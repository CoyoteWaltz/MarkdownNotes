# Media Query

媒介查询，当我们的应用需要在不同类型的设备上运行的时候，我们可以通过查询设备 viewport 的尺寸/分辨率来适配我们的样式、图片、资源的大小。

## 用途

- 根据条件来应用 CSS 样式，`@media`和`@import`（这两个叫 at-rule，@规则），实现**响应式的样式**！
- 标记特殊媒体在 html 上的元素：`<style>`，`<link>`，`<source>`以及其他有`media`属性的元素标签
- [`Window.matchMedia()`](https://developer.mozilla.org/en-US/docs/Web/API/Window/matchMedia) and [`MediaQueryList.addListener()`](https://developer.mozilla.org/en-US/docs/Web/API/MediaQueryList/addListener) [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript) methods.

## 语法

既然能在 CSS 的 at-rule 中用，必然是有一定语法的。

首先，查询什么？如何表示？

查询的是媒介的类型（media type），然后用一个表达式来描述它的尺寸特性，这样就组成了查询运语句（media query），注意是大小写敏感的。多个表达式可以用逻辑操作符来连接组合，当这个表达式的内容满足实际的设备条件就返回 true。

media type + media feature

### media type

描述一个大类的设备，除非用`not`，`only`这样的操作符。这个字段也是可选的，会用`all`类型来兜底。

- `all`：所有设备都应用
- `print`：页面/文档在打印模式下的预览
- `screen`：有屏幕的设备
- `speech`：会话合成器？？？

### media feature

挺多的。。感觉用的最多的也就是`width`，`height`，`hover`（设备允许用户在元素上 hover 的），**表达式必须要用圆括号包住**

- `prefers-color-scheme`：检测用户是否会调用系统切换 light/dark 模式，详见 [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme)，语法：`light`，`dark`

  ```css
  .theme-a {
    background: #dca;
    color: #731;
  }
  @media (prefers-color-scheme: dark) {
    .theme-a.adaptive {
      background: #753;
      color: #dcb;
      outline: 5px dashed #000;
    }
  }
  ```

- `orientation`：设备的方向，语法：`portrait`（肖像，就是竖屏），`landscape`（横屏），这参数名字有点意思的。

  ```css
  body {
    display: flex;
  }

  div {
    background: yellow;
  }

  @media (orientation: landscape) {
    body {
      flex-direction: row;
    }
  }

  @media (orientation: portrait) {
    body {
      flex-direction: column;
    }
  }
  ```

- `resolution`：屏幕的分辨率，`@media (resolution: 150dpi) `

- 还有很多，去 [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Media_Queries/Using_media_queries) 看吧

最常用的就是 `max-width` 和 `min-width` 或者 height 了，在这些可以有范围的属性前加上`min-`或者`max-`，可以限制范围

```css
@media (max-width: 12450px) {
  ...;
}
```

比如上面，在设备满足宽度在 12450px 之内的，这个媒介查询都是 true

如果是`min-width`，就是大于那么多 px 的设备。

**`max-width` -> 小于**

**`min-width` -> 大于**

### 逻辑操作

用`not`, `and`, `only`来组合查询

- `only`：对一个只有完全匹配才能生效的查询组合用 only 来修饰，可以防止旧的浏览器选择性的应用样式。When not using `only`, older browsers would interpret the query `screen and (max-width: 500px)` simply as `screen`, ignoring the remainder of the query
- `,`：有点像 `or` 的功能，每个查询可以用逗号分开，只要有一个成功了，整个就返回 true

看点例子：

```css
@media (min-width: 30em) and (orientation: landscape) {
  ...;
}
```
