# Modern C++ Tutorial: C++11/14/17/20 On the Fly

> 阅读笔记
>
> ouchangkun 大佬写的
>
> 可以在 https://changkun.de/modern-cpp/ 上免费获得这本书
>
> 从 C++ 98 一路飞跃到现代 C++ 的指南（地图）

## 环境配置

### clangd

安装 [clangd](https://clangd.llvm.org/)，是一个 LSP，可以告诉 editer 如何去写 cpp，在 macos 中直接安装 llvm 就行

`brew install llvm`

但问题是没有直接写入 PATH，目前两种解决方法：

- 先找到 clangd 在什么地方 `/usr/local/opt/llvm/bin/clangd`，把这个路径写进 PATH
  - `.zshrc` 或者 `.bash_profile` 里加上 `export PATH=$PATH:/usr/local/opt/llvm/bin/`
  - 查看 `echo $PATH | tr ':' '\n'`
- 直接看原来就有的 PATH 里有啥，然后把 clangd 软连接过去
  - `ln -s /usr/local/opt/llvm/bin/clangd /usr/local/bin/clangd`

最后 `clangd --version` 查看一下版本

VSCode 也可以用 clangd 来替代原来的 ms c++ 插件，不过还是之 ms c++ 好用点。。

### cmake

## CP 01: Towards Modern C++

- Compiler: clange++ -v 10.0.1（我本机已经是 11.0.3 了）
- Standard: `-std=c++2a`
- x86_64 架构

### Prerequisites?

#### LLDB & LLVM

[LLVM](https://en.wikipedia.org/wiki/LLVM):

- _Low Level Virtual Machine_，最早是这个缩写，现在这个含义已经被废弃了。变成了 umbrella project（有很多子项目）
- 一套基础纯设施工具链：LLVM can provide the middle layers of a complete compiler system, taking [intermediate representation](https://en.wikipedia.org/wiki/Intermediate_representation) (IR) code from a compiler and emitting an optimized IR
- 支持语言无关的指令集和 type system

[LLDB](https://lldb.llvm.org/index.html):

- LLDB is a next generation, high-performance debugger.
- It is built as a set of reusable components which highly leverage existing libraries in the larger LLVM Project, such as the Clang expression parser and LLVM disassembler.
- Xcode 的默认调试工具，对比 win 和 linux 上的 gdb

### 1.1 Deprecated features

> 未来版本会被抛弃，不再出现，但是依旧会被老版本兼容

- 字符串常量不能用 `char*` 去赋值，用 `const char*` 或者 `auto`。（其实之前写的时候已经在函数形参上有这个限制了吧）
- `auto_ptr` is deprecated and `unique_ptr` should be used.
- `++` 操作符在 bool 上将被废除（还能用在 bool 上？。。）
- C 语言的类型转换（`using <convert_type>`）将被废弃 c++17，用 **static_cast, reinterpret_cast, const_cas**t 这些

* 一些 C 语言的标准库也在 c++17 被废弃，such as `<ccomplex>, <cstdalign>, <cstdbool> and <ctgmath>`

### 1.2 Compatibilities with C

C++ is not a superset of C

在不得不在 C++ 中用 C 的时候，记得用 `extern "C"` 来分割 C 代码（就是如果对应的函数实现是 C，要特殊区分）

```cpp
// foo.h
#ifdef __cplusplus
extern "C" {
#endif
int add(int x, int y);
#ifdef __cplusplus
}
#endif

// foo.c
int add(int x, int y) {
  return x+y;
}
```

同时，需要先编译 C，再 build cpp（可以用 make file 来搞定）

```cpp
#include "foo.h"
#include <iostream>
#include <functional>
int main() {
    [out = std::ref(std::cout << "Result from C code: " << add(1, 2))](){
        out.get() << ".\n";
    }();
return 0; }
```

现在还有这种语法了？惊了，之后学到。

## CP 02: Language Usability Enhancements

> language usability: 指的是语言在运行时之前的行为

### 2.1 Constants

#### nullptr(c++11)

用来替换 `NULL` 空指针的，`NULL` 会被当作是 0 嘛，不过这样看编译器是如何定义它的，一些会定义为 `(void*)0` 一些直接是 0。

如果 `NULL` 是 0 的问题，会发生在函数重载上：（that's why）

```cpp
char *ch = NULL;
void foo(char*);
void foo(int);
```

为了避免这样，用 `nullptr` 关键字吧，他的类型是 `nullptr_t` 能够被隐式转换为任何类型的指针，可以进行任何的比较。

下面这么一段代码

```cpp
#include <iostream>
#include <type_traits>

void foo(char *);
void foo(int);

int main()
{
  if (std::is_same<decltype(NULL), decltype(0)>::value)
  {
    std::cout << "typeof NULL == 0" << std::endl;
  }
  if (std::is_same<decltype(NULL), decltype((void *)0)>::value)
  {
    std::cout << "NULL == (void *)0" << std::endl;
  }
  if (std::is_same<decltype(NULL), std::nullptr_t>::value)
  {
    std::cout << "NULL == nullptr" << std::endl;
  }
  if (std::is_same<decltype(nullptr), std::nullptr_t>::value)
  {
    std::cout << "nullptr == nullptr" << std::endl;
  }
  foo(0);
  // foo(NULL);
  foo(nullptr);
  return 0;
}

void foo(char *str)
{
  std::cout << "str: called" << std::endl;
}

void foo(int num)
{
  std::cout << "number: " << num << std::endl;
}
```

输出的只有 `nullptr == nullptr`，说明 nullptr 的独一无二。

**这里我们能看到 `is_same`、`decltype` 和标准库 `type_traits`**

- decltype: is used for type derivation，后文继续会谈到
- std::is_same: 这里居然用的是泛型。。

#### constexpr 类型修饰符吧？(c++11)

const expression 的概念：就是无论如何不会改变结果，以及无副作用，比如 `1+2` 这种。编译器会直接优化，将其结果塞入程序

```cpp
// 同样可以是 递归的 只要都满足 const！
constexpr int fibonacci(const int n)
{
    return n == 1 || n == 2 ? 1 : fibonacci(n - 1) + fibonacci(n - 2);
}

int main()
{
    constexpr int len_constexpr = 5;
    int arr[len_constexpr]; // legal
    cout << fibonacci(10) << endl;
    return 0;
}

```

上面这个 snippet 中的 arr 初始化的长度都可以用 `constexpr` 修饰的 int！

还有一点是 14 之后支持在 constexpr 修饰的函数中使用 local 变量、循环、if 分支，c++11 以下都是不行的

### 2.2 Variables and initialization

#### if-switch

在传统的 cpp 中，不能在 if 里面声明局部变量，在 c++17 中可以了

```cpp
 std::vector<int> vec = {1, 2, 3, 4};
    // since c++17, can be simplified by using `auto` 这里还是在外层声明了
const std::vector<int>::iterator itr = std::find(vec.begin(), vec.end(), 2); if (itr != vec.end()) {
*itr = 3; }
// 可以直接在 if 里面声明了
if (const std::vector<int>::iterator itr = std::find(vec.begin(), vec.end(), 3); itr != vec.end()) {
*itr = 4;
}
```

#### Initializer list

列表初始化，传统 cpp 生成数组确实不是很方便，vector，PODs (Plain Old Data, ie classes without constructs, destructors, and virtual functions) 这样

于是 c++ 11 提供了 `initializer_list` 也算是个容器吧，能够刚方便的为 class 初始化数组

```cpp
#include <iostream>
#include <vector>
#include <initializer_list>

using namespace std;

class Foo
{
public:
    Foo(initializer_list<int> list)
    {
        for (int el : list)
        {
            cout << "init list => " << el << endl;
            vec.push_back(el);
        }
    }
    vector<int> vec;
    void print() const
    {
        for (int el : vec)
        {
            cout << "print list => " << el << endl;
        }
    }
};

int main()
{
    Foo foo = {1, 2, 4, 5, 6};
    foo.print();
    return 0;
}
```

#### Structured binding

结构化绑定数据，类似其他语言可以一口气 return 多个变量

c++11 14 都做了类似的事情，但是在 17 变的更加完善了，直接 17 吧！

看代码

```cpp
#include <iostream>
#include <tuple>

using namespace std;

tuple<int, double, string> f()
{
    return make_tuple(1, 2.3, "yesok");
}

int main()
{
    auto [a, b, c] = f();
    cout <<  a << " " << b << " " << c << endl;
    return 0;
}
```

#### Type inference

> auto? any?

c++11 提供了两个 `auto` 和 `decltype` 来让编译器去判断类型

##### auto

提一下传统的 [register](http://www.cplusplus.com/forum/beginner/140093/) 变量类型，会直接存到寄存器而不是内存 RAM 中，在 c++17 就被 deprecated 了

注意：不能用在函数的形参类型，以及数组的类型 `auto auto_arr2[10] = {arr};`

##### decltype

需要知道一些表达式的值的类型，可以用它

```cpp
auto x = 1;
auto y = 2;
decltype(x+y) z;
```

同样可以配合 `is_same`（前面提到过）

```cpp
if (std::is_same<decltype(x), int>::value) std::cout << "type x == int" << std::endl;
if (std::is_same<decltype(x), float>::value) std::cout << "type x == float" << std::endl;
if (std::is_same<decltype(x), decltype(z)>::value) std::cout << "type z == type x" << std::endl;
```

`std::is_same<T, U>` 判断 T 和 U 的类型是否相同

可以用 auto 作为返回值类型

```cpp
#include <iostream>

template <typename T, typename U>
auto add(T x, U y)
{
    return x + y;
}

int main()
{
    auto res = add<std::string, std::string>("1", "asdfdasf");
    std::cout << res << std::endl;
    return 0;
}
```

##### decltype(auto)

**parameter forwarding** 有这么个东西之后会详细讲

有这么两个函数

```cpp
std::string  lookup1();
std::string& lookup2();
```

可以通过 delctype(auto) 包装，不用自己在 copy 类型了

```cpp
decltype(auto) look_up_a_string_1() {
  return lookup1();
}
decltype(auto) look_up_a_string_2() {
	return lookup2();
}
```

### 2.4 Control flow

#### if constexpr

本质上 `constexpr` 会把表达式在编译的时候直接编译为 constant 结果，那么其实在判断条件的时候也可以这么做，可以让程序更加高性能

```cpp
template <typename T>
auto print_type(const T &a)
{
    if constexpr (is_integral<T>::value)
    {
        cout << "int " << a << endl;
    }
    else
    {
        cout << "not int " << a << endl;
    }
}
```

#### Range-based for loop

就是在容器里迭代的简洁语法

`for (auto el : vec)` 不可改，el 是个 copy

`for (auto& el : vec)` 可修改，是个引用
