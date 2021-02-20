# SVG 怎么画

**Scalable Vector Graphics**

SVG 是使用 XML 来描述**二维**矢量图和绘图程序的**语言**。

> it's a text-based, open Web standard for describing images that can be rendered cleanly at any size and are designed specifically to work well with other web standards including [CSS](https://developer.mozilla.org/en-US/docs/CSS), [DOM](https://developer.mozilla.org/en-US/docs/DOM), [JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript), and [SMIL](https://developer.mozilla.org/en-US/docs/Web/SVG/SVG_animation_with_SMIL)（svg 动画）.
>
> SVG is, essentially, to graphics what [HTML](https://developer.mozilla.org/en-US/docs/Web/HTML) is to text.

SVG 之于图形，如 HTML 之于文本（超文本标记语言）（a W3C XML dialect to mark up graphics）

SVG 图像和行为都定义在 XML 的文件中，所以他们可以被搜索、索引、脚本化和压缩，以及在任意的编辑器里编辑都可。

1999 年起由 W3C 组织开发。

### 如何学习？

先看了 MDN 上的介绍和 [tutorial](https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial)

MDN 推荐了 [inkscape](https://inkscape.org/about/) 学习教程，一个免费的 svg 编辑器

### MDN 教程摘要

#### 简介

各大浏览器对 svg 的支持都很好，缺点在于加载 svg 会比较慢

HTML 不仅可以定义 headers, paragraphs, tables 等，定义 svg 只需要一个 `<svg>` 作为根标签以及一些内部的一些基础图形即可

另外有 `<g>` 标签作为 group 基础图形的作用

对 XML 要有一定了解

- XML is case-sensitive (unlike HTML)
- 属性的值必须用引号包住，即使是数字

#### getting start

```xml
<svg version="1.1"
     baseProfile="full"
     width="300" height="200"
     xmlns="http://www.w3.org/2000/svg">

  <rect width="100%" height="100%" fill="red" />

  <circle cx="150" cy="100" r="80" fill="green" />

  <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>

</svg>
```

<svg version="1.1"
     baseProfile="full"
     width="300" height="200"
     xmlns="http://www.w3.org/2000/svg">
<rect width="100%" height="100%" fill="red" />
<circle cx="150" cy="100" r="80" fill="green" />
<text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>
</svg>

TODO：https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Getting_Started

https://www.jianshu.com/p/132b58273e27

### viewbox

https://www.jianshu.com/p/4422c05ff0f2

stroke-dasharray：https://www.cnblogs.com/daisygogogo/p/11044353.html

viewBox 指定了四个值：min-x，min-y，width，height，注意坐标轴原点在左下角，标准的直角坐标系
