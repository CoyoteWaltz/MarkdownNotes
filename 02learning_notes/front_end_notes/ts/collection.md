# 收集一些有用/有趣的 types/体操

> 通常，体操只是图一乐，实战用不太到

### 一种 Map 方法

将一个对象类型的属性 map 成标准格式

```typescript
type Field<Form = Record<string, unknown>> = {
  [K in keyof Form]: {
    field: K;
    value: Form[K];
  };
}[keyof Form];

interface Form {
  name: string;
  age: number;
}
const fieldA: Field<Form> = {
  field: "name",
  value: " ", // must be string since Form['name'] is string
};
const fieldB: Field<Form> = {
  field: "age",
  value: 123, // must be number since Form['age'] is number
};

const wrong: Field<Form> = {
  field: "age",
  value: "sdfs",
};
```

### 加减乘除

获得数字，通过元组

```typescript
type TupleA = [0, 0];
type TupleB = [0, 0, 0, 0];

type TupleALength = TupleA["length"]; // 2
type TupleBLength = TupleB["length"]; // 4

type TupleC = [...TupleA, ...TupleB];
type TupleCLength = TupleC["length"]; // 6
```

如果可以构造任意长度的元组，得到任意的数字

- 通过递归，给数组塞元素，直到满足长度

这样以来 加法就有了

#### 加法

```typescript
type _NArray<N, T extends unknown[]> = T["length"] extends N
  ? T
  : _NArray<N, [unknown, ...T]>;
type NArray<N> = N extends number ? _NArray<N, []> : never;

type Add<A extends number, B extends number> = [
  ...NArray<A>,
  ...NArray<B>
]["length"];

type ResultA = Add<1, 1>; // 2
```

#### 减法

```typescript
// 减法 通过推导出满足答案的长度的元组
type Subtract<A extends number, B extends number> = NArray<A> extends [
  ...head: NArray<B>,
  ...rest: infer R
]
  ? R["length"]
  : -1;

type TestSubtract = Subtract<5, 2>; // 5 - 2 = 3
```

#### 乘法

```typescript
// 乘法，需要依赖减法
type _Multiply<
  A extends number,
  B extends number,
  R extends unknown[]
> = B extends 0
  ? R["length"]
  : _Multiply<A, Subtract<B, 1>, [...NArray<A>, ...R]>;

type Multiply<A extends number, B extends number> = _Multiply<A, B, []>;

type TestMultiply = Multiply<4, 5>; // 4 * 5 = 20
```

#### 除法

```typescript
// 除法，需要依赖减法
type _DividedBy<
  A extends number,
  B extends number,
  R extends unknown[]
> = A extends 0
  ? R["length"]
  : Subtract<A, B> extends -1
  ? unknown
  : _DividedBy<Subtract<A, B>, B, [unknown, ...R]>;

type DividedBy<A extends number, B extends number> = B extends 0
  ? unknown
  : _DividedBy<A, B, []>;

type TestDivideBy = DividedBy<18, 6>; // 18 / 6 = 3
```

### Fibonacci

> 走楼梯问题，N 阶台阶，每次只能走 1 or 2 个
>
> 对于 N 阶，有几种走法？

```typescript
type _NArray<N, T extends unknown[]> = T["length"] extends N
  ? T
  : _NArray<N, [unknown, ...T]>;
type NArray<N> = N extends number ? _NArray<N, []> : never;

type Add<M extends number, N extends number> = [
  ...NArray<M>,
  ...NArray<N>
]["length"];

type Subtract<M extends number, N extends number> = NArray<M> extends [
  ...x: NArray<N>,
  ...rest: infer R
]
  ? R["length"]
  : 0;

type Fibonacci<N extends number> = N extends number
  ? Subtract<N, 2> extends 0
    ? N
    : Add<Fibonacci<Subtract<N, 1>>, Fibonacci<Subtract<N, 2>>>
  : never;

type Result = Fibonacci<5>; // 8  [1, 2, 3, 5, 8]
```

### Array join

```typescript
type ArrayStructure<Head extends string, Tail extends string[]> = [Head, ...Tail];

type Join<T extends string[], S extends string, Result extends string = ''> =
  T extends [] ? Result :
  T extends ArrayStructure<infer Node, []> ? `${Result}${Node}` :
  T extends ArrayStructure<infer Head, infer Tail> ? `${Head}${S}${Join<Tail, S, Result>}` : never;

type Res = Join<['1', '2', '3'], ','>;
```

### 部分属性 partial/required

> 参考：https://stackoverflow.com/questions/53741993/typescript-partially-partial-type

挑选对象中某几个 key 变成 partial or required

```typescript
type PickPartial<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>> &
  Partial<Pick<T, K>>;

type PickRequired<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>> &
  Required<Pick<T, K>>;
```

### setTimeout 的返回值类型？

我遇到了在这篇 [stackoverflow](https://stackoverflow.com/questions/51040703/what-return-type-should-be-used-for-settimeout-in-typescript) 上同样的问题

```TypeScript
const timer: ReturnType<typeof setTimeout> = setTimeout(() => '', 1000);
```

### 改字段的类型

```typescript
type ModifyPropType<Base, Props extends keyof Base, NewType> = Omit<Base, Props> & {
    [k in Props]: NewType;
};

type demo = ModifyPropType<{
	id: number
}, 'id', string>,
```

### 封装条件守卫，便于后续不必要的断言

```TypeScript
function IsString (input: any): input is string {
    return typeof input === 'string';
}

function foo (input: string | number) {
     if (IsString(input)) {
        input.toString() //被判断为string
     } else {
     }
}
```

### 数组长度生成 union type

_想用数组的 length 生成一个 union type，比如 length = 4 -> type N = 0 | 1 | 2 | 3，这样有可能吗？_

来自 nihouze 大佬的第一版

```TypeScript
type StrIndex<T extends readonly any[]> = Exclude<keyof T, keyof any[]>; // 数组下标的 union string 类型 [1, 2, 3] -> '0' | '1' | '2'
```

第二版

```TypeScript
// 利用递归 数组长度减少来实现 ts 4.1 above

type Tail<T> = T extends [any, ...infer R] ? R : never;

type Length<T extends any[]> = T["length"];

type Cool<Arr extends any[]> = Tail<Arr> extends never

  ? []

  : [Length<Tail<Arr>>, ...Cool<Tail<Arr>>];

type Fin<T extends any[]> = Cool<T>[number];

type D = Fin<[4, 5, 6]>; // 0 | 1 | 2
```

太妙了！！大佬牛逼！
