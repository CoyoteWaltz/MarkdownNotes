# 图片相关

## webp

> 一种图片格式
>
> （我们需要关心）：
>
> - 是否是有损/无损压缩：可以是无损（lossless）也可以压缩成有损（lossy）
> - 压缩效率如何：无损 26%，有损 25%-34%

- 支持 alpha 通道，无损压缩需要额外 22% 的字节量。

压缩算法细节：https://developers.google.com/speed/webp/docs/compression

## Tiff

> **Tag Image File Format**
>
> TIFF is a mark-based file format that is widely used for the storage and conversion of images that require high image quality.
>
> 在 file header 中有 label，能在一个文件中处理多个图像
