## node 版本选择

结论：选择偶数的 LTS 版本

https://zhuanlan.zhihu.com/p/145243810

## npm & yarn 安装差异

https://segmentfault.com/a/1190000017075256

看这一篇就大致了解 npm 和 yarn 的区别了，但是这篇文章最后的实验部分做的不太合理

我们重新做一下（npm 6.14.4，yarn 1.22.4）

新建两个文件夹`test_yarn`和`test_npm`中分别`yarn init`，`npm init`

然后分别

`yarn add react-router-native@4.3.0 react-router-dom@4.3.1`

`npm install -s react-router-native@4.3.0 react-router-dom@4.3.1`

查看各自的 node_modules

发现也没差多少。。。。react-router 也都被扁平化提到最上层了。。。

npm 下也没出现嵌套的模块安装

**_体验总归是趋同的，两者现在完全不差多少，可能只是命令上的差异罢了。。。_**

也不一定要用 yarn 了

关于 npm 锁的历史：https://zoucz.com/blog/2020/05/31/f23b2980-a30c-11ea-90b5-eb40e9720ed0/

TODO 问题：这些 lock 文件，设计上有没有什么问题？

## Registry

登记处？每个包的发布的所在地，像一个中心一样交给他托管这些包，安装个 nrm 来管理 npm 使用的包“源”

```bash
  npm -------- https://registry.npmjs.org/
* yarn ------- https://registry.yarnpkg.com/
  cnpm ------- http://r.cnpmjs.org/
  taobao ----- https://registry.npm.taobao.org/
  nj --------- https://registry.nodejitsu.com/
  npmMirror -- https://skimdb.npmjs.com/registry/
  edunpm ----- http://registry.enpmjs.org/
```

大概那么多吧

### 配置

如果你需要发布包到指定的 registry

```bash
npm config set registry https://registry.npm.yourcompany.com
```

## package.json

一个前端模块的身份证。

