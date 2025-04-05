# zustand

> [github](https://github.com/pmndrs/zustand)
>
> 热门状态管理库之一，和 react 的融合性非常好，react 应用的首选之一，也可以直接使用

工作中深度使用了一下（除了 middleware），真的很爽，非常灵活，TS 支持也非常好

一些最佳实践：

- https://tkdodo.eu/blog/working-with-zustand
- https://betterprogramming.pub/harness-state-management-using-zustand-5f2ee597d1c1
- 可以不在 store 里定义 action. 可以结合业务自己组织一层 https://github.com/pmndrs/zustand/blob/main/docs/guides/practice-with-no-store-actions.md （确实很清晰且也不和 hook 耦合）
- 支持中间件可以配合 immer
- 分割 store（slice 切片）的[最佳实践（TS）](https://github.com/pmndrs/zustand/blob/main/docs/guides/typescript.md#slices-pattern)

源码深入：

> 源码的 TS 体操比较多，难懂。核心 store 的代码很简单。

- https://github.com/ascoders/weekly/issues/392
  - 对比了一下，现在版本 v4 已经用 [useSyncExternalStore](https://react.dev/reference/react/useSyncExternalStore) 作为 hooks 的集成了，不过文章中之前到方法也值得一看
  - force rerender 的实现：`const [, forceUpdate] = useReducer((c) => c + 1, 0) as [never, () => void]`

Update: 最新 V5 版本（只支持 React 18，因为 `useSyncExternalStore`）：

- 直接使用了 `useSyncExternalStore` 而不在外部依赖他的 polyfill 库

- ```typescript
  export function useStore<TState, StateSlice>(
    api: ReadonlyStoreApi<TState>,
    selector: (state: TState) => StateSlice = identity as any
  ) {
    const slice = React.useSyncExternalStore(
      api.subscribe,
      () => selector(api.getState()),
      () => selector(api.getInitialState())
    );
    React.useDebugValue(slice);
    return slice;
  }
  ```

- 注意在 react 中使用 useStore 的 selector 时候，避免写每次返回新对象的 selector，否则会在 useSyncExternalStore 中出现死循环 render（因为 useSyncExternalStore 里是通过 Object.is 来做 diff 判断的），可以使用 zustand 的 [`useShallow`](https://github.com/pmndrs/zustand/blob/main/src/react/shallow.ts) 做浅比较

  - 可以看到内部实现的比较数组之类可迭代的对象，用的是迭代器属性

    ```typescript
    // Ordered iterables
    const compareIterables = (
      valueA: Iterable<unknown>,
      valueB: Iterable<unknown>
    ) => {
      const iteratorA = valueA[Symbol.iterator]();
      const iteratorB = valueB[Symbol.iterator]();
      let nextA = iteratorA.next();
      let nextB = iteratorB.next();
      while (!nextA.done && !nextB.done) {
        if (!Object.is(nextA.value, nextB.value)) {
          return false;
        }
        nextA = iteratorA.next();
        nextB = iteratorB.next();
      }
      return !!nextA.done && !!nextB.done;
    };
    ```
