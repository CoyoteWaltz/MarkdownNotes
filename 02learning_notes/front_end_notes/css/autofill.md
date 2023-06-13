# autocomplete 选中后的颜色

## How to autofill

> 参考
>
> - https://css-tricks.com/almanac/selectors/a/autofill/

通常在表单填写登录/注册的聚焦 input 的时候，会弹出自动填充信息的菜单，很常见。自动填充是浏览器（UA）自带的一个功能，可以在浏览器设置中开启（chrome/firefox 搜索「自动填充/autofill」），并且可以设置保存的信息

### 如何开启 autocomplete

> 参考 [MDN](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete)

浏览器可能会保存用户之前填写过的 name、address、phone number、email 信息（需要权限，用户可以在设置中关闭）

`autocomplete` 属性在 `input` `textarea` `select` `form` 元素上都可以作用，前三者如果没有开启这个属性，会去找他们各自上层所属的 `form` 元素（内部的 or 他们的 `form` 属性指向的 form 元素）的 `autocomplete`

> **Note:** In order to provide autocompletion, user-agents might require `<input>`/`<select>`/`<textarea>` elements to:
>
> 1. Have a `name` and/or `id` attribute
> 2. Be descendants of a `<form>` element
> 3. The form to have a submit button

具体值：

- off
- on：开启，没有任何引导，由浏览器自己决定信息
- name：预期是用户完整的名字，但是也可以细化到 honorific-prefix、given-name 等，但不推荐
- username
- email
- new-password：创建新账户的时候通常浏览器可以避免输入老密码，并且提供一个更安全的加密过的密码选择
- ... 还有非常多的选项，具体看 MDN 吧

[如何关闭](https://developer.mozilla.org/en-US/docs/Web/Security/Securing_your_site/Turning_off_form_autocompletion)

### 样式问题

但是浏览器提供的自动填充菜单的样式我们是不能控制的，同样选中完内容后，input 的样式也发生了变化，这是浏览器自带的样式（可能变成黄色/蓝色背景）

审查 css 可以看到有这样的内置样式，同样我们写 CSS 也是无法覆盖这个样式

```css
input:-internal-autofill-selected {
  // ...
}
```

## 覆盖样式

> 参考来自 [stackoverflow](https://stackoverflow.com/questions/2781549/removing-input-background-colour-for-chrome-autocomplete)

无法通过覆盖 background 属性来修改样式，但是可以通过 box-shadow 来改变背景，`-webkit-text-fill-color` 来改变文字颜色

```css
/* Change the white to any color */
input:-webkit-autofill,
input:-webkit-autofill:hover,
input:-webkit-autofill:focus,
input:-webkit-autofill:active {
  -webkit-box-shadow: 0 0 0 30px white inset !important;
}
```

更加骚一点的操作是开启背景色的渐变，设置一个很长的时间

```css
transition: background-color 5000s ease-in-out 0s;
```
