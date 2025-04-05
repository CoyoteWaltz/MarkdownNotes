[github cheat sheet](https://github.com/tiimgreen/github-cheat-sheet/blob/master/README.md)

> github 和 git 的奇技淫巧，摘录一些
>
> Github
>
> - [gist](https://gist.github.com/) 是一个更好的管理代码片段的平台，在文件后加上 `.pibb` 可以获得 html only 的内容
> - 同样 gist 可以被认为是一个仓库，可以 clone/push
> - [Git.io](http://git.io/) is a simple **URL shortener** for GitHub. 不过目前已经不运营了
> - url hash `#L53-L60` 来高亮文件的行内容
> - 通过 commit message 来 close issue：`git commit -m "Fix screwup, fixes #12"`
> - 快速选择仓库协议：在创建仓库的时候可以选预置的协议，或者仓库中 `LICENSE` 文件也能触发此功能
> - 在 PR 链接之后加上 `.diff` `.patch` 可以直接获得 git diff/patch 之后的内容
> - [Hub](https://github.com/github/hub) is a command line Git wrapper that gives you extra features and commands that make working with GitHub easier.（github 已经两年没更新了）
> - Contribution Guidelines
>   - CONTRIBUTING or CONTRIBUTING.md 或者 `.github` 在仓库根目录，在 PR 的时候会创建一个链接
>   - ISSUE_TEMPLATE 里面的内容会在 issue 创建的时候作为模版内容填入（[更多](https://github.blog/developer-skills/github/issue-and-pull-request-templates/)）
>   - PULL_REQUEST_TEMPLATE PR 模版
> - [Octicons](https://primer.style/foundations/icons) GitHubs icons (Octicons) have now been open sourced.
> - SSH keys：`https://github.com/{user}.keys` 来查看
> - 头像照片：`https://github.com/{user}.png`
> - Repository Templates：在仓库设置中开启，则可将本仓库作为模版
>
> Git：
>
> - git 就直接收录在[笔记](../../../../02learning_notes/git/intro.md)

[探究 webpack tapable](https://github.com/lizuncong/mini-tapable/issues/1)

> tapable 必然是作为前端绕不开的宝藏代码，之前也用到了 hook 相关的概念去设计代码，来细细品一下为什么 tapable 如此之神
>
> 主要是以「tapable 为何用 new Function 的方式来执行 call」这个角度深入源码
>
> 详细参考这个 [issue](https://github.com/webpack/tapable/issues/162)，包含 tapable 作者对此的一些讨论（结论是此设计下，在非常巨量调用的场景，函数的执行效率会更高；反之，如果只是少量的 tap 注册，性能是比较差的）
>
> 核心是比较下面两种方式调用在性能上的差异
>
> ```javascript
> // 方法一：
> const callFn = (...tasks) => (...args) => {
>   for (const fn of tasks) {
>     fn(...args);
>   }
> };
>
> // 方法二：
> const callFn2 = (a, b, c) => (x, y) => {
>   a(x, y);
>   b(x, y);
>   c(x, y);
> };
> ```
>
> 所以 tapable 使用了函数代码拼接的方式（[HookCodeFactory](https://github.com/webpack/tapable/blob/master/lib/HookCodeFactory.js)）来构造 call 方法，也是其精华所在
>
> - 通过 `CALL_DELEGATE` 在第一次缓存 call 方法的结果（compile 代码），第二次开始调用都是上次的结果，得以提高多次 call 的执行效率
> - `.tap` 注册插件时，都会重置一次 `this.call` 方法，因为代码需要重新生成
> - `this._x = undefined` 是啥？在 setup 时，将 hook 实例的 taps 的回调作为数组赋值，以便在 compile 代码的时候减少代码复杂度（结合源码，个人理解）
> - 在构造函数中利用 V8 引擎的 `Hidden Class`，绑定实例方法来使得类的形态固定，这样多次调用方法时可以提高寻址效率

[continue.dev](https://www.continue.dev/)

> 大模型代码编辑器 co-pilot 真的是层出不穷

[vscode pets](https://github.com/tonybaloney/vscode-pets)

> 挺有意思一插件，在 vscode 里养个小宠物

[CSS 利用雪碧图来实现小 icon 的动画](https://leanrada.com/notes/css-sprite-sheets/)

> sprite 雪碧图
>
> - 最初提出的目标是为了减少 http 请求的次数（不过现在 http 2 多路复用之后，完全不需要担心带宽问题了）
> - 压缩了多个素材在一张图里
>
> 这里要实现雪碧图动画的效果的思路：动画的每个帧的图片，浓缩在一个雪碧图里，通过动画来改变所选取展示的坐标，实现每一帧的放映（像电影一样）
>
> 雪碧图坐标选取的几种方式：
>
> ```css
> background-image: background-position
> overflow: hidden with nested <img>	left, top on the nested element
> clip-path: clip-path, left, top
> ```
>
> `background-image` 是比较简单好用的
>
> 此方法的一些局限性：
>
> - 过于复杂的动画可能会导致雪碧图非常大，效果反而不好
> - 比较适合简单的 case，更复杂的场景还是推荐用 svg，video 等
> - 高（多）分辨率的场景，实现起来可能比较麻烦

[tc39 try operator](https://nalanj.dev/posts/safe-assignment/)

> 来看一下关于更好的 try/catch 写法（和 go 一样的 error first 使用）
>
> [proposal](https://github.com/arthurfiorette/proposal-try-operator) 在这里，还在早期 stage，先了解下吧
>
> ```javascript
> function tryCatch(fn, ...args) {
>   try {
>     return [undefined, fn.apply(null, args)];
>   } catch (e) {
>     return [e, undefined];
>   }
> }
> ```
>
> Async 版的
>
> ```javascript
> function tryCatch(fn, ...args) {
>   try {
>     const result = fn.apply(null, args);
>
>     if (result.then) {
>       return new Promise((resolve) => {
>         result
>           .then((v) => resolve([undefined, v]))
>           .catch((e) => resolve([e, undefined]));
>       });
>     }
>
>     return [undefined, result];
>   } catch (e) {
>     return [e, undefined];
>   }
> }
> ```

[你不需要 lodash 和 underscore](https://github.com/you-dont-need/You-Dont-Need-Lodash-Underscore)

> es6 提出了很多 util 方法，大部分浏览器都支持，需要兼容也可以直接用 polyfill，我们真的不需要再用鲁大师这样的包了
>
> 这里给出了基本所有方法的**平替代码**
>
> 当然也可以拥抱一下现代化的工具库 [radash](https://github.com/sodiray/radash)，很多时候也可以直接复制他的源码直接使用（ES6 + typescript）

[React Profiling in production](https://gist.github.com/bvaughn/25e6233aeb1b4f0cdb8d8366e54a3977#profiling-in-production)

> 前言：首先什么是 [profiling](https://github.com/reactjs/rfcs/blob/main/text/0051-profiler.md)：render timing metrics，统计渲染性能。[具体的 API 文档](https://react.dev/reference/react/Profiler)
>
> 这篇 Gist 说明了如何开启生产环境的 profiler
>
> - CRA 大于等于 3.2，直接可以通过 `npm run build -- --profile`
>
> - 小于等于 3.1，有几种方式 hook script 脚手架本身的 webpack config
>
>   - ```js
>     // 使用 profiling 版本的 rd
>     'react-dom$': 'react-dom/profiling',
>     ```
>
> ```
>
> ```

[UI-TARS-desktop 自然语言控制电脑](https://github.com/bytedance/UI-TARS-desktop)

> created by Bytedance
>
> 能够通过自然语言，让计算机完成相应的操作的桌面端应用
>
> - 通过屏幕截图理解和识别
>
> 背后的大模型 Agent 是 [UI-TARS](https://github.com/bytedance/UI-TARS) 这个论文

[【Mark】coze 开源流程构建引擎组件](https://github.com/coze-dev/flowgram.ai)

> Mark 一下

[eslint config inspector](https://eslint.org/blog/2024/04/eslint-config-inspector/)

> antfu 老师写的分析 eslint 可视化工具（[github](https://github.com/eslint/config-inspector)）
>
> 可以拍平所有的配置，个人理解在各种 preset 或者 extends 的情况下，可以更直观的查看当前的 eslint 有哪些配置，真不错
>
> 重要：这个工具对于 eslint 的配置文件有限制，必须是新版的[配置](https://eslint.org/docs/latest/use/configure/configuration-files)（eslint v9）

[MyIP](https://github.com/jason5ng32/MyIP)

> IP 检查的使用工具（作者用 ChatGPT 完成的）
>
> 推荐阅读作者的[《我是如何使用 ChatGPT》](https://kenengba.com/post/3800.html)，能有一些如何使用大模型工具的启发

[2025 AI 工程师必读论文 50 篇](https://www.latent.space/p/2025-papers)

> AI 大模型领域，在 10 个领域列举了一些经典必读的论文（LLMs, Benchmarks, Prompting, RAG, Agents, CodeGen, Vision, Voice, Diffusion, Finetuning）

[figma: line height changes](https://www.figma.com/blog/line-height-changes/)

> 这篇 post 介绍了字体排版布局的历史，从印刷块时代到现在的屏幕时代，（垂直）对齐文字始终是一个令人头疼的问题，不同系统、不同应用对字体文件的处理都存在着轻微差异，但 figma 作为设计工具，需要统一的处理字体对齐问题。列举了 figma 上新版 text box 对于 line height 的改动（对齐 web）
>
> 这部分历史还是挺有意思的，以前的 line-height 100% 居然是字体默认字号的大小，而 web 上 100% 就是 font-size 的值，CSS 的创始人认为他们不想耦合字体文件进行大量的计算，所以 line height 与字体无关
>
> type：动词，打字
>
> typesetter：放置印刷块的人
>
> 从 Chrome 133 开始 `text-box` 可以调整文本上方和下方的空格（[link](https://developer.chrome.com/blog/css-text-box-trim?hl=zh-cn) 有很多例子，务必先确保自己的 chrome 是最新的）
>
> ```scss
> text-box-trim: trim-start | trim-end | trim-both | none;
> text-box-edge: cap | ex | text | leading;
> line-fit-edge: alphabetic | text;
> // 或者简写为
> text-box: trim-both cap alphabetic;
> ```
>
> - 可以裁剪掉 "half leading" 的部分
>
> 更多详见 [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/text-spacing-trim)

[如何处理 monorepo 合并 commit 的时的 lock 文件冲突](https://7tonshark.com/posts/avoid-conflicts-in-pnpm-lock/)

> 问题和现象：在合并（rebase/merge）的时候会遇到 lock 文件也有冲突，我们通常手动处理
>
> ```bash
> git checkout --ours pnpm-lock.yaml
> # 并重新根据 package.json install 一次（如果只选择 ours，可能会丢失信息）
> ```
>
> 或者直接 `pnpm install` 让 pnpm 自己处理冲突
>
> 优化的思路：自动配置 lock 文件在冲突时选择 `ours`，重新执行 install 脚本
>
> 1. 配置 `.gitattributes` 文件，同时需要开启 `git config merge.ours.driver true`
>
>    ```bash
>    pnpm-lock.yaml merge=ours
>    ```
>
>    为了使得团队内所有的成员都能在本机自动开启 driver，最好是配置一下 git hook(git-hooks/post-checkout) 或者你的仓库有一个整体的 bootstrap 脚本会执行
>
> 2. 可以创建一个 script，在有合并冲突时执行（下面来自团队中的实践方案）
>
> ```bash
> #! /bin/bash
> # 解决 lock file 冲突工具
>
> LOCK_FILE_PATH=...
> LOCK_FILE_TEMP_PATH=...
>
> # 切换到 master 分支
> checkout_return=$(git checkout master)
> echo $checkout_return
>
> # 拷贝 lock file 到临时文件夹
> cp $LOCK_FILE_PATH $LOCK_FILE_TEMP_PATH
>
> # 切回原分支
> checkout_return=$(git checkout -)
> echo $checkout_return
>
> # 移除错误的 lock file
> rm -f $LOCK_FILE_PATH
> # 拷贝 master 的 lock file
> mv $LOCK_FILE_TEMP_PATH $LOCK_FILE_PATH
> # 移除临时 lock file
> rm -f $LOCK_FILE_TEMP_PATH
>
> # 重新安装依赖
> emo i --ignore-script
>
> # add lockfile
> git add $LOCK_FILE_PATH
>
> # commit lockfile
> git commit -m "chore: update pnpm-lock [auto]"
> ```
>
> pre-push 的 githook 中
>
> ```bash
> #!/bin/bash
> # 设置红色颜色的 ANSI 转义码
> RED='\033[0;31m'
> if git status --porcelain | grep -q "pnpm-lock.yaml"; then
>   echo -e "${RED}Error: pnpm-lock.yaml is included in the changes. Please commit it before push!${NC}"
>   exit 1
> fi
> ```
>
> BTW：`git config merge.ours.driver true` 中的 `merge.<strategy>.driver` 是什么？
>
> 在 git [文档](https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes)中有提及，是指导 git 如何处理 merge 的，以及这些[策略](https://git-scm.com/docs/merge-strategies)，我们也可以[自定义合并策略](https://graphite.dev/guides/git-merge-driver)

[What is FE Architecture](https://ducin.dev/what-is-frontend-architecture)

> 什么是前端架构？（来自团队内分享的文章）
>
> **decisions**、**architectural drivers**、**tradeoffs**、**limitations**
>
> 什么是架构？_The (**high-level, technical**) decisions you make according to business requirements that shape your system today and that are difficult to change in the future._
>
> 不要将架构和具体的实现方式混淆，文件夹结构也并非架构
>
> 提出正确的问题
>
> > _I would rather have questions that can't be answered than answers that can't be questioned_
>
> ...

[Open Router](https://openrouter.ai/)

> unified interface for LLMs 大模型的统一的接口，可以在 open router 用更低的价格购买，并且能有 uptime 的优化（持续检测模型 provider 的连接时延/健康度）

[Desk Pad 虚拟显示器](https://github.com/Stengo/DeskPad)

> MacOS app，创建了一个虚拟显示器，可以把需要投屏分享的软件拖进去进行共享，作为一个纯净的 workspace
>
> 个人暂时没有这种使用场景，但是很好玩哈哈

[前端已死？](https://www.zhihu.com/question/13453534732/answer/115166055109)

> 来看看狼叔对「前端已死」论调的驳论，有些启发
>
> Web 前端这几年的发展或许已经到瓶颈期了，目光要往 AI Web FE 看去，且要客观审视
>
> “客观上多用好 AI 做到最大限度的提效，主观上让 AI 辅助我思考完善个人知识体系。”
>
> 1、AI 工具要善于利用，2，**要愿意下笨功夫，把知识体系建立好**。（前端、AI 的知识体系）
>
> 给出了一些入门 AI Agent Dev 的项目：
>
> [vercel/ai-chatbot](vercel/ai-chatbot)、[goose](https://github.com/block/goose)、[langchain（知乎付费课程。。）](https://juejin.cn/book/7347579913702293567) 等
>
> BTW 包括下面 于江水 的高赞回答带来的一些启发：
>
> - 地理套利：利用技术优势 + 英语学习去做远程
> - 行业套利：去其他的行业做，但是目前比较看好的就 AI 或者 Web3
> - **了解程序之外的事情**，**例如社会运转、商业、财富管理等**：现在 AI 就是你的研发团队

[brotli 压缩格式](https://github.com/google/brotli)

> 来自 google 开源的网络压缩算法和格式，2015 年推出，用于替换传统的压缩算法（如 Gzip 和 Deflate），在压缩率、解压缩速度、资源消耗之间实现更好的平衡
>
> _下面内容来自 Deepseek_
>
> 1. **高压缩率**
>    Brotli 的压缩率显著优于 Gzip（通常可减少 20%-26% 的文件体积），尤其在文本类数据（如 HTML、CSS、JavaScript）中表现突出。这使得网页加载更快，节省带宽。
> 2. **预定义字典优化**
>    Brotli 内置了一个静态字典，包含常见字符模式、HTML 标签和 JavaScript 关键字。这使得它对 Web 内容的压缩更加高效，无需依赖动态字典。
> 3. **多压缩级别支持**
>    支持 0 到 11 的压缩级别：
>    - **低级别（0-4）**：快速压缩，适合实时动态内容（如 API 响应）。
>    - **高级别（5-11）**：最大化压缩率，适合静态资源预压缩（如 CSS/JS 文件）。
> 4. **解压速度快**
>    尽管压缩速度可能慢于 Gzip（尤其在高级别下），但解压速度极快，适合客户端（如浏览器）快速解码。
> 5. **广泛兼容性**
>    - **浏览器支持**：Chrome、Firefox、Edge、Safari（iOS 11+ 和 macOS High Sierra+）等主流浏览器均支持。
>    - **Web 服务器**：Nginx、Apache、CDN（如 Cloudflare）均可配置 Brotli 压缩。
>
> **应用场景**
>
> 1. **Web 性能优化**
>    - 压缩 HTTP 响应：通过 `Content-Encoding: br` 标头传输压缩内容。
>    - 预压缩静态资源（如 CSS、JS、字体文件），搭配缓存策略提升加载速度。
> 2. **前端构建工具集成**
>    - Webpack、Rollup 等工具可通过插件（如 `brotli-webpack-plugin`）生成 `.br` 文件。
>    - 静态站点生成器（如 Next.js）默认支持 Brotli。
> 3. **移动应用与游戏**
>    - 压缩资源文件（纹理、配置文件），减少应用体积和下载时间。
> 4. **CDN 与边缘计算**
>    - 主流 CDN（Cloudflare、Akamai）默认支持 Brotli，自动为兼容客户端提供压缩内容。
>
> 局限性
>
> - **CPU 开销**：高级别压缩对服务器 CPU 压力较大，需权衡压缩率与性能。
> - **旧浏览器兼容性**：需为不支持 Brotli 的客户端提供备用方案（如 Gzip）。
>
> 可以从 youtube 的 js 资源的 response header 看到 `content-encoding` 就是 `br`
>
> 算法概述：
>
> 1. LZ77 滑动窗口算法，来编码重复字符串，用`(distance, length)`，将重复字符串编码成在窗口内存在的某个位置（曾出现过的）
> 2. **静态字典优化**，将一些常用的字符串作为字典表，遇到时直接替换成 index
> 3. 上下文建模，块分割（Html 标签和文本分开建模），将出现频率较高的字符分配更短的哈夫曼编码

[中文网字计划 关于字体分割](https://chinese-font.netlify.app/zh-cn/post/get_start)

> Mark 了好久的站点，核心目的是加速 Web 网站对中文字体（或 CJK 字体）的加载/渲染效率，采用了将字体文件分割成多个 chunk（by unicode-range），利用浏览器 CSS 的 Unicode Range 特性来实现按需加载字体的能力
>
> - 核心依赖：[Harfbuzz](https://github.com/harfbuzz/harfbuzz)，[rust 版的](https://github.com/harfbuzz/harfbuzz_rs)
> - 分包算法：
>
> TradeOff（个人结合过往经验）：
>
> - 完整字体文件的方案 → 首屏渲染会有字体的跳动（加载资源耗时）
> - base64 inline 字体方案 → 首屏包提及大，代码维护不便，治理难度大
> - **分割字体**（CDN 部署）→ 耗时和稳定性
>
> 相关工作原理：[cn-font-split 介绍](https://chinese-font.netlify.app/zh-cn/post/cn_font_split_design)，[github](https://github.com/KonghaYao/cn-font-split)
>
> 看前须知：
>
> - 每个字符都对应一个 [`unicode` 编码](../../../../02learning_notes/sundries/unicode.md)
> - CSS `@font-face` 的 [unicode-range](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face/unicode-range) 能力
>   - 定义一个 `font-face` 的时候 指定 `unicode-range`，当浏览器需要渲染的字在这个范围内，就会去并行的下载对应的字体资源（src），如果没用到就不会下载，通过分割，就会避免整个字体文件的下载
>
> 可以做的工程实践：
>
> - 指定字体文件，放仓库内；dev/build 执行脚本进行字体分割（cn-font-split），生成对应 result.css 代码；移动相应资源文件相应目录下，被上层业务 css（reset.css/base.css）引入；构建时，分割后的字体文件（woff2）也同步被上传到 cdn
>
> 个人项目：可以直接用作者提供的[中文字体 CDN](https://chinese-font.netlify.app/zh-cn/cdn)，点赞！
>
> 感觉是字体分割这块的天花板项目了，[wiki](https://github.com/KonghaYao/cn-font-split/wiki/Architecture#cn-font-split-%E6%9E%B6%E6%9E%84)

[TypeScript Golang port](https://devblogs.microsoft.com/typescript/typescript-native-port/)

> 题外话：从这篇“[为什么使用 go 而不是 rust 来重写的回答中](https://www.reddit.com/r/programming/comments/1j8s40n/comment/mh7n5n0/)”看到一个[神人](https://www.youtube.com/watch?v=0mCsluv5FXA)，用纯 types 写了一个游戏（DOOM 1993 年的），包括编译器、汇编、底层数据结构等等，令人震惊。。
>
> 注意这是一个新的 “**port**”（移植）通常指将一个软件系统或组件的代码从原有运行环境（如编程语言、操作系统、硬件架构等）迁移到另一个环境，同时保持其功能一致性的过程。
>
> TypeScript 团队选择了移植性更好的 Golang（相比 Rust），所做的操作就是将原本的 TypeScript 仓库的 js/ts 代码翻译成 go 代码（by 文件）
>
> [github](https://github.com/microsoft/typescript-go)

[VSCode 的发展历史](https://mp.weixin.qq.com/s/FEYkzmIUCTfkc1HMza-A_w)

> 超过十年的迭代，注重细节和用户反馈，追求极致性能
>
> 推荐看[视频](https://www.youtube.com/watch?v=hilznKQij7A)

[Liquid Logo](https://github.com/collidingScopes/liquid-logo)

> 大佬，用 HTML Canvas + WebGL + shader 编程，让 Logo 有液体流动的特效，很炫酷
>
> 这位大佬还有另一[作品](https://github.com/collidingScopes/ascii)是将视频转化成 Ascii 像素画面
