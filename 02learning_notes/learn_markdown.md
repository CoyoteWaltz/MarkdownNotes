# Markdown 学习

    在博客园上使用markdown编辑，记录学习进度，以来日可以复习

## 前期准备

### 1. 安装 markdownpad2

    官网直接找下载安装，遇到bug他会自动提示信息，跟着提示去安装一些东西就好了。
    看了官网的介绍，结合自己的使用感觉，这种软件真的是良心啊，创造出给人带来便捷和快乐的软件才是程序员们最终的梦想吧！

---

## 语法

### 1. 标题

    # 这是一级标题
    ## 这是二级标题
    ### 这是三级标题
    #### 这是四级标题
    ##### 这是五级标题
    ###### 这是六级标题

**注意#后需要加空格(?)**

### 2. 字体

    **这是加粗的文字，快捷键ctrl+b**
    *这是斜体*
    ***斜体加粗文字***
    ~~加删除线的文字~~

### 3. 引用

    在引用的文字前加 >，可嵌套
    >引用的内容
    >>引用的内容
    >>>>>引用

效果如下：

> 引用的内容

> 这也是
>
> > 嵌套引用
> >
> > > 第三方

> 嵌套好像没什么卵用

### 4. 分割线

    三个或以上的-或者*
    ****
    -----

效果如下：

---

---

一样的

### 5. 插入图片与链接

####插入链接：
[链接名称]
(http://xxx 链接网址)
效果：
[Baidu]
(http://baidu.com)

注：Markdown 本身语法不支持链接在新页面中打开，貌似简书做了处理，是可以的。别的平台可能就不行了，如果想要在新页面中打开的话可以用 html 语言的 a 标签代替。

    <a href="超链接地址" target="_blank">超链接名</a>

例：
<a href="http://www.baidu.com" target="_blank">百度</a>

---

#### 插入网页上的图片：

    ![图片alt](图片地址 '图片title')
    图片alt就是显示在图片下面的文字，相当于对图片内容的解释。
    图片title是图片的标题，当鼠标移到图片上时显示的内容。title可加可不加

效果：
![hirose suzu](https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1547977755566&di=c816898e79099fa10ff063b6852b96cf&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201805%2F28%2F20180528042842_dhvks.jpeg "广濑丝丝")

#### 添加本地图片：

    暂时还没有找到好的解决方法，想办法把本地图上传到网上吧

### 6. 插入 gif 与视频

    在博客园的页面里可以插入gif，方法同插图片

效果：
![hirose suzu gif](http://m.qpic.cn/psb?/V122zFEU2iUhGv/ufHfwJgZFSIGcBN52ZCUXplM6SOaygQKD.F5ZVtBUao!/b/dH4BAAAAAAAA&bo=WgKVAQAAAAACh28!&rf=viewer_4)

<!--
这段内容不会显示在网页里
<iframe height=500 width=660 src="http://b-ssl.duitang.com/uploads/item/201804/30/20180430165358_SyKQP.thumb.700_0.gif">

-->

### 7. 列表

- 无序列表
  - 用 - + \* 都可以
  * 注意： 符号和内容之间要有一个空格

* 无序列表
  1.  用数字加点.
  2.  注意：点与内容之间要有空格
  3.  通过缩进可以达到等级标题的效果

### 8. 表格

    表头|表头|表头
    ---|：--:|---:
    内容|内容|内容
    内容|内容|内容

    第二行分割表头和内容。
    - 有一个就行，为了对齐，多加了几个
    文字默认居左
    -两边加：表示文字居中
    -右边加：表示文字居右
    注：原生的语法两边都要用 | 包起来。此处省略
    输完一行按shift+enter输入下一行，否则出不来效果的。

效果：

| 表头 | 年份 | 月份 |
| ---- | :--: | ---: |
| 内容 | 2019 |    1 |
| 哈哈 | 2088 |   22 |

### 9. 代码框

    `这是代码框`

效果：

`这是单行代码框hello world`

    代码块用两个(```)包住

效果：

```
#include <string>
int main(){
	return 0;
}
```

<!--
被包住的地方不用强行换行
-->

### 10. 隐藏内容

    <!--
    这段内容不会显示在网页里
    -->
