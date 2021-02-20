# VIM 按键笔记

**是真的记不住**

---

### visual 模式

按 v 进入文本选择模式

再次按 v 退出

V 选择行

Ctrl+v 选择块

- 通过 visual 模式选择文本
- d 可删除
- y 复制到寄存器?，在其他位置按 p 粘贴

### 删除

- x 删除光标上的字
- dd 删除一整行

### 复制粘贴

- yy 复制光标所在的当前行
- p 粘贴当前缓冲区的内容
-

### 撤销、重做

- u 撤销
- :u[ndo] 撤销
- Ctrl+R 重做
- :red[o] 重做一个被撤销的

### 不要习惯去 Ctrl + S

`CTRL-S`会阻塞所有的输入，解决方式为**`CTRL-Q`**。

这个锅要 Terminal 去背，因为这个是终端的组合件，作用是停止所有输出，同时在 VIM 中的作用是阻塞所有输入，所以...习惯按了之后，移动光标是可以的，但是你看不到。

### 移动光标

上下左右 : k j h l

- 文末 G
-

### 编辑

- i insert
- a

### 保存退出

- :wq 这个保存退出和 x 是有区别的
- :x
- :q! 强制退出
- :q 退出
- :w 保存

### 永久显示行号

复制一份 vim 配置到个人目录下

`cp /usr/share/vim/vimrc ~/.vimrc`

编辑一下，加入

```bash
syntax on
set nu!
set ruler
```

以及其他的一些参考

```bash
set nocompatible                 "去掉有关vi一致性模式，避免以前版本的bug和局限

set nu!                                    "显示行号

set guifont=Luxi/ Mono/ 9   " 设置字体，字体名称和字号

filetype on                              "检测文件的类型

set history=1000                  "记录历史的行数

set background=dark          "背景使用黑色

syntax on                                "语法高亮度显示

set autoindent                       "vim使用自动对齐，也就是把当前行的对齐格式应用到下一行(自动缩进）

set cindent                             "（cindent是特别针对 C语言语法自动缩进）

set smartindent                    "依据上面的对齐格式，智能的选择对齐方式，对于类似C语言编写上有用

set tabstop=4                        "设置tab键为4个空格，

set shiftwidth =4                   "设置当行之间交错时使用4个空格

set ai!                                      " 设置自动缩进

set showmatch                     "设置匹配模式，类似当输入一个左括号时会匹配相应的右括号

set guioptions-=T                 "去除vim的GUI版本中得toolbar

set vb t_vb=                            "当vim进行编辑时，如果命令错误，会发出警报，该设置去掉警报

set ruler                                  "在编辑过程中，在右下角显示光标位置的状态行

set nohls                                "默认情况下，寻找匹配是高亮度显示，该设置关闭高亮显示

set incsearch                        "在程序中查询一单词，自动匹配单词的位置；如查询desk单词，当输到/d时，会自动找到第一个d开头的单词，当输入到/de时，会自动找到第一个以ds开头的单词，以此类推，进行查找；当找到要匹配的单词时，别忘记回车

set backspace=2           " 设置退格键可用
```

### 插件管理 Vundle.vim

https://github.com/VundleVim/Vundle.vim

readme 写的很清楚。还是摘录一下吧。

1. clone 到本地`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`

2. 然后在`.vimrc`中配置以下的内容

3. 注意，很多是示例内容，自行添加`"`注释

4. 然后自己加入需要的插件，在`call vundle#begin()`和`end()`之间，比如`Plugin 'https://github.com/nathangrigg/vim-beancount.git'`

5. 配置好之后，在命令行输入`vim +PluginInstall +qall`开始安装

```bash
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
```
