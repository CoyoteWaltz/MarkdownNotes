# html 各种标签

### script importmap

[`<script type="importmap">`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/script/type/importmap)

当一个 script 标签的 type 属性为 `importmap` 时，此时内部的内容需要是一个 JSON 对象，能够控制浏览器如何导入 JS 模块，这里是 ESM 的 `import` 语法（表达式 or 动态导入）

```html
<script type="importmap">
  {
    "imports": {
      "square": "./module/shapes/square.js",
      "circle": "https://example.com/shapes/circle.js"
    }
  }
</script>
```

### 标签属性的 boolean 类型

```html
<script src="xxx" defer=""></script>
```

注意看，这个 `defer=""`，实际上 defer 的属性还是生效的

因为：如果是 boolean attribute，**这个属性存在即是 true value，这个属性缺失才代表是 false value**

（[w3c](https://www.w3.org/TR/2010/WD-html5-20100624/author/common-microsyntaxes.html#boolean-attributes): The presence of a boolean attribute on an element represents the true value, and the absence of the attribute represents the false value.)

### 有用的 html 属性

#### `enterkeyhint`

虚拟键盘回车键的提示，移动端常见，比如回车键显示“确认”，“下一个”，“搜索”等。满足 editable 的元素都可以使用。

```html
<input type="text" enterkeyhint="done" />
```

可以是下面这些，但是自定义内容会被降级成默认（如果是 hybrid，肯定需要客户端支持啦）

- `enter`
- `done`
- `go`
- `next`
- `previous`
- `search`
- `send`

#### `<blockquote>` 的 `cite` 属性

```html
<blockquote
  cite="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/blockquote#attr-cite"
>
  A URL that designates a source document or message for the information quoted.
  This attribute is intended to point to information explaining the context or
  the reference for the quote.
</blockquote>
```

#### `<a>` 标签的 `download`

```html
<a href="/example.pdf" download>Download File</a>
```

如果没有指定 `download` 的值，则会强制下载 href 的链接页面，可以给他一个文件路径

#### `<img>` 的 `decoding`

新的属性，告诉浏览器如何 decode 这个图片，和 script 的 async 类似

```html
<img src="/images/example.png" alt="Example" decoding="async" />
```

可以是：

- `sync`：同步解析，浏览器通常是这么做的
- `async`：异步解析，不影响其他内容的展示
- `auto`：交给浏览器自己来处理

浏览器支持度，都支持（chrome 65 开始）

#### `<iframe>` 的 `loading`

img 是有 `loading` 属性来做图片[懒加载](https://developer.mozilla.org/en-US/docs/Web/Performance/Lazy_loading)的（才知道），同样 iframe 也是可以通过 `loading` 属性来做懒加载（快进入 viewport 的时候才加载内容）

```html
<iframe src="/page.html" width="300" height="250" loading="lazy"></iframe>
```

值：

- `eager` 默认行为，不会懒加载
- `lazy`

支持度：主流都支持（chrome 77

### Twitter 的前十行 html

> 读文：https://css-tricks.com/explain-the-first-10-lines-of-twitter-source-code/
>
> 读者作为一个前端面试官（SWE），在考察候选者的时候会问的一个小问题（10/60 的时间），很有意思。综合了 web 的核心（web vitals），无障碍（accessibility），浏览器历史（browser wars）和一些其他的 web 知识。
>
> 这些知识点结合我当下的工作内容（跨端/跨平台/混合开发），感觉对于 web 的理解又更加牢固和深刻了。对于 web 理解的文章后续单独写。这里对于这些 web vitals 做一些记录和学习/温习。
>
> 这篇文章下面的评论也非常有意思，值得一看。前几个 topic 也让我对工作，招聘水平，和现代 web 框架有了一定的思考。

#### 第一行：`<!DOCTYPE html>`

Html 5 规范的声明，用来告诉浏览器，下面的 Document 用 H5 规范来运行和解析（比如 CSS 的 `box-sizing` 都是 `content-box`）

但其实浏览器已经知道接收到文件的 MIME 类型是 text/html 了，为啥还多此一举呢？是因为 browser wars，一些老的浏览器并不只识别标准的 html 规范，所以需要 W3C 统一的标识符。

> **Perfect answer:** This is the document type (doc-type) declaration that we always put as the first line in HTML files. You might think that this information is redundant because the browser already knows that the MIME type of the response is `text/html`; but [in the Netscape/Internet Explorer days](https://css-tricks.com/chapter-8-css/), browsers had the difficult task of figuring out which HTML standard to use to render the page from multiple competing versions.

#### 第二行：`<html dir="ltr" lang="en">`

首先 `<html>` 标签是整个 html 文件的 root element。这里两个属性包含了无障碍和本地化（accessibility and localization）。从这里也可以切入聊一下 screen reader。

`dir` 是 direction，也就是布局的文字阅读顺序，`ltr` = left to right，当然也有 `rtl`，这个其实我本身也就知道，有国外业务会考虑不同的阅读顺序来布局，做到本地化。如果值是 `auto` 就让浏览器自己来决定。

`lang` 肯定不用多说了。

> **Perfect answer:** This is the root element of an HTML document and all other elements are inside this one. Here, it has two attributes, direction and language. The direction attribute has the value left-to-right to tell user agents which direction the content is in; other values are right-to-left for languages like Arabic, or just `auto` which leaves it to the browser to figure out.

#### 第三行：`<meta charset="utf-8">`

这个 meta tag 告诉浏览器下面的所有源码的编码格式（character set），这行放的越早越好（浏览器应该最先解析到这行信息），否则影响性能（以及解析了一部分内容，还需要重新再根据编码解析一遍）

> **Perfect answer:** The meta tag in the source code is for supplying metadata about this document. The character set (char-set) attribute tells the browser which character encoding to use, and Twitter uses the standard UTF-8 encoding. UTF-8 is great because it has many character points so you can use all sorts of symbols and emoji in your source code. It’s important to put this tag near the beginning of your code so the browser hasn’t already started parsing too much text when it comes across this line; I think the rule is to put it in the first kilobyte of the document, but I’d say the best practice is to put it right at the top of `<head>`.

#### 第四行：`<meta name="viewport" content="width=device-...`

让浏览器更好的在小屏幕上缩放，viewport 就是指浏览器展示内容的部分，content 是告诉要以以下特定方式来缩放：

- width=device-width：告诉浏览器用设备的 100% 宽度作为视窗的宽度，这样就不会有水平方向的滚动
- initial-scale=1.0：用户正常看到的尺寸，以及可以缩放的最佳实践
- user-scalable=0：用户不可以缩放

#### 第五行：`<meta property="og:site_name" content="Twitt...`

这个就很有意思了，是我不知道的东西 Open Graph tags。Facebook 发明的一种 protocol，能够更简单的打开链接并在分享的时候能展示出一些缩略的内容。

这个标签不是标准的属性，用 `og:xxx` 来声明一些内容比如 title，site_name，description，url，image 等等

> **Perfect answer:** This tag is an Open Graph (OG) meta tag for the site name, Twitter. [The Open Graph protocol](https://ogp.me/) was made by Facebook to make it easier to unfurl links and [show their previews in a nice card layout](https://css-tricks.com/microbrowsers-are-everywhere/); developers can add all sorts of authorship details and cover images for fancy sharing. In fact, these days it’s even common to auto-generate the open graph image using something like Puppeteer. ([CSS-Tricks uses a WordPress plugin](https://css-tricks.com/automatic-social-share-images/) that does it.)

#### 第六行：`<meta name="apple-mobile-web-app-title" cont...`

这一个标签的 name 其实在 typlog 上也看到过，其实就是在 IOS 上可以直接将网页作为桌面 app，这里的内容就是这个桌面 app 的 icon。

> **Perfect answer:** You can pin a website on an iPhone’s homescreen to make it feel like a native app. Safari doesn’t support progressive web apps and you can’t really use other browser engines on iOS, so you don’t really have other options if you want that native-like experience, which Twitter, of course, likes. So they add this to tell Safari that the title of this app is Twitter. The next line is similar and controls how the status bar should look like when the app has launched.

#### 第七行：`<meta name="theme-color" content="#ffffff"...`

其实就是容器的 UI 样式了，很好理解。

> **Perfect answer:** This is the proper web standards-esque equivalent of the Apple status bar color meta tag. [It tells the browser to theme the surrounding UI](https://css-tricks.com/meta-theme-color-and-trickery/)[.](https://css-tricks.com/meta-theme-color-and-trickery/) Chrome on Android and Brave on desktop both do a pretty good job with that. You can put any CSS color in the content, and can even use the `media` attribute to only show this color for a specific media query like, for example, to support a dark theme. You can also define this and additional properties in the web app manifest.

#### 第八行：`<meta http-equiv="origin-trial" content="...`

这个 meta 标签就比较晦涩，其实搜了下笔记，还是有提到这个 http-equiv 是用来告诉浏览器一些指令。

这里的 `origin-trial` 其实是让浏览器使用一些他自带的原生新特性，比如 Edge 的分屏？（没用过）

> **Perfect answer:** Origin trials let us use new and experimental features on our site and the feedback is tracked by the user agent and reported to the web standards community without users having to opt-in to a feature flag. For example, Edge has an origin trial for dual-screen and foldable device primitives, which is pretty cool as you can make interesting layouts based on whether a foldable phone is opened or closed.

#### 第九行：`html{-ms-text-size-adjust:100%;-webkit-text-size-adjust`

只要给这个属性赋值了，就能阻止浏览器在小屏幕上放大文字，影响自适应性。

> **Perfect answer:** Imagine that you don’t have a mobile responsive site and you open it on a small screen, so the browser might resize the text to make it bigger so it’s easier to read. The CSS [`text-size-adjust`](https://developer.mozilla.org/en-US/docs/Web/CSS/text-size-adjust) property can either disable this feature with the value none or specify a percentage up to which the browser is allowed to make the text bigger.
>
> In this case, Twitter says the maximum is `100%`, so the text should be no bigger than the actual size; they just do that because their site is already responsive and they don’t want to risk a browser breaking the layout with a larger font size. This is applied to the root HTML tag so it applies to everything inside it. Since this is an experimental CSS property, vendor prefixes are required. Also, there’s a missing `<style>` before this CSS, but I’m guessing that’s minified in the previous line and we don’t see it.

P.S. 这应该也不是一个标准 CSS3 的属性，有 -ms 和 -webkit。

#### 最后：`body{margin:0;}`

其实就是对于 css 样式的 reset，解决一些浏览器（可泛指 webview）对内容有一些特殊的样式（加边框啊啥的），解决不同浏览器间的差异（inconsistencies）。也是很常见的。

> **Perfect answer:** Because different browsers have different default styles (user agent stylesheet), you want to overwrite them by resetting properties so your site looks the same across devices. In this case, Twitter is telling the browser to remove the body tag’s default margin. This is just to reduce browser inconsistencies, but I prefer normalizing the styles instead of resetting them, i.e., applying the same defaults across browsers rather than removing them altogether. People even used to use `* { margin: 0 }` which is totally overkill and not great for performance, but now it’s common to import something like `normalize.css` or `reset.css` (or even [something newer](https://css-tricks.com/an-interview-with-elad-shechter-on-the-new-css-reset/)) and start from there.

这里提到一点，对性能不好，浏览器会解析多次 css 进行 reprint。

#### 还有更多

```html
<link
  rel="search"
  type="application/opensearchdescription+xml"
  href="/opensearch.xml"
  title="Twitter"
/>
```

（很有意思）…tells browsers that users can add Twitter as a search engine.

```html
<link
  rel="preload"
  as="script"
  crossorigin="anonymous"
  href="https://abs.twimg.com/responsive-web/client-web/polyfills.cad508b5.js"
  nonce="MGUyZTIyN2ItMDM1ZC00MzE5LWE2YmMtYTU5NTg2MDU0OTM1"
/>
```

…has many interesting attributes that can be discussed, especially `nonce`.

```html
<link rel="alternate" hreflang="x-default" href="https://twitter.com/" />
```

…for international landing pages.

```css
:focus:not([data-focusvisible-polyfill]) {
  outline: none;
}
```

…for removing the focus outline when not using keyboard navigation (the CSS `:focus-visible` selector is polyfilled here).

#### 总结

其实个人觉得浏览器也好，webview 也好，开发者最终的目标（动态化）就是在各平台、各终端（浏览器、移动端、嵌入式设备、等）上用户的体验能达成一致，不免的要去抹平这层差异，核心思路是要对这些差异有足够的意识和认知，在遇到问题的时候也知道如何去 google（寻求解决方案）。于此同时要了解我们所写的 DSL 是在哪一层做了这些事，比如框架，他们为什么要去做（一开始说的），以及怎么做的，遇到新的差异要怎么去做才能更好的不让上层用户感知（更多存在于移动端定制化的混合开发中，对就是我现在干的这破事）。

BTW，这个文章的评论区聊的也很有深度，可以看看。

### 替换元素和非替换元素

#### 替换元素

指浏览器是根据元素的属性来判断具体要显示的内容的元素。

比如 `img` 标签，浏览器是根据其 `src` 的属性值来读取这个元素所包含的内容的，常见的替换元素还有`input` 、`textarea`、 `select`、 `object`、 `iframe` 和 `video` 等等

对于这些元素的处理，浏览器都是根据其某一个属性来替换具体的内容。

比如浏览器会根据 `input` 中的 `type` 的属性值来判断到底应该显示单选按钮还是多选按钮亦或是文本输入框。

相当于是一个 placeholder

#### 非替换元素

比如 `p`、`label` 元素等等，浏览器直接显示元素所包含的内容。

**对于替换的行内元素，给他垂直方向设置`margin`和`padding`是有效果的（可以改变盒子高度），非替换元素是无效的，但还是有`padding`，会对`border`样式有效果，height 只会跟着`line-height`变化**

### meta

meta 元素，承载 metadata 的标签

所谓 metadata 就是描述一个数据的数据，在 html 中就是描述页面的信息：作者、名字等等之类的信息

`meta` 元素定义的元数据的类型包括以下几种：

- 如果设置了 `name` 属性，`meta` 元素提供的是文档级别（_document-level_）的元数据，应用于整个页面。
- 如果设置了 `http-equiv` 属性，`meta` 元素则是编译指令，提供的信息与类似命名的 HTTP 头部相同。
- 如果设置了 `charset` 属性，`meta` 元素是一个字符集声明，告诉文档使用哪种字符编码。
- 如果设置了 `itemprop` 属性，`meta` 元素提供用户定义的元数据。

注意: 全局属性 `name` 在 `meta` 元素中具有特殊的语义；另外， 在同一个 <meta> 标签中，`name`, `http-equiv` 或者 `charset` 三者中任何一个属性存在时，`itemprop` 属性不能被使用。

#### 属性

`charset`

`content`: 具体取决于`name`或`http-equiv`的内容

`http-equiv`: 编译指示指令

`name`: 和`content`配合使用，有`author`，`description`，`keywords`，`viewport`其他详细可见 [MDN](https://wiki.developer.mozilla.org/en-US/docs/Web/HTML/Element/meta/name)

#### 来点例子

```html
<meta charset="utf-8" />

<!-- Redirect page after 3 seconds -->
<meta http-equiv="refresh" content="3;url=https://www.mozilla.org" />

<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
```

### datalist

通常用在输入框，可以增加下拉选项

用法：`input`标签中为`list`属性

```html
<label for="ice-cream-choice">Choose a flavor:</label>
<input list="ice-cream-flavors" id="ice-cream-choice" name="ice-cream-choice" />

<datalist id="ice-cream-flavors">
  <option value="Chocolate"></option>
  <option value="Coconut"></option>
  <option value="Mint"></option>
  <option value="Strawberry"></option>
  <option value="Vanilla"></option>
</datalist>
```

### img

> embeds an image into the document.

所以明显是个替换元素，有 src 属性替换内容（如果 src 为空，则会看到 unknown，Chrome 是这样）

#### properties

`alt`

Alternative text 当图片没能成功加载的时候展示，同时伴随着一个坏掉的图片 icon。

如果不给 `alt` 属性，表示这个 img 是非常重要滴，不能用文字去替代。如果设置 `alt=""`，表示 image is _not_ a key part of the content (it’s decoration or a tracking pixel)，浏览器不会在视口上渲染（DOM 里还是有的），同时会隐藏坏掉的图片 icon。如果没有 `alt` 也是不会展示的。

`loading`

主要是想讲这个属性，决定了浏览器如何加载这张图片

- `eager`(default): 立即 load 图片，不管这个图片是否在 viewport 中

- `lazy`: 延迟图片的加载，直到图片到达一个距离 viewport 计算好的距离（这个距离由浏览器决定），也就是懒加载了。可以节省首屏加载的带宽、时间、性能。

  > **Note:** Loading is only deferred when JavaScript is enabled. This is an anti-tracking measure, because if a user agent supported lazy loading when scripting is disabled, it would still be possible for a site to track a user's approximate scroll position throughout a session, by strategically placing images in a page's markup such that a server can track how many images are requested and when.

  所以在 js 被 disabled 的时候，设置 `loading="lazy"` 是没用的，原因是不想让禁用脚本的浏览器环境能够有服务端 tracking 的能力，因为只要有策略的排布图片的加载顺序，服务端就能根据请求来 track。

做了实验发现这个懒加载的距离很玄学，在 Chrome 85 中大概距离 viewport 底部 1000 多 px 的时候就开始 load 了，`getBoundingClientRect` 和 `window.innerHeight` 来看的。

`sizes`

由多个字符串（逗号分开）来决定图片的 size。

有 **Media Conditions**，来描述 viewport(media) 的属性。

举个例子：`sizes="(max-height: 500px) 1000px"`，在 viewport 高度最大为 500px 的情况下，使用图片的大小为宽度 1000px

`width`

The intrinsic width of the image in pixels. **Must be an integer without a unit.**

#### Styling with CSS

`img`是一个替换元素，默认的 `display` 是 `inline`，替换之后是 `inline-block`，可以在 CSS 中设置 `border`/`border-radius`, `padding`/`margin`, `width`, `height`, etc

最后：MDN 上内容还是很多的，包括 `srcset` 属性，还是去[看看](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/img#attr-alt)吧，以及提到的[Responsive images](https://developer.mozilla.org/en-US/docs/Learn/HTML/Multimedia_and_embedding/Responsive_images)

### link

#### 简介

The **HTML External Resource Link element**

这是一个标明了外部资源和当前文档关系的一个标签元素。大多数情况都是用来 link 样式表的。

也会被用来建立站点图标（ favicon 或者是不同屏幕尺寸 App 的图标）与其他东西的连接？

是**inside `<head>`**

简要的看几个属性：

- `href`: 资源的 URL
- `rel`: 指明关系，非常关键的一个属性
- `media`: 指明这些资源会加载的设备
- `crossorigin`: 标明这个资源是获取是否需要 CORS

例子：

```html
<link rel="icon" href="favicon.ico" />
<link
  rel="apple-touch-icon-precomposed"
  sizes="114x114"
  href="apple-icon-114.png"
  type="image/png"
/>
<!-- media -->
<link href="print.css" rel="stylesheet" media="print" />
<link
  href="mobile.css"
  rel="stylesheet"
  media="screen and (max-width: 600px)"
/>
```

根据媒介查询加载资源

```html
<link href="print.css" rel="stylesheet" media="print" />
<link href="mobile.css" rel="stylesheet" media="all" />
<link
  href="desktop.css"
  rel="stylesheet"
  media="screen and (min-width: 600px)"
/>
<link
  href="highres.css"
  rel="stylesheet"
  media="screen and (min-resolution: 300dpi)"
/>
```

#### 属性

**`as`**

仅会在 `rel="preload"` or `rel="prefetch"`的时候生效，这个 as 指明了加载进来的资源是什么类型的，**只有匹配到这个 as 指明到类型的资源才会被接受**，会设置 Accept 请求头，另外，`rel="preload"`是会用这个作为优先请求信号（？）

这个表对应了 as 的值和应用的资源类型

| Value    | Applies To                                                                                                       |
| :------- | :--------------------------------------------------------------------------------------------------------------- |
| audio    | `<audio>` elements                                                                                               |
| document | `<iframe>` and `<frame>` elements                                                                                |
| embed    | `<embed>` elements                                                                                               |
| fetch    | fetch, XHR _This value also requires `<link>` to contain the crossorigin attribute._                             |
| font     | CSS @font-face                                                                                                   |
| image    | `<img>` and `<picture>` elements with srcset or imageset attributes, SVG `<image>` elements, CSS `*-image` rules |
| object   | `<object>` elements                                                                                              |
| script   | `<script>` elements, Worker `importScripts`                                                                      |
| style    | `<link rel=stylesheet>` elements, CSS `@import`                                                                  |
| track    | `<track>` elements                                                                                               |
| video    | `<video>` elements                                                                                               |
| worker   | Worker, SharedWorker                                                                                             |

**`crossorigin`**

- `anonymous`: 跨域但不发送 credential (i.e. no cookie, X.509 certificate, or HTTP Basic authentication)。如果服务器不设置跨域，这个资源会被 tainted ? 反正使用受限制
- `use-credentials`: 会发 credential 的跨域

如果不设置这个属性，所有的请求 fetch 过来都不是跨域的

**`disabled`**

**For `rel="stylesheet"` only**

像一个开关一样可以按需加载样式表

Setting the `disabled` property in the DOM causes the stylesheet to be removed from the document's [`document.styleSheets`](https://developer.mozilla.org/en-US/docs/Web/API/Document/styleSheets) list.

**`href`**

资源 url

**`media`**

表明了资源只会在这样的媒介类型上面加载

值可以是媒介类型 or [媒介查询](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_queries)

**`rel`**

很重要的属性，表明关系

详见[类型](https://developer.mozilla.org/en-US/docs/Web/HTML/Link_types)

**关于 preload 详见**https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content

**`title`**

一个特殊的语义化的属性，会在`rel="stylesheet"`上定义这个样式表是一个更喜欢的还是一个可选的

**`type`**

MIME 类型，指明对应的类型让浏览器加载。

### input

详见[MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input)

通过定义不同的 type，赋予不同类型内容的输入功能

#### overview

| Type                                                                                             | Description                                                                                                                                                                                                                                                                                                                                                                  | Spec                                                         |
| :----------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------- |
| [button](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/button)                 | A push button with no default behavior displaying the value of the [value](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefvalue) attribute, empty by default.                                                                                                                                                                                    |                                                              |
| [checkbox](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/checkbox)             | A check box allowing single values to be selected/deselected.                                                                                                                                                                                                                                                                                                                |                                                              |
| [color](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/color)                   | A control for specifying a color; opening a color picker when active in supporting browsers.                                                                                                                                                                                                                                                                                 | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [date](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/date)                     | A control for entering a date (year, month, and day, with no time). Opens a date picker or numeric wheels for year, month, day when active in supporting browsers.                                                                                                                                                                                                           | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [datetime-local](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/datetime-local) | A control for entering a date and time, with no time zone. Opens a date picker or numeric wheels for date- and time-components when active in supporting browsers.                                                                                                                                                                                                           | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [email](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/email)                   | A field for editing an email address. Looks like a `text` input, but has validation parameters and relevant keyboard in supporting browsers and devices with dynamic keyboards.                                                                                                                                                                                              | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [file](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file)                     | A control that lets the user select a file. Use the [accept](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefaccept) attribute to define the types of files that the control can select.                                                                                                                                                          |                                                              |
| [hidden](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/hidden)                 | A control that is not displayed but whose value is submitted to the server. There is an example in the next column, but it's hidden!                                                                                                                                                                                                                                         |                                                              |
| [image](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/image)                   | A graphical `submit` button. Displays an image defined by the `src` attribute. The [alt](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefalt) attribute displays if the image [src](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefsrc) is missing.                                                                   |                                                              |
| [month](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/month)                   | A control for entering a month and year, with no time zone.                                                                                                                                                                                                                                                                                                                  | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [number](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/number)                 | A control for entering a number. Displays a spinner and adds default validation when supported. Displays a numeric keypad in some devices with dynamic keypads.                                                                                                                                                                                                              | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [password](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/password)             | A single-line text field whose value is obscured. Will alert user if site is not secure.                                                                                                                                                                                                                                                                                     |                                                              |
| [radio](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/radio)                   | A radio button, allowing a single value to be selected out of multiple choices with the same [name](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefname) value.                                                                                                                                                                                  |                                                              |
| [range](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/range)                   | A control for entering a number whose exact value is not important. Displays as a range widget defaulting to the middle value. Used in conjunction [min](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefmin) and [max](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input#htmlattrdefmax) to define the range of acceptable values. | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [reset](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/reset)                   | A button that resets the contents of the form to default values. Not recommended.                                                                                                                                                                                                                                                                                            |                                                              |
| [search](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/search)                 | A single-line text field for entering search strings. Line-breaks are automatically removed from the input value. May include a delete icon in supporting browsers that can be used to clear the field. Displays a search icon instead of enter key on some devices with dynamic keypads.                                                                                    | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [submit](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/submit)                 | A button that submits the form.                                                                                                                                                                                                                                                                                                                                              |                                                              |
| [tel](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/tel)                       | A control for entering a telephone number. Displays a telephone keypad in some devices with dynamic keypads.                                                                                                                                                                                                                                                                 | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [text](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/text)                     | The default value. A single-line text field. Line-breaks are automatically removed from the input value.                                                                                                                                                                                                                                                                     |                                                              |
| [time](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/time)                     | A control for entering a time value with no time zone.                                                                                                                                                                                                                                                                                                                       | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [url](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/url)                       | A field for entering a URL. Looks like a text input, but has validation parameters and relevant keyboard in supporting browsers and devices with dynamic keyboards.                                                                                                                                                                                                          | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |
| [week](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/week)                     | A control for entering a date consisting of a week-year number and a week number with no time zone.                                                                                                                                                                                                                                                                          | [HTML5](https://developer.mozilla.org/en-US/docs/HTML/HTML5) |

#### file 类型

上传文件

- value: 他的值是一个字符串路径，[is prefixed with `C:\fakepath\`](https://html.spec.whatwg.org/multipage/input.html#fakepath-srsly)，防止被恶意脚本猜到路径。
- 属性：
  - accept: string 指定接受的文件类型
    - 用扩展名指定：`.doc, .xlsx, .docs, .pdf`
    - 或者用 MIME 类型：e.g. `image/*`
  - capture: string 指定获取图片和视频的来源（摄像头）
    - 值为`user`的时候会用前置的镜头和 microphone
    - 值为`environment`时，outward-facing camera
    - 如果不填，则让 ua 自行选择
    - `accept`属性接受的值通常就是`video/audio/image`
    - **在移动端用效果更好！**例子详见[MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/capture)
  - files：获取所有选择上传的文件，`HTMLInputElement.files`返回一个`FileList`对象
  - multiple：boolean 表示是否可以多选文件

设置 input 标签的 value 值不会起作用的。

来看一下 js 的部分

```js
const input = document.querySelector("input");
const preview = document.querySelector(".preview");

input.style.opacity = 0;
```

用 opacity 去隐藏了上传文件的输入框，因为太丑了。。。

用一个 label 即可，为什么不用`display: none`或者`visibility: hidden`呢？

_MDN 解释 assistive technology 会将后两者解析后让 input 不可交互了，试了一下确实如此，但是通过 label 还是可以的。。当然`display: none`更绝一点，浏览器是不画他的位置的，前两个还是会留位置的。_

MDN[例子](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/file#Unique_file_type_specifiers)非常可以！

#### MIME 媒体类型

Multipurpose Internet Mail Extensions 多目的的 internet 邮件拓展？

是一种标准，用来表示文档、文件或字节流的性质和格式。

##### 通用结构

`type/subtype`

##### 独立类型

```fallback
text/plain	// 没有指定subtype的时候 所有text文档都用这个
text/html
image/jpeg
image/png
audio/mpeg
audio/ogg
audio/*
video/mp4
application/*  // 表示某种二进制数据
application/json
application/javascript
application/ecmascript
application/octet-stream  // 未知二进制类型的文件
```

##### multipart

```fallback
multipart/form-data
multipart/byteranges
```

`ultipart/form-data` 可用于联系 [HTML Forms](https://developer.mozilla.org/en-US/docs/Web/Guide/HTML/Forms) 和 [`POST`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Methods/POST) 方法,此外 `multipart/byteranges`使用状态码[`206`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Status/206) `Partial Content`来发送整个文件的子集

更多的是指一个文件被分为多个不同 MIME 类型的子文件，在 email 场景下很常见

##### 重要的 MIME 类型

- application/octet-stream：这是应用程序文件的默认值，意思是 *未知的应用程序文件 ，*浏览器一般不会自动执行或询问执行。浏览器会像对待 设置了 HTTP 头[`Content-Disposition`](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Headers/Content-Disposition) 值为 `attachment` 的文件一样来对待这类文件。
- text/plain：文本文件默认值，也是未知的，但浏览器认为是可以直接展示的。不是意味着某种文本数据，浏览器在需要指定类型的文件时，不会拿 text/plain 的文件去做 match 的。
- text/css：必须要用这个类型去指明是 css 文件，不然浏览器不会去解析，**所以在标签里也会写`type="text/css"`**。服务端如果不能识别`.css`文件，就会返回`text/plain`或者`application/octet-stream`，浏览器就无法识别了。
- text/javascript：只有这个 MIME 类型才会被浏览器识别。

##### image

常用的几个图片类型知道就好

`image/png`

`image/bmp`

`image/jpeg`

`image/svg`

当然这些对浏览器是有不同的兼容性的

##### multipart/form-data

一个表单数据，每个字段算是一个子数据文件，有不同的类型。不同的 part 在传递的时候通过两个 dash 分开，每个 part 都有 http header，对于上传的文件会有`Content-Disposition`和`Content-Type`

### thead

table head，我神他妈以为 thead 是一个单词.......其实就是表头行

### picture(html5)

`<picture>`元素也是用来展示图片的，能够让浏览器在不同场景（屏幕尺寸、分辨率）下选择合适的图片资源来展示。

兼容性：

- ie 不支持

用途：

- 视觉上可以达到更好的用户体验
- 以及减少图片流量、传输带宽
- 选择合适的图片格式（有些浏览器/移动设备不支持）

#### 用法

包含了 0 个或多个`<source>`标签和至少一个`<img>`标签，浏览器会选择合适的`<source>`，将其 URL 赋值给`<img>`，**如果没有`<img>`标签，那么就什么也不展示了。**

_如果旧的浏览器不支持`<picture>`标签，会忽略，只展示渲染其中的`<img>`标签。_

```html
<picture>
  <source
    srcset="/media/cc0-images/surfer-240-200.jpg"
    media="(min-width: 800px)"
  />
  <img src="/media/cc0-images/painted-hand-298-332.jpg" alt="" />
</picture>
```

#### source 标签

利用`srcset`，`media`，`type`属性来告诉 UA 如何匹配合适的图片资源

_是一个空元素，`<source>`不需要闭合标签_

另一个`<img>`标签的作用：

- 用来做图片真正的容器（元素），可以对其作用大小和其他的属性（CSS）
- 如果所有的`<source>`都不满足，就 fallback 到`<img>`上了

来看一下属性：

- srcset：资源集合，由一个字符串表示多个图片资源的描述，用`,`分开。图片的描述由：URL 和宽度或者 DPR 来组成：

  - 宽度：用`w`来表示，比如一张宽 200 的图`xxx.jpg 200w`
  - DPR：用`x`来表示，比如在 DPR 为 2 的屏幕下展示`xxx.jpg 2x`

- type：[MIME type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types)，e.g`type="image/webp"`，表示了这个`<source>`标签`srcset`属性中资源的图片类型，如果浏览器不支持这个 type 就会直接跳过这个`<source>`标签

- media：就是 media query，**只有在`<picture>`中使用`<source>`才能用这个属性**

- sizes：资源的大小（width）集合，多个 size 用`,`分开的一个字符串，可以带 media query。告诉浏览器最后`srcset`中选择的图片最终渲染的**宽度**大小。

  - **注意**：只有资源在`srcset`中用`w`来描述的时候才会生效

  - **注意**：只有是`<picture>`元素的直接子元素的时候才会生效

  - 同样这个属性是可以放到`<img>`元素里的，看上面的笔记！

    ```html
    <source
      sizes="(min-width: 640px) 60vw, 100vw"
      srcset="
        img-200.jpg   200w,
        img-400.jpg   400w,
        img-800.jpg   800w,
        img-1200.jpg 1200w
      "
    />
    ```

PS.这个`<source>`还可以用在`<video>`和`<audio>`元素中，下次[再看](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/source)！

以及，为什么图片的大小都是由宽度决定的呢。是不是因为所有的文档排榜都是从上到下，从左到右？

#### 看个例子

```html
<picture>
  <source
    media="(min-width: 1280px)"
    sizes="50vw"
    srcset="
      img-full-200.webp   200w,
      img-full-400.webp   400w,
      img-full-800.webp   800w,
      img-full-1200.webp 1200w,
      img-full-1600.webp 1600w,
      img-full-2000.webp 2000w
    "
    type="image/webp"
  />
  <source
    media="(min-width: 1280px)"
    sizes="50vw"
    srcset="
      img-full-200.jpg   200w,
      img-full-400.jpg   400w,
      img-full-800.jpg   800w,
      img-full-1200.jpg 1200w,
      img-full-1600.jpg 1800w,
      img-full-2000.jpg 2000w
    "
  />

  <source
    sizes="(min-width: 640px) 60vw, 100vw"
    srcset="
      img-200.webp   200w,
      img-400.webp   400w,
      img-800.webp   800w,
      img-1200.webp 1200w,
      img-1600.webp 1600w,
      img-2000.webp 2000w
    "
    type="image/webp"
  />
  <img
    src="img-400.jpg"
    sizes="(min-width: 640px) 60vw, 100vw"
    srcset="
      img-200.jpg   200w,
      img-400.jpg   400w,
      img-800.jpg   800w,
      img-1200.jpg 1200w,
      img-1600.jpg 1600w,
      img-2000.jpg 2000w
    "
  />
</picture>
```

### pre(html5)

块级元素，`<pre>`元素代表一个 _preformatted_ 的文本，预先格式化好的，在什么地方预先了呢？在 HTML 文件中！

会展示 HTML 文件中一摸一样的编辑格式，比如下面

```html
<pre>
  L          TE
    A       A
      C    V
       R A
       DOU
       LOU
       111
       141
      REUSE
      QUE TU
      PORTES
    ET QUI T'
    ORNE O CI
     VILISÉ
    OTE-  TU VEUX
     LA    BIEN
    SI      RESPI
            RER       - Apollinaire
</pre>
```

会用 `monospace` 的字体来渲染，空格有多少就展示多少。

可以在 JSX 中用 JSON.stringify 来展示对象信息

```jsx
<pre>{JSON.stringify(obj, null, 2)}</pre>
```

### manifest 离线缓存（html5）

说句题外话，一直对 manifest 这个单词无法理解（学不会），名词意思：旅客名单（a list of passages)

离线缓存为的是第一次请求后，根据 manifest 文件进行本地缓存，并且在下一次请求后进行展示（若有缓存的话，无需再次进行请求而是直接调用缓存）

最根本的感觉是它使得 Web 从 online 可以延伸到了 offline 领域。

几大优点：

- 离线浏览 – 用户可在应用离线时使用它们。
- 速度 – 已缓存资源加载得更快。
- 减少服务器负载 – 浏览器将只从服务器下载更新过或更改过的资源。
- 浏览器支持：所有主流浏览器均支持应用程序缓存，除了 Internet Explorer。对于移动端来说浏览器不是问题。

#### 如何使用

```html
<!DOCTYPE html>
<html manifest="demo.appcache"></html>
```

需要一个 manifest 文件（在服务端的某个 url）来告诉浏览器如何缓存

manifest 文件的后缀名必须为`.appcache`，并且和引入该 manifest 的页面同源

一个 manifest 文件分为几个部分：

- `CACHE MANIFEST` – 在此标题下列出的文件将在首次下载后进行缓存
- `NETWORK` – 在此标题下列出的文件需要与服务器的连接，且**不会被缓存**
- `FALLBACK` – 在此标题下列出的文件规定当页面无法访问时的回退页面（比如 404 页面）

看个例子：

```json
CACHE MANIFEST
#v0.0.1.1    // 版本号
/mobile/style/zxx.css
/mobile/js/jquery.min.js
/mobile/js/jquery.lazyload.min.js
/mobile/js/zxx.js
/mobile/style/fonts/icomoon.svg
/mobile/style/fonts/icomoon.eot
/mobile/style/fonts/icomoon.ttf
/mobile/style/fonts/icomoon.woff

NETWORK:
*

FALLBACK:
/html5/ /404.html
// 在此标题下列出的文件规定当页面无法访问时，则用 404.html 替代 /html5/ 目录中的所有文件 可写可不写
```

#### 进行查看

Chrome -> f12 -> Application -> Application Cache

#### 运行机制

浏览器第一次读取到页面有 xxx.appcache 文件时，在加载页面之前去检查 application Cache 是否有缓存，有则优先加载缓存，没有则会在其他资源加载完后再把 demo.appcache 文件及里面所规定的静态资源一并存入 application Cache 之中。且也会把当前页面的 html 直接读出来存入 application Cache 中，其类型为 master。

用户再次联网打开页面时，页面加载到 manifest 时，会对 manifest 配置文件进行脏检查，当检测到 manifest 文件被修改后，之前的缓存将会被弃用，转而去根据 manifest 文件中配置的新内容进行缓存。如果断网打开页面，会优先读取 application Cache，有缓存就直接读出来，不会提示断网

_但是问题是，当前的 html 页面也会跟着 cache 直接读出来了，可能会造成即使 我们的页面更新了，但是用户还是看的老旧版本页面（因为更新 mainfest 的时候，页面加载已经开始了，但是缓存更新却尚未完成，浏览器还是会使用缓存的资源，当浏览器检测到了 Application Cache 有更新时，本次不会使用新的资源，下一次才会进行使用）。_

#### 刷新缓存

```js
applicationCache.addEventListener(
  "updateready",
  function () {
    applicationCache.swapCache(); // 手工更新本地缓存
    location.reload(); //重新加载页面页面
  },
  true
);
```

#### 下线缓存

服务端的 manifest 文件删除即可，同时也要将 HTML 中的 manifest="manifest.appcache" 删除

### figure

**Figure With Optional Caption**

图像（例如`<img>`）或者可选的字幕（`<figcaption>`）的父元素

```html
<figure>
  <img src="/media/cc0-images/elephant-660-480.jpg" alt="Elephant at sunset" />
  <figcaption>An elephant at sunset</figcaption>
</figure>
```

Usually a `<figure>` is an image, illustration, diagram, code snippet, etc.

看个`<pre>`的例子

```html
<figure>
  <figcaption>Get browser details using <code>navigator</code>.</figcaption>
  <pre>
function NavigatorExample() {
  var txt;
  txt = "Browser CodeName: " + navigator.appCodeName + "; ";
  txt+= "Browser Name: " + navigator.appName + "; ";
  txt+= "Browser Version: " + navigator.appVersion  + "; ";
  txt+= "Cookies Enabled: " + navigator.cookieEnabled  + "; ";
  txt+= "Platform: " + navigator.platform  + "; ";
  txt+= "User-agent header: " + navigator.userAgent  + "; ";
  console.log("NavigatorExample", txt);
}
  </pre>
</figure>
```

#### `figcaption`

caption 元素，会根据不同的 figure 去到不同的位置（浏览器决定）

### 全局属性 `data-*`

> [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/data-*)
>
> 标签上的自定义属性，可以通过脚本在 HTML 和 DOM 之间设置/获取信息

#### html 属性

```html
<ul>
  <li data-id="10784">Jason Walters, 003: Found dead in "A View to a Kill".</li>
  <li data-id="97865">
    Alex Trevelyan, 006: Agent turned terrorist leader; James' nemesis in
    "Goldeneye".
  </li>
  <li data-id="45732">
    James Bond, 007: The main man; shaken but not stirred.
  </li>
</ul>
```

一些规则：

- 属性名以 `data-` 开头，只能包含字母、数字、dashes(`-`)、periods(`.`)、colons(`:`) and underscores(`_`)
- 大写字母都会被转成小写

#### css 获取 attr

可以通过 `attr(data-*) ` 得到对应的字符串的值

#### JS DOM 获取

API：通过 `HTMLElement.dataset.keyName` 来获取

这的 `dataName` 就是 html 里面 dash 连接的名字 `data-key-name`，都会被转成 camelCased `keyName`。

#### 应用场景

类似自定义属性，能给不同的 html 标签给上统一的属性（比如 vue 的自定义属性），来干点什么事情。

实际例子：

H5 开发的时候，点击后不失去焦点、同时触发点击

```ts
export default function hideKeyboardOnTouch() {
  // 滚动或点击时收起软键盘
  let shouldInterceptClick = false;
  let shouldInterceptScroll = false;
  const initialHeight = window.innerHeight;
  let currentHeight = window.innerHeight;
  window.addEventListener("resize", () => {
    if (
      window.innerHeight === initialHeight &&
      window.innerHeight > currentHeight
    ) {
      if (
        document.activeElement &&
        document.activeElement.tagName &&
        (document.activeElement.tagName.toLowerCase() === "input" ||
          document.activeElement.tagName.toLowerCase() === "textarea")
      ) {
        (document.activeElement as HTMLElement).blur();
      }
    }
    currentHeight = window.innerHeight;
  });
  document.addEventListener(
    "touchstart",
    (e) => {
      if (
        document.activeElement &&
        document.activeElement.tagName &&
        (document.activeElement.tagName.toLowerCase() === "input" ||
          document.activeElement.tagName.toLowerCase() === "textarea")
      ) {
        if (e.target) {
          const target = e.target as HTMLElement;
          const tagName = target.tagName.toLowerCase();
          if (
            tagName === "input" ||
            tagName === "textarea" ||
            (target.dataset && target.dataset.keepKeyboard)
          ) {
            shouldInterceptScroll = isIOS;
            shouldInterceptClick = false;
          } else {
            if (isIOS) {
              (document.activeElement as HTMLElement).blur();
            }
            shouldInterceptClick = true;
          }
        } else {
          shouldInterceptClick = false;
          shouldInterceptScroll = false;
        }
      } else {
        shouldInterceptClick = false;
        shouldInterceptScroll = false;
      }
    },
    true
  );

  if (isIOS) {
    document.addEventListener(
      "touchend",
      () => {
        shouldInterceptScroll = false;
      },
      true
    );
    document.addEventListener(
      "scroll",
      () => {
        if (shouldInterceptScroll) {
          // iOS上滑动时收起软键盘
          (document.activeElement as HTMLElement).blur();
        }
      },
      true
    );
  }
  document.addEventListener(
    "click",
    (e) => {
      if (e.target) {
        const target = e.target as HTMLElement;
        const tagName = target.tagName.toLowerCase();
        if (tagName === "input" || tagName === "textarea") {
          return;
        }
      }
      if (shouldInterceptClick) {
        e.stopPropagation();
        e.preventDefault();
        // Android上因为键盘会resize页面，滑动时收起会卡顿，所以只在点击时收起
        if (!isIOS) {
          (document.activeElement as HTMLElement).blur();
        }
      }
    },
    true
  );
}
```
