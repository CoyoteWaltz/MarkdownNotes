# Flex 布局

可以让元素有弹性的布局

### flex 盒模型

`display:flex`之后，这个元素就成为了弹性容器

- **主轴和交叉轴**，垂直关系，主轴方向可以改变的
- 轴的**起点和终点**，元素对齐靠这个
- flex 容器中的所有子元素称为“弹性元素”，**永远沿着主轴方向排列**
- 弹性元素也可以是`display:flex`的弹性容器
- 注意，设为 Flex 布局以后，子元素的`float`、`clear`和`vertical-align`属性将失效。

### 主轴

flex 布局是**一维布局**模型，一次只能处理一个维度

也就是说，**flex 布局大部分的属性都是作用于主轴的，在交叉轴上很多时候只能被动地变化**。

#### 主轴的方向

在弹性容器上`flex-direction: row/column/row-reverse/column-reverse`，默认是 row，也就是 x 轴方向，**交叉轴的方向始终 90 度**

- column: 主轴 y 轴，交叉轴 x 轴
- row-reverse: x 轴负方向是主轴
- column-reverse: y 轴负方向是主轴

从[这篇博客](https://www.cnblogs.com/qcloud1001/p/9848619.html)拿几张图来说明 reverse 的情况

![row-reverse](https://ask.qcloudimg.com/http-save/1006489/4p83wn4fgq.gif)

![column-reverse](https://ask.qcloudimg.com/http-save/1006489/5u3vo6jku5.gif)

#### 主轴排列的处理

弹性元素在主轴排不下啦！

可以设置`flex-wrap: nowrap/wrap/wrap-reverse`来设置包裹的方式

- nowrap: 默认，如果会溢出，那么所有的弹性元素都会弹性伸缩
- wrap: 折叠了，另起一行，折叠后的行间距离如何调整呢？交叉轴上多行对齐
- wrap-reserve: 折叠换行后，再整个在交叉轴方向 reverse 一下

#### 复合属性

`flex-flow`定义了 flex 布局的工作流？

是`flex-direction`和`flex-wrap`的简写，默认为`row nowrap`

### 元素弹性伸缩

在弹性元素上设置缩放比例系数，在 nowrap 的时候

- `flex-shrink`: 缩小比例**(容器宽度 < 元素总宽度时收缩)**，默认为 1，等比收缩

  - 真实的计算公式：

    $$
    Overflow = Width_{parent} - \sum{Width_{child}}
    $$

    $$
    SumChild = \sum{shrink_{child} Width_{child}}
    $$

    $$
    shrink_{child}^{'} = shrink_{child}\times Width_{child} / SumChild
    $$

    $$
    ShrinkedWidth_{child} = Width_{child} + shrink_{child}^{'} \times Overflow
    $$

  - 所以每个弹性元素的收缩因子都会影响各自的收缩宽度

  - 给定值越大，收缩越厉害

- `flex-grow`: 生长比例**(容器宽度 > 元素总宽度的时候伸展)**

  - 容器内还有一定的宽度剩余，默认是不能分配给子元素的，flex-grow 默认为 0
  - 比例值作为份数，将剩余宽度按照份数分给子元素，子元素生长，会撑满容器
  - 无剩余宽度的时候 flex-grow 无效

### 弹性处理和刚性尺寸 [flex-basis](https://developer.mozilla.org/en-US/docs/Web/CSS/flex-basis)

有些场景需要元素的尺寸固定，不需要弹性调整，元素尺寸除了 height 和 width 外，flex 布局还有`flex-basis`，基础？

该属性定义了在分配多余空间之前，项目占据的主轴空间（main size）。浏览器根据这个属性，计算主轴是否有多余空间。它的默认值为`auto`，即元素的本来大小。--来自阮一峰老师

#### 和 width/height 有区别！

设置的是在主轴上的初始尺寸，在有 width 的情况下，`flex-basis `优先级更高！也可以是 auto，由 width 决定，没有 width 则由内容决定，可以实现不让这个元素被其他 flex 元素压缩。

注意：`flex-basis` 仅仅是**主轴上的尺寸**！和 width 其实没关系，改变主轴方向就变成了 height 了

#### 常用的复合属性 flex

**flex = flex-grow + flex-shrink + flex-basis**

一些简写

- `flex: 1` = `flex: 1 1 0%`
- `flex: 2` = `flex: 2 1 0%`
- `flex: auto` = `flex: 1 1 auto;`
- `flex: none` = `flex: 0 0 auto;` // 常用于固定尺寸 不伸缩

flex:1 和 flex:auto，在初始主轴尺寸上 0 和 auto 的区别

- flex-basis 设置为 0 之后，flex-shrink 和 flex-grow 伸缩的时候不考虑其尺寸

### 如何对齐弹性元素

#### 主轴对齐

容器设置`justify-content:`定义了子元素在主轴上的对齐方式。

```css
.box {
  justify-content: flex-start | flex-end | center | space-between | space-around;
}
```

![主轴对齐](http://www.ruanyifeng.com/blogimg/asset/2015/bg2015071010.png)

- flex-start: 和起始点对齐
- flex-end: 和终点对齐
- center: 居中
- space-between: 两端对齐，彼此间隔相同
- space-around:每个弹性元素两侧的间隔相等，所以中间的会多一倍

#### 交叉轴对齐

交叉轴上单行和多行的情况！

##### 单行对齐 align-items

```css
.box {
  align-items: flex-start | flex-end | center | baseline | stretch;
}
```

![](http://www.ruanyifeng.com/blogimg/asset/2015/bg2015071011.png)

- `flex-start`：交叉轴的起点对齐。
- `flex-end`：交叉轴的终点对齐。
- `center`：交叉轴的中点对齐。
- `baseline`: 沿着**第一行文字**的基线对齐。
- `stretch`（默认值）：如果项目未设置高度或设为 auto，将占满整个容器的高度。

记得交叉轴只是和主轴垂直的方向啊！

##### 多行对齐 align-content

在`flex-wrap: wrap`等情况的时候，放不下的元素会换行

**对多行作为整体进行对齐**

- `flex-start`：与交叉轴的起点对齐。
- `flex-end`：与交叉轴的终点对齐。
- `center`：与交叉轴的中点对齐。
- `space-between`：与交叉轴两端对齐，轴线之间的间隔平均分布。
- `space-around`：每根轴线两侧的间隔都相等。所以，轴线之间的间隔比轴线与边框的间隔大一倍。
- `stretch`（默认值）：轴线占满整个交叉轴。

大致上和主轴差不多的，多了 space-between 和 space-around

##### 两者的差异

- 作用域不同，align-content 管所有的行，视为整体；align-items 只管单行

##### align-self

弹性元素上的属性

和`align-items`相同，会覆盖，默认值为 auto 表示继承父元素的`align-items`

### 其他属性

#### order 调整元素的顺序

- 值为下标，**越小越靠前**，**默认为 0**

- 相同的下标看 dom 顺序
