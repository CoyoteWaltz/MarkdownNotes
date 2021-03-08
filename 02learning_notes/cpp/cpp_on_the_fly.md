# Modern C++ Tutorial: C++11/14/17/20 On the Fly

> 阅读笔记
>
> ouchangkun 大佬写的
>
> 可以在 https://changkun.de/modern-cpp/ 上免费获得这本书
>
> 从 C++ 98 一路飞跃到现代 C++ 的指南（地图）

## CP 01: Towards Modern C++

- Compiler: clange++ -v 10.0.1（我本机已经是 11.0.3 了） 
- Standard: `-std=c++2a`
- x86_64 架构

### Prerequisites?

#### LLDB & LLVM

[LLVM](https://en.wikipedia.org/wiki/LLVM):

- *Low Level Virtual Machine*，最早是这个缩写，现在这个含义已经被废弃了。变成了 umbrella project（有很多子项目）
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

















