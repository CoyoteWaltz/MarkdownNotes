# Python 学习笔记

​ python 语法、模块杂记

---

[TOC]

---

### 在 jupyter-notebook 中添加环境

系统环境 Ubuntu 18.04
先在已经激活的环境中安装 ipykernel，`conda install ipykernel`
然后`python -m ipykernel install --name [当前环境名称]`
此时会报错*[Errno 13] Permission denied: '/usr/local/share/jupyter'*
加上`--user`之后即可，`python -m ipykernel install --name [当前环境名称] --user`
之后就会在 jupyter notebook 中出现新的环境啦。

---

### jupyter 服务器开启远程连接

- step1 打开 ipython 为 jupyter 添加密码

```python
from notebook.auth import passwd
passwd()
```

输入两次密码后在终端输入，记得要复制 ash 密钥

```shell
jupyter notebook --generate-config
```

生成配置文件，在主目录下的.jupyter 文件有 jupyter_notebook_config.py

- step2 修改配置文件内容

```python
c.NotebookApp.ip = '*'
#设置可访问的ip为任意。
c.NotebookApp.open_browser = False
#设置默认不打开浏览器
c.NotebookApp.password = '第2步生成的密文'
c.NotebookApp.port = 9999
c.NotebookApp.notebook_dir = '/your/file/saved/path/'
```

可能会用到

```python
c.NotebookApp.allow_remote_access = True
c.NotebookApp.root = True
```

- step3 开启 jupyter note

后台开启服务

```shell
nohup jupyter notebook >/dev/null 2>&1 &
```

之后就能在没有 python 的环境下打开浏览器访问远程服务器的 jupyter notebook 了

---

### 字符串前的 r,u,b

1.字符串前加 r
强制不转义，认为字符串中的所有字符都是他本身。例如`r't\tdsf'`打印出来就是`'t\tdsf'`。
`\f`表示换页符。

2.字符串前加 u
表示字符串是 Unicode 编码的，Python3 中默认所有字符串编码都是 Unicode，所以等效。

2.字符串前加 b
表示是**bytes**类型的（python3 才有），二进制编码字符串，为了兼容 python2。

---

### 字符串拼接

#### format

熟知:`"{}".format(xxx)`

巧用:指定所占字符个数`{:25s}:{:2.3f}.format("sss", 0.12313)`，一目了然吧字符位数和类型，我感觉是比纯占位符牛逼多了

---

### 函数名后的->

第一次看到这个箭头以为是写错了，和 c 佳佳中的指针一样，然后去搜索了一下，这个箭头写在函数后指名了函数返回值的类型。
例如

```python
def less_than_200(x) -> int:
    return x < 200
```

至于会不会强制转换，我感觉不会....应该只是起到提示返回类型的作用吧

---

### min, max, sort, ... 中的 default

传入的 default obj 在这些函数传入的可迭代对象为空的时候返回。这样做的用处就避免了出现 ValueError 的异常

```python
a = []
min(a)		# 这样会报错
min(a, default=-10)
```

---

### 几个内置高阶函数 map, iter, reduce, filter

#### map

映射函数, `map(function, *iterable)`需要传入一个 function 和**可迭代对象**(可以是多个)
iterable 对象的个数由 function 的参数个数来决定，例子:`map(lambda x, y : x+y, range(10), range(20)`，得到的结果是一个**map 对象**可以通过 list 转换或者 for 或者 next()来迭代，**只是一次性的！我猜是个生成器**，如果多个可迭代对象的长度不同，会按照最短的来处理(**python3**)，python2 中 map 返回一个 list，不多了解。

map 不迭代的话不会生产面包，也就是不会执行函数。

#### iter

用法:

- `iter(object)`

  - object 是一个集合对象，可迭代或者是序列，也就是实现了`__iter__()`或者`__getitem__()`方法，如果这两个函数都有，优先调用`__iter__()`
  - return an iterator object

  ```python
  l = [1, 2, 3, 4]
  for i in iter(l):
      print(i)
  ```

- `iter(object, sentinel)` sentinel:哨兵的意思

  - 此时的 object 一定要是可以 call 的也就是有实现了`__call__()`方法
  - call 的时候不带参数，调用他的`__next__()`，如果返回的值和 sentinel 相等，就 StopIteration

  ```python
  class IterTest(object):

      def __init__(self):
          self.s = [1, 2, 3, 4]
          self.it = iter(self.s)  # 返回一个迭代器

      def __getitem__(self, key):
          print("call getitem")
          return self.s[key]

      def __iter__(self):
          print("call iter")
          return self.it

      def __call__(self):
          print("call me")
          return next(self.it)
  itt = IterTest()
  t = iter(itt, 4)
  print(type(t))
  for i in t:
      print(i)
  '''
  <class 'callable_iterator'>
  call me
  1
  call me
  2
  call me
  3
  call me   # 可见应该返回4的时候next就报错了
  '''
  ```

#### reduce

#### filter

过滤一个可迭代对象，返回一个迭代器

`filter(function: Callable[[_T], Any], **iterable**: Iterable[_T], /) -> Iterator[_T]`

第一个函数相当于是一个一元谓词，返回真(True, ..)的时候保留这个对象，否则就跳过。

---

### 内置函数 exec

简单来说就是执行(execute)一句 str，`exec(object[, globals[, locals]])`

globals 和 locals 参数可以是`globals()`和`locals()`，这两个返回都是字典，全局变量和局部变量。

---

### 内置函数 hasattr, getattr, setattr

#### hasattr(obj, name)

判断一个对象中是否存在名字为 name 的属性(或者方法)，返回布尔值

#### getattr(obj, name [, default])

获取对象的属性，分两种情况，如果属性有默认值则得到默认值，如果给定了默认值就会获得默认值，如果属性不存在也不会添加新的属性；getattr 的是成员方法，可以加()来调用，但一定要是实例(因为有 self，否则要用@classmethod 来装饰)

