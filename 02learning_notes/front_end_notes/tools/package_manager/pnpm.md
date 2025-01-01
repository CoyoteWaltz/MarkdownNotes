# Pnpm Stuff

> [Pnpm](https://pnpm.io/) 作为新一代的前端包管理工具，广受好评啊，公司里的 monorepo 架构也用的是他。
>
> 好文推荐：
>
> - [精读 pnpm](https://github.com/ascoders/weekly/issues/435)
> - [官方文档](https://pnpm.io/blog)

### pnpm why

```bash
pnpm why react
```

展示所有依赖这个包的包（最多展示 10 个）

可以输出 json 格式 `--json`

### pnpm patch

> 来自这个 [patch-package](https://github.com/ds300/patch-package) 库，能让库使用者立即修复一些问题，_It's a vital band-aid for those of us living on the bleeding edge._
>
> yarn v2+ 和 pnpm 都内置了这个功能

可以看[官方文档](https://pnpm.io/cli/patch)

1. `pnpm patch <pkg name>@<version>` 执行想要 patch 的包和版本
2. 然后 pnpm 会创建一个 commit 文件（path），编辑这个文件里的源码
3. `pnpm patch-commit <path>` 提交
4. pnpm 会注册在 package.json 的 [`patchedDependencies`](https://pnpm.io/package_json#pnpmpatcheddependencies) 字段

### Workspace

[pnpm](https://pnpm.io/workspaces) 内置了 monorepo 的管理能力（AKA 多包仓库）

必须要有 [`pnpm-workspace.yaml`](https://pnpm.io/pnpm-workspace_yaml) 文件在根目录，同时根目录下也可能有 `.npmrc`

- `pnpm-workspace.yaml`：用来定义工作区中的目录是否是 monorepo 中的 package
- [`.npmrc`](https://pnpm.io/npmrc)：pnpm 的一些特殊配置，这里不展开了。。

#### workspace 中依赖子仓的几种方式

##### Workspace protocol

pnpm workspace 支持通过 `workspace:` 这样的协议来链接到工作区内的包，比如 `"foo": "workspace:2.0.0"`，如果本地的包并没有这个版本，则会安装失败

##### alias

workspace 中有 `foo` 这个包，`"foo": "workspace:*"`

或者想用不同的 alias 时可以：`"bar": "workspace:foo@*"`

当发布之前会转换为：`"bar": "npm:foo@1.0.0"`

##### 相对路径

`"foo": "workspace:../foo"` 通过相对路径的方式也可以

#### 发布流程

发布是一个比较复杂的任务，所以 pnpm 目前没有支持内置的功能，推荐了：[changesets](https://github.com/changesets/changesets) 和 [rush](https://rushjs.io/) 这两个工具

### npm 安装 pnpm 找不到

MacOS 通过 nvm 管理 node，切换到新的 node 版本然后 `npm i -g pnpm` 之后执行 `pnpm` 指令 not found

参考这篇[回答](https://juejin.cn/post/7067462048656916493)

发现是 `.npmrc` 中的 `prefix` 然后导致在不同 Node 版本找不到全局命令

删除 prefix 之后重新切换版本并且安装 pnpm 就可以解决

并且在 nvm 官方 Readme 中也[说明](https://github.com/nvm-sh/nvm#important-notes)了，if you have/had a "system" node installed and want to install modules globally 需要注意不需要用 `sudo` 全局安装模块，**`~/.npmrc` 文件中不需要 `prefix`，会和 nvm 冲突**

### npmrc

https://pnpm.io/next/npmrc

### 如何处理 peer dependencies

> https://pnpm.io/how-peers-are-resolved，一遍看不明白，就多看几遍，结合自己项目的 `pnpm.lock` 和 `node_modules`

一些 npmrc [配置](https://pnpm.io/next/npmrc#peer-dependency-settings)

#### strict-peer-dependencies

- Default: false

If this is enabled, commands will fail if there is a missing or invalid peer dependency in the tree.

#### auto-install-peers

- Default: true

### `node_modules` 的结构

> 官方的这篇 [blog](https://pnpm.io/blog/2020/05/27/flat-node-modules-is-not-the-only-way)，说的很明白，也很清晰

一句话解释就是：

- 在 `node_modules` 里面有个 `.pnpm` 是用来存放真正的所有 dependencies，当前 package 的直接依赖会以 symlink 的形式，放在 `node_modules` 的第一层。
- 所有依赖真实所在的位置都满足：`.pnpm/<name>@<version>/node_modules/<name>`
- 同时依赖的子依赖同样会以 symlink 的形式在依赖的 `node_modules` 中，而子依赖的真正代码会放在 `.pnpm` 里面进行统一拍平管理
- `.pnpm` 里管理源码，以硬连接的方式指向 pnpm-store 中的文件地址

这样（三层寻址）的好处：

- 完全兼容 Node.js 的依赖查询逻辑
- 结构清晰，避免循环依赖，和幻影依赖（没有安装的依赖，却是其他依赖的子依赖，也能直接被 node 在 `node_modules` 中捕捉到而可以引用，
- 还原最语义化的 `package.json` 定义（只能依赖定义了的包）
- 包复用（依赖间、跨项目）
- ...可以看[这篇](https://github.com/ascoders/weekly/issues/435)

_隔了一段时间_，看了第二篇文章

再看一看 pnpm 的三层寻址

- `node_modules/package-a` > 软链接 `node_modules/.pnpm/package-a@1.0.0/node_modules/package-a` > 硬链接 `~/.pnpm-store/v3/files/00/xxxxxx`

- 第一层：解决幻影依赖，用最合理的树型 node_modules 结构
- 第二层：提升包复用性
- 第三层：指向全局包空间，跨项目复用
  - `pnpm` 在第三层寻址时采用了硬链接方式，但同时还留下了一个问题没有讲，即这个硬链接目标文件并不是普通的 NPM 包源码，而是一个哈希文件，这种文件组织方式叫做 content-addressable（基于内容的寻址）。
  - 即便包版本升级了，也仅需存储改动 Diff
  - 并且新包下载下来之后，发现 hash 相同就可以直接丢弃，节省时间

### 软/硬链接复习

硬链接通过 `ln originFilePath newFilePath` 创建，如 `ln temp/testlh.txt ./tlh`，这样创建出来的 `testlh` 文件与 `tlh.txt` 都指向同一个文件存储地址，因此无论修改哪个文件，都因为直接修改了原始地址的内容，导致这两个文件内容同时变化。进一步说，通过硬链接创建的 N 个文件都是等效的，通过 `ls -li ./` 查看文件属性时，可以看到通过硬链接创建的两个文件拥有相同的 inode 索引：

```bash
# ls -li
104503671 .rw-r--r--   0 admin 21 Oct 14:43 tlh.txt
104503671 .rw-r--r-- 0 admin 21 Oct 14:43 temp/testlh.txt
```

软连接就是 `ln -s` 创建出来的，可以认为是指向文件地址指针的指针，即它本身拥有一个新的 inode 索引，但**文件内容仅包含指向的文件路径**，源文件删除之后，软连接也就失效了

软连接不会占用多少额外存储，硬连接也更是零额外存储

如果将源文件删除，会影响软链接（指向空路径），此时硬链接会感知到节点删除，创建一个副本重新指向，此时和源文件的联系就断开了（没关系了）

### `pnpm-store` 在哪里

`~/.pnpm-store`

```bash
└── v3
    ├── files
    │   ├── 00
    │   ├── 01
```

目录结构很离谱，文件全部都是用 hash（文件内容 to Hash）来存的。content-addressable（基于内容的寻址）。

基于内容的寻址比基于文件名寻址的好处是，即便包版本升级了，也仅需存储改动 Diff，而不需要存储新版本的完整文件内容，在版本管理上进一步节约了存储空间。

个人理解：也就是说 pnpm 把一个 npm 包的每个文件都以内容 hash 命名，每次包版本更新，实际上也只需要 diff 不用 hash 的文件，做到最小增量更新，相同的 hash 完全就可以抛弃

### pnpm 支持的四种 `node_modules` 拓扑结构

### 通过 env 配置全局的 node 版本

> 说实话 nvm 还是好用点。。。

```bash
pnpm env --help
Version 7.9.3
Usage: pnpm env use --global <version>
       pnpm env use --global 16
       pnpm env use --global lts
       pnpm env use --global argon
       pnpm env use --global latest
       pnpm env use --global rc/16

Install and use the specified version of Node.js. The npm CLI bundled with the given Node.js version gets installed as well.

Options:
  -g, --global             Installs Node.js globally

Visit https://pnpm.io/7.x/cli/env for documentation about this command.
```

可以用 `pnpm env use --global <version>` 修改 node 版本

但是注意！！如果是 pnpm7+，最低支持 node14，所以别手贱切到 14 以下，不然就有点麻烦

- 得 nvm 切到 12，全局安装 pnpm6，
- 然后再通过指令配置 14
- 再切回 pnpm7 的 node14 环境

### [--frozen-lockfile](https://pnpm.io/cli/install#--frozen-lockfile)

```bash
pnpm install --frozen-lockfile
```

在 CI 环境是默认开启的，来看下是什么作用：开启之后，pnpm 不会生成 lock 文件，并且当 lock 文件不存在 or 与 manifest（并不知道是啥）不同步 or 需要更新的时候，`pnpm install` 会失败

CI 环境中的一些环境变量

```javascript
exports.isCI = !!(
  env.CI || // Travis CI, CircleCI, Cirrus CI, GitLab CI, Appveyor, CodeShip, dsari
  env.CONTINUOUS_INTEGRATION || // Travis CI, Cirrus CI
  env.BUILD_NUMBER || // Jenkins, TeamCity
  env.RUN_ID || // TaskCluster, dsari
  exports.name ||
  false
);
```
