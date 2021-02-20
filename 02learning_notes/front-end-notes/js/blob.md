## Blob（浏览器）

### Binary Large Oject

二进制大对象，在 mysql 中的一个数据字段，是一个存储大量数据的容器（图片、音乐等）

在前端怎么用呢？为什么用呢？

_ps：在哪里遇到的 blob？git 文件夹中的对象类型_

是不可变的，原始数据的类文件对象。[`File`](https://developer.mozilla.org/zh-CN/docs/Web/API/File) 接口基于`Blob`，继承了 blob 的功能并将其扩展使其支持用户系统上的文件。

可以用`slice(start[, length])`方法创建一个 blob 的子集，length 表示字节数

### 构造函数

```js
let blob = new Blob(array, options);
```

- array: [`ArrayBuffer`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer), [`ArrayBufferView`](https://developer.mozilla.org/zh-CN/docs/Web/API/ArrayBufferView), [`Blob`](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob), [`DOMString`](https://developer.mozilla.org/zh-CN/docs/Web/API/DOMString) 等对象构成的 [`Array`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Array) ，或者其他类似对象的混合体，它将会被放进 [`Blob`](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob)。DOMStrings 会被编码为 UTF-8。
  - ArrayBuffer 是通用的、固定长度的原始二进制数据缓冲区。不能直接操作 `ArrayBuffer` 的内容，而是要通过[类型数组对象](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)或 [`DataView`](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/DataView) 对象来操作，它们会将缓冲区中的数据表示为特定的格式，并通过这些格式来读写缓冲区的内容。只能看 length
    - 类型对象数组`TypedArray`，是 ArrayBuffer 原始二进制数组的一个类型数组视图，没有这个全局的`TypedArray`，详见[MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/TypedArray)。其实就是有指定类型的数组构造函数。
  - 其实宏观看就是字节数组类型
- options: type，endings 属性
  - type: 默认`''`，代表 blob 数组内容的 MIME 类型（Multipurpose Internet Mail Extensions）
  - endings: 默认 transparent，指定含有结束符`\n`的字符串如何被写入。native：更改为适合宿主操作系统文件系统的换行符。transparent 会保持 blob 中的结束符不变。

### 属性/方法

- size：大小（字节）

- type：类型

- slice()：`slice(start[, length])`

- stream(): 返回能读取 blob 内容的[`ReadableStream`](https://developer.mozilla.org/zh-CN/docs/Web/API/ReadableStream)
- text(): 返回一个 promise，包含 blob 的所有内容，用 then 获取
- arrayBuffer(): 返回 promise 包含二进制内容

### 用法

```js
let blob = new Blob(["hello world"], { type: "text/plain" });
```

## URL.createObjectURL(object)

object: 用于创建 URL 的 [`File`](https://developer.mozilla.org/zh-CN/docs/Web/API/File) 对象、[`Blob`](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob) 对象或者 [`MediaSource`](https://developer.mozilla.org/zh-CN/docs/Web/API/MediaSource) 对象。

返回 URL 字符串，指定源`object`的内容

在每次调用 `createObjectURL()` 方法时，都会创建一个新的 URL 对象，即使你已经用相同的对象作为参数创建过。当不再需要这些 URL 对象时，每个对象必须通过调用 [`URL.revokeObjectURL()`](https://developer.mozilla.org/zh-CN/docs/Web/API/URL/revokeObjectURL) 方法来释放。

```js
revokeObjectURL(objectURL);
```
