# Ubuntu 使用中踩到的坑

Ubuntu 18.04(自己的电脑)/16.04(腾讯云服务器)

[TOC]

---

## 指令回顾 linux & macOS

### tree

> 注意，macOS 需要用 brew 来安装 `brew install tree`

常用的指令，用来打印目录树（`man tree` 查看使用说明）

```bash
tree <directory>
```

常用的选项：

- `-L`：递归的最大深度，`-L 3` 3 层
- `-I`：需要 ignore 的目录 pattern，可以是 glob，多个用 `|` 分割，比如 `-I node_modules|dist|test_*`
- `-d`：仅 directory
- `-a`：所有（all）文件，默认是不会展示隐藏文件的
- `-f`：展示文件的完整（full）目录
- `--prune`：过滤掉空目录
- `-s`：文件/目录大小，配合 `-h` 展示 humam-readable 大小（默认没有单位就是字节）
- `--du`：For each directory report its size as the accumulation of sizes of all its files and  sub-directories  (and their files, and so on). 给每个目录展示其整个所占磁盘空间大小

文件选项：

- `-p`：文件 type 和 permission
- `-u`：username
- `-g`：groupname
- `-D`：Print  the  date of the last modification time

排序选项：

- `-t`：Sort the output by last modification time instead of alphabetically.
- `-c`：Sort the output by last status change instead of alphabetically. 如果 `-D` 配合使用，则会用最近一次修改的时间排序
- `-U`：Do not sort. Lists files in directory order. Disables --dirsfirst.
- `-r`：Sort the output in reverse order.

选项通常可以整合起来一起输入

```bash
tree -L 3 -I node_modules -sdhpugD --du .
```



### pbcopy & pbpaste

在 mac 上的 termial 复制粘贴指令，非常方便

比如

`cat file.txt | pbcopy`

`tree | pbcopy`

能够减少一次用鼠标选中复制的操作！

在 linux 上可以使用 **xsel** 来替代，可以在 `.zshrc` 里面加上 alias

```bash
# Linux version of OSX pbcopy and pbpaste.
alias pbcopy='xsel — clipboard — input'
alias pbpaste='xsel — clipboard — output'
```

### xargs

eXtended ARGuments

