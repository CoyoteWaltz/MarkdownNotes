# 收集一些有用/有趣的 types/体操

> 通常，体操只是图一乐，实战用不太到
>
> [TS Challenges](https://github.com/type-challenges/type-challenges)
>
> [ts-reset](https://github.com/total-typescript/ts-reset)
>
> > 对一些基础类型的更好扩展，类似 CSS Reset
>
> [ts-essentials](https://github.com/ts-essentials/ts-essentials)
>
> > 有用的工具类型，包括 [XOR](https://github.com/ts-essentials/ts-essentials/tree/master/lib/xor)

### 【进阶】类型安全的 Event Emitter

> 其实思路和实践过的 `open(url, data)` 的类似，根据不同 url，补充 data 的类型，这里的实现比较简单，因为限制了一定存在 Event，而 url 是不限制的

```TypeScript
interface EventDefinitions {
  // 通过将事件声明收敛到同一个 interface，能够防止事件名冲突
  I_AM_HUNGRY: [isReallyHungry: boolean];
}

declare function emit<T extends keyof EventDefinitions>(
  key: T,
  ...args: EventDefinitions[T]
): void;

declare function on<T extends keyof EventDefinitions>(
  key: T,
  handler: (...args: EventDefinitions[T]) => void
): void;

// 🎉 正确地报错，没有提供足够的参数
emit("I_AM_HUNGRY");

// 🎉 输入逗号时，自动补全提示第二个参数叫「isReallyHungry」且类型为 boolean
emit("I_AM_HUNGRY", true);

// 🎉 输入逗号时，自动补全提示函数接收一个名为「isReallyHungry」且类型为 boolean 的参数
on("I_AM_HUNGRY", (isReallyHungry) => {});

// 🎉 正确地报错，没有这样的事件名
on("I_AM_HUNGARY", () => {});

```

更好的，用上枚举和模块拓展

```typescript
// registry.ts
export const enum EventKeys {}
export interface EventDefinitions {}

// foo.ts，是 I_AM_HUNGRY 这个事件主要触发的地方，提供了事件的注册
declare module "./registry" {
  export const enum EventKeys {
    I_AM_HUNGRY,
  }

  export interface EventDefinitions {
    [EventKeys.I_AM_HUNGRY]: [isReallyHungry: boolean];
  }
}

emit(EventKeys.I_AM_HUNGRY, ...);
export {};

// bar.ts
import { EventKeys } from "./registry";
// 并不需要导入 `foo.ts`，TypeScript 知道 I_AM_HUNGRY 来自 `foo.ts`
on(EventKeys.I_AM_HUNGRY, (isReallyHungry) => {});
```

### 【进阶】类型安全的路由器

```typescript
type ResolveRouteParam<T extends string> =
  //                      👇 我们只判断了 number，你可以扩展其它类型！
  T extends `${infer P}@${infer _ extends "number"}` // 这是比较复杂的写法，可以改成 @number
    ? [P, number]
    : [T, unknown];

type ParseRouteString<
  T extends string,
  // 我们使用元组来承载解析出来的路由参数，当然它们还是通过联合类型去处理
  //（为了简单，这里没有考虑去重问题）
  Params extends [string, unknown] = never
> = T extends `${string}:${infer P}/${infer Rest}`
  ? ParseRouteString<Rest, Params | ResolveRouteParam<P>>
  : T extends `${string}:${infer P}`
    ? Params | ResolveRouteParam<P>
    : Params;


type MakeParamsType<
  T extends string,
  R extends [string, unknown] = ParseRouteString<T>
> = {
  // 👇 注意到 R[0] 返回 "userId" | "bookId"
  [K in R[0]]: R extends [K, infer U] ? U : never;
  //           👆 使用分配式条件类型找到 K 对应的元组的第二个元素，即它的路由参数类型
  // 分配式条件类型的计算过程（当 K 为 "bookId" 时）：
  //  1. ["userId", number] | ["bookId", number] extends ["bookId", infer U]...
  //  2. ["userId", number] extends ["bookId", infer U]... | ["bookId", number] extends ["bookId", infer U]...
  //  3. never | number
  //  4. number
} & {};

interface MyRequest<T> {
  params: T;
}


declare function get<T extends string>(
  route: T,
  handlerFn: (req: MyRequest<MakeParamsType<T>>) => void
): void;

get("/users/:userId@number/books/:bookId@number", (req) => {
  const { params } = req;
  //      ^? const params: { userId: number; bookId: number }
});

```

### 去除空格

```typescript
type RemoveSpaces<T extends string> =
  string extends T // 👈 通过这种方式判断它是否为 string 类型
    ? string
    : T extends `${infer Head}${infer Tail}`
      ? `${Head extends ' ' ? '' : Head}${RemoveSpaces<Tail>}`
      : '';
```

### 扩充 filter Boolean 的类型

使得经过 Boolean 过滤后的数组都保持非空元素

```typescript
type Truthy<T> = T extends false | 0 | "" | null | undefined | 0n ? never : T;

// 扩充 Array 方法
interface Array<T> {
  // 看到一个版本 对 BooleanConstructor 做扩充
  filter(predicate: BooleanConstructor, thisArg?: any): Truthy<T>[];
}

const arr = [1, 2, undefined].filter(Boolean); // number[]
```

用 ts-reset 可以直接使用

### XOR

即抄即用

```typescript
// => U without T, 把 T 独有的 key 都变成 never
export type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never };

// 最终生成的结果还是类似自动加 never
export type XOR<T, U> = T | U extends object
  ? (Without<T, U> & U) | (Without<U, T> & T)
  : T | U;
```

属性互斥的常见场景：其中有 a 和 b 字段是二选一的, foo 是可选的。自己也遇到过，挺棘手的。

解决方案

- 手工用 never 处理类型（也是自己用的方法，比较初级，也是核心逻辑）
- 函数重载
- 用体操自动加 never 字段

  - 可以实现 `JustOne<UserConfig, ['a', 'b','c']>`

- **XOR（体操，答案）**
  - 什么是 [XOR](https://en.wikipedia.org/wiki/Exclusive_or)，门电路中，两个输入**互不相同**，但**只要其中一个**有 1 则输出 1，其他输出 0
  - 在 TS 中的场景，比如 `XOR<{ a: boolean}, { b: boolean }>` 就是只能有 `a` 或者 `b` 其中一个给了值（有 1），没有给的情况就是输入 0，如果两个都输入了 1（都有值），就不符合类型
  - 在这个[回答](https://stackoverflow.com/questions/44425344/typescript-interface-with-xor-barstring-xor-cannumber)中也看到了这段代码

具体使用场景：

_拿 XOR 做例子_

```typescript
/**
 * 有 error 的时候 就是异常了 必然有 description 且 data 是 error 真实的值 可能是 字符串 or 对象
 * 没有 error (if (!error) 的 else 情况) data 就是 API 的类型
 */
export type SDKApiResponseWrapper<T> = XOR<
  {
    error: SDKApiErrResp;
    data: RawSDKApiErrResp;
  },
  {
    data?: T;
  }
>;
```

### Deep Partial

来自 stackoverflow 回答

```typescript
export type DeepPartial<T> = T extends Record<string, any>
  ? {
      [P in keyof T]?: DeepPartial<T[P]>;
    }
  : T;
Ï;
```

### Module Tools Types

声明为一个 `.d.ts` 文件，然后通过引用来使用它

`/// <reference types='xx/types' />`

```typescript
/// <reference types="node" />
/// <reference types="react" />
/// <reference types="react-dom" />
declare namespace NodeJS {
  interface ProcessEnv {
    readonly NODE_ENV: "development" | "production" | "test";
    readonly PUBLIC_URL: string;
  }
}

declare module "*.bmp" {
  const src: string;
  export default src;
}

declare module "*.gif" {
  const src: string;
  export default src;
}

declare module "*.jpg" {
  const src: string;
  export default src;
}

declare module "*.jpeg" {
  const src: string;
  export default src;
}

declare module "*.png" {
  const src: string;
  export default src;
}

declare module "*.ico" {
  const src: string;
  export default src;
}

declare module "*.webp" {
  const src: string;
  export default src;
}

declare module "*.svg" {
  export const ReactComponent: React.FunctionComponent<React.SVGProps<
    SVGSVGElement
  >>;

  const src: string;
  export default src;
}

declare module "*.bmp?inline" {
  const src: string;
  export default src;
}

declare module "*.gif?inline" {
  const src: string;
  export default src;
}

declare module "*.jpg?inline" {
  const src: string;
  export default src;
}

declare module "*.jpeg?inline" {
  const src: string;
  export default src;
}

declare module "*.png?inline" {
  const src: string;
  export default src;
}

declare module "*.ico?inline" {
  const src: string;
  export default src;
}

declare module "*.webp?inline" {
  const src: string;
  export default src;
}

declare module "*.svg?inline" {
  export const ReactComponent: React.FunctionComponent<React.SVGProps<
    SVGSVGElement
  >>;

  const src: string;
  export default src;
}

declare module "*.bmp?url" {
  const src: string;
  export default src;
}

declare module "*.gif?url" {
  const src: string;
  export default src;
}

declare module "*.jpg?url" {
  const src: string;
  export default src;
}

declare module "*.jpeg?url" {
  const src: string;
  export default src;
}

declare module "*.png?url" {
  const src: string;
  export default src;
}

declare module "*.ico?url" {
  const src: string;
  export default src;
}

declare module "*.webp?url" {
  const src: string;
  export default src;
}

declare module "*.svg?url" {
  export const ReactComponent: React.FunctionComponent<React.SVGProps<
    SVGSVGElement
  >>;

  const src: string;
  export default src;
}

declare module "*.css" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.scss" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.less" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.styl" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.sass" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.module.css" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.module.scss" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.module.less" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.module.styl" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.module.sass" {
  const classes: { readonly [key: string]: string };
  export default classes;
}

declare module "*.md" {
  const src: string;
  export default src;
}

declare module "*.hbs" {
  const src: string;
  export default src;
}

declare module "*.yaml" {
  const src: string;
  export default src;
}

declare module "*.toml" {
  const src: string;
  export default src;
}

declare module "*.xml" {
  const src: string;
  export default src;
}
```

### 推断 readonly [satisfies](./satisfies_operator)

> 告诉编译器是 const，告诉程序员是某个 type

```typescript
interface RouteItem { readonly path: string };
export const routes = [
    { path: '/abc/:bcd' }
] as const satisfies readonly RouteItem[];

type R = typeof routes;

let ee = routes[0].path // let ee: "/abc/:bcd"
```

另一个例子

```typescript
export enum FormType {
  LOGIN_PWD,
  LOGIN_SMS_CODE,
}
export interface PageConfig {
  routers: Readonly<FormType[]>;
  title: string;
  showBack?: boolean;
}

export const PageConfigMap = {
  [FormType.LOGIN_SMS_CODE]: {
    routers: [FormType.LOGIN_SMS_CODE, FormType.LOGIN_PWD] as const,
    title: '验证码登录',
    showBack: true,
  },
  [FormType.LOGIN_PWD]: {
    routers: [FormType.LOGIN_PWD] as const,
    title: '密码登录',
    showBack: true,
  },
} as const satisfies Record<FormType, PageConfig>;

const s = PageConfigMap[FormType.LOGIN_SCAN];
s.title;

```

### 去掉一个类型中的可选属性

```typescript
type RemoveOptional<T> = {
    [k in keyof T as T[k] extends Required<T>[k] ? k : never]: T[k]
}

interface A {
    value?: string;
    type: number;
}

type DA = RemoveOptional<A>; // { type: number }

```

### 一种 Map 方法

> 映射类型

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
