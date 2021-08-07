# Some code snippets

### Trim End 指定字符

```ts
const trimEndBy = (str: string, dep = " ") =>
  Array.from(str === dep ? "" : str).reduceRight(
    (pre, acc) => (pre === dep ? acc : acc + pre),
    ""
  );
```
