# Web APIs

[toc]

### window.matchMedia

通过媒介查询得到一个布尔值表示当前屏幕是否满足查询的屏幕尺寸

```js
// mqList = window.matchMedia(mediaQueryString)
let mql = window.matchMedia("(max-width: 600px)");
// matches: false
// media: "(max-width: 600px)"
// onchange: null
```

### window.devicePixelRatio

#### 简介

物理像素和 css 像素的比值，也可以看成是：一个 css px 大小对应多少个物理像素

如果你的屏幕物理像素 ppi 很高，那么这个值就会很高啦

#### 何时用

在高分辨率的屏幕（HIDPI or 视网膜屏幕）显示的时候，我们需要更多的像素点来绘制物体，可以得到更清楚点图像

```js
let value = window.devicePixelRatio;
```

返回一个 2 位浮点数，表示 dpr，标准 pc 屏幕 96 dpi 就是 1，如果是 2 的话就是 HiDPI/Retina 啦，这台 mbp 就是。。。更大的话，是通过 物理像素 / 逻辑像素 然后向下取整得到。

**canvas**

在 `<canvas>`上画画的时候，会在高分屏上变得模糊

```js
var canvas = document.getElementById("canvas");
var ctx = canvas.getContext("2d");

// Set display size (css pixels).
var size = 200;
canvas.style.width = size + "px";
canvas.style.height = size + "px";
var scale = window.devicePixelRatio; // Change to 1 on retina screens to see blurry canvas.
canvas.width = Math.floor(size * scale);
canvas.height = Math.floor(size * scale);

// Normalize coordinate system to use css pixels.
ctx.scale(scale, scale);
```

**js**

监听媒介查询内容发生改变

```js
let pixelRatioBox = document.querySelector(".pixel-ratio");
let mqString = `(resolution: ${window.devicePixelRatio}dppx)`; // dppx = device dots per px
// 查询分辨率

const updatePixelRatio = () => {
  let pr = window.devicePixelRatio;
  let prString = (pr * 100).toFixed(0);
  pixelRatioBox.innerText = `${prString}% (${pr.toFixed(2)})`;
};

updatePixelRatio();

window.matchMedia(mqString).addListener(updatePixelRatio);
```

### window.prompt

https://developer.mozilla.org/en-US/docs/Web/API/Window/prompt

```js
const result = window.prompt("prompt", "default-msg-in-the-input");
```

返回值是 string 类型

_可以用 window.prompt 作为 h5 页面和 native 通信的 schema 触发（安卓 4.2.0 以下）_

### window.location

窗口的位置，感觉是窗口定位的 url

| 属性     | 描述                                                                               |
| -------- | ---------------------------------------------------------------------------------- |
| hash     | 从井号 (#) 开始的 URL（ anchor ）                                                  |
| host     | 主机名和当前 URL 的端口号                                                          |
| hostname | 当前 URL 的主机名                                                                  |
| href     | 完整的 URL                                                                         |
| pathname | 当前 URL 的路径部分                                                                |
| port     | 当前 URL 的端口号                                                                  |
| protocol | 当前 URL 的协议                                                                    |
| search   | 从问号 (?) 开始的 URL（查询部分，包含问号）                                        |
| origin   | 只读属性，返回**源**（文件的返回值为`file://`， blob 类型的会得到`blob:`之后的值） |

通常我们会用 `search` 配合 Node 的核心模块 `querystring` 来解析 query 参数

### window.parent/self/top

#### window.parent

如果当前 window 是在 `<iframe>` `<frame>` `<object>`中，就指向外部的 window，否则也就指向自己，也就是 window.self
