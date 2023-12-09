# CSS 变量

> 不多说了，非常好用的特性，[MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/--*)

## 兼容性问题

存在低版本兼容的问题（IOS 9 以下）

可使用 [npm 包](https://www.npmjs.com/package/css-vars-ponyfill)，参考[教程](https://jhildenbiddle.github.io/css-vars-ponyfill/#/?id=usage)

或者简单兼容，在 `var` 语句前再做一次兜底值（对于会改变的变量不太友好）

```css
color: red;
color: var(--colorRed);
```
