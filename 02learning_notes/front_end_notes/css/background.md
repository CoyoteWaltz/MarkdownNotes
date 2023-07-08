# background

> 花里胡哨的背景、图片，非常重要的属性

背景属性也是所有属性的合集：`background:#000 url(图片地址) no-repeat left top`

每一**_层_**用逗号隔开，写一起太难看了，还是分开来写吧

这个层：可以有多个 background

- 颜色：不多说了，色彩英文/16 进制/rgb()/rgba()/hsl/hsla()
- 背景图 url：`background-image`，多层的背景用`,`隔开，其他属性对应层来同样用`,`隔开
  - 多个背景重叠放置，在前的层叠放在上面（ The first layer specified is drawn as if it is closest to the user.）
  - 背景色可以是渐变色、图片 URL、元素等等，一会详细看一下[`linear-gradient()`](https://developer.mozilla.org/en-US/docs/Web/CSS/linear-gradient), [`radial-gradient()`](https://developer.mozilla.org/en-US/docs/Web/CSS/radial-gradient), [`repeating-linear-gradient()`](https://developer.mozilla.org/en-US/docs/Web/CSS/repeating-linear-gradient), [`repeating-radial-gradient()`](https://developer.mozilla.org/en-US/docs/Web/CSS/repeating-radial-gradient), [`element()`](https://developer.mozilla.org/en-US/docs/Web/CSS/element), [`image()`](https://developer.mozilla.org/en-US/docs/Web/CSS/_image), [`image-set()`](https://developer.mozilla.org/en-US/docs/Web/CSS/image-set), [`url()`](https://developer.mozilla.org/en-US/docs/Web/CSS/url)
- 水平重复：`background-repeat`，可以有两种语法：
  - 1 个值：`repeat-x`、`repeat-y`、`repeat`、`space`（背景图之间空格）、`round`（会拉满整个范围，不留 space）、`no-repeat`
  - 2 个值：分别指定 horizontal 和 vertical 方向的重复
- 定位：`background-attachment`，设置背景相对于 viewport 是否 fixed，或者在他所在 block 中可以滚动
  - fixed：相对于视口固定了，即使这个元素可以滚动，也不会随之滚动。也就是固定在了页面上，很牛逼，这个背景会相**对于 viewport** 固定，意味着不会出现在 div 的位置，需要改变 position 来定位，但是可以利用这个特性做一些滚动看到图片的特性！
  - local：相对于 div 定位，跟随滚动
  - scroll：相对 div 固定，不跟随滚动
- 位置：`background-position`，定位背景开始的 x/y 坐标
  - 1 个值：`center`，`top`，`bottom`，`right`，`left`，`center` 就直接放在 div 中心，其余的，会让对应的背景的边紧贴 div 边，其他方向都保持在中间位置；如果这个值是数字/长度/百分比，那么是 x 方向的偏移，此时的 y 方向在 50% 位置
  - 2 个值：成对的出现，位置或者长度或者百分比，表示 x 和 y 方向的位置，但注意别写反人类的比如既上又下的那种。。。默认：`top left` or `0% 0%`
  - 3 个值：两个是 position 的关键字，另一个是长度/百分比，作为前（precede）一个位置的 offset。比如：`background-position: top 10px left;`的第二个`10px`是`top`的 offset，`top left 10px`的`10px`
  - 4 个值：和 3 个值的情况一样，1、3 位表示位置，2、4 位表示 offset
- 切片：`background-clip`，定义背景是如何被 clip 的
  - `border-box`：在 border 范围上拓展背景
  - `padding-box`：在 padding 上拓展背景（也就是 padding 是有背景的）
  - `content-box`：被裁剪到 content 的范围
  - `text`：仅对文字有背景效果，可以做文字特效哦（支持度不高！）
- 原点：`background-origin`，sets the background's origin: from the border start, inside the border, or inside the padding. 值和上面的三个一样（除了 text，表示背景开始的边界）
- 背景图大小：`background-size`
  - `contain`：放大图片以至于覆盖范围，但不会**裁剪**和**拉伸**
  - `cover`：放大图片覆盖，不会**拉伸**，所以和 contain 的区别只是会裁剪？来 cover 元素范围
  - `auto`：在对应方向上自动的放大，可以设置`auto, auto`
  - 长度/百分比：两个方向上的大小
