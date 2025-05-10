### 写在前面

html、CSS 组成了页面的布局和样式，给我的感觉就是他们的技术呈现和实现真的是有很浓厚的排版大师的味道，比如说常见的 margin 塌陷、伪元素 `::first-letter` ...，这些小特性直觉上给人一种看报纸、杂志的感觉，不禁让我想到一开始的设计者是不是就想让我们在浏览器上也能得到阅读报纸、杂志的体验呢？但反观当今人们的视觉体验，更多是倾向更现代交互的风格（至少不会那么复古吧），所以年代赋予的设计思路而且 CSS 是一种

### 【DOM】setProperty

[MDN](https://developer.mozilla.org/en-US/docs/Web/API/CSSStyleDeclaration/setProperty)

通过 DOM 对象来优雅的修改样式

```js
dom.style.setProperty("height", "10px", "important");
```

### 反人类

#### margin/padding 的值如果是百分比，是相对于父元素的宽度来的

相对于父元素的**宽度**来的

相对于父元素的**宽度**来的

相对于父元素的**宽度**来的

看[这篇](https://segmentfault.com/a/1190000004231995)，[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/percentage) 也讲了

#### 子元素的 margin-top 会影响父元素（外边距塌陷）

父子元素的 margin-top 属性，会共用值最大的那个。所以父元素公用了子元素的 margin-top 值，自然也就跟着移动了。

用 BFC 解决

#### translate 的值为百分比，是本身的宽度和高度（X，Y）

### CSS 文档流

布局(reflow)过程中，元素会自动从左到右，从上到下的流式排列

#### 看看如何展示元素的属性：display

行内元素`display:inline` 比如 a, b, span, img, input...不会自动换行，屏幕一行放不下就会自动换行

块级元素`display:block` 比如 div, ol, li, dl, dt, h1-h6 p...元素会占一行，当然也可以设置 display 成为行内元素。

`display:inline-block`还有`display:none`不展示，不出现在 render tree 中

#### 脱离文档流

浮动和定位

- `float: left`: 浮动的元素脱离了文档流，但是，文档流中其他元素的**文字**还是会注意到这个浮动元素的位置大小，会围绕这个元素布局。
  - 清楚浮动`clear: both/right/left`: 清楚两侧元素的浮动效果
  - 或者父元素`overflow: hidden`: 让父元素紧贴子元素
- `position: absolute`: 相对于父元素是绝对位置的，也是脱离了文档流，如果多个元素都是绝对定位，那么就会重叠，标签越在下方，重叠越前
- `position: fixed`: 对于窗口固定该元素的位置，也就是一开始他本该出现在文档流的位置，**但是脱离了文档流**！

#### 文档流的定位

**常规流(Normal flow)**

- 见文档流

**浮动(float)**

- 脱离常规流
- 左浮动靠左、靠上。右浮动同理
- 浮动不影响块级元素布局
- 但是影响行内元素布局，会让其**围绕在浮动元素周围**，撑大行内元素的父元素，从而间接影响了块级元素
- 行内元素出现在左浮动的右边，右浮动的左边
- 不会超过当前行的最高点，以及他之前浮动元素的最高点
- 不超过其父块级元素，除非元素已经比父块更宽了

**绝对定位(Absolute positioning)(absolute fixed)**

- 脱离常规流布局
- 见 position！

### viewport 在移动端存在的问题

> [100 vh 的高度并不好](http://caibaojian.com/avoid-100vh-on-mobile-web.html)

100 vh 在移动端的浏览器中的体验可能会有点不好，因为浏览器有些时候会自动隐藏顶部的地址栏，用 JS 去设置高度为 innerHeight 会更好，这个是浏览器窗口内部的可见高度。

#### vh/lvh/svh/dvh

移动端的浏览器界面可能会出现顶部/底部的地址栏，同时他们可能有时出现/收起

所以退出了新规范的三个单位：

1. The large viewport units（大视口单位）：`lvw`,`lvh`, `lvi`, `lvb`, `lvmin`, and `lvmax`
2. The small viewport units（小视口单位）：`svw`, `svh`, `svi`, `svb`, `svmin`, and `svmax`
3. The dynamic viewport units（动态视口单位）：`dvw`, `dvh`, `dvi`, `dvb`, `dvmin`, and `dvmax`

所谓的 Large：容器 UA 界面能够收起/展开的部分，是收起的；Small 则就是都展开了，压缩了 viewport 后的长度

所谓的 D：动态视窗

1. 动态工具栏展开时，动态视口等于小视口的大小
2. 当动态工具栏被缩回时，动态视口等于大视口的大小
3. 兼容性问题：https://caniuse.com/?search=dvh，基本新版本都支持了，后面将成为主流替代 vh

### 盒子模型

盒子通常由：content，margin，padding，border 组成

第一个 content 是 html 中元素的内容，其余都是 CSS 属性

#### 盒子大小如何决定

根据`box-sizing:content-box | border-box | inherit`来决定

默认值是`content-box`就是**W3C 标准盒子模型**，`border-box`就是**IE 盒子模型**

**在 html 开头的`!DOCTYPE html`（h5）所有浏览器会解释成 W3C 盒模型**

#### W3C 盒子

width 和 height 属性应用到元素的 content，再此之外绘制元素的 padding，margin，border

盒子真实的宽高是**content+padding+border**

#### IE 盒子

width 和 height 属性应用到元素的盒子本身，padding 和 border 都是在盒子内部画的

下面这个例子，如果是 IE 盒子(border-box)，实际的 content 高宽是 height - 2 _ 10px - 2 _ 10px = 160px，width 为 60px。

```html
<style>
  .box {
    height: 200px;
    width: 100px;
    box-sizing: content-box;
    /* box-sizing: border-box; */
    padding: 10px;
    margin: 10px;
    border: 10px;
    background-color: red;
  }
</style>

<div class="box"></div>
```

#### 看看 border 属性

- 上下左右可以分别设置各个属性`border-top/...:`

- `border:1px solid`颜色属性不指明的时候和字体的`color`相同
- `border`=`border-width + border-style + border-color`
  - style: none, hidden, dotted, dashed, solid, double, groove, ...
- `border-radius`: 边界半径，圆角（可以出现不同的形状 hh）
  - 一个值: 四个角半径一样
  - 二个值: 左上右下，右上左下
  - 三个值: 左上角，右上左下，右下角
  - 四个值: 左上，右上，右下，左下
  - 相当于是垂直方向逆时针转 45 度的变量
- 图形边界...还有很多内容

#### 伪元素::before 和伪类:after 区别

单冒号（:）用于**CSS3 伪类**，可以看成是元素的某种状态

双冒号（::）用于**CSS3 伪元素**，可以作为是在 CSS 中写 DOM 元素（伪元素由双冒号和伪元素名称组成）

双冒号是在当前规范中引入的，用于区分伪类和伪元素。不过浏览器需要同时支持旧的已经存在的伪元素写法，比如`:first-line`、`:first-letter`、`:before`、`:after`等，**而新的在 CSS3 中引入的伪元素则不允许再支持旧的单冒号的写法**。

想让插入的内容出现在其它内容前，使用`::before`，否者，使用`::after`；

在代码顺序上，`::after`生成的内容也比`::before`生成的内容靠后。

如果按堆栈视角，`::after`生成的内容会在`::before`生成的内容之上

**伪类一般匹配的是元素的一些特殊状态，如 hover、link 等，而伪元素一般匹配的特殊的位置，比如 after、before 等。**

css 引入伪类和伪元素概念是为了格式化文档树以外的信息。也就是说，**伪类和伪元素是用来修饰不在文档树中的部分**，比如，一句
话中的第一个字母，或者是列表中的第一个元素。

##### 伪类

**伪类用于当已有的元素处于某个状态时，为其添加对应的样式，这个状态是根据用户行为而动态变化的。比如说，当用户悬停在指定的元素时，我们可以通过:hover 来描述这个元素的状态。**

##### 伪元素

**伪元素用于创建一些不在文档树中的元素，并为其添加样式。它们允许我们为元素的某些部分设置样式。比如说，我们可以通过::before 来在一个元素前增加一些文本，并为这些文本添加样式。虽然用户可以看到这些文本，但是这些文本实际上不在文档树中。**

有时你会发现伪元素使用了两个冒号（::）而不是一个冒号（:）。这是 CSS3 的一部分，并尝试区分伪类和伪元素。大多数浏览器都支持这两个值。按照规则应该使用（::）而不是（:），从而区分伪类和伪元素。但是，由于在旧版本的 W3C 规范并未对此进行特别区分，因此目前绝大多数的浏览器都支持使用这两种方式表示伪元素。

#### 伪元素怎么用

`::before`和`::after` 一定要有 content，不然就无效，可以设置对应的样式

```css
.boxx + p::before {
  content: "5555555";
  color: brown;
}
.boxx + p::after {
  content: "666";
  font-size: large;
  color: rgb(16, 119, 150);
}
```

`::selection`可以改变选中后的文字样式，通常可以个性化文字颜色、背景颜色

```css
::selection {
  background-color: #fff;
}
p::selection {
  color: #fff;
}
```

**[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/Pseudo-elements)查看所有的伪元素！**

`::first-line`、`::first-letter`等等好多有意思的 trick 都可以用到伪元素

### 可继承的 CSS 属性

字体:

- font
- font-family, font-weight, font-size, font-stretch, font-size-adjust

文本

- text-indent, text-align, text-shadow, text-transform
- line-height, word-spacing, letter-spacing,
- direction, color

表格布局属性

- caption-sideborder-collapseempty-cells

列表属性

- list-style-type, list-style-image, list-style-position, list-style

光标(cursor)

可见性(visibility)

还有一些不常用的；speak，page，设置嵌套引用的引号类型 quotes 等属性

**注意：当一个属性不是继承属性时，可以使用 inherit 关键字指定一个属性应从父元素继承它的值，inherit 关键字用于显式地指定继承性，可用于任何继承性/非继承性属性。**

### 关于 a 标签的伪类 LVHA 顺序 的解释

首先什么是 LVHA 伪类

L: link 普通的、未被访问的链接

V: visited 连接被访问过的

H: hover 悬停

A: active 激活

- 当鼠标滑过 a 链接时，满足:link 和:hover 两种状态，要改变 a 标签的颜色，就必须将:hover 伪类在:link 伪类后面声明；
- 当鼠标点击激活 a 链接时，同时满足:link、:hover、:active 三种状态，要显示 a 标签激活时的样式（:active），必须将:active 声明放到:link 和:hover 之后。因此得出 LVHA 这个顺序。

当链接访问过时，情况基本同上，只不过需要将:link 换成:visited。

这个顺序能不能变？可以，但也只有:link 和:visited 可以交换位置，因为一个链接要么访问过要么没访问过，不可能同时满足，也就不存在覆盖的问题。

总结来说，（个人观点）触发伪类的时候渲染层会重绘 a 标签的样式（根据伪类），覆盖原来的样式，所以覆盖顺序不能错。

### 居中 div！！

记得要**子绝父相**: 子元素`position:absolute`父元素`position:relative`

#### 水平居中

**方法 1 有宽度的 div+margin 自适应**

- 容器元素宽度设定
- 当前元素`margin: 0 auto`左右自适应

**方法 2 绝对定位和 margin-left:-(width/2)实现水平居中**

- 子绝父相！
- `left: 50%` `margin-left: -(width / 2)`
- 首先让元素的起点到父元素容器的一半位置，然后将左边的 margin 缩短自身 width 的一半，居中

**方法 3 flex 布局**

- 容器`display:flex` `justify-content:center` `align-items/content:center`
- 可以水平垂直都居中

#### 垂直居中

方法 1 **子绝父相**之后 top + margin-top

- `top:50%` `margin-top:-(height/2)`
- 原理和水平的方法 2 一样

**方法 2 flex 布局**

#### 垂直水平居中

**translate 方法(CSS3)**

- 子绝父相
- `left: 50%` `top: 50%`移动原点到中心
- `transform: translate(-50%, -50%)`不清楚宽高的时候用 translate 位移，原理差不多

**子绝父相+四个位置偏移为 0+margin 自适应**

```css
#d6 {
  background-color: #39303f;
  position: absolute;
  left: 0;
  top: 0;
  bottom: 0;
  right: 0;
  margin: auto;
}
```

总结一下就这么几个方法吧

1. 设置宽度或者高度后让 margin 自适应一个方向
2. 绝对定位，脱离文档流，四个方向 0 偏移，margin 自适应 auto
3. 绝对定位，原点利用 top 和 left50%定位到中心，利用 margin 的负值居中；或者用 translate(-50%, -50%)
4. flex 布局

**对于宽高不确定的元素，后两种方法比较合适**

### position 属性

absolute

- 绝对定位，相对于**第一个定位非 static 的父元素**
- 可以利用 top，bottom，left，right，z-index 来偏移

fixed(老 IE 不支持)

- 对于**浏览器窗口（viewport）**定位

relative

- 相对**正常位置**定位
- 可以利用 top，bottom，left，right，z-index 来偏移
- _如果父元素有 margin 或者 padding，偏移起始位置不会收到 padding 的影响，而是从`{padding-left: 0, padding-right: 0}`开始计算_

static 默认，无定位，正常的流中（忽略 top，bottom，left，right，z-index）

inherit 从父元素继承

### CSS3 新特性

- 新增各种 CSS 选择器 （:not(.input)：所有 class 不是“input”的节点）
- 圆角 （border-radius:8px）
- 多列布局 （multi-columnlayout）
- 阴影和反射 （Shadow/Reflect）
- 文字特效 （text-shadow）
- 文字渲染 （Text-decoration）
- 线性渐变 （gradient）
- 旋转 （transform）
- 缩放，定位，倾斜，动画，多背景。例如：`transform: | scale(0.85,0.90) | translate(0px,-30px) | skew(-9deg,0deg) | Animation:`

### CSS 画三角形的原理

很简单的方法，只用 border，盒子的宽和高都是 0

此时想象一下边框是什么样的，当内容无限接近于 0，边框就在四个方向平均分割了这个盒子

![四等分](https://img-blog.csdn.net/20160928120730295)

此时只要保留需要的一个三角形就行了，让其余的边框消失（颜色 transparent)

```css
.trang {
  width: 0;
  height: 0;
  border-width: 20px 10px;
  border-style: solid;
  border-color: transparent transparent red transparent;
}
```

### BFC(块级格式化上下文)

Block Formatting Context 什么上下文，浏览器渲染的上下文，通俗点说就是一块渲染的区域，块级格式化上下文就是一种浏览器如何渲染盒子（块级元素）以及与其周围元素的互相影响的方式。。

BFC 规定了一个块级元素的内部布局方式，并且这个块级元素与外部隔绝

如何触发这样的渲染方式(BFC)呢

- 根元素 html 标签
- 浮动元素(float 不是 none)
- 绝对定位的(position 是 absolute or fixed)
- display 值为 `inline-block`、`table-cell`、`table-caption`、`table`、`inline-table`、`flex`、`inline-flex`、`grid`、`inline-grid`
  - 行内块级元素(display: inline-block)
  - 表格单元格
  - overflow 不为 visible 的
  - flex 布局
  - grid 布局
  - ...

其实很难懂，但是只要知道 BFC 只是一种在以上情况会触发的一种渲染方法就行。

他的作用就是在页面上新建一个隔离的独立容器，容器内部的子元素不收到外部元素的影响。

#### 详细规则

浏览器对 BFC 区域的约束规则：

1. 生成 BFC 元素的子元素会一个接一个的放置。
2. 垂直方向上他们的起点是一个包含块的顶部，两个相邻子元素之间的垂直距离取决于元素的 margin 特性。**在 BFC 中相邻的块级元素的[外边距会折叠(Mastering margin collapsing)](https://developer.mozilla.org/zh-CN/docs/Web/CSS/CSS_Box_Model/Mastering_margin_collapsing)。**
3. 生成 BFC 元素的子元素中，每一个子元素左外边距与容器的左边界相接触（对于从右到左的格式化，右外边距接触右边界），即使浮动元素也是如此（尽管子元素的内容区域会由于浮动而压缩），除非这个子元素也创建了一个新的 BFC（如它自身也是一个浮动元素）。

规则解读：

1. 内部的 Box 会在垂直方向上一个接一个的放置
2. 内部的 Box 垂直方向上的距离由 margin 决定。（完整的说法是：属于同一个 BFC 的两个相邻 Box 的 margin 会发生折叠，不同 BFC 不会发生折叠。）
3. 每个元素的左外边距与包含块的左边界相接触（从左向右），即使浮动元素也是如此。（这说明 BFC 中子元素不会超出他的包含块，而 position 为 absolute 的元素可以超出他的包含块边界）
4. BFC 的区域不会与 float 的元素区域重叠
5. 计算 BFC 的高度时，浮动子元素也参与计算

#### BFC 能解决什么问题

避免边距坍塌

- 两个连续的 div 的 margin 会重叠，原因是 body 本身是一个 BFC，重叠部分的边距是两 margin 的较大

- 让 div 触发 BFC 即可

  ```html
  <style>
    div {
      height: 100px;
      width: 100px;
    }
    #dd {
      background-color: red;
      margin-bottom: 100px;
    }
    #ddd {
      background-color: blue;
      margin-top: 50px;
    }
  </style>
  <div id="dd"></div>
  <div id="ddd"></div>
  ```

  解决方法，在 div 外套一个 div，让其 BFC(一种方案吧)

  ```html
  <div id="dd"></div>
  <div style="overflow: hidden;height: auto;">
    <div id="ddd"></div>
  </div>
  ```

自适应两栏布局

- 让在文档流中，在浮动元素底下的元素成为 BFC 即可

清除浮动(不推荐用 BFC)

- 父元素无 height 或者 auto 的时候，子元素 float 会导致父元素的高度塌陷，因为子浮动元素脱离了文档流
- 让父元素成为 BFC，加`overflow: hidden`

清除浮动除了 BFC 之外还有在父元素加入伪元素（推荐做法）

- 在父元素加入`::after`，伪元素本身是 inline 的，让其成为`display: block`，同时`clear:both`

`clear：both`：本质就是闭合浮动， 就是让父盒子闭合出口和入口，不让子盒子出来

#### 总结

BFC 就是绘制的一块隔离的容器，脱离文档流的元素不会影响 BFC，浮动会让 BFC 变窄，不与浮动重叠。

BFC 内部有浮动的时候，BFC 为了隔离自己，会将内部的浮动算在自己的高度。

margin 也算在 BFC 自己的高宽，所以可以避免边距塌陷。

### FFC(Flex Formatting Context)

居然还有 FFC，一个关于边距塌陷的[问题](https://stackoverflow.com/questions/43882869/margin-collapsing-in-flexbox)

**FFC 中不会出现 margin collapsing**

### 关于动画、过渡效果

#### transition

用于进入某一状态之间发生的过渡

举个例子，如果是`:hover`状态被触发了，这部分的 css 有 transition，那么就会过渡。如果是正常状态的 css 中有 transition，那么每次切换回到正常状态都会触发，并且离开该状态的时候也会触发

### z-index

控制元素叠放的顺序

数值越大的，在前面，相当于是一个从屏幕指向用户的 z 轴

**一定要是 absolute 定位的元素才可以**，脱离文档流了，比如 float

在 iOS 上 `z-index`失效，用 `transform: translateZ(1000px);`，safari 和 IE 分别加前缀 `-webkit-` 和 `-ms-`

### outline

设置元素周围的轮廓

```css
p {
  outline: #00ff00 dotted thick;
}
```

outline 也是多个属性的集合写法（short handed）

- outline-color: 颜色
- outline-style: none, dotted, dashed, solid, double 以及一些 3D 轮廓效果等等
- outline-width: thin, medium, thick 或者指定数值 px
- inherit: 继承父元素

### line-height

设置一个 box 内的文字行高`line-height: normal | <number> | <length> | <percentage>`

- `normal`
- 数字（无单位）：用这个数值乘上元素的 font-size 得到行高，通常这样用最好，不会引起重叠
- 长度：e.g. `1.2em`，万一比字号还小了，就会重叠行
- 百分数：和数字的一样，但是他是和相乘 by the element's computed font size（？）

### at-rule

@规则，是 CSS 的声名 来告诉（指示） CSS 如何行动的（MDN 硬翻）

用`@`符号开头，后面跟一个 identifier，以`;`或者`{}`结尾

多种 identifier 看一下吧

#### [`@charset`](https://developer.mozilla.org/en-US/docs/Web/CSS/@charset)

指定样式表的字符编码。

只能放在第一句，多个声明只有第一个会被应用，不能用在 html 的行内`style`属性和`<style>`标签，因为字符编码直接和 html 相关了，所以只能放在`css`文件中。

```css
@charset "utf-8";
```

#### `@import`

倒入其他样式表

##### 语法

```css
@import url;
@import url list-of-media-queries;
@import url supports(supports-query);
@import url supports(supports-query) list-of-media-queries;
```

- url：相对或者绝对路径的字符串，或者`url("xxx/xxx")`
- list-of-media-queries：逗号分开的媒介查询语句，如果满足条件，就会导入这个样式表
- supports-query：`@supports`语句或者是一句定义（`color: red`）

##### 例子

```css
@import url("fineprint.css") print;
@import url("bluish.css") speech;
@import "common.css" screen;
@import url("landscape.css") screen and (orientation: landscape);
```

##### 兼容性

都可

#### `@supports`

一个嵌套的 rule，查询浏览器是否支持某个 CSS 特性（feature query）

```css
@supports (display: grid) {
  div {
    display: grid;
  }
}
/* 支持逻辑操作 and or not*/
@supports not (display: grid) {
  div {
    float: right;
  }
}
@supports (display: table-cell) and (display: list-item) and (display: run-in) {
}
```

详见：[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@supports)

兼容性：IE 没有

#### `@media`

就是媒介查询了，嵌套的规则（满足条件后可以在里面写 CSS 规则）

不多介绍，看另一篇专讲媒介查询的。这里就看例子吧

```css
/* At the top level of your code */
@media screen and (min-width: 900px) {
  article {
    padding: 1rem 3rem;
  }
}

/* Nested within another conditional at-rule */
@supports (display: flex) {
  @media screen and (min-width: 900px) {
    article {
      display: flex;
    }
  }
}
```

Media Queries Level 4 可以写这样的范围语法了

```css
@media (height > 600px) {
  body {
    line-height: 1.4;
  }
}

@media (400px <= width <= 700px) {
  body {
    line-height: 1.4;
  }
}
```

#### `@font-face`

描述一个自定义字体！能够在文档中使用。挺重要的

```css
@font-face {
  font-family: "Open Sans";
  src: url("/fonts/OpenSans-Regular-webfont.woff2") format("woff2"), url("/fonts/OpenSans-Regular-webfont.woff")
      format("woff");
}
```

##### 属性

**`src`**

```css
/* <url> values */
src: url(https://somewebsite.com/path/to/font.woff); /* Absolute URL */
src: url(path/to/font.woff); /* Relative URL */
src: url(path/to/font.woff) format("woff"); /* Explicit format 可选 声明字体文件的格式 */
src: url("path/to/font.woff"); /* Quoted URL */
src: url(path/to/svgfont.svg#example); /* Fragment identifying font */

/* <font-face-name> values */
src: local(font); /* Unquoted name */
src: local(some font); /* Name containing space */
src: local("font"); /* Quoted name */

/* Multiple items */
src: local(font), url(path/to/font.svg) format("svg"), url(path/to/font.woff)
    format("woff"), url(path/to/font.otf) format("opentype");
```

`local()`：声明一个本地安装的字体

The available types are: `"woff"`, `"woff2"`, `"truetype"`, `"opentype"`, `"embedded-opentype"`, and `"svg"`.

其他属性和 CSS 字体相关的就不展开了，可以在声明字体的时候直接指定它的`font`样式，详见：[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@font-face)

#### `@keyframes`

实现动画的。控制动画序列，在动画的中间位置（关键帧）指定样式，比`transition`有更丰富的细节控制。

理解起来不难，直接看例子吧：

```css
@keyframes slidein {
  /* from := 0% */
  from {
    transform: translateX(0%);
  }
  /* to := 100% */
  to {
    transform: translateX(100%);
  }
}
```

上面定义了一个 slidein 的关键帧序列，元素从左到右的一个长度为元素宽度的位移

也可以用百分比表示动画进行的进度

```css
@keyframes identifier {
  0% {
    top: 0;
    left: 0;
  }
  30% {
    top: 50px;
  }
  68%,
  72% {
    left: 50px;
  }
  100% {
    top: 100px;
    left: 100%;
  }
}
```

重复的关键帧会统一作用，下面在 50% 的时候是`top: 10px; left: 20px;`

```css
@keyframes identifier {
  0% {
    top: 0;
  }
  50% {
    top: 30px;
    left: 20px;
  }
  50% {
    top: 10px;
  }
  100% {
    top: 0;
  }
}
```

`!important`修饰的帧会被忽略。。

### cursor

修改鼠标指针的样式，内置样式详见：[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/cursor)

主要看一下自定义的时候怎么用

#### 语法

```css
/* Keyword value */
cursor: pointer;
cursor: auto;

/* URL, with a keyword fallback */
cursor: url(hand.cur), pointer;

/* URL and 图片起始的坐标, with a keyword fallback */
cursor: url(cursor1.png) 4 12, auto;
cursor: url(cursor2.png) 2 2, pointer;

/* Global values */
cursor: inherit;
cursor: initial;
cursor: unset;
```

多个鼠标样式用`,`隔开，浏览器依次渲染（如果第一个图片加载失败的话就向后 fallback）

关于坐标：表示指针中心所在的位置，默认是图片的`top-left`，可以自定义偏移量

### clip-path

_clip 属性已经被 deprecated 了。。_

[这个属性](https://developer.mozilla.org/en-US/docs/Web/CSS/clip-path)可以定义一个元素可见的区域，仅作用于 position 是绝对的元素（`absolute`或`fixed`）

#### 语法

```css
/* Keyword values */
clip-path: none;

/* <clip-source> values */
clip-path: url(resources.svg#c1);

/* <geometry-box> values */
clip-path: margin-box;
clip-path: border-box;
clip-path: padding-box;
clip-path: content-box;
clip-path: fill-box;
clip-path: stroke-box;
clip-path: view-box;

/* <basic-shape> values */
clip-path: inset(100px 50px);
clip-path: circle(50px at 0 100px);
clip-path: polygon(50% 0%, 100% 50%, 50% 100%, 0% 50%);
clip-path: path(
  "M0.5,1 C0.5,1,0,0.7,0,0.3 A0.25,0.25,1,1,1,0.5,0.3 A0.25,0.25,1,1,1,1,0.3 C1,0.7,0.5,1,0.5,1 Z"
);

/* Box and shape values combined */
clip-path: padding-box circle(50px at 0 100px);

/* Global values */
clip-path: inherit;
clip-path: initial;
clip-path: unset;
```

一些[基础图形](https://developer.mozilla.org/en-US/docs/Web/CSS/basic-shape)具体的用法还是到时候看一下 MDN 吧，不是很难。

### object-fit

[这个属性](https://developer.mozilla.org/en-US/docs/Web/CSS/object-fit)适用于可*替换元素（replaced element）*比如 `<img>` `<video>`，让替换的元素处于合适的位置展示

`contain`：

ensures that the entire image is always visible, and so the opposite of `cover`

`cover`：

用最小的边比例去 fit div

`fill`：

re-adjust the image to fill the space. This causes the image to be squished and blurry, as it re-adjusts pixels.

_有点像 background ?_

_IE 不支持_

同样还有 [object-position](https://developer.mozilla.org/en-US/docs/Web/CSS/object-position) 配合使用，决定了 replaced element 的位置

### aspect-ratio

之前用 padding-top/bottom 百分比来 hack 一个 div 的 ratio 可以不用啦

**Using padding-top**

```css
.container {
  width: 100%;
  padding-top: 56.25%;
}
```

**Using aspect-ratio**

```css
.container {
  width: 100%;
  aspect-ratio: 16 / 9;
}
```

#### 适用场景

**consistency in a grid**

在 grid 布局中连续的 UI，设置所有的 img 一样的宽高比

**preventing layout shift**

让图片为加载的时候，img 元素就能撑开高度，等待替换

**设置 width 和 height 属性**

如果提前知道图片的大小，同样能达到 aspect-ratio 的效果！

### backdrop-filter

[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/backdrop-filter)

```css
backdrop-filter: blur(10px);
```

这个 CSS 属性能够在元素后面增加图形特效，比如 blur 或者 color shifting，因为是在元素的后方，所以需要元素的背景**至少是部分透明的**

#### 效果

语法

```css
/* Keyword value */
backdrop-filter: none;

/* URL to SVG filter */
backdrop-filter: url(commonfilters.svg#filter);

/* <filter-function> values */
backdrop-filter: blur(2px);
backdrop-filter: brightness(60%);
backdrop-filter: contrast(40%);
backdrop-filter: drop-shadow(4px 4px 10px blue);
backdrop-filter: grayscale(30%);
backdrop-filter: hue-rotate(120deg);
backdrop-filter: invert(70%);
backdrop-filter: opacity(20%);
backdrop-filter: sepia(90%);
backdrop-filter: saturate(80%);

/* Multiple filters */
backdrop-filter: url(filters.svg#filter) blur(4px) saturate(150%);

/* Global values */
backdrop-filter: inherit;
backdrop-filter: initial;
backdrop-filter: revert;
backdrop-filter: revert-layer;
backdrop-filter: unset;
```

常用的感觉就是 blur 制作毛玻璃效果了

#### 兼容性

https://caniuse.com/?search=backdrop-filter _global 达到 94.12%_
