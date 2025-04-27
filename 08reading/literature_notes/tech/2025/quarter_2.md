[inversify IOC, DIP](https://github.com/inversify/InversifyJS)

> 所谓的依赖倒置设计模式，这个库给了 TypeScript 实现的 api 套件，很不错，待结合项目深入研究下使用姿势（with 官方文档）

[Anubis 利用工作量证明机制来防御 AI 爬虫](https://anubis.techaro.lol/)

> [github](https://github.com/TecharoHQ/anubis)
>
> AI 爬虫完全不遵守规矩，导致 Saas 站点可能收到非常多的爬虫流量侵袭，一种方式是可以使用 cloudflare 的[免费防护](https://blog.cloudflare.com/declaring-your-aindependence-block-ai-bots-scrapers-and-crawlers-with-a-single-click/)
>
> 或使用 anubis 作为网页流量的前置反向代理，计算 SHA-256 checksums（Anubis has a customizable difficulty for this proof-of-work challenge, but defaults to 5 leading zeroes.）满足条件后才算成功，就是比特币的工作量证明，可以极大的消耗爬虫的 CPU

[做一个 local first and ejectable 的软件](https://thymer.com/local-first-ejectable)

> _EJECTABLE_ Apps：可以随时从云端服务打包“弹射”出去（将数据和服务），部署在本地运作的应用

[node module inspector](https://github.com/antfu/node-modules-inspector)

> 来自安东尼老师，设计审美在线，用于检查项目中的 node module 依赖关系，很不错的可视化工具

[animejs 动画引擎](https://animejs.com/)

> 非常强大的 js 动画引擎库，官网动效非常炫酷

[MTranServer](https://github.com/xxnuo/MTranServer)

> 低占用速度快可私有部署的自由版 Google 翻译，本地 docker 部署，配合 bob 的[插件](https://github.com/gray0128/bob-plugin-MTranServer)，翻译效果还挺丝滑的
>
> 推荐！挺好用

[Google application centric](https://cloud.google.com/blog/products/application-development/an-application-centric-ai-powered-cloud)

> Google 对 **application-centric cloud** 应用开发的体验升级 with AI（Gemini），一站式的工作台，并且结合 AI 助手将应用创建、代码生成、AI 测试、文档等全研发生命周期都集成了。Google 牛逼
>
> 顺便体验了下 [Firebase studio](https://firebase.studio/) 感觉还挺不错的，一条龙服务

[图解 Stable Diffusion](https://www.ithome.com/0/668/981.htm)

> 对[油管视频](https://www.youtube.com/watch?v=MXmacOUJUaw)的翻译（应该是机翻，比较一般），介绍什么是 SD

[对 TypeScript enum 的赞颂（ode）](https://blog.disintegrator.dev/posts/ode-to-typescript-enums/)

> TS 5.8 带来了 `--erasableSyntaxOnly` 特性，简单来说就可以直接执行 ts 代码，通过擦出代码中 type 的特性来实现
>
> 但是 ts 自带的 enum 和 namespace 让这个事情还挺困难的。作者也说了一些社区内对 enum 特性的鄙夷，不过作者在文章中主要还是提出了 enum 好的地方，比如有很好的 doc 能力（deprecated、JS Doc），但是还是推荐使用 `as const` + union literals
>
> ```typescript
> const Foo = {
>   Test: "123",
>   Bro: "bro",
> } as const;
> // 不过很多项目不允许有同名变量
> type Foo = typeof Foo[keyof typeof Foo];
>
> let f: Foo = Foo.Bro;
> ```

[pronotes.app](https://www.pronotes.app/)

> supercharge apple note 很不错的加强插件，挺好用

[FramePack 斯坦福大学的视频 diffusion 模型](https://lllyasviel.github.io/frame_pack_gitpage/)

> [Github](https://github.com/lllyasviel/FramePack)
>
> 太牛了，不过本地需要 N 卡，等等有服务出来直接用吧

[Deepwiki](https://deepwiki.com/)

> 好东西，devin 带你剖析 github 仓库，`github.com/xxx/yyy` to `deepwiki.com/xxx/yyy`
>
> powered by [devin](https://devin.ai/)
