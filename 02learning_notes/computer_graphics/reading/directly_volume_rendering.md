## 视频学习 direct volume rendering

> 来自油管：https://www.youtube.com/watch?v=IqIvK6EiBz8

### 光照模型：

1. 光到 voxel（particle）经过吸收/反射的量，也就是透明度 alpha 或者 transpancy
   1. 公式推导
   2. 积分离散化
2. eye ray 到 particle 能得到的颜色（ray casting）
   1. shading：phong 模型
   2. classfication：transfer function
   3. blending
3. GPU 渲染管线
   1.

![image-20210415220637917](imgs/directly_volume_rendering.assets/image-20210415220637917.png)

![image-20210415220649125](imgs/directly_volume_rendering.assets/image-20210415220649125.png)

![image-20210415220655424](imgs/directly_volume_rendering.assets/image-20210415220655424.png)

![image-20210415220700520](imgs/directly_volume_rendering.assets/image-20210415220700520.png)
