# Padding bottom 的妙用

## padding-bottom 的值可以是百分比

> 可[参考](https://css-tricks.com/oh-hey-padding-percentage-is-based-on-the-parent-elements-width/)

padding-bottom 如果是百分比数值，是基于父容器的宽度，用他来自适应图片的高度，防止因为宽度不同导致图片被纵向拉伸，可以带来一些便利，比如：

- 父容器宽度写死后，内部的图片元素便可以直接 100 width，padding-bottom 采用图片真实比例（height/width）% 来做
- 比如背景的氛围图场景
