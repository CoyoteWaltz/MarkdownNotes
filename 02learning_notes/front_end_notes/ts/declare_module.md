# declare module 有什么用

> 参考：[官方指南](https://www.typescriptlang.org/docs/handbook/modules.html#ambient-modules)

## previously

首先我们得知道 TS 也是完全按照 ES Module 的，如果一个文件里有顶层的 `import` or `export` 那就是一个模块，如果都没有，那么他就当成一个 script 里面的内容**可以被全局使用**。

再来看看 `.d.ts` 是干什么的？如果一个库并不是 TS 来写的，我们需要类型的时候，需要暴露这个库的 API 类型，可以为这个库（模块）写一个 `.d.ts` 的文件（类似 C++/C 的 `.h` 文件），通常一些库会另起一个 `@types/xxx` 的 npm 包来做。当然，不仅是非 TS 的库可以这么做，也适用于任何需要给模块定义类型的时候。

上面这种说的没有具体实现的声明，可以叫做 **`ambient`**

## Ambient Modules

在[官方指南](https://www.typescriptlang.org/docs/handbook/modules.html#ambient-modules)中说到，如果需要声明一个 ambient module，我们可以在每个 module 的 `.d.ts` 里面写类型，但也可以全部写到一个大的 `.d.ts`，更加方便。

可以在这个声明文件中声明不同 module（起到 namespace 的作用）

```typescript
// test.d.ts
declare module "url" {
  export interface Url {
    protocol?: string;
    hostname?: string;
    pathname?: string;
  }
  export function parse(
    urlStr: string,
    parseQueryString?,
    slashesDenoteHost?
  ): Url;
}
declare module "path" {
  export function normalize(p: string): string;
  export function join(...paths: any[]): string;
  export var sep: string;
}
```

import

```typescript
/// <reference path="test.d.ts"/>
import * as URL from "url";
let myUrl = URL.parse("https://www.typescriptlang.org");
```

_P.S. reference 那行是干嘛的？稍后再说_

### Shorthand ambient modules

也可以简写 `declare module "xxx"`，所有从 `xxx` module 导出的变量都将会是 `any`

### Wildcard module declarations

可以用通配符来声明模块，最常见的就是如果我们要用图片等静态资源作为模块在我们的代码中使用，并且不报错。

```typescript
// assert.d.ts
declare module "*.png";
declare module "*.jpg";
declare module "*.jpeg";
declare module "*.gif";
declare module "*.webp";
declare module "*.ttf";
declare module "*.woff";
declare module "*.woff2";
declare module "*.scss";
declare module "*.svg";
```

官方的例子

```typescript
declare module "*!text" {
  const content: string;
  export default content;
}
// Some do it the other way around.
declare module "json!*" {
  const value: any;
  export default value;
}
```

```typescript
import fileContent from "./xyz.txt!text";
import data from "json!http://example.com/data.json";
console.log(data, fileContent);
```

## 神奇的用法

其实想了解 `declare module` 是看到公司代码里在用，现在发现居然能够在不同地方声明某处 module 内的原始定义，并且不断扩充（merge）类型。

比如在一个文件 `xx/index.ts` 中声明了 `export interface Boo {}` 类型，作为 base。

在需要扩展他的地方

```typescript
// a.ts
declare module "xx/index" {
  interface Boo {
    a: string;
  }
}
// b.ts
declare module "xx/index" {
  interface Boo {
    b: number;
  }
}
```

最终 `Boo` 类型就被这样扩充了，很好玩

```typescript
import { Boo } from "xx/index";
// let b: Boo;
```

其实这个也是因为多处同名的 `interface` 在声明 module 之后会提升到全局，是会合并属性，最终合成一个 `interface`
