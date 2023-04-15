# Interface V.S. Type alias

> 到底是更推荐用 `interface` 还是 `type` 来定义类型呢
>
> [文章](https://ncjamieson.com/prefer-interfaces/)推荐使用 `interface`

## 两者的区别

[官方文档](https://www.typescriptlang.org/docs/handbook/2/everyday-types.html#differences-between-type-aliases-and-interfaces)说明两者是非常接近的，主要的差异就是 `type` 是不能被重新增加新的属性的（re-open），而 `interface` 是可以被扩展的：（也就是[这里](declare_module.md)所说的神奇的用法：在不同的 module 去扩充 interface）

```typescript
interface Window {
  title: string;
}
// 可以扩充
interface Window {
  ts: TypeScriptAPI;
}

const src = 'const a = "Hello World"';
window.ts.transpileModule(src, {});
```

```typescript
type Window = {
  title: string;
};

type Window = {
  ts: TypeScriptAPI;
};

// Error: Duplicate identifier 'Window'.
```

以及这些不同点：

- 在 4.2 版本也提出了 [interface 能更好的在错误信息中展示类型名称，方便找错误（只能已名字去用）](https://www.typescriptlang.org/play?#code/PTAEGEHsFsAcEsA2BTATqNrLusgzngIYDm+oA7koqIYuYQJ56gCueyoAUCKAC4AWHAHaFcoSADMaQ0PCG80EwgGNkALk6c5C1EtWgAsqOi1QAb06groEbjWg8vVHOKcAvpokshy3vEgyyMr8kEbQJogAFND2YREAlOaW1soBeJAoAHSIkMTRmbbI8e6aPMiZxJmgACqCGKhY6ABGyDnkFFQ0dIzMbBwCwqIccabcYLyQoKjIEmh8kwN8DLAc5PzwwbLMyAAeK77IACYaQSEjUWZWhfYAjABMAMwALA+gbsVjoADqgjKESytQPxCHghAByXigYgBfr8LAsYj8aQMUASbDQcRSExCeCwFiIQh+AKfAYyBiQFgOPyIaikSGLQo0Zj-aazaY+dSaXjLDgAGXgAC9CKhDqAALxJaw2Ib2RzOISuDycLw+ImBYKQflCkWRRD2LXCw6JCxS1JCdJZHJ5RAFIbFJU8ADKC3WzEcnVZaGYE1ABpFnFOmsFhsil2uoHuzwArO9SmAAEIsSFrZB-GgAjjA5gtVN8VCEc1o1C4Q4AGlR2AwO1EsBQoAAbvB-gJ4HhPgB5aDwem-Ph1TCV3AEEirTp4ELtRbTPD4vwKjOfAuioSQHuDXBcnmgACC+eCONFEs73YAPGGZVT5cRyyhiHh7AAON7lsG3vBggB8XGV3l8-nVISOgghxoLq9i7io-AHsayRWGaFrlFauq2rg9qaIGQHwCBqChtKdgRo8TxRjeyB3o+7xAA)，而 type alias name 不能
- TS interface 可以扩充类型，type 不行
- interface 只能用来声明类型，而不能重命名原始类型

官方使用建议：For the most part, you can choose based on personal preference, and TypeScript will tell you if it needs something to be the other kind of declaration. If you would like a heuristic, use `interface` until you need to use features from `type`.

## Why Prefer Interface?

可以通过 playground 分别试一下 `interface` 和 `type` alias 的使用

当 type [在 IIFE 中使用](https://www.typescriptlang.org/play?#code/MYewdgzgLgBATgUwIYBMYF4YAosEoMB8MA3gFAwxQCeADgjAErIoDCSANuwEZLADWGbKDBQEIgFwxocAJZgA5vnRFpc+QG5y8BFACucMDABmusMCgzwWGkigALSaoUAaGMA7defSU1RtOPPz4xAC+pCG4eOpAA)

```typescript
const read = (() => {
  type ReadCallback = (content: string) => string;
  return function (path: string, callback: ReadCallback) {};
})();
```

可以看到输出的 `.d.ts` 中的类型 `ReadCallback` 直接被 inline 化了

[而换成 interface ](https://www.typescriptlang.org/play?#code/MYewdgzgLgBATgUwIYBMYF4YAosEoMB8MA3gFAwwCWYUCcAZksAjAErIoDCSANjwEZMA1iWygaCGgC4Y0ONQDmuGXMUBuGAF815eAigBXOGBj0DYYFErhsAByRQAFiqjywCgDQxgvAcJnsqNx8gsBC+MTapJq4eGpAA)之后，则直接编译报错了：interface 不会被处理成 inline，而是用他的名字去引用

在[这条推特](https://twitter.com/drosenwasser/status/1319205169918144513)中大家也讨论很多，将 `type` 改成 `interface` 之后，将 700 多行输出降低到了 7 行（`.d.ts` ts 的输出）

TS 的 Program Manager 也坚定的优先选择 interface：

_Honestly, my take is that it should really just be interfaces for anything that they can model. There is no benefit to type aliases when there are so many issues around display/perf._

_We tried for a long time to paper over the distinction because of people’s personal choices, but ultimately unless we actually simplify the types internally (could happen) they’re not really the same, and interfaces behave better._

可以用 lint 的方式去执行这个规范。

相关阅读：

- [PR: Preserve type aliases for union and intersection types](https://github.com/microsoft/TypeScript/pull/42149)
- [TS Performance](https://github.com/microsoft/TypeScript/wiki/Performance#preferring-interfaces-over-intersections)
