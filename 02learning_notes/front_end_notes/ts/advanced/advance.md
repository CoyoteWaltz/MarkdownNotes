# Typescript Advance

> 进阶技巧的收集，适合有一定 TS 代码经验
>
> 参考来源：
>
> - [You-Might-Not-Know-TypeScript](https://github.com/darkyzhou/You-Might-Not-Know-TypeScript)
> - [ts handbook](https://www.typescriptlang.org/docs/handbook/2/types-from-types.html)

## 确保两个数组长度相同

```typescript
// 当两个数组元素类型相同时，可以直接使用可变元组类型
declare function check<T extends unknown[]>
  (a: [...T], b: [...T]): void;

check([1], []);  // ERROR
check([], [1]);  // ERROR
check([1], [1]); // OK

// 当两个数组元素类型不同时，可以通过对返回值类型进行检查
declare function check2<T extends unknown[], U extends unknown[]>
  (a: [...T], b: [...U]): T['length'] extends U['length'] ? true : false;

check2([1], []) satisfies true;      // ERROR
check2([], [1]) satisfies true;      // ERROR
check2([1], ['foo']) satisfies true; // OK

// 对返回值类型进行检验不是解决问题的唯一的办法，我们还有：
type DoCheck<T extends unknown[], U extends unknown[]> =
  T['length'] extends U['length'] ? unknown : never;

// 考虑这样一个事实：unknown 是 top type（全集），所以其它类型对它取交都等于原类型
// 而 never 是 bottom type（空集），其它类型对它取交都等于 never
declare function check3<T extends unknown[], U extends unknown[]>
  (a: [...T] & DoCheck<T, U>, b: [...U] & DoCheck<T, U>): void;

check3([1], []);      // ERROR
check3([], [1]);      // ERROR
check3([1], ['foo']); // OK
```

## 匹配元组类型

使用 `[...T]` 可以提示 TypeScript 将 `T` 推导为元组类型而不是数组类型：

```typescript
declare function test<T extends unknown[]>(_: [...T]): T;

const _3 = test(["seele", 114, false]);
//    ^? const _3: [string, number, boolean]
```

## 定制错误信息

```typescript
declare const ERROR_SYMBOL: unique symbol;
type MyTypeError<T extends string> = { [ERROR_SYMBOL]: T };

type DoCheck<T> = "foo" extends keyof T
  ? unknown
  : MyTypeError<"对象没有包含必须的类型 foo 哦">;

// ...

function check<T extends Record<string, unknown>>(input: T & DoCheck<T>) {
  return input;
}

check({}); // ERROR
// Property '[ERROR_SYMBOL]' is missing in type '{}'
// but required in type 'MyTypeError<"对象没有包含必须的类型 foo 哦">'
check({ foo: true }); // OK
check({ foo: true, bar: false });
```

> 稍微看了一下，有人已经提了一个 [PR](https://github.com/microsoft/TypeScript/pull/40468)，实现方式是利用已有的 throw 关键字替代 never
>
> [playground](https://www.staging-typescript.org/play?ts=4.2.0-pr-40468-44#code/C4TwDgpgBAsgrgZ2AOTgWwEYQE4B4AqAfFALxT5QQAewEAdgCYJR3pbZQD85UAXFMAAW2APYB3KAAMAolUgBjWgwA0UDHGBQAZiLiMoAIgAkAb3zgI+EQGVg2AJZ0A5gUIBfA5IBQoSFACCpLCIKGw4uACMhD4WUABCQfBIqJjhvhAiWlBijgzihEA)
>
> 作者甚至持续维护了两年。可惜

## 检查一个类型仅含 key foo

```typescript
type DoCheck<T> = [keyof T] extends ["foo"]
  ? ["foo"] extends [keyof T]
    ? unknown
    : never
  : never;

function check<T extends Record<string, unknown>>(input: T & DoCheck<T>) {
  return input;
}

check({}); // ERROR
check({ foo: true }); // OK
check({ foo: true, bar: false }); // ERROR
```

## 非空数组

```typescript
declare const TYPE_TAG: unique symbol; // 2.7+
type NonEmptyArray<T> = readonly [T, ...T[]] & { [TYPE_TAG]: never };

// 给用户提供一个函数来进行检查和类型转换
function asNonEmptyArray<T>(array: readonly T[]): NonEmptyArray<T> {
  if (!array.length) {
    throw new Error(...);
  }

  return array as any;
}

declare function last<T>(array: NonEmptyArray<T>): T;

// 这样，用户在调用 last 函数之前就必须先确保自己的函数非空
const nonEmptyArray = asNonEmptyArray(myArray);
last(nonEmptyArray);

// 另一个选择：
// asNonEmptyArray<T>(array: readonly T[]): NonEmptyArray<T> | null
// 当输入的数组为空时返回 null，使用户强制检查这个 null 值的存在
```

为什么使用 `[T, ...T[]]` 而不是 `T[]`， tsconfig 中的 `noUncheckedIndexedAccess` 选项：

```typescript
// 当 noUncheckedIndexedAccess 打开时
declare const arr1: number[];
const _1 = arr1[0];
//    ^? const _1: number | undefined

declare const arr2: [number, ...number[]];
const _2 = arr2[0];
//    ^? const _2: number

// 由于我们的「非空数组」已经暗含了数组的第一位不可能为空
// 所以可以使用可变元组的方式让 TypeScript 相信数组的第一位不可能为 undefined
```

## 工具类型 Prettify

简而言之就是拍平对象结构

```typescript
export type Prettify<T> = {
  [K in keyof T]: Prettify<T[K]>;
} & {};
```

这里的核心是 `& {}`，哪里不能推导出结构，就在那一层加上

## [Immediately Indexed Mapped Type（IIMT）](https://www.totaltypescript.com/immediately-indexed-mapped-type)

也是一个比较常用的技巧，直接映射出对象类型

```typescript
type CSSUnits = "px" | "em" | "rem" | "vw" | "vh";

/**
 * | { length: number; unit: 'px'; }
 * | { length: number; unit: 'em'; }
 * | { length: number; unit: 'rem'; }
 * | { length: number; unit: 'vw'; }
 * | { length: number; unit: 'vh'; }
 */
export type CSSLength = {
  [U in CSSUnits]: {
    length: number;
    unit: U;
  };
}[CSSUnits];
```

```typescript
type Event =
  | {
      type: "click";
      x: number;
      y: number;
    }
  | {
      type: "hover";
      element: HTMLElement;
    };

// 对某个含有 type 属性的对象类型，将它的 type 属性加上一个字符串前缀
// 同时，其它属性保持不变
type PrefixType<E extends { type: string }> = {
  type: `PREFIX_${E["type"]}`;
} & Omit<E, "type">;

/**
 * | { type: 'PREFIX_click'; x: number; y: number; }
 * | { type: 'PREFIX_hover'; element: HTMLElement; }
 */
type Example = {
//               👇 使用了「映射类型中键的重映射」
  [E in Event as E["type"]]: PrefixType<E>;
}[Event["type"]];
```

## Exhaustive Guard

也是之前提到过 `switch case` 中检测所有 case 都处理的技巧

```typescript
function exhaustiveGuard(value: never): never {
  throw new Error(`Exhaustive guard failed with ${value}`);
}
```

**new：如果你不在乎运行时的兜底，可以使用 `satisfies` `4.9+` 来做到相同的事情。**

```typescript
enum MyType {
  Foo,
  Bar,
  EEE
}
declare const getSomeValue: () => MyType;
const val = getSomeValue();
switch (val) {
  case MyType.Foo:
    // 此时 someValue 的类型为 MyType.Foo
    break;
  case MyType.Bar:
    // 此时 someValue 的类型为 MyType.Bar
    break;
  default:
    val satisfies never; // 确实会报错
}
```

## 控制流中的类型具化 Discriminated Union Types

可以通过单独设置一个公共属性，比如 `type` 来进行类型具化

如果三个 `interface` 都含有不同的属性，那么我们通过 `in` 关键字就能够让 TypeScript 利用类型具化的机制进行区分。但是，实际情况中我们更多地会遇到一些**部分含有相同属性的类型**。

```typescript
function myFunction(value: Apple | Banana | Watermelon) {
  // 如何类型安全地区分 value 的不同的类型？
}
```

## 阻止联合类型的 Subtype Reduction

比较实用的小技巧，能提供更好的代码补全

比如如下遇到的场景，支持接受指定字符串和 `string` 全集

TypeScript 会将联合类型中的 `'foo'` 约去，因为这个字面量类型是它的子类型，而且它的值可以覆盖 `'foo'`。这个过程被称为 subtype reduction。

```typescript
declare function foo(input: "a" | "b" | string): void;
foo(""); // 什么提示都没有

declare function foo2(input: "aaa" | "bbb" | (string & {})): void;
foo2("bbb"); // 可以提示 'bbb'
```

## 阻止 Type Alias Preservation

[4.2 版本引入的 Smarter Type Alias Preservation 特性](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-2.html#smarter-type-alias-preservation)，TypeScript 不会展开这些联合类型。很难看出这个类型具体是哪些类型的联合。

```typescript
type Foo = 1 | 2 | 3;
type Bar = Foo | 4 | 5;
//   ^? type Bar = Foo | 4 | 5
type Bar2 = (Foo & {}) | 4 | 5;
//   ^? type Bar2 = 1 ｜ 2 ｜ 3 | 4 | 5
```

## unique symbol

```typescript
declare const TYPE_TAG: unique symbol; // 2.7+
// 通过 & 并入一个特殊属性来定义名义类型（一些人将这个过程称为 Tagging）
type PositiveValue = number & { [TYPE_TAG]: "_" };
```

关键字：`unique`，[2.7 加入的](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-2-7.html#unique-symbol)

`unique symbol` 是 `symbol` 的一个子类型

上面的例子使用 `unique symbol` 而不是字符串作为属性名不是必要的，不过推荐使用这种方法，因为 Lanuage Service 提供的**自动补全不会将这个属性考虑在内**，避免对用户造成不必要的干扰，同时也能避免用户无意中访问这个「假的属性」造成运行时错误，因为这个属性只是我们在类型里附加上去的。

附：一些 [well-unknown symbols](https://www.typescriptlang.org/docs/handbook/symbols.html#well-known-symbols)

### 添加元信息

[playground](https://www.typescriptlang.org/play?#code/CYUwxgNghgTiAEYD2A7AzgF3gFQJoAUBRAfWwEEBxALngFcUBLAR1oTQE8BbAIyQgG54AeiHwATADoA7AGoAUBnYAHBAGUMMBigDmASRQArcBmxIA1iBQAebAD54AXniZNO+ADJ4Ab3gBtPESklAC6NNjwAL78cnIi8IC58oBqsYAXNoCmioAhboC-ioAOpnKgkLAIAGb0YBgMqPBaRmU2tgAUGOaWNOqueobGphbWdgCUYfAAPvAotBACMXGAiEaAN3LpgBSugOxGgLDmgIVKgDEqgJ-agCl66Wk4zSh54NBwiNBoaPAAqmggMKoPAG4MYAg+UXLI6Fg3qoQAErEAGAgBqugAwoRHPAAOS0e6PF5vEBw+BQa5tLQdGomI5WO4PJ4wV7vWzRWKiZaAe+VAKdygCwEwDj8YB-eQWgE34wBUcvAmj14IB24MA6fqAbx9ANHqgAXjQBcnt9UJg6EiSWSEE5qsZ6v8gSCgRDoX1+EA)

```typescript
declare const TYPE_TAG: unique symbol; // 2.7+
type StringInjectToken<T> = string & { [TYPE_TAG]: T };

// 依赖注入的函数
declare function inject<T>(token: StringInjectToken<T>): T | null;

// 我们的用户服务和对应的注入 Token
declare class UserService {}
const USER_SERVICE = "userService" as StringInjectToken<UserService>;

// 用户可以通过使用这个 token 获得类型提示
const userService = inject(USER_SERVICE);
```

这里用了 `unique symbol` 取构造一个类型的元信息，实际上不作为一个属性存在对象上，但是可以通过类型获取到，仅供类型检查，妙啊

## 类型 `{}` 到底是什么？

[从 TypeScript 4.8 开始](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-8.html#improved-intersection-reduction-union-compatibility-and-narrowing)，`{}` 等价于「任何非 `null` 非 `undefined` 的类型」，并且有：`type NonNullable<T> = T extends null | undefined ? never : T` 等价于 `T & {}`。换句话说，`string`、`number`、`boolean` 等常见类型也能够被赋给 `{}`。

因此，`{}` 框定的值的范围实际上要大于「任何对象类型」。如果确实想表示对象类型，`Record<string, unknown>` 一般会是更好的选择。

## `string & K` 是什么意思？

对象的属性名的类型可能是 `string | number | symbol` 等，而我们在这里只关心那些类型为 `string` 的属性名。可以使用交叉类型（intersection types）来实现这个功能，具体的原理是：

- 当 `K` 满足 `string` 类型时，结果为 `K` 对应的字符串字面量类型
- 否则，结果为 `never`，映射类型会过滤掉类型为 `never` 的键

```typescript
type Fe<T> = string & T;

type Ef = Fe<"s">; // s
type Eff = Fe<1>; // never
```

## 枚举成员的透明性（opaque）

许多人可能遇到过这样的场景：

```TypeScript
enum MyEnum {
  Foo = 'foo', Bar = 'bar', Baz = 'baz'
}

declare function myFunction(value: MyEnum): void;

// 我们希望用户可以这样传参：
myFunction(MyEnum.Foo); // 编译通过

// 我们也希望用户不必导入 MyEnum 就能传参
myFunction('foo'); // 编译不通过 :(
```

我们很容易认为函数参数中的 `MyEnum` 类型就是它的成员值的联合类型，即 `'foo' | 'bar' | 'baz'`，因此也就觉得 `myFunction('foo')` 的用法是符合道理的。

然而，为什么 TypeScript 会报错呢？简单来说，[这是一个设计决策](https://github.com/microsoft/TypeScript/issues/17690#issuecomment-321319291)：TypeScript 的设计者希望枚举具备透明性（opaque），即枚举成员实际的值可以被修改却不会导致它的消费者出错，简单来说就是 TypeScript 不希望我们可以通过枚举的值去指代某个枚举成员，因为枚举的存在意义在于枚举成员的名字，而不是它的值

TypeScript 的这种「漏洞」其实是一个重要特性带来的副作用：数字枚举可以参与数学运算，就像下面的例子。

```TypeScript
const _1 = MyEnum.Foo | MyEnum.Bar; // OK
const _2 = MyEnum.Foo * 2; // OK
const _3 = MyEnum.Baz & 0; // OK
```

[从 5.0 开始，只有数字枚举成员对应的值的字面量才能被赋给枚举](https://github.com/microsoft/TypeScript/pull/51561#issue-1451913116)

## Some tricks

### 指定 this 的类型

在 call/apply 一个 class function 的时候，this 变了，但却没有被检查出来 this 指向的错误。可以在方法的 this 隐式形参加上类型限制。

```ts
class Dong {
  name: string;

  constructor() {
    this.name = "dong";
  }

  hello(this: Dong) {
    return "hello, I'm " + this.name;
  }
}
```

并且也有一个 utility type [`ThisParameterType`](https://www.typescriptlang.org/docs/handbook/utility-types.html#thisparametertypetype) 来提取一个函数所接受的 this 的类型

实现也非常简单：尝试匹配函数的类型中有没有显示定义 this 的类型，匹配出来就是 U，否则为 `unknown`

```ts
type ThisParameterType<T> = T extends (this: infer U, ...args: any[]) => any
  ? U
  : unknown;
```

### `-` 去掉已有的修饰

比如

```ts
type ToMutable<T> = { -readonly [Key in keyof T]: T[Key] };
```

## Utility Types

### NonNullable 过滤空类型

将一些包含 `null` `undefined` 的 union type 转化成不含这两个的 union。

```typescript
type ss = "egg" | "flat" | "internet" | undefined | null;
type n = NonNullable<ss>; // 'egg' | 'flat' | 'internet'
```

### Parameters 取函数的参数类型

```typescript
declare function f1(arg: { a: number; b: string }): void;

type T0 = Parameters<() => string>;

type T0 = [];
type T1 = Parameters<(s: string) => void>;

type T1 = [s: string];
type T2 = Parameters<<T>(arg: T) => T>;

type T2 = [arg: unknown];
type T3 = Parameters<typeof f1>;

type T3 = [
  arg: {
    a: number;
    b: string;
  }
];
```

### Capitalize

`Capitalize<S extends string>`

限制 S type 的首字母大写

```typescript
let a: Capitalize<"xxxx"> = "Xxxx";
```

同样还有将 string type 进行大小写转换等

```typescript
Uppercase<StringType>
Lowercase<StringType>
Capitalize<StringType>
Uncapitalize<StringType>
```

## TS 4.1 的一些新东西

> Ts 4.1 RC 了，抓紧来看看有什么新的内容吧
>
> 来自：https://www.infoq.cn/article/kHLmigWZ3fCyEdLQcvkD

### 安装

`npm install typescript@rc`

或者直接安装 latest，现在都 4.1.2 了

### 踩坑

#### vscode 报错

> 仅是编辑器的语法报错

大家都知道 vscode 对 ts 的支持简直是亲生的一样，但是当我们在一个 workspace 安装了最新版本的 ts，那么需要找到右下角 typescript 旁边的版本，可以看到 vscode 内置的 ts 版本可能没那么高，选择 workspace 的就好，或者全局升级到最新。

### 模版字面量（Template Literal）类型

回顾：字面量类型，也就是这个类型他的值就是这几个具体的字面量的值

```typescript
type Direction = "left" | "right" | "up" | "down";
```

**模版字面量类型**就是使用模版字符串，让字面量类型的具体值在模版中生成新的字面量类型

```typescript
type World = "world";

type Greeting = `hello ${World}`;
// same as
//   type Greeting = "hello world";
```

在很多时候自动生成一组 gird 数据就很好用，不需要一个个枚举

```typescript
type VerticalAlignment = "top" | "middle" | "bottom";
type HorizontalAlignment = "left" | "center" | "right";

declare function setAlignment(
  params: `${VerticalAlignment}-${HorizontalAlignment}`
): void;

setAlignment("top-left");
// setAlignment("top-top"); 报错
```

在看一个来自马进大佬的例子

```typescript
type Whitespace = " " | "\n" | "\r" | "\t";

type TrimStart<
  S extends string,
  P extends string = Whitespace
> = S extends `${P}${infer R}` ? TrimStart<R, P> : S;

type answerStartsWithSpace = "  yes" | " no" | "     ok";
let answer: TrimStart<answerStartsWithSpace> = "ok"
```

这里的 `TrimStart` 是一个泛型，将接受的类型，字符串的前缀给 trim 掉，注意这个类型判断其实是一个递归的，`infer R` 判断成功 S 所属的类型，也就是以类型 P 开头的值，如果不是，这个类型就是 S 类型，如果是，那就继续递归判断剩余部分 R，太妙了！

再看一个例子吧

```typescript
function makeWatchedObject<T>(obj: T): T & PropEventSource<T> {
  return {
    ...obj,
    on(eventName: `${string & keyof T}Changed`, callback: () => void): void {
      // let a: string = eventName.replace("Changed", "");
      console.log(`on ${eventName}`);
      // usually will add callback to a cache cbs queue
      callback();
    },
  };
}

let person = makeWatchedObject({
  firstName: "Homer",
  age: 42, // give-or-take
  location: "Springfield",
});

type PropEventSource<T> = {
  on(eventName: `${string & keyof T}Changed`, callback: () => void): void;
};

person.on("ageChanged", () => {
  console.log(person.firstName);
});
```

我们也可以，通过泛型，让 callback 的参数能正确推断出类型，酷啊

```typescript
type PropEventSource<T> = {
  on<K extends string & keyof T>(
    eventName: `${K}Changed`,
    callback: (newValue: T[K] | undefined) => void
  ): void;
};
// newAge 能自动推断出是 number 很酷
person.on("ageChanged", (newAge) => {
  if (newAge < 100) {
    console.log("newAge", newAge);
  }
});
```

也可以继续玩泛型

```typescript
type hello = Uppercase<"yes" | "ok">;
type HELLO<T extends string> = `${Uppercase<T>}!!!`;

let aa: HELLO<hello> = "YES!!!"
```

### 映射类型 & key 重映射

先说说映射类型

```typescript
type Options = {
  [K in "yes" | "ok" | "yesOk"]?: boolean;
};
// 相当于
// type Options = {
//   yes?: boolean;
//   ok?: boolean;
//   yesOk?: boolean;
// }
let options: Options = {
  ok: true,
};
```

可以快捷的创建一些类型

在 4.1 中，可以用 as 子句重新映射到不同类型的 key，结合模版类型，分分钟变形金刚

```typescript
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];  // 保持原有属性类型
};

interface Person {
  name: string;
  age: number;
  location: string;
}

type LazyPerson = Getters<Person>;
// type LazyPerson = {
//   getName: () => string;
//   getAge: () => number;
//   getLocation: () => string;
// }
```

```typescript
type RemoveNameField<T> = {
  [K in keyof T as Exclude<K, "name">]: T[K];
};

interface Cat {
  name: string;
  color: string;
}

type AnonymousCat = RemoveNameField<Cat>;
```

其实这个特性就是将 keyof 遍历出的类型映射到新的（自定义）类型

也可以 as 到一个常量上，可以做到将多个字段的 value 类型 union 到一个 key 上

```typescript
type All<T> = {
  [k in keyof T as 'prop']: T[k];
}['prop'];
```

更多详见：[PR](https://github.com/microsoft/TypeScript/pull/40336)

## Type language programming

> 参考文章：https://www.zhenghao.io/posts/type-programming
>
> 文中以 TS 作为一门类型语言来看（图灵完备），也具编程语言的有很多特性，可以利用这些来更好的在日常开发中写类型，让 web app 变得更加 type safe and dependable

### 变量定义

`type` 或者 `interface` 声明的字面量其实是 type synonym or type alias（个人感觉是因为 duck inference 的原因）

local 变量可以通过 `infer` 来声明

```typescript
type ConvertFooToBar<G> = G extends "foo" ? "bar" : never;
type ConvertBarToBaz<G> = G extends "bar" ? "baz" : never;

// infer defines the local variable Bar := ConvertFooToBar<T>
type ConvertFooToBaz<T> = ConvertFooToBar<T> extends infer Bar
  ? Bar extends "bar"
    ? ConvertBarToBaz<Bar>
    : never
  : never;
```

### 等价判断

`extends`

### 获取类型的 props 的类型

```typescript
type Names = string[];
type Name = Names[number];

type Tuple = [string, number];
type Age = Tuple[1];

type User = { name: string; age: number };
type Name = User["name"];
```

### 函数

解释下不是函数类型，而是把一个 type 映射成另一个 type 的 type（map）

那就是用泛型了

#### Map 和 filter

文中举的例子很不错，JS 中将一个对象的所有 key 都转成 string（用到了 `Object.fromEntries`）

```typescript
const user = {
  name: "foo",
  age: 28,
};

function stringifyProp(object) {
  return Object.fromEntries(
    Object.entries(object).map(([key, value]) => [key, String(value)])
  );
}

const userWithStringProps = stringifyProp(user); // {name:'foo', age: '28'}
```

TS 中就是用 `[K in keyof T]` 来进行遍历

```typescript
type User = {
  name: string;
  age: number;
};

type StringifyProp<T> = {
  [K in keyof T]: string;
};

type UserWithStringProps = StringifyProp<User>; // { name: string; age: string; }
```

同样也能进行判断，用 `as` 作为断言，个人理解这里相当于是 python 中 `x if x == y else z`

```typescript
type FilterStringProp<T> = {
    [K in keyof T as T[K] extends string ? K : never]: string
}
```

### Pattern matching

用 `infer` 作为模式匹配，很高级

```typescript
type Str = 'foo-bar';
// infer use as the pattern matcher
type Bar = Str extends `foo-${infer rest}` ? `${rest}--Bar` : never; // 'bar--Bar'

```

### 递归代替循环

举个例子，填充数组的方法，可以通过递归来实现数组扩充，递归结束条件就是数量达到长度

```typescript
// recursive function in JS
const fillArray = <T>(item: T, num: number, arr: T[] = []) => {
  return arr.length === num ? arr : fillArray(item, num, [...arr, item]);
};

type FillArray<
  Item,
  N extends number,
  Array extends Item[] = []
> = Array["length"] extends N ? Array : FillArray<Item, N, [...Array, Item]>;

type Foos = FillArray<"foo", 3>; // ["foo", "foo", "foo"]
```

#### Limits for recursion depth

Before TypeScript 4.5, the max recursion depth is [45](https://www.typescriptlang.org/play?ts=4.4.4&ssl=3&ssc=10&pln=3&pc=17#code/C4TwDgpgBAShkENgDkA8BJYEC2AaKyUEAHlgHYAmAzlGQK7YBGEATvgCp1gA20J51KAjIgA2gF0oAXigSAfNKiceEUQHJeZAObAAFmsn8IlGoQD8SrrygAuWPAhI0mHPmT5RAOm-Le+F9jicgDcAFCgkFAAQopwiCioagCMavgALACsCuHg0ACCsQ5OiSnpAGwKAPSVUFTACADGANZQAPYAbqwAZtytAO5AA). In TypeScript 4.5, we have tail call optimization, and the limit increased to [999](https://www.typescriptlang.org/play?ts=4.5.4#code/C4TwDgpgBAShkENgDkA8BJYEC2AaKyUEAHlgHYAmAzlGQK7YBGEATvgCp1gA20J51KAjIgA2gF0oAXigSAfNKiceEUQHJeZAObAAFmsn8IlGoQD8SrrygAuWPAhI0mHPmT5RAOm-Le+F9jicgDcAFChoJBQAIKKcIgoqGoAjGr4AJyZchHg0ABCcQ5OSan4yQAMlQoA9NVQVMAIAMYA1lAA9gBurABm3O0A7qFAA).

### Avoid type gymnastics in production code

不要在生产环境中玩 ts 体操，看了一些体操，真的挺有意思

1. [simulating a Chinese chess (象棋)](https://github.com/chinese-chess-everywhere/type-chess)
2. [simulating a Tic Tac Toe game](https://blog.joshuakgoldberg.com/type-system-game-engines/)
3. [implementing arithmetic](https://itnext.io/implementing-arithmetic-within-typescripts-type-system-a1ef140a6f6f)
