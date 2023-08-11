# About Scroll

> scroll 相关的一些场景 tricks
>
> 但 scroll 行为和响应往往在不同浏览器上可能有些许不同，尤其是移动端场景

### scroll into view

> 某个元素滚动到出现，比较常见的需求

#### 原生 scrollIntoView

浏览器提供的 api：[scrollIntoView](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoView)

```javascript
const element = document.getElementById("box");

// 默认将元素滚动到可视区域 顶部对齐顶部
element.scrollIntoView();

// false 则底部对齐可视区域的底部
element.scrollIntoView(false);
// block 垂直方向的对齐 start/end/center/nearest
element.scrollIntoView({ block: "end" });
// behavior 决定了滚动是否有过度效果
// inline 水平方向的对齐 start/end/center/nearest
element.scrollIntoView({ behavior: "smooth", block: "end", inline: "nearest" });
```

#### 第三方库

github 搜的话还挺多的

[scroll-into-view-if-need](https://github.com/scroll-into-view/scroll-into-view-if-needed)

- 作为 [scrollIntoViewIfNeeded](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollIntoViewIfNeeded) 的 polyfill
- star 比较多

[scroll-into-view](https://github.com/KoryNunn/scroll-into-view)

- 这个库用的还比较多

### 判断滚动到底部

```typescript
const isScrollToBottom =
  window.scrollY + window.innerHeight >= document.body.scrollHeight;
```

### 判断是否滚动停止

浏览器也提供了 [scrollend](https://developer.mozilla.org/en-US/docs/Web/API/Element/scrollend_event) 事件：

- 在滚动停止并且用户完成手势之后会触发
- 兼容性：
  - 比较新，chrome 114，移动端 safari 还不支持

```typescript
/**
 * 检测滚动是否已经停止 目前 scrollEnd 事件还没法用 只能用 onscroll 延迟判断
 */
export function detectScrollFinished(
  element: HTMLElement | Window | Document | null,
  callback: () => void,
  timeout = 100
) {
  if (!element) {
    return () => {};
  }
  let timer: ReturnType<typeof setTimeout>;
  const handleScroll = () => {
    if (timer) {
      clearTimeout(timer);
    }
    timer = setTimeout(callback, timeout);
  };
  element.addEventListener("scroll", handleScroll);
  return () => {
    element.removeEventListener("scroll", handleScroll);
  };
}
```

### 滚动条

在 mac 上，滚动条可以设置为：

- 始终展示
- 滚动时展示
- 根据触摸展示

滚动条出现的时候，也会作为滚动元素的一部分渲染在页面上，有的时候就会压缩水平/垂直方向

#### [滚动条出现水平方向压缩](../../css/css_tricks/browser_scroll_bar.md)

#### 判断滚动条出现 & 获取滚动条宽度

参考：[stackoverflow](https://stackoverflow.com/questions/55008733/how-can-i-tell-if-the-mac-show-scroll-bars-setting-is-always-on) 提供的 [代码](http://jsfiddle.net/UU9kg/17/)

原理就是判断当前区域的 wrapper 是否比 inner 宽，提供了获取滚动条宽度的工具方法：

```javascript
/**
 * Gets the OS scollbar width in pixels.
 * @returns {number} The width as a number in pixels.
 */
utils.getScrollbarWidth = function () {
  const outer = document.createElement("div");
  outer.style.visibility = "hidden";
  outer.style.width = "100px";
  document.body.appendChild(outer);

  const widthNoScroll = outer.offsetWidth;
  outer.style.overflow = "scroll";

  const inner = document.createElement("div");
  inner.style.width = "100%";
  outer.appendChild(inner);

  const widthWithScroll = inner.offsetWidth;
  outer.parentNode.removeChild(outer);

  return widthNoScroll - widthWithScroll;
};
```
