# Optimization Configuration

> 2023.06.21 17:06:47 +0800 粗看了一遍[optimization 配置的文档](https://webpack.js.org/configuration/optimization/)，简要摘录一些比较关键的配置
>
> 2023.11.20 19:27:54 +0800 开始看中文版的[文档](https://webpack.docschina.org/plugins/split-chunks-plugin/)，翻译的还不错，推荐

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

> 大背景是 webpack4 从 `CommonsChunkPlugin` 切到了 `SplitChunksPlugin`（[这篇官方文章](https://medium.com/webpack/webpack-4-code-splitting-chunk-graph-and-the-splitchunks-optimization-be739a861366)），并且引入了 `ChunkGroup` 这个新对象，简单来说有几个原因：
>
> - 从老的 chunk 图模型（chunk graph）的缺点
>
>   - parent-child 关系（一个 chunk 所属一个 chunk）
>   - 如果一个 chunk 有 parents，则可以认为这个 chunk load 完，至少一个 parent 是加载了的，这样在优化阶段就可以利用这个假设信息，做到（比如）：如果 chunk 中的某个模块在所有的 parents 都可用，那就可以将这个模块直接在 chunk 中移除
>   - 从一个 entrypoint 开始加载的一系列 chunk 会并行的加载
>   - CommonsChunkPlugin 在处理将模块提升到 chunk 之后，会错误的将其作为 parent chunk（会影响后续的优化）（其实这里还并不是很理解说的是什么情况，总之意思就是**很难去表达一个 chunk 到底是如何 split 的**）
>
> - 新的对象 `ChunkGroup` 包含很多 chunk，相当于是用一个集合去包含 chunk，不存在父子层级关系，当然加载的时候从一个 entrypoint 开始指向一个 chunkgroup，其中 chunks 也是并行加载
>
>   - 所以现在 chunk 的拆分就很好去表达了：一个 chunk 拆分出来之后，所有所需的 chunkgroup 只要去把他的引用加入到自己的 group 即可！
>   - 推出了 `SplitChunksPlugin` 内置在 webpack 中做优化
>
> - 举几个例子：
>
>   - Vendors：
>
>   - ```js
>     `chunk-a`: react, react-dom, some components
>     `chunk-b`: react, react-dom, some other components
>     `chunk-c`: angular, some components
>     `chunk-d`: angular, some other components
>
>     webpack would automatically create two vendors chunks, with the following result:
>     `vendors~chunk-a~chunk-b`: react, react-dom
>     `vendors~chunk-c~chunk-d`: angular
>     `chunk-a` to `chunk-d`: Only the components
>     ```
>
>   - 还有 vendors overlap/share 等情况见文章。。

将代码拆分成块，按需使用。

对于动态引入的模块，可以采用 split chunk 的策略，在用到的时候才 import 模块代码。

_Since webpack v4, the `CommonsChunkPlugin` was removed in favor of `optimization.splitChunks`._

`SplitChunksPlugin` **默认的配置已经足够用了**（out of box），会按照下面的条件自动拆分 chunk

- New chunk can be shared OR modules are from the `node_modules` folder
- New chunk would be bigger than 20kb (before min+gz)（文章中写的是 30kb 可能后面改过）
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
