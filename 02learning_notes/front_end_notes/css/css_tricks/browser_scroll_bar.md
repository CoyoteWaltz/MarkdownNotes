### 浏览器滚动条导致宽度缩小、页面跳动

> [解决方案](https://aykevl.nl/2014/09/fix-jumping-scrollbar)

#### 浏览器的 scroll bar

设置 `overflow: scroll` 的时候，不管是内容长短，都会出现 scroll bar 的位置

此时，`window.innerWidth` or `100vw` 也就是 viewport 的宽度是包含滚动条的宽度

而 CSS 的 `height: 100%` 是不包含的

#### 水平方向跳动

我们通常不会总是展示滚动条，而是让他需要的时候出现（`overflow: auto`），但出现的时候就会让宽度计算出问题，导致页面元素在水平方向闪动。**注意这里其实只有在水平方向自适应的情况才会遇到（flex、margin auto）**

所以文章的解决方法就是给最外层容器（直接在视窗内）加一个 `margin/padding-left`

```css
margin-left: calc(100vw - 100%);
```

滚动条的出现会将容器向左推（压缩了宽度），需要将多出的滚动条宽度作为左边的偏移量，再向右推，抵消这个效果

_注意别自作聪明的把这个值除以二。。。_

可以看[代码例子](https://codepen.io/anon/pen/NPgbKP)

PS. 移动端的滚动条通常不会挤到视窗里面，所以可以最好给一个最大宽度的 media query
