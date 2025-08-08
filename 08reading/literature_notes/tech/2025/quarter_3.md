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
