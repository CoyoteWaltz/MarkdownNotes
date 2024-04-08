# 关于字符编码

> 参考[这篇](https://darkyzhou.net/articles/character-encoding-you-must-know#%E5%89%8D%E8%A8%80)
>
> 了解字符背后的编码原理，还是很有意思的

### 概念

#### 字符集

字符集（Charset）是一系列字符（Character）构成的集合。

#### 码点

码点（Code point）表示一个字符在字符集中所处的位置。

#### 字符编码

一个字符对应的 0/1 的序列，计算机解析到对应的序列就知道需要展示哪个字符了

### ASCII

美国在上世纪 60 年代推出的字符编码，它囊括了英文 26 个字母的大小写形式、以及一些标点符号和特殊的控制字符（Control codes），它使用了 7 个比特对字符进行编码

美国以外的其他国家选择在 ASCII 的基础上加入新的字符构成自己国家内通行的字符编码

### ISO/IEC 8859

这是欧洲国家基于 ASCII 扩展出来的**一系列字符编码规范**，这系列规范总共有十多个，涵盖了欧洲各个国家使用的各种字符。例如，其中的 ISO/IEC 8859-1 字符编码主要包含了西欧国家（德国、法国等）所使用的字符

### GB/T 2312-1980

在 1980 年，国家推出了 GB 2312 规范（“GB”是“国标”的拼音缩写，即国家标准），它涵盖了**几千个常用的简体汉字**、标点符号以及 ASCII 中的所有字符。

#### 编码方案

GB 2312 主要使用了 EUC-CN 编码方案。**它将 ASCII 字符（即英文字符等）编码为 1 个比特，且与 ASCII 一致；而将汉字字符编码为 2 个比特。**例如，对于小写英文字母“a”，它会被编码为“1100001”，和 ASCII 一模一样。又如，对于汉字“坤”，它会被编码为“0xC0 0xA4”（这里使用十六进制表示）。同时，汉字编码的两个比特中的每一个的范围都必须在“0xA1”到“0xFE”之间。这样，**计算机在遇到一个比“0xA1”小的比特时，就知道这代表一个 ASCII 字符；在遇到一个比“0xA1”大的字符时，就知道这个比特和后面的一个比特共同代表一个汉字字符**。

### GBK

GBK 可能是在国内最广为人知的汉字编码了。**GBK 是 GB 2312 在字符集上的扩展，也就是说 GBK 囊括了 GB 2312 中的所有字符，除此之外它也包括了繁体汉字以及 GB 2312 推出之后才出现的简体汉字。**

GBK 在 1993 年被微软公司发布，并且自此之后**一直都是 Windows 简体中文版的默认文本字体**。

#### 屯屯屯和烫烫烫

初写 C++ 在控制台里打印出来的乱码哈哈哈

> 这些神奇的乱码是如何产生的？据笔者查找资料，原来是 Windows 平台上的 VC++ 编译器在调试模式下会自动将未初始化的栈内存的值填充为 0xCC，将未初始化的堆内存的值填充为 0xCD。同时，由于在简体中文版 Windows 下的命令提示符（cmd）使用的默认文字编码为 GBK。那么，当遇到一连串的 0xCC 时，系统就会按照 GBK 编码解释 0xCCCC 得到了“烫”；遇到一连串的 0xCD 时，系统解释 0xCDCD 得到了“屯”。

### Unicode

Unicode 是由 Unicode Consortium 维护的一套囊括了世界上绝大多数语言的文字的通用字符集。它的 1.0.0 版本在 1991 年发布，最新的版本是在 2020 年发布的 13.0 版本，此时它已经囊括了超过 14 万个字符，来自 154 种世界上目前使用的，以及历史上曾经使用过的书写系统，以及近几年越来越火的 Emoji 表情。为了兼容 ASCII 编码，它将整个字符集的前 128 个字符定义为 ASCII 的所有 128 个字符。

#### Unicode 平面

Unicode 由 17 个平面（Plane）组成，每个平面最多可以包含 216 个字符。其中，第一个平面是 Plane 0，也被称为 BMP（Basic Multilingual Panel，基本多语言平面）。

#### 一个误区

这里还要注意，Unicode 只是字符集（Charset），不是编码规范！

#### Unicode Zalgo Text

这里额外介绍一个有趣的概念：Unicode Zalgo Text。首先我们来看一个例子：“é”和“é”。你能看出这两个字符的区别吗？这两个字符看上去一模一样，但是如果把它们分别复制下来使用编程语言比较，实际不是一样的

H̴͓̪̩̟̳̺̠̫̤͉̭̗̊̏͑e̷̛̮̠͖͕̝͍̤l̸̛̮͈͍̬̇̈͌́̌̑̎̿͌͝l̶͔͕̀̒̋͐ȍ̷̡̧̦̘̹̺̫̟̭̣͂̌͗̍̽͒̈͑̋̈́͂͑̄͠ ̴̨̲͓̙̺̰͖̞̯̼̝͚̦̐̈́͊̂̊́͊̚ͅw̷̝͍͑̋͐̂͘o̸̱̽̈̓̌̅̽̑́̔͒̃̏̅͗r̶͙͖̬͙̚͝ͅl̴̨͇͙͇̯̬͔̙̞͛̑̈̀͑̓̉̈́͒̾͠͝d̷̠͙̲̗̲̍̐̅

### UTF-8

#### 简介

UTF-8 是一套面向 Unicode 的变长（Variable-width）字符编码规范。**“变长”是指可变长度，依据字符的不同，可能将它编码为一个、两个、三个或四个字节。**其中，UTF-8 专门将 ASCII 中的字符编码为一个字节，且与 ASCII 保持一致，这样 UTF-8 做到了兼容 ASCII 编码。

#### 锟斤拷

在介绍 GBK 编码时，我们介绍了两个著名的乱码产生的原理。这里再介绍一下另一个著名的乱码“锟斤拷”是如何产生的。在 Unicode 中，有一个特殊的字符“�”（U+FFFD），规范规定 Unicode 处理程序在遇到一个无法处理的 Unicode 码点时（可能是因为码点的值无效等原因），将它对应字符替换为这个特殊字符。这种情况在使用 UTF-8 解码 GBK 编码后的文本时可能会发生。

特殊字符“�”在 UTF-8 中会被编码为 0xEFBFBD。一连串的 0xEFBFBD 在 GBK 中会被解码为“锟”（0xEFBF）、“斤”（0xBDEF）和“拷”（0xBFBD），这就是锟斤拷产生的原理。

### UTF-16

#### 简介

UTF-16 是 Unicode 官方采用的另一套编码规范，它的编码范围和 UTF-8 一样，而且也同样是变长的字符编码规范。不过，UTF-16 的编码规则很特殊：对于位于 BMP 的字符，它们将被编码为两个字节；而对于 BMP 之外的字符（从 U+10000 到 U+10FFFF），它们将被编码为四个字符。

也由于这种特殊的编码规则，**UTF-16 并不兼容 ASCII**。不过，Windows 内核、Java 和 Javacript/ECMAScript 的内部使用的却都是 UTF-16 编码。

### UTF-32

UTF-32 也是 Unicode 官方采用的编码规范。**和前面的 UTF-8、UTF-16 相比，它最大的不同在于它是一套定长（Fixed-length）编码规范，即每一个字符都被编码为 32 个比特（即 4 个字节）**。Go 语言中的`rune`类型使用的就是 UTF-32 编码。

### Emoji😎

#### 简介

Emoji 受到了上世纪 90 年代日本移动社交网络的影响，是一套经过多方参与共同形成的统一标准，囊括了各种表情、符号等。和 Unicode 类似，Emoji 也在不断地更新发展之中，不断地有新的 Emoji 被加入标准之中。

需要注意的是，Emoji 也是一个字符集！他的元素来自 Unicode！只是**定义了什么字符是 Emoji**

当然，每个字体厂商是可以特制 Emoji 字符集的样式的

#### Emoji 与 Unicode Zero-width joiner

在 Unicode 中有一个特殊的字符叫做 Zero-width joiner（ZWJ，码点 U+200D，是不是就是零宽字符？）。它被用来给一些复杂的语言（例如阿拉伯语）的文字进行特殊的排版操作，例如将两个原本连写的字分拆出来。ZWJ 如果单独使用是不会显示的。

Emoji 字符：👨‍👩‍👦，其实是由 👨、ZWJ、👩、ZWJ、👦 一共五个字符连接而成的。