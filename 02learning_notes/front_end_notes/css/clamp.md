# Clamp 函数

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/clamp)
>
> The function takes three parameters: a minimum value, a preferred value, and a maximum allowed value.

## 介绍

```css
font-size: clamp(1rem, 10vw, 2rem);
```

使用使用这个方法，能够实现字体大小的动态根据宽度自适应，能够满足类似设计同学的「字多了字体就小一点」的需求，并且无需 [fluid typography](https://css-tricks.com/snippets/css/fluid-typography/) 中的 `media-query`

可以在 viewport 增大的同时设置字体大小，并且能有最大/最小限制

## 参数

`clamp(min, val, max)`

- min
  - The minimum value is the smallest (most negative) value. This is the lower bound in the range of allowed values. If the preferred value is less than this value, the minimum value will be used.
- val
  - The preferred value is the expression whose value will be used as long as the result is between the minimum and maximum values.
- max
  - The maximum value is the largest (most positive) expression value to which the value of the property will be assigned if the preferred value is greater than this upper bound.

## 兼容性

所有浏览器都支持，但是版本还挺高的（基本都是 20 年才支持）

- chrome: 79（2019-12-10）
- Safari: 13.1（2020 年）
