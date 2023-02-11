# will-change 属性

> [张鑫旭文章](https://www.zhangxinxu.com/wordpress/2015/11/css3-will-change-improve-paint/)

## 有什么用

`will-change` 属性会告诉浏览器，该元素需要变化，需要启用 GPU 来帮忙计算变化后的图形，为的是减轻 CPU 的计算，让页面不卡顿

```css
/* 关键字值 */
will-change: auto;
will-change: scroll-position;
will-change: contents;
will-change: transform; /* <custom-ident>示例 */
will-change: opacity; /* <custom-ident>示例 */
will-change: left, top; /* 两个<animateable-feature>示例 */

/* 全局值 */
will-change: inherit;
will-change: initial;
will-change: unset;
```

> 以下摘录自文章

**auto**
就跟 `width:auto` 一样，实际上没什么卵用，昨天嘛，估计就是用来重置其他比较屌的值。

**scroll-position**
告诉浏览器，我要开始翻滚了。

**contents**
告诉浏览器，内容要动画或变化了。

**`<custom-ident>`**
顾名思意，[自定义的识别](https://developer.mozilla.org/en-US/docs/Web/CSS/custom-ident)。非规范称呼，应该是 MDN 自己的称呼，以后可能会明确写入规范。比方说`animation`的名称，计数器`counter-reset`, `counter-increment`定义的名称等等。

上面展示了 2 个例子，一个是`transform`一个是`opacity`，都是 CSS3 动画常用属性。如果给定的属性是缩写，则所有缩写相关属性变化都会触发。同时不能是以下这些关键字值：`unset`, `initial`, `inherit`, `will-change`, `auto`, `scroll-position`, 或 `contents`.

**`<animateable-feature>`**
可动画的一些特征值。比方说`left`, `top`, `margin`之类。移动端，非`transform`, `opacity`属性的动画性能都是低下的，所以都是建议避免使用`left`/`top`/`margin`之流进行唯一等。但是，如果你觉得自己是`margin`属性奶大的，非要使用之，试试加个`will-change:margin`说不定也会很流畅（移动端目前支持还不是很好）。

## 使用注意

遵循最小化影响原则，毕竟也是利用 GPU 资源（耗电）

仅需要动画变化的时候再挂在这个属性，及时 remove。
