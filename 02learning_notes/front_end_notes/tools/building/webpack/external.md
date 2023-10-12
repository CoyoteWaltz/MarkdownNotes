# Webpack.externals

> [Official Document](https://webpack.js.org/configuration/externals/)
>
> 这个配置能够将项目依赖的外部依赖不打入最终输出的 bundle 里。

## 概述

换句话说，在项目中引入了某个库

```typescript
import $ from "jquery";
```

按照常规做法，webpack 是会去找 node_modules 中这个库被用到的模块代码，一起生成最后输出的 js bundle

使用 externals 防止这个库被打入依赖：

```html
// index.html
<script
  src="https://code.jquery.com/jquery-3.1.0.js"
  integrity="sha256-slogkvB1K3VOkzAI8QITxV3VzpOnkeNVsKvtkYLMjfk="
  crossorigin="anonymous"
></script>
```

```javascript
// webpack.config.js
module.exports = {
  //...
  externals: {
    jquery: "jQuery",
  },
};
```

下面的代码依旧能正常执行，需要从 `jquery` 导入的东西，都会从 `jQuery` 这个全局变量进行寻址。

```javascript
import $ from "jquery";

$(".my-element").animate(/* ... */);
```

这个全局对象的默认类型是 `var`

## externals 配置

### string

当只有需要替换的 module 和变量名（取决于 externalsType）都一致的时候可以仅用一个 string 来简写

```javascript
module.exports = {
  //...
  externals: "jquery",
};

// 等价
module.exports = {
  //...
  externals: {
    jquery: "jquery",
  },
};
```

同样可以用 `${externalsType} ${libraryName}` 的格式一起声明类型，这里 string 里的类型会覆盖 `externalsType` 配置的定义。

```javascript
module.exports = {
  //...
  externals: {
    jquery: "commonjs jquery",
  },
};
```

### [string]

```javascript
module.exports = {
  //...
  externals: {
    subtract: ["./math", "subtract"],
  },
};
```

可以选择一个模块的一部分进行 externals

When the `externalsType` is `commonjs`, this example would translate to `require('./math').subtract;` while when the `externalsType` is `window`, this example would translate to `window["./math"]["subtract"];`

也可以直接声明类型

```javascript
module.exports = {
  //...
  externals: {
    subtract: ["commonjs ./math", "subtract"],
  },
};
```

### object

```javascript
module.exports = {
  //...
  externals: {
    react: "react",
  },

  // or

  externals: {
    lodash: {
      commonjs: "lodash",
      amd: "lodash",
      root: "_", // indicates global variable
    },
  },

  // or

  externals: {
    subtract: {
      root: ["math", "subtract"],
    },
  },
};
```

### function

函数写起来更加抽象一些，也可以灵活的控制

- `function ({ context, request, contextInfo, getResolve }, callback)`
- `function ({ context, request, contextInfo, getResolve }) => promise` （5.15.0+）

Object containing details of the file.

- `ctx.context` (`string`): The directory of the file which contains the import.
- `ctx.request` (`string`): **The import path being requested.**
- `ctx.contextInfo` (`object`): Contains information about the issuer (e.g. the layer and compiler)
- `ctx.getResolve` 5.15.0+: Get a resolve function with the current resolver options.

- `callback` (`function (err, result, type)`): Callback function used to indicate how the module should be externalized.

如果需要 external，就调用 `callback` 即可，将配置，类型都传入（result、type）

```javascript
module.exports = {
  //...
  externals: [
    function ({ context, request }, callback) {
      if (/^yourregex$/.test(request)) {
        // Externalize to a commonjs module using the request path
        return callback(null, "commonjs " + request);
      }

      // Continue without externalizing the import
      callback();
    },
  ],
};
```

更多例子看文档

### RegExp

所有叫 jQuery，不论大小写、或者 \$ 都会被外部化掉

```javascript
module.exports = {
  //...
  externals: /^(jquery|\$)$/i,
};
```

### 混合类型

可以用数组去配置混合类型的配置

## externalsType

目的是指明被外部化的模块需要如何的变量形式去表达

Supported types:

- `'amd'`
- `'amd-require'`
- `'assign'` - same as `'var'`
- [`'commonjs'`](https://webpack.js.org/configuration/externals/#externalstypecommonjs)
- `'commonjs-module'`
- [`'global'`](https://webpack.js.org/configuration/externals/#externalstypeglobal)
- `'import'` - uses `import()` to load a native EcmaScript module (async module)
- `'jsonp'`
- [`'module'`](https://webpack.js.org/configuration/externals/#externalstypemodule)
- [`'node-commonjs'`](https://webpack.js.org/configuration/externals/#externalstypenode-commonjs)
- [`'promise'`](https://webpack.js.org/configuration/externals/#externalstypepromise) - same as `'var'` but awaits the result (async module)
- [`'self'`](https://webpack.js.org/configuration/externals/#externalstypeself)
- `'system'`
- [`'script'`](https://webpack.js.org/configuration/externals/#externalstypescript)
- [`'this'`](https://webpack.js.org/configuration/externals/#externalstypethis)
- `'umd'`
- `'umd2'`
- [`'var'`](https://webpack.js.org/configuration/externals/#externalstypevar)
- [`'window'`](https://webpack.js.org/configuration/externals/#externalstypewindow)

## 应用

### 减少依赖提及

**人工检查**并且**确认**某些在第三方库里的依赖是不需要的（但他们还是引入了），可以通过 externals 的方法去掉这些模块代码的引入

1. 配置 externals
2. 定义这些变量的平替变量（全局变量）
