# RSC

> 来自 Dan 的 [RSC from scratch](https://github.com/reactwg/server-components/discussions/5)
>
> Deep Dive into _React Server Component_
>
> 文章从零开始实现一个 RSC（三个部分，目前只写了第一部分）

开篇坐着时光机回到 php 的年代，展现了 php 版的网页服务

再从现代 Node API 开始，手把手实现一个 SSR 的博客站点：

1. JSX

纯操控 HTML 字符串不太方便，用 JSX 插槽的形式将模版和内容逻辑拆分

2. Components

将内容拆分成组件（名字，props）都是非常合理的（分而治之）

3. 增加路由

不同路由渲染不同的文件

4. Async components

在博客列表中，虽然是不同的 blog 内容，但他们卡片的结构都是相同的，所以渲染也可以是并行的！需要异步了。
