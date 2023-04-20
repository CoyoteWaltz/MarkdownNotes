## Stream API

> [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Streams_API)
>
> Stream 能够让 JS 语言编程式的访问流式数据，开发者可以根据自己的意愿来处理数据
>
> **在 [Web Workders](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API) 也可以用**

流式数据能够使得我们从网络获取的资源拆分成一块一块（chunks），可以一点一点的处理。是浏览器一直使用的资源处理方式，比如视频 buffer。

以前 JS 没有这个能力，我们通常是等到资源完全下载完并且序列化成对应的类型才开始处理。而现在可以在客户端一点点的处理院士和数据，可以检测传输的开始和结束、处理错误、取消传输

浏览器兼容性

Chrome 43，Firefox 65

详细的用到了再继续学
