# Flask 框架学习笔记

一个非常简单、轻量级的 python web 应用框架。

所谓框架：一套完整的技术解决方案

~~看的网课学习，18 年的慕课的 Flask 高级编程，老师是七月，我觉得讲的很好~~

后来看 b 站有搬运的一个视频，也很不错...

## 笔记

最简单的应用

```
from flask import Flask

app = Flask(__name__)

@app.route('/index')
def hello():
    return 'hello'

app.run(host='0.0.0.0', debug=True, port=81)
```

0.0.0.0ip 可以监听所有 ip，81 端口
所谓镜像：两份代码是一模一样的，镜像！

flask 所有的扩展包都可以直接传入 app 实现初始化，或者用都有的一个方法`init_app(app)`！可以先实例化一个对象，不传入 app，e.g.`db = SQLAlchemy()`，然后在恰当地方(app 创建好了之后)加入`db.init(app)`

**favicon.ico**原来是网页的图标，才知道。。。浏览器会向域名请求一个静态资源:127.0.0.1:8000/favicon.ico 来获取这个 icon。原来如此，所以每次开启 flask 服务用浏览器都会有一个 favicon.ico 是 404 的请求......

### flask 的 request 对象

获取请求中的数据
1 post 过来的表单数据
用`request.form`获得一个*ImmutableMultiDict*的对象可以用 get(key)的方法来获得 key 所对应的 value

`request.remote_addr`可以获得 ip 地址

2 post 过来的文件数据
首先 Postman 的 Post 请求头部要改

```json
Content-Type : multipart/form-data
```

然后 body 里面 form-data 要选择是 file，然后填写 key 选择 file 就行

flask 的 request 对象通过`request.files`获得一个字典，具体`[key]`或者`.get(key)`获取 key 所对应的文件。
多文件情况`request.files.getlist(key)`获得 key 都为*key*的文件 list

3 get 方法加在 url 后面的参数?xxx=xxx
通过 request.args 来获取

4 request.values 相当于 args 和 form 一起

### **name**的作用

```python
if __name__ == '__main__':
    # 生产环境这很重要，作为主函数入口,uwsgi来加载这个module的
    # 这个if 只会在 python xxx.py的时候使用起作用，会执行判断里面的
    # 语句
    # 而在生产环境中用uwsgi来开启web服务的时候，uwsgi启动整个模块
    # 就不会把这个文件当做主函数入口执行，就不会执行app.run()
    # app.run()是flask自带的服务器，很low的
    app.run()
```

### flask 中的 session

flask 的 session 是放到 cookie 中，而不是后端的数据库中。可以把 session 放到后端*redis*中。用的时候还是`from flask import session`。

