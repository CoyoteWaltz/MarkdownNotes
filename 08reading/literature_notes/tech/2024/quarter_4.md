[收藏一个 number flow 组件](https://number-flow.barvian.me/)

> react 组件，数字变化之后滚动的效果

[Starlight Documentation website framework for Astro](https://github.com/withastro/starlight)

> 基于 Astro 框架的文档站点框架

[react-scan](https://github.com/aidenybai/react-scan)

> millionjs 的作者的又一 react 组件性能检测的工具
>
> 看了下实现细节，基于对 React 的 global devtool 进行 hook，底层调用了作者的 [bippy](https://github.com/aidenybai/bippy) 这个库
>
> - Hack 进 react 的内部，可以使得我们访问到 fiber
> - 关键点在于 `window.__REACT_DEVTOOLS_GLOBAL_HOOK__` react 组件在 runtime 都会给在这个对象上执行一些事件（这个设计是为了 react devtool，利用它实现一些 hack 手段）
>
> _Monkey-patching: A monkey patch is a way for a program to extend or modify supporting system software locally (affecting only the running instance of the program). This process has also been termed duck punching._
>
> 看到一段关于 equal 的判断，这里 `a !== a` 是为了识别出两个 `NaN`
>
> ```typescript
> export function isEqual(a: unknown, b: unknown): boolean {
>   // biome-ignore lint/suspicious/noSelfCompare: reliable way to detect NaN values in JavaScript
>   return a === b || (a !== a && b !== b);
> }
> ```

[React 19 正式发布](https://react.dev/blog/2024/12/05/react-19)

> 2024/12/05
>
> update at: 2025.01.26 15:41:34 +0800
>
> 文章的内容还是挺多的，涵盖了基本上全部的 19 版本的更新内容概要，做一些摘录总结：
>
> - 关于异步交互的状态管理：
>   - 在 Suspense 之上新增了 `Actions` 概念，通过 `useActionState` 来管理异步方法的数据、请求 pending 态、action
>   - 为 `<form>` 表单元素标签增加了 `action` 属性 `<form action={actionFunction}>`，可以自动的在提交成功后，重置表单内未受控的元素值
>   - `useFormStatus`：在 form 标签包裹内的组件中，可以用此得到当前 form 的一些状态（context），比如 `pending`
>   - [`useOptimistic`](https://react.dev/reference/react/useOptimistic)：所谓的“乐观更新”，能够在异步请求发起的开始就将内容展示为最新的数据。在官网的例子试了下，感觉这个 hook 是比较奇妙的，感觉是在传入的 `state` 变化后，就同时更新 `optimisticState` 了（存疑），还是会自动检查是否在 pending 状态？
>   - `use`，这个 hook 应该之前就有看过，是对于 promise state 的等待处理
> - ReactDom 的一些静态方法 `react-dom/static`
>   - `prerender` 在 `renderToString` 之上的优化
> - RSC 相关
> - API 优化：
>   - `ref` 可以直接从组件 props 里拿到了
>   - hydration 错误的提示更加丰富
>   - Context 可以直接作为 Provider 了 `<XXXContext></XXXContext>`
>   - ref 有 clean up function 了，可以在组件卸载的时候调用，以前组件卸载的时候是获取到 `null`。同时对于 ref 方法的返回值有要求
> - Document Tags
>   - script、style、meta 等原生标签可以被 react 直接 hoist 到 head 标签中
>
> 总体感受就是新的一些 API 更加贴近 web 原生开发体验，挺好。。

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
