# 层叠上下文

> 参考来自张鑫旭大佬的[文章](https://www.zhangxinxu.com/wordpress/2016/01/understand-css-stacking-context-order-z-index/)
>
> 以及[这篇](https://www.joshwcomeau.com/css/stacking-contexts/)

## 是什么？

说大白话就是页面元素出现在人面前的前后关系

如果当元素出现重叠的时候，搞清楚层叠顺序就能让我们快速清除重叠的原因了

![层叠顺序元素的标注说明](./_imgs/stacking_context.assets/2016-01-07_235108.png)

下面这两个是层叠领域的黄金准则。当元素发生层叠的时候，其覆盖关系遵循下面 2 个准则：

1. **谁大谁上：**当具有明显的层叠水平标示的时候，如识别的 z-index 值，在同一个层叠上下文领域，层叠水平值大的那一个覆盖小的那一个。通俗讲就是官大的压死官小的。
2. **后来居上：**当元素的层叠水平一致、层叠顺序相同的时候，在 DOM 流中处于后面的元素会覆盖前面的元素。

## 层叠上下文

所谓上下文就是从某个节点开始的元素树，该树中的节点元素所在的区域就满足上面的规则

个人理解和 BFC 其实差不多，在 CSS3 之后，也能通过某些属性来触发层叠上下文：

- 页面根元素 `<html>`
- z-index 为数值的**定位元素**——_传统层叠上下文_
- 其他 CSS3 属性

### 传统层叠上下文

来个张大佬的例子：

```html
<div style="position:relative; z-index:auto;">
  <img src="mm1.jpg" style="position:absolute; z-index:2;" /> <-- 横妹子 -->
</div>
<div style="position:relative; z-index:auto;">
  <img src="mm2.jpg" style="position:relative; z-index:1;" /> <-- 竖妹子 -->
</div>
```

此时两个容器 div 都不是层叠上下文（不在同一个上下文中），所以两个图片会根据 z-index 来排序

但是调整一下两张图片的父容器的 `z-index`

```css
<div style="position:relative; z-index: 0;">
  <img src="mm1.jpg" style="position:absolute; z-index:2;" /> <-- 横妹子 -->
</div>
<div style="position:relative; z-index: 0;">
  <img src="mm2.jpg" style="position:relative; z-index:1;" /> <-- 竖妹子 -->
</div>
```

会发现竖的妹子在横妹子上！

因为 `z-index: auto` 是**不会创建层叠上下文**，而 `z-index: 数值` 则会，两个`<img>`妹子的层叠顺序比较变成了优先比较其父级层叠上下文元素的层叠顺序。这里，由于两者都是`z-index:0`，层叠顺序这一块两者一样大，此时，遵循层叠黄金准则的另外一个准则“**后来居上**”，根据在 DOM 流中的位置决定谁在上面。

不知道什么时候起，Chrome 等 webkit 内核浏览器，`position:fixed`元素天然层叠上下文元素，无需`z-index`为数值。根据我的测试，目前，IE 以及 FireFox 仍是老套路。（文章 2016 年）

### CSS3 与新时代的层叠上下文

CSS3 的出现除了带来了新属性，同时还对过去的很多规则发出了挑战。例如，CSS3 `transform`[对 overflow 隐藏对 position:fixed 定位的影响](http://www.zhangxinxu.com/wordpress/2015/05/css3-transform-affect/)等。而这里，层叠上下文这一块的影响要更加广泛与显著。

如下：

1. `z-index`值不为`auto`的`flex`项(父元素`display:flex|inline-flex`).
2. 元素的`opacity`值不是`1`.
3. 元素的`transform`值不是`none`.
4. 元素`mix-blend-mode`值不是`normal`.
5. 元素的`filter`值不是`none`.
6. 元素的`isolation`值是`isolate`.
7. `will-change`指定的属性值为上面任意一个。
8. 元素的`-webkit-overflow-scrolling`设为`touch`.

文中每个都举例子了。。确实看傻眼，上面这些条件触发层叠上下文之后，会完全改变常规对层级的认知，以后遇到了就知道怎么找问题了。

定位元素为什么会自动在上一层，其根本原因就在于，元素一旦成为定位元素，其`z-index`就会自动生效，此时其`z-index`就是默认的`auto`，也就是`0`级别，根据上面的层叠顺序表，就会覆盖`inline`或`block`或`float`元素。

## isolation

上文提到的 CSS [isolation 属性](https://developer.mozilla.org/en-US/docs/Web/CSS/isolation)，determines whether an element must create a new **层级上下文**。在配合  [`mix-blend-mode`](https://developer.mozilla.org/en-US/docs/Web/CSS/mix-blend-mode) and [`z-index`](https://developer.mozilla.org/en-US/docs/Web/CSS/z-index) 这两个属性非常有用。

- 和 `mix-blend-mode` 配合，如果某个元素不需要在 z 轴 blend 颜色的话，就设置 `isolation` 独立

```css
.wrapper {
  isolation: isolate;
}
```

此时 wrapper 元素就是一个层级上下文容器，无需 z-index/fixed/absolute 等方式创建，这样是最纯粹的层级上下文创建方式。就能够让 children 元素的层级关系在这个独立的层级上下文中生效。
