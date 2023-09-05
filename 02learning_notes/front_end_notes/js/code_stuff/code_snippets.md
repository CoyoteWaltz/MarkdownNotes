# Some code snippets

### Trim End 指定字符

```ts
const trimEndBy = (str: string, dep = " ") =>
  Array.from(str === dep ? "" : str).reduceRight(
    (pre, acc) => (pre === dep ? acc : acc + pre),
    ""
  );
```

### Cache async

```typescript
/**
 * Cache a asynchronous function
 *
 * @param call original call
 * @returns cached call
 */
export function cacheAsync<T extends unknown, U extends unknown[]>(
  call: (...args: U) => Promise<T>
): (...args: U) => Promise<T> {
  let pendingTask: Promise<T>;
  return function (...args: U) {
    if (!pendingTask) {
      pendingTask = call(...args);
    }
    return pendingTask;
  };
}
```
