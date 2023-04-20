## Event Loop & Tasks & Microtasks

[toc]

> JS 基础！

MDN 上有很好的文章说明了 Event Loop 和 JS Tasks Microtasks 是什么，JS 引擎是如何调度单线程的代码执行。

- [Microtask Guide](https://developer.mozilla.org/en-US/docs/Web/API/HTML_DOM_API/Microtask_guide)
- [Microtask Guide In depth](https://developer.mozilla.org/en-US/docs/Web/API/HTML_DOM_API/Microtask_guide/In_depth)

### JS 执行上下文

JS execution contexts，也就是我们熟知的函数调用栈。

在 JS 中有三种方式创建一个新的执行上下文：

- 全局上下文，也就是浏览器按顺序执行我们的代码
- 每个 JS Function 有自己的执行上下文（local context）
- 不推荐使用的 `eval()` 方法也会创建一个新的执行上下文

每次上下文的创建，都执行在上下文栈上（push），代码退出了，上下文也就结束并销毁了（pop）。

对于递归函数我们也知道，每次的自我调用其实都是开辟了新的调用栈，能够在运行时获取每一层调用的结果，也需要注意每次递归创建都需要内存的消耗。（优化？尾递归）

### Event loops

JS 代码在运行时，引擎会维护一系列的**[代理](https://developer.mozilla.org/en-US/docs/Glossary/User_agent)**来执行代码（包含执行上下文、

上下文栈、主线程、其他的线程处理 worker 之类）。一些浏览器还会共享一些代理。

代理是被 event loop 这个东西驱动，用来收集用户交互的 events，处理 task 和 callback，检查待执行的 task，处理所需的渲染和绘制。

_知道哪种情况是复用 event loop 的，也就可以分辨出运行上下文了_

- Window event loop：同源的 window 会跑在同一个 event loop（但也会有不同的情况）
- Worker event loop
- Worklet event loop

There are specific circumstances in which this sharing of an event loop among windows with a common origin is possible, such as:

- If one window opened the other window, they are likely to be sharing an event loop.
- If a window is actually a container within an [`iframe`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/iframe), it likely shares an event loop with the window that contains it.
- The windows happen to share the same process in a multi-process web browser implementation.

#### 一次 loop 执行顺序

1. 执行主线程中的任务（JS Code）
2. 检查微任务队列，如果有待执行任务则执行
3. 微任务队列为空（都执行完毕），检查（宏）任务队列
4. 如果有任务，就开启一个新的 loop iteration（新一轮），将任务 pop 到主线程，**交还控制权给浏览器渲染**，继续执行任务**回到（1）**

任务和微任务之间最重要的差异就在于：一次 loop 中，微任务队列只有被清空了才会开始下一次 loop。同时，在微任务的执行中，也可以继续在微任务队列添加微任务，会在这一次 loop 中执行完毕。

_Microtasks can enqueue new microtasks and those new microtasks will execute before the next task begins to run, and before the end of the current event loop iteration._

**所以，要避免一次 loop 中过长或者是无限的执行微任务，因为他会阻塞 event loop，导致浏览器无法布局/绘制，页面出现卡顿、无法交互。**

#### 解决 JS 带来的卡顿/阻塞

- 用 [web workers](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API)，将主要的代码放在另一个线程执行
- 异步 js，比如 promise

### 触发任务

#### 宏任务

- event 触发的 callback
- [`setTimeout()`](https://developer.mozilla.org/en-US/docs/Web/API/setTimeout)
- [`setInterval()`](https://developer.mozilla.org/en-US/docs/Web/API/setInterval)
- 新的 js 程序（比如来自控制台，新增的 `<script>` 标签）

#### 微任务

- `Promise.then`
- [`queueMicrotask`](https://developer.mozilla.org/en-US/docs/Web/API/queueMicrotask)

微任务其实之前一直被浏览器内部使用，用来处理 promise 的，现在也暴露给开发者 `queueMicrotask` 这个方法，在必要的时候可以将代码加入到全局的微任务队列。能够保证在一些场景执行的代码是同样的顺序，避免难以定位 bug。

### 什么时候使用微任务

在函数结束后，处理、捕获结果或者做一些清理，并且在事件触发前。

有点类似 go 的 `defer`，但在 JS 中很隐晦。

#### 举个例子：保证条件 promise 的执行顺序

```javascript
customElement.prototype.getData = (url) => {
  if (this.cache[url]) {
    this.data = this.cache[url];
    this.dispatchEvent(new Event("load"));
  } else {
    fetch(url)
      .then((result) => result.arrayBuffer())
      .then((data) => {
        this.cache[url] = data;
        this.data = data;
        this.dispatchEvent(new Event("load"));
      });
  }
};
// 实际上如果有 cache（if 条件），就是同步了，对于外层控制会比较 tricky，容易出现 bug
```

所以可以将 if 语句的两个执行都加入到微任务，保证执行顺序一致

```javascript
customElement.prototype.getData = (url) => {
  if (this.cache[url]) {
    queueMicrotask(() => {
      this.data = this.cache[url];
      this.dispatchEvent(new Event("load"));
    });
  } else {
    fetch(url)
      .then((result) => result.arrayBuffer())
      .then((data) => {
        this.cache[url] = data;
        this.data = data;
        this.dispatchEvent(new Event("load"));
      });
  }
};
```

#### 举个例子：批量操作

这个还挺有意思的，可以理解为一次任务（函数执行），sendMessage 被调用第一次就延迟处理（`defer`）一个发送任务，后续调用会收集队列，在函数执行结束（退出上下文）才做最后的处理。

```javascript
const messageQueue = [];

const sendMessage = (message) => {
  messageQueue.push(message);

  if (messageQueue.length === 1) {
    queueMicrotask(() => {
      const json = JSON.stringify(messageQueue);
      messageQueue.length = 0;
      console.log("Goooo", json);
    });
  }
};

function batchSend(...messages) {
  messages.forEach(sendMessage);
}

batchSend(["123", "223", "323", "423", "523"]);
```

猜测 React/Vue 的批量更新 DOM 也是基于微任务队列？

#### 注意：微任务在主线程全部执行完才会执行

```javascript
let callback = () => log("Regular timeout callback has run");

let urgentCallback = () => log("*** Oh noes! An urgent callback has run!");

let doWork = () => {
  let result = 1;

  queueMicrotask(urgentCallback);

  for (let i = 2; i <= 10; i++) {
    result *= i;
  }
  return result;
};

log("Main program started");
setTimeout(callback, 0);
log(`10! equals ${doWork()}`);
log("Main program exiting");

// Main program started
// 10! equals 3628800
// Main program exiting
// *** Oh noes! An urgent callback has run!
// Regular timeout callback has run
```

### queueMicrotask

有了这个 API，可以避免之前通过 promise 去创建微任务的方法所带来的一些问题：比如在微任务中报错了，会被作为“rejected promises”而不是常规的异常错误。

> [在 Chrome 下，非同源的脚本抛出的 unhandled rejection 甚至不会被捕获到](https://stackoverflow.com/questions/40026381/unhandledrejection-not-working-in-chrome)
>
> Q：unhandled promise rejection 要怎么样不被 window.onunhandledrejection 和 unhandledrejection 给捕获 A：把对应的 JS 代码部署在一个跨域的资源服务器上，通过 `<script src="xxx" />` 的形式引入，并且 script 标签不能加上 crossorigin="anonymous"。（只针对部分浏览器有效）

并且创建 promise 也需要额外的时间和内存。

在没有这个 API 之前，通常只有在没有其他解决方案的情况下，或者在创建需要使用微任务的框架或库以创建它们正在实现的功能时，才应该使用微任务。

#### 兼容性

Window 和 Worker 都支持（chrome 71）

Node.js 在 11 开始支持

Deno 1.0 支持

### Next

工作原理的下一步就是深入 JS 引擎去了解这些东西是如何实现的，如何做优化。。
