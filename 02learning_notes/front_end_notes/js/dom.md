[toc]

### Input.valueAsNumber & valueAsDate

> [参考](https://www.builder.io/blog/numbers-and-dates)
>
> 浏览器支持度很高，全支持了

通常我们处理 input 输入的数字都是通过 string 转成 number

```jsx
export function NumberInput() {
  const [number, setNumber] = useState(0);

  return (
    <input
      type="number"
      value={number}
      onChange={(e) => {
        const num = parseFloat(e.target.value);
        setNumber(num);
      }}
    />
  );
}
```

但其实浏览器提供了一个自动转换的属性 `valuesAsNumber` 能够省去我们转换 number 的这一步

```jsx
      onChange={(e) => {
        // ✅
        const num = e.target.valueAsNumber
        setNumber(num)
      }}
```

注意：这个属性的类型永远都是 number，但可能会是 `NaN`

```jsx
typeof NaN; // 'number'
```

所以需要多判断一步 `!isNaN(xx)`

同样有 `valueAsDate` 是浏览器自动转换好的 `Date` 对象

```jsx
export function DateInput() {
  const [date, setDate] = useState(null);

  return (
    <input
      type="date"
      value={date}
      onChange={(e) => {
        // ✅
        const date = e.target.valueAsDate;
        setDate(date);
      }}
    />
  );
}
```

如果 input 是空，则会拿到 `null`

```jsx
const date = myDateInput.valueAsDate;
if (date) {
  // We've got a date!
}
```

### Node.appendChild & ParentNode.append

两者都是在元素节点后 append 新的节点

|          | `Node.appendChild`                                       | `ParentNode.append`                                    |
| -------- | -------------------------------------------------------- | ------------------------------------------------------ |
| 功能     | 如果这个节点已经有父节点，则会先移除，后加到新的父节点后 | 插入一组 Node 或者 DOMString                           |
| 参数个数 | 1                                                        | n                                                      |
| 参数类型 | Node only                                                | Node 或者 DOMString（UTF-16 String 就是 js 的 String） |
| 返回     | 返回被插入的 Node 对象                                   | None                                                   |

IE 不支持 append，appendChild 都支持的

### Node.cloneNode()

```js
let newClone = node.cloneNode([deep]); // node.cloneNode(true)
```

克隆一个新的节点对象（尚未加入 document）

deep 如果为 true，会拷贝节点的完整子树以及其中的文本，对空标签没有什么作用（比如 img 和 input）；false 的时候仅 Node 被拷贝

注意：clone 节点可能会导致两个 ID 重复

### Node.nodeType

| Constant                           | Value | Description                                                                                                                                                                                                                    |
| :--------------------------------- | :---- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `Node.ELEMENT_NODE`                | `1`   | An [`Element`](https://developer.mozilla.org/en-US/docs/Web/API/Element) node like [``](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/p) or [``](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div).   |
| `Node.TEXT_NODE`                   | `3`   | The actual [`Text`](https://developer.mozilla.org/en-US/docs/Web/API/Text) inside an [`Element`](https://developer.mozilla.org/en-US/docs/Web/API/Element) or [`Attr`](https://developer.mozilla.org/en-US/docs/Web/API/Attr). |
| `Node.CDATA_SECTION_NODE`          | `4`   | A [`CDATASection`](https://developer.mozilla.org/en-US/docs/Web/API/CDATASection), such as ``.                                                                                                                                 |
| `Node.PROCESSING_INSTRUCTION_NODE` | `7`   | A [`ProcessingInstruction`](https://developer.mozilla.org/en-US/docs/Web/API/ProcessingInstruction) of an XML document, such as ``.                                                                                            |
| `Node.COMMENT_NODE`                | `8`   | A [`Comment`](https://developer.mozilla.org/en-US/docs/Web/API/Comment) node, such as ``.                                                                                                                                      |
| `Node.DOCUMENT_NODE`               | `9`   | A [`Document`](https://developer.mozilla.org/en-US/docs/Web/API/Document) node.                                                                                                                                                |
| `Node.DOCUMENT_TYPE_NODE`          | `10`  | A [`DocumentType`](https://developer.mozilla.org/en-US/docs/Web/API/DocumentType) node, such as ``.                                                                                                                            |
| `Node.DOCUMENT_FRAGMENT_NODE`      | `11`  | A [`DocumentFragment`](https://developer.mozilla.org/en-US/docs/Web/API/DocumentFragment) node.                                                                                                                                |

判断节点是否在 document 上（TODO 改成 es6）

```js
/**
 * 判断元素是否还在doc上
 * @param  {[type]} node [description]
 * @return {[type]}      [description]
 */
function inDoc(node) {
  if (!node) return false;
  var doc = node.ownerDocument.documentElement;
  var parent = node.parentNode;
  return (
    doc === node ||
    doc === parent ||
    // 这里判断 节点类型
    !!(parent && parent.nodeType === Node.ELEMENT_NODE && doc.contains(parent))
  );
}
```

### Node.childNodes

返回子节点的 NodeList，这个 API 在抖音面试的时候用到了（求子节点是 input 的所有节点），不得不说这个 API 的名字有点怪

可以通过 `hasChildNodes` 来判断

注意：childNodes 会返回所有的节点，包括 text，如果只想要 elements，可以用 `ParentNode.children`

### ParentNode.children

### Node.nodeName

好像和 `tagName` 是一样的值，标签都会返回大写（DIV, INPUT...，Read more [details on nodeName case sensitivity in different browsers](http://ejohn.org/blog/nodename-case-sensitivity/).）

和 `tagName` 的区别：Bear in mind, however, that `nodeName` will return `"#text"` for text nodes while `tagName` will return `undefined`.

### Element.getBoundingClientRect()

顾名思义，获取边框长方形，不过这个 client 是什么意思？哦哦客户端上的，所以是实际在 viewport 的大小，**并且是实时的**

众所周知，一个盒子的宽和高是 css 的 width/height + padding + border-width，这个是 W3C（content）盒子，如果是 `box-sizing: border-box`，就只看 width/height

```js
domRect = element.getBoundingClientRect();
// 返回例如下 实时定位
// bottom: -411
// height: 0
// left: -4
// right: 1016
// top: -411
// width: 1020
// x: -4
// y: -411
```

![](https://mdn.mozillademos.org/files/17155/element-box-diagram.png)

可见：

- right - left = _width_ + padding
- bottom - top = _height_ + padding

### HTMLElement.offsetHeight/Top/Left/Width

返回与最近的相对位置（`position: relative`）的父元素 Top 的偏差值

### 滚轮相关

### document.documentElement.scrollTop

滚轮对象，可以通过修改`scrollTop`来进行滚动，其他属性是只读的，先不做了解

获取滚轮高度的值可以这样

```js
const scrollTop =
  window.pageYOffset ||
  document.documentElement.scrollTop ||
  document.body.scrollTop;
```

修改滚轮高度可以这样

```js
const scrollTop =
  window.pageYOffset ||
  document.documentElement.scrollTop ||
  document.body.scrollTop;
const bodyOrHtml = () => {
  if ("scrollingElement" in document) {
    return document.scrollingElement;
  }
  if (window.navigator.userAgent.indexOf("WebKit") != -1) {
    // navigator为浏览器自带对象
    return document.body;
  }
  return document.documentElement;
};
// 定义一个 滚动函数
let start = 0;
const during = 15;
const _run = () => {
  start++;
  // 平滑滚动
  let top = easeInOut(start, scrollTop, offsetTop - scrollTop, during);
  bodyOrHtml().scrollTop = top;
  // 每一帧渲染的时候去滚动
  if (start < during) window.requestAnimationFrame(_run);
};
```

### window.scrollY

滚轮滑动的位置

```js
window.pageYOffset === window.scrollY; // always true
```

```js
// make sure and go down to the second page
if (window.scrollY) {
  window.scroll(0, 0); // reset the scroll position to the top left of the document.
}

window.scrollByPages(1);
```
