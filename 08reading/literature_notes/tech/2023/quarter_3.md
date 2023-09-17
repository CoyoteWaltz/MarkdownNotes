[v8 shape inline cache](https://mathiasbynens.be/notes/shapes-ics)

> 视频来自 JS Conf EU 2018
>
> Chrome、Firefox、Edge、Safari 都有各自的 js engine
>
> 还是聚焦于 js 的对象，js 引擎可以通过对象的“形状（shape）”，也叫 hidden class
>
> 对象的基本操作就是访问属性了，在引擎层是一个寻址的过程，多个结构相同的对象之间可以共享一个 shape，这样就能节省很多空间
>
> transition chain：当对象的结构（shape）发生变化时，会通过一个链式的结构去记录**增量**的变化，每个结点会指向他前一次变化的节点，每一个节点都包含了新增的属性和他们所在的 offset，通过这个 offset 就可以寻址到 value
>
> transition tree：相同结构开始的不同对象，分别增加不同的属性，构造一棵树的 transition chain
>
> 属性访问过程：
>
> `a = {x: 1}; a.x = 6; b = {p: 12, x: 3};` 这样的情况，其实就有两颗根节点（`{x}` 和 `{x, p}`）
>
> 当继续添加 `b.y = 4; b.z = 3` b 的 chain 就会从 `{x, p} -> {y} -> {z}`，同理 a 也增加 z 和 y 和 p 属性 `{x} -> {y} -> {z} -> {p}`，访问 `a.z` 的时候，就从 p 一路向上寻找到 z，其实会比 `b.z` 访问多一次，也就慢一些
>
> 访问 `b.z`：
>
> 1. 找到 b 对象对应的 hiddenClass（shape）
> 2. 在 shape 上寻找他的 z（back chain look up）
> 3. 找到 z 属性的 offset 信息
> 4. 通过 offset 找到对应的 value
>
> inline-cache：**记忆从哪里去寻找 js 对象属性的信息**，不用每次都进行很复杂的向上寻找
>
> - 对于 Object：根据相同的 shape 缓存每个属性的 offset 信息，直接寻址
> - 对象的 shape 变化，就会导致 IC 失败，需要重新进行缓存
> - 对于 Array：之前也学到过数组的 shape 会有 `length` 属性，其元素是放在 elements store 去存储的，不会存储属性值
>   - 如果用了 `Object.defineProperty` 在数组上（别这么做！），Elements store 实际上会变成一个 dictionay，key 是数组下标，value 是对应元素（常规的属性，enumable/configurable/writable）
>
> 视频也只是对 hiddenClass 和 inline cache 的概念做一个初步的介绍，并且给出了一些编码建议（基于 vm 优化特性）：
>
> - 让 js 对象的 shape（结构）尽可能保持不变，让 hiddenClass 保持不变
> - `Object.defineProperty` 别在数组上使用
>
> BTW 视频还是非常不错的！

[Million.js block](https://million.dev/blog/virtual-dom)

> [github](https://github.com/aidenybai/million) 已经 10k 的 star 了（2023.06.26 17:15:41 +0800）
>
> 是一个 react/preact 的 virtual dom 的替代方案，并不是一个完整的 UI 框架，而是在 React Component 上 hook 一层，来接管渲染，让组件渲染更快。
>
> link 的 blog 也是 block（million js 的核心组件）背后的原理
>
> - virtual dom 在某些场景上的性能确实不太行 diff 一整棵 vdom 树消耗很大（reconciliation），从而催生了 nodiff 的一些框架比如 svelte、solidjs
> - Block Virtual Dom：**Diff the data, not the DOM.**
>   - **Static Analysis**: 在编译阶段分析模版结构，记录动态的部分，生成一个 Edit Map 结构
>   - **Dirty Checking**: 运行时 diff state，根据 Edit Map 变更对应 dom 即可，无需 diff tree
> - 不是银弹，这样的 dom 改动方法并不一定在所有场景都会比 virtual dom 快
>   - 更加适合：
>     - 静态内容多，动态内容少的组件。这样就无需关注大量不会改动的内容（no diff）
>     - 列表结构
>   - 不适合：
>     - state 比 dom 还多的组件
>     - 非 stable 的组件，返回结构不稳定
>   - 细粒度的使用，而不是所有组件全都用
>
> Despite its potential, **it is not a one-size-fits-all solution, and developers should evaluate the specific needs and performance requirements** of their applications before deciding whether to adopt this approach.
>
> 一些启发：web 的渲染效率意味着 dom 的变更效率，不同算法对于不同的 dom 结构也有其优势所在，所以精细化优化最终也近似于手动 dom 优化 hah

[2023 前端开发者重点](https://zhuanlan.zhihu.com/p/631879733)

> 重点速览：（摘录一些自己觉得重要和感兴趣的）
>
> - 重新思考 web 兼容性：主流浏览器推出了一个 [web 基线](https://web.dev/baseline/)的东西，用这个去替代 browser-list？不用再以老的浏览器作为兼容性标准了
> - web 平台：
>   - dialog 标签：原生的对话框（自动展示在所有元素前）
>   - SVH，LVH：`Small Viewport` 和 `Large viewport`
>   - structuredClone
>   - Import Maps：你指定模块名称并将它映射到 `URL` 上。当你在代码中使用 `import` 语句时，浏览器会自动查找 `Import Map`，并从 `URL` 中加载相应的模块。
> - 性能：
>   - LCP 优化建议：静态 `HTML` 中的图片资源更易于被发现，这有可以让浏览器的预加载扫描程序更早的找到并加载它。
>   - fetch proirity：允许标记资源的优先级，能够让浏览器更早的开始下载他们
>   - [CLS](https://web.dev/i18n/en/cls/) 优化建议：网页视觉稳定性的度量指标，页面有新增内容时，是否会经常跳动。保持内容能够被显示的缩放
>   - 去除不必要的 JS：devtool 自带了 coverage 能力？
> - chrome devtools 调试新姿势
> - 第三方 cookie 的终结：chrome 将在未来停止支持第三方 cookie
> - Passkeys 可能淘汰传统的 Web 密码登陆方式

[INP(interaction to next paint)](https://web.dev/inp/)

> 虽然还是说 pending Core Web Vital metric（核心性能指标），会在 2024 年 3 月替换 FID(First Input Delay)
>
> 这个指标是测量交互事件的响应性能的，一个网站最后上报的数值是一个，会取所有交互响应速率的最大值（公式）
>
> 比较好理解，就是让网页有一个好的响应性能，比如点击、键盘敲击之后，不能让浏览器渲染下一帧太慢（js 计算别太久），这样用户的连贯体验就很好，不会卡
>
> 如何计算：会收集一个页面上所有的交互响应，然后根据不同交互复杂度的页面按照不同百分位进行取值，有一个特定的算法（交互很少的页面，就去 100 分位，多一些交互的就取 99 或者 98 分位）
>
> 如何界定：给了一个标准，`不错 <- 200ms <-需要提升-> 500ms -> 不太行`
>
> **只有点击、键盘输入、tap，滚动和 hover 不会算入 INP**
>
> 和 FID 的差异：FID 只会记录第一次交互，可以算是一个 load responsiveness metric，INP a more reliable indicator of overall responsiveness than FID.
>
> JS 中如何计算：
>
> ```javascript
> new PerformanceObserver((entryList) => {
>   for (const entry of entryList.getEntries()) {
>     if (entry.interactionId) {
>       const duration = entry.processingEnd - entry.startTime;
>       console.log("Interaction:", entry.name, duration, entry);
>     }
>   }
> }).observe({ type: "event", buffered: true, durationThreshold: 16 });
> ```
>
> or
>
> ```javascript
> import { onINP } from "web-vitals";
>
> onINP(({ value }) => {
>   // Log the value to the console, or send it to your analytics provider.
>   console.log(value);
> });
> ```
>
> further reading → [如何优化 INP](https://web.dev/optimize-inp/)
>
> 个人感觉就是不要执行长任务阻塞线程渲染，拆任务；不要 enqueue 很多微任务，拆成宏任务；还有类似 isinputpending 的机制，交还给浏览器执行权

[2023 web framework 性能报告](https://astro.build/blog/2023-web-framework-performance-report/)

> astro 3 月的 blog
>
> 通过 [Core Web Vitals](https://web.dev/learn-core-web-vitals/)（LCP、FID、INP、CLS）对各个主流建站框架 Astro、Nextjs、Nuxt、Remix、Gatsby、SvelteKit（非 React/Vue 这类 UI 渲染框架）进行性能测试
>
> 效果确实是 Astro/Sveltekit/Remix 会更好些（个人感觉是因为 no diff）
>
> 除此之外还有 lighthouse 测试和 JS payload 测试（astro 几乎可以是 0 js 的）
>
> 用的数据是
>
> - [The Chrome User Experience Report (CrUX)](https://developer.chrome.com/docs/crux/)
> - [The HTTP Archive](https://httparchive.org/)，能看有多少 url/请求/js/图片等，还是很有意思的
> - [The Core Web Vitals Technology Report](https://discuss.httparchive.org/t/new-dashboard-the-core-web-vitals-technology-report/2178)

[（SSR）hydration tree/resumability map](https://www.builder.io/blog/hydration-tree-resumability-map)

> 分析了现代 SSR hydration 的模式
>
> 所谓 hydration 的定义：
>
> - 在 SPA 框架中让页面变得可交互，需要重新从 root 节点开始执行 app，覆盖在服务端生成的纯 HTML 上的 state 和 event handlers
> - O(n) 的算法效率（N 是组件数，遍历每个组件）
>
> Partial hydration：
>
> - Astro 框架的核心架构：会构成多个 root（island）组件进行水合，但是组件之间是独立的，不方便数据通信
>
> RSC（React Server Component）：
>
> - **Sparse Hydration**，using 'use server' or 'use client' 来定义客户端组件边界
>
> Resumability：（QWIK 的架构，builder.io 的）
>
> - 完全不一样的算法，[O(1) 的效率](https://www.builder.io/blog/our-current-frameworks-are-on-we-need-o1)
>   - 读了这篇继续讲 QWIK 的新算法，背景是随着页面交互不断复杂和丰富（and JS UI 框架），网站请求的 JS 资源量越来越多（httparchive.org 的统计）
>   - 执行 JS 变得高效吗？CPU 虽然每年都在变快（摩尔定律）但是 JS 是单线程，分配给 CPU 的也只有一个内核，繁重的 JS 工作并不能利用 CPU 的并行提高效率。
>   - UI 框架随着组件增多（复杂交互）对于 JS 产物的体积也是线性增长（y = mx + b）
>   - O(1) 的目标：懒加载水合，思路和 SPA 路由拆 chunk 懒加载一样，把懒加载放到了交互层 hydration 上。这样首屏仅需很少的 js 进行渲染，用户交互要发生了才加载对应的 hydration code
>   - **_frameworks are O(n). This is not scalable._**
>   - 最后问题来了，如何实现的？（之前有记录过，可以搜搜看）文章只是简单介绍

[对 React 和 Vue 的看法](https://cali.so/blog/react-or-vue-my-take-on-web-dev)

> 前端真的太多框架了！太多工具了！（一个项目的配置文件就有一大堆！）
>
> 这篇 blog 也是从几个方面对比了 React 和 Vue：
>
> - 产品现状：国内外大项目对 React/Vue 的使用情况，Vue 还是少
> - 设计工程师：例举了挺多人的（有 shuding），大多都是 React，Vue 只有 anthfu
> - 多用性：React Netive 不必多说；命令行应用 [ink](https://github.com/vadimdemedes/ink) 以后可以详细了解下
> - 开发者体验：anthfu 新出的 [NuxtDevTools](https://nuxt.com/blog/introducing-nuxt-devtools) 很强大，以后试一下
> - 生态：两个都不错
>
> [作者](https://cali.so/)看着也是个大佬，收藏下

[Web Cache API](https://web.dev/cache-api-quick-guide/)

> 从 Qwik 框架看到说利用了 cache api（service worker），于是乎看了下 [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Cache)
>
> 发现并不能完全看下去。。找了 quick intro 看看
>
> 浏览器将缓存能力暴露成 API 给 javascript 使用，能够更加自定义的使用缓存，读取缓存。
>
> 主流浏览器都支持了这个 API（全场景可用：window, iframe, worker, or service worker.）
>
> `const cacheAvailable = 'caches' in self;`
>
> 可缓存：
>
> - 一组 `Request` 和 `Response` 对象（http 的请求/返回，即 http 可传输的任何类型的数据）
>
> 缓存大小：很大
>
> 创建/打开一个缓存：
>
> - `caches.open(name)` 给一个缓存名，如果不存在这个 namespace 则会新建一个，return 的是一个 Promise
>
> 添加缓存：
>
> - `cache.add(URL or Request)`：对某个网络请求进行缓存，请求失败（非 200），不会存储任何东西并且 Promise reject
> - `cache.addAll([])`：类似，如果其中一个失败，Promise 就 reject
> - `cache.put(Request or URL, Response)`：允许创建任意的 Response 缓存
>
> Response 对象：
>
> - 可以是 Blob、ArrayBufer、FormData
>
> - 可以设置 MIME type
>
> - ```javascript
>   const options = {
>     headers: {
>       "Content-Type": "application/json",
>     },
>   };
>   const jsonResponse = new Response("{}", options);
>   ```
>
> 获取缓存 `cache.match`
>
> 搜索缓存：API 没有直接的能力，但是可以自己实现（文章给了搜 png 缓存的例子）
>
> 删除：
>
> - 删除一个缓存 item：`.delete(Request)`
> - 删除一个缓存 namespace：`caches.delete(name)`
>
> 问题来了：缓存是有同源策略的吗？Yes，在 MDN 能找到“An origin can have multiple, named `Cache` objects.”

[Waterloo Style](https://theprogrammersparadox.blogspot.com/2023/04/waterloo-style.html)

> "The primary understanding is that you should ignore the code. It doesn’t matter. It is just a huge list of instructions for the stupid computer to follow."
>
> "Instead, focus on the data. Figure out how it should flow around."
>
> Programming == Data Structure + Algorithm

[Batch updates in React 18](https://github.com/reactwg/react-18/discussions/21)

> 依旧是 Dan 写的 discussion about Automatic batching
>
> batch update 能够避免多次 setState 导致重复 render，从而提升性能和体验
>
> 在 react 17 已经在浏览器点击事件的 callback 中自动做了 batch update
>
> react 18 更是自动的在所有场景都进行了 batch，不过需要通过使用 [`ReactDOM.createRoot`](https://github.com/reactwg/react-18/discussions/5)（替换 render）开启，在所有的 callback 中都是自动 batch 的，意味着
>
> ```tsx
> function handleClick() {
>   setCount((c) => c + 1);
>   setFlag((f) => !f);
>   // React will only re-render once at the end (that's batching!)
> }
> ```
>
> 如果不需要 batch，需要用 `flushSync`（`react-dom`）来包裹
>
> 同样 `unstable_batchedUpdates` 这个 API 在 React18 中还是保留

[new root API in React 18](https://github.com/reactwg/react-18/discussions/5)

> 依然保留了 17 之前的渲染方法 `ReactDOM.render`
>
> 新增了 React18 `ReactDOM.createRoot`
>
> - 先 create root，再 render：相比 `render` 来说可以不用每次都传入 container 了（`ReactDOM.render(<App tab="home" />, container)`），可以更方便的改动 render 的内容
> - 去掉了 render 之后的 callback：为了在部分/渐进 SSR 这个 callback 的时机是不太对的，推荐这么做 ⬇️
>
> ```jsx
> import * as ReactDOMClient from "react-dom/client";
>
> function App({ callback }) {
>   // Callback will be called when the div is first created.
>   return (
>     <div ref={callback}>
>       <h1>Hello World</h1>
>     </div>
>   );
> }
>
> const rootElement = document.getElementById("root");
>
> const root = ReactDOMClient.createRoot(rootElement);
> root.render(<App callback={() => console.log("renderered")} />);
> ```

[CommonJS is hurting js](https://deno.com/blog/commonjs-is-hurting-javascript)

> Deno 的 blog
>
> 讲述了 NodeJS 推出 CommonJS 作为服务端 JS 运行时模块化的历程，以及存在的核心问题：
>
> - **module loading is synchronous**.
> - **difficult to tree-shake**
> - **not browser native**
>
> 以及 TC39 推出 ES Module web-first 模块化
>
> NodeJS 目前同时支持 CommonJS 和 ESM，但还是给开发者带了不小的问题（同时输出两种产物 & 构建过程很繁琐）
>
> 不过存在即合理，当时 CommonJS 确实解决了 JS 模块化很大的问题
>
> [Other module authors have found success supporting CommonJS and ESM](https://frontside.com/blog/2023-04-27-deno-is-the-easiest-way-to-author-npm-packages/) using [dnt](https://github.com/denoland/dnt).
>
> 可以深入下 node，寻找到更好的 npm 包输出姿势

[Deno U don't need a build step](https://deno.com/blog/you-dont-need-a-build-step)

> Deno 的 blog，围绕现代 web 构建方面的内容（编译时间摸鱼是如此常见）
>
> 三个部分：
>
> 1. **为什么前端的构建会出现：**古早的时候 js 的拆分通过 script 标签就可，当 Node 出现后，可以写非浏览器端的 JS，可以模块化、框架、CSS 后处理、编译到 es5、TS/TSX、...（列举了一系列为什么需要构建的原因），**这里的 trade-off 即 DX v.s. Build Complexity**
> 2. 打包工具的兴起：Browserify 到 Vite、Turbopack
> 3. 构建的四个步骤（Nextjs 举例）
> 4. 推荐了 Deno 无需构建步骤，和 [Fresh](https://fresh.deno.dev/) 框架：Deno runtime 本身就是完全支持 web 标准（所以为啥抛弃 Node 去搞 Deno 了。。），JIT 构建，利用了直接通过 url import 的特性 + SSR 直接输出浏览器，JIT 转码，通过 deno-runtime 可以直接在浏览器中使用 TS/TSX
>
> Deno 看来也是很不错的，有机会尝试下！
>
> BTW：[依赖可视化工具](https://github.com/sverweij/dependency-cruiser)、[打包器教程（经典）](https://github.com/jamiebuilds/the-super-tiny-compiler)

[【TODO】Modules In Typescript](https://gist.github.com/andrewbranch/79f872a8b9f0507c9c5f2641cfb3efa6)

> 文章主要介绍 TS 是如何处理模块的
>
> 上古时期，JS 的拆分还是通过多个 script 标签插入到 HTML，当项目变得逐渐复杂，页面需要加载完所有的 js 才能渲染页面，并且所有的变量都是全局作用域，所以写变量/方法的时候还得非常小心
>
> 模块化，在自己的作用域中处理代码，并且能提供给其他文件一些代码的文件
>
> JS 有非常多模块化系统/方案，TS 支持输出[一部分类型](https://www.typescriptlang.org/tsconfig#module)（CommonJS(default)、UMD、amd、esNext...none）
>
> _The TypeScript compiler’s chief goal is to look at input code and tell the author about problems the output code might encounter at runtime._
>
> 编译器需要知道这些代码在 runtime 的环境，比如是否是全局的
>
> 编译器在处理 module 的时候概括的任务是：Understand the **rules of the host** enough
>
> 1. to compile files into a valid **output module format**,
> 2. to ensure that imports in those **outputs** will **resolve successfully**, and
> 3. to know what **type** to assign to **imported names**.
>
> Host 的定义，一句话来说就是真正消耗输出代码来指导模块加载行为的系统。
>
> 有点看不下去了。。以后再看

[Use Deno author packages](https://frontside.com/blog/2023-04-27-deno-is-the-easiest-way-to-author-npm-packages/)

> frontside 公司的 blog（并不太了解是什么公司）
>
> 介绍了从 deno 发布 package 到 deno.land 和 npm
>
> 文中提到 Deno 的 DX 很不错，开发 deno 会比 node 的压力少 900% 哈哈，而且发布的包版本并不是依赖 `package.json`（deno 也没有这个），而是直接用 git tag，约定俗成只有带有 tag 才认为是 release
>
> 具体流程：
>
> 1. 一次 tag 发布两次，约定带有版本号的 tag 就是需要发布的，`v1.2.3` 或者 `package-xxx-v2.3.1`
> 2. 构建 + 发布
>    1. 发布到 deno.land 非常自然，文中说只要注册 web hook 然后 release 带 tag 即可让 deno.land 进行发布
>    2. 发布到 npm
>       1. 通过脚本获取版本号，构建出 npm package
>       2. 通过 GitHub workflow 监听 release tag 然后执行发布脚本
>
> 发布 npm 的工具是 deno 提供的 [dnt](https://github.com/denoland/dnt)，非常强大的工具能够通过 esm 入口生成一个完整能力的 npm 包作为输出，并且支持 ts 转码、处理依赖、生成 esm/commonjs 总之都集成好了。
>
> 并且给出了他们实践的例子：[构建 npm 脚本](https://github.com/thefrontside/graphgen/blob/v1.8.1/tasks/build-npm.ts)、[npm workflow](https://github.com/thefrontside/graphgen/blob/v1.8.1/.github/workflows/npm-release.yml)
>
> 文笔还挺不错，还是想去尝试一下 deno！

[ts 迭代对象](https://fettblog.eu/typescript-iterating-over-objects/)

> 一篇关于 typescript 里比较优雅姿势的对象属性访问，JS 中最简单的就是 `Object.keys`，但 ts 里的类型返回的永远是 string，这样访问对象会直接暴红，文中给出了用泛型让 TS 更好的进行类型约束
>
> ```typescript
> function printPerson<T extends Person>(p: T) {
>   for (let k in p) {
>     console.log(k, p[k]); // This works
>   }
> }
> ```

[cicada CI/CD 平台](https://cicada.build/)

> CI/CD platform，看了[仓库](https://github.com/cicadahq/cicada)又是 rust 写的。
>
> Use TypeScript SDK to write pipelines, test them locally, then run them on every PR in our ultra-fast cloud
>
> TS SDK 好评，不用写恶心的 yaml/toml
>
> 感觉是刚起步的项目？，个人是免费，团队使用就要开始收费了，不错

[聊聊架构](https://juejin.cn/post/6844903801053249543)

> 掘金上随便看看
>
> “架构是为了满足具体的业务的发展而做出的一整套的解决方案。”
>
> 架构就是为了实现业务而为技术实现设计的“蓝图”，这张蓝图就是上述所说的**解决方案**和**规范**。
>
> 业务方向：稳 & 可扩展，深入业务、更好的支撑业务扩展
>
> 使用者：高效 & 简洁，任何解决方案/规范肯定要考虑开发者的体验，一线员工深有体会 T_T
>
> 如果有更好的架构意识：
>
> 1. 深入业务、多积累，才能设计出更好、更强壮的架构
> 2. 继续深入学习基础知识、了解各类其他方案/规范
>
> 持续学习，切勿抱着一技之长而停止学习！说的很棒

[淘宝双十一 SSR 优化实践](https://juejin.cn/post/6896288990765252616)

> 虽然是 2020 年的文章，但是其中的思路还是非常值得学习，做一些总结
>
> 0. 性能优化最重要的还是在特定的场景内定义评估标准、核心指标，并且需要结合特定业务场景去细化/补充数据指标，比如 web.dev/社区提供的 FCP、TTI 等通用指标并不适用于电商场景，我们会新增一些诸如“用户可交互”、“业务白屏”等场景闭环体验的衡量标准（之前在抖音电商也是如此实践的）
> 1. 全链路的性能埋点（客户端、前端、服务端、...），不多说
> 2. 阿里采用了在接口做 SSR 渲染，而不是常规的 HTML 请求的 SSR 直出，原因是能低风险、低成本，不想浪费客户端已有的各种性能优化能力（看文章是说客户端会帮 H5 预请求接口和 webview 请求资源是并行的，并且有很好的 assets 缓存能力，所以 HTML 请求一般走的都是缓存、只是接口数据是动态的）
>    1. 这样有什么好处：
>       1. 风险低：无缝 SSR 降级 CSR，接口有 html 字段返回就渲染在 root container 上并且进行 SSR hydrate，如果没有（说明降级了/没开启 SSR）就走常规的 JS CSR（因为无论是 CSR 还是 SSR hydrtae，JS 资源都是需要请求的）
>       2. 利用端上成熟的性能优化能力
> 3. 对衡量优化的价值做了进一步的拆解分析（看不同人群的优化效果）
>    1. 体验性能
>       1. 多维度：机型、网络条件、命中 SSR、前端其他优化
>       2. 服务端分桶 + AB 实验
>    2. 业务收益
>       1. UV 点击提升 5%（还是很可观的）
> 4. 未来的架构？
>    1. webpack5 弱化 taget：将 web 描述为 browserlike 的环境
>    2. service worker cache
>    3. SSR 性能优化/安全（现在都 React18，这方面更细化了）
>    4. 站外 H5 SSR（HTML 直出）
> 5. 核心思路：Document 静态化（cacheable），root container 动态化（SSR）

[axios-hooks](https://github.com/simoneb/axios-hooks)

> axios 的 react hook 版
>
> 功能也挺丰富，支持 cancel、ssr、手动请求
>
> 看了下源码，精悍
>
> ssr 支持在 server 将 useAxios 中的请求适用 axios 发起，把 promise 放入一个闭包队列，然后在 render to html 的时候，await 结果，塞到 window 对象（替换字符串），在 client 用 `loadCache` 方式存在一个对象，hydrate 的时候直接进行数据渲染，无需请求接口（如果数据有问题降级还是会请求）

[diff-match-patch 文本 diff 库](https://github.com/google/diff-match-patch)

> google 维护的这个库的包含了所有语言的实现（底层是 myer's diff 算法）
>
> 包含 diff、match、patch 三种方法
>
> [fast-diff](https://github.com/jhchen/fast-diff) 是单独将 js 的 diff 算法独立导出的一个仓库

[coroutine for Go](https://research.swtch.com/coro)

> post 讲述了为什么在 go 里还需要一个 coroutine 的包来实现 coroutine，对我而言 go 还是比较深奥，但文章讲了 coroutine 是什么，coroutine 和 thread、generator 的区别，以及实现 coroutine 的背景和细节。
>
> 看了 1/3，剩下的没看下去了。。

[pake 介绍 from 掘金 bilibili](https://www.bilibili.com/video/BV1Cz4y1W7sy/)

> tw39 开源的 pake，基于 rust tarui 的桌面应用构建工具，的视频
>
> 原来大佬也是在阿里的飞猪带前端团队的，居然还有时间搞这么多开源
>
> 前端在 rust 也能做很多事情！补齐生态，好好学
>
> 技术产品化，30% 技术代码、30% 产品能力、30% 营销运营
>
> JS 的构建慢是原罪？插件多/ast/兼容低版本/IO 操作/单线程
>
> Rust 的发展前景

[浮点数精度损失](https://www.bilibili.com/video/BV12k4y1y7ST?t=1255.9&p=2)

> 应用了 IEEE754 标准浮点数的编程语言都会有精度损失，比如 `0.1 + 0.2 !== 0.3`
>
> 1 位符号位：0 正 1 负
>
> 11 位整数：整数部分等于 2 的这个次方
>
> 后面都是小数位：默认是 1.0
>
> 所以只要不是 2 次方的数，在不同位（32/64）上的计算方式都会有损失，0.1 在 JS 中损失的就是 [`Number.EPSILON`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Number/EPSILON)（定义的是比 1 大的最小浮点数与 1 之间的差，`2**(-52)`）
>
> **精度不准怎么办？**换成整数去运算，最终结果再还原到小数即可

[依赖注入](https://youtu.be/J1f5b4vcxCQ)

> 依赖注入模式！

[react tweet](https://vercel.com/blog/introducing-react-tweet)

> vercel 反向工程（reverse engineering）了 tweet embedded iframe，提供了 react 组件能够更好，更高性能的渲染推特卡片。

[vscode 团队压缩变量名优化](https://code.visualstudio.com/blogs/2023/07/20/mangling-vscode)

> vscode 团队通过命名压缩（name mangling）的方式减少了核心 js 代码文件的体积（workbench.js）20%的大小，提升了 app 启动时间。
>
> vscode 对于性能有极致的追求。命名压缩能够在不影响代码行为的情况下有效减少体积，但是风险也非常大。blog 也从一开始的试错到最后利用先构建到 ts 保证正确性，最后再打包的思路，选取了一些比较适合的场景（private properties 和内部变量）得益于团队固有的高标准编码规范。
>
> btw 这个优化在编译型语言来说显得有些不必要，因为最后都是会打成二进制指令码的吧……

[Ai engineer](https://www.latent.space/p/ai-engineer)

> AI 工程的未来

[Tea.xyz 未来的打包工具](https://tea.xyz/)

> 在之前的一期播客中听到，结合区块链的统一打包工具，来自 brew 的作者

[about Web gpu](https://cohost.org/mcc/post/1406157-i-want-to-talk-about-webgpu)

> 长文。web gpu 在 chrome 113 正式推出。
>
> 文章介绍了图形显卡、驱动、渲染框架的历史和由来；介绍了 WebGPU 是什么（shader 语言用 WGSL），如何使用，面向 JS/[TS](https://alain.xyz/blog/raw-webgpu)/NPM、[Rust](https://sotrh.github.io/learn-wgpu/)、C++
>
> 可以深入看看这几个教程

2023.09.03 21:55:01 +0800

[2023 前端框架和技术](https://mp.weixin.qq.com/s/GTEYKVt7GUI-OHdML2WaaQ)

> 一些前端技术进展的 review

[dynamic import 原理](https://github.com/rollup/plugins/tree/master/packages/dynamic-import-vars)

> 来自公司内部介绍 rollup 实现动态引入的原理
>
> - Rollup 插件构建时，动态引入（path 是动态的）是如何实现的，构建时不知道运行时的变量，通过一些特殊的手段。（[github](https://github.com/rollup/plugins/tree/master/packages/dynamic-import-vars)）
> - import( '../path/\${xx}.js' ) -> 会构造 glob path，然后编译所有的文件，再将代码转换成 switch/case 匹配
> - [源码](https://github.com/rollup/plugins/blob/master/packages/dynamic-import-vars/src/index.js)
> - 这个业务团队也用 [unplugin](https://github.com/unjs/unplugin) 开发了一个 vite 支持的插件

[treeshaking 排查指南](https://zhuanlan.zhihu.com/p/491391823)

> 也是来自公司内部杨健的文章
>
> - Tree shaking 是在什么环节：LTO（Link Time Optimization）的时候，检查各个模块之间的引用依赖
> - 是什么：分析出模块中导出的被引用代码之外的代码是否有用，是否有副作用，删除这些代码
>   - _Tree shaking_ is a term commonly used in the JavaScript context for dead-code elimination. It relies on the [static structure](http://exploringjs.com/es6/ch_modules.html#static-module-structure) of ES2015 module syntax, i.e. `import` and `export`. The name and concept have been popularized by the ES2015 module bundler [rollup](https://github.com/rollup/rollup).
> - 每个打包工具之间的 tree shaking 算法比较固定
> - sideEffects：具体教程可以看 webpack 的 [doc](https://webpack.js.org/guides/tree-shaking/)，
>   - 值可以是 boolean，告诉打包工具模块里面所有的代码都是没有副作用的
>   - 也可以是 string[]，指定有副作用的代码
> - 误区：
>   - 包含副作用的代码，都不能配置 sideEffects false：就是要看这个副作用设计是给模块内部还是外部的，如 vue，虽然是有副作用，但是是给内部用的，所以可以配置为 true(see [side effects in vue](https://github.com/vuejs/vue/pull/8099))。
>   - Css 配置 sideEffects 为 false 来实现 tree shaking：直接 import 进来的 css 如果被认为是没有副作用就会被误 tree shaking 掉，导致直接引入的 css 不生效，跟着组件相关一起 shaking

Signal 与响应式编程

> 公司内很好的一篇文章
>
> - 基于 signal 的响应式编程，通过 preact、solidjs、vue、rxjs 主流的响应式框架
> - Signal 是随着时间变化的值，signal 变化的时候，依赖他的下游也会自动作出反应（收到信号一样）
> - Signals、Reactions（副作用）、derivations（衍生）
> - 响应式特点：Evalution、lifting、glitch avoidance，看原文，讲的还是很生动的
>   - 求值分 拉取和 推送，像 vue solid preact 等都是 push 体系，pull-based 就是消费方主动计算依赖方的值，需要轮询开销
>   - lifting
>   - 闪烁避免：Glitch avoidance 是指响应式实现需要规避一个问题：两个上游依赖拥有相同依赖，当共同依赖变更时，会产生重复的计算过程，从而暴露 inconsistent data 给下游。
>     - 这里比较深入，先测试了下各个框架是否有 glitch 的问题
>     - 然后讲了解决方案
> - 响应式的问题：
>   - Sum type 和 product type：前者就是 或 关系，后者是笛卡尔积关系
>     - Sum type： A ｜ B
>     - Product type：理解为 C 是 A 和 B 的组合（也就是对象）
>   - 基于 Proxy 的响应式框架除了对基础数据类型无法很好支持外，对于 sum type 也难以处理。

[React 18 concurrent](https://react.dev/blog/2022/03/29/react-v18#what-is-concurrent-react)

> 来自公司内部文章
>
> - 浏览器处理 CPU 密集型的任务，JS 线程会占用浏览器渲染，所以会导致比如输入框延迟响应变化
> - VDom 的计算是非常 CPU 密集的，之前的 react 是对所有组件一视同仁，不会暂停渲染
> - 所以 concurrent mode 相当于 CPU 时间分片，或是用 startTransition API 来告诉 React 这个组件的优先级
> - 优先计算后的 node 会被提前 render，后续任务会放入队列（微任务），交换给浏览器线程

前端文件分片上传

> - 分片上传的优势：多个片可以并发上传、避免代理服务器拦截请求体过大的请求、避免网络波动导致整个文件重传（只需要重传失败的分片）
> - 前端利用 [blob.slice](https://developer.mozilla.org/en-US/docs/Web/API/Blob) 方法
>   - 进行文件分片，同时记录顺序
>   - 通知服务端开始上传，获得上传 id
>   - 并发上传所有分片
>   - 通知服务端结束上传
>   - （文章的代码还做了最大并发数的控制。。
> - 服务端（可以是 BFF）
>   - 提供开始/结束的请求，个人认为开始之后会在 redis 之类的 session 存一个 UploadId，超时未结束的话需要及时清除
>   - 需要有拼接文件的能力

[nolyfill: no node polyfill](https://github.com/SukkaW/nolyfill)

> 挺有意思的项目，目的是干掉所有安装在本地 node 环境中的兼容低版本 node 环境的依赖，因为我们基本用的都是高版本的 node 了，一些依赖库中还会有兼容 node4 以下的 polyfill，干掉他们！

[安卓能用 font-weight: 500 了吗](<[https://juejin.cn/post/7056752646283067400](https://juejin.cn/post/7056752646283067400)>)

> 移动端开发的时候（以 web）为例，设计师想要 font-weight: 500，但在安卓手机上就是不能让字体变粗，只支持 700 的 bold 粗细
>
> 字体匹配规则
>
> 如果指定的 font-weight 数值，即所需的字重，能够在字体中找到对应的字重，那么就匹配为该对应的字重。否则，使用下面的规则来查找所需的字重并渲染：
>
> - 如果所需的字重小于 400，则首先降序检查小于所需字重的各个字重，如仍然没有，则升序检查大于所需字重的各字重，直到找到匹配的字重。
>
> - 如果所需的字重大于 500，则首先升序检查大于所需字重的各字重，之后降序检查小于所需字重的各字重，直到找到匹配的字重。
>
> - 如果所需的字重是 400，那么会优先匹配 500 对应的字重，如仍没有，那么执行第一条所需字重小于 400 的规则。
>
> - 如果所需的字重是 500，则优先匹配 400 对应的字重，如仍没有，那么执行**第一条所需字重小于 400 的规则**。
>
> - 所以 font-weight 500 的结果就是
>
>   - 中文渲染字重为 400，看上去没有变化
>
>   - 英文渲染字重为 500，正常加粗
>
> 目前不同手机厂商的安卓系统也在努力补齐字重，有朝一日可以用上
>
>     另外看到一种更骚的方法实现字体加粗 webkit text stroke [https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-text-stroke](https://developer.mozilla.org/en-US/docs/Web/CSS/-webkit-text-stroke)
>
> `-webkit-text-stroke: 2px red; // currentColor`

2023.09.14 13:13:41 +0800

[数据库碎碎念](https://zhuanlan.zhihu.com/p/645811161)

> 数据库简史合 Snowflake 公司

[tsconfig cheat sheet](https://www.totaltypescript.com/tsconfig-cheat-sheet)

> `tsconfig.json` 真的是令人头大的配置，这篇文章给出了基础的 coding 所需配置和说明，不做翻译了，直接看吧

[why rust is the most admired amoung programmers](https://github.blog/2023-08-30-why-rust-is-the-most-admired-language-among-developers/)

> Rust 语言一直是 stackover flow 最受程序员欢迎的语言
>
> Blog 介绍了 Rust 的历史
>
> Rust 的一些优势：自带并发体系、没有 GC、自带包管理器 Cargo（第一个带包管理器的系统语言）、令消耗抽象、模式匹配、类型推断
>
> 一些关键的使用场景：
>
> - 极端关注性能的后端系统
> - 操作系统
> - 系统操作相关的任务
> - web 开发（工具链 swc、rspack、oxc、...）（服务框架 [Rocket](https://rocket.rs/)）
> - crypto、Block chain
> - CLI tools（真的已经太多了）（[教程](https://rust-cli.github.io/book/index.html)）
> - 嵌入式系统、IoT 开发
