[SSA Compiler theory](https://www.recompiled.dev/blog/ssa/)

> 关于 React 19 的 react compiler（aka react-forget by hux）
>
> 作者是 react 的 member
>
> 介绍了一部分 react compiler 的思路：细粒度的 diff 一个组件依赖的 render 变量，将其 memo 来节省计算开销。这种方式是一种传统的编译器实现： [Static single-assignment form](https://en.wikipedia.org/wiki/Static_single-assignment_form)
>
> P.S. [其他文章](https://www.recompiled.dev/tags/forget/)

[Fast Node Manager](https://github.com/Schniz/fnm)

> 来体验一下 rust 版的 nvm 平替：fnm，速度是非常之快
>
> 学习下他的 [Commands](https://github.com/Schniz/fnm/blob/master/docs/commands.md)

[load image with blur down effect](https://joebell.studio/blog/loading-images-with-the-blur-down-technique)

> 来自 [cva](https://github.com/joe-bell/cva) 的作者，介绍了一个图片从 placeholder 加载完成的一个渐变效果：
>
> - [blur up](https://css-tricks.com/the-blur-up-technique-for-loading-background-images/)：
>   - not loaded：底 placeholder 模糊，原图 hidden（opacity 0）
>   - loaded：底图不动，原图 opacity 0 → 1
> - blur down：
>   - not loaded：底 placeholder 模糊，原图 hidden（opacity 0），同时 scale 大一点
>   - loaded：底图不动，原图 opacity 0 → 1，scale 1
>
> 效果还是挺有意思的，其实 nextjs 的 [Image](https://nextjs.org/docs/pages/building-your-application/optimizing/images) 已经有这个 blur up 的效果了
>
> More：[基于浏览器渲染 pipeline 得理解，对模糊动效的深入了解](https://developer.chrome.com/blog/animated-blur)，这篇文章也是使用了前后两张图片的 opacity 的过渡来提升效果的性能（因为通过 css filter 实现的模糊是在 gpu 层通过卷积计算来完成的，对于低端机来说开销是很大的），还同时用了 shadow DOM。[源码](https://github.com/GoogleChromeLabs/ui-element-samples/blob/gh-pages/animated-blur/scripts/animated_blur.js)也是挺有意思
>
> ```javascript
> // opacity 用 0.99
> // Use 0.99 otherwise Safari would have repainting
> // at the end of animation
> ```
>
> 同时作者也有一个 [plaiceholder](https://github.com/joe-bell/plaiceholder) 库可以来生成一张图片的 placeholder 图（纯 function，可用于 node/web）

[【Mark】PDF 技术原理](https://zxyle.github.io/PDF-Explained/)

> PDF 解析的中文译本，可以详细深入了解 PDF 的背后原理
>
> [github](https://github.com/zxyle/PDF-Explained)

[HTML5 Boilerplate](https://www.matuzo.at/blog/html-boilerplate/)

> mark 了很久没看的文档，上来看了这个 html 模版的 [github](https://github.com/h5bp/html5-boilerplate)，震惊有 56k 的 star
>
> 这篇文章会逐行解释 html 的含义，包含很多有意思的配置

[flutter 的未来](https://gityuan.com/2020/03/26/flutter_is_future_or_not/)

> 字节员工 20 年写的对 flutter 的一些探索和展望（如今已经是 lynx 天下，字节内的 flutter 业务屈指可数）

[前端粒子特效库](https://github.com/tsparticles/tsparticles)

> 好东西收藏下
