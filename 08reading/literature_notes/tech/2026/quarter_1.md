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
>
> - 我能不能拆对问题
> - 我能不能判断 AI 的好坏
> - 我能不能设计系统、组织协作、承担责任

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
>
> - [`useId`](https://react.dev/reference/react/useId)，来生成元素的 id，避免冲突
> - [cache](https://react.dev/reference/react/cache)（RSC only），缓存函数，当输入参数相同的时候，会直接使用缓存值返回
> - [Activity](https://react.dev/reference/react/Activity)，类似 vue 的 keep-alive？当回到 `visible` 的时候，会重新展示 children 和触发他们的 effects。使用场景：tab 切换保留状态；预先渲染，更快展示；加快 SSR 的 selective hydration，能帮助拆分优先级。要注意的是，`hidden` 状态之后，children 的 effect 会被清除，相当于是 unmount 了组件，但是 react 保留了他们的 state
> - [taintUniqueValue](https://react.dev/reference/react/experimental_taintUniqueValue)（react@experimental），在 server component 标记某些关键的值不能传递给 client component

2026.03.02

[Introducing Markdown for Agents](https://blog.cloudflare.com/markdown-for-agents/)

> Cloudflare 推出的功能：AI Agent 请求网页时在 HTTP header 里加 `Accept: text/markdown`，Cloudflare CDN 层自动将 HTML 转为 Markdown 返回，去掉导航、脚本等非必要元素。本文从 16,180 tokens 降到 3,150 tokens，减少 80%。还包含 Content Signals 标签，标明内容是否允许 AI 训练/搜索/输入。Web 从"为人类浏览器服务"到"同时为 AI Agent 服务"的基础设施转变。
>
> Markdown 对于 AI 爬虫的好处是能大幅度的减少 token 的消耗（相比于解析 html），同样 md 也已经是 AI 系统的 lingua franca 了。

[不要对 Vibe Coding 上瘾](<[https://x.com/i/status/2022263691492937996](https://x.com/i/status/2022263691492937996)>)

> 很真实，要有自我感知，vibe coding 带来的快感 和成瘾性；
>
> 警惕上瘾的标志性体验：不做的时候比做的时候更难受。

2026.03.02

[万字长文：2025 年，我对 AI 编程的全部理解——Part 1](https://loongphy.com/blog/ai-coding-2025)

> LLM 本质是预测下一个 token 的概率，提示词工程已从严格格式演变为自然语言交互。核心工作流：维护 AGENTS.md 作为系统指令 + docs/plans 文件结构作为 Agent 的"记忆"，采用"Plan 优先"模式。警惕营销噪声（RAG、MCP、Context Engineering），聚焦真实需求。并行开发超过两个任务会损伤深度思考能力，要主动掌控工作节奏（关闭通知）。心态从执行者转变为管理者，将 Agent 视为助手而非完美代码生成器。
>
> 看完还是十分有感触的，大模型的发展之迅速，但不要在其中丧失了本应该提升的个人能力：专注力、思考能力；更加需要自己扩展能力边界和知识视野。

[Deep agent](https://blog.langchain.com/deep-agents/)

> 定义：什么是 deep agent？能够对话题深入研究、完成复杂任务、执行长时间任务的 agent，比如 claude code、manus、[deer flow](https://github.com/bytedance/deer-flow)，他是一个 harness 架构设计：
>
> - A system prompt inspired by [Claude Code](https://github.com/kn1026/cc/blob/main/claudecode.md), but modified to be more general
> - A no-op Todo list planning tool (same as Claude Code)
> - Ability to spawn sub-agents, and specify your own
> - A mocked out “virtual file system” that uses the agents state (a preexisting LangGraph concept)

[Ghostty setup for Claude Code](https://x.com/dani_avila7/status/2023151176758268349)

> ghostty 快捷键配置，能更快捷的分割 panel，移动。学到了一些使用功能，比如 focus 一个分区。但是不知道为啥我的 ⌘ + alt 的快捷键不生效，可能是全局冲突了。
>
> 提到了用 [lazygit](https://github.com/jesseduffield/lazygit) 来查看改动，但说实话还是觉得挺难用的，需要上手学习下；以及 [yazi](https://yazi-rs.github.io/docs/quick-start)，在命令行查看文件，同样也是要学习很多 keybindings

2026.03.03 19:30:23 +0800

[beautiful-mermaid](https://github.com/lukilabs/beautiful-mermaid)

> 高性能 TypeScript 库，将 Mermaid 图表渲染为精美 SVG 或 ASCII art，零 DOM 依赖，支持同步渲染。内置 15 套主题 + 自定义主题，完整兼容 Shiki / VS Code 主题；Mono mode 仅用两色生成美观图表。支持 6 种图表类型（流程图、状态机、序列图、类图、ER 图、XY 图）。由 Craft 团队创建，驱动 Craft Agents 的图表渲染，解决原版 Mermaid 美观性差、主题繁琐、无终端输出、依赖重等痛点。

2026.03.13 13:38:58 +0800

[【好文】How Terminals Work](https://how-terminals-work.vercel.app/)

> 这篇交互式的教程清晰的介绍了 terminal 的工作流、TUI 架构设计等。非常好的一个教程，来认识下程序员日常使用最多的 terminal 到底是如何工作的。当敲下键盘后输入的字符在 terminal 应用到底是如何流转？最终在 cli app 里（比如 vim、ls）中响应，完成我们想要的操作/展示。
>
> terminal 是在一个坐标画布上，打印字符，a character display（坐标、样式、字符）。每个键盘按键都对应一个字符，包括上下左右箭头。颜色会通过转译序列（Escape sequences）来编码。当输入 `ctrl + c` 或者 `ctrl + z` 的时候，会在 os 层面被内核的 line discipline 拦截，并且转换为 SIGINT 信号给当前的程序。
>
> terminal 键盘输入流：
>
> ```bash
> Keyboard
>    ↓
>    Terminal Emulator       // 终端 app，比如 iterm2 warp ghostty
>    ↓
>    PTY (pseudo terminal)   // OS 层面
>    ↓
>    zsh (shell)             // shell app，比如 zsh、bash
>    ↓
>    CLI programs (git / ls / vim)
> ```
>
> 每一层都指责明确：
>
> 1.  Hardware Terminal，TTY
> 2.  Software Terminal，负责将键盘输入转换成字节，发送给 PTY，并且展示在屏幕上（带样式、颜色），控制光标移动
> 3.  Software shell，接受 terminal emulator 给的指令，解析、寻找 path、执行，将返回结果给到 terminal
> 4.  Software PTY，模拟 TTY，连接两端（shell 和 terminal emulator）
> 5.  Software CLI，各种 app、TUI app
>
> 所以，当我们打开一个终端 tab（比如 ghostty），实际上是 `terminal emulator -> pty -> shell`
>
> 什么是 TTY、PTY
> **TTY = Teletype** 终端设备接口，Unix 里就把**终端设备统一叫 TTY**。表现为设备文件：`/dev/tty`, `/dev/tty1`, `/dev/tty2` >**PTY = 软件模拟出来的 TTY**，GUI 时代之后，没有真实的硬件终端了，可以用软件模拟，`terminal emulator <-> PTY <-> shell/program`
> shell 看到的是 `/dev/tty` 设备，而不是 terminal，zsh 的 stdin/stdout/stderr 都连接到 tty
>
> ```bash
> keyboard
> ↓
> terminal emulator
> ↓
> PTY master
> ↓
> PTY slave
> ↓
> zsh
> ↓
> exec ls
> ↓
> ls output
> ↓
> PTY slave
> ↓
> PTY master
> ↓
> terminal
> ↓
> screen
> ```
>
> 当在 terminal 中输入 `ls | cat` 时，ls 会判断 stdout 不在 tty 中，所以不会展示出颜色等样式，`ls | bat` 会展示 STDIN，说明内容是通过管道符的 stdin 带入的
>
> 关于 TUI

2026.03.15 21:27:37 +0800

[cmux](https://github.com/manaflow-ai/cmux)

> 基于 Ghostty 的 macOS 原生终端应用（Swift + AppKit），专为 AI coding agent 工作场景设计。核心功能：垂直 Tab 管理多个 Claude Code/Agent 会话、Agent 完成时的通知提醒、内置可脚本化的浏览器、CLI/Socket API 供自动化调用。定位是"可组合的原语"而非强制工作流，原生性能优先，AGPL-3.0 开源。

[nowledge mem](https://mem.nowledge.co/zh)

> 单独的 AI 记忆层工具，对目前主流的 AI Agent、应用都做了适配（插件、浏览器插件等），能够将记忆上下文都能收集并构建成独立的记忆系统/知识平台，在 [v0.6](https://nowledge.co/zh/blog/nowledge-mem-v06)版本中，mem 学会了[自己思考](https://x.com/wey_gu/status/2024480351054418219)；后台智能；全新的搜索引擎：**混合搜索**、**更高维度的 embedding**、**原生中文支持**、**AI 重排序**、**快**；知识存储结构：**Trace**、Unit、Cystal；MCP 交给 Agent 知识图谱
>
> 看文档感觉这个工具很香，也是很不错的知识库设计思路，但目前还没有很强的诉求要用他，后面可以氪金试试。
>
> 或许我会思考：我是否能从历史的和大模型的上下文中获取个人的一些经验？可以搞出来好好复盘一下。比如，[对自己和 AI 的聊天记录进行一次深度复盘](https://x.com/guishou_56/status/2023639714281222265)

[cli anything](https://github.com/HKUDS/CLI-Anything)

> 随着 agent 越来越火，cli 已经成为 agent 调用的最主要/基础的方式，这个库可以对任何软件做一层 cli wrapper，进行 backend call
>
> ```bash
>          AI Agent
>              │
>              │ CLI
>              ▼
>        CLI-Anything
>              │
>      generated CLI layer
>              │
>              ▼
>          Software
> ```

2026.03.15 22:54:41 +0800

[Turso](https://github.com/tursodatabase/turso)

> 用 Rust 重写的 SQLite 兼容嵌入式 SQL 数据库，目标是打造下一代嵌入式数据库。兼容 SQLite 的 SQL 方言、文件格式和 C API，同时引入现代特性：原生 async I/O、CDC（变更数据捕获）、向量搜索、MVCC 并发事务、静态加密、全文搜索等。采用确定性模拟测试（Antithesis 验证），追求 SQLite 级别的可靠性。提供 Go/JS/Java/Python/Rust/WASM 多语言绑定。目前仍处于 beta 阶段。

2026.03.18 21:19:36 +0800

[Crawl4AI](https://github.com/unclecode/crawl4ai)

> 开源的 LLM 友好网页爬虫，将网页转换为干净的结构化 Markdown，专为 AI 应用和数据管道设计。支持 LLM 驱动的数据提取、JS 执行、浏览器自动化与会话管理、智能内容过滤。提供 pip/Docker 部署，多种提取策略（Markdown 生成、CSS 选择器、LLM 提取），内置缓存、代理支持和 API 端点。62k+ stars，社区驱动的开源替代方案。

2026.03.19 15:13:58 +0800

[我对 Spec Driven Development 的看法](https://strrl.dev/post/2026/my-thought-about-spec/)

> Spec Driven Development（规格驱动开发）存在根本缺陷：文档和代码的表达能力之间有巨大 gap，规格无法完整表达产品信息，需求快速变化时文档难以跟进。实践中这种方法导致开发陷入瀑布式设计，生成的代码质量差且难以维护。代码包含大量工程经验和隐含知识，不能被自然语言规格完全替代。作者认为小团队快速迭代 + Coding Agent 辅助是目前较优方案。
>
> 一个很深刻的反省就是，现在的 spec coding，也只是基于需求又写了一份产品文档，但语言/文档和代码之间的 gap 巨大，且文档是最容易丢失维护性的，软件为什么难维护，代码中包含大量反直觉的隐含知识和经验，希望不要在诱惑前丧失了理智, 丧失了思考的能力。为什么上瘾？和

2026.03.26 16:48:22 +0800

[Liveline](https://benji.org/liveline)

> 轻量级 React 实时动画折线图组件，单个 canvas 元素实现 60fps 平滑插值，除 React 18 外零依赖。支持动量箭头、数值叠加、时间窗口、订单簿可视化、K 线图和多系列等可选功能，核心亮点是优雅的线性插值让低频数据更新看起来流畅自然。
>
> 非常漂亮和丰富的功能，作者是 X 的 lead design。

2026.03.27 14:58:19 +0800

[Harness engineering: leveraging Codex in an agent-first world](https://openai.com/zh-Hans-CN/index/harness-engineering/)

> OpenAI 提出 "Harness Engineering" 概念——在 agent-first 的时代，工程师的角色从写代码转向设计约束、工具、反馈循环和验证系统来引导 AI agent。在一次内部实验中，3 名工程师用 Codex 在 5 个月内生成了约 100 万行代码、合并约 1500 个 PR，全程无人手写代码。核心实践包括：为 agent 可读性优化代码库、将设计文档编目索引、agent 直接与开发工具交互（开 PR、评估变更、迭代至满足标准），以及通过遥测数据监控和复现 bug。
>
> 很有启发的 vibe coding 范式，期待在自己的项目里实践下
