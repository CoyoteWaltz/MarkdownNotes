# Base 64 编码

> 图片，邮件附件

将任何二进制的文本编译成纯 ASCII 的字符串（7 bit 表示键盘上直接能打印出来的字符）

base 64 在 ASCII 中挑选了 **64** 个「可显示字符」的子集

### encode

因为是 64，所以是 6 bit，将原本的二进制数据按照 6 bit 一组查表得到对应 ASCII，通过 ASCII 文本传输，会带来大约 1/3 的额外体积开销。

padding：如果 input 的二进制个数不能被 6 整除，补零之后，再加一个 = 作为 padding（填充编码）

### decode

拿到 ASCII 之后，每 6 位 bit 解析，再每 8 位转为 char 即可。

### 优化

很多优化手段，

- 64 个字符转为 bit
- 固定长度分配内存

详见 chrome 浏览器 atob 的[源码](https://github.com/chromium/chromium/blob/master/third_party/blink/renderer/platform/wtf/text/base64.cc)实现。。魔法

```c++
// 摘录自源码 原地将 4 byte 转为 3 byte
// 4-byte to 3-byte conversion
  out_length -= (out_length + 3) / 4;
  if (!out_length)
    return false;

  unsigned sidx = 0;
  unsigned didx = 0;
  if (out_length > 1) {
    while (didx < out_length - 2) {
      out[didx] = (((out[sidx] << 2) & 255) | ((out[sidx + 1] >> 4) & 003));
      out[didx + 1] =
          (((out[sidx + 1] << 4) & 255) | ((out[sidx + 2] >> 2) & 017));
      out[didx + 2] = (((out[sidx + 2] << 6) & 255) | (out[sidx + 3] & 077));
      sidx += 4;
      didx += 3;
    }
  }
```

### 浏览器上的 base64 转换函数

字符串 to base64：`btoa('coyote')` => Y295b3Rl

反之：`atob('Y295b3Rl')` => coyote

### 代码

```c++
#include <iostream>
#include <string>

static constexpr const char base64Chars[] =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghigklmnopqrstuvwxyz0123456789+/";

// 7 bit ascii 映射到 base64Chars 的位置
static const unsigned char decMap[128] = {
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64, 64,
    64, 62, 64, 64, 64, 63, 52, 53, 54, 55, 56, 57, 58, 59,
    60, 61, 64, 64, 64, 64, 64, 64, 64, 0, 1, 2, 3, 4,
    5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
    19, 20, 21, 22, 23, 24, 25, 64, 64, 64, 64, 64, 64, 26,
    27, 28, 29, 30, 31, 32, 33, 34, 64, 36, 37, 38, 39, 40,
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 64, 64, 64,
    64, 64};
// calculate those from js code
// const res = Array.from({ length: 128 }, (_, i) => {
//   const base64Chars = // 这个可以单独写在外面 为了写在一个函数里面..
//     'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghigklmnopqrstuvwxyz0123456789+/';
//   const char = String.fromCharCode(i);
//   const indexOfBC = base64Chars.indexOf(char);
//   return indexOfBC === -1 ? 64 : indexOfBC;
// });

uint8_t decode(const uint8_t c)
{
    for (const char &bc : base64Chars)
    {
        if (c == bc)
        {
            return &bc - base64Chars;
        }
    }
    throw std::invalid_argument("invalid base64 input");
}

// 学一个新的 std string_view c++17 https://www.learncpp.com/cpp-tutorial/an-introduction-to-stdstring_view/
std::string base64Decode(const std::string_view input)
{
    std::string output;
    unsigned int buf = 0;
    unsigned int bufSize = 0;
    // unsigned char
    for (uint8_t c : input)
    {
        if (c > 127)
        {
            break;
        }
        if (c == '=') // 默认 padding 在末尾 直接结束
        {
            break;
        }
        // uint8_t sextet = decode(c); // 00XX XXXX 虽然是 8 bit 但是只有低 6 位有内容
        uint8_t sextet = decMap[c];
        if (sextet >= 64)
        {
            throw std::invalid_argument("invalid base64 input");
        }
        // populate output 只要记录 6 位 让 buffer 每次塞进去 6 位
        buf = (buf << 6) | sextet; // + sextet also ok
        bufSize += 6;
        if (bufSize >= 8) // 满足一个字节 就撤出 8 位
        {
            // 取出前 8 位 char 只能截断低 8 位? sure...
            output.push_back((char)(buf >> (bufSize - 8)));
            bufSize -= 8;
        }
        // 111100110000111111
    }

    return output;
}

int main()
{
    std::string out = base64Decode("Y295b3Rl"); // coyote
    std::cout << out << std::endl;
    // std::cout << (char)(0b00111101) << std::endl;   // =
    // std::cout << (char)(0b1100111101) << std::endl; // =

    return 0;
}
```

转码可视化网站：https://devtool.tech/base64
