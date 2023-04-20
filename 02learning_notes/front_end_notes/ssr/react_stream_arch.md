# React 18 Stream SSR 架构

> [文章](https://github.com/reactwg/react-18/discussions/37)解读

## SSR 现存的问题

1. 在服务端：必须等待所有数据获取后才开始生成 HTML，客户端才能拿到 HTML 展示内容
2. 在客户端：必须加载所有资源（js）才能开始水合
3. 在客户端：必须“水合”所有组件，才能开始交互（按钮可点击）

优化这些问题的思路：Server 端整页渲染拆分到各个组件维度的渲染（**渲染粒度视角：Page → Components**），每个组件所需的数据可以并发的请求数据，而所需最长时间的组件会拖慢整个 HTML 返回到客户端的速度；水合的粒度也随之从 Page → Components，以更好的优先处理需要响应的组件的水合过程。

可以画一下 Rendering Waterfall 图

## v18 新架构

2018 年推出的 `<Suspense>` component 是为了支持客户端渲染的 lazy-loading 组件，React 18 中继续提升 Suspense 的能力来优化 SSR 的渲染性能，带来以下两个新特性，解决了上述提到的三个问题：

- **Streaming HTML** on the server. `renderToString` → `renderToPipeableString`
- **Selective Hydration** on the client. `hydrateRoot` → `<Suspense>`

简述下第二点通过 `<Suspense>` 组件来部分传输 HTML（streaming HTML）的原理：

1. 通过 `<Suspense>` 包裹的组件，React 会认为页面其他部分是不需要等待这个组件，便可以直接开始返回 HTML 给客户端的（streaming HTML），客户端拿到 HTML 后会展示 `fallback` 属性中的等待组件（比如 loading）
2. 当 `<Suspense>` 下的组件在服务端准备完毕之后（拿到了数据），React 会继续在同一个 stream 中往客户端发送 HTML，包含一个极小的 script 脚本用来将 `<Suspense>` 内的等待组件替换成最终的页面组件

这样可以解决第一个**必须等待所有数据才发送 HTML 给客户端**的问题。

顺带提一嘴 RSC(React Server Component)

_Note: for this to work, your data fetching solution needs to integrate with Suspense. Server Components will integrate with Suspense out of the box, but we will also provide a way for standalone React data fetching libraries to integrate with it._

通过组件维度的 code splitting 让水合过程无需等待全部代码加载（**Selective Hydration，我暂且称它为“异步水合”）**

1. 在之前的 SSR 架构客户端水合的过程，是需要等待页面所有 js 代码都加载完之后才开始，包括 `<Suspense>` 下的组件，仍然有
2. 可以通过 `React.lazy` 将组件进行 code spiltting，React 18 中 `<Suspense>` 能让水合过程不受需要等待的组件影响而提前开始。（Previously: To the best of our knowledge, even popular workarounds forced you to choose between either opting out of SSR for code-split components or hydrating them after all their code loads, somewhat defeating the purpose of code splitting.）

这样就解决了第二个**必须等待所有资源加载才能开始水合**的问题，一些逻辑非常重的组件不会阻塞整个页面的水合过程。

文中提到：“In React 18, hydrating content inside Suspense boundaries happens with tiny gaps in which the browser can handle events.”就是说，当 Suspense 的组件在客户端在水合的过程中，也是会进行分片处理，在适当的时机让出线程控制权给浏览器执行事件的处理（类似 fiber 架构），所以 click 事件能够立即被响应，即使在低端机上也不会出现因为过大的水合过程而导致浏览器卡死的现象。

同时当有多个需要异步水合的 Suspense boundary 时，React 水合的顺序是按照 Suspense boundary 在渲染树中出现顺序，但如果有其他未水合的区域有交互触发（比如点击事件），并且此时 js 代码已经加载（只是未水合），React 会在捕获事件的阶段同步地进行这个组件的优先水合（just in time），并且响应这次的点击交互，然后继续按照顺序水合。**这也是为什么水合过程中也会进行分片处理，不阻塞浏览器响应事件交互。**

这也就解决了第三个问题：**必须“水合”所有组件，才能开始交互。**React starts hydrating everything as early as possible, and it prioritizes the most urgent part of the screen based on the user interaction.

需要注意的细节是 React 会优先水合所有的父 Suspense boundaries，跳过无关的邻节点（React will prioritize hydrating the content of all parent Suspense boundaries, but will skip over any of the unrelated siblings.）

`<Suspense>` 里面可以再套 `<Suspense>` 吗？可以，文中给出了例子。

其中文中这一段 Note 比较难读懂但也说明了一些比较关键的细节：

_Note: You might be wondering how your app can work in this not-fully-hydrated state. There are a few subtle details in the design that make it work. For example, instead of hydrating each individual component separately, hydration happens for entire_ _`<Suspense>`_ _boundaries. Since_ _`<Suspense>`_ _is already used for content that doesn't appear right away, your code is resilient to its children not being immediately available. React always hydrates_ **\*in the parent-first order\*\***, so the components always have their props set. React holds off from dispatching events until the entire parent tree from the point of the event is hydrated. Finally, if a parent updates in a way that causes the not-yet-hydrated HTML to become stale, React will hide it and replace it with the\* _`fallback`_ _you specified until the code has loaded. This ensures the tree appears consistent to the user. You don’t need to think about it, but that’s what makes it work._

说的是 React 对于 `<Suspense>` 的水合是从最外层的 `<Suspense>` 边界开始的，而不是对独立的组件进行水合，同时 React 也不会派发交互事件直到他们整个父节点被水合，最后如果父组件的变更导致了内部**尚未水合**的组件陈旧了（父组件的变化导致 props 已经不是水合前的状态，也就是过期 state，不确定理解的对不对？），会被 React **重新**隐藏并渲染 fallback 元素，直到代码被加载完。React 都自动完成了这些。

（个人理解）对于下面这个组件来说，如果 Comments 还没被水合就触发了点击（HTML 已经加载），会从整个最外层的 Suspense Boundary 开始水合，但是会跳过无关的组件。

```jsx
<Layout>
  <NavBar />
  <Suspense fallback={<BigSpinner />}>
    <Suspense fallback={<SidebarGlimmer />}>
      <Sidebar />
    </Suspense>
    <RightPane>
      <Post />
      <Suspense fallback={<CommentsGlimmer />}>
        <Comments />
      </Suspense>
    </RightPane>
  </Suspense>
</Layout>
```

总结，React 18 对于 SSR 的三个问题带来了两个特性来解决：

- 不需要等待所有数据在服务端都获取到才返回 HTML 给客户端。
- 不需要等待全部 JS 加载完才开始水合。
- 不需要等待所有组件都水合完才能进行交互。

最后，`<Suspense>` 虽然是一个可选的能力，但是他解锁了以上这些优化的特性，改改代码的成本也不大 `if (isLoading)` → `<Suspense>`

那么问题来了，React 是如何保持 HTML Request 不断向客户端 stream HTML 的？
