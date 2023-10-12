# Ubuntu 使用中踩到的坑

> Ubuntu 18.04(自己的电脑)/16.04(腾讯云服务器)

## 环境配置

### Golang

go 语言配置，这是我一直很想学的语言

从官网下载源码（需要翻墙) `wget https://dl.google.com/go/go1.13.1.linux-amd64.tar.gz`

然后解压，将 go 文件夹移动到*/urs/local*中，然后在**/etc/profile**最后加入以下几行

```bash

export GOROOT=/usr/local/go
# GOPATH is the location of your work directory. For example my project directory is ~/Projects/Proj1 .
# Now set the PATH variable to access go binary system wide.
export PATH=$PATH:$GOROOT/bin
export GOPATH=$HOME/go  # 我在$HOME下新建了一个/go
export GO111MODULE=auto
export GOPROXY=https://goproxy.cn,direct
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
```

最后`source /etc/profile`

查看 go 版本`go version`是 1.13.1 即可

### nodejs&npm

    nodejs和npm环境的配置是让我最头疼的，也是我这次重装Ubuntu的原因（之前的npm环境乱了）。不过这次找到了一个非常方便的方法，赶紧记录下来

命令：

`curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -`

从 node 的源码 github 上把对应版本的安装文件下载下来（这里下载的是 10.x 的版本），然后通过`bash`执行（？）脚本，看终端中的提示好像是直接把这个 repository 安装来了，然后顺便执行了`apt-get update`...最后提示你可以通过

`sudo apt-get install -y nodejs`

来安装 node.js 10.x 和 npm 了，可能还需要其他环境（这里不多说了）
安装之后通过
`node --version`
`npm --version`
查看版本
都是最新版本！ok，大功告成。

附：彻底删除 nodejs 和 npm
执行以下命令

- 卸载
  `sudo apt-get remove --purge nodejs-legacy`
  `sudo apt-get remove --purge nodejs`
  `sudo apt-get remove --purge npm`
  `sudo apt-get autoremove`
- 删除相关目录
  `rm -r -f /usr/local/bin/npm`
  `rm -r -f /usr/local/lib/node-moudels`
  查找 npm 的所有文件，这里可能要`sudo`
  `find / -name npm`
  然后通过`rm`删除所有文件

### Anaconda3

#### jupyter notebook

添加已有的虚拟环境
在 base 环境中安装 nb_conda 这个插件
在所需要添加的环境中`conda install ipykernerl`如果还不行就在环境中安装 jupyter notebook

### MySQL

#### 安装

#### 开启外部访问

登录之后，在 mysql 数据库中看一下目前的 host，user，authentication_string
`select host, user, authentication_string from user;`
所有的 host 应该都是 localhost，然后新增一个 root 用户，使得所有地址(%)都可以访问，密码为 password(根据自己情况)
`grant all privileges on *.* to 'root'@'%' identified by 'password';`
这一步之后，mysql.user 这张表中会多一行，也就是有新的用户 root 了，这个 root 用户是可以对所有库和所有表进行所有操作的，很危险。
如果想指定权限和数据库以及具体表的话，可以参照
`grant select, insert, update, delete on major_db.* to 'major'@'%' identified by 'password'`记得数据库名称加引号.....
刷新权限(不需重启服务)
`flush privileges;`
最后因为是 mysql5.7 版本，在外面的配置文件中**/etc/mysql/mysql.conf.d/mysqld.cnf**注释掉**bind-address**，重启数据库服务，搞定。
外部登录：
`mysql -h ip -u user -P port -p`

#### 查看和修改默认端口

1 查看
`show global variables like 'port';`

2 修改端口
在**/etc/mysql/mysql.conf.d/mysqld.cnf**配置文件中修改端口，重新启动 mysql 服务即可。
然后在 Mysql 中查看一下是否修改成功。

#### 数据库编码查看和修改

1.查看
`show variables like 'character_set_database';`
`show variables like '%char%';`

2.修改
找到配置文件`mysqld.cnf`，应该在**/etc/mysql/mysql.conf.d**里面，在[mysqld]下写**character-set-server=utf8**或者 utf8mb4，然后重启服务`service mysql restart`，检查一下是不是改了