参考阮一峰的[教程](https://www.ruanyifeng.com/blog/2019/08/xargs-tutorial.html)

### du

> disk usage 命令行递归的查看静态文件占用的硬盘大小

`du /path/to/directory`

- `-h`：Human Readable Format
- `-a`：展示目录下所有子目录的大小
- `-s`：一个 summary 大小
- `-c`：Display a grand total 在最后一行
- `--exclude`：指定不查询的目录（linux 有）

### ln

Link？

关于什么是软连接/硬连接可以简单看[这篇](https://www.cnblogs.com/itech/archive/2009/04/10/1433052.html)，简单来说

- 硬连接：多个路径可以指向同一个文件（磁盘上的 Inode index），最后一个指针被删除，文件空间才被释放
- 软连接：多个路径指向一个“地址文件”，这个“地址文件”包含了真实的文件 Inode index

`ln [-Ffhinsv] source_file ... target_dir`

- `-s ` 软连接，symbolic

  `ln -s <source_dir> <target_dir>`

  可以发现`ls`之后在文件名后多了个`@`，用`ls –l`命令去察看，就可以看到显示的 link 的路径了

### dig

domain information groper，`*niux`系统用来查询 DNS 的指令

_为啥用 groper 这个单词呢哈哈哈_

#### 如何使用

> [推荐文章](https://jvns.ca/blog/2021/12/04/how-to-use-dig/)

basic：`dig domain`，会得到一堆输出

可以查询：A 记录（默认），TXT（文本注释），MX 记录，NS 记录，或者任意综合查询。

```bash
# 第一行是 dig 的版本
; <<>> DiG 9.10.6 <<>> www.coyoo.xyz
;; global options: +cmd
;; Got answer:
# 下面是 DNS 服务器的响应 header
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 7672
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;www.coyoo.xyz.			IN	A

;; ANSWER SECTION:
# IN 表示在互联网中 A 是 A 记录
www.coyoo.xyz.		752	IN	A	118.25.153.140

;; Query time: 467 msec
;; SERVER: 172.20.10.1#53(172.20.10.1)
;; WHEN: Mon Sep 14 14:10:35 CST 2020
;; MSG SIZE  rcvd: 58
```

- 简短输出：`dig xxx +short`
- 查询 TTL：`dig xxx TTL`
- 查询各种记录：e.g `dig xxx NX`
- 指定一个 name server 去查询：`dig @ns1.google.com www.google.com`

```bash
# dig 最基本的用法
dig` `@server qianlong.com
# 用 dig 查看 zone 数据传输
dig` `@server qianlong.com AXFR
# 用 dig 查看 zone 数据的增量传输
dig` `@server qianlong.com IXFR=N
# 用 dig 查看反向解析
dig` `-x 124.42.102.203 @server
# 查找一个域的授权 dns 服务器
dig` `qianlong.com +nssearch
# 从根服务器开始追踪一个域名的解析过程
dig` `qianlong.com +trace
# 查看你使用的是哪个 F root dns server
dig` `+norec @F.ROOT-SERVERS.NET HOSTNAME.BIND CHAOS TXT
# 查看 bind 的版本号
dig` `@bind_dns_server CHAOS TXT version.bind
```

关于 DNS：

DNS 还是有很多内容的。。

先说说各种记录类型（A，NS，MX）（这些记录都在服务器控制台的域名管理添加）

- A：最基础的记录吧，将一个 domain name 指向一个 IPv4 地址的一条记录
- NS：域名解析服务器记录，如果要**将子域名指定给某个域名服务器来解析**，需要设置 NS 记录
- MX：建立电子邮箱服务
- CNAME：将一个域名指向一个目标域名，这样可以达到访问目标域名的效果了（在用七牛云做存储服务的时候就这样做了）
- AAAA：将一个域名（主机名）指向一个 IPv6 地址
- SOA：该记录表明的 DNS name server 是 DNS 域中的数据表的信息来源，该服务器是主机名字的管理者，创建新区域时，该资源记录自动创建，且是 DNS 数据库文件中的第一条记录。

每一条 DNS 记录的 **TTL**（Time To Live）：该条解析记录在 DNS 服务器的缓存时间（单位：s）

### nslookup

查询 DNS 记录，域名解析是否正常

基础用法：`nslookup domain [dns-server]` _如果没有指定 dns 服务器，就采用系统默认的 dns 服务器。_

```json
Server:		192.168.199.1						// DNS服务器IP地址
Address:	192.168.199.1#53				// DNS服务器IP和端口

Non-authoritative answer:					// 说明不是权威答案，即从上述的DNS服务器的本地缓存中读取出的值，而非实际去查询到的值
www.meituan.com	canonical name = web.vip.meituan.com.					// //说明www.meituan.com有个别名叫web.vip.meituan.com,www.meituan.com的CNAME是web.vip.meituan.com
Name:	web.vip.meituan.com					// 当DNS在查询CNAME左面的名称的时候，都会转向CNAME右面的名称再进行查询，一直追踪到最后的A记录，成功查询后才会做出回应，否则失败
Address: 103.37.152.3							// web.vip.meituan.com对应的IP地址之一
Name:	web.vip.meituan.com
Address: 103.37.142.167						// web.vip.meituan.com对应的IP地址之一
Name:	web.vip.meituan.com
Address: 101.236.12.4							// web.vip.meituan.com对应的IP地址之一
```

### kill

这个可不是杀死进程的命令啊(虽然可以)

`man kill`看一下说明这个是"send a singal to a process"，只是发送一个信号量给某个进程。

信号和操作系统里面学的**信号量(semaphore)**不一样，但我忘了，这里大概就是一个信息代号吧。

---

**信号机制(signal)**:

signal，又简称为信号（软中断信号）用来通知进程发生了异步事件。

一个进程收到一个信号与处理器收到一个中断请求可以说是一样的。信号是**进程间通信机制中唯一的异步通信机制**，一个进程不必通过任何操作来等待信号的到达，事实上，进程也不知道信号到底什么时候到达。进程之间可以互相通过**系统调用 kill 发送软中断信号**。内核也可以因为内部事件而给进程发送信号，通知进程发生了某个事件。信号机制除了基本通知功能外，还可以传递附加信息。

Linux 中系统调用函数为`signal()`

**信号量(semaphore)**:

Linux 内核的信号量用来操作系统进程间同步访问共享资源。

---

语法:`kill [options] <pid> [...]`

`<pid>`: 进程号 通过 ps 或者 top 查看

选项 options:

- `-<signal>`: 指定发送给某个进程的信号，名称或者号码都可以
- -l: list names and number of all signals

用法:

- `kill -l`查看有哪些信号可以发送，-9 是杀死进程
  - 1)SIGHUP: 启动被终止的程序，可以让该进程读取自己的配置文件，类似重启(?没试过)试了一下，感觉不对啊，提示的是 Hangup 挂起进程？
  - 2)SIGNT: 相当于前台 ctrl+c 中断
  - 9)SIGKILL: 强制终端一个程序，会留下半成品
  - 15)SIGTERM: 正常的方式 terminal 这个程序，后续会完成，但是如果程序已经出问题，这个信号也没用
  - 19)SIGSTOP: 相当于 ctrl+z 来暂停一个进程
  - 更多的`man 7 signal`了解
