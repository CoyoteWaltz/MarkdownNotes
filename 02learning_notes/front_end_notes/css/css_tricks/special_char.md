## `&nbsp;`

全称为 Non-breaking Space，表示不在此处换行

当页面变窄之后，文字会在空格处折行，但是插入 `&nbsp;` 的空格则**不会折行**，继续以一行显示

## 零宽字符

> https://juejin.cn/post/6844904164057677831

```css
零宽空格（zero-width space, ZWSP）用于可能需要换行处。
    Unicode: U+200B  HTML: &#8203;
零宽不连字 (zero-width non-joiner，ZWNJ)放在电子文本的两个字符之间，抑制本来会发生的连字，而是以这两个字符原本的字形来绘制。
    Unicode: U+200C  HTML: &#8204;
零宽连字（zero-width joiner，ZWJ）是一个控制字符，放在某些需要复杂排版语言（如阿拉伯语、印地语）的两个字符之间，使得这两个本不会发生连字的字符产生了连字效果。
    Unicode: U+200D  HTML: &#8205;
左至右符号（Left-to-right mark，LRM）是一种控制字符，用于计算机的双向文稿排版中。
    Unicode: U+200E  HTML: &lrm; &#x200E; 或&#8206;
右至左符号（Right-to-left mark，RLM）是一种控制字符，用于计算机的双向文稿排版中。
    Unicode: U+200F  HTML: &rlm; &#x200F; 或&#8207;
字节顺序标记（byte-order mark，BOM）常被用来当做标示文件是以UTF-8、UTF-16或UTF-32编码的标记。
    Unicode: U+FEFF
```

使用场景：

- 可以用来计算一行文字初始的高度，比较 tricky
- ...

### 踩坑

#### 零宽字符 + url

在 js 中零宽字符可以通过 `\u200B` 字面量生成

如果 url 的开头包含了零宽字符，很难察觉，而且会直接 window.open 的行为

```javascript
let s = "\u200B"; // s.length => 0
window.open(s + "https://www.baidu.com");
```

我们看到的 url 是 `https://www.baidu.com` 因为零宽字符不可见

但 window.open 看到的是 `\u200Bhttps://www.baidu.com`，不是一个合法的 url，所以会当成是当前域名下的 path 去打开新的窗口，最终打开的是 `${originURL}/%E2%80%8Bhttps://www.baidu.com` 直接寄了。
