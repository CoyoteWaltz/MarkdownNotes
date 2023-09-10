# Pytorch 学习笔记

源自[官网教程](https://pytorch.org/tutorials/)加上自己的理解

60 分钟 blitz 快速了解

## Tensor

### Tensor

众所周知，要充分使用 GPU 计算，Tensor 是一个很好的数据容器，其实也就是高维矩阵。在 pytorch 中的 tensor 更像是 numpy 里的 darray

`x = torch.empty(3, 3, 1) # 空tensor 内容比较随机 uninitialized`

`x = torch.rand(3, 4) # 随机数矩阵`

`x = torch.zeros(4, 2, dtype=torch.long) # 零矩阵 也可以指定数据类型`

`x = torch.tensor([44, 1]) # initialize from array`

到这里感觉就像是在用 numpy，axis 也和 numpy 是一样的

`x.new_ones(1, 4) # new_什么 接收size作为参数 返回一个新对象`

`x = torch.randn_like(x, dtype=torch.double64) # like一个tensor的size`

`x = torch.randint_like(x, 1, 4) # like x 生成 1 - 4之间的随机整数tensor`

获得 shape/size

`x.size()` 或者 `x.shape` 当然官网说的是前者，返回一个 torch.Size 的实例，实质上是一个 tuple

### 操作符

​ 加法

```python
# result = torch.empty(4, 2)
result = torch.zeros_like(x)		# 这样可以更方便一点
torch.add(x, y, out=result)

# adds x to y
y.add_(x)
```

​ 所有操作符之后加上下划线可以是改变本身的运算，类似于+=，-=，copy=

### Resizing 使用`torch.view`

可是 torch 没有 view 这个函数啊。。。

只能用 tensor 自带 view，

`x = x.view(-1, 1)` 说明 view 只是改变之后返回

和 numpy 相比，numpy 有`np.reshape(x, (1, -1))`这个函数当然作用也只是返回一个改变后的 array

如果 tensor 只有一个元素，可以使用`x.item()`来获取，如果有多个元素会报错*ValueError*

### NumPy Bridge

摘自官网

Converting a Torch Tensor to a NumPy array and vice versa is a breeze. (这个 is a breeze 意思是 很 easy)

The Torch Tensor and NumPy array will share their underlying memory locations (if the Torch Tensor is on CPU), and changing one will change the other. (cpu 上两者是共享内存的 改一个全都会变 验证下来确实如此，但是 GPU 的还不知道)

Tensor2Array 仅仅需要`x_ay =x.numpy()`

Array2Tensor 需要`b = torch.from_numpy(x_ay)`

All the Tensors on the CPU **except a CharTensor** support converting to NumPy and back.

### Tensor on CUDA

使用`.to`

```python
if torch.cuda.is_available():
    device = torch.device("cuda")		# 生成一个 torch.Device
    y = torch.ones_like(x, device=device)	# 直接在gpu上定义一个tensor
    x = x.to(device)                       # or just use strings ``.to("cuda")``
    z = x + y
    print(z)
    print(z.

          to("cpu", torch.double))       # ``.to`` can also change dtype together!
```

### repeat

`repeat`(\*_sizes_) → Tensor

接收的参数依次对应 tensor 的维度，下为官网的例子

```python
>>> x = torch.tensor([1, 2, 3])
>>> x.repeat(4, 2)  # 在第0维重复4次 在第1维重复2次
tensor([[ 1,  2,  3,  1,  2,  3],
        [ 1,  2,  3,  1,  2,  3],
        [ 1,  2,  3,  1,  2,  3],
        [ 1,  2,  3,  1,  2,  3]])
>>> x.repeat(4, 2, 1).size()
torch.Size([4, 2, 3])
```

#### numel

returns the total number of elements in the tensor

#### unsqueeze & squeeze

unsqueeze 向 tensor 指定维度再插入一个维度，那么 squeeze 就是挤掉一个维度....

```python
s = torch.Tensor([1, 2, 3])  # size: (3,)
s.unsqueeze(1)	# size = (3, 1) 就是列向量了
```

#### max

torch.max，取最大值，但是给定维度之后会不仅会返回最大值的 tensor，并且还会返回第二个参数是最大值所在的下标，结合了 arg 的 max，挺好

#### nonzero

返回 tensor 中非零元素的下标组成的 array

#### clamp

和 numpy 的 clip 是一个用法，`clamp(input, min, max)`超过 max 的置为 max，小于 min 的置为 min

## AUTOGRAD: AUTOMATIC DIFFERENTIATION

大名鼎鼎的自动微分在 pytorch 中是如何用的呢

### Tensor

​ `torch.Tensor` is the central class of the package. If you set its attribute `.requires_grad` as `True`, it starts to track all operations on it. When you finish your computation you can call `.backward()` and have all the gradients computed automatically. The gradient for this tensor will be accumulated into `.grad` attribute.

在给 Tensor 的一个属性`requires_grad`传递参数`True`之后，就具备类记录每次计算后的梯度问题（这个问题还是具体看 Auto differentiation 如何实现的，当初看了没怎么看懂，只知道在 forward 的时候要保留一个值），当 call 了`.backward()`之后开始反向传播，就会自动计算梯度了，每次梯度会被累计在 Tensor 的`.grad`属性中。

当不需要记录梯度的时候，用`.detach()`，或者用上下文`with torch.no_grad():`，减少记录梯度所占用的系统空间，“This can be particularly helpful when evaluating a model because the model may have trainable parameters with `requires_grad=True`, but for which we don’t need the gradients.”这句话说的挺好。

还有一个非常重要的模块**Function**

Tensor 和 Function 两者保证了在神经网络中无环图，encodes a complete history of computation. Each tensor has a `.grad_fn` attribute that references a `Function` that has created the `Tensor` (except for Tensors created by the user - their `grad_fn is None`).

If you want to compute the derivatives, you can call `.backward()` on a `Tensor`. If `Tensor` is a scalar (i.e. it holds a one element data), you don’t need to specify any arguments to `backward()`, however if it has more elements, you need to specify a `gradient` argument that is a tensor of matching shape.

仅有一个元素的 Tensor 可以被称为 scalar。

`x = torch.ones(2, 2, requires_grad=True)`

此时查看`x.requires_grad`得到的是 True

```python
y = x + 2
z = y * y * 3
out = z.mean()
```

关于 tensor 有的`requires_grad_`是一个 function，可以传递参数来改变`requires_grad`的属性，

```python
a = torch.randn(2, 2)
a = ((a * 3) / (a - 1))
print(a.requires_grad)
a.requires_grad_(True)	# 之后开始计算grad　不给参数 就默认开启
print(a.requires_grad)
b = (a * a).sum()
print(b.grad_fn)
```

requires_grad 有传递作用

写到这里发现 pytorch 的命名还挺有意思

重新从 github 上面找了[pytorch-handbook](https://github.com/zergtant/pytorch-handbook)，中英对照着来学吧，快一点。

开始反向传播，`out.backward()`，因为这里的 out 是一个 scalar，相当于`backward(torch.tensor(1))`。

得到 x 的梯度

```python
tensor([[ 4.5000,  4.5000],
        [ 4.5000,  4.5000]])
```

官网还说到计算 vector-Jacobian 乘积，向量和雅克比矩阵乘积，有$\vec{y} = f(\vec{x})$ ，$\vec{v}^{T} \cdot J$，这个 v 向量是$l = g(\vec{y})$的这个标量$l$对 y 的梯度向量，J 是$\vec{y}$对于$\vec{x}$的梯度矩阵的转置，也就是雅克比矩阵，那么$J^{T} \cdot \vec{v}$的过程就是$l$对于$\vec{x}$的梯度向量，可以自己写出矩阵和向量的乘积看一看结果。这其实也就是连式法则的关键，当对于$\vec{y} = f(\vec{x})$这样结果不是 scalar 的输出，要 backward 的时候可以在`backward()`中传入一个向量$v$来计算$J^{T} \cdot \vec{v}$，也就是 l 对于 x 的梯度向量。

也就是当输出是一个向量的时候，反向传播用一个(或许是标签的)向量做 backward 的输入

最后是说在`with torch.no_grad()`的上下文中梯度将不被计算。

## NEURAL NETWORKS 神经网络

见 ipynb 文件

## Train a classifier 训练一个分类器

了解了如何定义一个网络，计算 loss，更新权重之后，想到了该如何找数据

对于数据的处理:

- 图像: Pillow(PIL), opencv
- 语音: scipy, librosa
- 文本: python 原生，nltk, spacy

specifically for 计算机视觉，torch 有一个专门的包叫做`torchvision`，可以加载数据集 such as Imagenet, CIFAR10, MNIST, etc. and data transformers for images, viz., `torchvision.datasets` and `torch.utils.data.DataLoader`.这样就不用写轮子了(writing boilerplate code)

接下来我们用 cifar10 数据集，`3 * 32 * 32`的图像，It has the classes: ‘airplane’, ‘automobile’, ‘bird’, ‘cat’, ‘deer’, ‘dog’, ‘frog’, ‘horse’, ‘ship’, ‘truck’.

## 关于 contiguous

这个单词的英文意思是连续的

pytorch 中很少几个操作是不会对**tensor 本身数据**进行修改的，而只是**重新定义下标与元素的对应关系**。改变的是**元数据**。

这些操作是: `narrow() view() expand() transpose()`

就拿转置来说，pytorch 不会新建转置后的 tensor，而只是修改原本 tensor 的一些元数据(属性)，使得转置后的 tensor 的 offset 和 stride 和原始 tensor 相对应，并且他们是**共享内存**的！

```python
In [8]: a = torch.Tensor([[1, 2, 3], [2, 4, 5]])
In [9]: a
Out[9]:
tensor([[ 1.,  2.,  3.],
        [ 2.,  4.,  5.]])
In [11]: b = a.transpose(0, 1)
In [12]: b
Out[12]:
tensor([[ 1.,  2.],
        [ 2.,  4.],
        [ 3.,  5.]])
In [14]: a[1, 2] = 555
In [15]: b
Out[15]:
tensor([[   1.,    2.],
        [   2.,    4.],
        [   3.,  555.]])
```

转置之后的到的 tensor 虽然看上去是一个 2 \* 3 的矩阵但是其内部的数据不是**连续分块**的，如果是直接生成这样一个矩阵，其内部数据在内存中按照行/列是连续的(具体不清楚，但可以类比 C++的原生数组)。所以这里的**contiguous**指的是数据在内存是否有序连续。

调用`contiguous`的时候会强制**copy**一份，让转置后的矩阵和新创建的是一模一样的，也不存在共享内存了。

如果在 view 等操作后报错，说不 contiguous 的时候调用即可。

```python
In [27]: b.view(1, -1)
------------------------------------------------------------
RuntimeError               Traceback (most recent call last)
<ipython-input-27-99d8d20de9ef> in <module>
----> 1 b.view(1, -1)

RuntimeError: invalid argument 2: view size is not compatible with input tensor's size and stride (at least one dimension spans across two contiguous subspaces). Call .contiguous() before .view(). at /opt/conda/conda-bld/pytorch_1524584710464/work/aten/src/TH/generic/THTensor.cpp:280
In [26]: b.contiguous().view(1, -1)
Out[26]: tensor([[   1.,    2.,    2.,    4.,    3.,  555.]])
```

P.S.其实可以看到 pytorch 的函数命名还挺有意思，view 和 numpy 的 reshape 效果一样，但是人家告诉你我只是改变了他的 view，你看到的形状变了，内部没变。

## 自定义数据集&加载 MNIST
