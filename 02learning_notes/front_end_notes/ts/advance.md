# Typescript Advance

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