#### setattr(obj, name, value)

为属性设置值，如果没有属性会为其添加

```python
class Apple():
    color = "red"
    def __init__(self):
        self.core = 22

    def eat(self):
        print("apple is delicious")

print(hasattr(Apple, "color"))
print(hasattr(Apple(), "eat"))  # 要实例才会初始化
a = Apple()
print(getattr(a, "core"))
getattr(Apple(), "eat")()

setattr(a, "color", "black")
print(a.color)
```

---

### try/finally 捕获异常

try 来抛出异常，except 来捕获，finally 做清理工作是无论如何都会执行的。

```python
def func1():
    try:
        return 1
    finally:
        return 2

def func2():
    try:
        raise ValueError()
    except:
        return 1
    finally:
        return 3

print(func1())
print(func2())
```

func1()的打印结果为 2，func2()的结果为 3
finally 执行在所有的 return 之前，funct1 中在`return 1`之前就 finally: return 3 了。func2 中 except 捕捉到了异常，然后想要 return 1，但是先执行了 finally，然后 return 1 被忽略了（直接 return 3 出去了），所以不推荐在 finally 中加入 return 语句！

---

### with 上下文管理

经常在文件操作的时候会用到 with 模块，比如

```python
with open(filename, 'r') as f:
	data = f.read()
```

那个时候只知道用 with 可以在恰当的时候帮我们执行`f.close()`，后来一次写数据库的时候也遇到了要连接数据库和关闭数据库的操作，于是网上看到一个方法可以使用 with 封装，通过一个类的**enter**()和**exit**()方法来管理 context 的进入和退出。
**`__enter__`**进入 context，return 值就是**as**后的对象，之后在 context 中即可对这个对象进行各种操作
**`__exit__`**离开上下文，参数必须有*exc_t, exc_v, traceback*并不了解这有什么用，但必须写着，之后可以在函数中定义结束上下文之后需要执行的操作了。

一个 with 连接数据库的例子

```python
class MyDataBase():
    # 封装一个数据库类，可以实现用with来操作
    def __init__(self, host, port, user, password, database, charset='utf8'):
        self._conn = MySQLdb.connect(
            host=host,
            port=port,
            user=user,
            password=password,
            database=database,
            charset=charset
        )
        self.cs = self._conn.cursor()
    def __enter__(self):
        # 上下文属性
        # print('进入上下文')
        # with 上下文as的对象就是这里返回的值
        return self.cs

    def __exit__(self, exc_t, exc_v, traceback):
        # print('exc_t:', exc_t)  None
        # print('exc_v:', exc_v)
        # print('traceback:', traceback)
        # print('结束上下文')
        self._conn.commit()
        self.cs.close()
        self._conn.close()
```

用法

```python
 with MyDataBase('localhost', 3306, 'root', 'lijingwei', 'testsss') as cs:
     cla = ['1022', '1023', '1222']
     for c in cla:
         cs.execute(sql[1].format(c))
     cs.execute(sql[0])
     cont = cs.fetchall()
     print(cont)
```

这是一种写一个类，重写两个进入和离开函数的方法实现 with 管理上下文。

不过标准库中提供了 contextlib 模块，更加方便管理上下文。
看一个简单的例子

```python
from contextlib import contextmanager

@contextmanager
def make_open_context(filename, mode):
    fp = open(filename, mode)
    try:
        yield fp
    finally:
        fp.close()

with make_open_context('/tmp/a.txt', 'a') as file_obj:
    file_obj.write("hello carson666")
```

其实这里的**make_open_context**函数是个生成器，有**yield**!这里的 yield 其实也是上下文的一个分割点，yield 前面的所有部分是**enter**()中会做的事情，同时 yield 返回一个句柄 handle，finally 之后的是退出 context 的操作。句柄可以在 context 里面被执行，一旦执行结束就触发 finally。

使用 contextlib 的好处：不用重写**enter**和**exit**函数，在一些框架中比如 Flask，就需要重写源码了。。。所以用 contextlib 写个生成器就好了

---

### [OOP]property 装饰器

类中的 property 装饰器起到了让一个函数成为一个类属性的作用，在用到 protected 或者 private 的类属性时，要获得这个值必须要定义外部访问接口函数，用 property 可以让这个函数变成一个属性的样子来访问，实际还是执行了函数。看个例子

```python
@property
def password(self):
    return self.__password if self.__password else None
```

通过`client.password`即可获得，符合了**统一访问原则**。属性名就是函数名，用属性名对应的方法的返回值作为属性值。
有的时候我们要给密码赋值`client.password = pwd`，注意此时的 password 是一个 property，赋值会调用一个自定义的设置方法，需要一个装饰器**@password.setter**表示对于 password 属性可以进行设置，调用下面的方法

```python
@password.setter
def password(self, value):
    self.__password = value  # 简单的写
```

先 property 才有对应的 setter
不想让人读取属性`raise AttributeError("can not read, only setting")`

---

### [OOP]staticmethod 和 classmethod 装饰器

staticmethod 叫做**静态方法**，和 C++里面的静态成员函数一样。
classmethod 叫做**类方法**。
两者都可以通过 ClassName.method()直接访问

staticmethod 装饰的静态函数参数中不需要加*self*，C++中其实也没有*this*指针。

classmethod 装饰的类函数中也不需要*self*，而是要传入一个实例作为参数，比如"cls"，然后对实例进行操作(调用 cls)，防止硬编码。

小结：staticmethod 不多说。classmethod 的用处在于可以不用实例化对象而操作成员函数(当实例对象会产生很大数据量的时候)

ps:才发现，原来成员函数的 self 不是固定死的，也就是可以换成别的名字，比如 this，也就普通成员函数只是规定了第一个参数是指向实例本身的引用，而不是 c++那样连名字 this 也规定了的！

---

### logging 模块

