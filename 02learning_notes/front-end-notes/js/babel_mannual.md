# Babel 7.x

[toc]

## 前言

babel 是什么？[官网](https://babeljs.io/docs/en/)

Babel 是一个 JS 代码编译器（编译成浏览器看得懂的 JS 代码，并不是机器码哈）

> Babel is a compiler (source code => output code). Like many other compilers it runs in 3 stages: parsing, transforming, and printing.

是能够将 ES 2015 之后的代码转换成当前浏览器以及旧版浏览器能运行的代码的一个**工具链**，主要我们用来：

- 转换语法
- 给旧浏览器增加 polyfill（@babel/polyfill）
- 源码转换

一句话：代码解析 -> 转换 -> 生成

## Babel 初见面

_熟悉 Babel 的可以跳过直接看 API_

Babel 的功能被拆分成每个模块，也是独立的 npm 包，可以模块化的使用，我们先大致看一下 babel 的结构，方便后面快速上手

要使用 babel 我们需要安装

```bash
npm install --save-dev @babel/core @babel/cli @babel/preset-env
npm install --save @babel/polyfill
```

这么多东西，一个个看一下

首先是核心库`@babel/core`，提供核心的转换代码的能力，我们可以将其他工具作为他的接口来完成很多功能，transform 方法在这个包里

`@babel/cli`命令行工具可以让我们在命令行完成对文件的转换

```bash
npx babel src --out-dir lib  # 将 src 路径的文件都编译到 lib 路径
```

当然，这个 cli 是依赖`@babel/core`的，所以推荐安装在本地，而不要全局安装，同时不同项目依赖的版本也都会不一样，下面是官方的原因

> There are two primary reasons for this.
>
> 1.  Different projects on the same machine can depend on different versions of Babel allowing you to update them individually.
> 2.  Not having an implicit dependency on the environment you are working in makes your project far more portable and easier to setup.

由于核心`@babel/core`只提供了转换代码的能力，具体如何转换是需要插件来实现的，也就是各种`@babel/plugin-transform-xxxxx`包，比如箭头函数我们需要安装

```bash
npm install --save-dev
npx babel src --out-dir lib --plugins=@babel/plugin-transform-arrow-functions
```

我们可以试一下写一个箭头函数的文件

```js
const a = () => {
  console.log(123123);
};
```

然后`npx babel src --out-dir lib`，发现编译后的文件毫无变化

再次`npx babel src --out-dir lib --plugins=@babel/plugin-transform-arrow-functions`，成功被转成普通函数了

```js
const a = function () {
  console.log(123123);
};
```

但是，这个`const`还是 ES6 的呢！怎么办，我们是不是还需要一个`@babel/plugin-transform-block-scoping`，可以去**https://babeljs.io/docs/en/plugins**一个个找，那太麻烦了呀，这时候我们就需要用到`@babel/preset-xxx`了！

preset 预设，这是一套预定好的插件配置，只要安装`npm install --save-dev @babel/preset-env`，在编译的时候

```bash
npx babel src --out-dir lib --presets=@babel/env
```

这样我们就引入了所有 ES2015，ES2016 等等语法转换的插件了，因为`env`

> Without any configuration options, babel-preset-env behaves exactly the same as babel-preset-latest (or babel-preset-es2015, babel-preset-es2016, and babel-preset-es2017 together).

```js
"use strict";

var a = function a() {
  console.log(123123);
};
```

还有其他的预设，来编译不同场景下的代码，我们后面详细看看

- [@babel/preset-env](https://babeljs.io/docs/en/babel-preset-env)
- [@babel/preset-flow](https://babeljs.io/docs/en/babel-preset-flow)
- [@babel/preset-react](https://babeljs.io/docs/en/babel-preset-react)
- [@babel/preset-typescript](https://babeljs.io/docs/en/babel-preset-typescript)

到目前为止我们就大致的可以用 babel 来转换代码了，但是命令行的形式着实有点不舒服，我们可以用配置化来更好的食用！

和`.eslintrc`还有`.prettierrc`一样都可以配置！babel 可以有好几种选择

- `babel.config.json`
- `.babelrc.json`
- `package.json`
- `.babelrc`

比如我们在`babel.config.json`中配置预设

```json
{
  "presets": [
    [
      "@babel/preset-env",
      {
        "targets": {
          "edge": "17",
          "firefox": "60",
          "chrome": "67",
          "safari": "11.1"
        }
      }
    ]
  ]
}
```

也可以增加指定插件

```json
{
  "plugins": ["@babel/plugin-proposal-optional-chaining"]
}
```

这个插件是可选链（ES2021）的。

我们还可以看到在 preset 的内部还有

```json
{
  "targets": {
    "edge": "17",
    "firefox": "60",
    "chrome": "67",
    "safari": "11.1"
  }
}
```

这个`targets`实际上是针对` @babel/preset-env`提供的参数，指定了目标环境，这些都是浏览器版本（因为有些低版本的浏览器很多语法不支持），babel 在编译的时候会根据需求来转换，我们也可以指定 node 环境等。

```json
{
  "targets": {
    "node": 4
  }
}
```

如果指定 node 版本 12 的话，编译出来的还是有`const`和箭头函数的！

另外我们在看一下前面安装在本地的`@babel/polyfill`，不在 dev 环境哦

我们为什么需要垫片来解决特性的兼容呢

引用别人的一段理解：解释的很好

> babel 编译过程处理第一种情况：统一语法的形态，通常是高版本语法编译成低版本的，比如 ES6 语法编译成 ES5 或 ES3。
>
> 而 babel-polyfill 处理第二种情况：让目标浏览器支持所有特性，不管它是全局的，还是原型的，或是其它。**这样，通过 babel-polyfill，不同浏览器在特性支持上就站到同一起跑线。**

因为有些浏览器不支持某些特性！babel 只是将高版本的语法转换成低版本，而无法避免一些浏览器连低版本的特性也不支持，比如`Array.prototype.includes`、`Promise`，有了 polyfill 之后。

我们为什么要用`--save`安装呢

> Note the `--save` option instead of `--save-dev` as this is a polyfill that needs to run before your source code.

我们可以在编译之后的代码中手动加入

```js
require("@babel/polyfill"); // 让模块运行
```

同时在`preset`配置的时候可以增加一个`useBuiltIns`属性，让 polyfill 按需导入

```js
{
  "presets": [
    [
      "@babel/env",
      {
        "targets": {
          "edge": "17",
          "firefox": "60",
          "chrome": "67",
          "safari": "11.1",
        },
        "useBuiltIns": "usage",
      }
    ]
  ]
}
```

当然如果要导入指定的垫片，就用[core-js](https://github.com/zloirock/core-js)

再介绍完以上的 babel 模块之后我们还剩最后两个包给大家介绍一下，分别是：

- @babel/runtime
- @babel/plugin-transform-runtime

`@babel/runtime`的作用是提供统一的模块化的 helper（模块化 -> 复用）

那什么是 helper，我们举个例子：我们编译有 `class`语法的代码里面有不少新增加的函数，如`_classCallCheck`，`_defineProperties`，`_createClass`，这种函数就是 helper，用来实现新特性的。

那这种 helper 跟我们的`@babel/runtime`有什么关系了，我们接着看，比如像这个`_createClass`就是我们将 es6 的 class 关键字转化成传统 js 时生成的一个函数，那么如果我有很多个 js 文件中都定义了 class 类，那么在编译转化时就会产生大量相同的`_createClass`方法，那这些`_createClass`这样的 helper 方法是不是冗余太多，因为它们基本都是一样的，所以我们能不能采用一个统一的方式提供这种 helper，也就是利用 es 或者 node 的模块化的方式提供 helper，将这些 helper 做成一个模块来引入到代码中，岂不是可以减少这些 helper 函数的重复书写。

`@babel/plugin-transform-runtime`是配合`@babel/runtime`使用的，它会帮我自动动态 require @babel/runtime 中的内容。最好要记得在`babel.config.json`里面配置这个插件。

## @babel/types AST 节点类型

**开发的时候请在[官方文档](https://babeljs.io/docs/en/babel-types)查找对应的 AST 节点类型，以及构造接受的参数，以及判断节点类型的 API（这样会比判断 node.type === 'xxx' 更优雅）**

安装`npm install --save-dev @babel/types`

```js
import * as t from "@babel/types";
```

## @babel/template

> In computer science, this is known as an implementation of quasiquotes.

quasiquotes? quasi- 前缀表示准，类似，来自拉丁文，意思为 as if, as it were, approximately

quasi-quotes?准引用？

### 用途/用法

接受一个字符串参数，可以提供占位符，再次替换占位符所对应的**节点对象**，渲染成新的 ast 返回

同时提供两种 placeholder，**不能同时混用**

1. 有语法的：`%%name%%`（version 7.4.0+）
2. identifier： `NAME`

```js
const func = template(`
  function abc() {
    %%a%% = 1;
  }
`);

const ast = func({
  a: types.identifier("abc"),
});
console.log(generate(ast).code);
// function abc() {
//   abc = 1;
// }
```

在没有占位符使用的时候我们可以直接将代码字符串转为 AST，用`.ast`

```js
const name = "my-module";
const mod = "myModule";
// 这里用的是 标签模版方法... es6
const ast = template.ast`
  const ${mod} = require("${name}");
`;
console.log(ast);
```

### API

#### `template(code: string, [opts])`

opts`Object`属性:

- syntacticPlaceholders(`Boolean`)：是否开启`%%foo%%`的风格，默认`true`
- placeholderPattern(`RegExp`)：匹配占位符的，默认是`/^[_$A-Z0-9]+$/`全是大写，包括下划线、数字
- preserveComments(`Boolean`)：是否保留 AST 中的注释节点，默认`false`

返回：一个函数，用来替换占位符

#### 解析得到的 results

`template`

返回一个/多个（数组）节点对象，根据最后解析代码的结果

**注意：只有一个节点的话，返回的不是数组，其他地方如果也要继续对 AST 操作的话，会有影响，因为最初解析的都是数组 [Node]**

`template.statements`

返回 Array of Nodes

```js
const arr = template.statements(`
  export default {
    a: 123,
    b: 223
  }
`);

console.log(arr());
```

**这个返回的都是数组**

`template.statement`

返回一个节点，如果代码是多个节点，会报错

## @babel/standalone

在浏览器，或者非 Node 环境中使用 babel

### 安装

#### CDN

通过 cdn 直接写入 HTML，在需要用到的`<script>`标签中加入类型`type="text/babel"`或者`text/jsx`

```html
<script src="https://unpkg.com/@babel/standalone/babel.min.js"></script>
<!-- Your custom script here -->
<script type="text/babel">
  const getMessage = () => "Hello World";
  document.getElementById("output").innerHTML = getMessage();
</script>
```

如果需要浏览器支持原生 ES 模块，`type`已经被占用了，所以要使用`data-type="module"`

需要插件或者预设，用`data-presets="env, stage-3"`或者`data-plugins="xxx,xxx"`

**其他方式请见[官网](https://babeljs.io/docs/en/babel-standalone)**

## 插件开发

具体参考[handbook](https://github.com/jamiebuilds/babel-handbook/blob/master/translations/en/plugin-handbook.md#toc-introduction)
