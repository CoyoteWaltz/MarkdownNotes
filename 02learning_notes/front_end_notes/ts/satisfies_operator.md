# satisfies 操作符

> 参考[文章](https://www.builder.io/blog/satisfies-operator)
>
> 一句话描述解决的问题是之前对于对象类型属性更好推导和确认具体的值，比 as 更好用，实战场景主要是对 `Record<string, xx>` 的 key 做更好的推导
>
> **4.9.x 的新关键词**，好东西，快升级吧！

### why

举例子：

```typescript
type Route = { path: string; children?: Routes };
type Routes = Record<string, Route>;

const routes: Routes = {
  AUTH: {
    path: "/auth",
  },
};
```

这种情况，`Routes` 的 key 只要是 string 都可以，所以会出现：

```typescript
routes.UNKNOW.path; // UNKNOW 这个 key 不在 routes 上，但不会被 ts 检查出来
```

所以 `satisfies` 就是用来解决精准推断的，同时也可以检查出一些 typo 问题

```typescript
type Route = { path: string; children?: Routes }
type Routes = Record<string, Route>

const routes = {
  AUTH: {
    path: "/auth",
  },
} satisfies Routes; // 😍
```

不要再用 as 了，因为直接完全跳过了 ts 检查，如果在对象上乱加属性 ts 是不知道的。

### 和 `as const` 一起使用

能够更好的推断出具体的字面量值

```typescript
const routes = {
  HOME: { path: '/' }
} as const satisfies Routes
```

此时 `routes.HOME.path` 的类型是 `/` 而不是 `string` 了，能够更好的满足类型准确性