Python 自带的一个日志库，flask 自己的 logging 也用到了这个库，简要记录一下怎么使用这个库。

#### 日志级别

6 种日志级别(分别对应了不同的数值)
NOTSET(0)
DEBUG(10)
INFO(20)
WARNING(30)
ERROR(40)
CRITICAL(50)
越 important 值越大，也可以自定义级别，但是注意不要让数值重复。
日志器设置的**level**会使得大于这个 level 的都会记录。比如设置`level=logging.INFO`之后，warn，error，critical 的日志都会被记录。

#### logging 流程

简单来说，有一个**Handler**来控制日志会去向什么文件，**Filter**决定哪些日志会被输出，**Formatter**决定了输出日志的格式

#### 配置一个日志输出

使用`logging.basicConfig()`方法，有参数:

```json
filename: 输出到的文件名称
filemode: 文件模式 r[+] w[+] a[+]
format: 日志输出的格式（见下面的Formatter）
datafmt: 日志日期时间的格式
style: 格式占位符 默认为% 和 {}
level: 设置(最低)日志输出级别
stream: 定义输出流 不能和filename一起用
handlers: 定义处理器 不能与filename和stream一起
```

#### 自定义一个 logger

一个系统只有一个**根**Logger 对象，且这个对象不能被直接实例化，单例模式！只能通过`logging.getLogger()`来获取这个 logger，一个 logger 可以有多个 Handler 和 Filter，Handler 又可以设置 Formatter 对象。

#### Formatter

参数

```
asctime %(asctime)s 将日志的时间构造成可读的形式，默认情况下是精确到毫秒，如 2018-10-13 23:24:57,832，可以额外指定 datefmt 参数来指定该变量的格式

name %(name) 日志对象的名称

filename %(filename)s 不包含路径的文件名

pathname %(pathname)s 包含路径的文件名

funcName %(funcName)s 日志记录所在的函数名

levelname %(levelname)s 日志的级别名称

message %(message)s 具体的日志信息

lineno %(lineno)d 日志记录所在的行号

pathname %(pathname)s 完整路径

process %(process)d 当前进程ID

processName %(processName)s 当前进程名称

thread %(thread)d 当前线程ID

threadNam %threadName)s 当前线程名称
```

#### Handler

在`logging.handlers`中提供了很多 handler(类)，当然不能去一一了解到，只是简单先了解了一个
**RotatingFileHandler**参数有
`filename, mode='a', maxBytes=0, backupCount=0, encoding=None, delay=False`
backupCount 是存在文件的最大数量，delay 如果是 True 那只有调用 emit()方法的时候才会写入文件，默认 False 是有日志产生就写入。

#### 实例

```python
# 设置日志等级
logging.basicConfig(level=logging.DEBUG)
# 创建日志记录器 指明日志保存的路径 每个文件的最大字节数 5mb  可存在的最大文件数量 5
file_log_handler = RotatingFileHandler("/log/webox_log", maxBytes=1024*1024*5, backupCount=5)
# 创建日志记录的格式                 时间-[日志等级]--|产生记录的文件|->第几行: 日志信息
formatter = logging.Formatter("%(asctime)s-[%(levalname)s]--|%(filename)s|->%(lineno)d: %(message)s")
# 为日志记录器设置日志格式
file_log_handler.setFormatter(formatter)
# 为全局的日志工具对象(flask app使用的) 添加日志记录器
logging.getLogger().addHandler(file_log_handler)
```

Flask 自己也调用了 logging 模块作为日志记录(print)，我们可以 TODO

---

### PIL 模块

pillow 模块，做简单图像处理的，肯定是没有 opencv 牛逼，但是在写 flask 框架的时候用到他来做验证码图片了，简单记录一下。

`from PIL import Image, ImageFont, ImageDraw, ImageFilter`都是 oop
构造一个画板`img = Image.new("RGB", (宽, 高), 背景色)`
设置字体`font = ImageFont.truetype('UbuntuMono-RI', 40)`这里的 UbuntuMono-RI 对应了在 ubuntu 系统字体文件中的 UbuntuMono-RI.ttf，可以通过 fc-list 来查看有哪些字体。

```python
# 初始化图片 和 画笔
img = Image.new("RGB", (self.width, self.height), "black")
draw = ImageDraw.Draw(self.img)
```

通过画笔来花各种 text、point、line......
图片添加过滤器(滤镜)`img = img.filter(ImageFilter.SHARPEN)`
展示图片`img.show()`
最后可以保存图片为内存中二进制或者文件
`buffer = BytesIO()` 从 io 模块导入
`img.save(buffer, "jpeg")`

生成验证码的完整代码

