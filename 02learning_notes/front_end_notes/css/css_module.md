# CSS Module

> 关于 CSS module 的[说明](https://github.com/css-modules/css-modules)

## TL; DR

CSS module 是什么：将 CSS 作为 JS Module 一样引入，CSS module 导出的对象是一个 map，将本地的（当前 css 文件下的）类名映射成一个全局类名

有什么作用：避免 class 冲突，样式更安全，因为它可以让每一个本地的 class 都全局唯一，最终渲染到 html 上的 class 也是全局的（可以是 hash 等组合）

## 使用

### 构建配置

#### webpack

基于 webpack 系的构建器，通过 loader 实现转化

可参考：[webpack demo](https://github.com/css-modules/webpack-demo)、[博客](https://blog.jakoblind.no/css-modules-webpack/)、[css trick](https://css-tricks.com/css-modules-part-2-getting-started/)

核心插件（loader）：

[css-loader](https://github.com/webpack-contrib/css-loader#modules)：

默认支持了非常多的 css 能力，`@import`、`url()`、 `import/require()`，让 css 用起来是 module

- **modules** option：开启 CSS Modules
  - **默认是 `undefined`**，但注意会默认 enable CSS modules for all files matching `/\.module\.\w+$/i.test(filename)` and `/\.icss\.\w+$/i.test(filename)` regexp. 所以其实默认就是有 css module 的功能了（xxx.module.xxss）
  - `true` 所有文件都应用 css module，`false` 则全部关闭
  - _还有很多非常复杂的能力，先不多介绍，看下最常用的_

值为 `boolean`

```javascript
options: {
  modules: true; // 开启所有文件的 css module（无脑）
}
```

值为 `object`

```javascript
module.exports = {
  module: {
    rules: [
      {
        test: /\.css$/i,
        loader: "css-loader",
        options: {
          modules: {
            mode: "local", // 默认是 local
            auto: true, // true 开启满足 module/icss 的文件 也可以是 (path: string) => boolean | regExp
            exportGlobals: true,
            localIdentName: "[path][name]__[local]--[hash:base64:5]", // 生成出的 class 名称 包含格式占位
            localIdentContext: path.resolve(__dirname, "src"),
            localIdentHashSalt: "my-custom-hash",
            namedExport: true,
            exportLocalsConvention: "camelCase",
            exportOnlyLocals: false,
          },
        },
      },
    ],
  },
};
```

还有一个配置是 `importLoaders`

_The option `importLoaders` allows you to configure how many loaders before `css-loader` should be applied to `@import`ed resources and CSS modules/ICSS imports._

通常：`importLoaders: 1`

上面的 loader 通过 style-loader 将 css 直接 embed 到 html 中，当然可以通过 [extract-text-webpack-plugin(deprecated)](https://github.com/webpack-contrib/extract-text-webpack-plugin) 将 CSS 作为 bundle file 输出

_P.S 现在推荐 [mini-css-extract-plugin](https://github.com/webpack-contrib/mini-css-extract-plugin)_

```javascript
// loaders
{ test: /\.css$/, loader: MiniCssExtractPlugin.loader, "css-loader" },

// plugins
new MiniCssExtractPlugin()
```

### 开发体验

写完 css module 我们会将 css 文件 `xx.module.css` 作为一个 module 在 js 代码中引入

```tsx
import style from 'xx.module.css';

...

return (
  <div className={style['someClass']} ></div>
)
```

但此时我们的 ts 类型就出现了 `any`，无法确认我们引入的 class 是否是正确的，并且也没有代码提示让我们快速写 class

第一个解决的是在 ts 项目中 `module.css` 或者是 `less` `scss` 等样式文件的类型问题

```typescript
declare module "*.module.less" {
  const classes: { [className: string]: string };
  export default classes;
}
```

第二个更好的方式是自动生成出 `module.css.d` 的 module 类型文件

> 这一篇 medium 的[文章](https://medium.com/@kvendrik/generating-typings-for-your-css-modules-in-webpack-2beb3739b342)

工具：[typed-css-modules](https://github.com/Quramy/typed-css-modules) cli，是一个直接通过 cli 的方式生成（编译）出 ts 文件，也提供了 API 方法可以在脚本代码中使用

文章中的思路是结合 webpack 在每次构建的时候自动生成出最新的 css module d.ts 文件，_可以使用 loader（[typings-for-css-modules-loader](https://github.com/Jimdo/typings-for-css-modules-loader)，17 年最后一个 commit），但是有一个 [bug](https://github.com/Jimdo/typings-for-css-modules-loader#typescript-doesnt-find-the-typings)_

于是作者就 DIY 自己造轮子

1. 写一段 js 脚本，能够把所有目标文件（css module）生成出对应的类型文件（通过 tcm JS API），并将 script 命令加入 package.json 的 scripts 中

2. 通过 [webpack-shell-plugin](https://www.npmjs.com/package/webpack-shell-plugin) 每次构建之前运行，并且用 [webpack-ignore-plugin](https://webpack.js.org/plugins/ignore-plugin/) 来忽略生成出的 `scss.d.ts` 文件（避免二次编译）

   ```javascript
   {
     plugins: [
       new WebpackShellPlugin({
         onBuildStart: ["yarn build:style-typings"],
         dev: false, // makes sure command runs on file change
       }),
       new webpack.WatchIgnorePlugin([/scss\.d\.ts$/]),
     ];
   }
   ```

结束，这样就可以在 dev 的时候，每次文件改动的之后生成出最新的 css module typings

不过，肯定是有更加优雅和高性能的方案，思路有了（这篇文章其实也很优雅了，可以直接通过命令来生成）

_目前公司里面的框架都内置支持 css module 并且也能自动生成对应的 ts 文件，出于好奇了解下如何实现_
