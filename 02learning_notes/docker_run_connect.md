# 初探 Docker

体验在服务器上使用 docker 深度学习，网上了解了一些资料后觉得 docker 真的很牛逼，附上一个教程[Docker 最全教程——从理论到实战(一) - 雪雁 - 博客园](https://www.cnblogs.com/codelove/p/10030439.html)，第一篇就介绍了 docker 整个的一个概念。

这次主要是学会简单的使用 docker，并没有什么深度的开发镜像等等操作。也许之后自己写网站也会采用 docker 来托管项目。

### 一些指令

#### docker ps 查看当前运行的 docker 容器

参数：

**-a:**列出所有容器

**-l:** show latest-created container

#### docker image 查看 docker 的镜像

#### docker run [OPTIONS] IMAGE [COMMAND] [ARG...] 创建一个新的容器

参数：

**-d:** 后台运行容器，并返回容器 ID

**-i:** 以交互模式运行容器，通常与 -t 同时使用

**-P:**随机端口映射，内部容器端口随机映射到主机高端口

**-p:**指定端口映射，格式为：**主机(宿主)端口:容器端口**

**-t:** 为容器重新分配一个伪输入终端，通常与 -i 同时使用

**--volume , -v:** 绑定一个卷 格式：**/home/file:/container/file**

**--name="nginx-lb":** 为容器指定一个名称

#### docker (container) attach id 进入一个容器

但这样的问题是 exit 退出之后这个容器就关闭了，解决方法是用 Ctrl+P+Q 来退出

#### docker exec -it containerID /bin/bash 这个命令 exit 退出，ok 容器还在运行

#### docker rm containerID 删除一个容器

### 用 SSH 登录到 docker

参考[来自简书的教程](https://www.jianshu.com/p/c4d4ee6f3663)

首先创建一个 container

`docker run -it -p 50001:22 --name ctrname -d /image /bin/bash`直接以交互式、后台、指定 docker 的 22 端口，也就是 ssh 默认端口到宿主机的 50001 端口来创建容器

然后用`docker attach ID`进入 docker，修改 root 密码，`passwd`，然后配置安装 ssh，`apt-get update`，`apt-get install openssh-server`，修改 sshd_config 的内容`vim /etc/ssh/sshd_config`，将*PermitRootLogin*改为 yes，最后重启 ssh 服务`service ssh restart`

最后就用自己的电脑通过`ssh root@ip -p 50001`来连接就好啦，exit 退出后在服务器上还会运行。

### 在 vs code 上使用插件连接 docker

首先，连接互联网，打开需要的内网穿透软件。

安装插件**Remote Development**，然后左下角会出现两个箭头组成的小图标，点击他，选择*Remote-SSH:Connect to Host*新建一个 ssh HOST，按照提示连接，选择 ssh 配置文件，然后打开这个文件可以修改 hostname，新建完成之后就可以连接了。会新开一个 vscode 窗口，输入密码以登录。选择 workplace 打开，也需输入密码。

之后就可以愉快的 vscode 上远程编程了

### 之后的内容等用到在继续学