```python
# coding:utf-8

# 验证码图片生成器

import random
from io import BytesIO

from PIL import Image, ImageFont, ImageDraw, ImageFilter


class Captcha(object):
    """
    验证码类
    """
    charset = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

    def __init__(self, width=130, height=50, length=4):
        """
        初始化函数
        :param: width height length: 图片宽、高、字符长度
        :return: text: 字符串值 img: 图片二进制
        """
        self.width = width
        self.height = height
        self.length = length
        self.font = ImageFont.truetype('UbuntuMono-RI', 40)


    def initialize(self):
        # 初始化图片 和 画笔
        self.img = Image.new("RGB", (self.width, self.height), "black")
        self.draw = ImageDraw.Draw(self.img)


    @staticmethod
    def rnd_color_light():
    # 随机颜色 亮
        return (random.randint(64, 255), random.randint(64, 255), random.randint(64, 255))

    @staticmethod
    def rnd_color_dark():
    # 随机颜色 暗色
        return (random.randint(64, 255), random.randint(64, 255), random.randint(64, 255))

    def draw_text(self):
        # 画字符
        text = ""

        for item in range(self.length):
            char = random.choice(self.charset)
            text += char
            x = 5 + random.randint(4, 8) + 20 * item
            y = 5 + random.randint(1, 10)
            self.draw.text((x, y), char, fill=self.rnd_color_light(), font=self.font)

        return text

    def add_noise(self):
        # 加noise
        for num in range(8):
            x1 = random.randint(0, self.width / 2)
            y1 = random.randint(0, self.height / 2)
            x2 = random.randint(0, self.width)
            y2 = random.randint(self.height / 2, self.height)
            # 加 线
            self.draw.line(((x1, y1), (x2, y2)), fill=self.rnd_color_light(), width=1)

            # 画点
            for i in range(15):
                x = random.randint(0, self.width)
                y = random.randint(0, self.height)
                self.draw.point((x, y), fill=self.rnd_color_dark())


    def generate_captcha(self):
        """
        生成验证码图片
        :return: text: 验证码真实值
                self.img
        """
        self.initialize()
        text = self.draw_text()
        self.add_noise()
        self.img = self.img.filter(ImageFilter.SHARPEN)

        buffer = BytesIO()
        self.img.save(buffer, "jpeg")
        self.img.show()

        return text, buffer.getvalue()


# 默认构造一个实例
captcha_instance = Captcha()



if __name__ == "__main__":

    for i in range(3):
        text, img = captcha_instance.generate_captcha()
        print(text)
        print(img)
    # captcha.generate_captcha()

```

---

### redis 模块

