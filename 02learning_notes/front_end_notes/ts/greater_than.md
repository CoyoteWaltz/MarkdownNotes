# 比较任意数字大于

> 来自：[type-challenges](https://github.com/type-challenges/type-challenges/issues/21721)
>
> 背景是处理数字格式化函数的类型推导，需要单位推导，所以需要比较传入的数字和 base 的大小，给出正确的单位作为类型（见最后）
>
> 高级体操，一开始咱也看不懂，issue 中也有翻译成代码的版本（type zen）便于理解，最后有解析
>
> _问题来了，实现的是 `>`，那么 `>=` 怎么做呢？难道要把 [`Equal`](./equals) 那块代码抄过来吗。。。yes_

### 最终答案：看最后

### 看一下复杂的第二版

#### GreaterThanEqual

`1000 >= 1000` true!

```ts
type GE<T extends number, U extends number> = Equals<T, U> extends true
  ? true
  : GreaterThan<T, U>;
```

#### GreaterThan

```typescript

// compares the first digits of T and U. If they are the same - compare rest of T and rest of U
// prettier-ignore
type GreaterThanSameDigitCount<
  T extends number | string,
  U extends number | string
> = `${T}` extends `${infer TF}${infer TR}`
  ? `${U}` extends `${infer UF}${infer UR}`
    ? TF extends UF
      ? GreaterThanSameDigitCount<TR, UR>
      : "0123456789" extends `${string}${TF}${string}${UF}${string}`
        ? false
        : true
    : true
  : false;

type DigitsToArr<S extends string> = S extends `${string}${infer R}`
  ? [0, ...DigitsToArr<R>]
  : [];

type ArrLenCompare<
  T extends any[],
  U extends any[]
> = "0123456789" extends `${string}${T["length"]}${string}${U["length"]}${string}`
  ? -1
  : "0123456789" extends `${string}${U["length"]}${string}${T["length"]}${string}`
  ? 1
  : 0;

type GreaterThan<T extends number, U extends number> = ArrLenCompare<
  DigitsToArr<`${T}`>,
  DigitsToArr<`${U}`>
> extends 0
  ? GreaterThanSameDigitCount<T, U>
  : ArrLenCompare<DigitsToArr<`${T}`>, DigitsToArr<`${U}`>> extends 1
  ? true
  : false;

```

### 使用

格式化数字，返回 `[decimal, unit]`

```typescript
const base = 10000;

/**
 * getW(11000) -> ['1.1', '万']
 * getW(1100) -> ['1100', '']
 * getW(11000, ['', 'w']) -> ['1.1', 'w']
 */
export function getW<T extends number, S extends Readonly<[string, string]>>(
  initNum: T,
  suffix: S
): GreaterThan<T, typeof base> extends true
  ? [string, (typeof suffix)[1]]
  : [string, (typeof suffix)[0]] {
  const decimal = ...; // 伪实现 不重要
  const unit = initNum < base ? suffix[0] || "" : suffix[1] || "万";
  return [`${decimal}`, unit];
}

const re = getW(110000, ["", "万"] as const);
// re -> [string, "万"]
```

### 浅析

type-zen 这个工具有点东西，[翻译之后](https://type-zen-playground.vercel.app/?example=type-challenges-medium-52_greater-than)还是比较能看懂的

#### GreaterThan

**比较两个数的大小**

首先进入的是 `ArrLenCompare`，但他接受的是一个数组，通过 `DigitsToArr` 构造

#### DigitsToArr

代码如下：这个不需要翻译，很好看明白

将 "1345" 这样的数字字符串转换成 `[0, '1', '3', '4', '5']` 这样的数组

```typescript
type DigitsToArr<S extends string> = S extends `${string}${infer R}`
  ? [0, ...DigitsToArr<R>]
  : [];

```

然后回到 `ArrLenCompare`，看看是如何比较的

#### ArrLenCompare

这里先说结论，`ArrLenCompare` 比较的是两个数组的长度，也就是两个数的位数，T 数组长度大于 U 数组则返回 1，反之则 -1，**相等或者位数超过 9 则返回 0**

通过了一个比较骚/牛逼的方法，就是通过字符串的比较的推导，将两个数组的长度 TL 和 UL，分别按「先后」，「后先」的顺序组合成字符串，比如 TL = 3，UL = 4 → `"34"` `"43"`，最后再去和一个生序字符串 `"123456789"` 进行判断，得出哪个数组长度多，那么这个对应的数的位数就多，数就大！

```typescript
type ArrLenCompare<T: any[], U: any[]> = ^{
  type LC = '0123456789';
  type RC1 = `${string}${T['length']}${string}${U['length']}${string}`
  type RC2 = `${string}${U['length']}${string}${T['length']}${string}`

  if (LC == RC1) {
    return -1
  } else if (LC == RC2) {
    return 1
  }

  return 0
}
```

如果两个数位数一样，结果就是 0，会继续交给 `GreaterThanSameDigitCount` 进行比较

**_问题来了，这里的位数最大就到 9，其实也就限制了最大的数字范围_**

#### GreaterThanSameDigitCount

首先解决一下下面这行干了什么，其实得到的 TF 就是第一个（first），TR 是剩下的（rest）

```typescript
`${T}` extends `${infer TF}${infer TR}`
  ? `${U}` extends `${infer UF}${infer UR}`
```

于是整个类型就比较清晰了：

1. 在位数相同的前提下（不相同，仅从高位开始比较，则会又问题）
2. 取各自最高位，判断是否相同
   1. 相同则继续递归比较剩下的后 n 位
   2. 不相同则判断哪个大，还是通过两个前后顺序摆放后的比较
3. 最后递归结束条件是 T 和 U 都是 `""`，此时通过第一个 infer 之后 TF 和 TR 其实无法推出，所以直接到了 false 分支，结束

```typescript
type GreaterThanSameDigitCount<T: number | string, U: number | string> = ^{
  if (`${T}` == `${infer TF}${infer TR}`) {
    if (`${U}` == `${infer UF}${infer UR}`) {
      if (TF == UF) {
        return GreaterThanSameDigitCount<TR, UR>
      } else {
        type LC = '0123456789';
        type RC = `${string}${TF}${string}${UF}${string}`

        return LC == RC ? false : true
      }
    } else {
      return true
    }
  }

  return false
}
```

### 最后

还是挺牛逼的。。思路清奇！小于、小于等于就直接复用 GreaterThan 即可

琢磨了很久想突破位数 9 的限制，支持 string 的数字，还挺难的。。

**试了下第一个回答是可以的**也是非常简单的思路，牛逼。

- 直接通过 `&` 判断字符串是否相等了，不想等就是 `never`
- Res 作为第一位大小比较的变量做递归

```typescript
type GreaterThan<
  T extends number | string,
  U extends number | string,
  Res = false
> = `${T}` extends `${infer TF}${infer TR}`
  ? `${U}` extends `${infer UF}${infer UR}`
    ? [Res, TF & UF] extends [false, never] // Res == false and TF != UF
      ? GreaterThan<
          TR,
          UR,
          "0123456789" extends `${string}${TF}${string}${UF}${string}`
            ? false
            : true
        >
      : GreaterThan<TR, UR, Res>
    : true
  : U extends ""
  ? Res
  : false;

```
