# Web Component

> 参考[阮一峰](https://www.ruanyifeng.com/blog/2019/08/web_components.html)，[MDN](https://developer.mozilla.org/en-US/docs/Web/Web_Components)
>
> TODO：需要实践

## Why

> 谷歌公司由于掌握了 Chrome 浏览器，一直在推动浏览器的原生组件，即 [Web Components API](https://www.webcomponents.org/introduction)。相比第三方框架，原生组件简单直接，符合直觉，不用加载任何外部模块，代码量小。目前，它还在不断发展，但已经可用于生产环境。

能通过纯 web 技术，实现更多定制组件的扩展，尽可能的复用、组件化（也就是现在框架在做的事情）

## What

我们可以创建出自定义的 html 标签元素，`<user-card></user-card>`，展示自定义的元素。

## 怎么用

> Web Components is **a suite of** different technologies allowing you to create reusable custom elements — with their functionality encapsulated away from the rest of your code — and utilize them in your web apps.

### 主要的几个 API

#### Custom elements

用来向浏览器注册自定义的标签（组件）

`customElements.define('custom-tag-name', ComponentClass)`

```javascript
class UserCard extends HTMLElement {
  constructor() {
    super();
  }
}
```

在 constructor 中就可以用 pure js 来操作 dom，其中的 this 指向的就是

#### shadow DOM

在 dom 树下挂载一个“影子” dom，和主文件流隔离渲染，可以将这个 dom 私有化，不会受到 js/css 的冲突/覆盖的困扰。

#### HTML templates

用 [`<template>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/template) or [`<slot>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/slot) 来写一些不会被渲染出来的 dom 元素（仅作为模版）

是不是和 vue 很像，可以将三部分写在一个 SFC 里面。
