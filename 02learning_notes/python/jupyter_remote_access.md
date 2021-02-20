# 关于远程连接服务器

    Jupyter notebook
    nginx
    uwsgi

---

### jupyter notebook

服务器开启远程 jupyter notebook 连接

#### step1 安装 python,pip,ipython,jupyter

```
pip3 install jupyter
```

#### step2 打开 ipython 为 jupyter 添加密码

```
from notebook.auth import passwd
passwd()
```

输入两次密码后在终端输入，记得要复制 ash 密钥

```
jupyter notebook --generate-config
```

生成配置文件，在主目录下的.jupyter 文件有 jupyter_notebook_config.py

#### step3 修改配置文件内容

```
c.NotebookApp.ip = '*'
#设置可访问的ip为任意。
c.NotebookApp.open_browser = False
#设置默认不打开浏览器
c.NotebookApp.password = '第2步生成的密文'

c.NotebookApp.port = 9999
c.NotebookApp.notebook_dir = '/your/file/saved/path/'
```

可能会用到

```
c.NotebookApp.allow_remote_access = True
c.NotebookApp.root = True
```

#### step4 开启 jupyter note

后台开启服务

```
nohup jupyter notebook >/dev/null 2>&1 &
```

##### 之后就能在没有 python 的环境下打开浏览器访问远程服务器的 jupyter notebook 了

---
