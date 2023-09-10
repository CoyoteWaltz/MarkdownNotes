# React Server Component

## Dan 文章解读

> 来自 Dan 的 [RSC from scratch](https://github.com/reactwg/server-components/discussions/5)
>
> Deep Dive into _React Server Component_
>
> 文章从零开始实现一个 RSC（三个部分，目前只写了第一部分）

### Part 1: Server Components 解读

开篇坐着时光机回到 php 的年代，展现了 php 版的网页服务

再从现代 Node API 开始，手把手实现一个 SSR 的博客站点：

1. JSX

纯操控 HTML 字符串不太方便，用 JSX 插槽的形式将模版和内容逻辑拆分

2. Components

将内容拆分成组件（名字，props）都是非常合理的（分而治之）

3. 增加路由

不同路由渲染不同的文件

4. Async components

在博客列表中，虽然是不同的 blog 内容，但他们卡片的结构都是相同的，所以渲染也可以是并行的！需要异步了。

5. Preserving navigator state

路由变化后，保留当前页面用户的交互状态，按需刷新页面内容，怎么做呢

拦截 link 的点击，全局监听 `click` 事件，preventDefault，`history.pushState(null, null, href)` 更新 history state，然后调用自己实现的 `navigate` 方法

`navigate`：对 path 进行网络请求（fetch），获取 body 标签中的内容，替换当前 `document.body.innerHTML`

但是仅仅替换 html 内容是不够的，没有交互能力，所以 Dan 这里继续改进，服务端将直接返回 jsx 内容（JSON stringify 之后的 react element tree），更加方便客户端去 diff 那些真正需要替换的内容部分，同样是将渲染好的 Component 返回，于是就得到了一个可以 diff 的数结构（这里就是 react jsx loader 转译出的，其实可以是其他结构，能被 diff 即可）

这里 Dan 引入了 React，因为能更好的满足交互场景，需要对首屏的 html 进行 **hydrate**，`const root = hydrateRoot(document, getInitialClientJSX());`，每次获得新 JSX 之后，`root.render(clientJSX)`，能够更新我们的渲染，并且保留 state

send JSX to client，这里提到了一个 react 的安全机制，就是 jsx 对象必须要有一个特殊标记，才能正常渲染，不然会被认为是其他非自己构建的 jsx 对象，用到了 `JSON.stringify` 的 replacer 方法，并在 client 解析的时候，使用 revive 还原 key（不多提了）

接着来实现 `getInitialClientJSX` 获取第一次的 jsx，可以在服务端直接塞到返回的 html 中，挂在 window 对象上，需要重新生成一次 jsx

6. 整理服务端逻辑

现在有两个渲染，一个是渲染第一次的 html，再一个就是渲染第一次的 jsx，这其实是重复的逻辑，浪费性能，并且会出问题（如果渲染 feed 流，两次会不一致！），所以需要优化流程：先渲染出 jsx，再通过 jsx 生成 html

同样也可以用 react 的 api `renderToString` 来通过 jsx 生成 html。

不同常规 ssr 的是，这里的实现是将组件都在服务端渲染好，然后将 jsx 结果给到客户端去 hydrate，那些自定义的组件都不存在了（变成了他们最后的输出）

所以可以将「jsx 生成」和「渲染 HTML」解耦，拆分成两个**服务**去部署，减少单个服务的 rt，「jsx 生成」在我看来是**结构**渲染，需要数据，可以部署在离数据库近的机房；「渲染 HTML」可以理解是将一套将**结构**（也是很多大厂/搭建喜欢玩的 schema/dsl 概念）渲染成客户端所需渲染内容的服务，可以部署在 edge 端，离客户端更近

至此，第一部分结束，还是挺有意思的

2023.08.30 20:01:38 +0800

## 理解 RSC

> [文章地址](https://juejin.cn/post/7227737293779828794)

结合 Dan 的第一篇文章，再读这篇，能够更加顺畅、快速的理解 RSC 的工作原理，做一些摘录和梳理。

React Server Component 可以解决一些现有技术无法解决或者解决不好的问题，例如：

- 零包大小：React Server Component 的代码只在服务端运行，永远不会被下载到客户端，因此不会影响客户端的包大小和启动时间。而客户端只接收 RSC 渲染完的结果。
- 完全访问后端：React Server Component 可以直接访问后端的数据源，例如数据库、文件系统或者微服务等，而不需要通过中间层来封装或者转换。
- 自动代码分割：React Server Component 可以动态地选择要渲染哪些客户端组件，从而让客户端只下载必要的代码。
- 无客户端-服务器瀑布流：React Server Component 可以在服务器上加载数据并作为 props 传递给客户端组件，从而避免了客户端-服务器瀑布流问题。 避免抽象税：React Server Component 可以使用原生的 JavaScript 语法和特性，例如 async/await 等，而不需要使用特定的库或者框架来实现数据获取或者渲染逻辑。

### 客户端组件

即标准的 React 组件，对服务端组件的限制：

- ❌ 不得使用服务器相关的方法，数据源
- 服务端组件可以作为客户端组件的 children

### 服务端组件

再服务器傻姑娘，每次请求只运行一次，没有状态，不能使用指存在客户端的特性：

- ❌ 没有状态和副作用，useState 类、useEffect 类的 hook 都不能用，自身也不依赖于页面状态（交互状态，存在于客户端上的状态）
- ❌ 不可使用浏览器 API
- ✅ 可以使用异步来访问服务端数据、服务、文件系统等
- ✅ 可以渲染其他服务端组件、原生元素、客户端组件

### RSC 工作流

**一个 ServerComponent 会被渲染成表达 UI 的类 JSON 数据，而客户端组件会转成一个表达脚本引用 JSON 数据。**

> 这个表格挺好，摘录一下

| 运行阶段 | 运行平台 | 服务端组件                              | 客户端组件                                |
| -------- | -------- | --------------------------------------- | ----------------------------------------- |
| 初始加载 | 服务器   | 运行、渲染为 UI JSON                    | 不运行，传递成脚本引用                    |
| 初始加载 | 浏览器   | 不运行、接收到 UI JSON 渲染成 dom       | 运行，解析脚本引用并渲染为 dom            |
| 更新渲染 | 浏览器   | 不运行、请求服务器获取新 UI             | 运行，更新状态                            |
| 更新渲染 | 服务器   | 运行、接收到 props 和路由渲染成 UI JSON | 不运行                                    |
| 更新渲染 | 浏览器   | 不运行、接收到新 UI JSON 更新 dom       | 运行，协调客户端状态和 RSC UI JSON 到 dom |

### 三大特性

渲染完备(Complete)、状态统一(Consistent)、组件互通(Commutative)

第一个问题：

```typescript
function Note({ note }) {
  return (
    <Toggle>
      <Details note={note} />
    </Toggle>
}
```

> 这些组件中，唯一的客户端组件是`Toggle`。它有状态（`isOn`，初始值为 `false`）。它返回 `<>{isOn ? children : null}</>`。 当你 `setIsOn(true)`了以后会发生什么？
>
> 1. 会发起请求获取`Details`
> 2. `Details`会立刻出现

答：切换 Toggle 组件的 on 之后，Detail 会立即出现，因为在服务端首次返回的 UI JSON 中就包含了在服务端已经渲染好的 Details 组件，作为客户端组件 Toggle 的 children 返回了，可以在异步完成后再送到前端。并且在用户改变状态的时候，**由于 `Details` 的 props 和服务端渲染的一致**，客户端可以直接使用服务器预渲染的结果进行 dom 操作。

当 props 不一致时，就请求服务端再次渲染组件并返回给客户端进行渲染。

**我们在 RSC 项目中可以把服务端组件重写成客户端组件，而不需要重写组件调用的特性叫做组件互通“commutative”。**

问题来了，在开发中如何去判断什么时候需要用服务端组件？在 RSC 的使用中其实默认所有组件都是服务端组件，而当需要客户端交互的时候，才会将它改写成客户端组件 `use client`。
