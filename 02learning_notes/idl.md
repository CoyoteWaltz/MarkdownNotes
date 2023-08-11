# IDL

> [IDL](<https://en.wikipedia.org/wiki/IDL_(programming_language)>)，服务端通识，Interface Definition Language
>
> 接口定义语言，一类定义网络接口（http/rpc/...）的（这里网络接口可能不太妥，狭义了）
>
> 常见的有：thrift、protobuf、json、XML

## thrift

> 文档：https://thrift.apache.org/docs/idl
>
> 一个 thrift IDL 文件 `.thrift` 会经过 thrift 代码生成器，生成对应语言的代码
>
> _Thrift 最初是由 Facebook 作为内部项目开发使用，于 2007.04 开源，2008.05 进入 Apache 孵化器，并于 2010.11 成为 Apache 顶级项目（Top-Level Project, TLP）, 至今已有 10+ 年，thrift 功能强大，使用二进制进行传输，速度更快。_-- 来自[掘金](https://juejin.cn/post/6844903971086139400)

### 语法

关键字：

```c++
include, cpp_include, namespace, const, typedef, enum, senum, struct, union, exception, service, extends, required, optional, oneway, void, throws, bool, byte, i8, i16, i32, i64, double, string, binary, slist, map, set, list, cpp_type
```

标识符命名定义规范

```c++
Identifier      ::=  ( Letter | '_' ) ( Letter | Digit | '.' | '_' )*
```

即：

1. 字母、数字、下划线、点组成
2. 字符或者下划线开头

Literal 字面量在 IDL 中可以是 `'` or `"` 括起来的字符串

数据类型：

- `bool` 布尔型，false | true
- `byte` byte
- `i8` int8
- `i16` int16
- `i32` int32
- `i64` int64
- `double` 双精度浮点型
- `string` 字符串
- `binary` 二进制 byte[]
- `slist`

`FieldType` 用的比较多，可以是基础类型、容器类型或者合法标识符（通过 `typedef` `enum` `struct` 声明的类型）

### IDL 定义

> 通常以 `.thrift` 作为扩展类型的文件

Document 就是一个 thrift 文件

Header 多个

- Thrift Include

  - 导入其他 IDL：`include base.thrift`

  - 这样就能用了

  - ```c++
    // 这时，我们就可以引用从 base.thrift 导入的内容了
    struct Example {
      1: base.Base ExampleBase
    }
    ```

- C++ Include

  - 导入 c++ 模块：`cpp_include xxx`

- Namespace

  - `::= ( 'namespace' ( NamespaceScope Identifier ) )`

    - NamespaceScope 可以是 `'*' | 'c_glib' | 'cpp' | 'delphi' | 'haxe' | 'go' | 'java' | 'js' | 'lua' | 'netstd' | 'perl' | 'php' | 'py' | 'py.twisted' | 'rb' | 'st' | 'xsd'`（不同语言）
    - 标识了当前 thrift 文件适用的语言

  - 比如定义这个文件在 golang 的 `namespace`：`namespace go base`

Definition 核心内容

- Const

  - `const i8 count = 100`
  - `const double money = '13.14' // 同样可正可负`
  - `const map<string, string> = { 'name': 'johnson', 'age': '20' }`
  - `const list<string> names = [ 'tom', 'joney', 'catiy' ]`

- Typedef

  - 类似 c/cpp 的 `typedef`
  - `typedef i8 int8`：将 `i8` 类型定义别名 `int8`

- Enum

  - ```c++
    enum fb_status {
      DEAD = 0,
      STARTING = 1,
      ALIVE = 2,
      STOPPING = 3,
      STOPPED = 4,
      WARNING = 5,
    }
    ```

- Struct

  - 直接考虑 `Field*`

- Union 结构体中的字段只要有要给被赋予合法值，就可以被 thrift 传输，字段默认就是 `optional` 的，不能使用 `required` 声明

  - ```c++
    union UserInfo {
      1: string phone,
      2: string email
    }
    ```

- Exception 通常在 Function 中和 `throws` 配合使用

  - ```c++
    exception Error {
      1: required i8 Code,
      2: string Msg,
    }

    service ExampleService {
      string GetName() throws (1: Error err),
    }
    ```

  -

- **Service** 提供了对外暴露的接口，Service 可以被继承

  - ```c++
    Service      ::= 'service' Identifier ( 'extends' Identifier )? '{' Function* '}'
    Function     ::= 'oneway'? FunctionType Identifier '(' Field* ')' Throws? ListSeparator?
    FunctionType ::= FieldType | 'void'
    Throws       ::= 'throws' '(' Field* ')'

    ```

  - 核心就是 Function 的定义

  - 举个例子，其中 `oneway` 关键字是表示单向请求，无需服务端响应，与 `void` 的区别是还可以返回异常

  - ```c++
    service ExampleService {
      oneway void GetName(1: string UserId),
      void GetAge(1: string UserId) throws (1: Error err),
    }
    ```

  -

Field

- FiledID：必须是整数常量 + `:`
- FieldReq(Requiredness)：标识是必选/可选，`required`/`optional`，默认不写是两者的混合版。。？

### 一些实践

> [参考](https://tomsoir.medium.com/thrift-types-best-practice-2bb902b11076)

- Make method response/result structural
- Make method requests structural (opinionated but you will regret otherwise)
- **Never reuse** field IDs
- **Everything is optional**
