# MutationObserver

> [MDN](https://developer.mozilla.org/en-US/docs/Web/API/MutationObserver)
>
> 提供监听 DOM tree 变化的能力

使用方法

```javascript
const ob = new MutationObserver(() => {}); // 创建实例 注册回调
ob.observe(node, options); // 监听需要改变的 dom tree
ob.disconnect(); // 移除
```

MutationObserver 构造函数：

- 接收 callback，有两个参数： [`MutationRecord`](https://developer.mozilla.org/en-US/docs/Web/API/MutationRecord) 数组，实例本身
  - `MutationRecord`：
    - type：代表是哪种变化（对应 options）
    - ...其他的看文档吧

observe：

- options：描述了 DOM 发生哪些改变是需要通知调用回调函数的
  - subtree，childList，attributes，attributeFilter，attributeOldValue，characterData，characterDataOldValue，至少有一个是 true

_rrweb 应该用的就是这个？_
