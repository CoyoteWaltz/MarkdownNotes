# CMake 上手速记

> 官网：https://cmake.org/
>
> to build, test and package software
>
> CMake is used to control the software **compilation process** using simple platform and compiler independent configuration files, and generate native makefiles and workspaces that can be used in the compiler environment of your choice

> github [教程](https://github.com/ttroy50/cmake-examples)

### CMakeLists.txt

store all your CMake commands，在一个目录下执行 `cmake` 的时候会去找这个文件，没有的话就报错

#### cmake 的最小版本

```cmake
cmake_minimum_required(VERSION 3.5)
```

#### Projects 项目名称

```cmake
project(hello_cmake)
```

这个指令执行完毕之后会创建一个变量 `${PROJECT_NAME}`

#### 可执行文件

`add_executable` 指令声明我们需要最终 build 之后的可执行文件

```cmake
cmake_minimum_required(VERSION 2.6)
project (hello_cmake)
add_executable(${PROJECT_NAME} main.cpp)
```

### Binary Directory

The root or top level folder that you run the cmake command from is known as your `CMAKE_BINARY_DIR` and is the root folder for all your binary files. CMake supports building and generating your binary files both in-place and also out-of-source.

#### in-place

就是在 `CMakeLists.txt` 文件所在的地方直接 cmake

#### out-of-source

可以新建个 build 目录，然后再 `cmake ..` keeping your source tree clean

### Directory Paths

cmake 中可以用到的一些有用的目录变量

| Variable                 | Info                                                                                           |
| ------------------------ | ---------------------------------------------------------------------------------------------- |
| CMAKE_SOURCE_DIR         | The root source directory                                                                      |
| CMAKE_CURRENT_SOURCE_DIR | The current source directory if using sub-projects and directories.                            |
| PROJECT_SOURCE_DIR       | The source directory of the current cmake project.                                             |
| CMAKE_BINARY_DIR         | The root binary or build directory. This is the directory **where you ran the cmake command**. |
| CMAKE_CURRENT_BINARY_DIR | The build directory you are currently in.                                                      |
| PROJECT_BINARY_DIR       | The build directory for the current project.                                                   |

### Source Files Variable

set 一个变量存储源文件，便于之后的 `add_executable` 操作

```cmake
# Create a sources variable with a link to all cpp files to compile
set(SOURCES
    src/Hello.cpp
    src/main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})
```

也可以用 `file` 指令配合 glob 和通配符（wild card）

```cmake
file(GLOB SOURCES "src/*.cpp")
```

_For modern CMake it is **NOT recommended to use a variable for sources**. Instead it is typical to directly declare the sources in the add_xxx function._

### 设置需要 include 的目录

`target_include_directories` 编译的时候会加上 `-I/directory/path`

```cmake
target_include_directories(target
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)
```

这个 `PRIVATE` 表示 include 的 scope，后续详细说

#### 几种 include 编译类型

如果是 `PUBLIC`（下面这个例子），这个目录会在：1）编译这个 lib 的时候和 2）编译其他会 link 到这个 lib 的 target

- PRIVATE - the directory is added to this target’s include directories
- INTERFACE - the directory is added to the include directories for any targets that link this library.
- PUBLIC - As above, it is included in this library and also any targets that link this library.

#### TIPs

For public headers it is often a good idea to have your include folder be "namespaced" with sub-directories.

The directory passed to `target_include_directories` will be **the root of your include directory tree** and your C++ files should include the path from there to your header.

For this example you can see that we do it as follows:

```c++
#include "static/Hello.h"
```

Using this method means that there is less chance of header filename clashes when you use multiple libraries in your project.

### Verbose output

`make VERBOSE=1`

### Library

#### Adding a Static Library

从 source code build 一个静态 lib

```cmake
add_library(hello_library STATIC
    src/Hello.cpp
)
```

会构建出一个 `libhello_library.a` 的 binary 文件

#### Linking a Library

构建一个 lib 之后要去 link 他，告诉 cmake

```cmake
# link the new hello_library target with the hello_binary target
target_link_libraries(hello_binary
    PRIVATE
        hello_library
)
```

同样也会根据 PRIVATE or PUBLIC or INTERFACE scope 去 propagate link

#### Adding a Shared Library

shared 和 static library 有啥区别呢

```cmake
add_library(hello_library SHARED
    src/Hello.cpp
)
```

会 build 出 `libhello_library.dylib`

#### Alias Target

暂时没看懂 alias 有啥用，先跳过

### Installing

> 为什么要 install 为了将一些可执行内容/库直接安装到某个路径，而不是直接执行，可以联想到 npm install

CMake offers the ability to add a `make install` target to allow a user to install binaries, libraries and other files.

安装二进制的目录可以通过 CMAKE_INSTALL_PREFIX 变量来控制，which can be set using ccmake or by calling cmake with `cmake .. -DCMAKE_INSTALL_PREFIX=/install/location`（一定要设置，不然就默认 install 到 `usr/local/` 下了）

```cmake
install (TARGETS cmake_examples_inst_bin
    DESTINATION bin)
```

将 target cmake_examples_inst_bin 安装在 `${CMAKE_INSTALL_PREFIX}/bin` 目录下

```cmake
install (TARGETS cmake_examples_inst
    LIBRARY DESTINATION lib)
```

将 cmake_examples_inst 这个 shared lib 安装

```cmake
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/
    DESTINATION include)
```

将项目源码路径下的 include 头文件安装在 `${CMAKE_INSTALL_PREFIX}/include`

```cmake
install (FILES cmake-examples.conf
    DESTINATION etc)
```

将配置文件安装在 `${CMAKE_INSTALL_PREFIX}/etc`

#### 执行 make install

也支持 `make install DESTDIR=/tmp/stage` 指定安装目录，如果在 cmake 阶段忘记的话

#### uninstall

注意这个文件 `install_manifest.txt` 里面 manifest 了 install 的 target

cmake 没有提供 uninstall 的指令，不过我们可以手动的 rm 他：

`sudo xargs rm < install_manifest.txt`

### Build Type

cmake 内置了一些编译配置，不同的优化等级对应不同的指令 flag

The levels provided are:

- Release - Adds the `-O3 -DNDEBUG` flags to the compiler
- Debug - Adds the `-g` flag
- MinSizeRel - Adds `-Os -DNDEBUG`
- RelWithDebInfo - Adds `-O2 -g -DNDEBUG` flags

#### 设置 type

通过参数传递给 cmake `cmake .. -DCMAKE_BUILD_TYPE=Release`

#### 设置默认的 type

```cmake
# Set a default build type if none was specified
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message("Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()
```

如果没有检测到有参数传入，设置默认，同时设置一下可选类型给 cmake-gui？

### 设置 compile flags

- using target_compile_definitions() function
- using the CMAKE_C_FLAGS and CMAKE_CXX_FLAGS variables.

### Including Third Party Library

引入第三方库，比如 opencv，cmake 支持寻找地方库的路径 `find_package` 方法，This will search for CMake modules in the format "FindXXX.cmake"**（mac 实测感觉是 XXXConfig.cmake）** from the list of folders in `CMAKE_MODULE_PATH`.

Mac 应该会在 `/usr/local/lib/cmake/` 这里去找

看个例子：

```cmake
find_package(Boost 1.46.1 REQUIRED COMPONENTS filesystem system)
```

- Boost - Name of the library. This is part of used to find the module file FindBoost.cmake（对应 FindXXX.cmake）
- 1.46.1 - The minimum version of boost to find
- REQUIRED - Tells the module that this is required and to fail it it cannot be found
- COMPONENTS - The list of libraries to find.

#### 是否找到 library

`XXX_FOUND` 变量

```cmake
if(Boost_FOUND)
    message ("boost found")
    include_directories(${Boost_INCLUDE_DIRS})
else()
    message (FATAL_ERROR "Cannot find Boost")
endif()
```

### Compiling with clang

cmake 提供了一些选项来控制编译和 link

- CMAKE_C_COMPILER - The program used to compile c code.
- CMAKE_CXX_COMPILER - The program used to compile c++ code.
- CMAKE_LINKER - The program used to link your binary.

传递给 cmake：

`cmake .. -DCMAKE_C_COMPILER=clang-11.0 -DCMAKE_CXX_COMPILER=clang++-11.0`

### 设置 C++ Standard

> 越是新的标准，就有新的 feature

好家伙，一口气给了三种方法

#### 常规方法

1. 检查编译器是否支持某个 cpp 标准，如果支持就设置 compile 的 flag `-std=c+=11`

`CHECK_CXX_COMPILER_FLAG` 方法

```cmake
# try conditional compilation
include(CheckCXXCompilerFlag)  # cmake 导入检查 c++ 编译器方法
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11) # 尝试用 c++11 编译 将结果保存在 COMPILER_SUPPORTS_CXX11 变量中
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
```

2. 如果支持某个标准，那就在编译 c++ 的时候增加 flag，`CMAKE_CXX_FLAGS` 变量

```cmake
# check results and add flag
if(COMPILER_SUPPORTS_CXX11)# 如果支持 11 就真的编译成 11
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")  # 这里的 set 更像是 append 做法
elseif(COMPILER_SUPPORTS_CXX0X)#
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
    message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()
```

#### Using CXX_STANDARD property

直接设置 `CMAKE_CXX_STANDARD` 变量，会使 `CXX_STANDARD` property on all targets.

```cmake
# set the C++ standard to C++ 11
set(CMAKE_CXX_STANDARD 11)  # 20
```

#### Using target_compile_features

用 target*compile_features 这个方法来设置支持，又是一个 `target*\*` 的函数，可以设置 scope

```cmake
# 目标都使用 auto 类型的标准来编译 cxx_auto_type 这个 feature 可以是其他的
target_compile_features(hello_cpp11 PUBLIC cxx_auto_type)
```

执行后的值保存在变量 `CMAKE_CXX_COMPILE_FEATURES`

```cmake
message("List of compile features: ${CMAKE_CXX_COMPILE_FEATURES}")
```
