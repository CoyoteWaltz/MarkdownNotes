## 文字渐变色 + 动画

> 效果[来自](https://fasterthanlight.net/)

直接上代码

```html
<div>
  <span id="text">text is text</span>
</div>
```

CSS：渐变色可以通过[工具](https://www.joshwcomeau.com/gradient-generator)得到想要的

- 核心是通过 `background-clip: text` 让背景只作用在文字上
- 通过改变 `background-position` 来动画 wave

```css
#text {
  --bg-size: 400%;
  --color-one: #ff2400;
  --color-two: #e81d1d;
  --color-three: #e8891d;
  --color-four: #b2e81d;
  --color-five: #1de83f;
  --color-six: #1ddde8;
  --color-seven: #2b1de8;
  --color-eight: #6900f3;
  --color-nine: #dd00f3;
  background: linear-gradient(
      100deg,
      var(--color-one),
      var(--color-two),
      var(--color-three),
      var(--color-four),
      var(--color-five),
      var(--color-six),
      var(--color-seven),
      var(--color-eight),
      var(--color-nine),
      var(--color-one)
    ) 0 / var(--bg-size) 100%;
  color: transparent;
  background-clip: text;
  -webkit-background-clip: text;
  animation: move-bg 8s infinite linear;
}

@keyframes move-bg {
  to {
    background-position: var(--bg-size) 0;
  }
}
```
