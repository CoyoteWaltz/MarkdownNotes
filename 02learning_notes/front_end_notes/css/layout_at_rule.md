# `@layer`

> [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@layer) 教程
>
> [张鑫旭文章](https://www.zhangxinxu.com/wordpress/2022/05/css-layer-rule/)
>
> _一个 CSS 的新特性（浏览器支持的版本都比较高，Chrome 要 99）_
>
> _能够更好的通过声明层级（layer）来解决 CSS 样式覆盖的问题_
>
> 用来声明一个级联层级（cascade layer），并且可以定义层级的优先权

## 背景

使用组件库开发的时候，通常需要根据 UI 定制一些颜色、边框之类的 CSS 样式，我们一般都是直接使用优先级更高的选择器进行覆盖

```css
.container .some-button {
}
```

但这种代码写起来真的头疼，而且又臭又长，有些组件库甚至有全局的 reset 样式，会污染整个文档流的样式

## @layer 的作用

**对于组件或者模块的 CSS，我们可以全部写在 @layer 规则中，把自身的优先级降到底部。**这样上层再次覆盖样式就非常简单

_Any styles not in a layer are gathered together and placed into a single anonymous layer that comes after all the declared layers, named and anonymous. from MDN_

可以理解为任何没有在 `@layer` 下的样式都会被默认汇集到一个最顶层的匿名 layer，会覆盖其他已经定义的 layer 样式（也就是说没有 layer 的优先级最高，有 layer 的反而低）

具体语法：

```css
@layer layer-name {rules};
@layer layer-name;
@layer layer-name, layer-name, layer-name;
@layer {rules};
```

直接看个例子吧

**可以定义多个层级的优先级，不同层级中有相同的规则时，最后一个胜出**

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

上面 `special` 和 `base` 两个 layer 中都声明了特定的样式，最终通过 `@layer base, special;` 这一句告诉 CSS 样式（其中的 color 规则）的顺序 special > base

用 `@layer` 来指定不同渲染样式的层级的顺序，然后在指定某个 layer 下面的特殊样式进行覆盖。

### 个人理解（伪代码）

相当于

```javascript
let @layer = defineLayerStyle(rules, name)

// 定义层级优先级
@layer abc, cbc, bbc;

// 定义很多套/层样式
@layer({ color: red; }, abc);

@layer({ color: green; font-weight: 800; }, bbc);

@layer({ font-weight: 400; line-height: 1.5; }, cbc);

```

最终浏览器编译成：

```css
function getLayerStyle(name);

// @layer abc, cbc, bbc;

// getLayerStyle(abc);
// getLayerStyle(cbc);
// getLayerStyle(bbc);
{
  color: red;
}
{
  font-weight: 400;
  line-height: 1.5;
}
{
  color: green;
  font-weight: 800;
}

// 最终样式结果如下
{
  color: green;
  line-height: 1.5;
  font-weight: 800;
}

```

层级优先级看似是定义了一片 CSS 规则，实际上是针对单条 CSS 规则（比如 color）

### 让整个 CSS 文件变成 @layer

让这个样式文件整个有一个 layer 叫 lib

使用 `@import` 时

```css
@import "./zxx.lib.css" layer(lib);
```

使用 `link` 时

```html
<!-- zxx-lib.css的样式属于名为 lib 的级联层 -->
<link rel="stylesheet" href="zxx-lib.css" layer="lib" />

<!-- 样式引入到一个匿名级联层中 -->
<link rel="stylesheet" href="zxx-lib.css" layer />
```

### 嵌套 layer

```css
@layer outer {
  button {
    width: 100px;
    height: 30px;
  }
  @layer inner {
    button {
      height: 40px;
      width: 160px;
    }
  }
}
```

等价于用 `.` 连接

```css
@layer outer {
  button {
    width: 100px;
    height: 30px;
  }
}
@layer outer.inner {
  button {
    height: 40px;
    width: 160px;
  }
}
```

优先级

```css
@layer 甲 {
  p {
    color: red;
  }
  @layer 乙 {
    p {
      color: green;
    }
  }
}
@layer 丙 {
  p {
    color: orange;
  }
  @layer 丁 {
    p {
      color: blue;
    }
  }
}
```

其中的优先级大小是这样的：`丙 > 丙.丁 > 甲 > 甲.乙`

### 兼容性

详见 [MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@layer#browser_compatibility)

主流浏览器都支持了（Chrome 99）

## revert-layer

来自[张鑫旭](https://www.zhangxinxu.com/wordpress/2023/03/css-revert-layer-global-keyword/)

首先了解下 revert 关键字，能够让样式规则还原到浏览器自带的样式，通常我们会使用`all: revert`这个 CSS 声明让浏览器的 UI 控件还原成默认的样子。

`revert-layer `可以让 CSS 属性值还原为上一层 @layer 中设置的同属性值，**如果当前 CSS 不在@layer 规则中，或者没有祖先 @layer 规则，则表现类似于 revert 关键字，使用浏览器默认的控件样式。**

### 单 layer 的例子

```html
<ul>
  <li class="revert-layer">第1项，颜色是revert-layer</li>
  <li class="revert">第2项，作者张鑫旭, revert</li>
  <li class="deepcolor">欢迎转发，点赞</li>
</ul>
```

```css
@layer {
  .revert-layer {
    color: revert-layer; // 寻找祖先的颜色
  }
  .revert {
    color: revert; // 还原到浏览器自带
  }
  .deepcolor {
    color: deepskyblue;
  }
}
```

### 多个 layer

```css
@layer base, special; // special > base

@layer special {
  .revert-layer {
    color: revert-layer; // 还原到 base layer
  }
  .revert {
    color: revert; // 还原到浏览器自带
  }
  .deepcolor {
    color: deepskyblue;
  }
}

@layer base {
  .revert-layer {
    color: deeppink;
  }
  .revert {
    color: deeppink;
  }
  .deepcolor {
    color: deeppink;
  }
}
```

### 嵌套 layer

```css
@layer outer {
  // 外部的 layer 优先级 > 内部 layer
  .revert-layer {
    color: revert-layer; // 所以会还原到内部的 inner deeppink
  }
  .revert {
    color: revert;
  }
  .deepcolor {
    color: deepskyblue;
  }
  @layer inner {
    .revert-layer {
      color: deeppink;
    }
    .revert {
      color: deeppink;
    }
    .deepcolor {
      color: deeppink;
    }
  }
}
```

### 最后

**对于第三方组件应用**

revert-layer 关键时候还是很有用的。

以后使用第三方组件，都会尽量放在 @layer 中，这样优先级低，样式才能轻易覆盖。

但是，如果希望样式被覆盖后，又继续使用组件里面设置的样式，那只能使用 revert-layer 关键字。

**可以这么说，revert 关键是是浏览器默认样式还原，revert-layer 是第三方组件默认样式还原，这样是不是容易理解多了。**
