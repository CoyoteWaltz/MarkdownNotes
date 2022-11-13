# Pnpm Stuff

> [Pnpm](https://pnpm.io/) 作为新一代的前端包管理工具，广受好评啊，公司里的 monorepo 架构也用的是他。
>
> 好文推荐：
>
> - [精读 pnpm](https://github.com/ascoders/weekly/issues/435)
> - [官方文档](https://pnpm.io/blog)

[toc]

### 如何处理 peer dependencies

> https://pnpm.io/how-peers-are-resolved，一遍看不明白，就多看几遍，结合自己项目的 `pnpm.lock` 和 `node_modules`



### `node_modules` 的结构

官方的这篇 [blog](https://pnpm.io/blog/2020/05/27/flat-node-modules-is-not-the-only-way)，说的很明白，也很清晰

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





