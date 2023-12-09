# 伪元素合集

## :any-link

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/:any-link)
>
> 所有含有表现形式为链接的元素选择器

任何有 href 属性的 `<a>` or `<area>` or 所有的 [`:link`](https://developer.mozilla.org/en-US/docs/Web/CSS/:link) or [`:visited`](https://developer.mozilla.org/en-US/docs/Web/CSS/:visited).

## :is()

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/:is)
>
> 最早是 `:matches()` 和 `:any()`，后续被 CSSWG 给重命名成 `:is()`

传入一系列选择器，选择任意的元素，生效 CSS，可以组合使用简化一些复杂的元素选择

```css
/* 3-deep (or more) unordered lists use a square */
:is(ol, ul, menu, dir) :is(ol, ul, menu, dir) :is(ul, menu, dir) {
  list-style-type: square;
}
```

注意

- 不支持选择伪元素

兼容性

Chrome 88（21 年）

## :has()

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/:has) 的介绍很晦涩

看个例子

```css
/* Selects an h1 heading with a
paragraph element that immediately follows
the h1 and applies the style to h1 */
h1:has(+ p) {
  margin-bottom: 0;
}
```

语法

```ccss
:has(<relative-seletor-list>)
```

理解：将 `has` 的参数中的相对选择器和元素本身进行组合判断，如果能选择到元素，那么就使得 CSS 生效（作用在元素本身）

所以开始判断上面的 `h1 + p` 选择器，如果 h1 后紧接着有 p 标签，那么就生效 CSS

### 用法

#### 配合 `:is()`

```css
h1,
h2,
h3 {
  margin: 0 0 1rem 0;
}

// 选择 h1 or h2 or h3 元素，他们紧跟着 h2 or h3 or h4
:is(h1, h2, h3):has(+ :is(h2, h3, h4)) {
  margin: 0 0 0.25rem 0;
}
```

#### 逻辑判断

可以用来检查多个 featrue 在当前上下文中是否存在

```css
body:has(video, audio) {
  /* styles to apply if the content contains audio OR video */
}
body:has(video):has(audio) {
  /* styles to apply if the content contains both audio AND video */
}
```

### 兼容性

Chrome 105（22 年 9 月）
