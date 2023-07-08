# 点状背景

### introduce radial-gradient

在 vercel 的各个文档站（Nextra）看到的，用到了 css 的 background-image: [radial-gradient](https://developer.mozilla.org/en-US/docs/Web/CSS/gradient/radial-gradient) 属性，浏览器会根据参数在屏幕上生成一张散射图片（是一个特殊的 图片，所以不会和 `background-color` 一起作用）

语法：

```css
radial-gradient(circle at center, red 0, blue, green 100%)
```

A radial gradient is defined by a _center point_, an _ending shape_, and two or more _color-stop points_.

```css
<radial-gradient()> =
  radial-gradient( [ <ending-shape> || <size> ]? [ at <position> ]? , <color-stop-list> )
// 可以设置位置，形状，大小，渐变的阶段颜色
```

P.S. [MDN Using CSS gradients](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_images/Using_CSS_gradients) 里面有各种花里胡哨的渐变效果 demo

### Dotted background

主要的 css 代码如下，

```css
.dot-background {
  background: fixed 0 0 /20px 20px radial-gradient(#313131 2px, transparent 0), fixed
      10px 10px / 20px 20px radial-gradient(#ff5f00 2px, transparent 0);
}
```

拆解一下这里用的属性，回顾一下 [`background`](../background) 属性

- `fixed`：是 [background-attachment](https://developer.mozilla.org/en-US/docs/Web/CSS/background-attachment) 的属性，设置了背景图对应他的 viewport 是固定的（fixex）还是随着容器滚动（scroll）
  - 也就是在滚动的时候会不会随着容器一起
- `0 0`：这里是 position
- `/ 20px 20px` 是背景的大小
- 最后才是 iamge，用的 radial-gradient，设置了一个大小为 2px，默认球体，颜色 `#ff5f00`，第二阶段是 transparent 0%

这样第一个图层的点就画完了，没有设置 repeat。

第二层一样，有一个位置的偏移，这样使得两个图层的点交错，更加密集
