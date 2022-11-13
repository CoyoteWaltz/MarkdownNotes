# 一些 hooks 收集

## useCallbackRef

> from myself，作用是对于需要用 ref 的 callback 做了一层语法糖包裹
>
> 其实再猛一点可以直接把 deps 包进去，里面用 useMemo/useCallback
>
> 但为了能够让非 ref 的 callback 依然能正常使用，就还是留了一手

```typescript
import React, { useLayoutEffect, useRef } from 'react';

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

