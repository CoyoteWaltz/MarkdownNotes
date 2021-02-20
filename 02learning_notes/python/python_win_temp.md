### python 笔记 on windows

### 处理 xml 文件，处理标签

xml 是什么？

eXtensible Markup Language 可扩展标记语言

类似 html 标签一样，所以在遍历节点的时候可以和 html 有异曲同工之处

python 自带了一个 xml 的库，用其中的`xml.etree.ElementTree`类来解析 xml 文件。解析后返回的是这个 xml 文件的根标签的元素对象(和名字一样嘛，元素树)，有：

- `attrib`属性: 返回一个字典，键是属性名，值是属性值
- `text`属性: 返回这个标签包含的文字内容
- `tag`属性: 返回元素的标签名
- `append`方法: 参数是一个元素，也就是一个标签
- `find`方法: 传入的参数可以是 str，是一个标签名，返回第一个找到的标签元素
- `findall`方法: 也就是找到所有的标签，返回一个 list of element
- `getiterator`方法: 返回一个迭代器，迭代其所有子标签，这应该是我用的最多的一个方法了

TODO xml to dict

### os 模块

#### os.walk 遍历目录

os.walk(top, topdown=True, onerror=None, followlink=False)

参数说明:

- top: 遍历的目录
- topdown: 默认为 True 的话就有限遍历 top 目录，False 就最后遍历
- onerror: 传递一个回调函数，出现异常的时候会调用
- followlinks: 为 True 的话会遍历目录下的快捷方式，linux 下就是软连接

返回一个生成器，需要不断遍历来获得内容，迭代的对象是一个三元组(root, dirs, files):

- root: 正在遍历的 path 本身
- dirs: 一个 list，当前目录中的所有目录
- files: 一个 list，当前目录下的所有文件
