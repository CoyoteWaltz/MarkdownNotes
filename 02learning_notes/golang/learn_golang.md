# Go 语言学习之旅

安装过程略过

官网说必看[go effective](https://golang.org/doc/effective_go.html#introduction)(科网)

---

github 有一个教程叫[go101](https://github.com/go101/go101)于是 clone 下来准备照着这个来学语法。

根据其 README 来启动 go101，`go run *.go`

---

阅读开始https://github.com/go101/go101

update on 2021.06.05 10:25:51 从这个 [website](https://go101.org/article/101.html) 阅读，界面改版成深色主题了？

## Chapter 1 About GO 101 这本书写来干嘛的

开篇作者以为自己掌握了 Go，想要写一本教程书，然后发现自己一无所知哈哈哈，然后积累了几年，终于牛逼了。提醒学者不能轻敌，要有对的 attitude。

提到了

- go 语言的 api 封装性挺好，官方解释的文档也很简单
- go 的优点有:
  - 静态语言但是有动态的灵活性
  - 内存节省，fast program warming-up?，执行的快 三大优点集一身不容易啊
  - 自带并行，可读性高，跨平台，内核稳定
- 书本会详细介绍基本概念和术语，值的部分？，内存 block 部分，interface values?，

## 致谢略过不读

## Chapter 2 An introducion of Go

- 编译型静态强类型语言 compiled and static typed

- go 的 features:
  - built-in concurrent 自带并行编程支持
    - 叫 goroutines 的东西，green threads 绿色线程？
    - channels 隧道？是 based on CSP 模型的 TODO:去了解一下
  - 容器类型 map 和 slice?一等公民？
  - 接口的多态？polymorphism
  - value boxing and reflcetion through interfaces?
  - 指针
  - 函数闭包
  - 方法
  - 类型嵌入(type embedding)？
  - 类型 deduction
  - 内存安全
  - 自动垃圾回收
  - 跨平台兼容性
- 一些高光 features:

  - 语法设计简单，快速上手
  - 很多很棒的标准代码库，大多数都是跨平台的
  - go 社区

  用 go 写代码的可以叫 gophers 哈哈

- go 的编译器，叫 Go compiler 或者 gc(abbreviation)，go team 还有一个 gccgo

  - gc 有官方的 go sdk
  - For example, noticeable lags caused by garbage collecting is a common criticism for languages with automatic memory management. lag 啥含义
  - 跨平台: Linux 上编译的东西在 window 也能运行，反之亦然
  - 编译贼快

- 执行 go 的优势:

  - 小内存占用

  - 快速代码执行

  - 短启动时间?short warm-up duration (so great deployment experience)

    下面是 C/C++/Rust 等编译型语言没有的

  - 快编译结果，本地开发快

  - 灵活动态语言

  - 内置 concurrent 编程支持！

- 也有一些 shortcomings:

  - 不支持泛型编程(C++)

## The Official Go SDK

复习一下什么是 sdk: 软件开发工具包 software development kit

第一次接触 sdk，应该就是各种函数库吧

这一章讲怎么 setup 和运行简单 programs

8 过我已经安装好了

最简单的程序

```go
package main

func main() {

}
```

`package`和`func`是关键字，两个`main`是 identifier 指示器?后面一章会介绍

运行 go run:

- `go run xxx.go`多文件`go run .`
- 不推荐这样去运行大项目

go 的操作:

- `go build`或者`go install`去运行大项目

- `go fmt`去 format 一个源代码

- `go get`
- `go test`测试基准
- `go doc`查看 go 的文档
- `go mod`管理依赖
- `go help`查看操作

## 要开始和 Go Code 打交道了

### Introduction to Source Code Elements

啥叫源代码元素啊??

Programming can be viewed as manipulating operations in all kinds of ways to reach certain goals.这句话挺好

The type system of a programming language is the spirit of the language.

开篇讲的东西还是很值得一读的，大致是以编程语言为主线，从最初的低级指令编程是 error-prone 的到高级语言对低级指令的封装和对数据的抽象能较好的解决错误问题的效率问题，引出数据类型系统的重要，

Named functions, named values (including variables and named constants), defined types and type alias are called **resources** in Go 101.

变量和包的命名要遵循 identifier 的标准，这后面会说。

讲到了许多高级语言用 packet 封装代码，导入一个包要 import，同时一个包要 export resource。

go 里的注释: `//` or `/**/`

看代码了

```go
/*
 * @Author: CoyoteWaltz
 * @Date: 2019-11-28 18:39:21
 * @LastEditors: CoyoteWaltz
 * @LastEditTime: 2019-11-28 19:00:43
 * @Description: from go 101 sample
 */
package main // specify the source file's package
// different in other lang

import "math/rand" // import a standard package

const MaxRnd = 186 // a named constant declaration

// A function declaration
/*
 StatRandomNumbers produces a certain number of
 non-negative random integers which are less than
 MaxRnd, then counts and returns the numbers of
 small and large ones among the produced randoms.
 n specifies how many randoms to be produced.
*/
func StatRandomNumbers(n int) (int, int) {
	// Declare two variables (both as 0).
	var a, b int
	// A for-loop control flow.
	for i := 0; i < n; i++ {
		// An if-else control flow.
		if rand.Intn(MaxRnd) < MaxRnd/2 {
			a = a + 1
		} else {
			b++ // same as: b = b + 1
		}
	}
	return a, b // this function return two results
}

// "main" function is the entry function of a program.
func main() {
	var num = 100 // automatically deduce the type
	// Call the declared StatRandomNumbers function.
	x, y := StatRandomNumbers(num)
	// Call two built-in functions (print and println).
	print("Result: ", x, " + ", y, " = ", num, "? ")
	println(x+y == num)
}

// (Note, the built-in print and println functions are not recommended to be used
// in formal Go programming.
// The corresponding functions in the fmt standard packages should be used
// instead in formal Go projects. In Go 101, the two functions are only
// used in the several starting articles.)
// import "fmt"
// fmt.Printf("hello, wodddd\n")
```

We should try to make code self-explanatory and only use necessary comments in formal projects.这也很重要！

牛逼了，说道花括号可不能像 C++一样乱放，很多时候**左花括号不能放在行的开始！**不过我也习惯是把左括号放在函数声明的后面。书上说这么做可以快速编译，方便 gophers 阅读代码。快速编译是咋回事？

小结一下: 题目说道的 code elements 其实就是编程遇到的种种东西，变量、函数。。。。

---

### Keywords and Identifiers

25 个关键字

```go
break     default      func    interface  select
case      defer        go      map        struct
chan      else         goto    package    switch
const     fallthrough  if      range      type
continue  for          import  return     var
```

记一下没见过的:

- `chan` `interface` `map` `struct`是在组合类型标记里面用的
- `fallthrough`
- `defer` `go`也是控制流里面的关键字，特殊方法，之后说
- 所有的之后都会详细说明

#### Identifiers

用来 identify 变量、package、函数、等等 code element 的

单下划线`_`是特殊的 identifier，叫**blank identifier**

**注意点:**

- **大写字符开头的是可以被 Import**，可以看成是这个 package 可以给别的包 public 的
- 其他的都是 non-exported 的，private
- 惊了，只要是 Unicode Standard 8.0 的都可以，中文也行，日文韩文也行.........

---

### Basic Types and Basic Value Literals

#### 来看看基本变量和基本啥 literals??

Types can be viewed as value templates, and values can be viewed as type instances.

内置变量:

- bool
- 11 种 int: int8, uint8, int16, uint16, int32, uint32, int64, uint64, int, uint, uintptr。~~疯了~~还好吧，挺好的类型都标注出来了
- 2 种 float: float32, float64
- 2 种复数: complex64, complex128 还不太了解
- string

说这些类型都属于一个 go 中不同的变量??

两个内置的 aliases:

- byte alias uint8
- rune alias int32

The size of `uintptr`, `int` and `uint` values n memory are implementation-specific.

complex64 的实部和虚部都是 float32，同理 complex128

string 在内存中其实是储存了一堆的 byte，也就是 uint8，ascii 字符 8bit

利用关键字`type`来声明一个 identifier 是一个内置类型

```go
type status bool
type MyString string

type boolean = bool
```

感觉就像是 C++的`typedef`或者是`using xx = xx`

#### 关于 0 值:

- bool 的 false
- 数值类型的 0
- **empty string**

#### Basic Value Literals

A literal of a value is a text representation of the value in code. A value may have many literals.

所谓 litreals, the way of a value is represented:

- int 可以用 10，8,16 进制表示
- float: 1.12 01.21 1.23e2
- 16 进制 float: yPn == y \* 2^n，同样 16 进制的时候不能有 e 出现
- 虚数: `1.23i`反正就是在后面跟一个小写的 i
- 用`_`使数值变量更容易读: `6_9 == 69`

#### Rune value literals

这个 rune 类型是什么东西呢？

可以自定义这个类型，当然默认的类型就是 int32，也算是一个特殊的整型类型吧，可见他是 32 位长的

可以用 rune 来表达很多的整型

Generally, we can view a code point as a Unicode character, but we should know that some Unicode characters are composed of more than one code points each. 这个 code point 不太理解，看成是字节吗？

一般来说大家喜欢用单引号包住字符来表示一个 rune 类型:

```go
'a'
'n'
'哈' // 中文就是两个字节了 16 bit
// 下面也是 'a' ascii = 97
// 141 is the octal representation of decimal number 97.
'\141'
// 61 is the hex representation of decimal number 97.
'\x61'
'\u0061'
'\U00000061'
// 用 \ 之后必须跟着3个8进制的数来表示一个二进制的值
// \x 之后必须 2位16进制的数
// \u 之后必须4位16进制 to represent a rune value,
// \U 之后必须8位16进制 to represent a rune value,
// 4位二进制表示一个十六进制数 也就是换一种方式来表示 rune这个类型的值
```

特殊字符 after `\`别忘了

```go
\a   (Unicode value 0x07) alert or bell
\b   (Unicode value 0x08) backspace
\f   (Unicode value 0x0C) form feed
\n   (Unicode value 0x0A) line feed or newline
\r   (Unicode value 0x0D) carriage return
\t   (Unicode value 0x09) horizontal tab
\v   (Unicode value 0x0b) vertical tab
\\   (Unicode value 0x5c) backslash
\'   (Unicode value 0x27) single quote
```

#### String value literals

**字符串在 go 里面是 utf8 编码的**，go 的源文件当然也是 utf8 编码兼容的啦，不用和 python2 一样指定编码

两种字符串的 literals:

- 双引号括起来的

- 用两个`括起来的 raw string 不会转义 raw 的输出

  ```go
  `hello
  ahah "heihei"`
  ```

_转义字符用的是 escape 这个单词_

---

### Constants and Variables

这篇讲的是 constant 和 variable，常量和变量，关于 untyped values 和 typed values。

#### Untyped valuse and typed values

有些变量在 go 中的 type 是没有被确定的叫做 untyped，大多数这些 untyped 都有一个默认 type，但是`nil`这个是没有默认 type 的 untyped 之后会遇到。

**所有的 literal constant 都是 untyped**。一个 constan 的默认类型是他的 literal form，比如字符串 constant`"sssttrrr"`的类型就是 string。

对 untyped**常量**的 explicit 转换

还挺严格。。。其实也就是说在 go 里面，常量一般都是没有 type 的，只有一个 default type，也只能用它来转换！

#### Introduction of type deductions(inference) in go

和 python 很像，go 也是可以自动判别数据类型的。所以很多时候不需要显示的指明数据类型。go 编译器会自动根据上下文来判别类型。很多 place 需要一个有类型的值或者无类型的值，go 编译器会根据 untyped 的 value 的类型推断这个 place 的类型，这些 place 有: 操作符之后的参数，函数的形参，...总之只要是有赋值操作的时候就会自动 inference，其他的情况下不需要知道数据的类型，直接将 untyped 的 default type 作为类型使用。上面说的两种是隐式转换。

#### Constant Declarations

- 一行一个声明

- 一组一起声明

- 一行多个声明(和 py 一样灵活)

**The `=` symbol means "bind" instead of "assign".** We should interpret each constant specification as a declared identifier is bound to a corresponding basic value literal.

Please note that, constants can be declared both at package level (out of any function body) and in function bodies. _package level go 里面是写 package 作为一个文件比如 package main_

所以 package level 的变量就是作用域在这个 package 的！感觉 go 的思路很清晰

全局 constant 这里也可以叫成 package-level constants，**全局的 constant**变量的声明顺序不重要。

typed named constants

```go
const X float32 = 3.14
const (
	A, B int64   = -3, 5	// golint告诉你B需要单独声明...
	Y    float32 = 2.718	// golint告诉你这样不规范 一定要在上面注释告诉别人Y是什么
)
```

其他的见代码部分

在 group 模式的时候声明 constant 的时候可以不用完整的声明，e.g.

```go
const (
	X float32 = 3.14
	Y           // here must be one identifier
	Z           // here must be one identifier

	A, B = "Go", "language"
	C, _
	// In the above line, the blank identifier
	// is required to be present.
)
// <==等价于==>
const (
	X float32 = 3.14
	Y float32 = 3.14
	Z float32 = 3.14
	A, B = "Go", "language"
	C, _ = "Go", "language"
)
```

#### iota?

iota(一个 generator)是一个 constant 声明的另一个特性，**它是被 predeclared 的**(`const iota = 0`)，const iota 只能被用在其他的 constant declarations，**每次*在 group constant 声明*的时候被使用一次就自增 1**，看一下 go101 的例子

```go
package main

func main() {
	const (
		k = 3 // now, iota == 0

		m float32 = iota + .5 // m float32 = 1 + .5
		n                     // n float32 = 2 + .5

		p = 9             // now, iota == 3
		q = iota * 2      // q = 4 * 2
		_                 // _ = 5 * 2
		r                 // r = 6 * 2
		s, t = iota, iota // s, t = 7, 7
		u, v              // u, v = 8, 8
		_, w              // _, w = 9, 9
	)
	const x = iota // x = 0
	const (
		y = iota // y = 0
		z        // z = 1
	)
	println(m)             // +1.500000e+000
	println(n)             // +2.500000e+000
	println(q, r)          // 8 12
	println(s, t, u, v, w) // 7 7 8 8 9
	println(x, y, z)       // 0 0 1
}
```

有 iota 之后可以很巧妙便捷的声明，So `iota` is only useful in group-style constant declarations.

实战中我们可以这样巧用 iota 牛逼嗷

```go
const (
	Failed = iota - 1 // == -1
	Unknown           // == 0
	Succeeded         // == 1
)
const (
	Readable = 1 << iota // == 1
	Writable             // == 2
	Executable           // == 4
)
```

#### 变量、变量的声明和变量的赋值

声明变量的时候要给 go 编译器提供多一点的信息为了 deduce 类型

package-level variables V.S. local variables

妈的还有两种基本的声明格式，标准和简短，后者只能用来声明 loacal 变量

#### Standard variable declaration forms

- 用 var 关键字开头，变量名，类型，值都是 specified 的

- `var lang, website string = "Go", "xxx"`

- 多变量可以一起，但是要注意他们必须是同一个类型

- Full standard variable declaration forms are seldom used in practice, since they are **verbose**.

- 呵呵

- 有两个标准声明的变形: 也就是利用自动推导类型

  - 不显示给类型，一起声明的变量可以不同类型`var lang, dynamic = "Go", false` go 是静态..编译

  - 不给值的声明，但是要给定类型，编译器自动初始化值

    ```go
    // Both are initialized as blank strings.
    var lang, website string
    // Both are initialized as false.
    var interpreted, dynamic bool
    // n is initialized as 0.
    var n int
    ```

- group 也可以

- **变量声明了你不用，go 会报错**，呵呵呵

- Generally, declaring related variables together will make code more readable.

#### Pure value assignments

等号在改变变量的时候赋值叫做纯值赋值......

一个下划线`_`叫做 blank identifier，可以用作被赋值的对象，也就是忽略输出，但不能放在等号右边

强类型语言，注意类型 match

注意 go 不支持链式赋值`a = b =13`不行！

#### Short variable declaration forms

- 大开眼界啊妈的
- `lang, year := "sss", 2200` 注意这是声明 ！
- redeclare: `year, sss := 111, "sss"` 注意这里的 year 仅仅是改变了值，不能改变类型
- 声明行必须只少声明一个新的变量，不然直接给他赋值就行了
- 与标准声明的区别:
  - var 和类型必须 omitted
  - 必须**:=**
  - 如果是新老变量可以一起在声明行中，也就是必须至少有一个新声明，才能用:=

#### 谈谈 Assignment

x is assignable to y which means if statement `x = y` is legal (compiles okay)此时的 y 类型为 Ty，那么可以说 x is assignable to type Ty，这里 y 与 x 类型相同或者可以是隐式转换，同时 y 可以是`_`

and 局部变量声明之后需要被至少用一次....但是全局的变量没有这样的限制，所谓的 be effectively used 是指最起码被放在等号左边....被当做赋值来用，实在不行就`_ = unused`生产模式别搞..debug 可以搞搞

#### Dependency relations of package-Level variables affect their initialization order

前面说到了全局变量的声明是可以不管顺序的,看看他们之间的相互依赖会产生的影响吧

```go
var x, y = a+1, 5         // 8 5
var a, b, c = b+1, c+1, y // 7 6 5
```

先看能直接赋值的 y=5-->c=y=5-->b=6-->a=b+1=7-->x=a+1

声明的时候循环赋值(loop/circularly)就不行了`var x, y = y, x`编译不过

#### Value Addressability

所有变量都有地址可寻,然而 constant 都没有的,之后的指针篇会学更多

#### Explicit Conversions on Non-Constant Numeric ValuesExplicit Conversions on Non-Constant Numeric Values

显示类型转换 on **非 const 变量**,有以下几个点

- 除了 int 到 str 还有浮点数到 int,任意复数之间
- overflow 是可以的,也就是会被近似(rounding)

#### Scopes of Variables and Named Constants

A variable or a named constant declared in an inner code block will _shadow_ the variables and constants declared with the same name in outer code blocks.这句话很有意思,在内部的 block,也就是{}里的变量会 shadow(遮蔽)外部同样名称的变量，后面文章会详细讲。

#### More About Constant Declarations

untyped 的 constant 可以在声明的时候 overflow，但在用的时候必须处理成不会 overflow。

有名字的 constant 在被编译的时候会被替换成他的值。可以看成是 C 语言中的加强版宏定义。

---

### Common Operators

数学，位操作，比较，布尔，字符串拼接算子。都是二元或者一元(unary)算子，且都返回一个值

#### Arithmetic Operators

- 算术运算符就和 cpp 一样，除法要注意类型，int 类型就是整除
- 位运算中有一个 bitwise clear: `x &^ y`: 按 y 的位将 x 置零: 返回 y 的 1 所在位将 x 对应位置为 0，也就是先取反 y，再和 x 与。这是 go 独有的，`m &^ n` is equivalent to `m & (^n)`.
- `+`也可以用于 string 拼接
- `*`和`&`也用于指针，like c and cpp
- 不像 java，无符号移位`>>>`这个没有
- power operator 没有基础款，只能用在 mathpackage 中的 Pow 函数

**rune 和 int 在操作符两边之后会返回 rune 的类型。**

位运算符(binary)的返回值类型的规则:(先记下来吧，到时候细看)

- 通常来说返回的都是 int

- 如果左参数是有特定类型的，返回类型也是他

- 如果左参数 untyped，**右边是一个 constant**，那么左参数会被当做是 int 类型，如果他的默认类型不是 int，那么必须要可以是转换成 int 的类型。返回结果也是一个 untyped 的，默认类型是和左参数一样

- 如果左参数 untyped，右边是 non-constant，那么左参数会先被转换成一样类型的，返回值是一个有类型的值。

  ```go
  var m = uint(32)
  var z = int64(1) << m
  /*
  if the operand 1 is deduced as int instead of int64, the bitwise operation at line 13 (or line 12) will return different results between 32-bit architectures (0) and 64-bit architectures (0x100000000), which may produce some bugs hard to detect.
  */
  ```

感觉 go 挺强调变量的类型的，因为不像 cpp/c 对类型如此严格的声明，go 更灵活，但也要求我们要对变量的类型清楚的不得了。

#### 关于 overflow

溢出不允许发生在 typed constant，但是可以是 non-constant 和 untyped constant，为什么呢。

首先变量的溢出直接按照内存给的位不够了还好理解，untyped-constant 允许溢出个人认为是由于上面提到了 const 相当于是宏定义，那么即使在声明 untyped 常量的表达式是会溢出的那只要在编译替换的时候整个表达式不溢出就 ok 了，所以允许，但是 typed 常量明显不允许了。

```go
var a, b = 4.0, 0.0
println(a / b) // +Inf
// println(0 / 0)
```

上面是可以通过编译的，说是分母为 int0 但不是 constant 的时候会引起一个 run-time panic，相当于是其他语言的 error，之后会学到 panics。

go 支持`op=`,`++`, `--`，但是自增自减只能是后缀，对象必须是数值类型(小数也可以)，且不返回任何值！

#### String concatenation

`+`即可，同样可以`+=`

#### Boolean operators

和 cpp 一样，两边有一个是 typed 那么结果也是 typed 的，如果两边都是 untyped，那么结果 untyped

#### Comparison operators

一样，返回值一般都是 untyped，如果两边都是 constant，那么返回也是 const bool。注意 not all real numbers can be accurately represented in memory, so comparing two floating-point (or complex) values may be not reliable. We should check whether or not the absolution of the difference of two floating-point values is smaller than a small threshold to judge whether or not the two floating-point values are equal.

#### Operator precedence(优先级吧)

```go
*   /   %   <<  >>  &   &^ // 按行以此递减 行中一样 按从左到右来
+   -   |   ^				// 与其他不一样 << >> 比 + -优先级高
==  !=  <   <=  >   >=
&&
||
```

```go
const x = 3/2*0.1
const y = 0.1*3/2

func main() {
	println(x) // +1.000000e-001
	println(y) // +1.500000e-001
}
```

---

### Function Declarations and Function Calls

写函数啦！函数操作符(function opeation)通常叫做函数调用(function call)

#### 函数声明

```go
func SquaresOfSumAndDiff(a int64, b int64) (s int64, d int64) {
	x, y := a + b, a - b
	s = x * x
	d = y * y
	return // <=> return s, d
}
```

函数签名: 关键字 func 函数名 输入参数() return 的参数() 函数体{}

- go 函数可以返回多个结果

- 输入和输出参数的形式可以看成是没有`var`的标准类型声明。

- 返回的变量声明(list)的**名字**必须一起出现或者没有，两者都可以。如果 result 是有 name 的，被叫做 named result，否则叫 anonymous result

  ```go
  func SquaresOfSumAndDiff(a int64, b int64) (int64, int64) {
  	return (a+b) * (a+b), (a-b) * (a-b)
  }
  ```

- 如果参数没有在函数体中被使用，那么他们的名字也可以没有，anonymous parameters 实际中很少用。

- go 不支持参数的默认值

- 如果连续的(successive)参数或者 result 的类型是一样的，可以省略`func SquaresOfSumAndDiff(a, b int64) (s, d int64)`and`func SquaresOfSumAndDiff(a, b int64, flag1, flag2 bool) (s, d int64) `

- 返回值是一个的时候可以省略()，**但是类型一定要给**，如果没有返回值....，但是参数的()必须要有

  ```go
  // Foo .
  func Foo(x int, b bool) int {
  	println(x, b)
  	return 1
  }
  ```

- 函数声明必须在 package level 中，在函数体内的只可以是匿名函数，但这不叫函数声明（？？？）

#### Function calls

就一般的用就行。**函数的声明可以是写在调用之后的！**感觉是编译的时候把所有的 func 排序？main 放最后？？我猜的。

Function calls can be deferred or invoked in new goroutines (green threads) in Go. Please read [a later article](http://localhost:55555/article/control-flows-more.html) for details.

#### Exiting phase

就是函数 return 的时候并没有结束，而是进入了一个退出阶段，这个之后还会讲到。

#### Anonymous Functions

定义一个匿名函数几乎和一个函数声明是一样的，只不过他是没有 name 的。

```go
x, y := func() (int, int) {
    println("This function has no parameters.")
    return 3, 4
}() // Call it. No arguments are needed.
// 这里直接call匿名函数对x和y进行了初始化

func(a, b int) {
    // The following line prints: a*a + b*b = 25
    println("a*a + b*b =", a*a + b*b)
}(x, y) // pass argument x and y to parameter a and b.

func(x int) {
    // The parameter x shadows the outer x.
    // The following line prints: x*x + y*y = 32
    println("x*x + y*y =", x*x + y*y)
}(y) // pass argument y to parameter x.

func() {
    // The following line prints: x*x + y*y = 25
    println("x*x + y*y =", x*x + y*y)
}() // no arguments are needed. 这个匿名函数是可以直接用到x和y的
```

In fact, all custom functions in Go can be viewed as closures. This is why Go functions are as flexible as many dynamic languages.

#### 内置函数

后文还会提到

`println`

`print`

`real`

`imag`

`complex`

如果参数有一个是 constant，返回值也是 constant，同理 untyped

```go
// c is a untyped complex constant.
const c = complex(1.6, 3.3)

// The results of real(c) and imag(c) are both
// untyped floating-point values. They are both
// deduced as values of type float32 below.
var a, b float32 = real(c), imag(c)

// d is deduced as a typed value of type complex64.
// The results of real(d) and imag(d) are both
// typed values of type float32.
var d = complex(a, b)

// e is deduced as a typed value of type complex128.
// The results of real(e) and imag(e) are both
// typed values of type float64.
var e = c
```

---

### Code Packages and Package Imports

代码 package 和 package 的导入

通常我们可以看到一个 go 文件里面的代码是这样的(比如 xx.go)

```go
package main

import "fmt"

func main() {
	fmt.Println("Go has", 25, "keywords.")
}
```

- main 入口函数必须要放在名字叫做 main 的 package 中。
- import 关键字之后的`fmt`是一个 standard package，这个 identifier `fmt`在这个代码文件`xx.go`的作用域中也是这个 package 的名字。
- `fmt.Println`: The form `aImportName.AnExportedIdentifier` is called a [qualified identifier](https://golang.org/ref/spec#Qualified_identifiers).(需要科网访问 golang.org)
  - 这个函数 has no requirements for its arguments(?)，反正会自动判断参数的类型，打印在一行，用空格分开。

Please note, only exported resources in a package can be used in the source file which imports the package.翻译一下: 这个文件模块里面的资源能被 import 使用的条件是，这些资源是被 exported 了的。

什么样的变量是可以被 exported 的呢[之前讲 identifier 的时候提到过](#identifiers)，也就是首字母大写的变量名是 exported identifier，也就是说这个变量是 public 属性的。

所以看`fmt.Println`这个函数只要是能被 import 过来用的，必定是首字母大写的函数

All standard packages are listed [here](https://golang.org/pkg/).(科网访问)，以后用到的时候在学

A package import is also called an import declaration formally in Go. An import declaration is only visible to the source file which contains the import declaration. It is not visible to other source files in the same package.在一个 package 中 import 的操作只会在这个 package 中起作用(visible)，这应该都是默认知道的。

例子:

```go
package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {
	rand.Seed(111)
	fmt.Println(time.Now())
	// fmt.Println(time.Date(2010, 11, 1, 23, 12, 12, 12, "8"))
	fmt.Println(rand.Uint32(), rand.NormFloat64(), rand.NormFloat64(), rand.NormFloat64())
    fmt.Printf("printf vvv %v\n", func() int { return 123 }())
	// 这里用了一个匿名函数 看来是可以的 go会自动判断类型给到%v
}
```

来看看这个`fmt.Printf`函数，就是 c 语言的 printf，看看这里的占位符`%v`，v 表示一个 format verb，是不是第二个参数只要是一个函数就行呢？(后面就详细谈一谈)

随机数种子，time 包里面的 Now 原来可以这样用，转换为 unix 时间

```go
rand.Seed(time.Now().UnixNano())
fmt.Println(time.Now().UnixNano())
// 哈哈原来这样用啊 time包的Time类型可以有这样一个成员函数转换为unix时间
// 这个unix时间是以微妙计数的整数int64
```

#### More about `fmt.Printf` format verbs

这个函数的第一个参数中只要有`%v`这样的 format verb，就会被第二个参数转换为字符串，来看看有多少个占位符:(这本书里只讲一点点)

- `%v`: will be replaced with the general string representation of the corresponding argument.

  - 这个是一个 general 的占位符，就是说不管给什么类型都行，如果是 struct，那么会打印{attr1 attr2 ...}，如果加了`%+v`会打印属性名称

  ```go
  // 只有被exported的变量才需要comment
  type tt struct {
  	name string
  	age  int8
  }
  func main() {
  	fmt.Printf("%v\n", tt{"ss", 12})
  }
  // {ss 12}
  // 加了%+v就是 {name:ss age:12}
  ```

- `%T`: 替换为这个变量的类型！

- `%x`: 被替换为 hex 的 string，一般都是 integer，integers array or integer slices

- `%s`: string 或者 byte slice(?) 字节片?

- `%%`: %

- `%t`: 布尔值的 true or false

- ```go
  %b	base 2
  %c	the character represented by the corresponding Unicode code point
  %d	base 10
  %o	base 8
  %O	base 8 with 0o prefix
  %q	a single-quoted character literal safely escaped with Go syntax.
  %x	base 16, with lower-case letters for a-f
  %X	base 16, with upper-case letters for A-F
  %U	Unicode format: U+1234; same as "U+%04X"
  ```

#### Package Folder, Package Import Path and Package Dependencies(需要深入)

For example, package `.../a/b/c/internal/d/e/f` and `.../a/b/c/internal` can only be imported by the packages whose import paths have a `.../a/b/c` prefix.

这段前面说的就是一个文件夹下有好多 package，这些 package 属于这个 folder，balabalabala。。。

In Go SDK 1.11, a **modules feature** was introduced. **A module can be viewed as a collection of packages which have a common root (a package tree).** Each module is associated with an root import path and [a semantic version](https://semver.org/). The major version should be contained in the root import path, execpt the `v0` or `v1` major versions. Modules with different root import paths are viewed as different modules.

If a package is contained within a `GOPATH/src` directory, and the **modules feature is off**, then its import path is the relative path to either the `GOPATH/src` directory or the closest `vendor` folder which containing the package.就是说当 module 特性关闭的时候，也就是一个 package 在 GOPATH/src 中(`export | grep GO`查看 GOPATH)的时候，那么这个包被引入的路径就是 src 路径或者是最近的 vendor 中，这个 vendor 其实是 govendor 包管理工具创建的文件夹，存放模块的，之后应该会学到的。

When the modules feature is on, the root import path of a module is often (but not required to be) specified in a `go.mod` file which is directly contained in the root package folder of the module. We often use the root import path to identify the module. The root import path is the common prefix of all packages in the module.

**Only the `vendor` folder directly under the root path of a module is viewed as a special folder.**才会触发 module 特性，被引用的 package 会在这个 root 下的 vendor 找

之后会谈`main`入口函数，它被称为**program packages** or command packages，其他的 package 就叫做**library packages**每一个 go 程序只能有一个 program package

So please try to make the two names identical for each library package.

这一部分关于 go.mod 的使用方法之后一定会去看的！很重要

#### (补充)[Semantic Versioning](https://semver.org/) 版本命名方法

#### The `init` Functions

初始化方法？？

每一个 package 可以有多个`init`方法，他必须是没有输入和输出的。

注意在 package-level 的地方`init`这个 identifier 只能被用在函数声明，不能用它当做变量等的声明。

在 run time 的时候每一个初始化函数都会被按序激活一次，仅一次，且是在 main 入口函数之前。

虽然还不知道 init 函数的妙用。。感觉目前这本 go101 只是粗略带过。

#### Resource Initialization Order

资源初始化顺序，哦？也许可以印证我上面的猜测。

首先，在运行的时候，一个 package 会在 import 他所有的 dependency package 之后加载。

**所有的`init`方法都会被按顺序调用，全部的`init`会在`main`之前调用，并且会在所有被 import 的包的`init`调用之后调用。**

So it is not a good idea to have dependency relations between two `init` functions in two different source files.

总的来说，都是先初始化 import 进来的 package，再按照顺序(如果特殊情况赋值的话就不按顺序)初始化

#### Full Package Import Forms

完整的 package 引入格式是

```go
import importname "path/to/package"
```

importname 相当于是给 package 其别名

```go
import fmt "fmt"        // <=> import "fmt"
import rand "math/rand" // <=> import "math/rand"	// 其实就是最后的package名字
import time "time"      // <=> import "time"
```

这个别名其实也不怎么常用，有的情况是有两个包有相同的名字，但在不同的路径下需要加以区分

如果这个 importname 是一个点`.`，那么，相当于没有 importname，`from xxx import *`这种感觉，直接使用 package 中的 exported 对象。但是写过 python 也就知道这样不太推荐。

同时也可以是`_`，称为 anonymous imports 或者 blank imports，但是这样之后，在文件中不能使用 anonymous import 的 exported 资源，这样引入`_`的目的只是为了激活这个 package 中的`init`函数

最后要记得，非 anonymous import 必须被使用至少一次，不然 ctrl+s 的时候 golint 直接帮你把这行删了。。。

---

### Expressions, Statements and Simple Statements

Simply speaking, an expression represents a value and a statement represents an operation.

#### 简单的 Expression 的 cases

这本书里谈到的表达式都是 single-value expression，就是这一个表达式返回一个值。

抛出了很多 topic，methods，channel，自定义的 function，之后都会学到。所以 go 里面，函数和方法是不同的两个东西哈。

#### 简单的 Statement Cases

- 变量声明，短的，不完整的那种
- 纯值赋值语句，包括`x op= y`
- 函数/方法的调用，channel 接收的参数
- channel send operations
- nothing (a.k.a., blank statements). We will learn some uses of blank statements in the next article.
- a++, a--

#### 一些不是 simple statement 的情况

- 完整的变量声明
- named 常量声明
- 自定义类型声明
- package 导入声明
- 语句块
- 函数声明
- 控制流和代码执行跳转？？jumps??
- return 的那行
- deferred function calls and goroutine creations. The two will be introduced in the article after next

虽然看到这里觉得讲 expression 和 statement 没什么意义。。也许之后会有意义吧。。。

---

### Basic Contril Flows

基础控制流语法，应该很简单，大致上有:

- if-else
- for
- switch-case
- for-range: loop block for **container** types
- type-switch: multi-way conditional execution block for interface types.这又抛出个 interface 类型。。
- select-case: for channel types

go 支持 break，continue，goto 还有一个特殊的跳出语句**fallthrough**，除了 if-else，都是 breakable control flow blocks

注意每个控制流 block 都是一个 statement，里面可以有其他的 sub-statement

#### if-else

```go
if InitSimpleStatement; Condition {
	// do something
} else if ... {
	// do something
} else {
    // ...
}
```

InitSimpleStatement 这个初始化的简单声明是可选的。实战中通常是一个纯值赋值或者变量声明。如果有初始化声明，那就不能在 Condition 和他外面加`()`，如果加了就把他们看成一个表达式了呗。没有初始声明的话，分号是 optional 的。

#### for (go 没有 while)

```go
for InitSimpleStatement; Condition; PostSimpleStatement {
	// do something
}
```

三个部分都是 optional，这三部分都不能被`()`，同样分号可以省略，那就相同与`while`了。没有`Condition`的时候会被当做是 true

```go
for i := 0; i < 3; i++ {
	fmt.Print(i)
	// The left i is a new declared variable,
	// and the right i is the loop variable.
	i := i
	// The new declared variable is modified, but
	// the old one (the loop variable) is not yet.
	i = 10
	_ = i
}
```

看一下这段，很好的说明了`{}`的作用，在这里面声明的新变量`i`是不会被外面的 for 条件给用到的，出了循环就没了。

#### switch-case

```go
switch InitSimpleStatement; CompareOperand0 {
case CompareOperandList1:
	// do something
case CompareOperandList2:
	// do something
...
case CompareOperandListN:
	// do something
default:
	// do something
}
```

注意这里的 case 对象可以都是 list，就是用逗号分开的变量，和 CompareOperand0 是可比的

Note, if any two case expressions in a `switch-case` control flow can be detected to be equal at compile time, then a compiler may reject the latter one.所谓 reject 就是直接报错，也就是两个 case 中不能出现相同的东西，不然就匹配到两个结果了，事实上目前 go1.13 编译器允许这样。。

**注意，和 c++不同，go 的 switch-case 会自动在 case 后面 break 掉，如果还想继续往下溜，那么就要用到`fallthrough`这个关键字了！**

```go
rand.Seed(time.Now().UnixNano())
switch n := rand.Intn(100) % 5; n {
case 0, 1, 2, 3, 4:
	fmt.Println("n =", n)
	// The "fallthrough" statement makes the
	// execution slip into the next branch.
	fallthrough
case 5, 6, 7, 8:
	// A new declared variable also called "n",
	// it is only visible in the currrent
	// branch code block.
	n := 99
	fmt.Println("n =", n) // 99
	fallthrough
default:
	// This "n" is the switch expression "n".
	fmt.Println("n =", n)
}
```

注意那行变量声明的`n := 99`，这个 n 是在 case 的 implicit block 里面，local 的

fallthrough 必须是 branch 的最后一个 statement，而且不能出现在最后一个 branch 中

如果 CompareOperand0 也被省略的话还是被当做是`ture`

和其他的不同，`default`语句可以在随意的顺序

#### goto

goto 必须跟着一个 LabelName，一个 label 是`LabelName:`，举个例子

```go
func main() {
	i := 0

Next: // here, a label is declared.
	fmt.Println(i)
	i++
	if i < 5 {
		goto Next // execution jumps
	}
}
```

Note that, if a label is declared within the scope of a variable, then the uses of the label can't appear before the declaration of the variable.

#### `break` and `continue` Statements With Labels

```go
package main

import "fmt"

func FindSmallestPrimeLargerThan(n int) int {
Outer:
	for n++; ; n++{
		for i := 2; ; i++ {
			switch {
			case i * i > n:
				break Outer
			case n % i == 0:
				continue Outer
			}
		}
	}
	return n
}

func main() {
	for i := 90; i < 100; i++ {
		n := FindSmallestPrimeLargerThan(i)
		fmt.Print("The smallest prime number larger than ")
		fmt.Println(i, "is", n)
	}
}
```

---

### Goroutines, Deferred Function Calls and Panic/Recover

这，来要来点硬核的东西了！开始吧。

这篇长文将介绍 goroutine **协程**，deferred function 调用。是 go 的两个很 unique 的特性。

同时也会解释 panic 和 recover 机制？

#### Goroutines

回忆一下操作系统，当代计算机的 CPU 都是多核心，支持 hyper-threading，嗯？超线程。所谓超线程是 intel 的 cpu 新特性，不过好像第九代就抛弃了，是通过一个 cpu 内核的 2 个 architecture state 软件方法模拟实现出两个逻辑内核，使得两个超线程可以同时得到 cpu 的资源。

Goroutines 就是 go 语言实现 concurrent(并发)计算的东西。也成为 green threads，绿色线程。不过呢，这个绿色线程由 go 语言运行的时候来调度和维护的，而不是交给 os 去控制。想到了上次看的 b 站视频讲的家庭模式和旅馆模式的区别，简单的比喻来说就是家里人睡的房间要是换个家里人睡，不用彻底大扫除，而旅馆每换一个客人都要彻底的大扫除，而这大扫除的操作就是 os 新建新线程和切换上下文的开销。

如果每个线程都是 os 拉起来的，每个线程的大小都要 2mb 还是 4mb 来着？特别吃内存，还有 nodejs 的 epoll 方法，event stack，这里先不多说了，总之 node 是很牛逼的单线程，非阻塞 IO 和事件驱动的调度能手。

**go 不支持用户用代码新建系统的线程**。所以只有用 goroutines 才能在 go 里面并发编程。

`go` 关键字后跟一个 function call 就是新建一个新线程的操作了。新的 goroutine 会在函数调用之后退出。

go 程序的开始就是一个 goroutine，在程序里面用`go`创建的都算是他的 sub-goroutine，看代码熟悉一下

```go
package main

/*
 * @Author: CoyoteWaltz
 * @Date: 2020-01-14 21:07:56
 * @LastEditors  : CoyoteWaltz
 * @LastEditTime : 2020-01-15 11:21:46
 * @Description: goroutine from go101
 */

import (
	"log"
	"math/rand"
	"time"
)

// 不用大写 不用被exported 不用写顶行注释 舒服
func greeting(greeting string, times int) {
	for i := 0; i < times; i++ {
		log.Println(greeting) // 这里不用fmt的原因 因为 log中的是synchronized
		// fmt.Println(greeting, i) // fmt的会异步 也许会打印在同一行 这个程序几乎不会出现。。
		delay := time.Second * time.Duration(rand.Intn(3)) / 2
		// time.Duration 其实就是在time模块里面自定义的一个类型 即 int64
		time.Sleep(delay)
	}
}

func main() {
	// main goroutine
	rand.Seed(time.Now().UnixNano())
	log.SetFlags(0)
	go greeting("yes", 100)
	go greeting("no", 50)
	time.Sleep(30 * time.Second) // 主线程存活的时间 如果main退出了 其子goroutine都死亡 anyway
}
```

#### Concurrency Synchronization

并发同步

看一些并行(发)计算的 data races 情况:

- 同时，读和写同一个 memory segment。读的数据的 integrity 不能保证。
- 两个计算同时写同一个 memory segment

所以并发编程要控制这种数据冲突，to implement this duty，叫 data synchornization or concurrency synchornization。以及还有需要注意的:

- 决定多少个并发计算
- 决定一个计算什么时候开始、阻塞、开塞、结束
- 决定如何分布荷载

and 如何让 main goroutine 知道子线程都结束了呢。这些在 concurrency synchronization techniques 中会介绍。(how to control concurrent computations)，这里面还有 channel 技术，后面会讲。

这里呢根据上面的程序，我们简单的使用`sync`标准库的`WaitGroup`来实现主 goroutine 和两个新的 goroutine 之间的同步(主进程等待两个结束之后才结束)，

```go
package main

import (
	"log"
	"math/rand"
	"sync"
	"time"
)

var wg sync.WaitGroup // 这是一个类型

// 不用大写 不用被exported 不用写顶行注释 舒服
func greeting(greeting string, times int) {
	...
	wg.Done() // <=> wg.Add(-1)
}

func main() {
	// main goroutine
	rand.Seed(time.Now().UnixNano())
	log.SetFlags(0)
	wg.Add(2) // register two tasks
	go greeting("yes", 10)
	go greeting("no", 10)
	// time.Sleep(30 * time.Second) // 主线程存活的时间 如果main退出了 其子goroutine都死亡 anyway
	wg.Wait() // block until all tasks are finished
	log.Println("main done")
}
```

#### Goroutine States

goroutine 存在两个状态，running 和 blocking。在上面的例子，`wg.Wait()`调用的时候 main goroutine 就进入了阻塞态，直到两个新线程都结束之后才重新进入 running 态。

goroutine 就和 os 的线程一样，走走停停，在两个状态中来回切换。

注意，调用`time.Sleep`函数或者在等待系统函数调用的回应或者网络连接，这些都算是在**运行态**。(在 go101 里是这样的)

只能在 running state 中 exit，每次被 create 起来先进入的是 running。

一个阻塞了的 goroutine 只能在另一个 goroutine 中被重新拉回 running，要是所有的 goroutine 都在阻塞，那么他们就都凉凉。看成是一个全体死锁。如果出现这样的情况，标准 Go runtime 会尝试 crash the program。看个例子:

```go
package main

import (
	"sync"
	"time"
)

var wg sync.WaitGroup

func main() {
	wg.Add(1)
	go func() {
		time.Sleep(time.Second * 2)
		wg.Wait()
	}()
	wg.Wait()
}
```

`fatal error: all goroutines are asleep - deadlock!`报错咯。

#### Goroutine Schedule

被执行的最多的 goroutine 数量不会超过 cpu 提供的所有逻辑上可以使用的内核个数。`runtime.NumCPU`函数调用可以获得可用的 cpu 数量。

go runtime 就好比是 cpu 调度中心，一直在调度 goroutine，让他们每个都有机会被 cpu 执行。

goroutine 在 running 的时候是排队等待被 cpu 执行，此时应该 cpu 数量小于 goroutine 的数量。

标准 Go runtime 采用了 MPG 模型来做 goroutine 的任务调度。**很重要**，复习一下操作系统，单 cpu，单 cpu 多核，多 cpu 单核，进程是啥，线程是啥，协程 coroutine 是什么。

#### MPG Model

接着说 MPG，M 指的是 Machine，是一个 os 的线程，P 指的是 logical processor 也就是处理器核，逻辑或者虚拟的(因特尔的超线程)，G 就是 goroutine 了。调度工作也就是将 G 添加到一个 M 的工作队列。一个 os 线程在给时间片处理(os 分配的)的时候最多被 attached 一个 goroutine，同时一个 goroutine 在有时间片(go 调度器分配的)的时候最多也只能 attached 到一个 os 线程上。所以呢只有当 goroutine 在 os 线程上才可以被执行，到了时间片结束或者有其他的情况(io, channel, wait, runtime.Gosched())，goroutine 会自己让出线程的控制权，让线程去执行其他的 goroutine。想象一下这张图，os 控制的线程**P**下有好多个 goroutine，当一个 P 关联多个 G 的时候，此时就是并发，同一个时间段要处理多个 G，通过 MPG 模型来实现百万协程的并发。

我的理解就是，go 的调度器相当于是把一个线程当做了一个 cpu，充当 os 的角色让协程 goroutine 成为了线程，进行调度，实现了多级调度？

调用`runtime.GOMAXPROCS`来获得和设置 logical processors 的数量，自从 go1.5 以后，这个默认值就是系统可用逻辑处理器的数量了。

```go
package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Println(runtime.NumCPU())       // 8 可用的cpu核心数
	fmt.Println(runtime.GOMAXPROCS(5))  // 设置新的P的数量 但是返回的还是之前的 8
	fmt.Println(runtime.GOMAXPROCS(-1)) // 传入的参数小于1 就不设置 返回previous 5
    // 后者才是关键的P
}

```

At any time, the number of goroutines in the executing sub-state is no more than the smaller one of `runtime.NumCPU` and `runtime.GOMAXPROCS`.总之**被执行的**goroutine 的数量的上界是这两者小的。

#### Deferred Function Calls

defer 这个单词，好吧忘了，是延迟拖延的意思。

这个延迟函数调用的用法是在函数调用之前加一个`defer`关键字。

Like goroutine function calls, all the result values of the function call (if the called function returns values) must be discarded in the function call statement.这句话我没搞明白啊啥叫 discard 呢？实验了一下就是 go func calls 之后的返回值就无效了，也不能加`vv := go ..`这种。

被冠以 defer 之名的函数调用不会立即执行，而是被压入一个 defer-call 栈中，由调用他的 goroutine 所维护，当这个函数(goroutine 在执行)return 并进入 exiting phase 的时候，所有被压入栈的 deferred function 才被执行，出栈执行，也就是逆序执行了，所有的这些被执行完才是这个 goroutine 所在的 function 真正 exit。

```go
package main

import "fmt"

func main() {

	defer fmt.Println(1) //不出意外的话他是最后执行的
	defer fmt.Println(2)
	fmt.Println(3)
} // 3 2 1
```

**实际上每个 goroutine 都维护两个 stack，一个是 normal-call stack 一个就是 defer-call stack**

- For two adjacent function calls **in the normal-call stack** of a goroutine, the later pushed one is called by the earlier pushed one. The earliest function call in the normal-call stack is the entry call of the goroutine.
- The function calls in the defer-call stack have no calling relations.

解释一下第一条这个 normal-call 栈是啥，就是在 goroutine 执行时候顺序扫描代码，一个 func 被扫描，就压入 nromal-call 栈，然后进入 func 继续扫描到一个其他的函数调用就再压入栈，那么前一个就是后一个的 caller，然后递归进入函数扫描，不断入栈，就形成了在 stack 中相邻的两个函数有这样被调用的关系，那么栈底的那个函数就是 entry call 了。_就是函数调用栈啦_

而 defer-call stack 的所有函数的 caller 都是这个 goroutine。

别搞了，用 debug.PrintStack()来看看 normal-call stack 吧

```go
package main

/*
 * @Author: CoyoteWaltz
 * @Date: 2020-01-15 22:30:10
 * @LastEditors  : CoyoteWaltz
 * @LastEditTime : 2020-01-15 22:35:01
 * @Description:
 */

import (
	"fmt"
	"runtime/debug"
)

func test1() {
	test2()
}
func test2() {
	test3()
}
func test3() {
	fmt.Println(333)
	debug.PrintStack()
}

func main() {
	test1()
	test2()
	debug.PrintStack()

}
/*
333
goroutine 1 [running]:
runtime/debug.Stack(0x4, 0x0, 0x0)
        /usr/local/go/src/runtime/debug/stack.go:24 +0x9d
runtime/debug.PrintStack()
        /usr/local/go/src/runtime/debug/stack.go:16 +0x22
main.test3()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:24 +0x7a
main.test2(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:20
main.test1(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:17
main.main()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:28 +0x22
-------------分割线 上面是test1执行最后栈的情况
333
goroutine 1 [running]:
runtime/debug.Stack(0x4, 0x0, 0x0)
        /usr/local/go/src/runtime/debug/stack.go:24 +0x9d
runtime/debug.PrintStack()
        /usr/local/go/src/runtime/debug/stack.go:16 +0x22
main.test3()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:24 +0x7a
main.test2(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:20
main.main()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:30 +0x28
(base) coyotewaltz@coyote-ubuntu:~/Programming/go/w5$ go run call_stack.go
-------------分割线
333
goroutine 1 [running]:
runtime/debug.Stack(0x4, 0x0, 0x0)
        /usr/local/go/src/runtime/debug/stack.go:24 +0x9d
runtime/debug.PrintStack()
        /usr/local/go/src/runtime/debug/stack.go:16 +0x22
main.test3()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:24 +0x7a
main.test2(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:20
main.test1(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:17
main.main()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:28 +0x22
333
goroutine 1 [running]:
runtime/debug.Stack(0x4, 0x0, 0x0)
        /usr/local/go/src/runtime/debug/stack.go:24 +0x9d
runtime/debug.PrintStack()
        /usr/local/go/src/runtime/debug/stack.go:16 +0x22
main.test3()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:24 +0x7a
main.test2(...)
        /home/coyotewaltz/Programming/go/w5/call_stack.go:20
main.main()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:30 +0x28
goroutine 1 [running]:
runtime/debug.Stack(0x1, 0x1, 0x4)
        /usr/local/go/src/runtime/debug/stack.go:24 +0x9d
runtime/debug.PrintStack()
        /usr/local/go/src/runtime/debug/stack.go:16 +0x22
main.main()
        /home/coyotewaltz/Programming/go/w5/call_stack.go:31 +0x2d
*/
```

可以看出 normal-call stack 实际上记录的是函数调用嵌套的顺序，最先入栈的总是 main，然后每执行一个 call 就记录一下里面的调用情况，通过出栈来 return 到上一层。

#### Deferred Function Calls Can Modify the Named Return Results of Nesting Functions

注意是 nesting function 的 named return，翻译一下就是在 main 外写的 func 的签名中的有名字的 return

```go
package main

import "fmt"

func triple(n int) (r int) {
	defer func() {
		r += n
	}() // 将这个匿名函数的执行defer到最后

	return n + n // 等价于 r = n + n 然后再return
}

func main() {
	r := triple(10)
	fmt.Println(r)
}
```

返回的 r 还是会在 deferred function 被改变

#### The Necessary and Benefits of the Deferred Function Feature

来看看 deferred function 的必要性和好处。说实话大部分被 defer 的 function 都可以不用这样做，但是！

对于接下来要遇到的 panic 和 recover 机制是非常必要的特性。

#### The Evaluation Moment of the Arguments of Deferred and Goroutine Function Calls

**延迟函数或者 goroutine function 的参数 evaluation 在其被调用(invoked)的时候。**

- invocation moment 调用时间??是被压入 defer-call stack 的时候，就是压入栈的时候就算是调用这个动作了？
- For a goroutine function call, the invocation moment is the moment when the corresponding goroutine is created.

The expressions **enclosed** within the body of an anonymous function call, whether the call is a general call or a deferred/goroutine call, will not be evaluated at the moment _when_ the anonymous function call is invoked.就是匿名函数的参数评估(我觉得这里应该)是 until 函数被调用。

```go
package main

import "fmt"

func main() {
	func() {
		for i := 0; i < 3; i++ {
			defer fmt.Println("a:", i)
		}
	}()
	fmt.Println()
	func() {
		for i := 0; i < 3; i++ {
			defer func() {
				fmt.Println("b:", i) // 这里和上面的区别是吧print放在了一个匿名函数里面，
				// 内匿名函数在外面的匿名函数中被调用，但是是defer的，压入栈了，出栈的时候i已经都是3了
			}()
		}
	}()
	fmt.Println()
	func() {
		for i := 0; i < 3; i++ {
			defer func(i int) {
				fmt.Println("b2:", i)
			}(i)
		}
	}()
	fmt.Println()
	func() {
		for i := 0; i < 3; i++ {
			i := i // 里面的i用外面的i来赋值
			defer func() {
				fmt.Println("b3:", i)
			}()
		}
	}()
}

```

上面的是 defer function 的参数估值时机，第一个 b 会打印 3 个 3，因为出栈的时候考察 i，已经都是 3 了。

下面看一下 goroutine function 的参数评估时机。

```go
package main

import "fmt"
import "time"

func main() {
	var a = 123
	go func(x int) {
		time.Sleep(time.Second)
		fmt.Println(x, a) // 123 789
	}(a)

	a = 789

	time.Sleep(2 * time.Second) // 用sleep来同步协程不太好的
}
```

会打印 123,789 呢，就是说在`go`开启新协程的时候将 a=123 送入了这个 func，但是在执行里面的语句的时候，a 是直到`fmt.Println`调用的时候才 evaluated(上面的一段说的)，所以 a 是父协程的资源，执行到 a=789 了。

#### Panic and Recover

前面说过了嗷，defer 存在的意义就是为了 panic 和 recover 服务

go 没有异常抛出和捕获！error handling 是 go 里面用的。和 throw/catch 机制很像的就是这个 panic/recover

调用 `panic` 函数创建一个慌张。。。。可以让当前的 goroutine 进入 panicking status，当然这个 panic 只能在当前协程中存在。

panicking 是另一种让函数 return 的方法。在一个函数调用中产生了一个 panic 会让函数立刻返回并进入 exiting phase，然后 defer-call stack 就会执行咯。

在 deferred call 中调用`recover`函数，就可以将前面生出来的活着的 panic 给去掉！然后当前的 goroutine 就会重新进入 calm 的状态。。。go 的单词用的真是活灵活现。

如果一个慌张的 goroutine 没有 recover 就退出，那么整个 program 就 carsh 了。

```go
func panic(v interface{}) // 接收一个interface
func recover() interface{} // 返回一个interface
```

interface 类型之后会介绍

Here, we just need to know that the blank interface type `interface{}` can be viewed as the `any` type or the `Object` type in many other languages. In other words, we can pass a value of any type to a `panic` function call.

就是说 recover 的返回值会喂给 panic，吃饱了就不 panic 了。

遇到错误就会产生 panic，程序就慌了，一慌就不执行了，就想回家 return，但是回去的时候还要把延迟的工作完成，如果延迟的工作里面能解决 recover，就不慌了。

看一下产生 panic 的一个情况 0 做除数，更多 panic 后面..大多数都是逻辑错误

```go
package main

import "fmt"

func main() {

	defer func() {
		rv := recover()
		fmt.Println("recover: ", rv)
	}()
	a, b := 1, 0
	_ = a / b // 这里慌了 return
	fmt.Println("done")
}
```

#### Some Fatal Errors Are Not Panics and They Are Unrecoverable

For the standard Go compiler, some fatal errors, such as stack overflow and out of memory are not recoverable. Once they occur, program will crash.

---

## Go type system

下一大章节！go 的系统，上面的 go 大体代码都看的懂了。

### Go Type System Overview

介绍所有的类型和概念。

#### Concept: Basic Types

稍微回顾一下所有的内置类型，自行脑补吧。反正 byte alias of uint8，rune alias of int32

#### Concept: Composite Types

组合类型？就是其内部是基础类型的组合。一会按着顺序讲

- pointer types 和 C 的指针很像
- struct types 和 C 的结构体很像
- function types 函数是 Go 的第一阶级的类型哦
- container:
  - array 定长
  - slice 动态长度和动态容量
  - map 和字典差不多吧 哈希的
- channel types 用来在 goroutine 之间同步数据的
- interface types 是 reflection 和 polymorphism(多态)的关键？？？

其他未定义的组合类型就是把组合类型和基础类型搞在一起，看一些例子

```go
// Assume T is an arbitrary type and Tkey is
// a type supporting comparison (== and !=).

*T         // a pointer type
[5]T       // an array type
[]T        // a slice type
map[Tkey]T // a map type key的类型是Tkey value的类型是T

// a struct type
struct {
	name string
	age  int
}

// a function type
func(int) (bool, string)

// an interface type
interface {
	Method0(string) int
	Method1() (int, bool)
}

// some channel types
chan T
chan<- T
<-chan T
```

#### Fact: Kinds of Types

讲一个 fact？上面讲的类型都是 go 的 26 个类型的一个。还有一个 unsafe 指针，看 go 的标准库吧。

#### Syntax: Type Definitions

定义类型的语法，用`types`关键字

```go
type newType sourceType
```

多个定义可以用括号放一起。

But please note that, type names declared at package level can't be `init`. (This is the same for the following introduced type alias names.)就是在 package 级的类型定义不能被初始化。

说是有两种方式，先看第一种

```go
type (
	mstr string
	age  uint8
)
type intPtr *int
type book struct {
	author, title string
	pages         int
}

// 将这样的函数类型重命名为convertor
type convertor func(in0 int, in1 bool) (out0 int, out1 string)
```

注意事项:

- 新定义的类型和对应的源类型是两个不同的类型
- 新类型和源类型的 underlying 类型是一样的，两个类型的值可以互相转换
- 在函数体内可以定义类型

#### Syntax: Type Alias Declarations

从 go1.9 之后的新的 type alias declaration

上面也说到了 byte 类型和 uint8 就是 alias 关系，and rune 和 int32。。。

用`=`来建立 alias

```go
type (
	Name = string
	Age  = int
)

type table = map[string]int
type Table = map[Name]Age  // 注意哦这个alias是可以被exported的因为identifier是大写
```

怎么想到了 cpp 里面也是两种，一种 c 的 `typedef`，一种 cpp 的 `using xxx = int;` 区别还是有的（忘了）

这种 alias 的区别，就是它是 alias 了一个新名字，而不是建立了一个新类型。记住了哦！

#### Concept: Defined Types vs. Non-Defined Types

```go
type A []string  // A是defined的了
type B = A
type C = []string  // 都是non-defined []string是non-defined 然后C是他的alias
```

#### Concept: Named Types vs. Unnamed Types

就是在 go1.9 以前才有的 named type 和 unnamed type，之后呢就有了 alias，会造成混乱。go101 给出了以下规则:

- An alias will never be called as a type, though we may say it denotes/represents a type.
- The terminology **named type** is viewed as an exact equivalence of **defined type**. (And **unnamed type** exactly means **non-defined type**.) In other words, when it says "a type alias `T` is a named type", it actually means the type represented by the alias `T` is a named type. If `T` represents an unnamed type, we should never say `T` is a named type, even if the alias `T` itself has a name.就是在 alias 的时候，alias 要看源类型是否是 named
- When we mention a type name, it might be the name of a defined type or the name of a type alias.

#### Concept: Underlying Types

躺在下面的类型，每个类型都有一个 underlying type

- 内置类型的 underlying 就是自己
- for the `Pointer` type defined in the `unsafe` standard code package, its underlying type is itself. (At least we can think so. In fact, the underlying type of the `unsafe.Pointer` type is not well documented. We can also think the underlying type is `*T`, where `T` represents an arbitrary type.)
- the underlying type of a non-defined type, which must be a composite type, is itself.
- 新定义的类型和源类型 share 一样的 underlying type

In Go,

- types whose underlying types are `bool` are called **boolean types**;
- types whose underlying types are any of the built-in integer types are called **integer types**;
- types whose underlying types are either `float32` or `float64` are called **floating-point types**;
- types whose underlying types are either `complex64` or `complex128` are called **complex types**;
- integer, floating-point and complex types are also called **numeric types**;
- types whose underlying types are `string` are called **string types**.

这个躺在下面的类型对于值转换，赋值和比较是很重要的。

#### Concept: Values

value 的概念是一个 type 的 instance，每个类型都有一个零值，可以看成是一个类型的默认值。之前声明的`nil` identifier 可以用来表示 slice，map，function，channel，pointer(含 unsafe)，interface。nil 之后还要看看。

讲一讲剩下的两个 literals，literal 就是表示值的一个方法

Function literals，函数 literal 就是来表示函数的 value 的。

Composite literals 用来表示结构体类型和容器类型的。

pointer，channel，interface 是没有 literals 的。

有点潦草，毕竟是概述，literal 还是有点晕乎。

#### Concept: Value Parts

值的 part，总所周知 value 都是存在内存里面的，所谓的 part 就是在内存中连续的 segment，有些值是有不同的 parts 叫做 indirect 的 parts，好比 cpp 的链表，通过在 direct 的地方(就是直接地址)用 pointer 来 reference 到。这也是 go101 中说法，go 官方没这么说。

#### Concept: Value Sizes

值存在内存中的字节数。可以用 `Sizeof` 函数来查看

Go 官方也并没有说**非数值**类型的大小

#### Concept: Base Type of a Pointer Type

#### Concept: Fields of a Struct Type

结构体中的每个成员叫做 field of the struct type

#### Concept: Signature of Function Types

函数签名，是函数类型的输入和输出 list

**函数名和 body 不是函数签名的部分**

#### Concept: Method and Method Set of a Type

方法，更好的解释是成员函数。

#### Concept: Dynamic Type and Dynamic Value of an Interface Value

Each interface value can box a non-interface value in it. The value boxed in an interface value is called the dynamic value of the interface value.

The type of the dynamic value is called the dynamic type of the interface value.

An interface value boxing nothing is a zero interface value.

A zero interface value has neither a dynamic value nor a dynamic type.

晕了，后面详细学一下，就是鸭式辩型吧

An interface type can specify zero or several methods, which form the method set of the interface type.

interface 类型的成员函数(method)

If the method set of a type, which is either an interface type or a non-interface type, is the super set of the method set of an interface type, we say the type implements the interface type.TODO 不懂。。

具体还是要搞明白 interface 是啥

#### Concept: Concrete Value and Concrete Type of a Value

具体值和具体类型，非 interface 类型的，就是其本身

A zero interface value has neither concrete type nor concrete value. For a non-zero interface value, its concrete value is its dynamic value and its concrete type is its dynamic type.

#### Concept: Container Types

容器，都有 length

#### Concept: Key Type of a Map Type

`map[Tkey]T`

#### Concept: Element Type of a Container Type

容器的元素类型都是一样的！

`[N]T`，`map[Tkey]T`，`chan T`or`chan<-T`or`<-chan T`他们的类型都是 T

#### Concept: Directions of Channel Types

Channel values can be viewed as synchronized first-in-first-out (FIFO) queues. Channel types and values have directions.通道是同步用的 FIFO 队列，有方向，所以有箭头这玩意。。

- 双向 channel，可接收和送，`chan T`作为 literal 表示
- send-only channel，`chan<- T`
- receive-only channel，`<-chan T`

#### Fact: Types Which Support or Don't Support Comparisons

那些是不能比较的

- slice types
- map types
- function types
- any struct type **with a field whose type is incomparable and any array type which element type is incomparable**

#### Fact: Object-Oriented Programming in Go

Go is not a full-featured object-oriented programming language, but Go really supports some object-oriented programming styles.

#### Fact: Generics in Go

泛型编程还是仅限内置类型，自定义的还不行，还在 go 的 draft phase 阶段(go1.13 now)

---

### Pointers in Go

go 虽然吸收了很多其他语言的特性，但是大部分还是被视为是 C 家族的语言。也有指针，用法大多相似，也有不同。这篇详谈。

#### Memory Addresses

内存地址其实就是一个 offset from the 内存始地址。内存地址被存为一个无符号 native(integer)，4 字节 on 32-bit architectures，8 字节在 64 位上。所以最大内存是 2 的 32 次字节，4gb，和 2 的 34 次方 GB 在 64 位。

通常都是用 hex integer，十六进制表示

#### Value Addresses

The address of a value means the start address of the memory segment occupied by the **direct part** of the value.直接 value 地址

#### What are Pointers in Go

相同的不赘述了，不同的是为了安全考虑，有一些限制。。后面会介绍。。。

#### Go Pointer Types and Values

一个 non-defined 指针可以用`*T`表示，`T`是任意类型。

We can declare defined pointer types, but generally, **it’s not recommended to use defined pointer types, for non-defined pointer types have better readabilities.** 问题是哪里有 defined pointer，好像还没遇到过。

underlying type 是`*T`，还有一个 base type 定义为`T`

如果有两个 non-defined 指针类型有一样的 base type，那么他们就是一个 type 的。注意这个 T 也可以是`*T1`

```go
*int  // A non-defined pointer type whose base type is int.
**int // A non-defined pointer type whose base type is *int.

// Ptr is a defined pointer type whose base type is int.
type Ptr *int   // 出现了! defined ptr
// PP is a defined pointer type whose base type is Ptr.
type PP *Ptr
```

指针类型的 0 值是 predeclared `nil`，也就是没有存地址的指针，cpp11 的`nullptr`

base type 是 T，则只能存 T 类型的值的地址

#### About "Reference"

In Go 101, the word "reference" indicates a relation.一个指针存了另一个值的地址，那么这个指针就可以说是(directly) references 另一个值。当然了，一个另一个值有至少一个 reference。

当然也可以说是指向(points)那个值

#### how to get a pointer value and what are addressable values?

如何定义一个 ptr 呢，以及什么值是有地址的(addressable)

有两种方法获得一个 non-nil pointer

1. 也有一个`new`，但他是个 function 来为一个类型的值分配空间，返回的是一个指针`*T`，地址所指向的值是 0 值。

2. 同样也可以用取地址符号`&`

所谓的 addressable 就是在内存中有房间的值，变量。constant，function calls 和 **explicit conversion result** 都是 unaddressable 的

When a variable is declared, Go runtime will allocate a piece of memory for the variable. The starting address of that piece of memory is the address of the variable. 这句话好好品一品，变量所需要的地址是一片 memory，这一片的起始地址才是他的地址。

#### Pointer dereference

和 C 用法一样。`*p` dereference，是取地址的反操作。

Dereferencing a nil pointer 会造成程序的慌乱哦

#### Why do we need pointers?

#### Return Pointers of Local Variables Is Safe in Go

写 cpp 的时候返回值是一个指针，且这个指针是在函数体内被 new 出来的，那么在用完它之后必须要 delete 释放空间。

但是在 go 里面，有 garbage recycle，所以很 safe 的可以 return pointer

#### Restrictions on Pointers in Go

go 为了安全所做的限制

- 不能++或者算术运算 like `p++`,`p-2`，如果 p 指向的是数值类型，那么编译器会把`*p++`合法看成`(*p)++`，就是说`&`和`*`的优先级高于++,--

- 一个 ptr 不能被转换成任意类型的 ptr，就不能像 cpp 一样`(double*)p`or`(void*)p`，除非满足一下两个情况的任意一个:

  1. 两个指针类型的 underlying type 是一样的(identical!)不考虑结构体，尤其是在两个指针类型都是 non-defined 的时候他们的 underlying type 是一样的(考虑结构体的 tag 后面会讲)，那么可以隐式转换。
  2. Type `T1` and `T2` are both non-defined pointer types and the **underlying types of their base types are identical** (ignoring struct tags).

  ```go
  type myInt int64
  type Ta *int64
  type Tb *myInt
  ptrMy := new(myInt)
  var ptrA Ta
  var ptrB Tb
  ptrB = (*myInt)((*int64)(ptrA)) // Ta 到 Tb要经过中间商*int64
  ptrA = (*int64)(ptrMy)
  ```

- 一个指针不能和其他任意类型的指针比较，除非:

  1. 是相同的类型
  2. 可以发生转换，换句话说就是他们的 underlying 类型是必须一样的而且他们之中**至少一个是 undefined type**
  3. 只有一个是`nil`，也就是判断是否是空指针的时候

- 不能赋值不同类型的指针变量，但可以赋值可比较的指针

#### It's Possible to Break the Go Pointer Restrictions

As the start of this article has mentioned, the mechanisms (specifically, the `unsafe.Pointer` type) provided by the `unsafe` standard package(到了 unsafe 的那篇文章会讲) can be used to break the restrictions made for pointers in Go. The `unsafe.Pointer` type is like the `void*` in C. In general the unsafe ways are not recommended to use.

---

### Struct

#### Struct Types and Struct Type Literals

首先要知道怎么声明

non-defined struct 如下

```go
struct {
	title  string
	author string
	pages  int // 这都叫做field 其他的文章也说成是member
	// title, author string 当然也可以这样啦
}
```

struct 类型的 size 就是所有的 field 类型的 size 之和加上一些 padding 字节，这还是很有意思的，应该就是为了补足到 2 的多少次方大小。之后会将 memory

没有 field 的 struct 的 size 为 0

还可以给每个 field 绑定一个 tag！是 optional 的，来看看

```go
struct {
	Title  string `json:"title"`
	Author string `json:"author,omitempty" myfmt:"Author"`
	Pages  int    `json:"pages,omitempty"`  // omit empty ?
}
```

Generally, the tag of a struct field should be a collection of key-value pairs. Tag 应该是一个键值对，然后值是 string，我们可以用 reflection 方法检查 field 的 tag 信息，之后学。。。

tag 存在的作用和所需要的应用场景有关。上面那个例子，tag 可以帮助`encoding/json`标准库的函数去检查 json， The functions in the `encoding/json` standard package will only encode and decode the exported struct fields, which is why the first letters of the field names in the above example are all upper cased.

将 tag 当做是 comment，可不太聪明

Raw string literals (`...`) are used more popular than interpreted string literals (`"..."`) for field tags in practice.

Go 的 struct 不支持 unions，回顾一下 c，unions 就是一个成员的类型可以有好多个，但他的出现只会用到其中的一个类型，内存共享，大概就是这个意思。

```c
union var {
    char c[4];
    int i;
} // 比struct好，struct不管用不用，全分配内存
// union分配的内存大小是两个类型size的最小公倍数
// 共用互斥。
```

上面的 struct 都是 non-defined 和匿名的，用的时候还是要 type 一下。

Only exported fields of struct types shown up in a package can be used in other packages by importing the package. We can view non-exported struct fields as private/protected member variables.就是说想要被 exported 就一定要大写首字母，小写的就可以看成是私有成员(oop 思想)

field 写的顺序是要紧的，两个 non-defined 结构体他们的 field 声明顺序是一样的才是一样的。Two field declarations are identical only if their respective names, their respective types and their respective tags are all identical.

注意，不同 package 中的两个 non-exported 结构体 field 名字被视作不一样的两个名字。

**A struct type can't have a field of the struct type itself, neither directly nor recursively.**

#### Struct Value Literals and Struct Value Manipulations

结构体变量用 `T{...}` 去初始化，T 必须是一个结构体，叫做 composite literal(说中文就是这个 T 是一个合成的表示形式)

```go
st := struct {
    age  uint8
    name string
}{12, "hh"} // 直接给值必须是按顺序给的
```

让这个 struct 是 0 值就不给值直接`{}`(最常用)

可以用键值对的形式

```go
type noval struct {
	title  string `json: "title, omitempty"`
	author string `json: "author"`
}
n1 := noval{title: "ss"}
n2 := noval{} // 确实的键值对就会直接赋0值
```

如果一个结构体是外面的 package 导入的，最好就是用键值对，因为如果在外面的 package 中被增加一个 field 的话，那么可以避免不兼容。

和 c 差不多，用`.`去 select field，叫做选择器表达式！

如果写 non-defined 结构体，注意最后的 coma。。。

```go
var _ = Book {
	author: "Tapir",
	pages: 256,
	title: "Go 101", // here, the "," must be present
}

// The last "," in the following line is optional.
var _ = Book{author: "Tapir", pages: 256, title: "Go 101",}
```

#### About Struct Value Assignments

结构体之间的赋值，就是每个 field 赋值，注意指针也是直接赋值的。。

#### Struct Field Addressability

这个还是很有意思的吧，看看首地址到底指的是谁！

结构体的 field 的 addressability 和 struct 保持一致。

unaddressable 的结构体 field 不能被改变

All composite literals, including struct composite literals are unaddressable.看个例子吧。组合的名字就没地址了

```go
package main

import "fmt"

func main() {
	type Book struct {
		Pages int
	}
	var book = Book{} // book is addressable
	p := &book.Pages  // selector的优先级是大于取地址的
	*p = 123
	fmt.Println(book) // {123}

	// The following two lines fail to compile, for
	// Book{} is unaddressable, so is Book{}.Pages.
	/*
	Book{}.Pages = 123
	p = &(Book{}.Pages) // <=> p = &(Book{}.Pages)
	*/
}
```

#### Composite Literals Are Unaddressable But Can Take Addresses

Go 有一个语法糖。。可以取 composite literals 的地址

A syntactic sugar is an exception in syntax to make programming convenient. 所谓语法糖，就是带来便利的，小糖果哦......

```go
// noval{}.author = "ss" // 相当于是一个临时变量
p := &noval{} // 相当于先有个tmp := noval{} 然后在p := &tmp
p.author = "ssss"
// p1 := &noval{}.ptr // 不行
fmt.Println(*p)
```

#### In Selectors, Struct Pointers Can Be Used as Struct Values

还好，是这样，不然上面的例子就错了，go 的指针没有`->`这个，因为被 channel 用掉了，所以还是用`.`去访问成员

#### About Struct Value Comparisons

Most struct types are comparable types, except the ones who have fields of incomparable types. 这句话看似真是废话。。。

比较相同的时候是每个 field 都相同才相同

#### About Struct Value Conversions

#### Anonymous Struct Types Can Be Used in Field Declarations

就是一个 struct 的 field 也可以是 struct

```go
var aBook = struct {
	// The type of the author field is
	// an anonymous struct type.
	author struct {
		firstName, lastName string
		gender              bool
	}
	title string
	pages int
}{ // 这里都是初始化 只能这样来
	author: struct { // an anonymous struct type
		firstName, lastName string
		gender              bool
	}{
		firstName: "Mark",
		lastName: "Twain",
	},
	title: "The Million Pound Note",
	pages: 96,
}
```

#### More About Struct Types

还有两篇拓展，type embedding 和 memory layouts

---

### Value Parts

为了之后的一些类型能更好的理解，我们先学一下这个值 part 的部分，因为后面涉及到不连续内存的问题了。

#### Two Categories of Go Types

类 C 语言，之前的两个类型的内存结构和 c 差不多

但是咧，go 语言的几个类型的内存结构并不是完全透明的，c 是。 Each C value in memory occupies (TODO)[one memory block](http://localhost:55555/article/memory-block.html) (one continuous memory segment). However, a value of some kinds of Go types may often be hosted on more than one memory blocks.

一个不止拥有一个内存 block 的值(value part)由一个 direct part 统一组成，并且其他的(underlying parts)parts are referenced by that 直接 value part

所以这个标题就想介绍有两种存的方式，一个是只 hosted on 一个内存 block 的，还有一种是有 multiple memory blocks 的。

| Types whose values each is only hosted on one single memory block | Types whose values each may be hosted on multiple memory blocks |
| :---------------------------------------------------------------: | :-------------------------------------------------------------: |
|                      solo direct value part                       |                 direct part --> underlying part                 |
|     boolean, numeric, pointer, unsafe pointer, struct, array      |        slice, map, channel, function, interface, string         |

注意:

- interface 和 string 是否有 underlying parts 取决于编译器，标准 go compiler 下，他们都可以有
- function 值是否有 underlying parts 很难去证实，在 go101 中认为是有的

第二种类型给 go 编程带来便利因为封装了很多细节，不同的 go 编译器对他们的实现方式不一样。

同时他们也不是很基础的类型，我们甚至可以自己造轮子。。enjoyable and productive

#### Two Kinds of Pointer Types in Go

前面讲的 pointer 都是 type-safe 的，也有 type-unsafe pointer 类型，在`unsafe`标准库中，`unsafe.Pointer`像 c 的`void*`

Below, we call a struct type with fields of pointer types as a **pointer wrapper type**, and call a type whose values may contains (either directly or indirectly) pointers a **pointer holder type**.

#### (Possible) Internal Definitions of the Types in the Second Category

就是内部实现的时候定义了好多好多的(中间)类型。TODO 全部学完类型了可以回过头看看。

#### Underlying Value Parts Are Not Copied in Value Assignments

浅拷贝？

Now we have learned that the internal definitions of the types in the second category are pointer holder (pointer or pointer wrapper) types. Knowing this is very helpful to understand value copy behaviors in Go.

所有的 go 的赋值过程都是浅拷贝！

只有 direct part of source value 才被 copy，所以强调了 pointer holder

In fact, the above descriptions are not 100% correct in theory, for strings and interfaces. The [official Go FAQ](https://golang.org/doc/faq#pass_by_value) says the underlying dynamic value part of an interface value should be copied as well when the interface value is copied. However, as the dynamic value of an interface value is read only, the standard Go compiler/runtime doesn't copy the underlying dynamic value parts in copying interface values. This can be viewed as a compiler optimization. The same situation is for string values and the same optimization (made by the standard Go compiler/runtime) is made for copying string values. So, for the standard Go compiler/runtime, the descriptions in the last section are 100% correct, for values of any type.

上面这段话就是说像 interface(尚未习得)和 string 的只读和不变的数据在拷贝的时候确实不用深拷贝，浅拷贝就够了，是一种编译器优化，但是如果当 string 要改变的时候再深 copy 出来，改变。想到了之前学 cpp 的 oop 的 string 类的实现，go 其实也是这个道理。

由于躺在下面的 part 不能成为值的专属，那么`unsafe.Sizeof`这个函数其实是不能记录的。一个 string 的 size 一直都是 16

---

### Arrays, Slices and Maps

> first-class citizen containers
>
> 概览讲了啥？都是 key & value 形式存储和访问
>
> array 和 slice 有啥区别
>
> - memory layout?
> - array: only direct part
> - slice & map: underlying part
>
> 容器元素的访问速度，map 与其他两种容器的优势
>
> - key 和 value 都可以是任意的 comparable type
> - 稀疏空间，map 占用的内存肯定更少
>
> underlying part 浅拷贝

#### 字面表示

```go
// array types: [N]T
// slice types: []T
// map types: map[K]T
```

- N 必须是非负数的 constant int

用 `T{...}` 去初始化

#### 嵌套组合表达

```go
// A slice value of a type whose element type is
// *[4]byte. The element type is a pointer type
// whose base type is [4]byte. The base type is
// an array type whose element type is "byte".
var heads = []*[4]byte{
	&[4]byte{'P', 'N', 'G', ' '},
	&[4]byte{'G', 'I', 'F', ' '},
	&[4]byte{'J', 'P', 'E', 'G'},
}
// 化简
var heads = []*[4]byte{
	{'P', 'N', 'G', ' '},
	{'G', 'I', 'F', ' '},
	{'J', 'P', 'E', 'G'},
}
type LangCategory struct {
	dynamic bool
	strong  bool
}

// A value of map type whose key type is
// a struct type and whose element type
// is another map type "map[string]int".
var _ = map[LangCategory]map[string]int{
	LangCategory{true, true}: map[string]int{
		"Python": 1991,
		"Erlang": 1986,
	},
	LangCategory{true, false}: map[string]int{
		"JavaScript": 1995,
	},
	LangCategory{false, true}: map[string]int{
		"Go":   2009,
		"Rust": 2010,
	},
	LangCategory{false, false}: map[string]int{
		"C": 1972,
	},
}
// 化简
var _ = map[LangCategory]map[string]int{
	{true, true}: {
		"Python": 1991,
		"Erlang": 1986,
	},
	{true, false}: {
		"JavaScript": 1995,
	},
	{false, true}: {
		"Go":   2009,
		"Rust": 2010,
	},
	{false, false}: {
		"C": 1972,
	},
}
```

#### 可比较的容器（`==`）

array 居然是可以 compare 的，map 和 slice 只能和 `nil` 比较是否是**空或者零值**的容器

数组的比较是逐元素，只能比较是否相等

```go
ee := [2]byte{12, 33} // byte alias uint8
ff := [2]byte{12, 33}
println(ee == ff) // true
```

#### 容器 length & capacity

使用内置的函数 `len` 和 `cap` 来获取，对于 array 来说两个值是一样的，但是 slice 有的时候不一样，后续会讲。对于 map 来说 cap 是无限的（因为非连续）

#### 访问 & 修改容器元素

既然容器都是 key value 组合，所以都可以通过 `v = c[k]` 来获取

[书上](https://go101.org/article/container.html)列举了 slice/arary 和 map 取值的 panic 情况

- 不能是负数 int 的 key
- out of boundary 会编译时报错，如果是 variable 会在 runtime panic
- 给一个 `nil` 的 map 赋值会 runtime panic
- ...

#### slice

说实话 slice 有点像 c++ 的 vector，可以用内置函数 `append` 给 slice 增加元素

```go
	ss := []int{}
	ss = append(ss, 1223, 12333, 33321)
```

slice 的 len 到 cap 之间的剩余空间并不属于 slice 的元素，而是一些冗余的 slot

The result slice of an `append` function call may share starting elements with the base slice or not, depending on the capacity (and length) of the base slice and how many elements are appended. `append` 函数会返回一个新的 slice，可能会共享原来 slice 的原始元素，取决于 slice 的 cap 和 length

- 当 append 的元素个数大于剩余 slot 的数量，会给新 slice 分配新的内存空间，故不共享
- 否则，就会共享内存分片，不会开辟新的空间

通常我们不能改变 slice 的三个 field 如下，除了 reflect 和 unsafe 的方法（后续会提到），当然我们能直接通过赋值去改变一个 slice 变量（重新绑定）

```go
type _slice struct {
	// direct part
	elements unsafe.Pointer
	len      int
	cap      int
}
```

append 是一个 Variadic functions，可变参数的函数可以用，`...` 来解构（放在变量后面）

#### 容器的赋值

map：如果是 map 变量赋值，会共享元素，改变一个容器元素会影响（反射 reflect）另一个变量

```go
	mm1 := map[int]bool{1: true}
	mm2 := mm1
	mm2[2] = false
	delete(mm1, 1) // 删除 map 的某一个 key
	fmt.Println(mm1, mm2)
```

slice：会共享所有内置元素，但不会发生 reflect（是因为重新赋值了？）

```go
	ss1 := []int{1, 2, 3, 4}
	ss2 := ss1
	ss2 = append(ss2, 5)
	fmt.Println(ss1, ss2) // [1, 2, 3, 4] [1, 2, 3, 4, 5]
```

但是如果只是用下标修改，还是会互相影响的。

array：copy 整个元素，互不影响

```go
	ar1 := [4]int{1, 2, 3}
	ar2 := ar1
	ar2[3] = 123
	fmt.Println(ar1, ar2) // [1 2 3 0] [1 2 3 123]
```

#### make 函数构造 map 和 slice

> `make` 不能构造数组，还可以构造 channel

直接看代码吧

```go
	// map
	m := make(map[string]int, 10) // 至少 10 entry 已分配
	m["s"] = 33
	fmt.Println(m)

	// slice
	s := make([]int, 1, 2) // len cap
	ss := make([]int, 2)   // len == cap
	fmt.Println(len(s), cap(s), ss)
```
