[inversify IOC, DIP](https://github.com/inversify/InversifyJS)

> 所谓的依赖倒置设计模式，这个库给了 TypeScript 实现的 api 套件，很不错，待结合项目深入研究下使用姿势（with 官方文档）

[Anubis 利用工作量证明机制来防御 AI 爬虫](https://anubis.techaro.lol/)

> [github](https://github.com/TecharoHQ/anubis)
>
> AI 爬虫完全不遵守规矩，导致 Saas 站点可能收到非常多的爬虫流量侵袭，一种方式是可以使用 cloudflare 的[免费防护](https://blog.cloudflare.com/declaring-your-aindependence-block-ai-bots-scrapers-and-crawlers-with-a-single-click/)
>
> 或使用 anubis 作为网页流量的前置反向代理，计算 SHA-256 checksums（Anubis has a customizable difficulty for this proof-of-work challenge, but defaults to 5 leading zeroes.）满足条件后才算成功，就是比特币的工作量证明，可以极大的消耗爬虫的 CPU

[做一个 local first and ejectable 的软件](https://thymer.com/local-first-ejectable)

> _EJECTABLE_ Apps：可以随时从云端服务打包“弹射”出去（将数据和服务），部署在本地运作的应用

[node module inspector](https://github.com/antfu/node-modules-inspector)

> 来自安东尼老师，设计审美在线，用于检查项目中的 node module 依赖关系，很不错的可视化工具

[animejs 动画引擎](https://animejs.com/)

> 非常强大的 js 动画引擎库，官网动效非常炫酷

[MTranServer](https://github.com/xxnuo/MTranServer)

> 低占用速度快可私有部署的自由版 Google 翻译，本地 docker 部署，配合 bob 的[插件](https://github.com/gray0128/bob-plugin-MTranServer)，翻译效果还挺丝滑的
>
> 推荐！挺好用

[Google application centric](https://cloud.google.com/blog/products/application-development/an-application-centric-ai-powered-cloud)

> Google 对 **application-centric cloud** 应用开发的体验升级 with AI（Gemini），一站式的工作台，并且结合 AI 助手将应用创建、代码生成、AI 测试、文档等全研发生命周期都集成了。Google 牛逼
>
> 顺便体验了下 [Firebase studio](https://firebase.studio/) 感觉还挺不错的，一条龙服务

[图解 Stable Diffusion](https://www.ithome.com/0/668/981.htm)

> 对[油管视频](https://www.youtube.com/watch?v=MXmacOUJUaw)的翻译（应该是机翻，比较一般），介绍什么是 SD

[对 TypeScript enum 的赞颂（ode）](https://blog.disintegrator.dev/posts/ode-to-typescript-enums/)

> TS 5.8 带来了 `--erasableSyntaxOnly` 特性，简单来说就可以直接执行 ts 代码，通过擦出代码中 type 的特性来实现
>
> 但是 ts 自带的 enum 和 namespace 让这个事情还挺困难的。作者也说了一些社区内对 enum 特性的鄙夷，不过作者在文章中主要还是提出了 enum 好的地方，比如有很好的 doc 能力（deprecated、JS Doc），但是还是推荐使用 `as const` + union literals
>
> ```typescript
> const Foo = {
>   Test: "123",
>   Bro: "bro",
> } as const;
> // 不过很多项目不允许有同名变量
> type Foo = typeof Foo[keyof typeof Foo];
>
> let f: Foo = Foo.Bro;
> ```

[pronotes.app](https://www.pronotes.app/)

> supercharge apple note 很不错的加强插件，挺好用

[FramePack 斯坦福大学的视频 diffusion 模型](https://lllyasviel.github.io/frame_pack_gitpage/)

> [Github](https://github.com/lllyasviel/FramePack)
>
> 太牛了，不过本地需要 N 卡，等等有服务出来直接用吧

[Deepwiki](https://deepwiki.com/)

> 好东西，devin 带你剖析 github 仓库，`github.com/xxx/yyy` to `deepwiki.com/xxx/yyy`
>
> powered by [devin](https://devin.ai/)

[【好文】jx 老师的 MCP AI Agent 应用开发实践](https://juejin.cn/post/7485691461296652338)

> MCP 让 AI 应用开发与工具能力提供解耦，规定了一套协议标准，MCP Server、MCP Client 和 LLM 之间能够只根据协议通信
>
> 通信方式：sse/STDio/local
>
> 生态也日益扩大

[Rspack with nextjs](https://rspack.dev/zh/blog/rspack-next-partner)

> 让 nextjs 使用 rspack 进行，社区推进的插件 [next-rspack](https://www.npmjs.com/package/next-rspack)

[Use react context with zustand](https://tkdodo.eu/blog/zustand-and-react-context)

> 为什么用了 zustand 之后，还需要用 context/provider 呢
>
> _在了解 zustand 的前提下_，作者遇到几个痛点：
>
> 1. store 是全局的，不能通过 react 上下文的 props 进行初始化（只能写死初始值）
> 2. 想要复用 store，并且做到隔离，比较困难，比如 router 维度
> 3. 测试起来会比较方便
>
> 所以结合 context 进行简单封装，将 vanilla store 的值作为 context，再简单封装一个 useSelector 方法即可
>
> _用了 useState 去 stabilize 一个值，原因[在此](https://tkdodo.eu/blog/use-state-for-one-time-initializations)，useMemo 用于性能优化，但未来 react 不保证他的值的稳定性？ useState 更稳定 并且可以做到 lazy init_
>
> ```jsx
> const BearStoreProvider = ({ children, initialBears }) => {
>   const [store] = React.useState(() =>
>     createStore((set) => ({
>       bears: initialBears,
>       actions: {
>         increasePopulation: (by) =>
>           set((state) => ({ bears: state.bears + by })),
>         removeAllBears: () => set({ bears: 0 }),
>       },
>     }))
>   )
>
> const useBearStore = (selector) => {
>   const store = React.useContext(BearStoreContext)
>   if (!store) {
>     throw new Error('Missing BearStoreProvider')
>   }
>   return useStore(store, selector)
> }
> ```

[AI 让程序员 dumb](https://eli.cx/blog/ai-is-making-developers-dumb)

> 博客对现在程序员过度依赖大模型编程助手这一现象提出来自己的反思，copilot 虽然能极快的给出结果，但对于研究过程的缺失反而会使我们越来越愚笨，确实很需要思考下该如何利用大模型。
>
> 用 copilot-lag 这一词很有意思，指程序员在等大模型输出的时间。
>
> 大模型本就是一个预测模型，他并不理解，只是重复的输出训练的预料罢了。

[localsend](https://github.com/localsend/localsend)

> 跨平台通过连接相同 wifi 即可传输文件，加密，无需中央服务端，很好用，以及他的协议 https://github.com/localsend/protocol
>
> 但是对于 live 图的传输不太友好

[sse 被低估](https://igorstechnoclub.com/server-sent-events-sse-are-underrated/)

> sever side event，从服务端单向推送到客户端的请求，基于现有的 http 基建即可，数据格式只能是 text based，chatgpt 目前就是用 sse 完成 streaming response
>
> 适用场景
>
> 1. Real-time News Feeds and Social Updates
> 2. Stock Tickers and Financial Data
> 3. Progress Bars and Task Monitoring
> 4. Server Logs Streaming
> 5. Collaborative Editing (for updates)
> 6. Gaming Leaderboards
> 7. Location Tracking Systems

[yt-dlp 强大的视频下载工具](https://github.com/yt-dlp/yt-dlp)

> Mac 可以通过 brew 或者 pip 安装
>
> 下载 Youtube 视频：需要将 youtube.com 的 cookie [传递](https://github.com/yt-dlp/yt-dlp/wiki/FAQ#how-do-i-pass-cookies-to-yt-dlp)，需要 [export cookie](https://github.com/yt-dlp/yt-dlp/wiki/Extractors#exporting-youtube-cookies)，最后用命令行下载（有非常多的配置），丝滑

[higgsfield AI 特效生成](https://higgsfield.ai/)

> 很强，生成的视频还挺惊艳的

[fellou](https://fellou.ai/)

> Agentic Browser，AI 智能体浏览器，帮你进行各种 action、planing、等，值得期待下

[在线表单编辑](https://tally.so/)

> 挺有意思，类似 Notion 一样 block 的自定义表单的配置，完成后进行发布，并且能拿到相应的代码进行项目内的集成
