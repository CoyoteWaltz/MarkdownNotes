## 更好的处理加载失败的图片

> 来自[张鑫旭](https://www.zhangxinxu.com/wordpress/2020/10/css-style-image-load-fail/)
>
> TL;DR：核心思路就是通过 onerror 得知图片加载失败，并且用伪元素来修饰一下失败场景

### 传统图片加载失败

<div>
<img src="123" alt="图片" />
</div>
会出现浏览器的兜底样式，not good。同时会触发 onerror

### 优化

1. onerror 之后添加 class
2. 对应 class 的伪元素：
   1. before 添加兜底展示样式
   2. after 添加文案
3. _当然也可以通过这个方法，为图片加载的时候添加兜底样式？_

```html
<img src="xxx.png" alt="图片" onerror="this.classList.add('img--error');" />
```

```css
img.img--error {
  display: inline-block;
  transform: scale(1);
}
img.img--error::before {
  content: "";
  position: absolute;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background: #f5f5f5 url(break.svg) no-repeat center / 50% 50%;
  color: transparent;
}
img.img--error::after {
  content: attr(alt);
  position: absolute;
  left: 0;
  bottom: 0;
  width: 100%;
  line-height: 2;
  background-color: rgba(0, 0, 0, 0.5);
  color: white;
  font-size: 12px;
  text-align: center;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
```
