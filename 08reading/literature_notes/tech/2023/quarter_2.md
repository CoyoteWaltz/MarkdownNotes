[ESM 与 CJS 的 interop（互通）](https://zhuanlan.zhihu.com/p/446113714)

> 来自杨健的文章
>
> 讲述了 ESM 模块和 CJS 模块之间是如何互通的，只需要支持个`import foo from 'bar'`这个 syntax sugar 即可满足（即`import foo from 'bar'` 等价于 `const foo = require('bar')`），然而却同时错误的支持了`export default 'xxx'`这个语法，为后续的交互性问题埋下了祸根
>
> Babel 将 ES 模块转成 CJS 模块，会设置 `__esModule` 属性标记是 ESM 模块，按照 `default` 导出时，能够知道使用 `module.exports.default`（可以跑下 babel 看看）
>
> 当 Node.js 最终发布他们的 ES 模块实现时，他们采用了原来的实现，即`default`导出总是等于`module.exports`，这打破了与现有的 ES 模块生态系统的兼容性(即和 Babel runtime 的兼容性)，这些模块已经被 Babel 交叉编译成 CommonJS 模块。为此，esbuild 做了兼容性修复...
>
> 其他一些：
>
> esbuild 0.14.4 引入的 break change
>
> esbuild 的 changelog 业界良心，能学到新东西
>
> babel 这种大工具也是会犯错（方向错了）
>
> js 真难写哈哈
>
> 杨健写了好多文章...很多都很有兴趣去看

[turbowatch](https://github.com/gajus/turbowatch)

> Extremely fast file change detector and task orchestrator for Node.js.
>
> [nodemon](https://github.com/remy/nodemon/) 的更好替代品，有更丰富的功能比如 nodejs API, retries, debounce, ...

[不推荐 export default](https://zhuanlan.zhihu.com/p/97335917)

> 杨健的文章，深入理解 ES Module & 编译，CJS & ESM
>
> 也就是 `export default` 代码在构建之后，被 node 环境引入的时候需要改写 `require('xxx').default` 这样丑陋的代码等一些问题。
>
> React 不支持 esm 入口，`module.exports = React.default || React` 以及错误用了 `default export`
>
> 推荐：
>
> - 不使用 `export default`
> - 编译器使用 rollup 的 auto 模式

[TS 体操：属性互斥](https://zhuanlan.zhihu.com/p/522191794)

> 常见场景：其中有 a 和 b 字段是二选一的, foo 是可选的。自己也遇到过，挺棘手的。
>
> 文中给出了解决方案
>
> - 手工用 never 处理类型（也是自己用的方法，比较初级，也是核心逻辑）
>
> - 函数重载
>
> - 用体操自动加 never 字段
>
>   - 可以实现 `JustOne<UserConfig, ['a', 'b','c']>`
>
> - XOR（也见过这个体操）
>
>   - 什么是 [XOR](https://en.wikipedia.org/wiki/Exclusive_or)，门电路中，两个输入**互不相同**，但**只要其中一个**有 1 则输出 1，其他输出 0
>
>   - 在 TS 中的场景，比如 `XOR<{ a: boolean}, { b: boolean }>` 就是只能有 `a` 或者 `b` 其中一个给了值（有 1），没有给的情况就是输入 0，如果两个都输入了 1（都有值），就不符合类型
>
>   - ```typescript
>     export type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never }; // => U without T, 把 T 独有的 key 都变成 never
>     export type XOR<T, U> = T | U extends object
>       ? (Without<T, U> & U) | (Without<U, T> & T)
>       : T | U; // 最终生成的结果还是类似自动加 never
>     ```
>
>   - 在这个[回答](https://stackoverflow.com/questions/44425344/typescript-interface-with-xor-barstring-xor-cannumber)中也看到了这段代码
>
> 具体使用场景，拿 XOR 做例子
>
> ```typescript
> /**
>  * 有 error 的时候 就是异常了 必然有 description 且 data 是 error 真实的值 可能是 字符串 or 对象
>  * 没有 error (if (!error) 的 else 情况) data 就是 API 的类型
>  */
> export type SDKApiResponseWrapper<T> = XOR<
>   {
>     error: SDKApiErrResp;
>     data: RawSDKApiErrResp;
>   },
>   {
>     data?: T;
>   }
> >;
> ```

[聊聊前端的未来 & Vercel](https://live.juejin.cn/4354/vercel)

> 我司 web infra 大咖面对面，[文字版](https://zhuanlan.zhihu.com/p/510366735)
>
> 介绍了现代 web 渲染的选型，CSR SSR ISR ...
>
> 细粒度组件渲染
>
> 很多 FAQ 也很有意思

[web container 浅析](https://zhuanlan.zhihu.com/p/446329929)

> 就是魔法站点 https://stackblitz.com/ 能在浏览器跑项目（node）所需的技术实现分析
>
> 浅了解一下，还是挺有意思的，很牛啊，node 模块用 wasm 来写，其他模块用 js 实现，终端的指令也用 js 来实现来模拟 命令行（工作量很大）
>
> 更多可看[这篇官方介绍（mark）](https://blog.stackblitz.com/posts/introducing-webcontainers/)

[write own reactive signal library](https://www.lksh.dev/blog/writing-your-own-reactive-signal-library/)

> 写一个响应式“signal”库，文中给的代码非常简单
>
> 更好的理解响应式 & signal
>
> 以及 Solidjs 的 signal，推荐了他们的 [playground](https://playground.solidjs.com/) 可以看到是如何编译代码的
>
> ```javascript
> let currentListener = undefined;
>
> function createEffect(callback) {
>   currentListener = callback;
>   callback();
>   currentListener = undefined;
> }
>
> function createSignal(initialValue) {
>   let value = initialValue;
>   // a set of callback functions, from createEffect
>   const subscribers = new Set();
>
>   const read = () => {
>     if (currentListener !== undefined) {
>       // before returning, track the current listener
>       subscribers.add(currentListener);
>     }
>     return value;
>   };
>   const write = (newValue) => {
>     value = newValue;
>     // after setting the value, run any subscriber, aka effect, functions
>     subscribers.forEach((fn) => fn());
>   };
>
>   return [read, write];
> }
>
> // use your signal
> const [count, setCount] = createSignal(0);
>
> const button = document.createElement("button");
> createEffect(() => {
>   button.innerText = count();
> });
> button.addEventListener("click", () => {
>   setCount(count() + 1);
> });
>
> document.body.append(button);
> ```

[Visualise your app logic](https://stately.ai/)

> 从 Xstate 文档跳过去的新站点，xstate 团队推出的 studio 用来通过状态机描述 app 的逻辑

[React 还是不好处理 Prop-drilling](https://www.builder.io/blog/react-compiler-will-not-solve-prop-drilling)

> 即使有 React-Forget（自动在编译环节给 FC 中增加 useMemo 和 useCallback），也没办法很好的处理 React prop drilling 的问题（state 变更，组件自上而下的 render）
>
> 而 signal 的方式能够让对应的 subscriber 更新，更加细粒度和高效
>
> builder.io 认为 Signal 更好

[artus-cli](https://github.com/artus-cli/artus-cli)

> 企业级 CLI 框架，个人目前用不到，可以作为 CLI 设计的参考学习

[What is TSDoc](https://tsdoc.org/)

> 微软
>
> 说白话就是在写函数头上的一堆 `/** @params */` 这样的注释，用于更好的生成代码文档
>
> [TSDoc](https://github.com/microsoft/tsdoc) 也是一个开源的库，用来解析 TS DOC 的，当然也有很多其他的工具解析了 DOC
>
> 三个必备条件：
>
> 1. **Extensibility:** Tools must be able to define their own custom tags to represent domain-specific metadata in a natural way.
> 2. **Interoperability（互通性）:** Custom tags **must not prevent other tools from correctly analyzing the comment**. In order words, custom tags must use established syntax patterns that can be safely recognized and discarded during parsing.
> 3. **Familiar syntax:** As much as possible, TSDoc should preserve the familiar style of JSDoc/Markdown. This also maximizes the likelihood that legacy comments will parse correctly as TSDoc.
>
> 为什么 JSDoc 不能成为标准？JSDoc 的语法不是严格要求的，而可以说是通过具体 API 的实现来推到出的注释，不满足 TS 强类型语言的诉求
>
> 有 [Playground](https://tsdoc.org/play)
>
> 差不多了解到这，后续需要深入再说

[v8 更快的访问 super 属性](https://v8.dev/blog/fast-super)

> super 关键字可以访问 class 的父类上的属性，依旧是用了 IC(inline cache)（还得去详细学习下）
>
> class 继承的最根本基础还是原型链！
>
> ```javascript
> class A {}
> A.prototype.x = 100;
>
> class B extends A {
>   m() {
>     return super.x;
>   }
> }
> const b = new B();
> b.m();
> ```
>
> 这里的 B 继承 A，所以 `B.prototype.__proto__` 指向 `A.prototype`，b 是 B 的实例所以 `b.__proto__` 指向 `B.prototype`，执行 `m()` 寻找 `super.x` 的过程就是
>
> 1. 从 _home object_（这里就是 m 所定义的对象 `B.prototype`），目标就是让访问 `super.x` 的过程变得更快！
> 2. 这个 case 中，x 是很快就能被访问到的，但是很多情况可能需要 look up 通过很长的 prototype chain 才能寻找到，此时就需要用 IC 进行加速
> 3. 另说一下，这里即使 `B.prototype` 有 `x` 也不会去找的，因为 `super` 是从 home object 的 `__proto__`（也就是 `B.prototype.__proto__`）去找，receiver 就是访问 super 函数的调用者（receiver）
> 4. 实现细节：
>    1. [Ignition](https://v8.dev/docs/ignition) bytecode, `LdaNamedPropertyFromSuper`, a new IC, `LoadSuperIC`, for speeding up super property loads.
>    2. `LoadSuperIC` reuses the existing IC machinery for property loads, just **with a different lookup start object**.
>    3. 具体代码在 [`JSNativeContextSpecialization::ReduceNamedAccess`](https://source.chromium.org/chromium/chromium/src/+/master:v8/src/compiler/js-native-context-specialization.cc;l=1130)，chromium 项目的在线编辑器，搜索代码比较方便（虽然看不懂代码）
> 5. 最后有一些场景可能是 vm 优化不到的，比如直接给 `super.x = ...` 修改了。或者用 mixin 方式会把 inline cache 变成全局的 cache (megamorphic)就慢了点

[React 2023/3 进展](https://react.dev/blog/2023/03/22/react-labs-what-we-have-been-working-on-march-2023)

> RSC React Server Component（了解不多）
>
> - async/await 方式来从服务端获取数据
> - 推荐用更高级抽象的框架去使用这个特性（比如 nextjs）
>
> Asset Loading
>
> - Suspense 能够在一些组件/资源/数据加载的时候展示 loading 状态的内容
>
> Document Metadata
>
> React Optimizing Compiler
>
> - React Forget 编译器已经在开发中 and 重构过，能够帮助 react 团队更好的了解 React 的响应式——an automatic _reactivity_ compiler
> - React 的问题是太响应式了（会 re-render 很多次比如深浅比较的问题），React Forget 的意义在于 apps re-render only when state values _meaningfully_ change
> - 完全与 Babel 解耦，核心的编译 API 输入和输出都是 AST，上层可以和 Babel 等多种
> - 更好的理解组件的语义 in JS 语言，需要不断扩展对于 JS 表达式的理解
> - 在 Meta 内部在试点，等验证之后会公布更多细节和开源
>
> Offscreen Rendering
>
> - 很有用的特性，也是推荐通过上层框架封装后再使用，以后就可以用到 vue 中的 keep-alive 了哈哈

[why react re-render](https://www.joshwcomeau.com/react/why-react-re-renders/)

> 一篇很好的 react 入门/深入文章，有可交互的例子说明了 react 的 render loop，和一些我们认为 react 会 render 的误区：
>
> 误区 并不是所有的 props 变化才会引起组件渲染：
>
> - 场景：一个组件 A 的 render 中包含一个没有 props 的纯组件 B，当 A re-render 的时候，B 也会 re-render，理想情况我们直觉是认为无需改动的组件可以跳过渲染，但是作为框架，_it would be counter-productive to memoize every single component we create._ 比较每一次组件是否渲染是很费劲的，所以 react 并没有做，而是推荐用 memo 将组件包裹（之后就看 React Forget 了）
> - context 场景，即使 memo 的组件其中用了 useContext，这个 context 也会被认作是一个 invisible state，可以理解成一个 prop，组件会随着 context 的变化而 rerender
>
> 文章介绍了用 react devtools，控制台的 Profiler 可以看到每次 render 的组件、render 一次所用的时间
>
> 以及一些性能优化的 tips

[shadcn/ui](https://github.com/shadcn/ui)

> 2023 年初开始就很火的一个 ui 库？框架？star 数一路飙升（目前 2023.03.30 13:03:57 +0800 已经 10.1k）
>
> 作者也是 vercel 的，可以直接通过模版 create next app [构建新项目](https://ui.shadcn.com/docs/installation)
>
> - 如果是已有项目，需要手动加一些配置才能更好配合 ui 库
>
> 理念：
>
> - This is **NOT** a component library.
> - It's a collection of re-usable components built using [Radix UI](https://radix-ui.com/) and [Tailwind CSS](https://tailwindcss.com/).
> - 不发布 npm 包，而是自己 **copy** 代码到项目，自定义样式
>
> [组件](https://ui.shadcn.com/docs/primitives/accordion)也挺好看的，组件的[源码](https://github.com/shadcn/ui/tree/main/apps/www/components/ui)都在文档中～

[Radix UI](https://www.radix-ui.com/)

> 那就再来看一下 Radix UI 是什么
>
> [目标 & Vision](https://www.radix-ui.com/docs/primitives/overview/introduction)
>
> - a low-level UI component library with a focus on accessibility, customization and developer experience.
> - Radix UI 实际上是为当下我们普遍已经[熟悉](https://www.w3.org/WAI/ARIA/apg/#aria_ex)的 UI 组件（checkbox、slider、toast ...）做了一层更好的抽象，但目前的 Web 平台并没有这些交互组件很好的实现（不一致性问题肯定也存在），所以码农们会自己去实现各种组件（项目里写的、好一些的开源的库）但并没那么“完美”（无障碍、功能、样式），所以 Radix 的目标就是构建一套更完备的组件库
>
> 特性：
>
> - Accessible，无障碍很完善
> - Unstyled，无预设样式，可以完全自定义
> - Opened，灵活开放
> - Uncontrolled
> - DX

[tsup](https://github.com/egoist/tsup)

> 好家伙，又是 [egoist](https://github.com/egoist) 的库，真神人
>
> 底层是 esbuild，能够打包 js, ts, tsx

[浅学分布式系统的服务发现](https://juejin.cn/post/6844903937653342216)

> 为什么需要服务发现？
>
> - 通常我们访问服务是需要知道服务实例的 IP 地址和端口，固定的我们便可以直接写在配置文件中，但大多数线上环境尤其是容器部署的情况下，实例地址都是动态分配的，只有实际部署之后才能得到地址，只能通过服务发现组件解析服务名来获取地址和端口
>   - 这里的服务名应该就是自己定义的（比如我司的 `p.s.m`）
>
> 一个标准的服务发现架构主要有三部分组成分别是服务注册中心、服务调用者、服务提供者
>
> 三者关系也就是：
>
> ```mermaid
> flowchart TB
>     服务提供者 --> |注册| 服务注册中心
>     服务调用者 --> 服务提供者
>     服务调用者 --> |服务订阅| 服务注册中心
>     服务提供者 -.-> |变更通知| 服务调用者
> ```
>
> 服务注册中心是核心组件：
>
> - 容错（Fault Tolerance）：服务注册中心保存了分布式系统中所有服务名与服务实例地址映射，一旦故障必将导致整个系统不可用，是整个分布式系统核心，必须具备高可用性；
> - 服务健康检查（Service Health Check）：服务注册中心必须要能及时发现故障实例并将其注销以防止被错误访问；
> - 监视器（Watcher）：服务注册中心必须具备及时通知服务调用者服务实例注册或注销的能力，以便服务调用者及时采取措施。
>
> 其实和域名很相似
>
> 文中介绍了现有的一些方案：DNS，mDNS，Zookeeper，Etcd，Consul

[aPaaS 入门](https://zhuanlan.zhihu.com/p/69168598)

> 互联网行业就喜欢搞一些单词的缩写，SaaS、PaaS、IaaS。都属于云计算
>
> 能够打包这些技术/装备，开发者（用户）都无需自建和维护了，公司提供
>
> 1. 应用（application）
> 2. 数据（data）
> 3. 运行库（runtime）
> 4. 中间件（middleware）
> 5. 操作系统（OS）
> 6. 虚拟化技术（virtualization）
> 7. 服务器（servers）
> 8. 存储（storage）
> 9. 网络（networking）
>
> aPaaS 可以理解为 PaaS 的一种子形式。application Platform as a Service，和 PaaS 的区别是非技术人员可以直接在云端完成应用的搭建、部署、使用、更新和管理
>
> 厂商有 Redmine，Jira，Odoo，Smartsheet, Airtable 和 Zoho Creator（文章是 2019 年的）
>
> 国外的 [retool](https://retool.com/) 也非常牛
>
> 好处：
>
> - 零代码/低代码
> - 可扩展性
> - 云服务
>
> 当然也有局限性，不适合一些企业

[How Warp Works](https://www.warp.dev/blog/how-warp-works)

> Warp 的实现（纯 Rust + Metal，performance first）
>
> Terminal → Shell
>
> 文章讲的还算是挺细节的
>
> - Warp 的一些特性/目标（现代性）：速度/性能；和现有的 shell 兼容（zsh、Bash、Fish）；多平台（还需要支持 web）；支持 blocks；任意的 UI 元素了；native and intuitive editing
> - 选择了 Rust + Metal for 性能，直接选择 Metal GPU 渲染是因为快 and 只想做 Mac 系统；选择 Rust 因为他快并且[社区](https://crates.io/)还不错，对跨平台的支持也很好（也能编译到 WASM）。
> - 为什么直接渲染到 GPU 呢：主要还是快，写 shader 代码封装了少量的基础元素（rectangle、image、glyphs），和 [Nathan Sobo](https://github.com/nathansobo)（Atom、zed）的作者一起开发了一个 **Rust 的 UI 框架**（之后也许会开源出来，很期待）
> - Blocks 的实现，为什么看不到其他 terminal 有 block 这个 feature，因为终端其实不知道到底是什么程序在跑，不知道在 shell 内部发生了什么。Warp 是通过 custom DCS(Device Control String) 包含了 metadata 来渲染一个 session 的内容（具体没怎么看）（顺带提到了 [upterm](https://github.com/railsware/upterm)）
> - Input Editor，也是和 atom 的作者一起，相当于重新实现了一个编辑输入栏，包含了很多使用的快捷键（通过一个事件分发系统实现）,We intentionally designed our editor to be an Operation-based [CRDT](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type) from the start。为了之后可以实时合作。（BTW CRDT 真的出现太多次了，只要是实时编辑就有，该去看看了）
>
> 未来的一些方向就不提了，因为这个 bog 已经是比较久的了（21 年的）
>
> Performance is one of our most important features
>
> Warp 社区好多 issues，甚至 [powerlevel10k 的作者都希望他直接集成](https://github.com/warpdotdev/Warp/issues/2851)
>
> BTW 从 upterm 看到了 [hyper](https://github.com/vercel/hyper)。。vercel 公司的 web 技术 terminal（基于 electron）

2023.4

[Linter?](https://twitter.com/dan_abramov/status/1086215004808978434)

> 来自 Dan 的 Twitter 吐槽
>
> 同样也有 Dan 的这篇[文章](https://overreacted.io/goodbye-clean-code/)，做些摘录：
>
> Obsessing with “clean code” and removing duplication is a phase many of us go through.
>
> Coding is a journey. Think how far you came from your first line of code to where you are now.
>
> **Don’t be a clean code zealot.**
>
> It’s a defense mechanism when you’re not yet sure how a change would affect the codebase but you need guidance in a sea of unknowns.
>
> Let clean code guide you. **Then let it go.**

[Optimize for Change](https://overreacted.io/optimized-for-change/)

> Dan 的文章
>
> _Good_ API design is memorable and unambiguous. It encourages readable, correct and performant code, and helps developers fall into [the pit of success](https://blog.codinghorror.com/falling-into-the-pit-of-success/).
>
> A slight change in requirements can make the most elegant code fall apart.
>
> _Great_ APIs not only let you fall into a pit of success, but help you _stay_ there.

[JSON URL](https://twitter.com/housecor/status/1555555629351198721?s=12&t=dXathnvNfnF_vdpC1hrLdQ)

> 推荐的 [JSONCrush](https://github.com/KilledByAPixel/JSONCrush) 这个库，能很高效的压缩 JSON String，让通常放在 URL 上的 JSON 数据变小（头疼问题）

[2023 年学传统软件开发还有意义吗](https://anduin.aiursoft.cn/post/2023/3/31/classic)

> Anduin Xue 大佬的博文
>
> _只是不要把重心放在传统软件工程上了，就像我的学习重心也不是汇编。但是绝对不是不学，而是对整个宏观知识都要有更高的要求的同时，将侧重点放在 AI 的研究方向上。_
>
> _例如，把 70%的精力放在 AI 相关领域，20%的精力放在传统软件工程（面向对象程序设计，MVVM，依赖注入，数据结构，算法，前后端分离，组件化开发，依赖管理，包管理，操作系统，虚拟化，云计算，分布式系统，数据库等），10%的精力放在考古技术上（C、汇编、计算机组成原理，数字电路）。_
>
> [计算机底层知识到底值得学么](https://www.zhihu.com/question/264426279/answer/1840524133) 的这个回答，提到的 [Hyrum's Law](https://www.hyrumslaw.com/)：
>
> 大意是指，如果一个接口存在足够多的用户，不论你在接口层面做出何种“契约”，整个系统每一个可观测行为都可能会被某个用户所依赖。
>
> 某种意义上计算机中的许多顶层抽象是“不完全成功”的，虽然它确实能够降低编程的门槛，但事实上作为专业程序员所需要掌握的底层知识并没有因此减少多少。

[Chrome112 支持 CSS 嵌套 document.domain 禁用](https://zhuanlan.zhihu.com/p/620412706)

> CSS 嵌套不多说了，就是 less 等后处理器的特性，但是为了兼容老版本，还是不要纯 CSS 了吧
>
> document.domain 正式禁用，为了更加安全
>
> - 之前可以在 iframe 跨域通信的场景，将主 frame 和 iframe 的 `document.domain` 都设置成相同的域名，但是不够安全，跨域通信方案还是选用 `postMessage` 或其他

[Hyrum's Law](https://www.hyrumslaw.com/)

> _With a sufficient number of users of an API,_ > _it does not matter what you promise in the contract:_ > _all observable behaviors of your system_ > _will be depended on by somebody._
>
> 什么意思呢？作者在多年的软件工程生涯中，得到了一个 interface 和 implementation 之间的观察。
>
> 通常我们认为 interface 是对复杂系统的抽象，他一旦被定义了就是确认的，可以理解是在消费者和实现者之间的一个分隔。但在实际中，这个理论经常会失败，因为当使用者增加后，他们会越来越倾向直接依赖从接口暴露的**实现细节**。
>
> “The Law of Implicit Interfaces”，有了足够多的用户，实现中的每一个细节都会被被依赖（代码覆盖），既包含了 explicitly documented interface, as well as the implicit interface captured by usage.
>
> 所以往往随着时间的推移，系统增长，用户量的增大，一个系统/API 的设计就需要考虑这些 implicit interface，也需要意识到 interface 会触达的深度比想象的更深（复杂系统中）。

[推特开源推荐算法](https://blog.twitter.com/engineering/en_us/topics/open-source/2023/twitter-recommendation-algorithm)

> GitHub 代码 [here](https://github.com/twitter/the-algorithm) (and [here](https://github.com/twitter/the-algorithm-ml)
>
> 推特的推荐算法是应用在“For You”的 tab，推荐出 tweets
>
> blog 中讲了大致的推荐流程、如何选择 tweets
>
> - 理论上，一半和用户关注的相关（In Network，社交网内），一半是 Out Of Network
> - 链路流程：候选推 -> Ranking -> 启发/过滤/特征 -> 混排 -> 下发
> - In-Network 用的 Real Graph 模型来预测两个用户之间有关联/会交互的可能性
> - Out-of-Network，开发了 GraphJet 图处理引擎用来实时维护用户和推之间的关系
> - Ranking 是用的大约 48M 参数的神经网络模型，通过学习推之间的正向交互（点赞、转推、回复等），得出每个推之间的标签分数
> - 启发/过滤其实就是对于排序结果进行微调，可见性、内容是否丰富、作者是否丰富、基于推文的反馈是否良好等规则
> - 最后就是再将推文混合一些广告啊、好友推荐等非推文的内容，给到服务下发
>
> 总的来说还是挺有意思的，流程概念也比较清晰

[字节 serverless 高密度部署与 Winter 实践](https://mp.weixin.qq.com/s/dkEgmep_9m05yXCN00NCsA)

> 传统 serverless 的调度（二层心型网络）：统一网关 -> FaaS 网关 -> Pod（函数）
>
> 进程高密度调度（三层）：在容器内部多了一个进程级别的调度
>
> 通过 Winter 作为函数运行时（interoperable 互通性）
>
> - 降低成本
> - 流程编排
>
> _相较于 Node.js 来说，有一些很好的优势，比如低门槛，因为写 JS 的前端开发者们更熟悉浏览器 API。选择 Node.js 你要自己实现一个服务器，你要监听端口，自己去实现整个 HTTP 服务器，除此之外，你还要搞它的 PM2、运维、部署，等等。如果上了 Winter 就简单了，我们不需要监听端口，只需要监听 Fetch 事件，之后直接把它上到高密度部署，其他什么事都不需要管，它直接会触发事件，我们只要写里面的逻辑就可以了。_

[how search works](https://web.dev/how-search-works/)

> 非常简单了解搜索引擎是如何收集网页信息，爬虫，排序。下一步需要 SEO
>
> As of now, Google and Bing can index synchronous JavaScript applications just fine. Synchronous being the key word there. from [vue-ssr](https://vuejs.org/guide/scaling-up/ssr.html#why-ssr)

[1x1 大小色块的 base64 data url 字符串](https://stackoverflow.com/questions/5845238/javascript-generate-transparent-1x1-pixel-in-dataurl-format/33919020#33919020)

> 在看 nextjs [文档](https://nextjs.org/docs/api-reference/next/image)中的一个 [demo](https://image-component.nextjs.gallery/color)，通过色块 blur 作为 image 加载时的 placeholder。
>
> 里面用到的算法来自 stackoverflow，方法还是蛮离谱的。。
>
> ```typescript
> // Pixel GIF code adapted from https://stackoverflow.com/a/33919020/266535
> const keyStr =
>   "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
>
> const triplet = (e1: number, e2: number, e3: number) =>
>   keyStr.charAt(e1 >> 2) +
>   keyStr.charAt(((e1 & 3) << 4) | (e2 >> 4)) +
>   keyStr.charAt(((e2 & 15) << 2) | (e3 >> 6)) +
>   keyStr.charAt(e3 & 63);
>
> const rgbDataURL = (r: number, g: number, b: number) =>
>   `data:image/gif;base64,R0lGODlhAQABAPAA${
>     triplet(0, r, g) + triplet(b, 255, 255)
>   }/yH5BAAAAAAALAAAAAABAAEAAAICRAEAOw==`;
> ```
>
> 使用方法：`rgbDataURL(2, 129, 210)`
>
> 应该是掌握了生成这个 base64 的规律，直接可以替换 RGB/HEX

[HTTP 状态码 307/308](https://nextjs.org/docs/api-reference/next.config.js/redirects)

> 在 nextjs 中看到重定向所返回给浏览器的状态码不再是 301/302 了，而是用 307/308
>
> 原因是，很多浏览器对于 301（永久重定向）和 302（临时重定向）提供的二次定向地址会无脑采用 GET 方法去请求。。。
>
> 而 307（临时重定向）和 308（永久重定向）是可以保留原始请求方法的
>
> 对于爬虫而言，即使你的 url 是永久重定向到另一个，也并不希望损失这部分访问的用户，所以比如 GoogleBot 还是会将这个 url 加入索引的

[网页 SEO 入门](https://nextjs.org/learn/seo/introduction-to-seo)

> 依旧是 nextjs 的官方文档，对于 SEO 的了解还是很值得一读的。
>
> - SEO 的重要性不言而喻，让你的网站在搜索结果中更多的曝光
> - 搜索引擎（例如 Googlebot）是如何工作的
>   - 爬虫：有特定的 UA，比如 Googlebot Desktop 和 Googlebot Smartphone，根据 HTTP 状态码进行响应
>     - robots.txt 文件，告诉爬虫什么能进行爬虫，什么不能
>     - xml sitemaps，告诉爬虫哪些 URL 是属于你的站点的，当这个文件更新之后，谷歌也能更高效的判断出新的内容（适用于超大规模站点）
>     - `<meta>` 标签，控制爬虫/浏览器的一些行为，比如不要让谷歌浏览器自动翻译或者不让爬虫将网站加入搜索排名
>     - canonical URL，官方 URL，用来去除重复的 URL（多个站点内容一样，URL 很多），可以指定一个 URL 代表是一个官方的。
>   - 存档（index）
>   - 渲染 & 排名
>     - The most important thing for SEO is that page data and metadata is available on page load without JavaScript.
>     - 对于 CSR 页面，谷歌爬虫也会解析 JS 并渲染出内容，但不保证其他爬虫也能做到
>     - [AMP Accelerated Mobile Pages](https://amp.dev/) [是什么](https://zhuanlan.zhihu.com/p/511566210)
>     - 好的 URL 结构能带来更好的 SEO 效果（语义性，逻辑性，关键字，最好是没有参数的），nextjs 的路由定义可以帮助这些
>     - metatag，包含网站的摘要信息：title、description、[open graph](https://ogp.me/)（Facebook 发明的一种 protocol，能够更简单的打开链接并在分享的时候能展示出一些缩略的内容，比如在推特卡片展示）
>     - JSON-LD
>     - 内容（更高层次），单页 SEO 由 heading 和 link 来组织内容
>
> 最后，nextjs 提供了便捷的 API 在 SSR 去做这些

[现代 Web 开发的现状与未来](https://zhuanlan.zhihu.com/p/88616149)

> 2019 年的文章，来自 yangyang。可见 Web 的广度非常大。

[zen of Python](https://github.com/python/cpython/blob/main/Lib/this.py)

> `import this` 会出现的这段话，居然也是经过编码的。。维护系数 max

[sun to moon](https://codepen.io/lunar-dark/pen/QWjgMeW)

> 无敌样式的 Check box 的实现

[优先考虑标准](https://juejin.cn/post/7216772871018889275)

> 纠结 querystringify query-string qs 用哪个？
>
> 而不是考虑 浏览器端的 `URLSearchParams` 或 node 端的 `node:querystring`
>
> 软件提供了非常大的灵活性，所以开发者几乎有可能表达任何形式的抽象。但是，这种灵活性变成了一种难以置信的、诱人的属性，因为它也迫使开发者打造几乎所有的初级构建模块，高层的抽象将建立在这些初级构建模块之上。建筑行业对原材料的品质有着统一的编码和标准，但软件行业却很少有这种标准。结果，软件行业还是一种劳动密集型的产业。
>
> 拥抱标准吧

[Shebang](<https://en.wikipedia.org/wiki/Shebang_(Unix)>)

> `#!` number sign(hash) 和 exclamation 的组合，也叫 hashbang, sha-bang, sharp-exclamation
>
> 在类 unix 系统中，最开始有 shebang 的文本文件都会被认为是可执行文件，program loader 将第一行的剩余部分解析成一个解释器指令，然开始解析文件内容。。。
>
> 常见的 `#!/bin/sh`，node 命令行脚本 `#!path/to/node`

[tachyon](https://fasterthanlight.net/)

> 功能：在页面上 hover 超过 50ms 就将这个链接进行 prerender
>
> 大道至简，直接引入 script 即可用，有 白/黑名单，同源，响应时间的 API，通过 data-set 设置即可
>
> [代码](https://github.com/weebney/tachyon)也非常简单，通过对标签的鼠标进入/离开进行监听（MutationObserver body 内的元素），在 header 里面增加/删除 prerender 的 link
>
> 也存在一些问题：
>
> - SPA 是无效的
> - safari 和 firefox 的支持
>
> P.S [prerender](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/rel/prerender) 其实已经不推荐用了

[v8 对象属性访问](https://v8.dev/blog/fast-properties)

> V8 是如何处理动态新增的属性，让其的访问也能快速
>
> named properties（具体的 key）和元素（数组，整数下标）
>
> 两者存储的形式类似，都是连续的数组 or 字典，两者的存储是独立分开的
>
> ```javascript
> JS Object
> - hiddenClass
> - properties
> - elements
> HiddenClass
> - bit field 1 // 并不是 1 bit 而是一种结构体
> - bit field 2
> - bit field 3 // 这个结构中存了属性的数量 和 descriptor array 的指针
> ```
>
> HiddenClass：meta data，存储了一个对象的形状信息（shape）以及属性名到下标的映射
>
> - 属性的数量
> - 指向原型的引用
> - 随着对象的变化会动态更新
> - 相同构造的对象共享同一个 HiddenClass
> - V8 内部用一个 transition tree 来连接所有 HiddenClass，这样只要是按照一样的属性增加的顺序，最终得到的 HiddenClass 也是同一个（类似状态机流转状态，单向图），每次新增一个属性都会创建一个新的 hiddenClass
> - 增加数组的下标属性不会增加 hiddenClass，因为是存在另一个独立的 elemenst 区域
> - 指向 descriptor 数组记录了属性名和位置，以及值存在哪里
>
> **三种属性类型**
>
> in-object 属性 vs. 普通属性
>
> - in-object 是 v8 访问最快的属性，直接存储在对象内部
>   - 数量是由对象初始化的结构决定的
> - 普通属性：运行时新增的属性被加入到 **属性存储区**，多一层间接访问
>
> 普通属性又分：fast 属性 vs. slow 属性
>
> - fast：在 **属性存储区** 中可以线性访问的属性（直接通过下标）
> - slow：有慢属性的对象有一个内置的字典作为属性存储（不会在 HiddenClass 上共享），属性增加和移除是不会更新 HiddenClass 的，同时 inline cache 也不能作用，所以访问慢，但是增加和删除的效率高（不用改 hiddenClass）
>
> ```javascript
> Named Property:
> 1. in-object -> directly on the obj
> 2. Fast -> properties store; meta info -> descriptor array(HiddenClass)
> 3. Slow -> properties dictionary
> ```
>
> **对于数组元素**
>
> 如果数组中间有 hole `[1,,3]` 这样，对于下标 1 的访问会去 prototype 上的 elements 找，对于 elements 来说，也是 self-contained 的，不会在 HiddenClass 上共享
>
> 如果知道数组对象上没有 hole 就能认为是 packed 的，能够提升访问效率（不会去原型上找）
>
> 有 20 种数组[元素类型](https://v8.dev/blog/elements-kinds)。。。为的是 VM 可以根据特定的类型进行访问的加速。
>
> Fast or Dictionary 元素：
>
> - Fast：简单的 VM 数组结构
> - Slow：稀疏数组会通过字典来节省内存
>
> ```javascript
> const sparseArray = [];
> sparseArray[9999] = "foo"; // Creates an array with dictionary elements.
> ```
>
> Smi and Double Elements
>
> - Smi(Small Integers)，纯整数数组，整数是直接 encode 在数组中的，不会经历 GC
> - Double，纯浮点数数组 V8 stores raw doubles for pure double arrays to avoid memory and performance overhead
>
> ```javascript
> const a1 = [1, 2, 3]; // Smi Packed
> const a2 = [1, , 3]; // Smi Holey, a2[1] reads from the prototype
> const b1 = [1.1, 2, 3]; // Double Packed
> const b2 = [1.1, , 3]; // Double Holey, b2[1] reads from the prototype
> ```
>
> 每一种类型其实都通过 C++ 实现的 ElementsAccessor（基于 [CRTP](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern)），没有深入了解。简单来说像是一个代理，决定是哪种类型的数组。
>
> 知道如何访问属性是在 V8 中优化的关键，可以知道为什么某些代码写出来就是快！

[react wrap balancer](https://github.com/shuding/react-wrap-balancer)

> 又是 Shuding 的，太牛了。[在线 demo](https://react-wrap-balancer.vercel.app/)
>
> 核心功能是能够在容器宽度减少时，单行文字发生换行之后，让其更有可读性
>
> 比如 `React: A JavaScript library for building user interfaces` 这行标题
>
> 宽度很窄的时候，最好的换行时这样折叠（举个例子，意思差不多，具体可看 demo）
>
> ```json
> |      React: A JavaScript library       |
> |      for building user interfaces      |
> ```
>
> 而不是
>
> ```json
> | React: A JavaScript library for building|
> | user interfaces                         |
>
> ```
>
> 看了下源码，不多，也不难读
>
> 核心思路小结下：
>
> 1. relayout 函数
>    1. 初始化会执行
>    2. 元素 resize 发生变化会执行（**ResizeObserver**）
>    3. 干了什么？计算出一个最合适的 max-width 然后作用到文本元素（span）上
>       1. 二分法：取当前容器元素的 clientWidth 作为 upper，他的一半作为 lower，取中点 middle，将 middle 作为 max-width 更新 dom 的 style，此时检查容器的 clientHeight 是否改变，如果变了，就将 middle 作为下一次的 lower 进行计算，直到 lower 和 upper 逼近。
>       2. 其实就是取到了一个临界宽度，这个宽度能满足当前文字不会换行，但是再小一点，就换行了（宽度大了），二分法就是不断在试探当宽度减少时是否会发生高度的变化
>       3. 最后将这个宽度结合给定的 ratio 作为 max-width 设置给元素
> 2. 兼容 next.js SSR
>    1. 一些 props 直接挂在 dom 的 dataset 上
>    2. 通过 React.useId API 得到组件渲染的唯一 id，用于绑定这个元素独有的 relayout 方法
>    3. 将 relayout 方法 toString 后，render 的时候直接插入 script 标签注入
>
> 总之还是挺有意思的。
>
> 也得到个结论：换行后，单词越少其实越不好读？
>
> _React Wrap Balancer avoids single hanging word on the last line_
>
> 最后也提到这个项目也是收到 adobe 等项目的启发，还有 CSS [text-wrap: balance](https://drafts.csswg.org/css-text-4/#text-wrap) 这个提案可以深入了解

[ni use the right package manager](https://github.com/antfu/ni)

> 今天被公司的 n 个项目给“折磨”到了，不同的项目不同的包管理器装的依赖，npm/yarn/pnpm，每次都得看一眼 lock 文件是啥，于是就想着自己搞一个命令行工具检查当前的 lock 文件，执行对应的命令，想的挺美 `just dev/start`
>
> 于是回家打开 GitHub，用了 fu 哥的模版，琢磨着里头的 `ni` 是啥库，结果就是我想要的哈哈哈哈，太牛了。哎。
>
> 拿 npm 举例子：`ni` → `npm install`, `nr` → `npm run`

[web worker 综述](http://www.alloyteam.com/2020/07/14680/)

> Web worker 的深入好文，从几个方面展开
>
> 背景 & 发展历史：浏览器单线程机制，独立的 worker 线程能够带来的好处
>
> 运用场景、语言、环境、数据通信
>
> 兼容性、调试方法、配套工具
>
> 第三方库、业界实践案例

[造一个 copy-to-clipboard 轮子](https://github.com/haixiangyan/my-copy-to-clipboard)

> 封装一个复制到剪切板的功能，还是挺有意思的
>
> 作者也是参考[这个 npm 库](https://github.com/sudodoki/copy-to-clipboard/blob/main/index.js)的代码做了详细的解释，一个简单的复制方法东西也不少
>
> - 考虑用 span 解决兼容性问题，textContent 和 innerText 的区别
> - 复制时需要清空 selection range
> - 还原用户当时的选中交互（输入框聚焦、选中还原等）
> - 兼容 IE
> - 触发回调方法 `e.clipboardData` format 为了不让复制带有原来的样式
> - 样式兼容
>
> 最后 **Clipboard API**。Clipboard API 是下一代的剪贴板操作方法，比传统的 document.execCommand() 方法更强大、更合理。它的所有操作都是异步的，返回 Promise 对象，不会造成页面卡顿。而且，它可以将任意内容（比如图片）放入剪贴板。**另外还有一个问题，使用 clipboard API 需要从权限 [Permissions API](https://developer.mozilla.org/zh-CN/docs/Web/API/Permissions_API) 获取权限**

[css @property 让不可能变成可能](https://juejin.cn/post/6951201528543707150)

> [MDN](https://developer.mozilla.org/zh-CN/docs/Web/CSS/@property) @property CSS at-rule 是 CSS Houdini API 的一部分, 它允许开发者显式地定义他们的 CSS 自定义属性，允许进行属性类型检查、设定默认值以及定义该自定义属性是否可以被继承。
>
> `CSS Houdini` 开放 CSS 的底层 API 给开发者，使得开发者可以通过这套接口自行扩展 CSS，并提供相应的工具允许开发者介入浏览器渲染引擎的样式和布局流程中，使开发人员可以编写浏览器可以解析的 CSS 代码，从而创建新的 CSS 功能。
>
> 能够自定义属性，增强能力，比如让渐变色也可以进行 transition

[skia 剖析（深入 flutter）](https://segmentfault.com/a/1190000038827450)

> 移动 App：UI 库 -> 图形库 -> 低级图形接口 -> 硬件设备层
>
> Skia 的框架分析，字体、图片解析

[React FC 真的需要用吗](https://www.harrymt.com/blog/2020/05/20/react-typescript-react-fc.html)

>

[JS Ecosystem Is Delightfully Weird](https://fly.io/blog/js-ecosystem-delightfully-wierd/)

> 作者讲了 JS 的生态非常怪，但也是好的
>
> 不写纯 JS（框架、TS、...）、RSC 的 `'use server'` 这类让 JS 变成 meta programming language

[new in Web UI](https://www.youtube.com/watch?v=buChHSdsF9A)

> Now: 2023.05.16 18:48:15 +0800
>
> 谷歌团队介绍 web ui 新技术，个人比较关注的是 container query,`text-wrap: balance`, 新的 viewport 单位, cascade layer, popover, view transition（让 SPA 体验更接近原生！）

[Bun Bundler](https://bun.sh/blog/bun-bundler)

> _JavaScript started as autofill for form fields, and today it powers the instruments that launch rockets to space._
>
> bun 运行时推出的内置构建器，非常快，等啥时候用了在体验吧

[useIsomorphicLayoutEffect?](https://usehooks-ts.com/react-hook/use-isomorphic-layout-effect)

> 好奇的搜一下之前看到的 `useIsomorphicLayoutEffect` 到底意义何在，起初只是认为是做 SSR/CSR 的兼容
>
> 包括 dan 的 [gist](https://gist.github.com/gaearon/e7d97cdf38a2907924ea12e4ebdf3c85) 也解答了，如果在 CSR 非常需要 `useLayoutEffect` 在 dom 变化后立即需要的 effect，但是又是 SSR 场景，会在服务端渲染的时候报错，所以可以在服务端使用 `useEffect`（即使这两个在服务端都不会执行），来满足这个场景。
>
> 代码非常简单
>
> ```jsx
> import { useEffect, useLayoutEffect } from "react";
>
> const useIsomorphicLayoutEffect =
>   typeof window !== "undefined" ? useLayoutEffect : useEffect;
>
> export default useIsomorphicLayoutEffect;
> ```

[what happens when...](https://github.com/alex/what-happens-when)

> 老问题：当在浏览器的地址栏中输入 url 按回车发生了什么
>
> 这个仓库回答的非常详细，除了传统的流程，甚至还提到了硬件（键盘）。还是挺值得收藏和回顾的。

[HTTP3](https://en.wikipedia.org/wiki/HTTP/3)

> 也是从左耳朵耗子在字节内的演讲中听到的，目前基于 tcp 协议的网络传输已经到达一定的天花板，性能受到 tcp 的拥塞控制（congestion control）限制，Http3 协议是基于 [QUIC](https://quicwg.org/) 协议，基于 UDP 的多路复用（multiplexed transport protocol）
>
> [这一篇](https://www.debugbear.com/blog/http3-quic-protocol-guide)后续可以深入看 HTTP3 和 QUIC
>
> 在来一篇[交互式 QUIC 协议说明](https://cangsdarm.github.io/illustrate/quic)，非常好的教材，阐述了每一个字节的解释和再现，[英文版](https://quic.xargs.org/)（[github](https://github.com/syncsynchalt/illustrated-quic)）

2023.05.25 13:41:11 +0800

[Deep Dive Into React Fiber](https://blog.logrocket.com/deep-dive-react-fiber/)

> 非常深入理解 React Fiber 的一篇文章，22 年的，篇幅较长
>
> 解答了几个名词：
>
> - Fibler：React 内置的引擎，使得 React 快和聪明（对于处理状态变化，而更新 UI 渲染的过程），从 React16 开始成为默认的 reconciler，是 reconciliation 算法的重写
>   - 全异步的（不阻塞主线程）：可以暂停、继续、重启渲染过程，复用已完成的渲染、取消渲染，拆分任务按照优先级处理
> - `<App />`：React element，一个普通对象，表达了组件实例和 DOM 节点以及它所需要的属性
> - stack reconciler：
>   - Fiber 之前，reconciliation 是递归的遍历，导致了一次 dom 更新是同步的，复杂的情况会导致耗时增加，下一次渲染时间间隔大于 16ms 会出现掉帧的情况，影响体验
> - reconciliation：
>   - 方便 React 进行 DOM 树的遍历和解析，整个过程叫做 reconciliation
>   - 在此之后就会调用 renderer（`react-dom` or `react-native`）进行真实元素更新
>   - `ReactDOM.render()` or `setState()` 的调用就会开始一次 reconciliation
>
> `ReactDOM.render(<App />, document.getElementById('root'))` 发生了什么？
>
> React Fiber 是如何工作的：
>
> - Singly-linked list of fiber nodes，每个 fiber 节点单个连接的链表结构，已 parent-first depth-first 深度优先的顺序进行遍历，包含
>   - Type
>   - Key
>   - Child
>   - Sibling
>   - Return
>   - Alternate
>   - Output
> - 会同时存在两颗树（current 和 workInProgress），已经渲染的树和本次 conciliation 过程要生成的树
> - 具体每个函数做了什么，和整个树是怎么遍历的，文章中有详细介绍
>
> 最后是 commit 阶段...
>
> 个人感觉还是需要结合代码（比如 fre）走一遍

clientWidth clientHeight 耗时那么久？是在计算样式？

> force reflow in perforamance dashboard

[回顾 exa modern ls](https://the.exa.website/introduction)

> 重新看了下 rust 写的现代 `ls`，也了解到 `ls` 这个指令已经出现了 40 多年之久（1970s，最早叫 `listf`），那时候和 unix 交互还是通过 _teletype_（一个硬件设备通过键盘输入指令和 Unix 计算机交互，最终输出到屏幕上）。
>
> 如今个人电脑的发展，这些已经集成到电脑中，teletype 也变成了软件，每次新开一个 terminal，OS 就会连接到一个新的 pty（pseudo-ttp or pseudo-teletype）。
>
> 现在的 terminal（terminal emulator）将字符流转换为屏幕上显示的字符网格，大多都支持了 ANSI 转译字符，输出颜色（exa 的最大特性之一）
>
> 还值得说的是我才发现 exa 是自带 [tree view](https://the.exa.website/features/tree-view) 的 `exa --tree --level=2 --long`，`exa -T src/ -D` 输出仅目录的 tree view（-D 仅目录）
>
> 集成了 git 文件的信息 `exa --long --git`
>
> 还有 icon 展示，真棒 `exa --icons`（需要 nerd 字体）

[about dependencies](https://sunshowers.io/posts/dependencies/)

> 关于依赖的很多观点，文章比较长，从 python，npm 到 rust，讲了一些处理依赖的问题，比如 diamond dependency、left pad 删 npm 库之类的，主要是讲了 rust 的 cargo，也有一些细节（不允许删库、处理 diamond 优先找他们公共符合的版本）。
>
> 最后上升到 who can we believe。我们到底该信任谁写的代码
>
> evaluating third-party dependencies requires new models that combine technical and social signals.

[react lazy load with webpack 处理异常](https://raphael-leger.medium.com/react-webpack-chunkloaderror-loading-chunk-x-failed-ac385bd110e0)

> chunk 是拆分组件比较常用的手段，经常会有上报
>
> `Loading chunk 6 failed.(missing:https://WEB_SERVER.com/82fbafaa3a.CHUNK_NAME.js)`
>
> 意味着加载这个 js 资源失败了，通常是这个资源没有了，稳重举的例子是用户在浏览的时候恰巧我们更新了最新的资源，覆盖了原来带有 hash 的资源文件，或者是被缓存的 html 请求了老的不存在的资源。
>
> 但是现实场景是资源明明也都在，但是 load css 资源失败了，css 的加载时通过编译时候 [minicssextract](https://webpack.js.org/plugins/mini-css-extract-plugin/) 插件插入的 `link` 标签的 onerror 的时候会抛出错误。还需要查一查

[Lua 语言初见面](https://matt.blwt.io/post/lua-the-little-language-that-could/)

> 来自马老师的分享，精巧的小编程语言，非常简单、可编译、可集成，Redis 里也集成了 Lua，甚至可以写 World of Warcraft 的插件。记得 [neovim](https://github.com/neovim/neovim) 也有 lua 的部分
>
> [十五分钟学 Lua](https://tylerneylon.com/a/learn-lua/)

2023.06.06 17:08:43 +0800

[tsconfig lib and target 的区别](https://www.claritician.com/typescript-lib-vs-target-what-s-the-difference)

> 先有的 target 配置，目的是告诉 ts 最终输出的 js 代码语法，可以是 `ES5` 适配低级浏览器
>
> lib 是后出现的，默认是根据 `target` 字段，ts 会引入对应语法版本的类型声明，这样代码中的语法就不会报错了，但是并不会引入 polyfill，代码输出后只是转换了语法
>
> 所以当我们需要用到新的方法比如 `Promise.allSettled`, `String.matchAll` 需要在 `lib` 字段声明更高的 es 版本（`ES2020`），如果需要支持 browser api，需要加入 `dom`

[移动端 H5 唤起 App](https://mp.weixin.qq.com/s/cpDgqG8LoHcn77m1-xe7fA)

> 大家熟知的 deeplink universal link、url schema，做一个记录
>
> 目的就是将 h5 用户引流回 App（广告投放、拉新）
>
> 只是简单的介绍了可以通过多种 url 拉起 app 的几种方法，至于 App 需要做什么并没有说（也是需要配置的，比如 IOS 的 Universal Link）

[system design blueprint](https://blog.devgenius.io/system-design-blueprint-the-ultimate-guide-e27b914bf8f1)

> 系统设计蓝图/cheatsheet，非常全面的对系统改怎么做、每个模块都有设计指南。
>
> 粗看了一遍目录，马着之后用

[google 单代码仓库看工程文化](https://mp.weixin.qq.com/s/8i-lrk_URPEgCJ62M4oeWA)

> 2016 年的文章了
>
> Google 在 Communication of the ACM 上发表了一篇文章，介绍 Google 独特的单代码库模式，题为《Why Google Stores Billions of Lines of Code in a Single Repository》
>
> 虽然不是论文原文，但是感触还是挺大。数十亿行的代码仓库，必须有相应的配套设施和制度才能玩得转。Google 的工程文化还是令人尊敬和佩服，值得参考。

[H5 性能极致优化](https://mp.weixin.qq.com/s/zJMM4SF7pc6LZPCsQfWOxw)

> 比较全面的 端 → 页面加载/渲染/CDN 优化手段说明，挺好的，收藏

[ffmpeg](https://ffmpeg.org/) 踩坑

> 写脚本批量压缩图片的时候，发现 ffmpeg 会把输入的文件名的第一个字符干掉，[这个回答](https://stackoverflow.com/questions/60766097/bash-deletes-the-first-letter-from-line-ffmpeg)解答了

[using prettier wrong?](https://www.youtube.com/watch?v=Cd-gBxzcsdA)

> theo 的视频
>
> 简单 sum 一下，观点是 formatting 和 linting 就是两个独立的事情，eslint 和 prettier 独立的两个工具
>
> - linter 会分析代码逻辑、有一套套规则
> - formatter 就是根据规则
>
> eslint 推荐用 eslint 去配置 prettier，而 format 的工作交给 prettier（我司内部的研发框架里面就是这样做的，vscode 配置默认的 formatter 是 prettier）
>
> Prettier 只需要一趟就可以完成 format，eslint 可能需要多 pass（分析）
>
> _Use prettier for code formatting concerns, and linters for code-quality concerns._
>
> 但是回想 antfu 就直接用 eslint [一起做了两件事](https://antfu.me/posts/why-not-prettier)（之前也记录过这篇阅读），原因有几个一个是 prettier 不可关闭的 printwidth 换行会造成 git diff 看不出真正的 diff（但其实可以有其他[工具](https://dandavison.github.io/delta/introduction.html)看出，但 github 貌似还没集成？公司里面是有的），还有就是两者都需要很多配置，而 eslint 能够完全配置（prettier 主打一个开箱即用，配置预设）
>
> 后续再深入了解两者吧。。个人感觉就是配置都很繁琐，哪个方便用哪个，团队统一配置即可。

[obsidian 结合 gatsby 制作 digital garden](https://dev.to/joeholmes/creating-a-diy-digital-garden-with-obsidian-and-gatsby-378e)

> 在搜 obsidian 支持 mdx 的[官方论坛](https://forum.obsidian.md/t/expand-the-plugin-surface-by-using-mdx/5925/6)讨论中看到的，还挺有意思的，主要是实现静态文档站点（JAMStack，javascript & API & Markup）具有双链文档的能力，但是 gatsby 确实不太了解。感觉也要写不少代码哈哈。

[flexsearch](https://github.com/nextapps-de/flexsearch)

> 应该是最快的 full-text search library，比之前用的 fusejs 应该厉害不少，也是 extra 用的
>
> 还有 https://docusaurus.io/ 用的是 [Algolia](https://github.com/algolia) 也很牛，但也不了解，收藏下。

2023.06.21 19:04:25 +0800

[queue 任务队列控制器](https://github.com/jessetane/queue)

> 源码很精简，非常简单。可以控制并发数、异步（Promise）任务、数组控制、支持超时、结果收集，挺牛的！
>
> 通过 event 的形式通知是否结束、异常
>
> - Event 是直接继承的 [EventTarget](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget)
>   - Node 和 浏览器都支持
>   - 一个能监听/发出事件的对象
> - 自定义了 QueueEvent，增加了 detail 的 caller 和 error

[apply vs ... 解构](https://www.measurethat.net/Benchmarks/Show/25806/0/apply-vs)

> `a.fn.apply(a, args);`
>
> `a.fn(...args);`
>
> `a.fn(args[0], args[1], args[2], args[3])`
>
> 三种方式的执行效率，居然用解构是最快的，神奇，不知道为什么，还是得深入 v8 啊，写符合 vm 优化的 js 代码
>
> “对性能已经如此敏感，js 这门语言本身就有大问题了” 哈哈

[ls-lint](https://github.com/loeffel-io/ls-lint)

> 挺不错的工具！能够扫描文件名是否满足命名规范
