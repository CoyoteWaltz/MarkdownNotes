# Numpy 学习笔记

NumPy(Numerical Python 的简称)是 Python 数值计算最重要的基础包。大多数提供科学计算的包都是用 NumPy 的数组作为构建基础。

和 matlab 操作数组一样简单便捷

```python
import numpy as np
```

---

## ndarray

#### ndarray

n 维数组 是一种数据类型，np.array()生成的对象就是这个类型的
ndarray 应该算是最重要的数据类型了

```python
b = np.array([[3, 4],
            [3, 5],
             [5, 4]])
type(b)		# numpy.ndarray
```

- 创建:

  ones, ones_like: like 另一个数组的 shape

  zeros, zeros_like

  empty, empty_like

- 属性:
  shape 获得数组的形状，也可以强制改变，可以这样`b.shape = 2, -1`给-1 他就会自动计算

- 方法:
  reshape() 参数为一个 size 元组 返回一个新数组临时变量
  `c = b.shape((2, -1))`注意 此时这里 c 和 b 共享内存！！
  ndarray 中的元素数据类型

#### dtype

np.float

np.int32

...
用 astype 转换类型(安全)
`f = b.astpye(np.float)`这样原本 b 中的整形到 f 里面会多一个小数点 表示是浮点类型

#### arange

类似 python 中的 range 函数，返回一个迭代器
np 中`a = np.arange(1, 10, 0.5)`得到 a 是一个 array 对象类型也是 ndarray

#### linspace

`s = np.linspace(1, 10, 10)`三个参数为: 起点，终点，元素个数，默认包含终点(endpoint)，也可以传入参数 endpoint=Flase。

#### logspace

类似 linspace，`d = np.logspace(1, 2, 10)`创建一个等比数列，起始值为 10 的 1 次方，终止为 10 的 2 次方，一共十个数。参数有 base，如果是 base=2，从 2 的 1 次方到 2 的二次方有十个数

#### fromstring

从字符串构造数组

```python
s = "abcd"
g = np.fromstring(s, dtype=np.int8)	# [97 98 99 100]
```

#### 读取 切片

a[1:14:2]左闭右开，步长为 2
a[::-1]意味着翻转 reverse， -1 即倒着来
切片还是共享内存
还支持 a[[2, 4, 6]]这样的提取 得到的结果不会与 a 共享内存！算是一种映射。

#### np.random.rand

**均匀分布**[0, 1)之间随机数
参数: 随机数个数
返回一个 1 维行向量

#### 不等号

`a > 1`可以得到一个布尔数组！！
可以这样 `b = a[a > 5]`就将 a 中大于 5 的元素提取出来了！！很巧妙，**并且 b 和 a 不会共享内存**
也可以`a[a > 5] = 5`将 a 中大于 5 的数都改为 5

#### 广播概念 boardcast

`b = a.reshape((-1, 1))`指定列为 1，行给-1 无所谓，让 python 自己计算，所以得到一个新的列向量

```python
aa = np.arange(0, 51, 10).reshape((-1, 1))
bb = np.arange(6)
aa + bb
"""
array([[ 0,  1,  2,  3,  4,  5],
       [10, 11, 12, 13, 14, 15],
       [20, 21, 22, 23, 24, 25],
       [30, 31, 32, 33, 34, 35],
       [40, 41, 42, 43, 44, 45],
       [50, 51, 52, 53, 54, 55]])
"""
```

a 的每一行分别加上了 b 的每一列，所得到新的一行

#### 二维数组的切片

类似 matlab。cc[:, 2]所有行，第二列, cc[2:4, [2, 3, 4]]3 到 5 行，第 3 4 5 列
a[(0, 1, 2, 3), (2, 3, 4, 5)]由 a[0,2], a[1, 3], a[2, 4], a[3, 5]组成的行向量
二维数组 a[[2, 3, 4]]会提取原矩阵(就这么叫吧)的第 3 4 5**行**，(**只要是通过数组提取出来的都不会共享内存！**)a[[2, 3, 4], 3]可以提取出第三列

#### 函数 binary_repr

将数值转换为 2 进制 str，在组图像处理比特平面分层的时候用到

#### 关于数组的 axis

如果把 tensor 看成是一个长方体

```python
	 0  /---------------/
   =  /              /  |
  x /	          /    |
 a/              /      |
 ---------------	       |
a|		      |        |
x|		      |       /
=|		      |     /
1|             |   /
 |             | /
 ---------------
   axis = 2
# 画图真难
# 如果是二位数组 axis=0就是y方向，axis=1就是x方向    x→   y↓
```

- 转置: `arr.T`即可，或者`np.transpose()`返回转置后的数组，对于高维数组，转置的是轴

  ```python
  In [30]: dd
  Out[30]:
  array([[[1],
          [2]],

         [[2],
          [3]],

         [[3],
          [4]]])
  In [31]: np.transpose(dd)
  Out[31]:
  array([[[1, 2, 3],
          [2, 3, 4]]])
  In [32]: np.transpose(dd).shape
  Out[32]: (1, 2, 3)
  # axis 0 - 1 - 2 ==> 2 - 0 - 1
  # 先沿着axis=2往下转90度，然后沿着原来的axis=0向左旋转90度
  ```

- 交换两个轴: `swapaxes(ax1, ax2)`，交换两个轴上的元素，返回新 array

#### stack 堆叠数组

