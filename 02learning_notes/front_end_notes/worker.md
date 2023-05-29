# Web Worker

> 参考文章：
>
> - [阮一峰教程](https://www.ruanyifeng.com/blog/2018/07/web-worker.html)
> - [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Worker)

### 是什么

增强浏览器单线程处理 js 的能力，创建多线程环境，充分发挥计算机多 CPU 内核的功效。

一些限制：

- **同源限制**
  - 分配给 Worker 线程运行的脚本文件，必须与主线程的脚本文件同源
- **DOM 限制**
  - 与主线程隔离的 runtime 线程，没有办法读到 DOM，`document`、`window`、`parent`这些对象。但是，Worker 线程可以`navigator`对象和`location`对象
- **通信联系**
  - 线程间通过事件/消息通信
- **脚本限制**
  - Worker 线程不能执行`alert()`方法和`confirm()`方法，但可以使用 XMLHttpRequest 对象发出 AJAX 请求（`responseXML` and `channel` 属性都是 `null`）
- **文件限制**
  - 安全限制，不能读取本地的文件（`file://` 开头的）

[web worker，service worker worklet 之间的区别](https://www.jianshu.com/p/e2cdc78ff47c)

### 怎么用

> 具体 api 看文章吧，用的时候在学

Lib 推荐：https://github.com/GoogleChromeLabs/comlink
