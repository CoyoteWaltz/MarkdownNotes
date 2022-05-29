# `@layer`

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@layer) 教程
> 一个 CSS 的新特性（浏览器支持的版本都比较高，Chrome 要 99）
> 能够更好的通过声明层级（layer）来解决 CSS 样式覆盖的问题

直接看个例子吧

```css
@layer base, special;

@layer special {
  .item {
    color: rebeccapurple;
  }
}

@layer base {
  .item {
    color: green;
    border: 5px solid green;
    font-size: 1.3em;
    padding: 0.5em;
  }
}
```

用 `@layer` 来指定不同渲染样式的层级的顺序，然后在指定某个 layer 下面的特殊样式进行覆盖。

有啥好处？
