# SSR in React

## API

### [hydrateRoot](https://react.dev/reference/react-dom/client/hydrateRoot)

将已经在服务端生成好的（通过 [`react-dom/server`](https://react.dev/reference/react-dom/server)）HTML 代码注水，让 HTML 内容成为 React Component（React 来接管页面内容和交互）

```javascript
const root = hydrateRoot(domNode, reactNode, options?)
```

Returns

`hydrateRoot` returns an object with two methods: [`render`](https://react.dev/reference/react-dom/client/hydrateRoot#root-render) and [`unmount`.](https://react.dev/reference/react-dom/client/hydrateRoot#root-unmount)

- `root.render` to update a React component inside a hydrated React root for a browser DOM element.
- `root.unmount` to destroy a rendered tree inside a React root. 通常完整的 React App 不需要

#### Pitfall

要保证水合后的 HTML 服务端生成的内容一致，不然会让用户看到的内容发生闪动。React 会恢复这些错误，但务必需要自己修复。

可以通过渲染不同的客户端/服务端内容，下面这个组件会正常 match 服务端内容，但是会在第二次 render 后渲染成 Is Client。渲染会变慢，而且会有闪动。

```jsx
import { useState, useEffect } from "react";

export default function App() {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  return <h1>{isClient ? "Is Client" : "Is Server"}</h1>;
}
```

#### 注意 useEffect 在 SSR 的时候不会执行

[useEffect 在 SSR 的时候为什么不执行](https://codewithhugo.com/react-useeffect-ssr/)

> useEffect 只会在 mount/update 之后才会执行（页面上渲染**后**）
>
> Your understanding is correct. useEffect happens _after_ mount/update, but the server doesn’t mount so it doesn’t happen.
>
> — Kent C. Dodds (@kentcdodds) [February 26, 2021](https://twitter.com/kentcdodds/status/1365359744991469570?ref_src=twsrc^tfw)
>
> “it [useEffect] won’t run on the server, but **it also won’t warn**.”
>
> — Hugo (@hugo) February 26, 2021

### [renderToPipeableStream](https://react.dev/reference/react-dom/server/renderToPipeableStream)

_Streaming HTML_

将 React 组件树渲染成 pipeable Node.js Stream

Node 环境专属 API，其他的环境使用 Web Stream 比如 Deno 或者其他 runtimes 需要用 renderToReadableStream。

```javascript
const { pipe, abort } = renderToPipeableStream(reactNode, options?)
```

Options 参数

- bootstrapScripts：string 数组，里面是 url，会作为 `<script>` 标签输出到页面上，在脚本中调用 hydrateRoot，如果不传，就不会在客户端执行 React（纯 Server 渲染的静态页面）
- identifierPrefix：string，给 `useId` 用的 ID 前缀，可用来标示 App 的唯一性
- onAllReady：当所有渲染都完成会触发的回调，包含 shell 和 content
- onError：当服务发生异常会触发
- onShellReady：当初始的 shell 部分内容渲染完成后触发的回调
- onShellError：shell 渲染异常的回调，不会有字节开始 stream，onShellReady 和 onAllReady 也不会触发，需要返回一个 fallback HTML

返回：两个方法

- pipe：将 HTML 输出成 [Writable Node.js Stream](https://nodejs.org/api/stream.html#writable-streams)，当 onShellReady 的时候就可以开始让服务开始 streaming 了，或者在 onAllReady 的时候开始（为了爬虫/静态生成）
- abort：可以终端服务端渲染，让客户端渲染剩余部分

#### shell & content & streaming

因为这个 API 主打流式渲染，能够让客户端更早的渲染出画面，依赖数据的部分可以等到数据返回了再流式传输到客户端渲染。

所以我们通过 `<Suspense>` 组件划分静态骨架部分和依赖数据的部分，前者就称为 shell，后者称为 content，shell 无需数据渲染完成后即可开始传输（onShellReady）

具体的一些用法可以看官网。

SSR 最好还是结合框架去使用，不推荐自己手写框架。

```jsx
const { pipe } = renderToPipeableStream(<App />, {
  bootstrapScripts: ["/main.js"],
  onShellReady() {
    response.statusCode = getStatusCode();
    response.setHeader("content-type", "text/html");
    pipe(response);
  },
  onShellError(error) {
    response.statusCode = getStatusCode();
    response.setHeader("content-type", "text/html");
    response.send("<h1>Something went wrong</h1>");
  },
  onError(error) {
    didError = true;
    caughtError = error;
    console.error(error);
    logServerCrashReport(error);
  },
});
```

### [renderToReadableStream](https://react.dev/reference/react-dom/server/renderToReadableStream)

_Streaming HTML_

renders a React tree to a [Readable Web Stream.](https://developer.mozilla.org/en-US/docs/Web/API/ReadableStream)

是 Web Stream，所以是用在 Web Workder 中或者 Deno 的
