# About Unicode

> 参考
>
> - [这篇 blog](https://blog.xinshijiededa.men/unicode/)，写的很不错
> - [用正则匹配 emoji](https://taxodium.ink/post/emoji-regexp/)

> 没有所谓的纯文本。
>
> 文本都是经过*编码*的

（个人理解）回到小白视角，何为字符编码？

- 计算机识别到某个码位，将其映射成某个字符展示的过程
  - 码位：可以理解为字符映射表中的 key，由特定的数值组成
    - 举个（不真实的）例子：1 对应“人”，2 对应“😋”

## Unicode 是什么？

Unicode 是一个将不同字符分配给唯一编号的表格。

Unicode 有多大？

目前，已被定义的最大码位是 0x10FFFF。这给了我们大约 110 万个码位的空间。

目前已定义了大约 17 万个码位，占 15%。另外 11% 用于私**有使用**。其余的大约 80 万个码位目前没有分配。它们可能在未来变成字符。

私用区：为程序开发人员保留的，unicode 永远不会定义他们

前缀 `U+` 表示的就是 Unicode，最高定义的码位是 `U+10FFFF`（16 进制）

## UTF-8 是什么

**一种编码**，是 unicode 的一种编码

> 一开始说的文本编码，从 计算机 → 文本展示 的角度看，就是将码位映射成文本图案，反之亦然
>
> 这里的将 unicode → utf-8 的编码也是一种映射，目的是为了更好的节省字符所需的空间而做的优化

最简单的 unicode 编码是 utf-32，即一共用 32 位来存储一个 unicode，`U+1F4A9` 变为 `00 01 F4 A9`，占用 4 个字节，Unicode 所有码位都适合。

`utf-8` `utf-16` 相对复杂一些，但也是将码位作为**字节**进行编码

### UTF-8 有多少字节？

首先他是一种**变长**编码，码位可能被编码（映射）为 1 到 4 个字节的序列

| 码位                | 字节                                         |
| ------------------- | -------------------------------------------- |
| U+`0000`..`007F`    | `0xxxxxxx`                                   |
| U+`0080`..`07FF`    | `110xxxxx` `10xxxxxx`                        |
| U+`0800`..`FFFF`    | `1110xxxx ` `10xxxxxx` `10xxxxxx`            |
| U+`10000`..`10FFFF` | `11110xxx ` `10xxxxxx` `10xxxxxx` `10xxxxxx` |

与 Unicode 表结合起来，就可以看到英语使用 1 个字节进行编码，西里尔语、拉丁语、希伯来语和阿拉伯语需要 2 个字节，中文、日文、韩文、其他亚洲语言和 Emoji 需要 3 个或 4 个字节。

几个特点/亮点：

1. 完全与 ASCII 兼容，0-127 就是 ASCII，两者可以等价
2. 对于基本的阿拉丁语来说可以节省空间
3. **自带错误检测和错误恢复的功能**，第一个字节的前缀总与第 2-4 个字节不同，总是可以判断当前是否在查看完整且有效的 utf8 字符序列（例如跳转到某个字节，向前或向后找到正确的序列开头）

这带来了一些重要的结论：

- 你**不能**通过计数字节来确定字符串的长度。
- 你**不能**随机跳到字符串的中间并开始读取。
- 你**不能**通过在任意字节偏移处切割来获取子字符串。你可能会切掉字符的一部分。

试图这样做的人最终会遇到这个坏小子：�

### � 是什么？

`U+FFFD` 替换字符，当应用和库检测到 Unicode 错误是，就可以使用它，来显示错误

**扩展字位簇**（extended grapheme cluster），这里简称*字位*

字位（grapheme，或译作字素），是在特定书写系统的上下文中最小的可区分的书写单位。也是我们实际（开发过程中）需要操作的最小单位（字符）

问题是，在 Unicode 中，一些字位使用多个码位进行编码！

- 比如说，`é`（一个单独的字位）在 Unicode 中被编码为 `e`（U+0065 拉丁小写字母 E）+ `´`（U+0301 连接重音符）。两个码位！

**所以就是为什么不要操作字符编码的字节。。**

一个扩展字位簇是一个或多个 Unicode 码位的序列，必须被视为一个单独的、不可分割的字符。

### `"🤦🏼‍♂️".length` 是什么？

python、Java/JavaScript/C#、Rust 得到不一样的值。。。

一个不被计算机内部拖累的人，他给的答案就是 1！而只有 swift 这门现代语言是正确的

1. 内部，面向计算机的一层，对字符串的表达，都是采用 utf-8 之类的编码格式，并不会分析他之于人类的含义
2. 外部，面向人类的 API，UI 的字数统计，Swift 会给出一个试图

`"ẇ͓̞͒͟͡ǫ̠̠̉̏͠͡ͅr̬̺͚̍͛̔͒͢d̠͎̗̳͇͆̋̊͂͐".length"`

Unicode 的规则一直在变化！大概从 2014 年开始，Unicode 每年都会发布一次主要修订版。这就是你获得新的 emoji 的地方——Android 和 iOS 的更新通常包括最新的 Unicode 标准。

```javascript
"Å" === "Å"; // false
"Å" === "Å"; // false
"Å" === "Å"; // false 蛤蛤
```

NFD 和 NFC 被称为「规范归一化」。另外两种形式是「兼容归一化」，上面字符就是从字位簇归一化到了一个 unicode

**NFKD** 尝试将所有东西分解开来，并用默认的替换视觉变体。

**NFKC** 尝试将所有东西组合起来，同时用默认的替换视觉变体。

## Unicode 是基于区域设置的

计算机如何知道何时呈现保加利亚式字形，何时使用俄语字形？

简短的回答：它不知道。不幸的是，Unicode 不是一个完美的系统，它有很多缺点。其中之一就是是将相同的码位分配给应该看起来不同的字形，比如西里尔小写字母 K 和保加利亚语小写字母 K（都是 `U+043A`）。

许多中文、日文和韩文的象形文字被分配了相同的码位

### 为什么 `String::toLowerCase()` 的参数中有个区域设置？

```javascript
var en_US = new Intl.Locale("en", "US");
var tr = new Intl.Locale("tr");

"I".toLowerCase(en_US); // => "i"
"I".toLowerCase(tr); // => "ı"

"i".toUpperCase(en_US); // => "I"
"i".toUpperCase(tr); // => "İ"'
```

依然应该。即使是纯英文文本也使用了许多 ASCII 中没有的「排版符号」

## 什么是代理对？

代理对（surrogate pair）是用于编码单个 Unicode 码位的两个 UTF-16 单位。例如，`D83D DCA9`（两个 16 位单位）编码了一个码位，`U+1F4A9`。

但是后来发现 65535 并不足以表达所有字符，16 位不够，那就需要增加 Unicode 去表达更多字符。

实现的方法就是定义了 **代理对 (Surrogates pairs)** , 代理对由 20 位组成。

规定前 10 位作为 **高代理位 (high-surrogate)** ，取值范围是 0xD800 - 0xDBFF。

后 10 位为 **低代理位 (low-surrogate)** ，取值范围是 0xDC00 - 0xDFFF。

高代理位和低代理位组成代理对 (surrogate pairs) 。

由于有 20 位的长度，因此可以表达 1048576 个字符，可以在原来 65536 个字符之上，再增加 1048576 个字符。

为什么 Unicode 要这么设计，可以参考 [Why does code points between U+D800 and U+DBFF generate one-length string in ECMAScript 6?](https://stackoverflow.com/questions/42181070/why-does-code-points-between-ud800-and-udbff-generate-one-length-string-in-ecm)

为什么高代理和低代理这么取值，可以参考 [How was the position of the Surrogates Area (UTF-16) chosen?](https://stackoverflow.com/questions/5178202/how-was-the-position-of-the-surrogates-area-utf-16-chosen)）

概括来说，就是在 JavaScript 的 String 中常用的字符（如字母，数字，汉字）是由 1 个 UTF-16 编码单元表示的。

而超出 65535 (0xFFFF, U+FFFF, \uFFFF) 字符（如 Emoji），则由代理对表示（高代理+低代理，2 个 UTF-16 编码单元）。

### 在 JavaScript 中 string

length：要注意是不是代理对

```javascript
"🌷🉐".length; // 4 这两个 emoji 都是代理对
```

获得 utf16 编码

```javascript
"🉐".split(""); // [ '\ud83c', '\ude50' ]
"🉐".charCodeAt(0); // 55356
"🉐".charCodeAt(1); // 56912
String.fromCharCode(55356, 56912); // '🉐'
```

## JavaScript 获得真正的 length

```javascript
"😄😄😄😄😄😄😄😄😄😄".length; // 20
console.log(Array.from("😄😄😄😄😄😄😄😄😄😄").length); // 10
console.log(Array.from("🚴🏻👌🏻🙏🏻💪🏻🚴🏻👌🏻🙏🏻💪🏻🚴🏻👌🏻").length); // 10
```

## 总结

- Unicode 已经赢了。
- UTF-8 是传输和储存数据时使用最广泛的编码。
- UTF-16 仍然有时被用作内存表示。
- 字符串的两个最重要的视图是字节（分配内存/复制/编码/解码）和扩展字位簇（所有语义操作）。
- 以码位为单位来迭代字符串是错误的。它们不是书写的基本单位。一个字位可能由多个码位组成。
- 要检测字位的边界，你需要表格。
- 对于所有 Unicode 相关的东西，甚至是像 `strlen`、`indexOf` 和 `substring` 这样的无聊的东西，都要使用 Unicode 库。
- Unicode 每年更新一次，规则有时会改变。
- Unicode 字符串在比较之前需要进行归一化。
- Unicode 在某些操作和渲染中依赖于区域设置。
- 即使是纯英文文本，这些都很重要。

## 使用正则匹配 emoji

### TL;DR

```typescript
/\p{Emoji_Presentation}/gu.test("你好hello123😄hi🌷456🉐") // true
/\p{Emoji_Presentation}/gu.test("你好hello123") // false
```

### 使用 `\p{...}`

`\p{...}`, `\P{...}` 是 [Unicode character class escape](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Regular_expressions/Unicode_character_class_escape#browser_compatibility)，也是一种转译字符类（一类字符的集合表示，比如 `\d` 是 `[0-9]`，`\s`，`\w`），这里是可以通过设置 Unicode property 来匹配相关的字符，必须开启 `u` 这个 [unicode flag](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp/unicode#unicode-aware_mode)

```javascript
\p{loneProperty}
\P{loneProperty}

\p{property=value}
\P{property=value}
```

loneProperty 可以参阅：https://tc39.es/ecma262/multipage/text-processing.html#table-binary-unicode-properties

兼容性：全支持

- chrome 64
- nodejs 10
