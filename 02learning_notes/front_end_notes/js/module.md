# JS 模块化

JS 最初的设计是没有模块化的，仅仅是单文件裸奔。。当然之前有很多模块化的实现方法，不过目前比较流行的模块化规范是 Nodejs 中 CommonJS 的模块化（ 2019 年）以及 ES6 的模块化（ 2015 年）

## CommonJs

### 模块导出

关键字：`module.exports` `exports`

`module` 和 `exports`都是对象类型

最终暴露给其他模块的对象是`module.exports` ，**`module.exports` `exports`两者指向的内存地址是一样的（同一个引用），其实在模块加载的最开始会执行：`let exports = module.exports`**

导出例子：

```js
// 导出内容作为属性
module.exports.name = "js";
module.exports.foo = () => console.log("foo");
exports.abc = 123;

// 整体导出
module.exports = { name: "js", foo: () => {}, abc: 123 };
// exports = {name: 'js', foo: () => {}, abc: 123};  // 不可以
```

**注意：**整体导出只能使用`module.exports`，因为一旦是整体导出，是用一个对象去替换`module.exports` 的指向。如果用`exports`来整体导出，并没有改变`module.exports`的指向，细品上面的粗体。

### 模块导入

关键字：`require`

导入例子：`require('./moduleA')`

#### 导入规则

**相对路径的情况下**，在导入的目录下寻找`moduleA`：

- 无后缀名的情况按照 JavaScript 解析
- `moduleA.json`按照 json 解析
- `moduleA.node`按照加载的编译插件模块 dlopen

如果同一级目录下没有`moduleA`文件，则会去找同级的`moduleA`目录

- 如果有`moduleA/package.json`会找其中`main`指向的入口文件，如果寻找失败， fallback 到寻找下面的文件
- `moduleA/index.js`
- `moduleA/index.json`
- `moduleA/index.node`

**绝对路径的情况下**，同上

**没有开头路径的模块**，比如`vue`

- 首先判断是否是核心内置模块（比如：`fs ` `path`），是就直接导入
- 如果不是，会从当前项目中最近的`node_module`下找按照上面有路径的情况找文件。
- **如果没找到 继续向父目录的`node_modules`中找**

### 模块实现

`Node`的模块实际上可以理解为代码被包裹在一个函数包装器里面

