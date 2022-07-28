# Git

[toc]

## 安装

mac：（貌似内置的 git）

`brew install git`

配置 ssh key，邮箱用户名：略

## git 是什么

参考https://zhuanlan.zhihu.com/p/96631135

管理版本、管理团队开发项目在个人本地的版本的工具

### git init 后的.git 文件夹下有什么？

```bash
❯ ll .git
total 32
-rw-r--r--   1 coyote  staff    23B May 14 18:56 HEAD
-rw-r--r--   1 coyote  staff   137B May 14 18:56 config
-rw-r--r--   1 coyote  staff    73B May 14 18:56 description
drwxr-xr-x  14 coyote  staff   448B May 14 18:56 hooks		# directory 一些钩子脚本
-rw-r--r--   1 coyote  staff   176B May 14 19:01 index    # 暂存区当前的信息
drwxr-xr-x   3 coyote  staff    96B May 14 18:56 info			# directory
drwxr-xr-x   6 coyote  staff   192B May 14 19:01 objects	# directory 所有数据内容
drwxr-xr-x   4 coyote  staff   128B May 14 18:56 refs			# directory 存储数据 commit 对象的指针（收藏夹）heads, tags
```

看看 object 里面有什么，git add 了两个文件 a.txt（123123），b.txt（321321）

```bash
❯ tree .git/objects
.git/objects
├── 3d
│   └── 4db092fd0fd1d1123323e66b47ac05e775cae3
├── e9
│   └── 301bd6b82ab3728f6fc78c396879a458e648d6
├── info
└── pack
```

`git cat-file [-t] [-p]`

- -t 查看类型
- -p 查看 object 具体的内容

```bash
❯ git cat-file -t 3d4d
blob
❯ git cat-file -p 3d4d
123123
```

blob 是啥？英语单词的翻译：a small drop or lump of something viscid or thick; someting shapeless

哈，其实不是，BLOB: Binary Large Object，呵呵。详见另一篇笔记

所以每一个被 add 的文件都成为了一个 blob 节点，用被 hash 的方法存着文件的内容

现在我们 git commit 一下看看

```bash
❯ tree .git/objects
.git/objects
├── 3d
│   └── 4db092fd0fd1d1123323e66b47ac05e775cae3
├── 93	# 新增的
│   └── baaa51e254faac23bf2ae2a6fe42c96369da0e
├── e9
│   └── 301bd6b82ab3728f6fc78c396879a458e648d6
├── f9	# 新增的
│   └── 694a5dfdc51dbe2ebcee9306c14f4dec4e4dd0
├── info
└── pack
```

我们看一下新增的两个是啥类型，注意这里 hash 的前两位作为了文件夹名称

```bash
❯ git cat-file -t 93ba
tree
❯ git cat-file -p 93ba
100644 blob 3d4db092fd0fd1d1123323e66b47ac05e775cae3	a.txt
100644 blob e9301bd6b82ab3728f6fc78c396879a458e648d6	b.txt
❯ git cat-file -t f969
commit
❯ git cat-file -p f969
tree 93baaa51e254faac23bf2ae2a6fe42c96369da0e
author yourname <yourname@example.com> 1589865135 +0800
committer yourname <yourname@example.com> 1589865135 +0800

[+] init
```

酷，新增了两个对象，一个是 tree，表示了文件目录（是一个 commit 时的快照），一个文件[权限，类型，id（sha1），文件名]。

一个是 commit 的信息[提交时的路径 tree 哈希，用户信息，提交的时间戳]。

再提交一次试试看，修改了 a.txt

```bash
❯ tree .git/objects
.git/objects
├── 12	# 新增的tree
│   └── 6ce6bd8e29f234a04f91e733aa9b4c4e690afe
├── 16	#	修改过的a.txt
│   └── 8454e1f8f10a51b7f7ff4cca1bbcb7c573c38d
├── 24	# 新增的commit
│   └── e3bb0ca06df989ea740219180c131c2c2b7aba
├── 3d
│   └── 4db092fd0fd1d1123323e66b47ac05e775cae3
├── 93
│   └── baaa51e254faac23bf2ae2a6fe42c96369da0e
├── e9
│   └── 301bd6b82ab3728f6fc78c396879a458e648d6
├── f9
│   └── 694a5dfdc51dbe2ebcee9306c14f4dec4e4dd0
├── info
└── pack
❯ git cat-file -t 24e3
commit
❯ git cat-file -t 126c
tree
❯ git cat-file -t 1684
blob
❯ git cat-file -p 1684
rrr
❯ git cat-file -p 24e3
tree 126ce6bd8e29f234a04f91e733aa9b4c4e690afe
parent f9694a5dfdc51dbe2ebcee9306c14f4dec4e4dd0					# 注意多了一个父节点commit的哈希
author lijingwei07 <lijingwei07@meituan.com> 1589865678 +0800
committer lijingwei07 <lijingwei07@meituan.com> 1589865678 +0800

2nd
```

