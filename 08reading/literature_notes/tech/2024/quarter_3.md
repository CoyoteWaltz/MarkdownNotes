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

[关于容器做 prefetch](https://juejin.cn/post/7203615594390732855)

> 从容器角度看把 prefetch 思路讲的挺好的，收录一下
>
> 虽然公司里也有多种 prefetch 方案，但我觉得核心方法论还是从容器的视角去出发，分析可以提前请求来优化页面首屏展示的环节，利用好多线程条件下的优势，并行的去资源请求和接口 prefetch（接口、图片、资源等）

[No MVP, But SLC](https://longform.asmartbear.com/slc/)

> 用户不喜欢 MVP(Minimum Viable Product)，做一个 SLC(Simple, Lovable and Complete)应用吧

[CSS 与 JS 的互通](https://www.falldowngoboone.com/blog/share-variables-between-javascript-and-css/)

> 日常前端开发中多多少少会遇到在 js 中需要 css 侧的一些变量（颜色之类的）
>
> 有很多种方法来实现这样的单一数据源（single source of truth）：
>
> - css module ICSS([Interoperable CSS](https://github.com/css-modules/icss))：css 使用 `:export {}`，在 js 可以直接使用这个 member。webpack 的 css-loader 配置需要开启 icss
>
> - css module `@value`：`@value larry, moe, curly from "theme/breakpoints.module.css";` 非常规的 css 语法
>
> - css in js
>
> - 自定义的 css 变量：可以通过 dom css api 获取到，存在兼容性问题（[polyfill](https://www.npmjs.com/package/ie11-custom-properties))
>
>   - ```javascript
>     function cssValue(property) {
>       return getComputedStyle(document.documentElement).getPropertyValue(
>         property
>       );
>     }
>     ```
>
> 最后：单一数据源是可以避免一些技术债和潜在 bug，选择还挺多

[Latency On your PC](https://colin-scott.github.io/personal_website/research/interactive_latency.html)

> Latency Numbers Every Programmer Should Know

[Turning the table on AI](https://ia.net/topics/turning-the-tables-on-ai)

> 挺有意思的一个视角，现在的 AI 产品让我们思考的更少了，为何不利用 AI 让我们思考的更多呢
>
> 文章也给出了一些关于利用 AI 写作的 takeways：
>
> - Don’t ask AI, let AI ask you：通过 prompt 让 AI 引导你去思考，你的回答完全可以直接作为内容
> - Don’t sell stolen goods—make your own：不要直接 copy，结合自己的思考内容
> - Don’t pretend. Create：用自己的话去重写，不断打磨和修改
> - Editing: Cut, clarify, simplify：让 AI 列出（list）现在文字的不足，让 AI 去批评现在的内容
>
> “With every thought we outsource, we miss out on a chance to grow. Love it or hate it, AI is here to stay. However we use it, we need to think more, not less.”
>
> 最后这个文章也出自一个写作工具 [Writer](https://ia.net/writer)

[Deeplink to PDF page](https://technicalwriting.dev/ux/pdf.html)

> 在浏览器打开 pdf 文件的时候，可以在 query 拼接 `#page=X`，第 X 页

[纯 Bash 生成 Markdown Table](https://josh.fail/2022/pure-bash-markdown-table-generator/)

> 很棒，先收藏一下

[gping, ping with a graph](https://github.com/orf/gping)

> Rust 写的

[Primitive 用原始图形重绘制图片](https://primitive.lol/)

> 很有意思
>
> 翻了一会找到了 [github](https://github.com/fogleman/primitive) golang 写的，不过 mac 软件版国区下不到。。
>
> [作者](https://www.michaelfogleman.com/)也是一个图形相关的大佬啊

[纯 CSS 实现超过 100 显示 99+](https://www.zhangxinxu.com/wordpress/2022/01/css-show-diff-content-according-var/)

> 来自张鑫旭
>
> 目标：评论数角标（9、99+），超过 100 后自动展示 99+，纯 css 实现
>
> _说实话有点杀鸡用牛刀的装逼味道_
>
> - CSS 变量作为中间人：`<span style="--num:50"></span>`
>
> - ```css
>   span::before {
>     counter-reset: num var(--num);
>     content: counter(num);
>     font-size: min(16px, calc(10000px - var(--num) * 100px));
>   }
>   span::after {
>     content: "99+";
>     font-size: min(16px, calc(var(--num) * 100px - 9900px));
>   }
>   ```
>
> - `99+` 的 font size 计算：num 是 100 以上，min + calc 算出来就是恒定值了，如果小于 99，那得到的就是 `-1px` 会按照 0 展示

[使用 WebGPU 去除图片背景](https://huggingface.co/spaces/webml-community/remove-background-webgpu)

> 挺有意思的工具，利用 WebGPU

[提升 zsh 的初始化效率](https://www.rustc.cloud/speed-up-zsh)

> 来自信鑫老师
>
> 测试 shell 启动时间
>
> ```bash
> for i in $(seq 1 10); do /usr/bin/time $SHELL -i -c exit; done
> ```
>
> 我的 zsh 启动确实很慢，增加一行
>
> ```bash
> # ~/.zshrc
> # 加到第一行
> zmodload zsh/zprof
> ```
>
> 重启一次 zsh
>
> 可以通过 `zprof` 查看插件性能，发现 nvm 是真慢，日常平时用的 fnm
>
> 于是可以把 zshrc 中的 nvm 相关脚本给注释掉：`export NVM_DIR="$HOME/.nvm"` 相关的一些内容

[将 OpenType 字体内置代码语法高亮](https://blog.glyphdrawing.club/font-with-built-in-syntax-highlighting/)

> 挺有意思的一篇文章
>
> 利用 OpenType features：[OpenType COLR table](https://glyphsapp.com/learn/creating-a-microsoft-color-font)、[OpenType contextual alternates](https://glyphsapp.com/learn/features-part-3-advanced-contextual-alternates)
>
> 拓展字体不同的颜色，并且基于上下文相关信息进行字符的替换，从而实现语法高亮（纯 WEB 页面，JS、HTML、CSS）
>
> 不需要利用 js library，纯字体实现，能替换主题色

[Deep Dive into Tree Shaking](https://github.com/orgs/web-infra-dev/discussions/17)

> 来自 hardfist 杨建老师的深度 treeshaking 解析文章
>
> 首先是 TreeShaking 的定义：
>
> ```bash
> Tree shaking is a term commonly used in the JavaScript context for dead-code elimination.
> It relies on the static structure of ES2015 module syntax,
> i.e. import and export.
> The name and concept have been popularized by the ES2015 module bundler rollup.
> ```
>
> 他的目的：减少最后产物的代码体积
>
> 其实 Webpack 打包工具中的 Tree Shaking 包含三个优化手段：
>
> - **usedExports Optimization**：对于没有使用的 export 变量进行移除（variable 维度）
> - **sideEffects Optimization**：对没有使用的 export 变量，并且没有副作用代码的 module 进行整个移除（module 维度）（`optimization.sideEffects`）
> - **DCE (Dead Code Elimination) Optimization**：不赘述了。。（代码块维度）（ [ConstPlugin](https://github.com/webpack/webpack/blob/main/lib/ConstPlugin.js)，Terser）
>
> 这三个优化并不是连续进行的，是相对分散，并且互相之间也会有影响
>
> `sideEffects` is much more effective since it allows to skip whole modules/files and the complete subtree. -> [sideEffect](https://webpack.js.org/guides/tree-shaking/#clarifying-tree-shaking-and-sideeffects)
>
> 在 [stats.optimizationBailout](https://webpack.js.org/configuration/stats/#statsoptimizationbailout) 为 true 的配置下，可以看到 webpack 打印出的优化信息

[YYX 的新创业公司 void0](https://voidzero.dev/posts/announcing-voidzero-inc)

> 愿景是更好的统一 javascript 工具链生态
>
> 借此也看看现在主流工具链的发展趋势（rust 化）：rolldown、oxc、rspack、...
