# Browser APIs

> 渲染：和 [html](../html) 紧密相关

> _`API` is the acronym for Application Programming Interface which defines interactions between multiple software architecture layers. Programmers carry out complex tasks easily using APIs in software development. Without APIs, a programmer's life would have been miserable with no proper(security, for example) access to data, knowing unnecessary low level details etc._
>
> _When it comes to Web APIs, there are extremely useful objects, properties and functions available to perform tasks as minor as accessing DOM to as complex as managing audios, videos, graphics, etc._
>
> -- from https://blog.greenroots.info/10-lesser-known-web-apis-you-may-want-to-use

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

### fullscreen 全屏 API

每个元素都可以做到全屏展示

```javascript
const manageFullscreen = () => {
  document.getElementById("fs_id").requestFullscreen();
};
```

兼容性检查：通过 `document.fullscreenEnabled` 来检查

全屏的 event handlers

- `onfullscreenchange`
- `onfullscreenerror`

### Clipboard Async API

copy cut paste 是最常用的剪切板操作。copy 内容到用户的剪切板是不需要用户权限的，从用户剪切板读取内容是需要用户授权的 [Permission API](https://developer.mozilla.org/en-US/docs/Web/API/Permissions_API)。

兼容性检查：

```javascript
if (
  navigator.clipboard &&
  navigator.clipboard.read &&
  navigator.clipboard.write
) {
  // ...
}
```

copy to clipboard

```javascript
async function performCopy(event) {
  event.preventDefault();
  try {
    await navigator.clipboard.writeText(copyText);
    console.log(`${copyText} copied to clipboard`);
  } catch (err) {
    console.error("Failed to copy: ", err);
  }
}
```

paste

```javascript
const text = await navigator.clipboard.readText();
```

### Resize Observer API

对于元素的 resize 需要做出响应的时候，可以通过 `ResizeObserver`

```jsx
<div>
   <input
         onChange={(event) => resize(event)}
         type="range"
         min={minRange}
         max={maxRange}
         defaultValue={rangeValue} />
</div>

useEffect(() => {
   try {
            let dumbBtn = document.getElementById('dumbBtnId');
            var resizeObserver = new ResizeObserver(entries => {
                for(const entry of entries) {
                    // Get the button element and color it
                    // based on the range values like this,
                   entry.target.style.color = 'green`;
                }
      });
      resizeObserver.observe(dumbBtn);
   } catch(e) {
            setSupported(false);
            console.log(e);
   }
}, [rangeValue]);

```

### Broadcast Channel API

在浏览器 tabs/windows/iframes/worker 进行同源的广播消息，跨 tab 的状态同步很实用吧！

用一个 name 创建一个 channel

```javascript
const CHANNEL_NAME = "greenroots_channel";
const bc = new BroadcastChannel(CHANNEL_NAME);
const message = "I am wonderful!";
```

Post Message!

```javascript
const sendMessage = () => {
  bc.postMessage(message);
};
```

receive message

```javascript
const CHANNEL_NAME = "greenroots_channel";
const bc = new BroadcastChannel(CHANNEL_NAME);

bc.addEventListener("message", function (event) {
  console.log(
    `Received message, "${event.data}", on the channel, "${CHANNEL_NAME}"`
  );
  const output = document.getElementById("msg");
  output.innerText = event.data;
});
```

### Battery Status API

```javascript
navigator.getBattery().then(function (battery) {
  // handle the charging change event
  battery.addEventListener("chargingchange", function () {
    console.log("Battery charging? " + (battery.charging ? "Yes" : "No"));
  });

  // handle charge level change
  battery.addEventListener("levelchange", function () {
    console.log("Battery level: " + battery.level * 100 + "%");
  });

  // handle charging time change
  battery.addEventListener("chargingtimechange", function () {
    console.log("Battery charging time: " + battery.chargingTime + " seconds");
  });

  // handle discharging time change
  battery.addEventListener("dischargingtimechange", function () {
    console.log(
      "Battery discharging time: " + battery.dischargingTime + " seconds"
    );
  });
});
```

### Network Information API

可以看当前的网络状态，根据不同的类型来决定数据、带宽的尺寸

```javascript
console.log(navigator.connection);
```

### Vibration API

可以让设备开始震动。。（移动端吧）

```javascript
useEffect(() => {
  if (start) {
    // vibrate for 2 seconds
    navigator.vibrate(2000);
  } else {
    // stop vibration
    navigator.vibrate(0);
  }
}, [start]);
```

### Bluetooth API

可以开启蓝牙

```javascript
navigator.bluetooth
  .requestDevice({
    acceptAllDevices: true,
  })
  .then((device) => {
    setDeviceName(device.name);
    setDeviceId(device.id);
    setDeviceConnected(device.connected);
  })
  .catch((err) => {
    console.log(err);
    setError(true);
  });
