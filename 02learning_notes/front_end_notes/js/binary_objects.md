# 二进制对象们

## Blob（浏览器）

### Binary Large Oject

二进制大对象，在 mysql 中的一个数据字段，是一个存储大量数据的容器（图片、音乐等）

在前端怎么用呢？为什么用呢？

_ps：在哪里遇到的 blob？git 文件夹中的对象类型_

是不可变的，原始数据的类文件对象。[`File`](https://developer.mozilla.org/zh-CN/docs/Web/API/File) 接口基于 `Blob`，继承了 blob 的功能并将其扩展使其支持用户系统上的文件。

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

- size：大小（字节数）

- type：MIME 类型

- slice()：`slice(start[, length[, contentType]])` 分片

  - 从 start 到 length（默认时 size）切分字节

  - 同时也可以重新设置新分片的 type，默认还是原来的 type

- stream(): 返回能读取 blob 内容的[`ReadableStream`](https://developer.mozilla.org/zh-CN/docs/Web/API/ReadableStream)
- text(): 返回一个 promise，包含 blob 的所有内容，用 then 获取
- arrayBuffer(): 返回 promise 包含二进制内容

### 用法

```js
let blob = new Blob(["hello world"], { type: "text/plain" });
```

### 提取一个 Blob

通过 [`FileReader`](https://developer.mozilla.org/en-US/docs/Web/API/FileReader) 来读取，将 Blob 读取成不同格式

```js
const reader = new FileReader();
reader.addEventListener("loadend", (res) => {
  // reader.result contains the contents of blob as a typed array\
  // 这个 res 是 ProgressEvent
  // 里面的 currentTarget 或者 target 的 result
});
reader.readAsArrayBuffer(blob);
```

还可以用 Response 来获取

```js
const text = await new Response(blob).text(); // 得到 string
```

或者直接调用 Blob 的 text 方法

```js
bb.text().then((r) => console.log(r));
```

## File（浏览器）

这个接口提供文件相关信息，是特殊类型的 Blob

JS 中两种获取 File 对象的方法：

- 通过 `<input>` 元素选择文件后返回的 FileList 对象
- 通过元素拖拽生成的 `DataTransfer` 对象

每个 `File` 对象都包含文件的一些属性，这些属性都继承自 Blob 对象：

- `lastModified`：引用文件最后修改日期，为自 1970 年 1 月 1 日 0:00 以来的毫秒数；
- `lastModifiedDate`：引用文件的最后修改日期；
- `name`：引用文件的文件名；
- `size`：引用文件的文件大小；
- `type`：文件的媒体类型（MIME）；
- `webkitRelativePath`：文件的路径或 URL。

### input

```html
<input type="file" id="fileInput" /> // onchange 拿到 e.target.files
```

### 文件拖拽

MDN 有教程，`ondrop` 和 `ondragover` 这两个 API 实现的

定义一个拖拽区

```html
<div id="drop-zone"></div>
```

然后给这个元素添加 `ondragover` 和 `ondrop` 事件处理程序：

```javascript
const dropZone = document.getElementById("drop-zone");

dropZone.ondragover = (e) => {
  e.preventDefault();
};

dropZone.ondrop = (e) => {
  e.preventDefault();
  const files = e.dataTransfer.files;
  console.log(files);
};
```

**注意**：这里给两个 API 都添加了 `e.preventDefault()`，用来阻止默认事件。它是非常重要的，可以用来阻止浏览器的一些默认行为，比如放置文件将显示在浏览器窗口中。

## FileReader

FileReader 是一个异步 API，用于读取文件并提取其内容以供进一步使用。FileReader 可以将 Blob 读取为不同的格式。（上面也记了）

- `readAsArrayBuffer()`：读取指定 Blob 中的内容，完成之后，`result` 属性中保存的将是被读取文件的 `ArrayBuffer` 数据对象；
- `FileReader.readAsBinaryString()`：读取指定 Blob 中的内容，完成之后，`result` 属性中将包含所读取文件的原始二进制数据；
- `FileReader.readAsDataURL()`：读取指定 Blob 中的内容，完成之后，`result` 属性中将包含一个`data: URL` 格式的 Base64 字符串以表示所读取文件的内容。
- `FileReader.readAsText()`：读取指定 Blob 中的内容，完成之后，`result` 属性中将包含一个字符串以表示所读取的文件内容。

可以看到，上面这些方法都接受一个要读取的 blob 对象作为参数，读取完之后会将读取的结果放入对象的 `result` 属性中。

## ArrayBuffer

ArrayBuffer 对象用来表示通用的、固定长度的**原始二进制数据缓冲区**。ArrayBuffer 的内容不能直接操作，只能通过 DataView 对象或 TypedArrray 对象来访问。这些对象用于读取和写入缓冲区内容。

ArrayBuffer 本身就是一个黑盒，不能直接读写所存储的数据，需要借助以下视图对象来读写：

- **TypedArray**：用来生成内存的视图，通过 9 个构造函数，可以生成 9 种数据格式的视图。
- **DataViews**：用来生成内存的视图，可以自定义格式和字节序。

## URL.createObjectURL(object)

object: 用于创建 URL 的 [`File`](https://developer.mozilla.org/zh-CN/docs/Web/API/File) 对象、[`Blob`](https://developer.mozilla.org/zh-CN/docs/Web/API/Blob) 对象或者 [`MediaSource`](https://developer.mozilla.org/zh-CN/docs/Web/API/MediaSource) 对象。

返回 URL 字符串，指定源 `object` 的内容

在每次调用 `createObjectURL()` 方法时，都会创建一个新的 URL 对象，即使你已经用相同的对象作为参数创建过。当不再需要这些 URL 对象时，每个对象必须通过调用 [`URL.revokeObjectURL()`](https://developer.mozilla.org/zh-CN/docs/Web/API/URL/revokeObjectURL) 方法来释放。

```js
revokeObjectURL(objectURL);
```

这个 URL 的生命周期和创建它的 document 绑定，也就是说当前 document 被销毁了（关闭、reload、跳转了...），这个 URL 也就失效了。

举个例子

```js
const bb = new Blob(["(() => {return 123;})()"]);

const url = URL.createObjectURL(bb);
// url
// 'blob:https://developer.mozilla.org/51414a57-9fe8-40a4-8f6d-c996944069f9'
```

在浏览器中打开就可以看到代码了 `(() => {return 123;})()`

可以作为 worker 的脚本来执行！（他是同源的）

注意：

- Web worker 可以用
- Service worker 不可以用

### 检查 image 的大小

> [来自](https://stackoverflow.com/questions/8903854/check-image-width-and-height-before-upload-with-javascript)

```js
var _URL = window.URL || window.webkitURL;
img = new Image();
var objectUrl = _URL.createObjectURL(file);
img.onload = function () {
  alert(this.width + " " + this.height);
  _URL.revokeObjectURL(objectUrl);
};
img.src = objectUrl;
```

## 日常应用

> 参考 https://www.jianshu.com/p/33564726aed8

1、可用于隐藏视频播放器的真实地址
由于需要后台支撑，故可参考[https://blog.csdn.net/qincidong/article/details/82781699](https://links.jianshu.com/go?to=https%3A%2F%2Fblog.csdn.net%2Fqincidong%2Farticle%2Fdetails%2F82781699)

- 需要 server 把数据直接返回到前端，而不是一个 url 或者其他格式？前端来处理成 BlobURL

2、使用 createObjectURL(blob) 输出页面，移动端长按保存，转发。

3、开源代码库可以在线自定义配置文件并下载 JSON，也可以通过 blob 的方式生成。

4、检查 image 的大小

5、预览图片/...，Blob 转 URL