注意多了一个父节点 commit 的哈希。

所以一次提交，commit 对象通过保存 tree 的 hash 指向文件路径快照，tree 又保存了文件 blob 对象的 hash，这样就明白文件结构和内容了。多次提交就像树的结构一样串起来。有点区块链的感觉 **Merkle Tree**，还真是。。。。

那么，分支的信息如何保存的呢？

```bash
❯ cat .git/HEAD
ref: refs/heads/master
❯ cat .git/refs/heads/master
24e3bb0ca06df989ea740219180c131c2c2b7aba
```

当前 HEAD 分支指向 refs/heads/master 文件所保存的 hash。

至此我们知道了 Git 是什么储存一个文件的内容、目录结构、commit 信息和分支的。**其本质上是一个 key-value 的数据库加上默克尔树（Merkle Tree）形成的有向无环图（DAG）**。

其实还有第四种 Git object，类型是 tag，在添加含附注的 tag（git tag -a <test>）的时候会新建，是带有备注信息的 tag，会生成一个 tag object 放在 .git/objects 下。

```bash
❯ tree .git/refs
.git/refs
├── heads
│   └── master
└── tags
    └── test

❯ cat .git/refs/tags/test
e313b468a3809ca6aabbc1dc716000c078cb2e19	# 也是一个hash，保存的是备注信息
❯ git cat-file -t e313
tag
❯ git cat-file -p e313
object 24e3bb0ca06df989ea740219180c131c2c2b7aba			# 记录版本的commit号
type commit
tag test
tagger yourname <yourname@example.com> 1589866604 +0800

test			# add tag时候让写的备注吧
```

### git 的三个分区

#### 工作区 workspace

写代码的地方，文件所在空间

#### 索引区

暂存当前 commit 的所有文件的索引，相当于是一个 tree 对象

#### git 仓库

由 Git 的 object 记录着每一次提交的**快照**，以及链式结构记录的提交变更历史。

### 大致工作流程

索引区指向着所有 git objects 里的文件 object，当一个文件内容被改变了，索引不发生变化，当这个文件被 git add 了之后，将改动后的文件生成一个新 blob 放到.git/objects 中，此时索引指向新文件

当执行了一次 commit，将当前索引生成一个新的 tree，生产一个新的 commit 对象，都放到.git/objects 下，更新分支的指向（`.git/refs/heads/<当前分支name>`的 hash 值改为最近的一次 commit）

## git 操作指令

一句话：多用就顺手了！

### commit

