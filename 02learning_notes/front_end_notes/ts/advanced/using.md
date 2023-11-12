# Using Keyword(TS 5.2)

> [TS 5.2 using keyword](https://www.totaltypescript.com/typescript-5-2-new-keyword-using)
>
> **我堪称之为 js 的 destructor（C++）或者是 defer 函数（Golang）**
>
> 能够在对象退出作用域的时候 dispose 一些东西（执行清理函数）
>
> _同样我们也可以用 `Promise.resolve` 来模拟任务结束时的清理（不阻塞当前任务）_
>
> 对于文件处理、数据库连接等一些场景能有很有用
>
> 来自于这个 [proposal: explicit resource management](https://github.com/tc39/proposal-explicit-resource-management)
>
> （目前 2023.06.27 20:17:11 +0800 已经是 stage3，快了）

### 用法

#### 新的全局 symbol

`Symbol.dispose` 对象传给这个属性的方法会认为是一个 resource，一个对象的特殊生命周期，配合 `using` 关键字使用

```javascript
const resource = {
  [Symbol.dispose]: () => {
    console.log("Hooray!");
  },
};
using resource;
```

`Symbol.asyncDispose` 是异步的，同样也配合 `await using` 使用

```javascript
const getResource = () => ({
  [Symbol.asyncDispose]: async () => {
    await someAsyncFunc();
  },
});
{
  await using resource = getResource();
}
```

注意**花括号**，指定一个短一点的作用域

### Use cases

#### 文件处理

常规我们会这么操作。

```javascript
import { open } from "node:fs/promises";
let filehandle;
try {
  filehandle = await open("thefile.txt", "r");
} finally {
  await filehandle?.close();
}
```

用 `using`，可以直接当做 destructor 去处理释放内存/handler 之类的清理操作

```javascript
import { open } from "node:fs/promises";
const getFileHandle = async (path: string) => {
  const filehandle = await open(path, "r");
  return {
    filehandle,
    [Symbol.asyncDispose]: async () => {
      await filehandle.close();
    },
  };
};
{
  await using file = getFileHandle("thefile.txt");
  // Do stuff with file.filehandle
} // Automatically disposed!
```

#### DB 连接

```javascript
const getConnection = async () => {
  const connection = await getDb();
  return {
    connection,
    [Symbol.asyncDispose]: async () => {
      await connection.close();
    },
  };
};
{
  await using { connection } = getConnection();
  // Do stuff with connection
} // Automatically closed!
```

不错。
