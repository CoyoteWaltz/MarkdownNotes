# 一些 hooks 收集

## useReducer 的优雅之处

基于 ref 数据的 state 更新

```typescript
const [bookList, updateBookList] = useReducer(() => {
  return bookPageInfoRef.current.list; // 更新的都是 ref 数据
}, []);
```

zustand 的 force rerender 的实现：

```typescript
const [, forceUpdate] = useReducer((c) => c + 1, 0) as [never, () => void];
```

## useCallbackRef

> from myself，作用是对于需要用 ref 的 callback 做了一层语法糖包裹
>
> 其实再猛一点可以直接把 deps 包进去，里面用 useMemo/useCallback
>
> 但为了能够让非 ref 的 callback 依然能正常使用，就还是留了一手

```typescript
import React, { useLayoutEffect, useRef } from "react";

export const useCallbackRef = <T = (args: any) => void>(callback: T) => {
  const callbackRef = useRef(callback);

  useLayoutEffect(() => {
    callbackRef.current = callback;
  }, [callback]);

  return callbackRef;
};
```

### Usage

```typescript
const foo = useCallback(() => {
  // ...
}, [a, b, c]);
const fooRef = useCallbackRef(foo);
```

## useAsyncState

> 来自杨大师的题目
>
> `useAsyncState<T>(initState: T) => [T, (nextState: PromiseLike<T> | T) => void];`
>
> // 三个细节是：
> // 1、传同步的时候不要额外等待（禁用掉 Promise.then()，你必须分类讨论）
> // 2、数据同步必须安全，过时的异步任务不能更新状态
> // 3、注意组件卸载后 setState 会报错
>
> // 还有加分项：
> // 1、参数控制异常处理，产生异常后状态回退或重置或返回新的 state 标记是否有 error【并没有处理异常】
> // 2、标记当前是否在 loading（参数控制时可能需要清除当前状态）
> // 3、加上 useState 接收回调的机制，再考虑回调是否要等待未完成的 Promise（不难但是代码会很长很恶心）【不知道实现的对不对】

```typescript
import { useCallback, useEffect, useRef, useState } from "react";

export const useAsyncState = <T>(
  initState: T
): [T, (nextState: PromiseLike<T> | T) => void, boolean] => {
  const [{ state: inner, waiting }, setInner] = useState({
    state: initState,
    waiting: false,
  });
  const currentRenderId = useRef(0);
  !waiting && (currentRenderId.current += 1);

  const mounted = useRef(true);
  useEffect(() => {
    return () => {
      mounted.current = false;
    };
  }, []);

  const safeSet = useCallback((v: T, id?: number) => {
    if (
      mounted.current &&
      (id === undefined || currentRenderId.current === id)
    ) {
      setInner({
        state: v,
        waiting: false,
      });
    }
  }, []);

  const set = useCallback(
    (nextState: PromiseLike<T> | T | ((prev: T) => PromiseLike<T> | T)) => {
      const renderId = currentRenderId.current;

      const next =
        typeof nextState === "function"
          ? (nextState as (prev: T) => PromiseLike<T> | T)(inner)
          : nextState;

      if (typeof (next as Promise<T>).then === "function") {
        setInner((v) => ({
          ...v,
          waiting: true,
        }));

        (next as Promise<T>)
          .then((res) => {
            safeSet(res, renderId);
          })
          .catch?.((err) => {});
      } else {
        safeSet(next as T);
      }
    },
    []
  );

  return [inner, set, waiting];
};
```
