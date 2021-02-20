# PCA 白化，ZCA 白化

## what is 白化(whitening)

> A **whitening transformation** or **sphering transformation** is a [linear transformation](https://en.wikipedia.org/wiki/Linear_transformation) that transforms a vector of [random variables](https://en.wikipedia.org/wiki/Random_variables) with a known [covariance matrix](https://en.wikipedia.org/wiki/Covariance_matrix) into a set of new variables whose covariance is the [identity matrix](https://en.wikipedia.org/wiki/Identity_matrix), meaning that they are [uncorrelated](https://en.wikipedia.org/wiki/Uncorrelated) and each have [variance](https://en.wikipedia.org/wiki/Variance) (from 维基百科)

从维基百科摘了第一句解释，白化就是一个 decorrelation 的**线性变换**，变换后的数据各个维度之间互相独立，并且各维度的方差为 1(协方差矩阵为一个单位阵)。

**注意这也是一个线性变换！**很重要

想说说这个**sphering transformation**(球型变换?)，也是看到这个词才觉得非常生动形象。初始随机的数据在样本空间中的散布肯定都是比较抽象或者没有规律的，以二维数据为例，如果两个维度之间有关联，那么样本空间中呈现的数据分布应该会是一个椭圆，那么在经过白化变换之后，维度之间消除了关联，可以想象一下协方差的定义$E\{(x_1 - x_{\mu_1})(x_2-x_{\mu_2})\} $，在均值空间坐标系(以$(x_{\mu_1},x_{\mu_1})$为原点的坐标空间，自己取的名字)中的点在各个方向上都有分布，所以是一个圆了，也就是将原本杂乱的样本空间变换成了一个球状(超椭球)的分布，且半径为 1。

那这个球状分布需要满足的条件：各维度之间互相独立，方差都为 1。就是白化的步骤。

## PCA whitening

PCA 肯定都会了，很简单，PCA 之后的数据已经是维度间互相独立，PCA 白化就是在 PCA 基础之上使得标准差为 1。即$x_{PCAwhite,i} = \frac{x_{PCA}}{\sqrt{\lambda_{PCA,i}}}$，$\lambda_{PCA}$是每一维度的方差，也就是原始数据的协方差矩阵的特征值。

#### 算法步骤

1. 中心化之后的数据$X = X-mean_X$，计算协方差矩阵($X\in R^{m \times n}$是每行一个样本，列是特征)

   $$
   \Sigma_X = \frac{1}{m}X^{T}X
   $$

2. 对协方差矩阵做特征值分解

   $$
   [U, S] = eig(\Sigma_X)
   $$

3. PCA 降维之后乘以特征值矩阵 S 进行收缩方差
   $$
   X_{PCAwhite} = XU'S^{-\frac{1}{2}}
   $$
   $S^{\frac{1}{2}}$也就是特征值对角矩阵的开平方，可以证明得到的 PCA 白化数据是方差为 1 的，即协方差矩阵为单位阵(identity matrix)
   $$
   \begin{aligned}	\Sigma_{PCAwhite} &= \frac{1}{m}{X_{PCAwhite}}^{T}X_{PCAwhite} \\	&= \frac{1}{m} (S^{-\frac{1}{2}})^{T} U^{T} X^{T}XUS^{-\frac{1}{2}} \\	&= (S^{-\frac{1}{2}})^{T} U^{T} (\frac{1}{m} X^{T}X)US^{-\frac{1}{2}} \\	&= (S^{-\frac{1}{2}})^{T} U^{T} \Sigma_X US^{-\frac{1}{2}} \\	&= (S^{-\frac{1}{2}})^{T} U^{T} USU^T US^{-\frac{1}{2}} \\	&= (S^{-\frac{1}{2}})^{T}SS^{-\frac{1}{2}} \\	&= (S^{-\frac{1}{2}})SS^{-\frac{1}{2}} \\	&= I	\end{aligned}
   $$

所以 PCA 白化也就是将数据变换到主成分空间之后再做了一步缩放方差。

## ZCA whitening

#### ZCA zero-phase Component Analysis Whitening

零相位成分分析白化。。。

零相位是指对原始样本空间旋转相位为零，也就是最后不会旋转空间。

那么 ZCA 的做法也就是在 PCA 白化之后再利用特征矩阵$U$将数据变化到原始空间

$$
X_{ZCAwhite} = X_{PCAwhite}U
$$

可以证明协方差矩阵也是一个单位阵。(实现了白化)(Indeed, whitened data will stay whitened after any rotation.)

ZCA 白化线性变换可以用矩阵表示$W_{ZCA} = US^{-\frac{1}{2}}U$，这个矩阵不是正交的，应该是保持和原空间同一坐标轴方向，只是伸缩了大小。

#### P.S:

降不降维取决于用户自己。

ZCA transformation ([sometimes](https://www.google.com/search?q="Mahalanobis transformation") also called "Mahalanobis transformation") is that it results in whitened data that is as close as possible to the original data (in the least squares sense).居然也叫马氏变换。变换回原始空间的好处是可以保持数据的原始性质。

所以，所谓的马氏(Mahalanobis)方法就是将原始空间变换到另一个奇奇怪怪的空间(通常是主成分空间，当然也可以自己学习一个线性变换去发现这个空间)去做一些正常的操作(比如算欧氏距离)。。

问题来了，那么有没有直接做消除方差的方法(归一化?)，和 ZCA 有什么不同呢。

## 正则化

PCA 和 ZCA 白化都需要正则化，即在缩放方差的时候在分母上加上一个$\epsilon$:

$$
s^{\frac{1}{2}} = \left[	\begin{array}{ccc}		\frac{1}{\sqrt{\lambda_1 + \epsilon}} & 0 & 0 \\		0 & \ddots & 0 \\		0 & 0 & \frac{1}{\sqrt{\lambda_n + \epsilon}} \\	\end{array}\right]
$$

- 防止分母下溢为 0
- 对图像来说，正则化项对输入图像也有一些平滑去噪（或低通滤波）的作用，可改善学习到的特征。。

解释一下第二条

图片经过 PCA 白化之后，加入正则项之后的协方差矩阵为:

$$
\Sigma_{PCAwhite} = \left[	\begin{array}{ccc}		\frac{\lambda_1}{\lambda_1 + \epsilon} & 0 & 0 \\		0 & \ddots & 0 \\		0 & 0 & \frac{\lambda_n}{\lambda_n + \epsilon} \\	\end{array}\right]
$$

通过$S^{-\frac{1}{2}}SS^{-\frac{1}{2}}$得到。这样看方差其实都是小于一的，对于均值化后的像素图片来说，PCA 白化之后的每个像素的方差比 1 还小，相当于是降低了不确定度(方差)，因为噪音也就是像素突变的，拥有方差很大的像素点，这样解释应该说的明白。
