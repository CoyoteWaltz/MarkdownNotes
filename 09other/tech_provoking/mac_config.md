# Mac Configuration For Love

[TOC]

## Foreword

终于投入 mac 的怀抱了，搞！

安利一个老外的[博客](https://www.robinwieruch.de/mac-setup-web-development/)，里面是他配置 mac 的记录，可以

## Programming Env

### Haskell

#### 下载

下载 [ghcup](https://www.haskell.org/ghcup/) —— an installer for the general purpose language Haskell

在命令行直接用`ghci`进行交互式的 repl 了

编译器：[GHC](https://www.haskell.org/ghc/) Glasgow Haskell Compiler

#### VScode 插件

直接搜 haskell 安装即可

还可以参考 medium [这篇](https://medium.com/@dogwith1eye/setting-up-haskell-in-vs-code-with-stack-and-the-ide-engine-81d49eda3ecf)（墙外）

### C/C++

编译器直接用 clang 就可以了

然后在 vscode 里面配置

推荐直接看[官网](https://code.visualstudio.com/docs/cpp/config-clang-mac)

编译：`⌘ + ⇧ + b`

#### in VScode

1. Codelldb 插件启动 mac 上的 lldb（win 和 linux 用的是 gdb）
2. 替换成`${fileBasenameNoExtension}`，在[官网](https://code.visualstudio.com/docs/editor/variables-reference)可以找到配置文件的变量含义
3. 在面板配置 clang++ 的 build task，记得设置 c++ 的标准 `-std=c++2a`（其实本质还是用命令行去调用 clang++，配置一个脚本点点就行）
4. 记得在 debug 的 launch task 中增加 `preLaunchTask` 值为 build task 的 label，让 debug 任务之前先做 build task

_说白了就是一套自动化的脚本，clang++ build 出的产物，被 lldb 执行 debug_

### Golang

`brew info go` 先看看 info

`brew install go` 应该需要科网吧，反正我是开了的，不开没试过

`go version`查看版本

### Python

直接装 anaconda 吧省事，官网找到 mac 的下载，一步步安装

`conda config --set auto_activate_base false`取消每次都激活 base 环境

当然也可以重新设置为 true

激活的时候还是`conda activate`

创建环境的时候有点坑。。

- `conda create -n <envName> python=3.7`一定要指定一下解释器版本，不然默认是 python2.7

后来我放弃了 anaconda3 觉得太大太臃肿了，还是直接装 python 比较简单

### Java

`java`在命令行里试一下会提示要安装，直接点开链接

在[官网](https://www.oracle.com/java/technologies/javase-downloads.html)下载安装 dmg，打开是 pkg，安装即可

也不需要配置 proflie 文件里面的路径。。看网上配置那些路径是为了能够在任何地方使用`java`

检查是否安装成功

```bash
java -version
java
javac
```

写个 helloworld 试试

```java
public class Helloworld {
    public static void main(String[] sss) {
        System.out.println("hello java");
    }
}
```

```bash
javac Helloworld.java
java Helloworld
hello java
```

### Node

#### nvm

node version manager，项目用到 node 版本可能都不一样

安装`curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash`

安装和切换版本

```bash
nvm install v8.11.3 ｜ 8	# 安装某个版本
nvm use 8								# 切换
nvm ls									# 查看已经安装的版本
nvm alias default 12	# 设置默认版本
```

命令行中如果`command nvm not found`的话：

1. 在`.zshrc`中加入`[[ -s $HOME/.nvm/nvm.sh ]] && . $HOME/.nvm/nvm.sh # This loads NVM`
2. `source .zshrc`一下

切换 node 的下载源：

- 在`.zshrc`中加入：`export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/dist`切换为淘宝

#### nrm

统一的 npm **源管理**，npm 和 yarn 同时管理

通常全局配置用`npm config set registry https://registry.npm.taobao.org`

全局安装` npm install -g nrm`

`nrm ls`

`nrm add 名字 源的地址`

`nrm use 名字 `

`nrm test`测试速度

#### npm

node 的包管理器，不多说了

#### yarn

> 与安装缓慢的`npm`相比，`yarn`通过并行安装与离线模式的缓存，使其模块安装速度快的令人发指，并且还做出了多项改进，因此在新的项目中，推荐使用`yarn`

`brew install yarn`

或者`npm install -g yarn`

### MySQL

直接[官网下载](https://dev.mysql.com/downloads/mysql/) community 版本的 dmg 安装即可

然后可以在 settings 中看到 MySQL 的服务

#### 命令行进入

不能像 linux 一样直接用`mysql`命令进入服务（没注册到环境变量吧）

需要`/usr/local/MySQL/bin/mysql -u root -p`

在`.zshrc`中 alias 一下

`alias mysql="/usr/local/MySQL/bin/mysql"`

## Softwares

> https://github.com/jaywcjlove/awesome-mac上有非常棒的软件推荐

### A 区账号获取教程

[苹果 A 区账号搞定教程](https://zhuanlan.zhihu.com/p/156908712)

### 远程连接文件传输

filezilla，还挺好用的，和 win-scp 差不多，拖来拖去传文件

去官网 https://filezilla-project.org/ 下载就好

### 解压 rar

Use `brew install rar` to install both the rar and unrar binaries.

添加 oh-my-zsh 的插件`extract`

命令行用`x`即可

### 截图软件 Xnip

http://xnipapp.com/

很好用啊！免费，App store 直接下载

### cleanmymac

### vscode

不多说了官网直接下载解压就是 app 了

记得拖到应用程序

~~在`.zshrc`中加入`alias code=/Applications/Visual\ Studio\ Code.app/Contents/Resources/bin/code`，source 一下之后就可以`code <path>`了~~

命令行`code`指令直接[官方的操作](https://code.visualstudio.com/docs/editor/command-line#_common-questions)，`⇧ + ⌘ + p`然后输入类似`shell command install 'code'`的语句就让 vscode 自己帮我们在环境变量中加 code 指令

#### 开启 TS 的引用计数

在 settings 中搜索 `codelens`，在 extensions 中找到 TypeScript，开启 `References Code Lens`

开启之后就能看到每个变量/属性被引用的次数啦，很方便。

#### 开启长按键盘

```bash
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
```

让 vim 插件按着 j 可以一路往下

mac 下全局，不建议这么做

```bash
defaults delete -g ApplePressAndHoldEnabled  # If necessary, reset global default
```

#### 工具插件推荐

- 主题啥的自己挑吧
- gitlens：git 必用，特别好用
- rainbow bracket：彩虹色括号
- rainbow indent：彩虹色锁进
- polacode：分享代码的好插件`⌘ + ⇧ + p` -> polacode
- code spell checker：检查拼写`⌘ + .` to fix spelling
- leetcode：刷 leetcode 适合装这个，按照教程登陆
- Prettier: 可以用`.prettierrc.js`文件自定义格式要求，是一个 module，也可以在设置里面配置
- code runner：跑代码的，推荐
- javascript console utils：写 JS 的时候让`console.log`更加方便，`⌘ + ⇧ + L`生成`console.log`行（选中变量会自动填充），`⌘ + ⇧ + D`删除文档内所有的`console.log`行（但那一行不会被删。。），PS：由于删除的快捷键被 Dato 占用了，就改成了`⌘ + ⌥ + D`
- code tour：在 vscode 中的代码指引
- outline map：同事推荐的，好评！能够把代码结构作为目录在侧边展示，很棒！

推荐一手托尼的 [vscode settings](https://github.com/antfu/vscode-settings)

#### 如何干光 vscode

统统删光

```bash
#!/bin/sh

rm -rfv "$HOME/.vscode"
rm -rfv "$HOME/Library/Application Support/Code"
rm -rfv "$HOME/Library/Caches/com.microsoft.VSCode"
rm -rfv "$HOME/Library/Saved Application State/com.microsoft.VSCode.savedState"
```

```bash
#!/bin/sh

rm -rfv "$HOME/.vscode-insiders"
rm -rfv "$HOME/Library/Application Support/Code - Insiders"
rm -rfv "$HOME/Library/Caches/com.microsoft.VSCodeInsiders"
rm -rfv "$HOME/Library/Saved Application State/com.microsoft.VSCodeInsiders.savedState"
```

### homebrew

（必装）命令行装包工具，**The Missing Package Manager for macOS (or Linux)**这 missing 是指？

名字很有意思，酿酒厂？

#### 安装

按照[brew.sh](https://brew.sh/)官网教程安装，使用很简单

检查是否装好`brew doctor`

若上面命令执行过程出现 _hombrew libevent not link_ 的错误，执行下面命令即可：

```bash
sudo chown -R $USER $(brew --prefix)
```

#### 使用

`brew search git`搜索

`brew list`

`brew update`

`brew cask install firefox`能省去拖动图标到 Application 的操作哟

这个 cask，木桶，装入桶内，有趣的词语（这个 cask 其实也是一个包，可以下载的）

卸载一个包（下面两个是一样的效果。。。）

`brew uninstall packageName`

`brew remove packageName`

可选的 flag：`–force` and `–ignore-dependencies`.

`brew deps packageName`查看包的依赖

#### 推荐的包

可[参考](https://osxdaily.com/2018/03/26/best-homebrew-packages-mac/)

- wget
- nmap
- cask
- geoiplookup

### git

`brew install git`

密钥

`ssh-keygen -t rsa -C "${你的邮箱地址}"`

### docker

[官网](https://www.docker.com/get-started)下载 dmg 安装 or [阿里云 Docker dmg 镜像](http://mirrors.aliyun.com/docker-toolbox/mac/docker-for-mac/stable/)

### Warp

[官网](https://www.warp.dev/)

同事推荐的另一款很好用的 terminal（rust 写的），官网下载即可

集成了很多功能，下面 Iterm2 提到的所有功能基本都集成了，ohmyzsh 的插件也基本上都集成了，界面也很酷

- hot key window（可自定义快捷键）：在设置里就有
- AI commend search：非常好用的功能，能通过大白话搜索出 shell 指令，很棒
- Block：每次指令 + result 都是一个 block，可以移动选中复制，很方便
  - 甚至可以分享 block 成网页链接给别人看！
- Text-editor：可以更爽的编辑文本，很棒
  - 选中单词 `⌃ + G`，这里和平时的 `⌘ + D` 不一样
- History：可视化的搜索 history，比 history 指令配合 ! 来用方便多了

[gci](https://www.npmjs.com/package/git-checkout-interactive) 可交互式切分支



### Iterm2

#### 安装

`brew cask install iterm2`

#### 使用

分屏快捷键操作：

- `⌘ + d`: 垂直分屏
- `⌘ + ⇧ + d`: 水平分屏
- `⌘ + ]`和`⌘ + [`在最近使用的分屏直接切换
- `⌘ + ⌥ + 方向键`: 切换到指定位置的分屏

快捷键丰富（不一一详细列举，只列了几个目前常用的）

- `⌘ + 数字`: 切换标签页，`⌘ + 方向键` ~~按方向切换标签页~~貌似是滚轮的作用
- `⌘ + enter` : 切换全屏
- `⌘ + t`: 新的标签页
- `⌘ + w`: 关闭标签页
- `⌘ + r`: 清屏
- `⌘ + /`: 定位 cursor
- `⌘ + ⌥`: 按住这两个键可以拖一个长方形来选择

**选中即复制**

- 一种是用鼠标，在 iTerm2 中，选中某个路径或者某个词汇，那么，iterm2 就自动复制了；
- 另一种是无鼠标模式，按下`⌘ + f`，弹出 iTerm2 的查找模式，输入要查找并复制的内容的前几个字母，确认找到的是自己的内容之后，按下`tab`，查找窗口将自动变化内容，并将其复制。如果按下的是`shift + tab`，则自动将查找内容的左边选中并复制。

管理密码：window -> Password Manager 中配置账号秘密，比如常用的`sudo`密码，if u want... 快捷键`⌥ + ⌘ + f`

Preferences -> Pointer 按住 ⌘ 点击文件/目录就会打开 finder，**贼方便**

标记命令的 mark

- 可以为那一行命令加一个 marker，复盘
- Edit -> Marks and annotations 看如何设置和跳转 mark 的快捷键

#### 主题配置

色彩主题：https://github.com/mbadolato/iTerm2-Color-Schemes

#### 快捷键

- 第二屏

挺好用的功能，能够独立在屏幕上面出现

设置一个新的 window profile，然后将 window 属性中的 Style 选择为 Full-Width Top of Screen，然后在 Keys 属性中绑定快捷键，我用的`⌃ + ⌘ + e`

- 指令输入面板

`⌘ + ⇧ + .` 打开面板输入指令，当复制很长文本的时候可以一口气放入这个面板。

#### 插件

- [imgcat](https://iterm2.com/documentation-images.html) 在终端查看图片，[如何安装](https://apple.stackexchange.com/questions/256322/how-to-install-imgcat-on-iterm2)
- 上面这个安装方法还装了一堆东西。。

### oh-my-zsh

基于 `zsh` 的增强配置, 附带各种常用的插件，以及一些自带的 [tricks](https://www.twilio.com/blog/zsh-tricks-to-blow-your-mind)

#### zsh 是什么

https://www.zsh.org/好像崩了看[知乎](https://www.zhihu.com/question/21418449)吧，比cmd，bash好用的shell

#### 安装

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`

设置为默认 zsh：`chsh -s /bin/zsh`

在`.zshrc`中配置

```bash
HIST_STAMPS="yyyy-mm-dd"
HISTFILESIZE=100000
HISTFILE=~/.zsh_history
```

#### tricks

> https://www.twilio.com/blog/zsh-tricks-to-blow-your-mind

take

- 同时做到了 mkdir xxx && cd xxx

zmv

- 批量重命名文件，感觉就是这个 mv
- 需要安装，执行 `autoload zmv` 就行
- 例子：`zmv '(*).(jpg|jpeg)' 'epcot-$1.$2'`
  - 可以用 `()` 做 group，用 `$n` 取 group 的值
  - 可以加 `-n` 参数展示具体对应的 mv 操作，但他不会执行

web-search

- 可以直接在命令行 `google sth`

sudo

- 可以通过两次的 `esc` 在 command 前补充 `sudo`

Park a command

- 通过 `⌃ + q` ctrl + q 暂存本次输入的 command，在输入完下次指令之后再让他出现

#### 插件

_在`.zshrc`中写入`plugins=(name)`，安装完 oh-my-zsh 就会有，找到即可_

autojump

- 非常好用的懒人跳转路径插件，根据 cd 到目录的频率作为权重
- python 写的https://github.com/wting/autojump
- `brew install autojump`在`.zshrc`中的 plugins 加上 autojump，source 一下
- `j | autojump <路径/部分名字>`
- `jc`(child directory), `jo`(open in finder), `jco`
- `j --stat`查看权重，可以在 data 所指的文件夹修改
- 反正就 j 来 j 去

git

- `gst` => `git status`
- `gco` => `git checkout`
- `ga` => `git add`
- `gb` => `git branch`
- `ggpul` => `git pull origin "$(git_current_branch)"`
- `gl` => `git pull`
- `gcmsg` => `git commit -m`
- 其他 alias 见https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git/#aliases

extract

- 命令行用`x filename`即可
- 会自动根据所解压的文件类型，比如 rar 就会调用`unrar`去解压，前提是你要安装

zsh-autosuggestions

- 安装见 github: https://github.com/zsh-users/zsh-autosuggestions
- 在`.zshrc`中加入`bindkey '^v' autosuggest-accept`可以增加填充的快捷键，我给的`⌃ + v`，默认是右方向键（始终有效）
- 可以配置提示的颜色`ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#1ABDE6"`也可以`ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"`用逗号隔开，这个 bg 是 cyan 很丑。。

zsh-syntax-highlighting

- 高亮命令行语法的，github：https://github.com/zsh-users/zsh-syntax-highlighting

- 同样可以配置

  ```shell
  ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
  # To have commands starting with `rm -rf` in red:
  ZSH_HIGHLIGHT_PATTERNS=('rm -rf *' 'fg=white,bold,bg=red')
  ```

- 参考色彩配置：https://coderwall.com/p/qmvfya/syntax-highlighting-for-zsh

还有好用的插件

#### 主题

用[powerlevel10k](https://github.com/romkatv/powerlevel10k#get-started)，~~安装起来有点复杂~~，但是很好看！

1. 跟着[步骤](https://github.com/romkatv/powerlevel10k#oh-my-zsh)来，非常简单
2. `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k`
3. Set `ZSH_THEME="powerlevel10k/powerlevel10k"` in `~/.zshrc`.
4. source 之后，Type `p10k configure` to access the builtin configuration wizard right from your terminal.一步一步配置，记得一定要安装他推荐的字体

git 符号的含义：https://github.com/romkatv/powerlevel10k#what-do-different-symbols-in-git-status-mean

如果在 vscode 中也要用 iterm2，记得配置一下默认 shell，**并且在字体 family 中加**`MesloLGS NF`

### 字由&字魂

都是可以获取免费商用字体的软件

字由：https://www.hellofont.cn/

字魂：https://izihun.com/

### VPN

自行查找。。

西游还不错，就是有点贵

### raycast（spotlight 的高效替代）

> https://www.raycast.com/

提效工具，很好用！配合插件市场，能满足很多快捷功能。不好说和 alfred 的比较，因为没用过（收费）


- 插入 snippet（比如：插入时间戳[[../sundries/macos_insert_date_shortcut]]）
	- btw 这个 snippet 他更推荐的是在 raycast 内部用，可以用 keywords 直接原地替换内容
	- 在 font-most 的 app 中插入 snippet 是需要用 search snippet
- 找 npm 包
- 查单词
- 计算器
- floating note
- clipboard history
- ...


## OS stuff

> just like linux/unix
>
> 指令 see [linux_cmd_ubuntu_notes_archived.md](linux/linux_cmd_ubuntu_notes_archived.md)

### macOS 查看端口占用情况

1. 网络实用工具

点击左上角的苹果标 -> 点击关于本机 -> 点击系统报告 -> 点击菜单栏上的窗口 找到「网络实用工具」

在扫描端口这里，输入域名即可开始扫描，略慢

2. 命令行检查

```bash
lsof -i :<port>
```





### .DS_Store 文件是啥

经常能在文件夹中看到这个文件，好奇知乎了一下：保存文件夹的自定义属性的隐藏文件，如文件的图标位置或背景色

删除的副作用不大，损失信息罢了，**可删**

关闭它的生成：`defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE`

恢复：`defaults delete com.apple.desktopservices DSDontWriteNetworkStores`

### exa for `ls`

Rust 写的，ls 的现代替换方案。[github](https://github.com/ogham/exa)

比 `ls` 爽太多了吧，赶紧 alias ls 吧。

#### 安装

```bash
brew install exa
```

#### Display Options

- **-1**（数字 1）, **--oneline**: display one entry per line
- **-G**, **--grid**: display entries as a grid (**default**)
- ==**-l**, **--long**==: display extended details and attributes
- ==**-R**, **--recurse**==: recurse into directories
- ==**-T**, **--tree**==: recurse into directories as a tree
- **-x**, **--across**: sort the grid across, rather than downwards
- **-F**, **--classify**: display type indicator by file names
- **--colo[u]r**: when to use terminal colours (auto, auto, never)
- **--colo[u]r-scale**: highlight levels of file sizes distinctly
- **--icons**: display icons 酷，太酷了

#### Filtering Options

- **-a**, **--all**: show hidden and 'dot' files
- **-d**, **--list-dirs**: list directories like regular files
- **-L**, **--level=(depth)**: limit the depth of recursion
- **-r**, **--reverse**: reverse the sort order
- **-s**, **--sort=(field)**: which field to sort by
- **--group-directories-first**: list directories before other files
- **-D**, **--only-dirs**: list only directories
- **--git-ignore**: ignore files mentioned in `.gitignore`
- **-I**, **--ignore-glob=(globs)**: glob patterns (pipe-separated) of files to ignore

#### Long View Options

只有`-l`模式下可以用

- ==**-h**, **--header**==: add a header row to each column
- **-b**, **--binary**: list file sizes with binary prefixes
- **-B**, **--bytes**: list file sizes in bytes, without any prefixes
- ==**--git**==: list each file's Git status, if tracked or ignored

还有好多 long 模式下展示的选项，详见 [github](https://github.com/ogham/exa#long-view-options)

### 如何剪切

- `⌘ + c`之后`⌘ + ⌥ + v`

### 如果无法访问例如 github

网络不太行。。。

上https://www.ipaddress.com/去找这个域名对应的ip

加到你的`hosts`文件

_当然得到 ip 的方法不止这一种，直接看请求头也很快_

实在不行试试连 vpn

或者换 dns 服务器域名

### 特殊表情、字符

`⌃ + ⌘ + ␣`开启面板

### 快捷键汇总

[官方](https://support.apple.com/zh-cn/HT201236)，[finder 使用](https://www.jianshu.com/p/3666e6954e8a)

- 隐藏/显示程序 dock：`⌥ + ⌘ + d`
- **分屏：**鼠标悬停在全屏键两秒
- 截全屏：`⇧ + ⌘ + 3`
- 区域截屏：`⇧ + ⌘ + 4`
- **多功能截屏/录屏：**`⇧ + ⌘ + 5`
- 全局文件搜索/快捷打开 finder：`⌥ + ⌘ + ␣`
- 新建窗口：`⌘ + n` 啥都可以新开
- 强制退出应用：`⌘ + ⌃ + esc`
- 推出硬盘：`⌘ + e`

### 显示隐藏文件

`⌘ + ⇧ + .`

finder 下使用 Command+Shift+G，隐藏文件夹也能访问

见https://support.apple.com/zh-cn/HT201586

### Catalina 10.15 修改根路径文件解决方案

#### 背景

- 尝试修根目录报错*mkdir: /data: Read-only file system*
- 发现无法在根路径下创建/修改，是 macos 新版本的硬性规定

#### 解决方案：将需要的根目录下路径软连接到非根目录（相当于给一个跨快捷方式）

需要关闭 System Integrity Protection(SIP)服务才可重新挂载，具体操作步骤如下：

1. 关机按 cmd+R 重启进入恢复模式, 关闭 SIP(命令: `csrutil disable` ), 正常重启
2. 在自己的目录下创建 /usr/local/casual/data 文件夹，这个目录随意，有权限即可（添加权限使用 chmod 指令）
3. 重新挂载根目录 (命令: `sudo mount -uw /`)
4. 软连接目录 `sudo ln -s /usr/local/casual/data /data`
5. 关机按 cmd+R 重启进入恢复模式, 打开 SIP(命令: `csrutil enable`), 正常重启
