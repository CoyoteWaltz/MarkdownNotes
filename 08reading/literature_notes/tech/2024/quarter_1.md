[javascript 中优雅创建并初始化数组](https://darkyzhou.net/articles/js-array-creation)

> 读这篇内容之前，一直都是用 `Array.from({ length: N })` 的方式创建数组，读完才知道为什么这样创建方式会好（优雅、高效）
>
> 底层原因：V8 对于带洞数组的性能可能劣于紧密数组，所以尽可能创建紧密数组
>
> 不过，“尽管这项事实可能会随着 V8 引擎的不断优化变得越来越难以在生产环境中发生。如果你创建的数组都很小，或者不关心性能问题，那么你还是可以继续坚持自己最喜欢的方法。”

[Dan 的 'The Two Reacts'](https://overreacted.io/the-two-reacts/)

> 一篇抛砖引玉的 blog，两个 react（client side 和 server side）。主要还是在抽象的讲 ssr with RSC 吧，后面还会有更深入的 blog...
