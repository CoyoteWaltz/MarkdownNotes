# Module Federation

> “模块联邦”
>
> [Webpack5](https://webpack.js.org/concepts/module-federation/) 融入，作为核心功能
>
> 作者是 [Zack Jackson](https://github.com/ScriptedAlchemy)

[medium 文章](https://medium.com/swlh/webpack-5-module-federation-a-game-changer-to-javascript-architecture-bcdd30e02669)，里面的第一个视频，讲的还是很生动的，模块联邦是什么，简单来说就是可以让一次构建产物，不仅作为一个项目部署，而且可以作为另一个项目的一部分模块，可以直接想到的就是微前端场景。

MF 解决什么问题：作为一个可扩展的解决方案来共享模块和应用代码，适应性和动态性。能动态加载另外一个应用提供的模块，并且能**共享依赖**，并具有 fallback 的那个能力。
