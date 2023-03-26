# XMLHttpRequest

> [XMLHttpRequest](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) 是前端 JS 动态性离不开的东西（当然也可以用 fetch）

### 题外话

工作排查问题的时候，看到公司内一个 CSRF SDK 的运行逻辑所引发对 XMLHttpRequest 的探索

首先简单讲一下 CSRF SDK（针对 Web，非 Native 请求，Native 请求就是 App/通过 JSB 发起的请求）这个安全 SDK 主要做了什么：

- hook XMLHttpRequest
- hook fetch