- 常用的就是 -15 -9
  - `kill -15 pid`发出这个信号量让进程正常退出，清理并释放资源，默认`kill pid`就是发送 15 信号
  - `kill -9 pid`强制结束，会留下文件残余

### history

展示历史记录和执行过的命令，history 命令*读取历史命令文件中的目录到历史命令缓冲区和将历史命令缓冲区中的目录写入命令文件*(这个文件应该是**~/.bash_history**)。该命令单独使用时，仅显示历史命令，在命令行中，可以使用符号**`!`执行指定序号的历史命令**。

`history [option] [args]`

选项:

- -c 清空当前历史命令
- -a 将历史缓冲区中的命令写入当前历史命令缓冲区?
- -r 历史命令文件中的命令读到当前历史命令缓冲区
- -w 将历史命令缓冲区写入历史命令文件

参数:

- n 打印最近 n 条历史指令

使用**!** 执行历史命令，注意不要有空格

`!2010` 执行第 2010 条历史指令

`!!`执行上一条

### scp

详见 _scp_ 那篇文章

好像是最近最频繁的指令了，通过 ssh 传送文件/文件夹到指定服务器上，或者将目标服务器的文件拷贝到本地

1.传送
`scp -r path username@xx.xx.x.x:/path/path`

2.copy
将 文件/文件夹 从远程 Ubuntu 机拷至本地(scp)

`scp -r username@192.168.0.1:/home/username/remotefile.txt /localpath`

### chmod

修改文件权限，我感觉应该是 change mode 的缩写，因为在 linux c 里面的 open 函数有一个参数叫 mode 是文件权限

先说明一下文件有哪些权限:

- r 读: read 二进制 00000100 十进制为 4
- w 写: write 二进制 00000010 十进制为 2
- x 执行: execute 二进制 0000001 十进制为 1

同样有三种用户群体可以根据权限使用文件:

- 文件所有者: 最高位表示
- 群组用户: 中间一位
- 其他用户: 最低位

所以三种用户的权限可以用三个连续的十进制数来表示 e.g. 777，这个 7 是怎么来的呢

网上说明这个 7 是，可读可写可执行加起来的，但是我觉得呢，这个是三个数值或起来的`r | w | x`，不知道谁对谁错，反正结果知道了就行了。

所以一般看到的`chmod 754`就说明，除了文件所有者以外的两个用户类别的权限分别是可读可执行，只读。

知道文件权限之后呢，我们讲讲怎么用这个指令去 change mode。

chmod [mode] [filename]

mode 参数:

- u,User 　　　 即文件或目录的拥有者
- g,Group 　　　即文件或目录的所属群组
- o,Other 　　　 除了文件或目录拥有者或所属群组之外，其他用户皆属于这个范围
- a,All 　　　　 即全部的用户，包含拥有者，所属群组以及其他用户
- r 　　　　　 读取权限，数字代号为“4” 即 “100”
- w 　　　　　写入权限，数字代号为“2” 即 “010”
- x 　　　　　 执行或切换权限，数字代号为“1” 即 “001” -　　　　　　 `-` 不具任何权限，数字代号为“0” 即 “000”

文件名选项:

- -c, --changes
- -f, --silent, --quiet 不显示错误信息
- -R, --recursive 递归处理，处理文件夹
- -v, --verbose 显示执行过程，verbose 就是一堆屁话的感觉
- --reference 把指定文件或目录的所属群组全部设成和参考文件或目录的所属群组相同(不太理解)

用法:

- 直接指明三种用户的权限 例如`chmode 777 file`
- 修改/指定/删除某一种用户的权限:
  - 身份 + 权限 例如 `chmod g+x file` 增加执行权限
  - 身份 - 权限 例如 `chmod g-rw file` 删掉用户组的读写权限
  - 身份 = 权限 例如 `chmod u=r file` 指定用户有读取权限

