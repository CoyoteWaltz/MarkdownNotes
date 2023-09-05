# 移动端的坑们

## 阻止页面滑动

主要场景是在 IOS safari 浏览器，input 聚焦的时候，会顶起页面，并且会让长度溢出 viewport 的 div 变得可滚动，不符合预期

需要禁止滚动

```typescript
// 阻止默认的滚动行为
function preventDefaultScroll(event: Event) {
  event.preventDefault();
}

// 禁止页面滑动 for 移动端
function disableTouchScroll() {
  document.addEventListener("touchmove", preventDefaultScroll, {
    passive: false,
  });
}

// 允许页面滑动
function enableTouchScroll() {
  document.removeEventListener("touchmove", preventDefaultScroll);
}

// 禁止滚动
export function disableScroll() {
  // 获取当前滚动位置
  const scrollTop =
    window.pageYOffset ||
    document.documentElement.scrollTop ||
    document.body.scrollTop;
  const scrollLeft =
    window.pageXOffset ||
    document.documentElement.scrollLeft ||
    document.body.scrollLeft;

  const stopScroll = () => {
    window.scrollTo(scrollLeft, scrollTop);
  };
  // 保持滚动位置不变，并禁用滚动条
  window.addEventListener("scroll", stopScroll);
  disableTouchScroll();
  return () => {
    // 允许滚动
    window.removeEventListener("scroll", stopScroll);
    enableTouchScroll();
  };
}
```

## IOS 禁止 webview 的 bounce

JS 解决方案：可以尝试引入这个 js lib：https://github.com/lazd/iNoBounce

其他场景：

```css
html {
  overscroll-behavior: none;
  -webkit-overflow-scrolling: touch;
}
```

or 有些容器直接在 html 上 `overflow: hidden`

or 调用 JSB 让客户端控制

## IOS webview text underline 没有颜色

```css
text-decoration: underline solid 1px #000;
```

居然在 ios 上不展示了。。于是感觉是因为 [color](https://developer.mozilla.org/en-US/docs/Web/CSS/text-decoration-color) 的兼容性不好

所以去掉 color，简单写，就有了

```css
text-decoration: underline;
```

## IOS 手机容器滚动条滑动不顺畅

```css
overflow: auto;
-webkit-overflow-scrolling: touch;
```

## 移动端吸底输入栏方案

背景概述：在移动端的交互需要在键盘打开的时候，输入栏吸附在键盘的上方，很多编辑场景会用到（编辑器、评论输入）

这里仅做原理梳理，没有实际代码

**安卓的表现和原理：**

1. 安卓软键盘弹起时页面直接压缩，内部是情况滚动
2. **一定会触发 resize 事件**
3. 当输入框不在可视范围，会触发滚动，触发 scroll 事件
   1. 若页面本身可滚动，则使用页面滚动，键盘收起后不复原
   2. 否则整个页面上推，键盘收起后复原
4. 键盘弹起后 fixed 布局不丢失，fixed 布局内的输入框不会触发滚动

**iOS 的表现和原理：**

未做任何处理时的表现：

1. 页面上推不返回
2. iOS 8+的设备，键盘是半透明的，会直接盖在页面上
3. **不会触发 window resize**
4. 键盘弹起时，所有 fixed 布局失效，变为 absolute，滚动时随 html 滚动
   1. 因此即使是 fixed 布局，如果吸底的话，键盘弹起一定造成页面上移。
5. 当 input 在页面下半屏（可能被键盘遮挡）时，会自动触发滚动，将输入滚动到可视范围
   1. 若当前页面已有滚动，则收起键盘后滚动位置不会还原
   2. 若当前页面无滚动，则页面会还原

IOS 13 推出 [Visual_Viewport_API](https://developer.mozilla.org/en-US/docs/Web/API/Visual_Viewport_API)，在键盘出现后会触发这个事件 visualViewport

主要思路就是检查是否有 viewportChange（可以是 resize、visualViewport，innerHeight...，端上通信），在 Webview 上就可以得知有键盘弹出，控制对应输入栏所需固定的位置（高度）即可
