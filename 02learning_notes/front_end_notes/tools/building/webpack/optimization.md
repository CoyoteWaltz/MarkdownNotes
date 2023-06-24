# Optimization Configuration

> 2023.06.21 17:06:47 +0800 粗看了一遍[optimization 配置的文档](https://webpack.js.org/configuration/optimization/)，简要摘录一些比较关键的配置

### optimization.chunkIds

控制 webpack 打包 chunk 产物的命名算法

- 在 production 模式下默认是 `deterministic`，能够保证每次构建是幂等的结果（deterministic by content），方便长期的缓存（文件名）
- `named` 更可读的 id（其他模式）
- `natural` 数值，使用顺序

_moduleIds 配置也一样_

### optimization.concatenateModules

concatenateModules 是 webpack 安全的将一些模块提升组合到一个单独模块（why？）production 模式下开启

### optimization.emitOnErrors

在产物编译发生异常的时候依旧输出产物

### optimization.mergeDuplicateChunks

顾名思义的一个重复 chunk 的优化，默认开启

### optimization.realContentHash

产物输出后名称增加内容 hash，默认开启

### optimization.removeAvailableModules

告诉 webpack 移除已经被导入使用过的模块，production 下默认开启

会降低 webpack 的性能

### optimization.sideEffects

识别依赖 npm 包 `package.json` 中的 `sideEffects` 字段，默认开启

### optimization.splitChunks

将代码拆分成块，按需使用。

对于动态引入的模块，可以采用 split chunk 的策略，在用到的时候才 import 模块代码。

_Since webpack v4, the `CommonsChunkPlugin` was removed in favor of `optimization.splitChunks`._

`SplitChunksPlugin` 默认的配置已经足够用了（out of box），会按照下面的条件自动拆分 chunk

- New chunk can be shared OR modules are from the `node_modules` folder
- New chunk would be bigger than 20kb (before min+gz)
- Maximum number of parallel requests when loading chunks on demand would be lower or equal to 30
- Maximum number of parallel requests at initial page load would be lower or equal to 30

整体配置：

```js
module.exports = {
  //...
  optimization: {
    splitChunks: {
      chunks: "async",
      minSize: 20000,
      minRemainingSize: 0,
      minChunks: 1,
      maxAsyncRequests: 30,
      maxInitialRequests: 30,
      enforceSizeThreshold: 50000,
      cacheGroups: {
        defaultVendors: {
          test: /[\\/]node_modules[\\/]/,
          priority: -10,
          reuseExistingChunk: true,
        },
        default: {
          minChunks: 2,
          priority: -20,
          reuseExistingChunk: true,
        },
      },
    },
  },
};
```

接下来看下具体的字段是如何影响最终 chunk 生产的

#### splitChunks.automaticNameDelimiter

默认值是 `~`，控制 chunk 名称比如 `vendor~main.js`

#### splitChunks.chunks

indicates which chunks will be selected for optimization.

Providing `all` can be particularly powerful, because it means that chunks can be shared even between async and non-async chunks.

value: `all`, `async`, and `initial`

#### splitChunks.cacheGroups

`reuseExistingChunk`
