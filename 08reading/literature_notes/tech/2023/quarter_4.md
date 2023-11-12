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
> 如果需要升级到 `>1` 的版本
