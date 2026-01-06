[生成式 UI](https://developers.googleblog.com/en/simulating-a-neural-operating-system-with-gemini-2-5-flash-lite/)

> 充满想象力的未来 UI 方案，google 的 gemini 2.5 flash lit 模型（延迟很低，让用户无感，生成交互界面）能够根据用户的交互生成出最新的交互画面，这与传统的、预设的（pre-coded）交互界面有着极大的差别。
>
> 如何约束模型：**UI constitution** 的 system prompt 让大模型有一套固定的 UI 生成规则，能使得生成的界面保持一致的风格。**UI interaction** 是一个 JSON 对象来捕捉用户最近的交互，告诉大模型需要如何响应。
>
> contextual awareness：大模型生成的 UI 能有用户操作上下文的信息，能够让大模型。利用 streaming 的特性让 UI 流式展示。Just-in-time 生成式 UI：大模型能够结合用户交互 or 场景上下文信息，实时生成出更便捷、优雅的交互给用户，更能“千人千面”

[Claude Code is my computer](https://steipete.me/posts/2025/claude-code-is-my-computer)

> 首先 cc 咱还用不了（但咱有 Codex），作者给了他所有控制电脑的权限，以及准备了自己的 `CLAUDE.md`
>
> _This isn’t about AI replacing developers—it’s about developers becoming orchestrators of incredibly powerful systems. The skill ceiling rises: syntax fades, system thinking shines._
>
> 非常多的场景可以交给 AI 去完成，程序员的天花板真的变高了

[Author of Ghostty: how to vibe coding](https://mitchellh.com/writing/non-trivial-vibing)

> 总结一些 vibe 的好的工作方式（GPT 总结）
>
> 1. 人类先规划，AI 再执行。AI 不负责想需求，你先想架构/流程/UI 方向，AI 再做实现。
> 2. 任务要拆小（小步快跑）一次专注一个部分：计划 → UI → 清理 → backend → 连接 → polish。
> 3. 先写 scaffold，AI 填空。人写骨架（函数名、TODO、结构），AI 补细节 → 成功率最高。
> 4. 遇到 bug：试几次就停，不要无限 brute-force。AI 连续失败说明方向错了，需要你换策略。
> 5. 清理与重构是整个工作流的核心。干净代码（尤其 ViewModel）= 之后的 AI 质量显著提升。
> 6. **文档不是给人看的，是给未来的 AI session 看的**。自然语言描述 + 代码 → AI 的理解力大幅提升。
> 7. 用 AI 做 simulation / 测试场景最划算。生成各种 scenario、状态机、模拟流程 → 节省巨量时间。
> 8. AI 很适合灵感、原型、探索。零到一最困难，让 AI 给方向；最终实现可部分或全部重写。
> 9. “我弄乱了，请修复” 是高频用法。你重构导致 build 爆掉 → AI 自动修。
> 10. 最后一定人工 review。永远不要直接合并 AI 写的代码。
> 11. AI 的最大价值之一：它能在你不在电脑前时工作。不是“更快”，而是“可以异步处理任务”。

[ghostty 在线配置](https://github.com/imrajyavardhan12/spectre-ghostty-config)

> ghostty 的生态真挺不错啊，想记录一下是因为这个网站做的卡片效果挺有意思，跟随鼠标做 3d 倾斜

[Bloom filter](https://llimllib.github.io/bloomfilter-tutorial/zh_CN/)

> **Bloom Filter（布隆过滤器）**是用来判断“某元素是否在集合里”的数据结构：它只能回答“**一定不在**”或“**可能在**”，以很小的内存换取很快的插入/查询。
>
> 工作原理：底层是一条**比特向量**；插入一个元素时，用 **k 个哈希函数**分别对元素取值，把对应的 k 个比特位置为 1。查询时再对该元素做同样的 k 次哈希：只要有任一比特为 0，就能确定“**一定不在**”；如果全为 1，则判为“**可能在**”（存在**误判**）。
>
> 他的一些[应用](https://en.wikipedia.org/wiki/Bloom_filter#Examples)
>
> - **数据库/存储**（Bigtable、HBase、Cassandra、ScyllaDB、PostgreSQL）：先用 Bloom 判断“不存在”，从而跳过昂贵的磁盘查找，加快查询。
> - **Medium**：避免给用户推荐“已经读过”的文章。

[Docus Nuxt 的文档站方案](https://docus.dev/en/getting-started/studio)

> Mark 一下，挺不错的，可以尝试下 nuxt 生态，可以 self host nuxt studio 来在线编辑内容
>
> 基于 [nuxt content](https://github.com/nuxt/content)

[赵纯想 laper.ai](https://mp.weixin.qq.com/s/_R5JNDgecyasSCbwmxZdaQ)

>

[蚂蚁开源 infographic](https://github.com/antvis/Infographic)

> 大模型友好的声明式信息图可视化引擎，还支持流式渲染
