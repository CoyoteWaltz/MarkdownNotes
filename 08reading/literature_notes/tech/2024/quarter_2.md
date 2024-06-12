[Signal 草案](https://github.com/proposal-signals/proposal-signals)

> 给 JavaScript 加入原生 signal（很多 UI 框架已经自己实现了，vue、preact、solidjs、...）
>
> stage0，指日可待

[又一 css 框架 bluma](https://github.com/jgthms/bulma)

> ...有机会再尝试吧

[我们的电脑是从哪里获取到时间的？](https://dotat.at/@/2023-05-26-whence-time.html)

> 来自一个 talk，做一些小结
>
> [NTP](https://en.wikipedia.org/wiki/Network_Time_Protocol)（Network Time Protocol）旨在将所有参与的计算机同步到协调世界时 （UTC） 的几毫秒内。
>
> 电脑通过 NTP 服务，NTP 服务也是有级联关系的，最顶层（root）来自一些 reference clocks，实际上本质大多是 GPS 接收器，他们的信号源来自 Schriever Space Force Base（在 Colorado 的一个基地）
>
> 里面是有时钟 US Naval Observatory Alternate Master Clock （atomic clocks、caesium beam clocks、hydrogen masers）
>
> BIPM determine what is UTC
>
> ...

[heptabase 个人知识管理工具](https://heptabase.com/)

> 结合 mindmap、notion，结构化知识、非结构化组织的形式非常符合自己对大脑管理的想象，不过要收费

[计算机领域的三个重要思想：抽象、分层、高阶](https://github.com/qiwihui/pocket_readings/issues/1050)

> 内容挺有意思的
>
> 抽象、分层、高阶 都是一种重要的心智活动
>
> 分层：提出了表面的接口/协议和深入的实现细节的差别，**在良好实现的分层机制中，对于某一层的实现者而言，下一层的绝大部分是不需关心的。**
>
> > Hyrum’s Law: **只要一个 API 有足够的用户，那么无论你在接口契约中承诺什么，你的系统的所有可观测行为都会被某个用户所依赖。**（**With a sufficient number of users of an API, it does not matter what you promise in the contract: all observable behaviors of your system will be depended on by somebody.**）
>
> 也就是意味着当用户逐渐增多，总有一个时候，输入会足够特殊、场景足够复杂，我们会依赖接口之外的可观测行为。**这个时候，层对我们而言已经*毫无意义*：我们依赖的*早已不是*层创设出的接口 / 契约，而是层的*实现细节本身*。**
>
> 确实，很多时候，一个函数的入参逐渐膨胀，抽象/分层变得毫无意义。
>
> 还是“没有银弹”
>
> 高阶：“高阶函数”、“高阶组件”，更加抽象了，非常重要的思想，这一思想具有很好的方法论层面上的指导意义
>
> “二村映射 Futamura projections”：解释器（比如 python 的解释器），接受的是源代码和输入，把解释器堪称一个函数，并且将它 currify，先给定源代码，这样就能得到一个“处理剩下参数的高阶函数”，**这一过程称作 部分求值 partial evaluate，而执行这一过程的程序**我们称作 _部分求值器 partial evaluator_。部分求值器作用于一个程序和它的一些参数，输出一个该程序对于这组参数 “特化” 后的新的程序。这里的 “一个程序” 我们称作 _源程序 source program_，“新的程序” 我们称作 _残差程序 residual program_。
>
> 可以将这一思路和*语言虚拟机*联系了起来：众所周知，实现编译器通常比实现解释器**难得多**，那我们能不能弄一个本质其实是一个部分求值器的语言虚拟机，在这个虚拟机上实现一门新的语言只需要编写一个解释器就行了，而语言虚拟机会调用它的部分求值器自动帮我生成对应的、更加高效的 “编译器” 呢？
>
> PyPy 就是这样一个思路实现的 python 解释器
>
> currify，高阶，思想...慢慢理解和实践看看吧

[ESLint 原理解析](https://juejin.cn/post/7025256331120476197)

> 21 年的文章，不知道现在的架构应该也如此？
>
> 写的比较清晰：
>
> 1. 确定 parser，可以自定义 parser
> 2. parse source code
> 3. 对 rule 进行检查，得到 lint problem，哪一行、哪一列、错误、如何修复
> 4. 自动 fix：字符串替换
> 5. preprocess、postprocess 生命周期
> 6. 通过 comment directives 过滤（比如 `/* eslint-disable */`）
>
> 同时还有 cli 的部分

[what is D3](https://d3js.org/what-is-d3)

> 非常出名的数据可视化的 js 库，收录这篇介绍是因为看到了很多有意思/不认识的英文词汇。。
>
> _slingshotted the field into growth, diversification and creativity that has been unprecedented_
>
> _bespoke visualization_
>
> 有机会体验下

[calendar macos dato 的平替](https://github.com/pakerwreah/Calendr)

> 不过更新了下 [dato](https://sindresorhus.com/dato)，发现还是很香，还是用 dato 吧哈哈

[Ideal PR is 50 lines long](https://graphite.dev/blog/the-ideal-pr-is-50-lines-long)

> 一个 PR 理想的改动量是 50 行，基于数据实验分析出的，文章也给了数据来源（github 的 pr）
>
> 摘录下结论：
>
> - 50 行比 250 行的 PR 的合入速度快 40%
> - 少 15% 被 revert 的几率
> - 多 40% 的评论数

[biome 前端 rust 工具链新星](https://github.com/biomejs/biome)

> 高性能前端工具链，mark 一下，有机会体验下

[【好文】Prompt 该怎么写](https://mp.weixin.qq.com/s/jOU2qT5o88tuZC1p6vLkJw)

> 非常不错的一片教如何写 prompt 的一篇文章，收藏下
>
> 文章最后的话很有共鸣
>
> “说实话，我一直认为，Prompt 这个东西，就是日常表达能力的一个映射。日常中跟人沟通能力很强的人，其实不知道这些技巧，一样能跟大模型协同的很好。”

[walk through million.js](https://github.com/aidenybai/hundred)

> 在 [2023 Q3](../2023/quarter_3) 看过 million js，再来深入了解下，思路还是不错的
>
> 同时作者也提供了 [hundred](https://github.com/aidenybai/hundred) 作为框架的学习素材/POC
>
> 在这篇 [behind the block](https://million.dev/blog/behind-the-block) 中能看出，million 的 block 是一个 HOC，会接管 React Component 中真正渲染 dom 的过程（而不是做一个兼容组件，类似 preact，这样就不用每次都跟进 React 更新的一些新 feature）
>
> 跟着 bundred 走了一边实现，还是非常妙的，实现了 block 创建的基本流程，妙的是通过 Proxy 收集了 ReactComponent 的动态变量。同样去看了下源码，实现的还是比较复杂的，要考虑很多场景
>
> 另外重要的是编译期间，需要将 block 被作用的 React 组件进行转换，例如：
>
> （同样解释了我对组件内部的 state 处理的疑问）
>
> ```tsx
> import { useState } from "react";
>
> import { block } from "million/react";
>
> export const Counter = block(() => {
>   const [count, setcount] = useState(0);
>
>   return (
>     <div>
>       count: {count}
>       <button onClick={() => setCount((v) => v + 1)}>+</button>{" "}
>     </div>
>   );
> });
> ```
>
> 转化为（大致）
>
> ```tsx
> import { block as _block$ } from "million/react";
>
> import { useState } from "react";
>
> const _anonymous$2 = () => {
>   const [count, setCount] = useState(0);
>
>   const _2 = () => setCount((v) => v + 1);
>
>   return <_puppet$ count={count} _2={_2} />;
> };
>
> const _puppet$ = /*million:transform*/ _block$(
>   ({ count, _2 }) => {
>     return (
>       <div>
>         count: {count}
>         <button onClick={_2}>+</button>
>       </div>
>     );
>   },
>   {
>     svg: false,
>     shouldUpdate: (a, b) => a?.a !== b?.a || a?._2,
>   }
> );
>
> export const Counter = _anonymous$2;
> ```
>
> block 的具体实现，参考[源码](https://github.com/aidenybai/million/blob/674b13047665009f8ab1281e77a00a017ddea6e9/packages/react/block.ts)

[【好文】React 技术揭秘](https://react.iamkasong.com/)

> 2024 年了，你还在学习 React 吗？
>
> 这篇 React 架构原理教程（fiber），应该是目前我读到过比较好的中文教程了，循序渐进
>
> 希望是最后一次学 React！XD
>
> 不过最后几章节作者貌似不更新了，看了 github 的 issue 发现作者去写 React 的书和课程了。。

[Tailwind CSS 颜色生成器](https://uicolors.app/create)

> 不错，但是很多功能貌似要登录并升级到 pro 用户。。是在提不起氪金的兴趣
>
> 还有 figma 插件

[radash 现代版的 lodash](https://radash-docs.vercel.app/docs/getting-started)

> TypeScript 编写
>
> 一些 lodash 没有的 feature：`try`、`select`、`defer`、`objectify`
>
> Radash does not provide `_.map` or `_.filter` functions. They were helpful before optional chaining and nullish coalescing. Now, there really isn’t a need.
>
> 来自 TypeScript 社区的一些价值观：**deterministic is good, polymorphic is bad, strong types are everything**.
>
> 多态性：比如 `lodash.map` 是可以同时接受 array 和 object 的。。。

[Pragmatic Drag And Drop](https://github.com/atlassian/pragmatic-drag-and-drop)

> From [Atlassian](https://www.atlassian.com/) by Jira
>
> 各种前端技术栈都适用的 Drag and Drop

[shadcn/ui 是如何 add 组件的](https://github.com/shadcn-ui/ui)

> 时隔一年再去看了下 shadcn。。
>
> 在执行 `npx shadcn-ui@latest add button` 为项目增加 button 组件代码的过程中，内部操作已经发生了改变：源码直接写在 doc 中 → 打包在 doc 项目
>
> 看了下 cli 的 `add` 方法，也是挺有意思的，大概步骤是：
>
> 1. 读取 `config.json` 获得配置
> 2. 拉 [registy](https://ui.shadcn.com/registry/index.json)（存储组件信息的列表）
> 3. 拉需要下载的组件的数据（tree 结构，因为组件可能依赖其他 shadcn 组件），例如 [button.json](https://ui.shadcn.com/registry/styles/default/button.json)
> 4. 获取项目信息（tsconfig，目录）
> 5. 转码（用了 `ts-morph`、babel），源码的路径引用正确、css 变量、tailwind 等（为了匹配当前项目）
> 6. 写入到本地文件
> 7. 安装组件所需要的其他第三方依赖库（用的是 antfu 的 `ni` 来确定用什么包管理器 哈哈）
>
> 整个思路还是比较清晰，能学到不少
>
> 有机会真的想用起来，是现代化的组件方案？

[cva Class Variance Authority](https://github.com/joe-bell/cva)

> 在看 shadcn/ui 看到了这个库，看目的是更好的组织多个 variant 的 className，并提供很好的类型，感觉是一个强化版的 `classnames`，内置了 [`clsx`](https://github.com/lukeed/clsx)（tiny 的 classnames）
>
> 还出了一个 [cva 1.0](https://github.com/joe-bell/cva/discussions/205)？升级了一些[新东西](https://beta.cva.style/getting-started/whats-new)
