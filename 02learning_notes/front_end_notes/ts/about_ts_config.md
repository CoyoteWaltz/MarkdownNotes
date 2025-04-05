## 阅读收录

[tsconfig cheat sheet](https://www.totaltypescript.com/tsconfig-cheat-sheet)

> `tsconfig.json` 真的是令人头大的配置，这篇文章给出了基础的 coding 所需配置和说明，不做翻译了，直接看吧

### [isolatedModules](https://www.typescriptlang.org/tsconfig#isolatedModules)

```json
  "compilerOptions": {
    ...
    "isolatedModules": true
  },
```

我们可以用 typescript 来转化出 js 代码，也可以用其他编译工具比如 babel/swc。但其他编译器只能每次处理单个文件，无法获取完整的类型系统，这个限制同样在开了 `isolateModules` 的情况下产生。

这样单文件编译的限制会造成 runtime 的错误，比如缺少对象，runtime 会直接报错。

`isolatedModules` 会让 TypeScript 警告，当写的代码不能在单文件编译过程中正常处理的情况下。

比如以下的情况

#### Exports of Non-Value Identifiers

导出非值的变量，比如 `export { SomeType }` 导出的是类型，单文件编译器是不知道类型的值，所以会有错误（为啥？）

所以推荐写 `export type { SomeType }`

#### 非 module 的文件

必须得含有 import/export

#### References to `const enum` members

如果是 `const enum`，会在编译过程中直接替换成它的具体值

```typescript
declare const enum Numbers {
  Zero = 0,
  One = 1,
}
console.log(Numbers.Zero + Numbers.One);
```

```js
"use strict";
console.log(0 + 1);
```

单文件编译器其实就不知道这个类型，其他文件如果引入了 `Numbers`，就会导致 runtime error。

**Because of this, when `isolatedModules` is set, it is an error to reference an ambient `const enum` member.** 下面是例子

```typescript
declare const enum A { // 一定得是 declare 的
  a,
  b,
  d,
}
console.log(A.a); // 会报错
```

因为既不是 `export` 出的类型，但是声明了 `declare` 意味这其他模块也可以直接饮用到这个变量，但是它的真实对象值不会在 runtime 存在，所以会报错。

#### Why isolateModules

为什么要有这样的 ts 警告？因为我们如果在写库的时候，以 bundleless esm 形式提供代码（也就是不完整打包到一个文件的形式，更利于 tree-shaking）

此时我们的代码会经过引入方重新编译，此时他们所选用的编译器是未知的，可能就是单文件编译的形式，所以开启 `isolateModules` 之后就能让 ts 在我们写库的时候就提示，保证输出代码的安全性。

### Project References

> [文档](https://www.typescriptlang.org/docs/handbook/project-references.html)
>
> TypeScript 3.0 that allow you to structure your TypeScript programs into smaller pieces.

拆分多个项目后（多个项目都包含 tsconfig.json），在 tsconfig.json，references 配置中可以配置多个其他项目的路径，path 指向包含 tsconfig.json 的目录或者直接指向 tsconfig 文件，`"path"` 可以是对于其他项目的名称，比如 `"apple" : "../packages/apple"`

```json
{
  "compilerOptions": {
    // The usual
  },
  "references": [{ "path": "../src" }]
}
```

这样之后，从 path 导入的项目就会直接用他的 `.d.ts` 类型文件了

说实话，文章后面一半没怎么看明白。

#### 在 Monorepo 中的应用

可以实现「源码跳转」，
