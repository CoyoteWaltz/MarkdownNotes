## Course13 Ray tracing 1

> 光线追踪～
>
> whitted style？

[toc]

### general

- basic theorem

### Why ray tracing

光栅化（rasterizing）：

- 全局效果处理不好
  - 软阴影：shadow mapping
  - 光线会反射一次以上的场景
    - glossy reflection：不是那么光滑的镜面，有高光
    - 间接光照
- 画质不太行
- 速度快，real-time

光线追踪（ray tracing）：

- 准确度高，速度慢，offline 的渲染
- 电影、视频的渲染，一帧就好几十万个 CPU 时间

***质量和速度的 tradeoff***

### Light rays

> 光线是肾摸？

在 CG 中的三个假设：

- 直线传播
- 光线不会发生碰撞

![image-20210303143125336](imgs/CG-intro-13-14.assets/image-20210303143125336.png)

***当你凝视深渊，深渊也凝视着你***

历史：

1968 Appel



![image-20210303150445014](imgs/CG-intro-13-14.assets/image-20210303150445014.png)

eye ray -> object -> shadow ray（判定可见性） -> shading



### Recursive (Whitted-Style) Ray Tracing

![image-20210303150928674](imgs/CG-intro-13-14.assets/image-20210303150928674.png)

递归。就是在任何一个点可以继续传播光线，着色也会发生变化

![image-20210303151117347](imgs/CG-intro-13-14.assets/image-20210303151117347.png)

内部二次弹射的光线的值，都加给最初的 primary ray

就是模拟光线不断的弹射

### Ray-surface intersection

> 光线和表面的交点怎么算？

光源 O

光的方向 d

t 时间的光线位置： O + td

#### 隐式表面

例如球的定义：隐函数表示

![image-20210303151723289](imgs/CG-intro-13-14.assets/image-20210303151723289.png)

解方程求时间 t

![image-20210303152100146](imgs/CG-intro-13-14.assets/image-20210303152100146.png)

所有的隐式表达的物体都能通过解函数的方式求光线的交点 O + td

![image-20210303152314717](imgs/CG-intro-13-14.assets/image-20210303152314717.png)

有意思的属性：

- 物体/图形内的一个点发出的光线（射线）与物体边界的交点一定是奇数个，反之是偶数个

#### 显式物体（三角形面）

> 一个个三角形面求交点？太慢了吧
>
> 1 个交点或者 0 个交点，忽略光线和平面完美平行的情况

可以这么拆分交点的问题：

1. 和三角形所在平面求交点（如何定义平面？）
2. 判断交点是否在三角形内部（好做）

**定义平面**

一个方向（法线） + 一个点（好像很熟悉，感觉大学教过啊-_-）

写成一个函数来表达

![image-20210303153107316](imgs/CG-intro-13-14.assets/image-20210303153107316.png)

![image-20210303153256788](imgs/CG-intro-13-14.assets/image-20210303153256788.png)

接着判断这个点是否在三角形内，能不能优化一下，一次性解？

![image-20210303153519483](imgs/CG-intro-13-14.assets/image-20210303153519483.png)

求解 t, b1, b2 三个未知量，下面那个定义的乱七八糟的方程组是一个 法则，反正能写出第一个等式的时候就用下面的这个方法来求解就完事了

- 求解得到 t，判定是光线
- **得到 b1, b2，判定是重心坐标，非负，且 (1 - b1 - b2) 也是 非负，就能判定点在三角形内部！**



### Accelerating Ray-Surface Intersection 加速！

> 为啥要加速？每个光线要和一个个的三角形求交点，还有多次弹射，也太慢了

#### Bounding Volumes

> 哦！这里是 volumne 的出现了，类似于 bounding box，不过这是立体的，包围盒/体

*用一个**体**去包围一个物体，如果一个光线连 bounding volume 都碰不到，那盒子里面的所有点肯定都碰不到！Object is fully contained in the volume. If it doesn’t hit the volume, it doesn’t hit the object*

通常我们用长方体作为包围盒，那么长方体是什么呢？（卧槽，简单又复杂的问题。。。）

- 可以理解是三个 oppositing surface 形成的交集

![image-20210303154732099](imgs/CG-intro-13-14.assets/image-20210303154732099.png)

我们通常用 AABB，是和三个轴对齐的包围盒

接着我们就可以看光线如何于 AABB 求交点了

#### Ray Intersection with Axis-Aligned Box

先看二维的 bounding box（两个对 slab 围城的交集）

![image-20210303155257282](imgs/CG-intro-13-14.assets/image-20210303155257282.png)

分别看两个对面，和光线相遇的分别的 tmin 和 tmax，也就是进入和离开的时间点，可以求两个线段的交集，为什么呢。

在三维的情况看：

![image-20210303155918370](imgs/CG-intro-13-14.assets/image-20210303155918370.png)

最后，当 t~enter~ < t~exit~ 就说明光线在盒子里呆了一段时间啦（很好理解），就是光线会照到盒子！

结论

![image-20210303161307004](imgs/CG-intro-13-14.assets/image-20210303161307004.png)

OK 基本上就是这么个回事了

最后看看几个前面提出的问题：

1. 为什么用 AABB 呢

![image-20210303161752627](imgs/CG-intro-13-14.assets/image-20210303161752627.png)

下节课，继续加速，和其他方法，以及如何使用 AABB

## Course14 Ray tracing 2











