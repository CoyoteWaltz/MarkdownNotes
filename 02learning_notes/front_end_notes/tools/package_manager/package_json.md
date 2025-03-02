# package.json stuff

## package.json 字段

一个前端模块的身份证。

查看[官网](https://docs.npmjs.com/files/package.json)发现具体字段的含义/作用：

### exports

[官方文档说明](https://nodejs.org/api/packages.html#packages_exports)（node 12+）

对于一个 npm 包来说，是比较推荐用 `exports` 指明入口文件

相比与 `main` 更加现代，能够更加清晰的定义更多的入口文件，同时能屏蔽除了指定入口外的路径访问。

```json
{
  "exports": {
    ".": "./index.js",
    "./submodule.js": "./src/submodule.js"
  }
}
```

如果当前目录就是主入口，下面可以改写成

```json
{
  "exports": {
    ".": "./index.js"
  }
}
// 可以简写
{
  "exports": "./index.js"
}
```

有 esm 和 cjs 两种的情况下[分条件导出](https://nodejs.org/api/packages.html#imports)（build 了两份，或者 wrapper 出一份 mjs），可以通过 `require` and `import`

```json
  "exports": {
    ".": {
      "import": "./dist/esm/index.js",
      "require": "./dist/cjs/index.js"
    },
  },
```

[对于 TS package 来说](https://www.typescriptlang.org/docs/handbook/esm-node.html#packagejson-exports-imports-and-self-referencing)：

- 首先也是可以用的
- 如果 `main` 指向的是 `./lib/index.js` TS 则会去找 `./lib/index.d.ts`，同时也可以用 `"types"` 字段去指明
- 对于 `"import"` 和 `"require"` 来说，也可以指定不同的类型路径

```json
// package.json
{
  "name": "my-package",
  "type": "module",
  "exports": {
    ".": {
      // Entry-point for `import "my-package"` in ESM
      "import": {
        // Where TypeScript will look.
        "types": "./types/esm/index.d.ts",
        // Where Node.js will look.
        "default": "./esm/index.js"
      },
      // Entry-point for `require("my-package") in CJS
      "require": {
        // Where TypeScript will look.
        "types": "./types/commonjs/index.d.cts",
        // Where Node.js will look.
        "default": "./commonjs/index.cjs"
      }
    }
  },
  // Fall-back for older versions of TypeScript
  "types": "./types/index.d.ts",
  // CJS fall-back for older versions of Node.js
  "main": "./commonjs/index.cjs"
}
```

_来自 [TS 4.7 log](https://www.typescriptlang.org/docs/handbook/release-notes/typescript-4-7.html#packagejson-exports-imports-and-self-referencing)_

在 node 执行的时候，也可以指定条件

```bash
#      "import": {
# 			 "xxx": "./types/esm/index.ts",
#        "types": "./types/esm/index.d.ts",
#        // Where Node.js will look.
#        "default": "./esm/index.js"
#      },

node --conditions=xxx ./index.js
```

### type

在 [nodejs](https://nodejs.org/api/packages.html#type) 中使用 esm 作为 js 模块的时候（使用 `import/export` 语法）

此时 `type` 字段需要指定为 `"module"`，否则就会认为 `.js`/`.ts` 文件默认是 CommonJS，需要用 `require`

但是如果不考虑用 `type` 这个字段，那就直接使用后缀 `.mjs`/`.mts` 表示 ES Module，用 `.cjs` 表示 CommonJS module

_同样在 [js module](../js/module)、[webpack](../tools/building/webpack/webpack) 中提到过_

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