```

### 兼容性

#### [ponyfill](https://github.com/sindresorhus/ponyfill)

> polyfill 会修改全局的代码，ponyfill 的目标是不污染代码，想用就用，需要指定 api 使用。
> 比如 core-js 就提供了 polyfill 和 ponyfill

### scroll

#### scroll() scrollTo()

> 这俩没啥区别，都是滚动到页面的某个位置

```js
window.scroll(x, y);
window.scroll({
  top: 100,
  left: 100,
  behavior: "smooth",
});
```

如果需要平滑滚动，需要用 polyfill（太多了），比如 [smoothscroll](https://github.com/iamdustan/smoothscroll)

#### 判断页面滚动到底部

来自 [stackoverflow](https://stackoverflow.com/questions/9439725/how-to-detect-if-browser-window-is-scrolled-to-bottom)

首先解决 scrollY 的兼容

```js
export function getScrollY() {
  return window.scrollY || window.pageYOffset;
}
```

```js
export function isScrollToEnd() {
  return (
    window.innerHeight + getScrollY() >=
    document.body.offsetHeight - (isiOS() ? 2 : 0)
  );
}
```

### 控制台 tricks

- copy()：可以将接受的所有对象都粘贴到剪切板，**比如组合使用：`copy($_)`**
- 对输入的变量右键“store as global”可以让对象作为变量暂存在控制台中 temp1(2, 3, ...)
- 截图：⌘ + ⇧ + p 呼出面板，输入“screen”就能看到截图选项，可以对 dom 节点、全屏、选取区域进行截图，很不错
- snippets：代码块，在 Sources 里的导航栏选 Snippets 可以新建代码块并且运行，在 ⌘ + p 呼出的输入框中输入`!`也能快速运行
- 一些快捷 alias
  - `$`: document.querySelector
  - `$$`: document.querySelectorAll（返回的是数组不是 nodeList）
  - `$0`: 在 Chrome 的 Elements 面板中， 0 是对我们当前选中的*html*节点的引用。1 是对上一次我们选择的节点的引用，2 是对在那之前选择的节点的引用，等等。一直到 4。
  - `**$_**`**: 对上次执行的结果的引用**
  - `$i`: 在 Dev Tools 里面来使用 npm 插件(e.g.运行`$i('lodash')`你就可以获取到 lodash 了)
- `console.assert()`：第一个参数为 falsy 的时候，会用 error 的方式将第二个参数展示出来
- `console.time`、`console.timeEnd`：一组计时器开关
- `console.log` with CSS：字符串用占位符 %c，后续参数依次就是 CSS 规则

### queryObjects

正巧刷到[这篇](https://www.zhihu.com/question/386595851/answer/1153444476)

发现 devtools 里面有 `queryObjects` 这个东西，可以遍历出 V8 堆上以某对象为原型的对象们，而且执行前会先做一次垃圾回收。

webkit safari 有 `queryHolders(target)` 的函数，它可以找到某个对象被哪些对象所引用了

### 安全上下文环境

> 一些浏览器 API 只有在“安全”的环境才能使用
>
> [MDN](https://developer.mozilla.org/en-US/docs/Web/Security/Secure_Contexts)
>
> 当浏览器 `Window` 或者 `Worker` 满足一些最小标准的时候才能达到 **secure context**，才能使用一些特定的 Web APIs
>
> 主要是为了防范 [MITM](https://en.wikipedia.org/wiki/Man-in-the-middle_attack) 攻击（中间人）

详见 MDN 文档，这里做一些摘要

- 本地传输的资源可以被认为是安全上下文，比如 `http://*.localhost` 或者 `file://` 的 URL
- **Note:** Firefox 84 and later support _http://localhost_ and _http://\*.localhost_ URLs as trustworthy origins (earlier versions did not, because `localhost` was not guaranteed to map to a local/loopback address).
- 检测是否是 secrue context 的 API：[window.isSecureContext](https://developer.mozilla.org/en-US/docs/Web/API/WindowOrWorkerGlobalScope/isSecureContext)
  - 目前还是个试验性 feature

### 地理位置信息 Geolocation.getCurrentPosition()

> [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition)
>
> **安全上下文中可以使用**

#### 用法

`navigator.geolocation.getCurrentPosition(success, error, [options])`

- 前两个是 callback，success 会接收位置信息对象
- options 可以配置 maximumAge（最大缓存时间）timeout（超时的 error cb 执行时间） enableHighAccuracy

```js
// 来自 MDN
var options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0,
};

function success(pos) {
  var crd = pos.coords;

  console.log("Your current position is:");
  console.log(`Latitude : ${crd.latitude}`);
  console.log(`Longitude: ${crd.longitude}`);
  console.log(`More or less ${crd.accuracy} meters.`);
}

function error(err) {
  console.warn(`ERROR(${err.code}): ${err.message}`);
}

navigator.geolocation.getCurrentPosition(success, error, options);
```

### 浏览器 cookie async api

> 活久见系列，不过我还没用过上古世纪就有的 `document.cookie`。。。
>
> 来自 medium 的[文章](https://medium.com/nmc-techblog/introducing-the-async-cookie-store-api-89cbecf401f)

#### 上古 `document.cookie`

我们可以从 [stackoverflow](https://stackoverflow.com/questions/14573223/set-cookie-and-get-cookie-with-javascript/24103596#24103596) 的这个 answer 看到是如何封装一层 cookie 的使用的

#### cookieStore

现在我们能用这个浏览器提供的对象了（chrome 87 开始）

不过感觉还是需要去了解一波 cookie（从数据结构，存的方式开始）

[官网](https://wicg.github.io/cookie-store/)上有很多案例，用到再继续学吧

### 键盘事件 key code

> 参考：https://www.zhangxinxu.com/wordpress/2021/01/js-keycode-deprecated/

不要再用 `keyCode` 啦，已经不被推荐了

原因：

1. 用户自定义案件
2. 键盘不同的按键是同一个字符，对应的 keycode 不同

推荐：

- Event.key：匹配对应的字符
- Event.code：对应按键的唯一码

### HTTP 1.1

Keep-alive: 一个连接中可以发送多个 Request ，接收多个 Response ，但是这两个 R 都是一一对应的，服务端只能被动响应。

### 浏览器打开 url 到页面展示全过程

#### DNS(Domain Name Server)(应用层)

输入 url 之后浏览器当然要往这个 url 所对应 ip 地址的服务器发请求啦

首先要获得 ip 地址

- 浏览器的本地缓存中找
- os 中的 hosts 文件找
- 向 LDNS 本地 DNS 服务器发送请求找
- LDNS 发起向 gTLDserver 主域名服务器寻找
- 发起到对应 Name Server(腾讯云阿里云 DNS)
- 以上任何找到都会在当前缓存 ip 和 TTL，并且返回上级

#### HTTP(应用层)

浏览器向该 ip 发起请求

header:

- url
- method: get/post/delete/put/patch/put/option
- protocol: http/https/...

body: 请求体

#### TCP/UDP TLS(传输层)

##### TCP

- 三次握手，四次挥手，面向连接，全双工通信
- 为什么要三次握手
  - 如果是偶数次的话，客户端的一次在网络中延迟的请求会被服务端当成是连接请求（到达服务端的时候上一次连接已经关闭了，此时服务端以为是新的连接），浪费服务端资源
  - 上述情况，需要客户端再一次确认连接的建立，服务端才正式开始接受请求
- 流量控制

  - 滑动窗口

- 拥塞控制
  - 慢开始
  - 拥塞避免
- 四次挥手

##### UDP

- 不可靠
- 面向数据，高效，快速
- 场景: qq 语音、视频

##### TLS(HTTPS)

- 在 TCP 握手后立刻发起
- 服务器首先发给客户端 CA 证书和服务器的公钥

  - 如何校验一个证书合法主要包括以下几个方面
  - 第一，校验证书是否是由客户端中“受信任的根证书颁发机构”颁发
  - 第二，校验证书是否在上级证书的吊销列表
  - 第三，校验证书是否过期
  - 第四，校验证书域名是否一致

- 浏览器验证证书（用认证中心的公钥解密），成功后创建随机密钥，用公钥加密发送
- 服务器用私钥解密
- 之后的通信都用这个密钥对称加密
  - 对称加密资源消耗小

##### Socket

套接字到底是啥呢，OS，网络中都有

其实他就是实现通信的一种 API 接口，编程实现的！

其实用 python 和 c++都写过......

#### 服务器返回资源和状态码

...

#### 浏览器页面渲染

大致步骤：

1. HTML 代码转化成 DOM
2. CSS 代码转化成 CSSOM（CSS Object Model）
3. 结合 DOM 和 CSSOM，生成一棵渲染树（包含每个节点的视觉信息）
4. 生成布局（layout），即将所有渲染树的所有节点进行平面合成
5. 将布局绘制（paint）在屏幕上

一个网页的资源当然是 html 文件了

逐行解析 html 文件，构造 DOM tree，遇到 CSS 并行构造 CSSOM tree

DOM tree:

- 因为是逐行自上而下解析，所以是 DFS 构造这棵树

CSSOM tree:

- CSS 文件是合并之后再解析成 tree

- 从右往左！

  ```css
  #app .p1 .p2 {
  } /*p2 p1 #app这样dfs构造*/
  #app .h1 .h2 {
  }
  ```

遇到脚本标签**阻塞加载和执行**，因为 js 可能会修改 DOM 和 CSSOM，防止重复遍历，性能重要，有些~~先进的~~浏览器会派一个小 scanner 去扫描后续 document 看看有没有资源 url 可以先去进行下载，可以提速。

之后利用 DOM tree 和 CSSOM tree 生成 render tree，也就是需要真正被显示屏显示的窗口内容了

- tree 中仅有需要显示的元素，display: none 的元素不存在其中
- **回流&重绘**(后文讲)

最后就是显示在页面上

**在 chrome dev tool 看 performance 可以很直观的看到这些环节**

### 回流&重绘

回流和重绘都是对 render tree 的操作

#### 回流 reflow

计算每个节点在设备 viewport（视窗）中确切的位置和大小的过程。从根节点开始 dfs。

回流影响浏览器性能，每次回流都要重新计算和渲染

- 初始化网页

- 改变窗口 size/滚轮

- 改变文字大小

- 添加/删除样式表

- 内容改变

- 激活伪类，:hover/active

- 操作 class 属性？

- 脚本对 DOM 的操作

- 计算 offsetWidth 和 offsetHeight？

- 设置 style

  | 常见的重排元素 |              |                |            |
  | -------------- | ------------ | -------------- | ---------- |
  | width          | height       | padding        | margin     |
  | display        | border-width | border         | top        |
  | position       | font-size    | float          | text-align |
  | overflow-y     | font-weight  | overflow       | left       |
  | font-family    | line-height  | vertical-align | right      |
  | clear          | white-space  | bottom         | min-height |

#### 重绘 repaint

浏览器根据渲染 tree，调用硬件 GPU 的图形 API 绘制页面。

repaint 会在一个元素外观样式发生改变的时候触发，如果元素的位置不发生变化，那就仅仅重绘。

| 常见的重绘元素  |                  |                     |                   |
| --------------- | ---------------- | ------------------- | ----------------- |
| color           | border-style     | visibility          | background        |
| text-decoration | background-image | background-position | background-repeat |
| outline-color   | outline          | outline-style       | border-radius     |
| outline-width   | box-shadow       | background-size     |                   |

#### 性能影响

- 避免一行一行对 dom 操作，选择批量或者 style 用 cssText 或者直接修改元素的 className
-

### html 中 script 标签的 defer 和 async 属性

首先解决为什么要有 defer 和 async 的脚本

- 原因是 html 逐行解析的时候遇到 script 就阻塞解析了，先执行脚本

- 如果加载了第三方的脚本，然后遇到这些脚本下载贼慢，导致阻塞的时候浏览器白屏，用户体验极差

- 所以用 defer 和 async 告诉解析器可以异步执行脚本的加载和执行，dom 解析不会被阻塞

提一下浏览器的 DOMContentLoaded 事件

- 就是在 DOM tree 解析完成触发的事件
- 由于 script 标签阻塞 html 的加载，必然也会影响 DOM tree 的解析时间

以及 load 事件

- 打开任意页面的 network 查看，红线就是 load 的触发时间
- [MDN](https://developer.mozilla.org/zh-CN/docs/Web/Events/load)解释：一个资源及其依赖资源加载完成

#### defer

异步下载脚本文件，在文档渲染完成之后，DOMContentLoaded 事件之前按原始**顺序执行所有被 defer 的脚本文件**

比如 polyfill

顾名思义放（defer）到最后执行嘛

#### async

异步下载脚本文件，异步执行，即加载完就阻塞解析，执行脚本了。

和 DOMContentLoaded 事件的触发时机没关系。

#### 使用场景

脚本依赖 DOM 的 => **defer**

脚本都是比较独立，不依赖其他脚本的数据，不关心 DOM 的（第三方脚本） => **async**

defer 比 async 稳定吧，在 DOM tree 解析完成之前会执行所有的脚本。

### 关于跨~~域~~源

简单的说一下吧

**浏览器**出于**安全**的考虑，有一套同源机制，一个**源**请求另一个不同源的资源的时候，浏览器拦截了数据，不返回给请求方。

安全考虑：防止另一个源的 js 代码对本源代码/页面产生破坏

#### 源

`window.location.origin`

协议 + 域名 + 端口

#### 跨域场景

由于现在主流的请求方法仍然用的 http 协议，微服务架构，以及静态资源和服务器分别部署在不同**域名**的服务器上。所以前端通过 ajax 发送的请求很有可能会收到浏览器同源机制的限制。

p.s. html 中一些标签是不会受到同源限制的：

- `<img>`
- `<script>`
- `<style>`

这些标签通过`src`属性让浏览器获取的资源不会受到跨域限制。

#### 解决跨域方案

1. 服务器在响应头 header 添加 `Access-Control-Allow-Origin`，设置允许访问的源（推荐用这个方法）。相当于设置了一个跨域白名单，这个名单主要呢也是给浏览器看的，因为浏览器在得到响应返回的时候会检查这个白名单，如果请求的**源**不在其中，浏览器就拦截了这个请求，并且在控制台报错。

   简单粗暴就写：`Access-Control-Allow-Origin: *`

2. 利用`<script>`标签，也就是大名鼎鼎的 **JSONP** 跨域，浏览器支持度非常高，缺陷：只能用 get 方式。

   JSONP ：服务端对应`src`配置了一个接口返回内容为一段 js 代码，形式如下，服务器将数据写在一段前端 js 能执的代码中

   ```python
   '''
   callback(
   	'{
   		code: "200",
   		data: ....
   	}'
   )
   '''
   ```

   这个代码在`<script>`中被浏览器执行，所以前端要保证也有`callback`这个回调函数的存在，于是前端会习惯的告知后端一个回调函数的名字，后端只需要把这个 name 放到返回的字符串作为函数名即可，通常的做法是在请求资源的路径后面加上参数`...&callback=CBName`

3. document.domain。不过这种只能适用于不同源页面的访问，像微服务架构这种，服务接口是独立的，所以你没法在页面上设置 document.domain。

4. 服务器代理

   1. 正向代理：前端去请求同源的服务器，这个服务器再去请求真实资源所在的不同源服务器，然后返回给前端。
   2. 反向代理：通常是 nginx 反向代理，用反向代理服务器映射到目标服务器，其实和正向代理没啥区别。。。

#### 后话

面试官问：服务器之间存在跨域吗问题？读了第一句话之后就明白了。

### 跨域时的 options 请求（preflight request）

之前在开发后端的时候也会看到经常有 options 请求进来，但也不知道是啥。现在来好好看看。

其实是在浏览器进行跨域请求的时候做的一次**预检**，用 options 请求获取目的资源所支持的通信选项。

普通的响应包含：

- `Allow`：允许请求的方法

跨域时 Options 的请求头：

- 预检请求报文中的 [`Access-Control-Request-Method`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Access-Control-Request-Method) 首部字段告知服务器实际请求所使用的 HTTP 方法；

- [`Access-Control-Request-Headers`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Access-Control-Request-Headers) 首部字段告知服务器实际请求所携带的自定义首部字段

CORS 的 options 响应：

- [`Access-Control-Allow-Methods`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Access-Control-Allow-Methods) 首部字段将所有允许的请求方法告知客户端。该首部字段与 [`Allow`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Allow) 类似，但只能用于涉及到 CORS 的场景中。

#### 跨域的两种情况

简单请求和非简单请求

**简单请求：**

满足以下三个条件都算：

1. 请求方式只能是：GET、POST、HEAD
2. HTTP 请求头限制这几种字段：Accept、Accept-Language、Content-Language、Content-Type、Last-Event-ID
3. Content-type 只能取：application/x-www-form-urlencoded、multipart/form-data、text/plain

对于简单请求，浏览器不会预检，直接发送正式请求，在请求头中加一个`origin`字段（源：协议 + 域名 + 端口），服务器的响应会多加三个 CORS 相关，都以`Access-Control-`开头：

- Access-Control-Allow-Origin：必须字段，接受的源，或全部`*`或者包含由 Origin 首部字段所指明的**域名**。
- Access-Control-Allow-Credentials：可选字段，boolean，响应头表示是否可以将对请求的响应暴露给页面，返回 true 则可以，其他值均不可以。Credentials 可以是 cookies, authorization headers 或 TLS client certificates。当作为**对预检请求的响应**的一部分时，这能表示是否真正的请求可以使用 credentials。简单请求如果带了 credentials，而响应头中没有这个字段，响应就会被忽略。（参考：[MDN](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Access-Control-Allow-Credentials)）
- Access-Control-Allow-Headers：Access-Control-Allow-Headers：该字段可选，里面可以获取 Cache-Control、Content-Type、Expires 等，如果想要拿到其他字段，就可以在这个字段中指定。
- Access-Control-Max-Age：在这段时间内，浏览器不用再发送预检请求了！注意，浏览器自身维护了一个最大有效时间，如果该首部字段的值超过了最大有效时间，将不会生效。

**非简单请求：**

感觉这里的简单、非简单都是针对这个请求会给服务端造成多大消耗来定义的，避免跨域请求让服务端产生不必要的消耗。

**请求方式是 PUT 或者 DELETE，或者 Content-Type 字段类型是 application/json。都会在正式通信之前，增加一次 HTTP 请求，称之为预检。**

服务器允许之后浏览器才会发出正式的 XMLHttpRequest 请求，否则就提示报错。

**请求头中预检请求不会携带 cookie，正式请求会携带 cookie 和参数。跟普通请求一样，响应头也会增加同样字段。**

#### 对于 CORS 再深入

> 并不一定是浏览器限制了发起跨站请求，也可能是跨站请求可以正常发起，但是返回结果被浏览器拦截了。

CORS，浏览器对网页安全的保护而有的行为，用一组 HTTP 首部字段来实现的，

参考：https://www.jianshu.com/p/5cf82f092201，[MDN-options](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/OPTIONS)，[MDN-CORS](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Access_control_CORS)

### DOMContentLoaded & load

https://www.cnblogs.com/caizhenbo/p/6679478.html

### 页面性能问题

[阮一峰](http://www.ruanyifeng.com/blog/2015/09/web-page-performance-in-depth.html)

reflow 和 repaint 导致性能问题

进行 dom 操作的时候，浏览器已经比较智能的会合并一些样式变化

不过下面这样会导致两次重排重绘，

```javascript
div.style.color = "blue";
var margin = parseInt(div.style.marginTop); // 这里要读取 margin-top 浏览器不得不进行重排 上面改变了 style
div.style.marginTop = margin + 10 + "px";
```

准确地说，写操作之后紧跟一个读操作，就会立刻引发重新渲染。

**所以，从性能角度考虑，尽量不要把读操作和写操作，放在一个语句里面。**

#### 提高性能的九个技巧（摘自阮一峰老师）

有一些技巧，可以降低浏览器重新渲染的频率和成本。

**第一条**是上一节说到的，DOM 的多个读操作（或多个写操作），应该放在一起。不要两个读操作之间，加入一个写操作。

**第二条**，如果某个样式是通过重排得到的，那么最好缓存结果。避免下一次用到的时候，浏览器又要重排。

**第三条**，不要一条条地改变样式，而要通过改变 class，或者 csstext 属性，一次性地改变样式。

> ```javascript
> // bad
> var left = 10;
> var top = 10;
> el.style.left = left + "px";
> el.style.top = top + "px";
>
> // good
> el.className += " theclassname";
>
> // good
> el.style.cssText += "; left: " + left + "px; top: " + top + "px;";
> ```

**第四条**，尽量使用离线 DOM，而不是真实的网面 DOM，来改变元素样式。比如，操作 Document Fragment 对象，完成后再把这个对象加入 DOM。再比如，使用 cloneNode() 方法，在克隆的节点上进行操作，然后再用克隆的节点替换原始节点。

**第五条**，先将元素设为`display: none`（需要 1 次重排和重绘），然后对这个节点进行 100 次操作，最后再恢复显示（需要 1 次重排和重绘）。这样一来，你就用两次重新渲染，取代了可能高达 100 次的重新渲染。

**第六条**，position 属性为`absolute`或`fixed`的元素，重排的开销会比较小，因为不用考虑它对其他元素的影响。

**第七条**，只在必要的时候，才将元素的 display 属性为可见，因为不可见的元素不影响重排和重绘。另外，`visibility : hidden`的元素只对重绘有影响，不影响重排。

**第八条**，使用虚拟 DOM 的脚本库，比如 React 等。

**第九条**，使用 window.requestAnimationFrame()、window.requestIdleCallback() 这两个方法调节重新渲染（详见后文）。

### window.requestIdleCallback()

比较新的 API，详见上文阮一峰文章介绍或者 [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Window/requestIdleCallback)

#### 首屏渲染时间

https://juejin.im/post/5df4294d518825128306cd5c

### http 2

如何升级到 http2：https://zhuanlan.zhihu.com/p/29609078

特性总结：https://www.jianshu.com/p/67c541a421f9

对比 http1.1：https://www.cnblogs.com/baraka/p/11685077.html

### User Agent

一直以为是一种**代理人**（正向代理），就好比浏览器，但认为只是浏览器的对象，看了 [MDN](https://developer.mozilla.org/en-US/docs/Glossary/user_agent) 才发现不止浏览器

> Besides a browser, a user agent could be **a bot scraping webpages**, a download manager, or another app accessing the Web.

每次客户端发到服务器的请求都会带上一个 self-identifying 的 `User-Agent` HTTP header 字段，一般标注了浏览器版本以及操作系统

JS BOM API：[`navigator.userAgent`](https://developer.mozilla.org/en-US/docs/Web/API/Navigator/userAgent)

一个典型的例子：`"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:35.0) Gecko/20100101 Firefox/35.0"`

之前看到有如何解析 UA 的，基本就是用正则字符串匹配

### 代理

面试的时候被问到正向代理和反向代理，反向代理是明白的，但是对于正向代理这个概念缺失非常的模糊。

看了大佬的[这篇文章](https://cjting.me/2018/08/11/forward-proxy-and-reverse-proxy/)之后也有了新的理解。

所谓正向/反向代理实际上是在服务器和客户端之间抽象了一层中间人（代理人）

#### 正向代理

在客户端这一层的代理，就是正向的（请求发送的方向），客户端往代理发送请求，从服务端的视角来看，这个代理就是客户端。

`(客户端 <-> 代理) <-> 服务器`

正向代理的作用/好处：

- 突破限制：五台客户端服务器中只有一台有能力访问公网，那么让其称为代理，其他四个服务器就有了新的能力；我们科学上网其实也可以看成是借助一个代理服务器来访问到被墙了的服务。
- 流量控制 & 统计：公司内网不让你上油管、淘宝这种
- 性能提升：代理服务器缓存经常被访问的网站

#### 反向代理

`客户端 <-> (代理 <-> 服务器)`

作用/好处：

- 突破限制：和正向代理差不多
- 负载均衡：将请求流量按照一定算法分摊到内网的各个服务器。负载均衡的另一个好处是可以实现容灾容错。如果某台服务器宕机了，代理服务器会将请求转发到其他服务器上，客户端不会受到任何影响。
- 加速访问：对于某些大型服务，他们的服务器遍布各地，通过使用反向代理，当请求到来时，代理可以将请求转发给最近的服务器，从而让用户在最短时间内获得响应，这一点其实和 CDN 的工作方式是一样的。

#### 透明代理和显式代理

_在客户端代理（正向）侧才有的概念，服务端的代理在客户端视角其实都是透明的_

透明代理：客户端无法感知有代理的存在，所有的流量都走的代理服务器。

显式代理：客户端显式配置了代理，比如 Chrome 的代理，客户端感知的到代理。

### event.preventDefault & event.stopPropagation & return false

1: 阻止事件的默认行为

2: 阻止事件的冒泡

3: 同时完成上述两个行为

### window.location

#### window.location.search

获得 query string `?xxx=xxx&yyy=yyy`

### DOMTokenList

这个 Web API represents a set of space-separated tokens

只要是以空格隔开的 token list 都可以通过元素上的这个对象来获得，比如 `classList`，`relList`

#### Properties

- length：token 的个数

- value：以空格隔开的字符串

#### Methods

- item(index)：获得下标对应的 token
- contains(token)：类似数组的 includes
- add
- remove
- replace(oldToken, newToken)
- toggle(token [, force)：token 的开关，如果 list 中有，就删了它，如果没有，就 add 它，挺好用的一个 api
- entries：返回可迭代对象，可以进行 for 迭代

兼容性看 [MDN](https://developer.mozilla.org/en-US/docs/Web/API/DOMTokenList) 吧

### 按条件加载 js 代码

来自：https://umaar.com/dev-tips/242-considerate-javascript/

摘要：**selectively downloading**/executing resources such as JavaScript. 在一些场景会加载巨量资源的时候我们要考虑客户端的设备情况

利用一些浏览器接口查询判断设备情况（比如电量、内存、网络情况）

大多设备信息都在 `navigator` 对象上查询

#### navigator.deviceMemory

查询内存大小，单位 GB

同时，http 请求也可以带上这个信息，让 server 返回合适大小的资源

需要加入以下 meta，会在 headers 中加上 `Device-memory`

```html
<meta http-equiv="Accept-CH" content="Device-Memory" />
```

#### navigator.hardwareConcurrency

逻辑处理单元的个数 lpu

#### navigator.getBattery

异步获取设备电池信息

```js
// { level: 0.53 (53%), charging: true...}
const { level, charging } = await navigator.getBattery();

// If the device is currently charging
// Or the battery level is more than 20%
if (charging || level > 0.2) {
  await import("./costly-module.js");
}
```

可以看到这些信息

```js
{
  charging: true,
  chargingTime: 3480,
  dischargingTime: Infinity,
  level: 0.87, // 电量百分比
  onchargingchange: null,
  onchargingtimechange: null,
  ondischargingtimechange: null,
  onlevelchange: null,
}
```

#### navigator.storage

获取存储空间大小

```js
const { quota } = await navigator.storage.estimate(); // quota 定额 单位
const fiftyMegabytesInBytes = 50 * 1e6;

if (quota > fiftyMegabytesInBytes) {
  await import("./costly-module.js");
}
```

还有 `await navigator.storage.persist()` 得到是否持久化存储空间？

#### navigator.connection

```js
{
  downlink: 5.85,
  effectiveType: "4g",
  onchange: null,
  rtt: 200,
  saveData: false
}
```

Downlink gives you the bandwidth in megabits per second. The round-trip time is in milliseconds

```js
// ⚠️ 4g does not mean fast!
if (navigator.connection.effectiveType === "4g") {
  await import("./costly-module.js");
}
```

所以那些查网速的服务是不是直接用浏览器的 API 就可以了呢

同样也可以告诉 server 这个信息

```html
<meta http-equiv="Accept-CH" content="Downlink" />
```

也可以用 `content="ECT"` 把 `effectiveType` 告诉 server。

saveData：如果用户开启了某些限制内存的设置，返回就是 true，此时不推荐下载资源到本地了哦
