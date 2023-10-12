### 浏览器 localStorage 溢出

页面存储在 local storage 的内容过多，导致溢出，会抛出异常

[DOMException](https://developer.mozilla.org/en-US/docs/Web/API/DOMException) 类型

他的 `name` 属性会包含错误类型：

- `QuotaExceededError`：超出容量
