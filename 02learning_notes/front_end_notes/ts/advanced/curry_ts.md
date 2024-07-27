# Make A Fully Typed Curry Function

> Refs: https://medium.com/free-code-camp/typescript-curry-ramda-types-f747e99744ab
>
> TL;RD：本文是从 TS 角度，用体操构建出 curry function 的类型，包含完整的参数推导

## Curry Function

[关于函数 currify](../../js/currify)，在平时使用函数式编程都很熟悉了

## Utilities Types

### Head Utility

```typescript
type Head<T extends any[]> = T extends [any, ...any[]] ? T[0] : never;
```

### Tail Utility

和我们之前经常看到的要获取最后一个的 `Last` 不太一样（如下）

```typescript
type Last<T extends any[]> = T extends [...infer I, infer L] ? L : never;
```

这个 `Tail` 的作用是获取 Head 之后的剩余部分，和 Haskell 的 tail 方法一样

给出我的代码：

```typescript
type Tail<T extends any[]> = T extends [any, ...(infer R extends any[])] ? R : [];
```

文中代码：

```typescript
type Tail2<T extends any[]> = ((...t: T) => any) extends (
  _: any,
  ...tail: infer R
) => any
  ? R
  : [];
```

### HasTail Utility

检查是否含有 Tail 部分

```typescript
type HasTail<T extends any[]> = T extends [] | [any] ? false : true;
```

当然我们还得熟悉 TS 中的 `extends` `infer` `type` 等关键字的作用，这里不细说，文中有一些对于 `infer` 的练习

## Curry V0

热身结束，开始递归

```typescript
type CurryV0<P extends any[], R> = (
  arg0: Head<P>
) => HasTail<P> extends true ? CurryV0<Tail<P>, R> : R;

type c1 = CurryV0<[1, 2, 3, 4, 5], boolean>; // type c1 = (arg0: 1) => CurryV0<[2, 3, 4, 5], boolean>
```

测试下

```typescript
declare function curryV0<P extends any[], R>(
  f: (...args: P) => R
): CurryV0<P, R>;

const toCurry02 = (name: string, age: number, single: boolean) => true;

const curried02 = curryV0(toCurry02);

const test23 = curried02("Jane")(26)(true); // boolean
```

但是目前有个问题是，只能接受一个参数 `curried02('Jane')(26, true)` 会报错，需要追踪每一个函数参数是否被使用。

## Curry FInal

还需要工具 type 正是前文提到的 Last，文中的实现，略复杂：

```typescript
type Last<T extends any[]> = {
  0: Last<Tail<T>>;
  1: Head<T>;
}[HasTail<T> extends true ? 0 : 1];
```

length

```typescript
type Length<T extends any[]> = T["length"];
```

Prepend，将多个参数合并到一个数组？这样就能来追踪

```typescript
type Prepend<E, T extends any[]> = ((head: E, ...args: T) => any) extends (
  ...args: infer U
) => any
  ? U
  : T;
```

效果：

```typescript
type testP = Prepend<number, [1, 2]>; // [number, 1, 2]
```

drop，将一个 tuple 的前 N 个元素抛弃，得到后面的 tuple

```typescript
type Drop<N extends number, T extends any[], I extends any[] = []> = {
  O: Drop<N, Tail<T>, Prepend<any, I>>;
  1: T;
}[Length<I> extends N ? 1 : 0];

// 不过在 playground 的里面编译有问题，改写成如下
type Drop<N extends number, T extends any[], I extends any[] = []> = Length<
  I
> extends N
  ? T
  : Drop<N, Tail<T>, Prepend<any, I>>;
```

测试下：

```typescript
type dd = Drop<3, [1, 2, 3, 4, 5]>; // [4, 5]
```

这样我们就能把已经被消费的参数，从总体列表剔除。

还需要一些工具类型。。

包括高级特性 `placeholders` 的 ts 实现，酷，这个 gap 是直接用的 `ramda.R.__`

```typescript
f(1, 2, 3);
f(_, 2, 3)(1);
f(_, _, 3)(1)(2);
f(_, 2, _)(1, 3);
f(_, 2)(1)(3);
f(_, 2)(1, 3);
f(_, 2)(_, 3)(1);
```

```typescript
/* It requires TS to **re-check** a type `X` against a type `Y`, and type `Y` will only be enforced if it fails.
 * e.g. Cast<[string], any> // [string]
 * e.g. Cast<[string], number> // number
 **/
type Cast<X, Y> = X extends Y ? X : Y;
// position
type Pos<I extends any[]> = Length<I>;
// 下一个 postion 通过 加数组长度
type Next<I extends any[]> = Prepend<any, I>;
type Prev<I extends any[]> = Tail<I>;
// 构造出迭代器 Iterator<2> => [any, any], Iterator<2, Iterator<2>> => [any, any, any, any]
type Iterator<
  Index extends number = 0,
  From extends any[] = [],
  I extends any[] = []
> = {
  0: Iterator<Index, Next<From>, Next<I>>; // Next 来递增
  1: From;
}[Pos<I> extends Index ? 1 : 0];
//
type Reverse<T extends any[], R extends any[] = [], I extends any[] = []> = {
  0: Reverse<T, Prepend<T[Pos<I>], R>, Next<I>>;
  1: R;
}[Pos<I> extends Length<T> ? 1 : 0];
type Concat<T1 extends any[], T2 extends any[]> = Reverse<
  Reverse<T1> extends infer R ? Cast<R, any[]> : never,
  T2
>;
type Append<E, T extends any[]> = Concat<T, [E]>;
```

看不下去了。。直接出结论吧：最终 ramda.js 已经[支持了](https://github.com/DefinitelyTyped/DefinitelyTyped/pull/33628/files#diff-f9eb0b0185267ceabc80da1e8007d08de61b20466ed1c7c1705cb1ab965bc4e6)

包括 [ts-toolbelt](https://github.com/millsp/ts-toolbelt)（最大的 ts 工具库）也[支持](https://github.com/millsp/ts-toolbelt/blob/master/sources/Function/Curry.ts)

所以这个类型配合上代码的实现，就可以是完美了

有空再看看 ramda.js 这个[函数编程库](https://ramdajs.com/docs/#curry)吧！
