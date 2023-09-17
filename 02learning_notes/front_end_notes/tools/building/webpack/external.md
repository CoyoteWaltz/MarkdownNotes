# Webpack.external

> [Official Document](https://webpack.js.org/configuration/externals/)
>
> 这个配置能够将项目依赖的外部依赖不打入最终输出的 bundle 里。

换句话说，在项目中引入了某个库

```typescript
import qs from "qs";
```

按照常规做法，webpack 是会去找 node_modules 中这个库被用到的模块代码，一起生成最后输出的 js bundle
