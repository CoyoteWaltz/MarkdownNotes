# Git 大仓库

在 git-scm.com 点击 git 图标，你可以看到如下几句话：

1. --fast-version-control （快捷的版本控制）
2. --local-branching-on-the-cheap （廉价的本地分支）
3. --distributed-is-the-new-centralized （分布式是新的集中式）
4. --distributed-even-if-your-workflow-isnt（分布式，且与你的工作流无关）
5. --everything-is-local（一切本地化）

提到大仓库，大家通常会联想到单仓 Monorepo。

行业内最出名的几家 monorepo 实践分别是：

1. Google，基于 [Perforce](https://www.perforce.com/)[3] 开发而来的 Piper。
2. Facebook，基于 [Mercurial](https://www.mercurial-scm.org/)[4] 定制化实现。
3. Microsoft，基于 Windows 虚拟文件系统 及 Git 开发而成的 GitVFS[5] 。

## 如何应对 Git 单体大仓库？

### 如何控制仓库膨胀？

```bash
# 取top20的大文件
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | sort -k 3 -n | tail -20 | awk '{print$1}')"

# 取大于500k的大文件
git rev-list --objects --all | grep "$(git verify-pack -v .git/objects/pack/*.idx | awk '{if($3>500000)print $1}')"
```

对症下药：

1. 对于二进制文件，可以借助 [git-lfs](https://github.com/git-lfs/git-lfs)，将文件上传到对象存储。
   1. Git-lfs 的落地，依赖客户端的安装，存在一定的成本，但确是上选。
   2. 对于非预期的提交，添加 pre-commit hook 做本地拦截也是一个好选择。
   3. 活用.gitignore，排除编译产物、非必要依赖等的提交
2. 引用清理：
   1. 本地经常性进行开发分支清理并 GC 是一个不错的选择。
3. 选择**更合理的**存储服务：
   1. 对版本要求不高的场景，对象存储的成本更为低廉。

### 如何高效识别用户大文件提交？

行业内的普遍做法

通过 pre-receive hook，对隔离区（Quarantine，objects/incoming-xxxx）中的对象大小进行识别，其中松散对象可以通过文件头中的 size 来判断，packfile 则通过 `git verify-pack` 。

但是这个方案的效率并不高：

1. 需要遍历隔离区的所有对象，事先并不知道哪些对象是 commit、哪些是 blob
2. verify-pack 的核心用途是校验 packfile 的完整性，对读取完整的数据；而我们的场景，只需求文件大小。

另一个思路：

> https://lore.kernel.org/git/YaUmFpIeCvHdKixj@coredump.intra.peff.net/
>
> We also **set GIT_ALLOC_LIMIT to limit** any single allocation. We also have custom code in index-pack to detect large objects (where our definition of "large" is 100MB by default): - for large blobs, we do index it as normal, writing the oid out to a file which is then processed by a pre-receive hook (since people often push up large files accidentally, the hook generates a nice error message, including finding the path at which the blob is referenced) - for other large objects, we die immediately (with an error message). 100MB commit messages aren't a common user error, and it closes off a whole set of possible integer-overflow parsing attacks (e.g., index-pack in strict-mode will run every tree through fsck_tree(), so there's otherwise nothing stopping you from having a 4GB filename in a tree).

我们可以在执行 index-pack / unpack-objects 的过程中，将对象的 oid、类型、大小记录在额外的文件中，在后续 pre-receive hook 执行的时候，就可以根据已有的结果来做展示信息加工。在这个过程中，无需再遍历所有的对象及 packfile 整体，**复用了数据接收过程**，这对大型仓库的效率提升是显著的。

### 如何下载一个 Git 大仓？

通常会遇到如下问题：

1. 引用发现慢
2. 对象计算久
3. 网络不稳定中断

可以怎么做：

1. 使用 protocol version 2

以 https://github.com/kubernetes/kubernetes 为例，如果下载该仓库的全量引用，总共有近 10w，而如果仅关心 branches 及 tags，那么仅有不到 1k。

```Plain
10:39:01.435687 pkt-line.c:80           packet:        clone> ref-prefix HEAD
10:39:01.435692 pkt-line.c:80           packet:        clone> ref-prefix refs/heads/
10:39:01.435696 pkt-line.c:80           packet:        clone> ref-prefix refs/tags/
```

Git 在 2.18 以后就开始支持新的协议，在更新的版本中，更是将 v2 作为默认协议，在这个协议下可以有更好的表达空间。

如果你的 Git 版本不高，可以考虑增加设置使用 v2：

```Plain
git config --global protocol.version=2
```

1. 使用 shallow clone

如果你不那么关心历史版本，shallow clone 是一个不错的选择。

```Plain
git clone --depth=100 git@github.com:kubernetes/kubernetes.git
```

1. 使用 partial clone[9]

比如我也想试试本地维护一个 linux，同时也想看看这个拥有 100w 个 commits 仓库的演进历史，我可以这么做

```Plain
git clone --filter=blob:none git@github.com:torvalds/linux.git
```

1. 使用 bundle

Git 当中，提供了将所有对象及引用打包的能力 `git bundle`，借助对象存储及 CDN，可以对文件进行分段读取，在网络条件不好的情况下，真的可以救命。

目前 Git 社区的 Derrick Stolee 及 Ævar Arnfjörð Bjarmason 正在推进 bundle uri 能力的落地，这将更好地改善大仓库的下载体验。

> https://lore.kernel.org/git/pull.1234.git.1653072042.gitgitgadget@gmail.com/

### 如何在减小本地工作空间

好不容易把一个 Git 的仓库下载下来，往往检出又成了难题。

Git 仓库中的文件都是经过压缩的，而解压缩之后，体积往往成倍膨胀开来；而对于一个大库，我们可能只关心其中的某个路径，可以尝试 `git sparse-checkout` 登场了。

引用 StackOverflow 上一个高赞回复：

> Git is not better than Subversion. But is also not worse. It's different.

当我们在 Monoreo 及主干开发上越走越远，也许随着技术的演进，Git 大仓库的体验一定会越来越好；但也许有一天我们也会发现，Git 不再是最适合我们的版本管理工具。

毕竟，没有完美的工具，合适的才是最好的。
