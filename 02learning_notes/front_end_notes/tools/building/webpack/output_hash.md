### output 的 hash/chunkhash/contenthash 的区别

在 webpack 的配置中可以控制 output chunk 文件的名称

先出结论

- hash 计算与整个项目的构建相关
- chunkhash 计算与同一 chunk 内容相关
- contenthash 计算与文件内容本身相关

同时也可以看 rspack 对于这几个选项的[解释](https://www.rspack.dev/zh/config/output.html#chunk-context)

#### hash

hash 计算是跟整个项目的构建相关

```javascript
    output: {
        filename: "[name].[hash].js",  // 改为 hash
    },
		...
    plugins: [
        new MiniCssExtractPlugin({
            filename: 'index.[hash].css' // 改为 hash
        }),
    ]
```

我们可以发现，生成文件的 hash 和项目的构建 hash 都是一模一样的。

#### chunkhash

```javascript
filename: "[name].[chunkhash].js", // 改为 chunkhash
```

#### contenthash

根据产物内容创建出唯一 hash 值，也就是说文件内容不变，hash 就不变
