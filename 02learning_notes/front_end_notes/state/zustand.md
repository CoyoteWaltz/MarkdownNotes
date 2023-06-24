# zustand

> [github](https://github.com/pmndrs/zustand)
>
> 热门状态管理库之一，和 react 的融合性非常好，react 应用的首选之一，也可以直接使用

支持中间件可以配合 immer

分割 store 的[最佳实践（TS）](https://github.com/pmndrs/zustand/blob/main/docs/guides/typescript.md#slices-pattern)

源码阅读中...

TS 体操比较多，难懂。核心 store 的代码很简单。

工作中深度使用了一下（除了 middleware），真的很爽，非常灵活，TS 支持也非常好

一些最佳实践

- https://tkdodo.eu/blog/working-with-zustand
- https://betterprogramming.pub/harness-state-management-using-zustand-5f2ee597d1c1
- 可以不在 store 里定义 action. 可以结合业务自己组织一层 https://github.com/pmndrs/zustand/blob/main/docs/guides/practice-with-no-store-actions.md （确实很清晰且也不和 hook 耦合）

源码深入：

- https://github.com/ascoders/weekly/issues/392
  - 对比了一下，现在版本 v4 已经用 [useSyncExternalStore](https://react.dev/reference/react/useSyncExternalStore) 作为 hooks 的集成了，不过文章中之前到方法也值得一看