p.s. : 不要和 chown 这个指令搞起来哦

### cal

查看日历
`cal`当前月
`cal [year]`某一年的年历
`cal [month] [year]`某年某月的月历

### cd

最简单最使用的命令之一了

change directory

`cd -`：cd 到上一个 cd 的目录

### mv

move 指令

妙用：修改文件夹的名字

`mv old/ new`将旧的文件夹所有东西 move 到新的文件夹来实现效果

### pwd

print the workplace directory

### ls

to exhibit the files of the current directory
`ls -a` show all files including hidden ones
`ls -l` show files with details, use a long listing format

参数补充说明:

- -h: human-readable ？人类可读性？和-l 或者-s 配合显示文件夹的大小多少 K，多少 G，就是多了单位 K、G 这样的，人就可以读懂了
- -i: inode 也就是文件在操作系统中的索引号，唯一标识

借着**ls**命令对 Linux 文件属性做一些笔记

命令`ls -lih`之后展示的文件格式分别是

**inode** | **文件类型和权限** | **硬连接个数** | **文件属主** | **文件属组** | **文件或目录的大小(目录只显示 4KB)** | **文件修改时间(默认月日时分)** | **文件名称**

[这篇](https://www.cnblogs.com/zoulongbin/p/10456285.html)关于文件属性和 linux 系统讲的很细致

文件类型和权限:

- 第一位为文件类型
- 后 9 为每三位为一组，一共三组，分别表示用户，组，其他用户的权限，rwx 分别表示 read，write，execute

### ll

等于 `ls -al`

### mkdir

在当前目录下创建一个文件夹 d

### chown

~~先去有道查了一下，中文解释为“修改文件目录属主”....好吧。~~其实应该是 change owner 这个缩写。。。这个命令主要用于给用户权限，可以把文件仅仅是 root 用户的权限给其他用户
语法：`chown [-cfhvR] user [:group] file`

参数：

```
user : 新的文件拥有者的使用者 ID
group : 新的文件拥有者的使用者组(group)
-c : 显示更改的部分的信息
-f : 忽略错误信息
-h :修复符号链接
-v : 显示详细的处理信息
-R : 处理指定目录以及其子目录下的所有文件(recursively)
```

用法：
`chown coyotewaltz file1.txt`
`chown -R coyotewaltz /abc`

### grep

[维基百科](https://en.wikipedia.org/wiki/Grep)

_g/re/p_ (**g**lobally search for a **r**egular **e**xpression and **p**rint matching lines)

用于查找文件中符合条件的字符串
语法：`grep [-abcdEFGhHi...] [-A<显示列数>] [-B<显示列数>]..`语法有点看不懂

用法：
(1) 查找含有值定的字符串的文件，并打印所在行
`$ grep aaa *file`(后缀有 file 字样的文件)

(2)一般跟在查找结果的后面`grep filename`

### 管道符 |

用来分隔命令，管道符左边的命令输出会作为右边的输入
例：
`cat /etc/passwd | grep /bin/bash | wc -l`
`ps -x | grep mysql`

### curl

**curl**是 Linux 中利用 url 规则的文件传输工具
语法：`curl [option] [url]`

常见参数：

```
-o/--output                                  把输出写到该文件中
-s/--silent                                    静音模式。不输出任何东西
-T/--upload-file <file>                  上传文件
```

基本用法：
(1) 访问网页
`curl https://www.linux.com`
然后 Linux 网站的 html 代码就出现在终端里面了，可以测试是否可到达一个网站

(2) 保存访问的网页

(2.1) 用重定向功能（>>是 linux 重定向功能）
`curl https://www.linux.com >> linux.html`
(2.2) [option] -o(小写 o)来保存
`curl -o linux.html https://www.linux.com`
(2.3) [option] -O(大写 O)保存网页中某个文件
`curl -O https://www.linux.com/hello.sh`

### 查看端口占用情况

#### lsof

list open files 列出当前系统打开文件的工具

`lsof -i:[port]`

#### netstat

`netstat -tunlp | grep [port]`

参数说明:

    -t (tcp) 仅显示tcp相关选项
    -u (udp)仅显示udp相关选项
    -n 拒绝显示别名，能显示数字的全部转化为数字
    -l 仅列出在Listen(监听)的服务状态
    -p 显示建立相关链接的程序名

### 关闭防火墙 ufw

关闭
`sudo ufw disable`
开启
`sudo ufw ensable`
查看状态
`sudo ufw status`
ps:需要重启生效

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
