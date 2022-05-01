# Grid 布局

## 网格布局

> 参考：https://ishadeed.com/article/grid-layout-flexbox-components/
>
> grid for layout and flexbox for components，文章介绍了 flex 和 grid 布局的一些差异，给出了如何结合两者布局的更好的建议

```css
.wrapper {
  display: grid;
}
```

### 属性

#### grid-template-columns

告诉 css 如何计算每个 column 之间的距离

定义 grid 的个数以及他们的长度 `grid-template-columns: 1fr 2fr;`

- none：表示没有任何 grid
- [linename]：
- 长度单位
- 百分比：grid 容器的百分比
- 自适应单位：fr
- minmax 函数：`minmax(100px, 1fr)`，可以定义一个范围 >= min && <= max，这个 grid 的宽度就会被这两个给限制
  - `minmax(10px, auto)`：最小 10px 宽度，最大自动计算
- repeat()：CSS 函数，生成一个 track list
  - auto-fill
  - auto-fit

#### grid-template-rows

和 column 一样定义行维度的尺寸

#### grid-template-areas

通过用 grid area 的名字来规划区域布局

1. 首先需要给每个 grid 元素一个名字，用 `grid-area: <string>`
2. 布局，用名字字符串（或者 `.` 表示空元素）的 + 空格的形式

例子：

```css
#page {
  display: grid;
  width: 100%;
  height: 250px;
  grid-template-areas:
    "head head"
    "nav  main"
    "nav  foot";
  grid-template-rows: 50px 1fr 30px;
  grid-template-columns: 150px 1fr;
}

#page > header {
  grid-area: head;
  background-color: #8ca0ff;
}

#page > nav {
  grid-area: nav;
  background-color: #ffa08c;
}

#page > main {
  grid-area: main;
  background-color: #ffff64;
}

#page > footer {
  grid-area: foot;
  background-color: #8cffa0;
}
```

#### grid-template

简写属性，定义 columns、rows 和 areas

- grid-template-rows **/** grid-template-columns values：`grid-template: auto 1fr / auto 1fr auto;`
- grid-template-areas grid-template-rows / grid-template-column values
-

#### grid-row/column-start/end

定义一个 grid 开始和结束的位置（范围）

```css
.wrapper {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  grid-auto-rows: 100px;
}

.box1 {
  grid-column-start: 1;
  grid-column-end: 4;
  grid-row-start: 1;
  grid-row-end: 3;
}

.box2 {
  grid-column-start: 1;
  grid-row-start: 3;
  grid-row-end: 5;
}
```

比如上面这个 box1 的范围就是 (1, 1) -> (1, 4)，box2 的范围是 (1, 3) -> (3, 5)，可以用坐标范围来理解

#### row/column-gap

定义行 or 列之间的距离

### 支持度

IE 肯定是别想了，甚至都不支持 `@supports` 查询

```css
@supports (grid-area: auto) {
  body {
    display: grid;
  }
}
```

可以用 flex 作为 grid 布局的兜底（fallback）

## CSS 长度单位 fr

> 参考：https://css-tricks.com/introduction-fr-css-unit/

`fr` 是 _fraction_ 的缩写，是一种自适应的长度单位（flex）

在 grid-layout 中，可以很方便的作为每一格长度的计算。比如需要布局 12 个平均宽度的 grid，其间隔为 10px，使用 `fr` 可以减去很多的计算，让代码变得 readable and maintainable

```css
.container {
  display: grid;
  gird-template-columns: repeat(12, 1fr);
  grid-column-gap: 10px;
}
```

这段代码会让浏览器自动计算均等分 12 份之后，包含 10px 间距的宽度。

也可以混合其他单位进行布局

```css
.container {
  display: grid;
  gird-template-columns: 60% repeat(2, 1fr);
  grid-column-gap: 10px;
}
```