查看[官网](https://docs.npmjs.com/files/package.json)发现具体字段的含义/作用：

摘录几个重要的吧

### name

和 version 一起组合成了这个包的唯一表示

一些规则：

- 不能超过 214 个字符（包含 scope 名，一时想不起 scope 中文如何翻译）
- 非`.` or `_`开头
- 新的包不能有大写（？）
- 这个名字会被用在 url 里、命令行里、文件名，所以不要有 url 中的奇怪字符（`:`、`.`等）

#### 关于作用域 scope

我们会看到 Vue 都是用`@vue/xxx`开始的

TODO

### version

语义化版本命名嘛，看这个https://semver.org/

`npm install semver`

https://docs.npmjs.com/misc/semver官网讲了如何比较版本的方法

### files

类型：数组

- 当这个包作为其他包的 dependencies 的时候只会安装 files 中的这些文件。

- 字符串的格式和`.gitignore`一样，但是是 include 这些文件，支持 glob 格式

- 如果没有这个字段，默认的是`["*"]`

- 同时可以提供`.npmignore`，作用和`.gitignore`一样，如果没有`.npmignore`，就会用`.gitignore`

- Certain files are always included, regardless of settings:
  - package.json
  - `README`
  - `CHANGES` / `CHANGELOG` / `HISTORY`
  - `LICENSE` / `LICENCE`
  - `NOTICE`
  - The file in the “main” field
  - `README`, `CHANGES`, `LICENSE` & `NOTICE`可以有任意的后缀
- Conversely, some files are always ignored:
  - `.git`
  - `CVS`
  - `.svn`
  - `.hg`
  - `.lock-wscript`
  - `.wafpickle-N`
  - `.*.swp`
  - `.DS_Store`
  - `._*`
  - `npm-debug.log`
  - `.npmrc`
  - `node_modules`
  - `config.gypi`
  - `*.orig`
  - `package-lock.json` (use shrinkwrap instead)

### main

导入该模块时的入口文件

`const x = require('xxx')`

### bin

让你的包成为命令行指令的关键字段！

```json
{
  "bin": {
    "cydir": "./index.js"
  }
}
```

npm install 之后就做了一个软连接（全局，或者本地在` ./node_modules/.bin/）`，`index.js`连接到`/usr/local/bin/cydir`.

记得在 bin 指向的文件开头加上`#!/usr/bin/env node`，不然就无法执行了！

### script

https://docs.npmjs.com/misc/scripts

`npm run <script>`

### engines

```json
{
  "engines": {
    "node": ">=0.10.3 <0.12"
  }
}
```

### private

这个包 publish 的时候会被 npm 阻止！

### scope

- 用户/组织的作用域名，形如`@myorg/package`

- 只有自己可以在 scope 下 add package，所以不用担心别人会用你的 scope

- 当然，scoped 的包可以依赖 unscoped 包，反之亦然

- 安装 scoped 包的时候会在`node_modules`目录下的`@myorg`目录下安装对应的子包

- 引入的时候也需要带上域名`require('@myorg/mypackage')`

- 可以发布在任何的 registry

其他的到真正用到再说吧。。。

## lerna

### foreword

请阅读https://blog.npmjs.org/post/186494959890/monorepos-and-npm

我们经常会将一整个项目分割为多个小的子模块（**module**）来管理，这在架构上是非常好的，但是会出现多个子包所导致的四个头疼的事情：

- **Discovery**：新包的加入，每个人都要在心里记一下。。成百上千个包就比较麻烦了
- **Access control**：每个仓库会遇到权限问题，新人会遇到依赖循环的问题
- **Versioning**：版本控制会非常碎片化，并且：asking humans to remember to do this across a large collection of packages (including packages they haven’t had to touch) is asking for trouble.
- **Duplication**：每个子包（package）的依赖会极大的增加安装的速度（比如在 npm 生态）

### Monorepo

单一的 repository。来解决上面多模块所产生的问题。

解决方法就是：将所有的 modules(packages) 都放到一个 repository 中去集中管理

注意的是：单一仓库的权限会让使用者获取到所有的代码

### a peek at Lerna

_快速入门，[lerna](https://github.com/lerna/lerna): A tool for managing JavaScript projects with multiple packages._

全局安装 lerna

```bash
npm i -g lerna
```

创建一个目录作为 monorepo，用 lerna 初始化

```bash
lerna init
```

我们可以看到一个`lerna.json`的配置文件

```json
{
  "packages": ["packages/*"],
  "version": "0.0.0"
}
```

接着 npm 登陆 registry，如果有 scope 就指定一下，登陆之后 lerna 就会为子包配置`publishConfig`

```bash
npm login –scope test
```

新增 package

```bash
lerna create @test/a
lerna create @test/b
```

新增的两个子包（npm package）都是版本`0.0.0`的

此时需要 `git remote add` 一下远程仓库，并且 commit 和 push 一下，才能继续进行发版操作

比如升级主版本

```bash
lerna version major
```

发布

```bash
lerna publish from-git
```

### 详细使用

由于并没有真正用到 lerna 做大项目，只是简单的了解了解

详细用法请看[官网](https://lerna.js.org/)

有谁在用 lerna：

> Projects like [Babel](https://github.com/babel/babel/tree/master/packages), [React](https://github.com/facebook/react/tree/master/packages), [Angular](https://github.com/angular/angular/tree/master/modules), [Ember](https://github.com/emberjs/ember.js/tree/master/packages), [Meteor](https://github.com/meteor/meteor/tree/devel/packages), [Jest](https://github.com/facebook/jest/tree/master/packages), and many others develop all of their packages within a single repository.

官网有个 list

## npm

> npm 相关指令，特性

### 指令

#### `npm fund [<pkg>]`

> retrieves information on how to fund the dependencies of a given project.

查看一个包是如何被 fund 起来的，说人话也就是查看包的依赖树信息和访问这个包的 url，通常都是 github

一些参数可以改变展示的格式

- `--unicode`

- `--json`

- `--browser`
- `which`：参数的 number，如果有多个 funding source 可以指定展示的下标