引入扩展**flask-session**
[Flask-Session 官网](https://pythonhosted.org/Flask-Session/)
需要配置
`SESSION_TYPE` => session 存放在哪，可以是 redis，mongodb，sqlalchemy....我们选择放到 redis 中
`SESSION_REDIS` => 表示 redis 的实例，default connect to 127.0.0.1:6379
`SESSION_USE_SIGNER` => 是否要对 session 签名为 cookie 中的 sid，如果 True 必须要有 secret key 配置
`SESSION_PERMANENT` => session 是否永久有效
`PERMANENT_SESSION_LIFETIME` =>设置 session“永久”有效的时长传入`datetime.timedelta`类型的对象或者传入一个整数秒

### 利用 flask-wtf 扩展包的 CSRFProtect

提供全局 CSRF 保护
`from flask_wtf import CSRFProtect`
`CSRFProtect(app)`

csrf 验证机制简介: 从 cookie 中获取一个 token，从请求体中也获取一个 token，如果两个值相同，则检验通过，进入视图函数，如果不相同则失败，flask 会向前端返回 400 错误。上面两个 token 都是自己来写，CSRFProtect 只是做验证。POST，PUT，DELETE 都会带 body。同源策略，资源的操作只能是同一个 origin 可以。

设置 cookie

```
from flask import make_response
from flask_wtf import csrf

# 生成一个csrf_token
csrf_token = csrf.generate_csrf()

# 构造响应并设置cookie
resp  = make_response(xxx)
resp.set_cookie("csrf_token", csrf_token)

```

### flask-cors 配置跨域请求

所谓跨域请求(Cross-origin Resource Sharing)：浏览器向配置静态资源的服务器 A 请求了静态资源 html，css，js 文件，但是 js 文件中的所有动态请求的服务器不是静态资源所在服务器，而是在另一台服务器 B 上，这样的请求就叫做**跨域请求**，因为 Ajax 不能跨域。flask 中可以通过 flask_cors 扩展包中的 CORS
配置制定视图函数可跨域，用`@cross_origin`装饰器

```
@app.route("/")
@cross_origin()
def helloWorld():
  return "Hello, cross-origin-world!"
```

配置全局

```
CORS(app, resources={
        r'api/{}/*'.format(app.config['VERSION']) : {'origins' : '*'}
    })
```

### 视图函数

和普通函数区别，返回的东西有： 1.状态码 status code 200, 404, 301, ...状态码只是告诉浏览器的标识，不影响内容 2.内容类型 content-type 在返回的头部 http headers，很重要

视图函数返回的对象是一个`Response`对象
`from flask import make_response`
`response = make_response('<div></div>', 404)`
为 response 修改头部`response.headers = {自定义的headers}`
也可以通过`return "字符串", 404, headers`不需要 make_response

关于重定向:状态码 301/302，在 headers 加入 location，浏览器看到是 301 之后会去找 location 做重定向

```
headers = {
    'location' : '需要重定向的url'
}
```

作为 api 的时候返回 json 格式
`'content-type' : 'application/json'`
web 交互的信息类型本质都是字符串

### 日志功能

导入 python 自带的模块`loggin`，然后在 app 的 init 的部分加入以下代码

```
# 开启日志功能
# 设置日志等级
logging.basicConfig(level=logging.DEBUG)
# 创建日志记录器 指明日志保存的路径 每个文件的最大字节数 5mb  可存在的最大文件数量 5
file_log_handler = RotatingFileHandler("webox/logs/webox_log.txt", maxBytes=1024*1024*5, backupCount=5)
# 创建日志记录的格式                 时间-[日志等级]--|产生记录的文件|->第几行: 日志信息
formatter = logging.Formatter("%(asctime)s-[%(levelname)s]--|%(filename)s|->%(lineno)d: %(message)s")
# 为日志记录器设置日志格式
file_log_handler.setFormatter(formatter)
# 为全局的日志工具对象(flask app使用的) 添加日志记录器
logging.getLogger().addHandler(file_log_handler)
```

之后可以用`logging.info/debug/...()`来记录日志

其实 flask 自己本身也用到了**logging**这个模块来输出日志，但是由于每个系统都只可以有一个 logger，所以上面代码的最后一行是获取到了整个系统的 rootLogger，对他添加 Handler，来实现我们想要的日志功能，如果在调试模式下`DEBUG=True`，Flask 会忽略所设置的日志等级，非调试模式下才可。

### 关于 ORM 模型 & flask-sqlalchemy

1 利用 flask-sqlacodegen 模块生成 python 的 orm 模型
终端输入`flask-sqlacodegen --outfile models.py --flask 'mysql://user:password@ip/database'`
将 models.py 放入 models 文件夹，修改 db，`from application import db`

2 使用 flask-sqlalchemy(快速入门)
2.1 查询(query)
一个查询对象`ClassName.query`
`User.query.get()`接收的就是 id！

过滤器:
`filter()`可以模糊查找，参数是布尔表达式，例：`Major.m_name.like("%%%s%%"%data)`，返回一个新的查询(query)，再举个例子`Major.query.filter(Major.id.in_([2, 3, 5, 12))`
`filter_by()`精确查找，参数为`字段=值`
`order_by()`根据指定条件对原查询结果进行排序, 返回一个新查 倒序情况`Goods.create_time.desc()`，或者直接传送字段的字符串
`group_by()`根据指定条件对原查询结果进行分组, 返回一个新查询
`limit()`
`offset()`
(用到再说)
过滤器起到对被查询对象的筛选作用，筛选结果还是被查询对象，所以过滤器可以叠加使用
执行函数:(操作被查询结果)
`all()`返回查询到的所有结果(list)
`first()`返回第一个查询结果，如果没有返回 None

2.2 会话管理，事务管理

提交单个(添加一个对象)
`db.session.add(instance)`
`db.session.commit()`

提交多个
`db.session.add_all(list_of_instance)`
`db.session.commit()`

事务回滚(在操作尚未 commit 的时候使用可以恢复到未操作前)
**在 commit 出现异常的时候必须回滚**
`db.session.rollback`

[优化 try/except 的方法来自 csdn](https://blog.csdn.net/weixin_43343144/article/details/87106213)
封装自动 commit

更新对象
`UserData.query.filter_by(username='name').update({'password':'newdata'})`
然后 commit
或者直接 query 出来之后修改对象属性再 commit

DM 锁，控制并发，`db.session.query.filter().with_for_update().all()`
之后跟上 commit

2.3 创建 ORM 模型
[官网-声明模型](https://flask-sqlalchemy.palletsprojects.com/en/2.x/models/)
直接上完整 models 模块代码吧

### flask-migrate 数据库迁移

首先安装 flask-migrate 库

```
from flask_migrate import Migrate, MigrateCommand
from application import app, db, manager
migrate = Migrate(app, db)
manager.add_command('db', MigrateCommand)
```

生成 orm 模型文件之后，可以在命令行使用`python manage.py db init`生成数据库文件，然后`python manage.py db migrate -m "leave a msg"`来迁移数据库文件，最后`python manage.py db upgrade`更新数据库，这样数据库中就有表了。
`python manage.py db history`查看历史状态
`python manage.py db downgrade xxx`回到 xxx 历史状态。
注意: 出错或是警告可能是没有配置数据库**SQLALCHEMY_DATABASE_URI**或者没有 export 变量。。还有要在别的地方 import models。

第一次 migrate 相当于`db.create_all()`，但是
upgrade 可以修改数据库并不影响数据。

#### 补充数据库 utf8mb4 字符集

首先修改 mysql 的文档，另一个笔记里有，不多赘述

主要是 flask 中的配置**SQLALCHEMY_DATABASE_URI**需要在最后加上**?charset=utf8mb4**

### flask 中使用 redis

在 python 中简要记录过 redis 的笔记，真的十分简要

redis 缓存机制在 web 应用中的适用场景：
有些资源前端会一直请求，每次从数据库中拿其实挺慢的，不如在第一次数据库操作后直接放在 redis 这个快速内存键值对数据库中，每次请求直接从 redis 中获取，返回。比如一些首页上面的资源，商品类别，等等。

### 基于 token 的登录验证

登录成功后，返回一个 token（令牌）给前端，之后所有需要登录的请求都让前端在请求头中加入**Authorization : token**让后端做验证。

token 技术用到了非对称加密和数字签名技术。

### 关于 OAuth 2

这是一个关于第三方应用向服务器授权信息权限的技术
简单来说是一种**授权机制**
参见[理解 OAuth2.0 阮一峰](http://www.ruanyifeng.com/blog/2014/05/oauth_2_0.html)
了解这个技术的原因是因为要通过学校的登录系统来验证用户在自己网站上的登录，而学校的登录应该用的是 oauth 验证。

### 加密算法

需求是要保存用户的密码，但是不能明文保存，只能加密保存
以下参考[csdn](https://blog.csdn.net/L835311324/article/details/81540641)
几种加密方法

#### 1. 单向加密

简介：即提出数据指纹；只能加密，不能解密；主要用来验证数据是否完整。

过程：A 向 B 发送数据以及对数据加密后的数据指纹，B 接收到数据后对数据进行加密，得到的数据指纹和 A 传送过来的数据指纹相匹配的话，则可认为数据没有被篡改过。

特性

- 定长输出
- 雪崩效应；

算法

- md5：Message Digest 5, 128bits
- sha1：Secure Hash Algorithm 1, 160bits
- sha224, sha256, sha384, sha512

#### 2. 非对称加密

简介：非对称性加密，也叫公钥加密，加密解密的过程使用不同的密钥。

密钥分为公钥和私钥： -公钥：从私钥中提取的，可公开给所有人 pubkey -私钥：通过工具创建，使用者自己保存，必须保证私密性 secret key

特点：用公钥加密的数据只能通过与之对应的私钥来解密，反之亦然。私钥只能有一个主机拥有，公钥可多个主机拥有。

用途：

- 数字签名
- 密钥交换
- 数据加密（速度慢）

常用算法：

- RSA [科普](https://www.cnblogs.com/jiftle/p/7903762.html)/[python 使用]()
- DSA
- ELGamal

### python 使用 rsa

首先安装 rsa 库([官方文档](https://stuvel.eu/python-rsa-doc/usage.html))
`pip install rsa`

1.生成密钥

1.1 可以用**openssl**在文件夹中生成，然后在 python 中获取
命令行输入:
`openssl genrsa -out private_key_file.pem 1024`生成私钥文件
`openssl rsa -in private_key_file.pem -pubout -out public_key_file.pem`通过私钥生成公钥(注：-pubout)
python 中 you can use rsa.PrivateKey.load_pkcs1() and rsa.PublicKey.load_pkcs1() to load keys from a file:

```
>>> import rsa
>>> with open('private_key_file.pem', mode='rb') as privfile:
...	keydata = privfile.read()
>>> privkey = rsa.PrivateKey.load_pkcs1(keydata)
>>> with open('public_key_file.pem', mode='rb') as privfile:
...	keydata = privfile.read()
>>> pubkey = rsa.PublicKey.load_pkcs1(keydata)
```

目前这个方法遇到的问题....openssl 生成的公钥的 begin 和 end 没有 RSA 关键字，`PublicKey`无法正确匹配和读取。通过 vim 人为加了 RSA 之后发现不是 ascii 编码(存疑)...

看了官方文档.......发现有一个方法叫**load_pkcs1_openssl_pem(keyfile)**(The contents of the file before the “—–BEGIN PUBLIC KEY—–” and after the “—–END PUBLIC KEY—–” lines is ignored.)专门为了读取 openssl 生成的公钥的，没问题了。
最后一句代码修改为

```
>>> pubkey = rsa.PublicKey.load_pkcs1_openssl_pem(keydata)
```

注意：Loads a key in PKCS#1 DER or PEM format.
所以必然还有`load_pkcs1_openssl_der(keyfile)`
目前没有了解两个后缀名的问题。

1.2 python 直接生成

```
>>> import rsa
>>> (pubkey, privkey) = rsa.newkeys(512)
```

上面 openssl 和 rsa.newkeys()中的 1024 和 512 表示 keysize 单位为 bit，越大生成 key 的时间越多，官网列了张表

2.编码和解码(加密和解密)
用到的方法`rsa.encrypt()`和`rsa_decrypt()`加密和解密

字符串需要编码成 utf8(必须，因为 rsa 只处理二进制编码，不处理字符串)
`>>> msg = 'a secret'.encode('utf8')`

用公钥加密
`>>> crypto = rsa.encrypt(msg, pubkey)`

用私钥解密

```
>>> message = rsa.decrypt(crypto, privkey)
>>> print(message.decode('utf8')
a secret
```

解码为 unicode

RSA 只能加密比 key 小的(编码为二进制码后 bit 比 key 的小)字符串。报错(OverflowError(加密时), DecryptionError(解密时))

3.签名和验证

字符串可以经过哈希函数之后得到签名，并可验证
官网例子:
用`rsa.sign`做签名，这里哈希函数是*SHA-1*

```
>>> (pubkey, privkey) = rsa.newkeys(512)
>>> message = 'Go left at the blue tree'
>>> signature = rsa.sign(message.encode('utf8'), privkey, 'SHA-1')
```

注意这里还是要编码为 bytes 的(官网没写....)

`rsa.verify`验证

```
>>> message = 'Go left at the blue tree'
>>> rsa.verify(message, signature, pubkey)
True
```

其实验证成功返回的不是 True......而是 hash 的方法，这里应该是'SHA-1'
验证失败会 raise exception: **VerificationError**

ok，关于 RSA 暂时了解到这里。
