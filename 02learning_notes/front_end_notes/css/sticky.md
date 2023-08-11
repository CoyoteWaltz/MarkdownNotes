# Position Sticky

> [参考](https://www.zhangxinxu.com/wordpress/2018/12/css-position-sticky/)

## `position:sticky`

relative 和 fixed 的结合体，离开屏幕就变成 fixed

```css
position: -webkit-sticky; // safari 前缀
position: sticky;
```

**sticky 元素效果完全受制于父级元素们**。（摘录）

1. 父级元素不能有任何`overflow:visible`以外的 overflow 设置，否则没有粘滞效果。因为改变了滚动容器（即使没有出现滚动条）。因此，如果你的`position:sticky`无效，看看是不是某一个祖先元素设置了`overflow:hidden`，移除之即可。
2. 父级元素设置和粘性定位元素等高的固定的`height`高度值，或者高度计算值和粘性定位元素高度一样，也没有粘滞效果。我专门写了篇文章深入讲解了粘性效果无效的原因，可以[点击这里查看](https://www.zhangxinxu.com/wordpress/2020/03/position-sticky-rules/)。
3. 同一个父容器中的 sticky 元素，如果定位值相等，则会重叠；如果属于不同父元素，且这些父元素正好紧密相连，则会鸠占鹊巢，挤开原来的元素，形成依次占位的效果。至于原因需要理解粘性定位的计算规则，同样[点击这里查看](https://www.zhangxinxu.com/wordpress/2020/03/position-sticky-rules/)。
4. sticky 定位，不仅可以设置`top`，基于滚动容器上边缘定位；还可以设置`bottom`，也就是相对底部粘滞。如果是水平滚动，也可以设置`left`和`right`值。

第三方实现，搜了下还挺多的，用了这个：https://github.com/yahoo/react-stickynode，用了下还不错，并且能有 sticky 状态发生变化的 callback，可以结合消息/订阅的模式实现相对 sticky 的效果～
