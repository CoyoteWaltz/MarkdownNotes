[notion ceo 对 AI 时代的理解](https://x.com/ivanhzhao/article/2003192654545539400)

> “We are still in the waterwheel phase of AI, bolting chatbots onto workflows designed for humans. We need to stop asking AI to be merely our copilots. We need to imagine what knowledge work could look like when human organizations are reinforced with steel, when busywork is delegated to minds that never sleep. Steel. Steam. Infinite minds. The next skyline is there, waiting for us to build it.”
>
> 最后一段发人深省

[了解一下 opencode](https://x.com/fkysly/status/2008216983628902879)

>

[shadergraph](https://www.threejsshadergraph.com/)

> 太有意思了，通过画布设置（类似 comfy），生成 shader

[shuding 的 better promise all](https://github.com/shuding/better-all)

> 优雅的处理了 promise 依赖，可以让 promise 都并发运行
>
> `this.$` 用 Proxy 实现，要取值的时候通过 await promise 来阻塞，相应的依赖结束后，通过 resolve 来继续

[A visual guide for SSL tunnel](https://iximiuz.com/en/posts/ssh-tunnels/)

> SSL Tunnel = 用 TLS 加密包一层“安全壳”，在不安全网络上传输原本不安全的 TCP 流量
>
> | 隧道类型          | 隧道协议                |
> | ----------------- | ----------------------- |
> | SSH Tunnel        | SSH                     |
> | SSL Tunnel        | TLS / SSL               |
> | VPN               | IPsec / WireGuard / TLS |
> | Cloudflare Tunnel | TLS + 反向代理          |
>
> 用一条 SSH 连接，临时创建一个 TCP 代理端口
>
> - SSH client 的端口总是开在左侧
>
> `Local → Remote`
>
> ```bash
> ssh -L local_port:remote_addr:remote_port user@sshd
>
> 本机程序
>   ↓
> localhost:local_port   ← 这里在监听
>   ↓
> SSH Tunnel
>   ↓
> remote_addr:remote_port
>
> 把远端服务“拉”到本地
> ```
>
> 典型用途：
>
> - 访问只监听 `127.0.0.1` 的远端服务（DB / 内部 Web）
> - 本地用浏览器 / GUI 调试远端系统
> - 通过 Bastion 访问 VPC / 内网资源
>
> `Remote → Local`
>
> ```bash
> ssh -R remote_port:local_addr:local_port user@gateway
>
> 外部用户
>   ↓
> gateway:remote_port    ← 这里在监听
>   ↓
> SSH Tunnel
>   ↓
> local_addr:local_port
>
> 把本地服务“推”到公网
> ```
>
> 典型用途：
>
> - 把本地 / 内网服务临时暴露到公网
> - demo、调试、临时对外联调
> - home server / NAT 后服务反向打洞

[posthog](https://posthog.com/)

> mark 一下，很牛逼的网站设计

[Josh Woodward gemini 负责人](https://mp.weixin.qq.com/s/-Zy9LpnKAAdQirQb4Hw3oA)

> 快速行动、团队精干、用户第一

[AI 雇佣人类](https://www.rentahuman.ai)

> 太离谱了


[cursor git blame](https://cursor.com/docs/integrations/cursor-blame?utm_source=chatgpt.com#requirements)

> 感谢公司，让我体验上了 cursor 的企业版功能，类似 gitlens 的 blame 功能，并且能看到 commit 内的代码哪些是 ai agent、tab、古法手写的


[AI 是如何改变 Anthropic 的工程师的](https://www.anthropic.com/research/how-ai-is-transforming-work-at-anthropic)

> anthropic 公司给内部员工做了问卷调研，以及 claude 的使用情况的数据，得出以下发现（gpt 总结）：
> 
> 生产力显著提升，但方式变了，输出量大幅增加，每类任务时间下降，但做的事情更多；AI 不只是加速器，而是在扩大工作的可能性边界（没有 AI 可能根本不会去做一些事）
> 
> Claude 是“持续协作者“；- 高风险、强上下文、强“品味（taste）”的工作仍由人主导；Trust but verify
> 
> 工作方式改变，更容易交给 claude 的是一些容易验证正确性、低风险、模块化/边界清晰、重复枯燥的；不太交给 AI 的任务：架构设计、战略判断、组织上下文和“审美”的决策
> 
> 技能广度 ↑，深度练习 ↓ 监督悖论：越依赖 AI，越需要专业能力来判断 AI 对不对
> 
> 软件工程的“工匠感”正在被重定义。
> 
> **未来的高级工程师优势，不在于“我能写什么代码”，而在于：**
> - 我能不能拆对问题
> - 我能不能判断 AI 的好坏
> - 我能不能设计系统、组织协作、承担责任
> 

[迁移 MySQL 到 MariaDB 吧](https://optimizedbyotto.com/post/reasons-to-stop-using-mysql/)

> MySQL 现在只是“开源授权”，而不是“开源协作”，技术层面明显退化，仓库已经很久没有新的 commit 进来迭代了。。
> 
> 尽快迁移到 [MariaDB](https://github.com/mariadb)（MySQL 的 fork，高度兼容，完全开放公开），或者 PostgreSQL 等；


[skills.sh](https://skills.sh/docs)

> vercel 出品的 skill cli，可以通过 cli 来查找想要的 skill，安装
> 
> `npx skills add <skill-name>`，安装的时候可以选择使用的 AI Agent，`-g -y` 代表全局和跳过所有 prompts
> 
> 安装 [`find-skills`](https://skills.sh/vercel-labs/skills/find-skills)
> 
> `npx skills add https://github.com/vercel-labs/skills --skill find-skills`
> 
> `npx skills find [query]`
> 
> mark 下 [vercel-react-best-practices](https://skills.sh/vercel-labs/agent-skills/vercel-react-best-practices)
>  

[http colon](https://httpcolon.dev/)

> 分析网站所有的响应头的工具，是一个学习 http headers 的好地方

[npmx dev](https://github.com/npmx-dev/npmx.dev)

> 一个更加现代化的 npmjs register 的 UI 交互界面，看着是 nuxtjs 和 unocss 的技术栈

2026.02.13 16:42:25 +0800

[Is the Golden Age of Indie Software Over?](https://successfulsoftware.net/2025/12/22/is-the-golden-age-of-indie-software-over/)

> 独立软件开发变得越来越困难：搜索引擎流量因 LLM 蚕食而下降，Google Ads 成本飙升且效果变差，Reddit 广告也不理想。LLM 降低了软件开发门槛，竞争加剧。不同平台都面临挑战——桌面软件被视为恶意软件风险，Web 应用需要 24/7 维护，移动应用竞争压力巨大。AI 带来的新机遇大多被大公司垄断，作者对独立开发者的前景持悲观态度。

[yaplog 上传 AI Agent 的上下文](https://yaplog.dev/transcripts)

> [twitter](https://x.com/mikker/status/2015192542627995979)

2026.02.13 21:10:00 +0800

[Vite DevTools - Features](https://devtools.vite.dev/guide/features.html)

> VoidZero / Vite 团队出品的开发者工具，提供构建过程的可视化分析：模块依赖、插件追踪、代码分割块分析、静态资源可视化、包依赖检测等。支持列表/图表/树形图/热力图多种视图，还能对比不同构建会话之间的变化。
> 
> 值得学习的还有他的页面交互、设计风格，很舒服

2026.02.22 18:13:32 +0800

[gitbutler](https://github.com/gitbutlerapp/gitbutler)

> 自己近期都在使用 jj 这个 vcs 工具，gitbutler 看着也是提供了很多有意思的 feature，对比 jj 的一些 feature 都可以支持（编辑 commit、split、squash、undo），也有一些特有的功能：stacked branches、虚拟分支、并行工作，整体是一个 git 的客户端，一个工作流工具
>
> 有桌面应用和 cli，挺不错
>
> 给我们的启发正如 [why-gitbutler](https://docs.gitbutler.com/why-gitbutler) 所言，代码管理工具的在近 40 年来都没有什么迭代，我们都只是一味的使用 git，是时候重新思考 RCS 工具的正真形态，A code concierge, hard at work for you to ensure that you'll never lose a moment of work again. 
>
> 和 jj 的区别：一个是 VCS，一个是 Git 工作流工具

[openclaw-is-what-apple-intelligence-should-have-been](https://www.jakequist.com/thoughts/openclaw-is-what-apple-intelligence-should-have-been)

> apple 真的应该做一个平台层面的 agent 能力，而不仅是售卖硬件

[bulletproof react component](https://shud.in/thoughts/build-bulletproof-react-components)

> 来自 shuding。讲述了现在写一个 React 组件需要考虑各种情况，来让这个组件变得 X-proof，（Server rendering, hydration, instance, concurrent, composition, portal, transition, activity, leak, future）
> 
> 从文中也了解到了一些 React 19 比较新的，相对陌生的 API，比如
> - [`useId`](https://react.dev/reference/react/useId)，来生成元素的 id，避免冲突
> - [cache](https://react.dev/reference/react/cache)（RSC only），缓存函数，当输入参数相同的时候，会直接使用缓存值返回
> - [Activity](https://react.dev/reference/react/Activity)，类似 vue 的 keep-alive？当回到 `visible` 的时候，会重新展示 children 和触发他们的 effects。使用场景：tab 切换保留状态；预先渲染，更快展示；加快 SSR 的 selective hydration，能帮助拆分优先级。要注意的是，`hidden` 状态之后，children 的 effect 会被清除，相当于是 unmount 了组件，但是 react 保留了他们的 state
> - [taintUniqueValue](https://react.dev/reference/react/experimental_taintUniqueValue)（react@experimental），在 server component 标记某些关键的值不能传递给 client component

2026.03.02 19:43:44 +0800

[Introducing Markdown for Agents](https://blog.cloudflare.com/markdown-for-agents/)

> Cloudflare 推出的功能：AI Agent 请求网页时在 HTTP header 里加 `Accept: text/markdown`，Cloudflare CDN 层自动将 HTML 转为 Markdown 返回，去掉导航、脚本等非必要元素。本文从 16,180 tokens 降到 3,150 tokens，减少 80%。还包含 Content Signals 标签，标明内容是否允许 AI 训练/搜索/输入。Web 从"为人类浏览器服务"到"同时为 AI Agent 服务"的基础设施转变。
> 
> Markdown 对于 AI 爬虫的好处是能大幅度的减少 token 的消耗（相比于解析 html），同样 md 也已经是 AI 系统的 lingua franca 了。

[不要对 Vibe Coding 上瘾]([https://x.com/i/status/2022263691492937996](https://x.com/i/status/2022263691492937996))

> 很真实，要有自我感知，vibe coding 带来的快感 和成瘾性；
> 
> 警惕上瘾的标志性体验：不做的时候比做的时候更难受。

2026.02.13 22:30:00 +0800

[万字长文：2025 年，我对 AI 编程的全部理解——Part 1](https://loongphy.com/blog/ai-coding-2025)

> LLM 本质是预测下一个 token 的概率，提示词工程已从严格格式演变为自然语言交互。核心工作流：维护 AGENTS.md 作为系统指令 + docs/plans 文件结构作为 Agent 的"记忆"，采用"Plan 优先"模式。警惕营销噪声（RAG、MCP、Context Engineering），聚焦真实需求。并行开发超过两个任务会损伤深度思考能力，要主动掌控工作节奏（关闭通知）。心态从执行者转变为管理者，将 Agent 视为助手而非完美代码生成器。
> 
> 看完还是十分有感触的，大模型的发展之迅速，但不要在其中丧失了本应该提升的个人能力：专注力、思考能力；更加需要自己扩展能力边界和知识视野。

