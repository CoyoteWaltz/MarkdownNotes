[收藏一个 number flow 组件](https://number-flow.barvian.me/)

> react 组件，数字变化之后滚动的效果

[Starlight Documentation website framework for Astro](https://github.com/withastro/starlight)

> 基于 Astro 框架的文档站点框架

[react-scan](https://github.com/aidenybai/react-scan)

> millionjs 的作者

[React 19 正式发布](https://react.dev/blog/2024/12/05/react-19)

> 2024/12/05

[excalidraw 支持中/日/韩字体](https://plus.excalidraw.com/blog/adding-hand-drawn-font-for-chinese-japanese-korean)

> 去年自己 fork 了 excalidraw [增加了小赖字体和霞鹜文楷](https://github.com/CoyoteWaltz/MarkdownNotes/blob/master/12project/excalidraw_with_font/index.md)，如今官方正式加入了中文的小赖字体，并且文章对于字体的优化也做了很好的阐述（附上 [PR](https://github.com/excalidraw/excalidraw/pull/8530)）
>
> _CJK？Chinese Japanese Korean_
>
> [小赖字体](https://github.com/lxgw/kose-font)：
>
> - 对于缺少的汉字，用的是深度学习[造字的方法](https://cjkfonts.io/blog/cjkfonts_allseto)（太牛了，大大减少造一款新字体的时间）
>
> 字体分割 & 懒加载：
>
> - 分割大字体（小赖有 22mb ttf）成为多个不同的 font face，做到无损且聚合最常用的字集
> - [cn-font-split](https://github.com/KonghaYao/cn-font-split)、[harfbuzzjs](https://github.com/harfbuzz/harfbuzzjs)（to perform glyph subsetting based on the established codepoint ranges）
> - 分割成了 209 个 chunk，使用浏览器的 FontFace API，动态的在 [`document.fonts`](https://developer.mozilla.org/en-US/docs/Web/API/Document/fonts) 增加字体
> - 大的 CJK 场景
>   - 使用 service worker 缓存/获取 CDN 上分发的 200 多个 chunk 字体
>   - 从 woff2 解压成 ttf/otf
>   - 用 harfbuzz 进行字码的子集
>   - 重新压缩到 woff2
>   - [详细流程](https://link.excalidraw.com/readonly/8FvNqNc1JwFYLEO1TX2e)
>
> 对 CJK 和多字码的 emoji 内容以及空格的换行进行算法的优化，简单来说就是有代理对的 emoji，在换行分割的时候，会拆分这个表情。。这次更新了正则，进行了优化
>
> 下一步的动作：将中文和日文之间公用的一些字码点进行共用

[state of js 2024](https://2024.stateofjs.com/en-US/features/)

> 每年有意思的前端数据统计
>
> 摘录一些新看到的东西
>
> [Promise.try](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/try)
>
> [Array.fromAsync](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/fromAsync)
>
> [私有属性（原生支持）](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Classes/Private_properties)
>
> [CSS perfers color scheme](https://developer.mozilla.org/zh-CN/docs/Web/CSS/@media/prefers-color-scheme)
>
> 以及 vite、vitest 的喜爱度和使用率都在提升 👍