**require wrapper: **（从[知乎](https://zhuanlan.zhihu.com/p/84204506)上抄的）

```js
function wrapper(script) {
  return (
    "(function (exports, require, module, __filename, __dirname) {" +
    script +
    "\n})"
  );
}

function require(id) {
  var cachedModule = Module._cache[id];
  if (cachedModule) {
    return cachedModule.exports;
  }

  const module = { exports: {} };

  // 这里先将引用加入缓存
  Module._cache[id] = module;

  //当然不是eval这么简单
  eval(wrapper('module.exports = "123"'))(
    module.exports,
    require,
    module,
    "filename",
    "dirname"
  );

  return module.exports;
}
```

类似[源码](https://github.com/nodejs/node/blob/master/lib/internal/modules/cjs/loader.js)（ TODO ）的简单实现吧，主要关键是会**缓存模块**

- 模块只执行一次之后调用获取的 `module.exports` 都是缓存，哪怕这个 `js` 还没执行完毕（因为**先加入缓存**后执行模块）
- 模块导出就是`return`这个变量的其实跟`a = b`**赋值**一样（原因我认为是在导出的时候基本类型也是直接赋值拷贝的，`exports.aaa = aaa`）， **基本类型**导出的是**值**， **引用类型**导出的是**引用地址**
- `exports` 和 `module.exports` 持有相同引用，因为最后导出的是 `module.exports`， 所以对`exports`进行赋值会导致`exports`操作的不再是`module.exports`的引用

注意这个缓存，在多次导入同一个模块的时候

1. 会先判断是否已经缓存过这个模块（对象）
2. 如果是没有缓存，将 module 先加入缓存**（拷贝的方式：注意引用类型）**，执行这个 module （初始化），返回`module.exports`对象。
3. 总之要注意多次导入的其实是同一个**缓存中的**对象。

可以写一下试一试

```js
// moduleA.js
let abc = { x: "abc" };
console.log("before: ", abc);
setTimeout(() => {
  abc.x = "bbbbbbbbxxxxx";
  console.log("after 3s: ", abc);
}, 3000);
module.exports = abc;

// index.js
const abc = require("./moduleA");
console.log("from index: abc", abc);
setTimeout(() => {
  console.log("after 3.5s : abc", abc);
}, 3500);
setTimeout(() => {
  const abcc = require("./moduleA");
  console.log("next require: abc", abcc);
}, 5000);
```

P.S. CommonJS 的模块化是动态的，运行时导入模块的对象（那一套缓存）

**以及，在 CommonJS 中的`this`指向的就是`modules.exports`**，情理之中，意料之外，想了想是这么回事。。

## ES6 Module

参考阮一峰老师：https://es6.ruanyifeng.com/#docs/module

> ES6 模块的设计思想是尽量的静态化，使得编译时就能确定模块的依赖关系，以及输入和输出的变量。

**核心：静态**

使用 CommonJS 模块是运行时加载

```js
const { resolve } = require("path");

// 等价于
const _path = require("path");
const resolve = _path.resolve;
```

ES6 编译时加载（或者静态加载）

```js
import { resolve } from "path";
```

这样以来不仅效率高了，而且仅加载一个方法。 不过这也导致了没法引用 ES6 模块本身，因为它不是对象。

### 严格模式（ ES5 ）

ES6 的模块自动采用严格模式

严格模式主要有以下限制。

- 变量必须声明后再使用
- 函数的参数不能有同名属性，否则报错
- 不能使用`with`语句
- 不能对只读属性赋值，否则报错
- 不能使用前缀 0 表示八进制数，否则报错
- 不能删除不可删除的属性，否则报错
- 不能删除变量`delete prop`，会报错，只能删除属性`delete global[prop]`
- `eval`不会在它的外层作用域引入变量
- `eval`和`arguments`不能被重新赋值
- `arguments`不会自动反映函数参数的变化
- 不能使用`arguments.callee`
- 不能使用`arguments.caller`
- 禁止`this`指向全局对象
- 不能使用`fn.caller`和`fn.arguments`获取函数调用的堆栈
- 增加了保留字（比如`protected`、`static`和`interface`）

### export

将某个变量给外部开放使用接口

#### 几种写法

```js
//
export var a = 1;
export function foo() {}

// 打包导出
const c = "123";
function b() {}
export { c as cc, b };
// 只能这样写 不然语法会报错
```

`export`语句输出的接口，与其对应的值是动态绑定关系，即通过该接口，可以取到模块内部实时的值。

```javascript
export var foo = "bar";
setTimeout(() => (foo = "baz"), 500);
```

最后，`export`命令可以出现在模块的任何位置，只要处于模块顶层就可以。如果处于块级作用域内，就会报错。这是因为处于条件代码块之中，就没法做静态优化了，违背了 ES6 模块的设计初衷。

### import

```js
import { resolve } from "path";
```

接收大括号，对应模块中导出的变量名

当然也可以用 `as` 重新取个名字

**所有`import`进来的都是 read-only 的，也就是 `const` 的，但是如果是引用类型，你知道可以怎么做吧。**

注意：

- `import`是会提升的（因为在编译阶段执行）

- 不要在`import`的时候使用动态的构造，比如`import {'f' + 'oo'} from 'foo'`，这些都是 runtime 的东西。。

- 只写`import xxx`，只会执行这个模块，多次写也只会执行一次

- ```javascript
  import { foo } from "my_module";
  import { bar } from "my_module";

  // 等同于
  import { foo, bar } from "my_module";
  // 对应的是同一个 my_module
  ```

- `import`是单例模式

### export default

为模块指定默认输出，用户不需要知道这个模块有什么东西，一股脑的导入即可，可以任意命名。

```javascript
// import-default.js
import customName from "./export-default";
customName(); // 'foo'
```

在`export default`之后的有名字的函数都“名亡实存”了

注意：

- 只能出现一次
- 可以和普通`export`并存

本质上，`export default`就是输出一个叫做`default`的变量或方法，然后系统允许你为它取任意名字。所以，下面的写法是有效的。

```js
export const e = "123123";

export { e as default };
// 等价于
// export default e
```

```js
import $ from "lodash"; // 鲁大师也能是 dollar
```

其实通过转码之后的`export default`会编译为`exports.default = xxxx`

### export 与 import 的复合写法

如果在一个模块之中，先输入后输出同一个模块，`import`语句可以与`export`语句写在一起。

```javascript
export { foo, bar } from "my_module";
// 向外转发了这两个接口 实际并没有导入到当前模块

// 可以简单理解为
import { foo, bar } from "my_module";
export { foo, bar };
```

用到这样的场景？

```javascript
// 接口改名
export { foo as myFoo } from "my_module";

// 整体输出
export * from "my_module";
```

其他的情况见阮一峰

### import()

`import`是在编译时静态处理（提升到最前处理），那么我们想动态的导入模块怎么办呢？

> `import`命令叫做“连接” binding 其实更合适

为了提升动态性，ES2020 提案引入`import()`函数

```javascript
import(specifier)
  .then((module) => {
    // ...
  })
  .catch((err) => {
    // ...
  });
```

返回一个 Promise 。

`import()`函数与所加载的模块**没有静态连接关系**，这点也是与`import`语句不相同。`import()`类似于 Node 的`require`方法，区别主要是前者是异步加载，后者是同步加载。

#### 适用场景

- 按需加载（懒加载）： vue-router 的懒加载就传入一个 import 函数即可
- 条件加载
- 动态路径加载

#### 注意

- 加载后这个模块会作为一个对象
- 可以用结构的方式获取属性
- 用`default`属性获取默认导出的变量：
  - `.then(({default: ddd}) => {...})` ddd 就是这个模块
  - 用 `async` 和 `await` 的时候同样 `const { default: _ } = await import('lodash');`
  - 其实就是整个模块对象有个 `default` 的属性。
- 也可以在`async`函数里面用！
- 多个模块导入可以用`Promise.all()`

### 浏览器支持 ES Module

```html
<script type="module" src="./foo.js"></script>
```

浏览器加载模块（`type="module"`）的时候是异步处理的

```html
<script type="module" src="./foo.js"></script>
<!-- 等同于 -->
<script type="module" src="./foo.js" defer></script>
```

_也可以给`async`属性让他异步加载_

其实看到这样调用模块有点迷惑，其实在`foo.js`这个文件中就是一个有`import`语句的 ES Module

也可以直接让 js 标签作为模块语法

```html
<script type="module">
  import $ from "./jquery/src/jquery.js";
  $("#message").text("Hi from jQuery!");
</script>
```

注意：代码是有 module 作用域的，自动`use strict`的

### Node.js 中使用 ES Module

由于 CommonJS 和 ES 不兼容，所以比较麻烦，但是在 v13.2 版本开始支持了

Node.js 要求 ES6 模块采用`.mjs`后缀文件名。Node.js 遇到`.mjs`文件，就认为它是 ES6 模块，默认启用严格模式，不必在每个模块文件顶部指定`"use strict"`。

如果不希望改成`.mjs`的话，可以在`package.json`中声明

```json
{
  "type": "module" // 默认是 commonjs
}
```

此时还想用 CommonJS 的话，文件后缀名改为`.cjs`

#### main

package.json 中指定入口文件，没有`"type": "module"`的时候会解析为 CommonJS 模块

```json
{
  "main": "./src/index.js"
}
```

#### exports

**优先级比`main`高**，有多种用法

- 子目录别名：

  ```json
  {
    "exports": {
      "./submodule": "./src/submodule.js"
    }
  }
  ```

  将`./src/submodule.js`指定别名为`./submodule`，别人可以直接导入了`import xx from 'myModule/submodule'`

- main 的别名：

  如果别名是`.`

  ```json
  {
    "exports": {
      ".": "./main.js"
    }
  }

  // 等同于
  {
    "exports": "./main.js"
  }
  ```

  由于`exports`字段只有支持 ES6 的 Node.js 才认识，所以可以用来兼容旧版本的 Node.js。

  ```json
  {
    "main": "./main-legacy.cjs",
    "exports": {
      ".": "./main-modern.cjs"
    }
  }
  ```

### 循环引入

#### CommonJS

由于动态导入的机制，如果 a 模块要引入 b，b 中也引入 a，我们在 main 函数中先导入 a，执行 a 模块代码的过程中发现引入了 b，会去执行 b，在 b 中发现引入了 a，但此时 a 没有执行完毕，所以 b 中拿到 a 的数据只是一部分的缓存，回到 a 后可能会出错。

所以我们要避免写

```js
const foo = require("a").foo; //	此时可能 a 还没有执行完毕
```

#### ES Module

直接看例子

```javascript
// a.mjs
import { bar } from "./b";
console.log("a.mjs");
console.log(bar);
export let foo = "foo";

// b.mjs
import { foo } from "./a";
console.log("b.mjs");
console.log(foo);
export let bar = "bar";
```

执行 `a.mjs` 会发生什么：发现 import 了 b，所以先去执行 b 了，发现 import 了 a，此时 a 以及是判断执行过了，所以认为 foo 是获取到的接口，然后继续执行到第 10 行发现 foo 实际上没有定义，就报错了。

解决方法：由于都用的是引用，用函数返回就行了，用的时候再取值

再看一个

```javascript
// even.js
import { odd } from "./odd";
export var counter = 0;
export function even(n) {
  counter++;
  return n === 0 || odd(n - 1);
}

// odd.js
import { even } from "./even";
export function odd(n) {
  return n !== 0 && even(n - 1);
}
```

执行一下

```javascript
$ babel-node
> import * as m from './even.js';
> m.even(10);
true
> m.counter
6
> m.even(20)
true
> m.counter
17
```

改成 CommonJS 就不能了

```javascript
// even.js
var odd = require("./odd");
var counter = 0;
exports.counter = counter;
exports.even = function (n) {
  counter++;
  return n == 0 || odd(n - 1);
};

// odd.js
var even = require("./even").even; // 这里上面此时还没执行完，是undef
module.exports = function (n) {
  return n != 0 && even(n - 1);
};
// var m = require('./even');
// m.even(10)
// TypeError: even is not a function
```

上面例子来自阮一峰老师

## 对比

CommonJS 的模块化是动态的，运行时导入（那一套缓存）

ES module 是静态的连接，在编译成 AST 的时候导入/输出接口

CommonJS 模块输出的是一个**值的拷贝**，ES6 模块输出的是**值的只读引用**。**注意基本非引用类型**，引用类型无所谓的都是指针，想改就改。。

_所以在不同 ES 模块中导入同一个导出的实例都是同一个，比如 Vue，这很关键_

CommonJS 中的 `this` 是`module.exports`，ES 模块是`undefined`

其次，以下这些顶层变量在 ES6 模块之中都是不存在的。

- `arguments`
- `require`
- `module`
- `exports`
- `__filename`
- `__dirname`

## 小结

感觉有些方面模块化这种东西大同小异，比如类比 Python ， `__init__.py` 文件就相当于是 JS 中的 `index.js` 所以一个目录都可以是一个 module 或者叫 package ，但是我还是觉得 Python 中用 `.` 作为子模块的连接比较舒服（前提是所有路径都是模块）。

## 扩展

rollup 和 webpack 的区别 使用场景：https://zhuanlan.zhihu.com/p/75717476

思考我们打包的场景，适合用什么打包工具去打包：

- Web App: webpack
- js 类库： rollup