stack arrays up!

- `np.stack`: 接收参数为一个`[arr1, arr2]`，按照 axis=0 的方向堆叠两个数组，返回堆叠后的数组
- `np.vstack`: vertically stacking，就是将两个数组按照垂直方向堆叠，两个`3*2*1`的数组 vstack 之后的 shape 是`6*2*1`。但是如果仅是`stack([arr1, arr2])`的结果 shape 是`2*3*2*1`，很迷惑，把两个数组分别放在了一个 array 的第一个和第二个位置了。
- `np.hstack`: horizontally stacking，就是水平方向 stack 了，应该很好理解。

## 元素级数组函数

#### 一元函数 arange sqrt exp prod clip

都接收一个参数 out，指定输出到某个变量

- `np.arange(n)`: 效果相当于 np.array(range(n))
- `np.sqrt(arr)`
- `np.exp(arr)`
- `np.prod(arr, axis=)`: 累乘轴上的元素 同样支持 arr.pord(axis=)
- `np.darray.clip(min=, max=)`: 默认参数为 min，大于 max 的值被设置为 max，小于 min 的值被设置为 min，不会原地改变，返回 clip 后的数组

#### 二元(多元)函数

- `np.maximum(arr1, arr2)`: 返回一个新 array，每个元素是对应 arr1 和 arr2 对应元素最大的，还可以是多个 arr 一起放入，但是注意维度都必须一样！
- `np.modf(arr)`: 返回一个 tuple，第一部分是 arr 元素的小数部分，第二个部分是整数部分 `frac, inte = np.modf(np.array([2.1, 4.44]))`
- `np.where(cond, x, y)`: 可以找到符合条件的下标，同时也可以替换符合条件的元素(返回替换后的数组):
  - cond: 条件`arr > 0`
  - x: 满足条件的元素，输出 x
  - y: 不满足条件，输出 y
  - 不给 x 和 y 的时候返回符合条件的下标，x 和 y 必须同时给，否则报错

#### 对轴元素做 map 映射 apply_along_axis

如果需要对元素进行批量修改，这是一个非常好的函数

`apply_along_axis(func1d, axis, arr, *args, **kwargs)`

第一个接收一个 1 元函数，第二个参数指定 axis

例子(写贝叶斯决策的时候):

```python
def _calc_posterior(self, rows):
    """
    calculate posterior probabilities for samples(rows)
    ommit the denominator
    :param rows: array of samples at rows
    """
    return (1 / np.sqrt(2 * np.pi * self.vars) * np.exp(
        -(rows - self.means) ** 2 / (2 * self.vars)
    )).prod(axis=1)  # multi-production
def _predict_prob(self, test_data):
    """
    :param test_data: array of rows of samples
    :return posterior: rows of samples, elements are class
    """
    posterior = np.apply_along_axis(self._calc_posterior, axis=1, arr=test_data) # 一行一行作用计算后验概率
    posterior = np.array(list(self.prior.values())) * posterior # product the prior
    return posterior
```

#### 生成网格 meshgrid

生成网格的作用，我想到了类似计算两个随机变量的联合概率，需要一个轴是 X 变量的取值，另一个轴是 Y。matlab 中也有类似函数。至于到底用来干什么，可以计算类似`sqrt(xx ** 2 + yy ** 2)`，每个 x 和多个 y 的计算（？），绘制三 D 图像也可以

用法:

```python
In [66]: a
Out[66]: array([4, 2, 3])
In [67]: b
Out[67]: array([1, 4, 1])
In [68]: xx, yy = np.meshgrid(a, b)
In [69]: xx
Out[69]:
array([[4, 2, 3],
       [4, 2, 3],
       [4, 2, 3]])
In [70]: yy
Out[70]:
array([[1, 1, 1],
       [4, 4, 4],
       [1, 1, 1]])
# 其实就是对第一个a做竖直方向上的stack得到xx，b做水平方向的stack得到yy
# 也可以三个维度gird np.meshgrid(a, b, c)
```

## 数学和统计方法

都可以指定 axis

- `np.mean()`
- `np.sum()`
- `np.cumsum()`: cumulatively sum，累加，$s_{k} = \sum_{i = 0}^{k-1}a_i$
- `np.argmin()`,`np.argmax()`
- `np.argsort()`,`np.sort()`
- `np.std()`, `np.var()`: 标准差和方差
- `np.cov(arr1, arr2)`: 求两个数组的协方差矩阵
- `np.unique(arr)`: 返回唯一元素的数组

## 数组的文件输入输出

`np.load()`

## np.random 模块

### numpy.random.choice(a, size, replace, p)

从一个**一维**的 array 中随机抽样。

参数说明:

- a: 一个一维 array-like 或者 int，如果是数组则采样，如果是 int 就是从 arange(a)中采样
- size: int or tuple 采样后的数组 size
- replace: bool optional,Whether the sample is with or without replacement？好吧就是放不放回采样，False 就是不重复采样！
- p: 1-d array-like，是传入 a 的元素对应的概率，如果没有就按照每个元素都是 uniform 分布来采样

## 线性代数操作和 np.linalg 模块

linear algerba 的使用应该是最多的了

#### 矩阵乘法

- `np.dot(arr1, arr2)`
- `@`符号

#### 矩阵分解

- qr 分解: `np.linalg.qr(mat)`qr 分解的内容，算法课讲过，高斯消去法的中间步骤
