[生成式 UI](https://developers.googleblog.com/en/simulating-a-neural-operating-system-with-gemini-2-5-flash-lite/)

> 充满想象力的未来 UI 方案，google 的 gemini 2.5 flash lit 模型（延迟很低，让用户无感，生成交互界面）能够根据用户的交互生成出最新的交互画面，这与传统的、预设的（pre-coded）交互界面有着极大的差别。
>
> 如何约束模型：**UI constitution** 的 system prompt 让大模型有一套固定的 UI 生成规则，能使得生成的界面保持一致的风格。**UI interaction** 是一个 JSON 对象来捕捉用户最近的交互，告诉大模型需要如何响应。
>
> contextual awareness：大模型生成的 UI 能有用户操作上下文的信息，能够让大模型。利用 streaming 的特性让 UI 流式展示。Just-in-time 生成式 UI：大模型能够结合用户交互 or 场景上下文信息，实时生成出更便捷、优雅的交互给用户，更能“千人千面”
