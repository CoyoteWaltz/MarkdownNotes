[minerU](https://github.com/opendatalab/MinerU)

> 一站式开源高质量数据提取工具，将 PDF 转换成 Markdown 和 JSON 格式，体验了下线上版本，效果挺好，vlm 大模型驱动

[tiktok font](https://www.tiktok.com/font)

> tiktok 字体开源，网站做的是真炫酷

[the gentle singularity](https://mp.weixin.qq.com/s/75AbnIxWgRmYS25eco1SjA)

> [原文](https://blog.samaltman.com/the-gentle-singularity) 来自 sam altman 好文，建议多读几遍。好好利用 AI，将想法落地，当下的智能和创意非常富足，行动起来吧。智能成本最终会逼近电价，便宜到几乎不需要计价。sam altman 给出了当前平均一次 chatgpt 对话的能量消耗：0.34 Wh 电 + 0.000085 gal 水。”
> 试试 deep research（o3）的翻译能力

[体验下新的 vcs Jujutsu](https://github.com/jj-vcs/jj)

> 这篇[入门教程](https://maddie.wtf/posts/2025-07-21-jujutsu-for-busy-devs)还挺不错，介绍了 jj 不一样的版本管理心智（revision），有点意思
> mark 下这个[教程](https://steveklabnik.github.io/jujutsu-tutorial/introduction/introduction.html)
> 可以用 ohmyzsh 的[插件](https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/jj/README.md)，做一些类似 `gst` 的 alias，蹲这个 [mr](https://github.com/ohmyzsh/ohmyzsh/pull/13179)，不过结合 zimfw 的时候，需要做一些关于 ohmyzsh 的提前兼容
>
> ```bash
> # .zimrc
> zmodule ohmyzsh/ohmyzsh --root plugins/jj
> ```
>
> ```bash
> # .zshrc
> # for using some plugins of oh my zsh
> # need to set some default vars
> export ZSH_CACHE_DIR="$HOME/.cache/mycustom"
> mkdir -p "$ZSH_CACHE_DIR/completions"
> ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
> ...
> ```

[了解下 Numeronym](https://en.wikipedia.org/wiki/Numeronym)

> 比如日常工作中听到的：`i18n`, `a11y`, `k8s`, `n8n`, `m12n`, `o11n` 都是 Numeronym 的一类（Numerical contractions）。当然还有
>
> - Homophones：用数字的发音来替代原有的读音，比如 `p2p`, `gr8`, `B2B`, `sk8r`, `B4`, `l8r`
> - Numerical contractions：第一个和最后一个字母之间的数量用数字来省略
> - Purely numeric：纯数字表达缩写 `520`, `143`(i love you), `491`, `456`
> - Repeated letters：重复字母，`W3C`, `W3` (World Wde Web)
>
> 挺有意思

[画布 AI 自动化工作流](https://n8n.io/)

> and [dify](https://github.com/langgenius/dify) 大模型工作流搭建

[bottom 跨平台的可视化图形的系统监视器](https://github.com/ClementTsang/bottom)

> 尝试下 [使用姿势](https://bottom.pages.dev/stable/usage/general-usage/)
>
> 同样还有一个比较新的 [neohtop](https://github.com/abdenasser/neohtop)，svelte + tauri 的一个 htop 的客户端，好像也不错，有空可以体验下

[pnpm 10.14 替代 nvm/fnm!](https://pnpm.io/blog/releases/10.14)

> ```json
> {
>   "devEngines": {
>     "runtime": {
>       "name": "node",
>       "version": "^24.4.0",
>       "onFail": "download" // we only support the "download" value for now
>     }
>   }
> }
> ```
>
> 这个思路真的不错，在 package 维度定义 [runtime engine](https://docs.npmjs.com/cli/v10/configuring-npm/package-json#devengines)，在 lockfile 中也会存储相关信息（把 node version 也加入到了 lockfile），并且 pnpm run 等指令都会用对应的 node 版本来执行，以后可以抛弃 nvm/fnm 了

[是否在线](https://antonz.org/is-online/)

> 如何检测用户是否在线（online，连接到网络），可以用 google 提供的 https://google.com/generate_204，或者 http://www.gstatic.com/generate_204，速度很快。
>
> surge 中的检测也是配的这个地址，他会返回 http 204。小技巧 +1，可以通过 js 实现用户的断网检测，同时和 navigator.onLine（立即，更快）检测

[promise.try](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/try)

> 浏览器支持度：chrome 128 (24 年 8 月）
>
> 作用是可以立即启动一个 promise chain，并且执行里面的函数，将其返回结果包装成 promise，并且可以自动将函数的 error 包装成 promise.reject，也不用再写 try catch 了。
>
> 和 `Promise.resolve().then(func)` 是高度相似，但也不太一样：resolve 后的 then 里面的回调，已经是在异步微任务里面执行了，不是 new Promise 的形式同步执行的。也和 settimeout 一样支持参数 Promise.try(func, arg1, arg2);

[manus 的 LLM 上下文工程中的教训经验](https://manus.im/zh-cn/blog/Context-Engineering-for-AI-Agents-Lessons-from-Building-Manus)

> AI 代理工程的一些经验教训，但是大模型厂商不断的飞速迭代，也会使得这些工程手段愈加不那么重要，等待就会白给

[twoslash](https://github.com/twoslashes/twoslash)

>

[康威定律](https://zh.wikipedia.org/wiki/%E5%BA%B7%E5%A8%81%E5%AE%9A%E5%BE%8B)

> "设计系统的架构受制于产生这些设计的组织的沟通结构。"
