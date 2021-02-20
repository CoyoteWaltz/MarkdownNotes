# Typescript Advance 4.1+

[toc]

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

更多详见：[PR](https://github.com/microsoft/TypeScript/pull/40336)

### Utility Types

#### Capitalize

`Capitalize<S extends string>`

限制 S type 的首字母大写

```typescript
let a: Capitalize<"xxxx"> = "Xxxx";
```