#### 数据库的备份与恢复

mysql 数据库备份整个库 shell:
`mysqldump -u root -p db > db.sql`

mysql 恢复数据库:
`mysql -uroot -p db < db.sql`

ps：可以远程恢复了
`mysql -h xx.xxx.xx.xx -P 3306 -u root -p db < db.sql`

### Redis

#### 什么是 redis

[参考](https://www.cnblogs.com/linkworld/p/7808818.html)

#### ubuntu18.04 安装 redis

[参考了这个文安装的](https://www.cnblogs.com/super-zhangkun/p/9457312.html)
`sudo apt-get install redis-server`
然后一路 ok(这样安装的是 redis 4.0.9)
其实发现还有很多文章写的是把源码下载下来手动安装......

#### 修改端口

在**/etc/redis**文件夹中 redis.conf 文件修改 port，然后重启服务
`redis-cli -p 8888`即可

#### 添加和查看密码

进入 redis-cli 后输入
`config set requirepass <密码>`
查看`config get requirepass`
之后登录以后要`auth <密码>`

#### flask 中报错

MISCONF Redis is configured to save RDB snapshots, but it is currently not able to persist on disk. Commands that may modify the data set are disabled, because this instance is configured to report errors during writes if RDB snapshotting fails......

cli 中输入`config set stop-writes-on-bgsave-error no` 其实好像这样也不好，还是老老实实的重启服务

### ubuntu 中文乱码

`sudo apt-get install language-pack-zh-hans`

## 应用安装

### yddict

一个命令行查单词工具

既然是用 linux 嘛，命令行当然是精髓所在，用命令行查单词太炫酷了。之前用的也是命令行查词，不过忘记叫什么软件了，这次查到一个 github 上的有道词典命令行 app，附上网址[Github-yddict](https://github.com/kenshinji/yddict) 挺佩服的，好像是用 nodejs 写的，调用有道的接口吗？所以要用 npm 来安装包，安装完之后就可以在终端里面输入`yd <要查询的单词>`。
还可以在 .config/configstore/yddict.json 中修改颜色

### Typora

另一款 markdown 的编辑器，比 Remarkable 好用。

[官网](https://www.typora.io/)下载即可，windows 平台也支持

### Remarkable

一款 markdown 的编辑器，也就是我正在写 markdown 的软件。
下载地址[Remarkable](https://remarkableapp.github.io/linux/download.html) ，点击 Download.deb 下载安装即可。

### Postman

很简单[官网](https://www.getpostman.com/downloads/)直接下载压缩包，解压之后打开即可用。
ps：如果打不开，用命令行去运行，会提示错误的，根据错误安装所需要的包即可。

### f.lux

这是一个自动调节色温的 app，根据地理位置判断日照强度调节屏幕色温。确实这段时间使用 ubuntu 感觉到眼睛很累.....

安装：
`sudo add-apt-repository ppa:nathan-renniewaldock/flux`
`sudo apt-get update`
`sudo apt-get install fluxgui`
然后打开 fluxgui，输入经纬度，那个网站需要科学的上网方式。然后选择光线强度，勾选开机自启，然后就 ok 了。
不过比较蛋疼的是他真的是自动调节，而我希望他一直是暖色光......
发现 ubuntu 18.04 其实自带夜间模式。

如何卸载：
`sudo apt-get remove fluxgui`
`sudo add-apt-repository -r ppa:nathan-renniewaldock/flux`

### Staruml

一款画数据库表的软件，从官网下载了超级无敌久，我准备放在百度云里面

### Lantern

一个 go 语言写的 vpn 软件
直接 github 搜索 lantern 就可以下载安装，没有过多了解，好用就行

### Kazam

录屏和截图软件，很小巧，安装直接 apt-get 即可 [GITHUB](https://github.com/hzbd/kazam) 里面讲到快捷键

Keyboard shortcuts

SUPER-CTRL-Q - Quit
SUPER-CTRL-W - Show/Hide main window
SUPER-CTRL-R - Start Recording
SUPER-CTRL-F - Finish Recording
