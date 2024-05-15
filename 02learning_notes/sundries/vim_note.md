# VIM 按键笔记

> **是真的记不住**
>
> [马老师的分享合辑](https://thinking.tomotoes.com/tags/tool/vim)
>
> [Key map](https://vim.rtorr.com/)

## 环境配置

> 来自 ben 的 [how to config your vim like vscode](https://www.youtube.com/watch?v=gnupOrSEikQ)
>
> _ben 大佬主要是写前端比较多吧（ts，js） some vscode features in vim_
>
> 环境：macOS 11+
>
> terminal：iterm2

### Neovim

> 装了 [neovim](https://neovim.io/) 目前还不知道有啥好的地方
>
> hyperextensible Vim-based text editor，超高拓展能力的 vim 编辑器

`brew install neovim` 即可

设置为英文，默认是跟着 local 系统的。。

`language en_US`

### 插件管理 Vim Plug

> A minimalist Vim plugin manager. 既然 neovim 是 hyperextensible 的了，那肯定需要一个插件管理

#### 安装

[github](https://github.com/junegunn/vim-plug) 安装之后在 init.vim 文件中（可以新建在 `~/.config/nvim`）

1. 用 `call plug#begin()` 作为开头
2. `Plug` 指令列出需要安装的插件
3. `call plug#end()` to update `&runtimepath` and initialize plugin system
   1. Automatically executes `filetype plugin indent on` and `syntax enable`. You can revert the settings after the call. e.g. `filetype indent off`, `syntax off`, etc.

例子：光是声明插件就很多种方法

```bash
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Multiple Plug commands can be written in a single line using | separators
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using a non-default branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }

" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'

" Initialize plugin system
call plug#end()
```

#### 指令

| Command                             | Description                                                          |
| ----------------------------------- | -------------------------------------------------------------------- |
| `PlugInstall [name ...] [#threads]` | **Install plugins**                                                  |
| `PlugUpdate [name ...] [#threads]`  | **Install or update plugins**                                        |
| `PlugClean[!]`                      | **Remove unlisted plugins (bang version will clean without prompt)** |
| `PlugUpgrade`                       | **Upgrade vim-plug itself**                                          |
| `PlugStatus`                        | **Check the status of plugins**                                      |
| `PlugDiff`                          | Examine changes from the previous update and the pending changes     |
| `PlugSnapshot[!] [output path]`     | Generate script for restoring the current snapshot of the plugins    |

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

### [coc.nvim](https://github.com/neoclide/coc.nvim)

> Make your Vim/Neovim as smart as VSCode. github
>
> 国人写的，牛逼
>
> 很厉害，支持全 [LSP](https://github.com/neoclide/coc.nvim/wiki/Language-servers#supported-features)
>
> - 想用什么语言就配置一下

可以配置各种插件

或者在 `init.nvim` 里面

```bash
" coc config
let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-pairs',
  \ 'coc-tsserver',
  \ 'coc-eslint',
  \ 'coc-prettier',
  \ 'coc-json',
  \ ]
```

或者使用命令安装

`:CocInstall xxxx`

#### 生态体系

- [coc-snippets](https://github.com/neoclide/coc-snippets)：snippets 快捷键

  - `:CocCommand snippets.editSnippets` 去设置**本文件类型的**快捷代码段

- 重命名函数：

  - `nmap <F2> <Plug>(coc-rename)` 绑定了 F2 去使用 plug 插件 coc-rename
  - vscode 也是 F2 重命名所有的地方，但我从来没用过。。

- Prettier，在 `coc-settings.json`

  - ```json
    {
      "suggest.noselect": false,
      // 以下文件类型保存的时候就 prettier
      "coc.preferences.formatOnSaveFiletypes": [
        "javascript",
        "typescript",
        "typescriptreact",
        "json",
        "javascriptreact",
        "typescript.tsx",
        "graphql"
      ]
    }
    ```

- 自动填充 ctrl+space

  - `inoremap <silent><expr> <c-space> coc#refresh()`

#### 一些配置

空格组合键

```bash
" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
```

ben 在配置文件中重新 map 了一些指令 -> 插件

```bash
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition) " C-o go back
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
```

### 文件 explore

#### [preservim/nerdtree](preservim/nerdtree)

> a file system explorer for the Vim editor

屏蔽了

- `node_modules`：`let g:NERDTreeIgnore = ['^node_modules$']`
-

#### [nerdtree-git-plugin](https://github.com/Xuyuanp/nerdtree-git-plugin)

这个是在 nerdtree 基础之上的插件，可以显示文件的 git 记录

可以自定义标记

```ts
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
```

#### [vim-nerdtree-syntax-highlight](https://github.com/tiagofumo/vim-nerdtree-syntax-highlight)

icon 插件，[vim-devicons](https://github.com/ryanoasis/vim-devicons) 这个也是，记得需要装一个字体（readme 里面有写 brew 装就行了），然后在 iterm2 里也设置一下

#### [ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)

> 模糊查找文件 这个名字也就是他的用法 `⌃ + p`

屏蔽所有的 gitignore 文件：`let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']`

在 iterm2 中改写 hotkey map `⌘ + p` => `⌃ + p` 保持和 vscode 一样 hh

- Key bindings 中 send text `:CtrlP\n`

ben 写了两个函数用来同步打开 fuzz 搜索的文件，并且在目录上 highlight，太强了

```bash
" sync open file with NERDTree
" " Check if NERDTree is open or active
function! IsNERDTreeOpen()
  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
endfunction

" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
" file, and we're not in vimdiff
function! SyncTree()
  if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
    NERDTreeFind
    wincmd p
  endif
endfunction

" Highlight currently open buffer in NERDTree
autocmd BufEnter * call SyncTree()
```

#### [nerdcommenter](https://github.com/preservim/nerdcommenter)

Ben 用几乎不会使用的指令来开启注释

```bash
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle
```

然后在 iterm2 里重新绑定成 vscode 的 hotkey 哈哈哈

- `⌘ + \` => `++`

#### [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)

> 不太知道啥事 tmux 了，理解就是让 terminal 能够上下左右切分屏幕，通过 C-lkjh 跳转

### theme

#### [gruvbox](https://github.com/morhetz/gruvbox)

> 主题插件

#### [yats.vim](https://github.com/HerringtonDarkholme/yats.vim)

> ts syntax 插件 配合使用

### git

> git 这块功能还是蛮重要的

#### [vim-gitgutter](https://github.com/airblade/vim-gitgutter)

> 显示文件内 git diff gutter（槽） 的插件

- `]c` 跳到下一个 diff 片段（hunk）`[c` 是上一个
- `\hp` 可以查看当前 hunk 的 diff，做了 map ` nmap ;; <leader>hp`
- `\hu` hunk undo
- `\hs` hunk staged

### 其他设置

#### 显示时间和行数 statusline

`set statusline=\PATH:\ %r%F\ \ \ \ \LINE:\ %l/%L/%P\ TIME:\ %{strftime('%c')}`

## 操作

### 重新定义指令

各种 map，可以在不同的 mode 下（normal、visual、insert）

#### vmap

#### inoremap

insert mode 下替换

`:inoremap a b` map a to b

### Global command

`:g`

### 基础操作

#### 移动

```json
h       左
j       下
k       上
l       右
space   右

```

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

> _yank_ ( y ), cut is called delete ( d )

- yy 复制光标所在的当前行
- p 粘贴当前缓冲区的内容

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

### 编辑

- i：insert before the cursor
- a：after the cursor

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

### 选择全部内容

组合使用！

`ggVG`

### 复制到剪切板

[来自](https://unix.stackexchange.com/questions/12535/how-to-copy-text-from-vim-to-an-external-program)

`"+y`

## 学习

学习资料：

- http://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/
- https://www.barbarianmeetscoding.com/boost-your-coding-fu-with-vscode-and-vim/introduction

### Vim & Vi

Vi：an ancient text editor, designed to work on contraptions called terminals

VIM：**V**i **IM**proved and formerly **V**i **IM**itation

VIM 是你变得更快、更准、在编辑器中不同级别的控制能力

HOW？VIM 的 modes！

**entirely keyboard driven workflow**

### Combine VIM with VSCode

VSC 真的爽啊好用啊，不如结合 VIM 吧

- 首先是 VSCode 提供的拓展能力是在太方便了
- 然而在 VIM 中配置这堆东西不是那么的容易，即使配了也不够完美

#### Setup

VIM 插件直接安装

### Modes

#### Normal

回到 Normal：

- `Esc`
- `C-c`
- `C-[`

#### Insert

#### Visual
