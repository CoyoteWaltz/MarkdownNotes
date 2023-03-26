# nanostores

> [github](https://github.com/nanostores/nanostores)
>
> A tiny state manager for **React**, **React Native**, **Preact**, **Vue**, **Svelte**, **Solid**, **Lit**, **Angular**, and vanilla JS. It uses **many atomic stores** and direct manipulation.
>
> 也是原子化的状态管理库
>
> 非常小：334 and 1064 bytes (minified and gzipped)，无依赖

### API & 使用

```typescript
// store/users.ts
import { atom } from "nanostores";

export const users = atom<User[]>([]);

export function addUser(user: User) {
  users.set([...users.get(), user]);
}

// store/admins.ts
import { computed } from "nanostores";
import { users } from "./users.ts";

export const admins = computed(users, (allUsers) =>
  allUsers.filter((user) => user.isAdmin)
);
```

In React

```tsx
// components/admins.tsx
import { useStore } from "@nanostores/react";
import { admins } from "../stores/admins.js";

export const Admins = () => {
  const list = useStore(admins);
  return (
    <ul>
      {list.map((user) => (
        <UserItem user={user} />
      ))}
    </ul>
  );
};
```

atom 支持原始基础类型，map 开始支持对象类型

支持 Lazy Stores 比较有意思：在 store 被加上 listener 的时候和清除完 listener 的时候会触发的 callback

- **Mount:** when one or more listeners was mount to the store.
- **Disabled:** when store has no listeners.
  - _For performance reasons, store will move to disabled mode with 1 second delay after last listener unsubscribing._

```javascript
import { onMount } from "nanostores";

onMount(profile, () => {
  // Mount mode
  return () => {
    // Disabled mode
  };
});
```

### 体验

细看了源码，写的还是很有意思的，一个 atom store 完成了基础类型变量的状态系统，衍生出 map 处理对象类型，先写的 js 再加的 ts 类型，感觉写起来会方便很多（不用顾及写代码时候的类型了）

支持的场景也比较丰富，computed，action，mapTemplate（可以简化很多相同类型的状态所需的代码）

整体的生态还是比较完善的，支持很多现代框架，看了 [nanostores/react](https://github.com/nanostores/react) 的代码，简单的结合 [`useSyncExternalStore`](https://beta.reactjs.org/reference/react/useSyncExternalStore#usage) 完成的，很棒，又学了一个 hook。

代码还是比较简洁和易懂的，也不多，从 `atom` 开始 `map`，然后到 `task` `action` `lifecycle`...不是很费力

除了 `lifecycle` 那块 `onMount` 这些，要理解他 `on` 的流程。

BTW 这个[作者](https://github.com/ai)非常牛牛牛啊，The creator of Autoprefixer, [@postcss](https://github.com/postcss), [@browserslist](https://github.com/browserslist), and [@logux](https://github.com/logux)