在 Python 中使用 redis，关于 redis[来自 cnblog](https://www.cnblogs.com/linkworld/p/7808818.html)
安装很简单
python 中
`import redis`导入模块
`redis_store = redis.StrictRedis(host="127.0.0.1", port=6379)`生成实例 端口默认 6379
`redis_store.set("key", "value")`设置键值对
`v = redis_store.get("key")`获取 如果没有返回`None`
`redis_store.expire(key, 123`设置有效时间 单位秒
也可以一起设置`redis_store.setex(key, constants.CAPTCHA_REDIS_EXPIRES, text)`
`redis_store.delete("key")`删除键和值

---

### SQLalchemy 模块

实现 python 的的 ORM(Object Relational Mapper)对象关系映射，associating user-defined Python classes with database tables, 关键就是建立关系型数据库的 ORM 模型。那就重点记录这一块的内容。(前提已知你会关系型数据库，懂数据库的基础知识)

1.首先连接数据库

```python
>>> from sqlalchemy import create_engine
>>> engine = create_engine('mysql:/user:password@hostname/dbname:', echo=True, encoding='utf8')
```

`Column`是生成字段的对象，`Integer`,`String`等等是数据类型的对象，`Base`是一个基类，自定义的类需要继承他

```python

2.声明一个对象映射(在python中写一个类)
# 摘自官网
>>> from sqlalchemy import Column, Integer, String
>>> class User(Base):
...     __tablename__ = 'users'
...
...     id = Column(Integer, primary_key=True)
...     name = Column(String)
...     fullname = Column(String)
...     nickname = Column(String)
...
```

常用属性:
primary_key
unique
index 如果为 true 为这列创建下标，查询会快
nullable
default

3.在所连接的数据库中根据自定义类创建数据表
`Base.metadata.create_all(engine)`

4.生成一个对象(instance)
就和实例化一个类是一回事情

5.创建一个会话 用来增 改

```python
>>> from sqlalchemy.orm import sessionmaker
>>> Session = sessionmaker(bind=engine)
```

6.Adding and Updating objects
增加一个`session.add(ed_user)`
增加全部`session.add_all(list)`
如果 add 完之后想修改对象，直接改就行，session 会 pay attention，可以用`session.dirty`查看修改的地方，`session.new`查看新增对象?。
最后提交`session.commit()`。此时已经插入数据库了，可以看看 id 了，之前是没有的。

7.回滚(Rolling Back)
回到上次的 transcation，也就是上一个 add 可以被撤销。`session.rollback()`

8.Query!
详见 flask 笔记
补充 filter 中可以加 Operator(针对 column):
like == != in* ~in* and* or*详见[官网](https://docs.sqlalchemy.org/en/13/orm/tutorial.html)

9.Relationship 多对多 1 对多关系！！外键
关系算是关系型数据库最重要的一个部分了吧，sqlalchemy 也提供了实现关系联动非常容易的方法，**relationship**方法。

9.1 一对多 one to many
显然*多*的地方要有*一*的**外键 Foreign key**。那么*一*想获得所有拥有*一*的属性的*多*，可以通过在*一*中有`many = relationship("Many", back_populates="one")`back_populates 提供了双向访问，参数是一个 str 名称，是*多*里面的*一*的属性(此处存疑)，同样在*多*里面想访问到外键所对应的*一*也可以这样。
所以*一*可以得到一个*多*的 list，*多*只会获得一个外键对应的*一*。
backref 可以实现单向的，用处是一样的，好处是只需指名一处的关系，用 backref="xxx"做反引用就能在*多*的地方用 xxx 了，back_populates 是在 backref 之后出来的新属性。

9.2 多对多
有一个**association table**，也就是第三张关系表，来个官网的例子

```python
association_table = Table('association', Base.metadata,
    Column('left_id', Integer, ForeignKey('left.id')),
    Column('right_id', Integer, ForeignKey('right.id'))
)

class Parent(Base):
    __tablename__ = 'left'
    id = Column(Integer, primary_key=True)
    children = relationship(
        "Child",
        secondary=association_table,
        back_populates="parents")

class Child(Base):
    __tablename__ = 'right'
    id = Column(Integer, primary_key=True)
    parents = relationship(
        "Parent",
        secondary=association_table,
        back_populates="children")
```

在 relationship 中多了个 secondary 属性指向第三张表的实例对象。
关于外键的**ON DELETE CASCADE**，在 relationship 方法中**passive_deletes**如果给 True，那么就会有*一*删了*多*也一起删。

9.3 如果出现一个*多*有多个*一*的情况
relationship 的关系要指名是哪一个外键
`primaryjoin="Xxx.yyy_id == Yyy.id"`

10(9.4) 多对多的第三章表
出现多对多的情况: 第三张表之后存放两个 FK
例如

```python
# 中间表 记录用户历史
dorm_user = db.Table(
    "dorm2user",
    db.Column("user_id", db.Integer, db.ForeignKey("user.id"), primary_key=True), # 订单id
    db.Column("dorm_id", db.Integer, db.ForeignKey("dormitory.id"), primary_key=True), # 商品详情id
)
```

多对多的添加
首先 User 中有
`history_dorm = db.relationship("Dormitory", secondary=dorm_user) `
实例化一个 User 对象 user 之后，再有一个 Domitory 实例 dorm 之后，`user.history_dorm.append(dorm)`就可以了，实际上 history_dorm 就是个 list，也可以直接赋值给他一个 dorm 实例的 list。数据库的第三张表里就新增了一行数据。并且这个 list 在 append 的时候会自动去重，也就是不会重复添加。

---

### uuid 模块

UUID（Universally Unique Identifier）是通用唯一识别码，在许多领域用作标识，比如我们常用的数据库也可以用它来作为主键，原理上它是可以对任何东西进行唯一的编码的。

不管那么多，拿来用就行了

```python
import uuid
print(
	uuid.uuid1(),
 	uuid.uuid3(uuid.NAMESPACE_DNS, "sdfsdf"),
 	uuid.uuid4(),
 	uuid.uuid5(uuid.NAMESPACE_DNS, "sdfsdf")
 )
```

uuid1()：这个是根据当前的时间戳和 MAC 地址生成的，最后的 12 个字符 408d5c985711 对应的就是 MAC 地址，因为是 MAC 地址，那么唯一性应该不用说了。但是生成后暴露了 MAC 地址这就很不好了。

uuid3()：里面的 namespace 和具体的字符串都是我们指定的，然后呢···应该是通过 MD5 生成的，这个我们也很少用到，莫名其妙的感觉。

uuid4()：这是基于随机数的 uuid，既然是随机就有可能真的遇到相同的，但这就像中奖似的，几率超小，因为是随机而且使用还方便，所以使用这个的还是比较多的。

uuid5()：这个看起来和 uuid3()貌似并没有什么不同，写法一样，也是由用户来指定 namespace 和字符串，不过这里用的散列并不是 MD5，而是 SHA1.

获得的字符串由"-"连接

---

### time 模块

Python 内置的时间模块

##### struct_time

一个结构化时间 class，函数*gmtime()*, _localtime()_, *strptime()*的返回类型，通过*named tuple*(index 可访问)构成，有：

```python
tm_year = "年份"
tm_mon = "月份 1-12"
tm_mday = "几号"
tm_hour = "小时"
tm_min = "分钟"
tm_sec = "秒"
tm_wday = "周几"
tm_yday = "一年中的第几天"
tm_isdst = ""
tm_zone = ""
tm_gmtoff = ""

time.time() # 时间戳　1970年到现在的秒数
print(time.clock())    # cpu时钟执行时间
print(time.gmtime())   # 将参数second转换为UTC时间的结构化时间，默认为time.time() UTC时间戳
# time.struct_time(tm_year=2019, tm_mon=4, tm_mday=3,
print(time.strftime('%Y %m %d %H %M %z', time.localtime()))
a = time.strptime('2019-01-21', '%Y-%m-%d')     # 格式化时间字符串转换为结构化时间
time.ctime(1231231231)      # second(float) to str of date
time.ctime()                # default: second = time.time()
time.mktime(time.localtime())  # convert timestruct to seconds from the Epch
# 我为什么要用英文？
```

---

### pandas 模块

内容应该有点多，因为都是很多函数的的使用方法，因为大三上了一门叫做数据分析的课程，从 python-numpy-pandas-sklearn 的使用-一些机器学习算法的内容全面铺开，一共 2000 多页的 ppt，是在是很多很全面很详细，但也不太好，还不如让我们实战操作一下感受一下数据分析的整个流程。

开始吧。

#### 前言

数据分析非常使用的库，对于数据清洗和分析很便捷。其中的数据类型都是 numpy 的数据类型

#### 基本数据结构 Series & DataFrame

Series:

- 构造

似一维数组(Series 固然是有序的嘛)的对象，index+value，构造的时候可以指定 index

```python
In [2]: a = pd.Series([4, 4, 1, 2])

In [3]: a
Out[3]:
0    4
1    4
2    1
3    2
dtype: int64
In [7]: a = pd.Series([4, 4, 1, 2], index=['e', 'q', 't', 'd'])
In [8]: a
Out[8]:
e    4
q    4
t    1
d    2
dtype: int64
```

- 通过 values 和 index**属性**获得值和下标

```python
In [4]: a.values
Out[4]: array([4, 4, 1, 2])
In [5]: a.index     	# 可以[]索引获得值 但不是mutable的
Out[5]: RangeIndex(start=0, stop=4, step=1) # 这个东西向数组一样
```

可以和用下标索引`a['d']`或者`a[['e', 'd']]`，类似 numpy 数组，不多举例子了

可以把 Series 看成是**定长**的 orderedDictionary，索引:值的键值对。同时呢，可以用 python 的字典来初始化一个 Series，索引就是字典键的顺序。有一种情况是给定了字典，但是 index 是自己规定的，就以下标为准，下标和字典中的 key 没有匹配的时候就给 NaN 这个值*(Not A Number)*。

```python
In [16]: d = {'a' : 2, 'm':4, 'o' : 12}
In [17]: b = pd.Series(d, index=['p', 'l'])
In [18]: b
Out[18]:
p   NaN
l   NaN
dtype: float64
```

- 检查缺失值

`pd.isnull(obj)`返回的值是 bool 类型

或者直接调用自身的`series.isnull()`

- 加法运算会自动对齐匹配相同的索引
- 对象可以起名字`b.name = "name"`
- index 可以原地修改，但是只能整个改`a.index = [3, 4, 5, 6]`，但是数量一定要匹配不然报错 ValueError

DataFrame:

非常重要的数据结构，类似二维数组(矩阵)，一般文件读完都是这个东西

- 创建

因为是二位的所以可以用字典，key : list 的方式创建，同样可以用 numpy 二位数组构造，可以指定 index 和 columns`frame = pd.DataFrame(np.arange(9).reshape((3, 3)), index=['a', 'c', 'd'], columns=['Ohio', 'Texas', 'California'])`

- head()方法: 选取前五行数据展示

- 指定列创建: `pd.DataFrame(data, columns=['a', 'b', 'e'])`，这些列其实就会去匹配字典中的键，如果没有匹配到，那么这一列的元素都是 NaN

- 获取列的方法，列的类型其实是 Series，均可直接修改:

  - 类似字典`['column']`
  - 类似属性`.column`
  - loc['column'] 方法
  - iloc[index]

- 创建新列: 类似字典，但是用类似属性的方式不行(因为原本没有这个新的属性啊)

- 转置: data.T

```python
Out[8]:
         major  tag
0     思想政治教育专业   政治
1     思想政治教育专业   教育
2  思想政治教育专业(理)   政治
3  思想政治教育专业(理)   教育
4           哲学   美学
In [9]: d.T
Out[9]:
             0         1   ...                83             84
major  思想政治教育专业  思想政治教育专业  ...  信息资源管理(授管理学学士学位)  知识产权(授法学学士学位)
tag         政治        教育  ...                管理             法律
[2 rows x 85 columns]
```

- 获取每一行 values()方法: 返回的是每一行构成的 list，其中每一行的所有值也是 list

Index:

索引对象，对象负责管理轴标签和其他元数据(比如轴名称等)。构建 Series 或 DataFrame 时,所用到的任何数组或其他序列的标签都会被转换成一个 Index。

- 类似数组
- non-mutable 的
- 可包含重复元素
- append()方法: 连接两个 Index
- difference(): 计算差集返回新的 Index
- intersection(): 计算交集
- union(): 计算并集

#### 基本功能

- reindex: 重新索引`obj.reindex(range(6), method='ffill')`，method 的作用是处理新增项目的方法(新索引长度大于原长度)，*ffil*应该是 forward fill 向前填充，经实验，ffill 是从原索引的位置向前后铺开的，看例子。**注意 reindex 不是原地修改，是返回修改后的对象**。

```python
In [42]: a
Out[42]:
3    4
4    1
5    2
6    5
dtype: int64
In [43]: a.reindex(range(7), method='ffill')  # 同样可以传入fill_value的值来解决空数据问题
Out[43]:
0    NaN
1    NaN
2    NaN
3    4.0
4    1.0
5    2.0
6    5.0
dtype: float64
```

- reindex(): 还可以重新索引 columns，`d.reindex(columns=[1, 2])`，效果一样，如果和原来的列不一样，就会变成 NaN
- drop(): 丢弃索引/列所在的值 `d.drop(['index/column'])`，默认是`axis=0`，也就是行，要列的话必须`axis=1`或者`axis='columns'`，返回修改结果
  - 参数 inplace: 如果为`True`，原地修改，返回 None
- loc[]: 对行的索引`d.loc["index"]`，定位某行的几列元素`d.loc["index", ["column1", "column1"]]`
- iloc[]: 和上面的一样，但是严格在 index locate 上面，index 必须是 int
- 加减乘除操作:
  - `+`: 如果索引是各自独立的，最后结果会保留索引，但是值全为 NaN
  - df.add()方法: 传入 fill_value 属性可以解决 NaN 的问题，`df1.add(df2, fill_value=0)`
- apply(): 类似 python 的 map，`d.apply(lambda x: x + 1)`将所有元素映射，df 中默认是按照列的，可以指定 axis。
  - 格式化浮点数字符串: `lambda x: "%.2f"%x`
- Series.map(): 用法是获得 df 中一列然后将这一列做 map，`d.major.map(lambda x:len(x))`
- sort_index(): 排序索引，返回排序后的对象，指定是否升序`ascending`，在 df 上可以指定`axis`
- sort_values(): 排序值，同上，缺失值会放到最后。不同之处是 df 中必须加入`by="column"`指定按照哪一列排序，可以传递 list 指定多个列，但是好像没什么用，试了一下结果还是按照 list 的第一个排序的
- rank(): 分配一个平均排名？返回带有排名的对象，有 method 参数:
  - methos='average': 默认情况，三个人里面前两个并列第一，分不清第一第二，就将两个人的排名加起来再平均。(1 + 2) / 2 = 1.5
  - methos='first': 并列，先来的先排名
  - methos='max': 两个人并列
  - methos='min': 两个并列第一，下一个是第三
  - methos='dense': 两个并列第一，下一个是第二，比较 danse 的排名
- is_unique**属性**: 告诉你这个列/Series 是否有各不相同
- sum(): 求和，可指定 axis，默认按`axis=0`
- mean(): 求均值，同上 axis
- idxmax()和 idxmin(): 返回最大/最小值的索引
- describe(): 返回一个汇总统计

```python
In [109]: p.describe()
Out[109]:
              0         1         2
count  3.000000  3.000000  3.000000
mean  -0.798408 -0.595752  1.333333
std    0.611495  2.385833  0.577350
min   -1.496926 -2.143362  1.000000
25%   -1.017706 -1.969553  1.000000
50%   -0.538487 -1.795745  1.000000
75%   -0.449149  0.178052  1.500000
max   -0.359812  2.151850  2.000000
In [110]: p
Out[110]:
          0         1  2
0 -0.359812  2.151850  1
1 -1.496926 -1.795745  1
2 -0.538487 -2.143362  2
```

- corr(): 返回相关系数矩阵 correlation coefficient 很奇怪怎么是两个 r?
- cov(): 返回协方差矩阵
- Series.value_counts(): 很常用的一个函数统计某一列各个元素出现的次数，df 中`d["column"].value_counts()`
- DataFrame.info(): df 中查看对象信息的函数，常用的可选参数有:
  - verbose: bool 类型，就是输出一堆信息(屁话)，默认是`True`
  - null_counts: bool 类型，给`True`展示 non-null 的数量，非空的数量，`False`则不展示

#### 数据清洗

- 处理缺失数据

  - 判断是否缺失: `isnull()`方法获取一个布尔 df，缺失值有`NaN`、`None`。

  - 丢弃缺失值: `dropna()`，默认丢弃一行，返回丢弃之后的 df，参数有:

    - how: 丢弃 how nan 的行，如果传入`"all"`，意思是丢弃 all nan 的一行

    - axis: 指定按行/列丢弃

    - thresh: `int`，丢弃 nan 的个数少于等于 thresh 的行

      ```python
      In [151]: p
      Out[151]:
                0         1    2
      0 -0.359812  2.151850  1.0
      1 -1.496926 -1.795745  1.0
      2 -0.538487       NaN  NaN
      In [152]: p.dropna(thresh=1)
      Out[152]:
                0         1    2
      0 -0.359812  2.151850  1.0
      1 -1.496926 -1.795745  1.0
      2 -0.538487       NaN  NaN
      In [153]: p.dropna(thresh=2)
      Out[153]:
                0         1    2
      0 -0.359812  2.151850  1.0
      1 -1.496926 -1.795745  1.0
      ```

  - 填充缺失值: `fillna()`用指定的值填充缺失值，e.g.`d.fillna(d.['salary'].mean())`，可以传入字典，**key 是索引，value 是填充的值**，也可以传入`method`参数，和前面的一样，默认为`"ffill"`前向填充，可以配合`limit`限制连续填充的最大数量。也有`inplace`。

  - 移除重复的行: `duplicated()`返回 bool 类型，表示某一行是否出现重复。`drop_duplicates()`返回丢弃后的 df，可以传入 column 来限制某一列是重复，`p.drop_duplicates(2)`，当然也可以传入列的 list。参数`keep="last"`可以保留最后一个重复的，也就是删除前面所有的重复。

  - 数据转换:

    - `map`方法，注意返回的是转换后的对象。

    - `replace`方法，replace a with b，用第二个参数替换第一个参数，这两个参数都可是 list，但是后者的维度不能大于前者(看下例)。也可以传递字典。

      ```python
      In [167]: p
      Out[167]:
                0         1    2
      0 -0.359812  2.151850  1.0
      1 -1.496926 -1.795745  1.0
      2 -0.538487       NaN  NaN
      In [168]: p.replace([1, np.nan], 2)
      Out[168]:
                0         1    2
      0 -0.359812  2.151850  2.0
      1 -1.496926 -1.795745  2.0
      2 -0.538487  2.000000  2.0
      ```

    - 划分数据:

      - `pd.cut(series, bins)`这个 bins 就是一个 lsit，e.g.

      ```python
      In [178]: bins
      Out[178]: [-1, 1, 2, 3]
      In [179]: pd.cut(p[0], bins)
      Out[179]:
      0    (-1.0, 1.0]
      1            NaN
      2    (-1.0, 1.0]
      Name: 0, dtype: category
      Categories (3, interval[int64]): [(-1, 1] < (1, 2] < (2, 3]]
      ```

      - `pd.qcut(series, n)`，按照分位数划分，第二个参数是多少分位，就是把这一个 series 中的最大值和最小值之间划分 n 个区间去划分。

    - 判断 bool 类型: `any`方法返回是否有任意是 True 的，与之相对的是`all`，返回这个行/列是否全是 True，可以传入参数指定 axis，默认是 0，`p[p[2] > 0].any()`。和 numpy 的一回事

    - 关于计算指标/哑变量:

      ​ 另一种常用于统计建模或机器学习的转换方式是: 将分类变量(categorical variable)转换为“哑变量”或“指标矩阵”。

      ​ 下面这个要理解一下: 如果 df 的某一列有 k 个不同的值，则可以派生出一个*k 列的*的 df，其值为 0/1。这 df 表示什么呢，列是原 df 中列的所有不同元素，0/1 表示这个元素在这一行里是否被使用。看个例子吧:

      - `get_dummies`

      ```python
      In [193]: dd
      Out[193]:
        key  data1
      0   b      0
      1   b      1
      2   a      2
      3   c      3
      4   a      4
      5   b      5
      In [194]: pd.get_dummies(dd['key'])
      Out[194]:
         a  b  c
      0  0  1  0
      1  0  1  0
      2  1  0  0
      3  0  0  1
      4  1  0  0
      5  0  1  0
      # 第一行key的值是b，第二行也是b，第三行是a......
      ```

      同时可以给这个函数加上`prefix='pre'`来添加前缀。还可以结合`cut`方法来观察数据。

    - 离散特征的编码: TODO one-hot
    - 某一列多类别问题: PPT P66 构件指标 df

---

### apscheduler 模块

advanced python scheduler，十分强大的任务调度模块，所谓任务调度就是在指定的时间(或者是周期，定时性)完成指定的任务(job)。

---

### argparse 模块

---

### re 模块

有兴趣去看看《正则指引》，反正我目前是不会看的。感觉正则表达式的东西大多数还是要背下来，熟练的使用。

直接贴上之前学的笔记吧

```python
# regularization expression 字符串匹配规则
"""
《正则指引》

用[]表示字符组：同一个位置上可能出现的字符集合
[0-9]:表示0到9的数字，[2-4]
[a-z],[A-Z],[a-zA-Z0-9]
# [A-z]: ascii码 67-122 不推荐
元字符：
.: 换行符以外的全部字符
\w: 字母数字下划线 word
\s: 所有空白符 space
\d: 匹配数字 digit
\W: 非\w能匹配的
\S: 非\s
\D: 非\d
\w\W: 全都可以匹配了
\n: 匹配换行符
\t: 制表符
\b: 单词结尾   \bdog\b匹配作为单词的dog
^: 这个字符串的开头     ^a == startswith()
$: 这个字符串的结束     ^[0-9]$  只能匹配一位数字
|: 或关系   abc|b  先abc了就不匹配b了
[^a]: 在[]（字符组）里面的^ 表示非，匹配除了字符组中所有的字符

量词：（贪婪匹配）（在字符后面）
{n}: 匹配n次   ab{3} == abbb
{1, 3}: ab{1, 3} == ab abb abbb
{n, }: 匹配n次（包括n）以上
*: == {0， }
?: == {0, 1} 0个或1个  ac? == a ac
+: == {1, } 至少有一个
## '+' + '?' 工作区间 == '*'
## (abc){1, } == abc abcabc abcabcabc abcabc...

e.g. r = re.search('<.*>', '2<h1>13<>dsf')
     r.group() = '<h1>13<>'             # 贪婪匹配，只要是在<>里面的都匹配
    如果r = re.search('<.*?>', '2<h1>13<>dsf')
    r.group() = '<h1>'      # ? 会以非贪婪/最小方式匹配，遇到第一个>就停止

还能起分组名  (?P<name> ...)
r.group('name') 去找到这个分组

在量词之后加?，非贪婪
ab+?    abbbb   匹配ab
转义：
加\  \\d
字符串前加r  r'\n'    真实字符串  real ??

贪婪匹配
<.*> 匹配  <sdfkjaskdfj><dsfsdf>sdfsdf  ==>  <sdfkjaskdfj><dsfsdf>
一路找下去直到最后一个发现不是>，于是回退到第一个>，停止(回溯算法)

非贪婪 惰性匹配
<.*?>      <sdfkjaskdfj>
*?  重复任意次，尽可能少重复
+?  重复一次到多次,...
??
{n, m}?
{n, }?
.*? 任意字符匹配0到任意长度的尽量少    e.g.  .*?x  找到x就停止，

这个点.除了换行符都可以匹配！

"""
import re

# 以下所有函数都有一个参数叫做flags:
# re.I ignore case 忽略大小写
# re.M multi-line多行
# re.S dotall 点.可以匹配任意字符，包括换行符!!!很关键，不然很多标签之后都会跟着一个换行符
# re.L locale 本地化识别。不推荐使用
# re.U unicode 使用\w \W \s \S \d \D 使用取决于unicode定义的字符属性
# re.X  verbose 冗长模式，该模式下pattern字符串可以是多行的，忽略空白字符，可以加注释


ret = re.findall('s', 'wefdsa sdfwefsdf')  #找所有的，得到一个list
# 会分组优先 也就是 会先去匹配()里面的东西
# r = re.findall('www.(baidu|google).com', 'www.baidu.com')
# r = ['baidu']
# 在(?: ...)这样就可以了

ret = re.search('d', 'ssdfs')  # 从前往后找到一个就返回，返回的变量有.group方法可以拿到结果str
#没找到会返回None，这个group就是()，整体看成一个()
print(ret.group())
ret = re.match('sd', 'afewsdsf')        #必须从头开始就要匹配
# ret = None

ret = re.split('[ab]', 'asdabvadf')       # 根据正则关系去分割，这里a或者b都能分割
# ['', 'sdv', '', 'v', df']
# 匹配模式里面有分组()会保留分组在切割


ret = re.sub('\d', 'X', 'sdfwek3rkj23fj1lkj132kjsdf')   # 把匹配到\d的所有替换成'X'
ret = re.sub('\d', 'X', 'sdfwek3rkj23fj1lkj132kjsdf', 1)   # 把匹配到\d的1个替换成'X'
# 结果是str

ret = re.subn('[0-9]', '-', 'x2 dsf3s2312df34')
#得到的是个元组，(result_str, num)  新字符串和替换的次数
# exec函数是一个可以执行字符串的函数  exec('x = 1\ny=1\nprint(x+y)')
st = 'for i in range(10): print(i)'
c = complex(st, '<string>', 'exec')          #将字符串编译为代码对象 code object
exec(c)     # c是一个code类型

ob = re.compile('\d{3}')        # re的compile 将正则表达式字符串编译为一个 正则表达式对象！ 可以减少cpu的使用
# re.compile(r'\d{3}', re.UNICODE)
ret = ob.search('sdfsdf2113dsf')        # 这个正则表达式对象就可以调用他的方法了
# 同一条正则规则要反反复复的用，同时这条规则也很长，可以用compile先编译一下，就方便了
ret = re.finditer('[a-z]', '1231n314123b23ndf2')         # 一看到iter就反应他是个iterator
# <callable_iterator at 0x7f94806d9208>
# 迭代器你懂得，用next()，或者 for r in ret: print(r.group())   要group一下才出内容
# 迭代器，节省内存!

identity = '111111199711024422'     # 1900 2000
ret = re.search('^[1-9](\d{14})(\d{2}[0-9X])?$', identity)   # 匹配身份证
# 这个匹配规则里面有()分组，用group(1)获得第一个分组，以此类推!

# identity = re.compile('(^[1-9]\d{5})(19\d{2}|20[01][0-9])(0[1-9]|1[0-2])([0-2][0-9]|3[0-2])(\d{3}[0-9x])')
# 这是我的身份证号码匹配规则
```

### namedtuple

有名字的元组

```python
from collections import namedtuple
# 第一个参数是名字 第二个 list 是元组每个元素的名字 同时指定了个数
Entry = namedtuple('Entry', ['path', 'weight'])
```
