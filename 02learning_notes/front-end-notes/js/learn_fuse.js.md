# [开源框架] Fuse.js

模糊搜索在前端使用的场景感觉还是挺多的

官网：https://fusejs.io/

github：https://github.com/krisk/fuse

## 带着问题看源码

- 如何实现模糊查找？
  - 转为小写，疯狂正则？答：大小写不敏感的时候都是转为小写的，正则在匹配的时候没有用到
- 利用位置误差来实现模糊：核心算法等下详细看一看
- 如何做到零依赖？成本会很大吗？值得这样做吗？
- 调用方式是用什么样的逻辑和设计？
  - 面向对象 + 面向过程
- 模糊查找的性能？
  - 内部有做提速，比如 FuseIndex 等
- ...

## 初步规划

1. 搞懂其中模糊搜索的 scoring theory ，搜索目标和待搜内容的关联度分数；https://fusejs.io/concepts/scoring-theory.html
2. 搞明白他的 fuse index 是什么东西，有什么作用；

## 几个概念

### FuseIndex

为了搜索时的提速做了一个

### Scoring theory

这个 score 为一个 0 ~ 1 的值，由参数 error 、 distance 和位置决定

**是衡量一个位置的匹配精确程度，score 越小，越满足精确性，越大越模糊**

计算公式`accuracy + proximity / distance`，其中

- accuracy 通过 error 得到
- proximity 通过位置得到

解释一下这些参数

#### error

是指允许的模糊误差的字符数，取值为 0-pattern.length 的整数

如果 pattern 是 apple （长度为 5），error 为 3 ，说明匹配到长度为 5 的范围内可以出现 3 个不是 apple 中的字符。

通过 error 可以得到一个 accuary

```js
const accuracy = errors / pattern.length;
```

误差给的越大，说明查询也越模糊，accuracy 也就越大

#### distance

用户配置的值，告诉 Fuse 一个匹配到 pattern 的位置和预期匹配位置的字符距离，默认是 100

#### 位置

Abs (预期匹配到的位置 - 实际匹配到的位置)可以得到 `proximity`

预期匹配的位置也是用户配置的，默认为 0

#### score

这些参数由这个函数计算得到 score

被用在计算不同位置、不同误差情况的分数

这个分数同样被可配置的 `threshold` 参数给限制：给`0.0`以为精确匹配，给`1`以为这会匹配到任何字符

```js
// 这个分数仅仅只是计算 误差 + 偏离程度 的一个分数  越小越好   0 -> 1 -> inf
export default function computeScore(
  pattern,
  {
    errors = 0, // 误差字符数
    currentLocation = 0, // 当前匹配位置
    expectedLocation = 0, // 预计位置
    distance = Config.distance, // 表示能够被作为一个模糊匹配的最近距离 与 location 的距离
    ignoreLocation = Config.ignoreLocation,
  } = {}
) {
  // 精确匹配的情况下 为 0
  const accuracy = errors / pattern.length;
  // 不考虑位置带给分数的影响
  if (ignoreLocation) {
    return accuracy;
  }
  // 得到与 预期位置的相差距离
  const proximity = Math.abs(expectedLocation - currentLocation);

  // 不考虑 距离偏差 的情况 意味着必须在 expectedLocation 的位置匹配到
  if (!distance) {
    // Dodge divide by zero error.
    // 存在偏差 就返回 1 说明 不满足要求 给最高的分数 最模糊
    return proximity ? 1.0 : accuracy;
  }

  return accuracy + proximity / distance;
}
```

## 核心模糊搜索算法

核心思路：在无法精确匹配的情况下，采用 **bitap** 算法进行模糊匹配（注意不是 bitmap），会从 error 为 1 开始，在文本串中从后往前判断： 模式串长度的区间内是否有大于 error 个模式串中的字符，如果满足，同时由该位置和 error 计算得到的 score 小于预设的阈值，就停止搜索，得到匹配结果。

例如：

模式串 apple

文本 weafafewe*xxxple*yyyyaep

搜索结果为：

```js
score: 0.5;
error: 2;
index: 10; // 也就是斜体的部分
```

### Bitap 算法

也叫做 shift-or 或者 shift-and 算法，用来匹配字符串的，用位运算的方法，可以实现精确匹配，也可以模糊匹配

首先对 pattern 构造字母表，用位运算记录 pattern 中每个字符出现的位置，匹配到了记 1，否则记 0

比如`apple`可以得到这样的

`{ a: '10000', p: '01100', l: '00010', e: '00001' };`

```js
// 首先构造字母表
function createPatternAlphabet(pattern) {
  let mask = {};

  for (let i = 0, len = pattern.length; i < len; i += 1) {
    const char = pattern.charAt(i);
    // 最初 0 | 1 <<
    mask[char] = (mask[char] || 0) | (1 << (len - i - 1));
  }

  return mask;
}
```

我们先看一下精确匹配，pattern 为 apple

#### 精确匹配

接着对每个文本字符进行匹配，同时维护一个比特串`bit=00000`，在匹配一个字符的时候先假定匹配成功了，让`bit = (bit << 1) | 1`，让这个位置为 1，然后看一下这个位置的字符是否在模式串中也是同样的位置`bit &= mask[text[i]]`，如果匹配失败了，`bit`会重回到 0，相当于模式串纸带被拉到开头继续匹配（如果熟悉 KMP 的话），匹配成功的话，`bit`中带 1 的成功信息会随着下次左移推进，直到`bit`最高位的长度为 pattern 的长度就算匹配成功（`bit & (1 << (patternLen - 1)) == 1`）

```js
function shiftAnd(pattern, text) {
  const patLen = pattern.length;
  const textLen = text.length;
  const alphabet = createPatternAlphabet(pattern);

  // 先构造好最终的 match
  const mask = 1 << (patLen - 1);

  let bit = 0;

  // 当 bit 到达最长匹配 mask 长度即匹配成功
  for (let i = textLen - 1; i >= 0; --i) {
    bit = ((bit << 1) | 1) & alphabet[text.charAt(i)];

    if (bit & mask) {
      return i; // 匹配成功
    }
  }
  return -1;
}
```

解释一下为什么叫 shift-and 算法，一边移动（shift）一边匹配（and）

#### 模糊匹配

将二进制串`bit`扩展到第二个维度，`bitArr[0, 1, ..., error]`，第`bitArr[i]`表示能匹配到的误差最多为 i 个的匹配信息

后一个字符的 binj1

0

当前匹配到了一个 a

当前的字符是否能精确匹配？

binj1 << 1 -> 0 << 1| 0 -> 1

1 & 10000 -> 0