> [how to write a good commit message](https://csaju.com/blog/how-to-write-a-good-commit-message/)
>
> - feat: A new feature
> - fix: A bug fix
> - style: Additions or modifications related to styling only
> - refactor: Code refactoring
> - test: Additions or modification to test cases
> - docs: README, Architectural, or anything related to documentation
> - chore: Regular code maintenance

`git commit -m "title" -m "description"`

原来可以两个 `-m` 分别表示 title 和 description

HEAD 会重新指向新的 commit obj 的 hash

#### --amend

通过 `git commit --amend` 进行提交可以修改上一次提交的 commit，用最新的 commit 来替换上一次

```bash
git commit --amend -m 'add b'
```

- 只能修改最近一次的 commit，rebase 和 reset 可以让你修改更前面的 commit

- 也可以单独修改 commit msg：直接 `git commit --amend -m 'change msg'`，替换上一次的 msg

- 注意不要修改之前 public 的 commit 哦

### fetch

`git fetch origin master`

拉取远程仓库最新分支的数据，仅是拉取 data，不会修改本地状态

### pull

实际上是两个指令的合并：`git fetch` and `git merge`

将最新的一次 commit 合并到当前分支

### push

### merge

`git merge dev`将 `dev` 分支合并到当前分支

#### 两种模式

**fast-forward**

git 默认的选项，只发生在当前分支与待合并来的分支之间没有差距，想象一下`dev`分支仅仅只是当前分支的一条支路，是单叉的。

此时发生：

- 不会产生新的 commit，因此不对当前分支产生修改
- 可以理解是 HEAD 移动到了`dev` 分支

查看`git log`可以看出就是将整个模板分支搬过来了

**no-fast-forward**(`--no-ff`)

上面那个情况，通常是往 master 合并的时候会发生的，但通常情况下，我们当前分支和待合并来的分支之间存在不同的 commit（分岔路），此时 git 就是 `--no-ff` 模式

此时发生：

- 将目标分支的 extract commit 搬过来
- 在当前分支上新建一个 merge commit，通常让你输入一段文字来描述此次 merge

完成合并

#### 合并 conflict

合并的时候难免会出现冲突（同一行的代码不一样了、文件删除了等情况）

Git 此时无法判断取舍，留给开发者自行解决冲突

解决之后，`git add`文件，重新 commit 即可

### rebase

同样也是一种将其他分支的改变应用到当前分支的操作。

（**当前`dev`**）`git rebase master`将`dev`分支的根移动到`master`的最顶层 commit 节点

发生：

- 相当于 copy 当前分支的所有 commit 到目标分支的 commit 之上

与 merge 相比，rebase 会改变分支的历史（commit 的 hash，copy 的时候重新计算了）

如果出现冲突，解决完冲突并 commit 之后，`git rebase --continue`继续合并，或者`git rebase --abort`放弃本次操作

#### 交互式的 rebase

`git rebase -i HEAD~3`（HEAD~3 是从当前 commit 节点往前 3 个）

接着 git 会打开一个 vim 编辑器，让你对所有 commit 进行操作（commit 顺序：最新的在最下面）

```bash
pick 7b9162b local arr
pick 6174d7a local yes ok
pick 0c6eb12 mm

# Rebase 3351b9f..0c6eb12 onto 3351b9f (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# ...
```

有多种指令

- `reword`: Change the commit message
- `edit`: Amend this commit
- `squash`: Meld commit into the previous commit
- `fixup`: Meld commit into the previous commit, without keeping the commit's log message
- `exec`: Run a command on each commit we want to rebase
- `drop`: Remove the commit

我们可以对 commit 进行修改和取舍（更多的控制！）

```bash
pick 7b9162b local arr
drop 6174d7a local yes ok
reword 0c6eb12 reword comment msg!

# Rebase 3351b9f..0c6eb12 onto 3351b9f (3 commands)
#
# Commands:
# p, pick <commit> = use commit
# ...
```

**注意：**vim 的保存用`:x`，反正我用`:wq`失败了。。

### reset

糟糕，刚刚提交的代码有 bug，reset 吧！

A `git reset` **gets rid of all the current staged files** and gives us control over where `HEAD` should point to.

会将所有 add 的文件从缓存区拿出来，归还控制权

#### soft reset

将 HEAD 指向（移动到）我们指定的 commit（或者是 HEAD 下标，HEAD~i），**不会丢弃提交**

`git reset --soft HEAD~2`

在`git status`之后还能看到之前 commit 上的改动

#### hard reset

**会丢弃之前的 commit！**

慎用！

### revert

撤销操作的另一个好方法

`git revert <hash>`，会新增一个 commit，回退到那个 commit 时的状态！这样不会修改 commit 历史。

### cherry-pick

当前分支想要用另一个分支**某一次（或者部分）**提交的改动，可以用 cherry-pick，摘下一点樱桃

`git cherry-pick 73we2`，会将那个 commit 的改动内容作为新的 commit 在当前分支上

支持多个 commit 的 pick：

- 多个 commit：`git cherry-pick <HashA> <HashB>`
- 从 A **（不含 A）**到 B 的 commit：`git cherry-pick A..B`，提交 A 必须早于提交 B，否则命令将失败，但不会报错。
- 要包含 A：`git cherry-pick A^..B`

### reflog

to show a log of all the actions that have been taken

查看所有的操作日志，可以用它来精确定位到需要撤销的 commit

### clone

### tag

通常在发布软件的时候打一个 tag，tag 会记录版本的 commit 号，方便后期回溯。

- `git tag`: 列出所有标签，在.git/refs/tags 中找
- -l: 过滤 tag `git tag -l '3.*.*'`
- `git tag name`: 新增 tag，tag 保存的 hash 就是 commit 的 hash
- `git tag -a tagName -m "my tag"`: -a 增加备注，-m 后写备注信息，如果不加-m，会自动弹出让你写的，注意这里 tag 是一个新 object 了
- `git show tagName`: 展示 commit 的信息
- 推送本地所有 tag，使用`git push origin --tags`。
- `git tag -a v1.2 <commit_hash> -m "comment message"`: 给指定的 commit 打 tag，加注释（git log 看 hash）
- `git tag -d v0.1.2`: 删除本地 tag
- `git push origin :refs/tags/<tagName>`: 远端删除 tag

将 tag 同步到远程服务器: git push origin v1.0

切换到一个 tag 上: git checkout 1.0.0，这个时候不位于任何分支，处于游离状态，可以考虑基于这个 tag 创建一个分支。

### show

`git show <hash> | <tag_name>`展示信息

### stash

非常有用的命令，stash 藏匿、存储的意思

#### save

暂存被 add 到暂存区的文件，文件的修改就被藏起来了

```bash
git stash save
```

存储 untracked 的文件，可带 message

```bash
git stash save -u [msg]
# git stash save --include-untracked
```

untracked 文件就被藏起来了，当前`git status`是看不到的

#### list

当输入 `git stash` 或 `git stash save`，Git 会创建一个带名字的 commit 对象，然后保存到你的仓库。

```bash
git stash list
```

查看存储列表，最近的保存会在最上面，像栈一样压入，并且会用 message 来命名

```bash
stash@{0}: On master: ssss
stash@{1}: WIP on master: c73bd7c deletel
stash@{2}: WIP on master: c73bd7c deletel
(END)
```

#### apply

将工作栈中最上面的 stash 应用到工作区中（注意 stash 不会出栈的，还存着）

也可以指定 stash 的 id

```bash
git stash apply stash@{2}
```

#### pop

和 apply 一样，但这次是出栈操作，会删除仓库中的 stash，同时也可以指定具体的 id

```bash
git stash pop
```

#### show

展示最近两次 stash 的差异

如果你想看完整的差异，可以加`-p`，或者指定 stash 查看差异

```bash
git stash show -p
```

#### branch name

```bash
git stash branch <name> stash@{1}
```

这条命令会根据最近（或者指定）的 stash 创建一个新的分支，然后删除最近的 stash（和 stash pop 一样）。

当你将 stash 运用到最新版本的分支后发生了冲突时，这条命令会很有用。直接新建个分支，爽。

#### clear

删除仓库中创建的所有的 stash。有可能不能恢复。

#### drop

删除工作栈中最近的 stash。但是要谨慎地使用，有可能很难恢复，也可以声明 stash id。

### rm

> Git 本地数据管理，大概可以分为三个区：
>
> - 工作区（Working Directory）：是可以直接编辑的地方。
> - 暂存区（Stage/Index）：数据暂时存放的区域。
> - 版本库（commit History）：存放已经提交的数据。
>
> 工作区的文件 git add 后到暂存区，暂存区的文件 git commit 后到版本库。

`git rm`：删除工作区文件，并且将这次删除放入暂存区。（也就是`git status`能看到`deleted xxx`）

#### git rm -f

删除工作区和暂存区文件，并且将这次删除记录放入暂存区。

删完之后工作区和暂存区都没了，直接 commit 也可以的。

#### git rm --cached

删除暂存区文件，但**保留工作区**的文件，并且将这次删除放入暂存区。——也就是文件都是`untracked`状态了

具体使用 case 见下方(.gitignore 不生效

### status

查看当前仓库文件状态

### grep

`git grep` grep 的方式匹配 tracked 文件，[官方文档](https://git-scm.com/docs/git-grep/2.9.5)

可以检查自己的内容有没有什么敏感信息

btw 速度很快

### log

[漂亮的 git log](https://stackoverflow.com/questions/1057564/pretty-git-branch-graphs)

可以在 `.gitconfig` 文件中对指令做 alias

```bash
[alias]
  lg1 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
  lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
  lg = !"git lg2"
```

## .gitignore

### 基本配置

这个文件可以配置不让 git track 的文件/夹

支持 glob 模式匹配

`*` `[]` `?`匹配任意一个字符 `[0-9A-z]` `!`不忽略

大致示例：

`.vscode`

`logs/`

`!/logs/log1.txt`这个文件不忽略，但是其他文件都忽略（上面忽略了）

`*.class`

`**/__pycache__`

可以全局配置，将任意的`.gitignore`文件配置为全局的，比如：

`git config --global core.excludesfile ~/.gitignore`将`~/.gitignore`配置为全局

### .gitignore 规则不生效

`.gitignore`只能忽略没有被 track 的文件，如果开发途中需要添加配置，修改`.gitignore`是没啥用的，所以要养成项目的开始就创建`.gitignore`的习惯

那么我们可以先删掉缓存区的文件，让文件是 untracked 状态，然后重新提交：

```bash
git rm -r --cached .
git add .
git commit -m 'msg'
```

## git log 自己变更的代码行数

```bash
git log --author="your name" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf "added lines: %s, removed lines: %s, total lines: %s\n", add, subs, loc }'
```

## 推荐阅读

[图解 git](https://marklodato.github.io/visual-git-guide/index-en.html)

官方书籍：https://git-scm.com/book/en/v2免费可下载pdf，很多。。

[可视化图解 git](https://dev.to/lydiahallie/cs-visualized-useful-git-commands-37p1)
