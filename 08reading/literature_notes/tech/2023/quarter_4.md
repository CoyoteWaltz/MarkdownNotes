[Deno with jupiter](https://deno.com/blog/v1.37)

> Deno core 的 jupiter，很是牛逼，在 jupiter 执行 js/ts 代码
>
> 能够做 python 环境的各种事情，比如画图表

[nue.js](https://nuejs.org/)

> 又一个[新的](https://nuejs.org/why/#spaghetti)前端框架、工具链
>
> 在 [backstory](https://nuejs.org/blog/backstory/) 中作者提到目前的前端开发的体验并不好，nue 是为了解决 JS engineer 和 UX developer 之间的割裂，一套新的开发框架
>
> 支持 bun、node 环境；支持 SSR；基于 HTML 模版语法（类 Vue）...
>
> Nue JS 个人感觉更像是 JS lib；Nue tools 相关生态工具链；Nuemark 语法，类似 markdown，更聚焦内容
>
> [源码](https://github.com/nuejs/nuejs)看起来还不多，很强

[chrome devtool override request](https://developer.chrome.com/docs/devtools/overrides/)

> 能够直接在 devtool 中直接 mock 接口数据了！非常好用
>
> 具体哪个版本更新的不知道

[CSS tricks 渐变动画边框效果](https://twitter.com/jh3yy/status/1714711273345065131?s=46&t=v3lPGTe7TNbgXSDge4D2KQ)

> 收藏下

[react dev inspector](https://juejin.cn/post/6901466406823575560)

> 挺有意思的一个 react 工具，能够在 dev 的时候通过页面点击直接打开编辑器，定位到所在组件的源码
>
> [github](https://github.com/zthxxx/react-dev-inspector)
>
> 通常我们会找这个元素对应的 class，然后在源码中搜...
>
> 实现思路：
>
> - 构建时：通过 babel 插件，在 jsx 转译前就加上一些自定义属性（比如文件相对路径），然后通过一个包裹组件进行快捷键的监听；同时定义文件目录，最终拼接完整路径
> - 寻找 fiber 节点的 name
> - fetch 到 dev server：在 dev server 的处理中，增加一些自己的逻辑，来打开编辑器
> - 打开编辑器：直接是参考的 CRA 的 [react-dev-utils](https://github.com/facebook/create-react-app/blob/main/packages/react-dev-utils/launchEditor.js)，通过 shell 直接获得当前正在运行的编辑器，然后直接 spawn 进程唤起（比如 `code <path>`

[前端 monorepo 之殇](https://sooniter.site/posts/frontend-monorepo)

> monorepo 的爽点：不走“发包”的流程来以“包”（package）的单位来复用代码
>
> 连环构建 & 依赖拓扑，build 是依赖其他子包时，通过依赖图分析（有向无环图），保证构建任务顺序正确
>
> 产物引入 & 源码引入：
>
> - dev 过程，极慢的 HMR
> - 源码引入，修改构建器的 resolve 逻辑，直接打到源码即可，也有一定问题
>   - 高度一致的构建环境
>   - 收敛自定义构建行为, 中间包想在编译时做点事情, 比如替换掉 `process.env.NODE__ENV` 几乎不可能了
>   - 开发生产的不一致, 发包后的产物挂掉浑然不知
>   - 为什么不直接放弃 monorepo 而使用源码文件夹呢。。。
>
> 文章还讨论了幻影依赖，去除重复包，一包一版本、版本号管理等令人头疼的多包管理问题
>
> BTW 作者目前是我司员工（专业搞 monorepo 的，牛逼！）

[yarn pnp](https://spin.atomicobject.com/2022/05/02/yarn-pnp/)

> 来了解一下 yarn 的 [pnp](https://yarnpkg.com/features/pnp)(Plug'n'Play)。注意只有 v2 开始有，npm 默认安装的都是 v1 的 yarn（不知道为什么
>
> `yarn set version stable` `yarn install` 更新
>
> [Plug and Play](https://en.wikipedia.org/wiki/Plug_and_play) 是什么？中文翻译过来叫“即插即用”。。
>
> 如果需要升级到 `>1` 的版本 TODO

[字节跳动前端工程化](https://zhuanlan.zhihu.com/p/640021617)

> 什么是前端工程化：开发效率、代码质量、代码复用性、自动化流程、团队协作、...
>
> 文章介绍了 monorepo、rspack、微前端、web 构建分析工具

[what is JWT](https://blog.logrocket.com/jwt-authentication-best-practices/)

> 几年前做过电商项目的 API 接口，在用户鉴权这块用到了 JWT token 的方式，近期工作上又有类似的场景，来做个回顾吧
>
> A JWT is a mechanism to verify the owner of some JSON data. It’s an encoded, **URL-safe** string that can contain an unlimited amount of data (unlike a cookie) and is cryptographically signed.
>
> When a server receives a JWT, it can guarantee the data it contains can be trusted because it’s signed by the source. No middleman can modify a JWT once it’s sent.
>
> 不要用 JWT 作为 session token：一个原因是本身的功能比较丰富，容易出错；第二个是因为 JWT 在一个 session 结束后不能直接移除，**因为他自包含（self-contained）没有一个中心的控制地来让他失效**；而且这个 token 的长度相对很大，作为 cookie 会增加请求的载荷。所以不合适
>
> 用 JWT 作为 API 的鉴权：
>
> 如何让一个 JWT token 失效：一个暴力的方法是直接把服务端的 secret 换掉，那全部的 JWT 都失效了；还有利用 `iat` 这个 token 创建的时间，自动会存为 token 的这个属性，然后可以通过服务端的比较，来决定是否让其失效；还可以自定义一些属性/黑白名单的机制（需要存储）
>
> 如何在 cookie 中安全的存储 JWT（client）：client 拿到 JWT，最好是存在 [HttpOnly cookie](https://www.cookiepro.com/knowledge/httponly-cookie/)（[MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#restrict_access_to_cookies)），不会被 js 访问到（`Set-Cookie: =“[; “=“] [; expires=“][; domain=“] [; path=“][; secure][; HttpOnly]`，例如：`Set-Cookie: id=a3fWa; Expires=Thu, 21 Oct 2021 07:28:00 GMT; Secure; HttpOnly`）
>
> 可以不需要服务端存储，解析 jwt 已经足够安全
>
> 通过 JWT 跨服务鉴权：无需两边共享 session，只需要各自解析即可（同一 secret）

[react-loadable](https://github.com/jamiebuilds/react-loadable)

> 读了下 readme，写的真的算是非常清晰的文档了（包括 API DOC），讲清楚了为什么要做组件粒度的 loadable（拆包）而不是路由（页面）维度的，以及丰富特性的 API
>
> BTW，这和 [`react.lazy`](https://react.dev/reference/react/lazy)，[loadable/components](https://github.com/gregberge/loadable-components) 这些库之间到底用啥呢
>
> loadable/components 给出了[比较](https://loadable-components.com/docs/loadable-vs-react-lazy/)：
>
> - react lazy 是官方结合 Suspense 的 code splitting 方案，如果已经使用了，用就完事
> - `@loadable/component` 提供了更完整的 ssr 方案，ssr 首选；并支持动态路径的 `import()`
> - react-loadable：与 webpack 4+ 和 babel 7+ 不兼容了，也很久不维护了，不太推荐目前使用

[关于前端是否需要对登录密码加密](https://blog.huli.tw/2023/01/10/security-of-encrypt-or-hash-password-in-client-side/)

> 文章分析的挺到位的，在 HTTPS 的前提下前端是否需要加密一些字段，真的是探讨很多的问题
>
> 对于这个问题的结论是：「在 client 加密（非对称）或是 hash，确实能增加安全性」
>
> 1. HTTPS 因为各种原因失效的时候，攻击者无法拿到明文的密码
> 2. 在 Server 端，没有人知道使用者的明文密码
> 3. **明文密码不会被记录到各种 log 中（前端接口失败的上报）**
>
> 一些大公司（银行）做了
>
> 很多人喜欢在各个平台用同一套账号/密码，如果被泄漏了，还挺危险
>
> 至于成本（ROI）
>
> _我自己認為一位優秀的工程師不能只給得出最佳實踐，而是必須針對有限資源的狀況之下，給出各種不同的解法，因此這篇討論的問題不是毫無意義的。把這個問題整理過一輪之後，自然而然就會出現許多成本不同，效益也不同的解法。_ 这段说的挺好
>
> 最后摘录下结论：
>
> - 一定要首选用 HTTPS
> - 可以使用 [presskeys](https://developers.google.com/identity/passkeys)
> - 如果你想要用很安全的方式驗證密碼，並且確保在 Server 端不會處理到明文密碼，請參考 [SRP（Secure Remote Password）](https://www.cryptologie.net/article/503/user-authentication-with-passwords-whats-srp/)協定，或是留言裡面讀者 yoyo930021 提到的 [OPAQUE](https://blog.cloudflare.com/opaque-oblivious-passwords/)
> - 上述没有资源的话，给密码加 hash or 加密能增加安全性，但会带来额外成本
> - 如果是对字段安全有极高要求的业务，再去实践吧，还是取决于 ROI

[我们需要 HTTP3](https://mp.weixin.qq.com/s/UlwboBEV3Q3Z_ROGQo7EWw)

> [原文链接](https://blog.apnic.net/2023/09/25/why-http-3-is-eating-the-world/)
>
> TCP 不再适合：效率问题，将网页视为耽搁文件
>
> QUIC：与 TLS 深度集成，HTTPS 仅对数据进行加密，QUIC with TLS 会对协议大部分内容加密，更加安全，效率性能提升，更快的连接握手

[React18 带来的类型变化](https://github.com/facebook/create-react-app/pull/8177)

> 在公司内部看到的技术分享，做一些摘录总结
>
> 现象：升级到 React18 之后，`React.FC` 的 Props 不带 `children` 属性了
>
> React18 背后的原因：
>
> - **`React.FC`** **移除了 props 里隐式提供的** **`children`** **类型**
> - **`ReactNode`** **类型中移除了** **`{}`**
>
> CRA 的这个 PR 中，移除了模版代码的 `React.FC`（一度被 TS 新接触者认为是最佳时间），是有好处的，因为 FC 这个类型多多少少有点问题
>
> - 默认带有隐式 `children`
>
> - 不太好支持泛型组件 `const GenericComponent: React.FC</* ??? */> = <T>(props: GenericComponentProps<T>) => {/*...*/}`
>
> - component as namespace pattern 不太好做
>
>   - ```jsx
>     <Select>
>       <Select.Item />
>     </Select>
>     ```
>
>   - 一旦定义成 FC，要扩展就不太行了
>
> 当然 FC 也有好处：
>
> - 提供了明确的返回值类型约束（不允许返回 `undefined`，`object` 之类的）
>
> 具体 React18 带来的类型上的 [breaking changes](https://github.com/DefinitelyTyped/DefinitelyTyped/issues/46691) 主要就是这些
>
> 补充：
>
> - `JSX.Element` vs `React.ReactNode` vs `React.ReactElement`
>
>   - `ReactElement` 是 `React.createElement`（17 之后是 jsx）的返回
>
>   - `JSX.Element` 基本是 `ReactElement`，就是 type 和 props 都是 any，更加宽松，同样 JSX 实际是一个 namespace，各个库可以覆盖
>
>   - ```typescript
>     declare global {
>       namespace JSX {
>         interface Element extends React.ReactElement<any, any> {}
>       }
>     }
>     ```
>
>   - `ReactNode` 虚拟 DOM 的表示方式，是 class 组件 render 函数和函数组件的返回值，因此它是组件所有可能返回值的集合。它除了可以是 ReactElement，还可以是 string, number, undefined,....
