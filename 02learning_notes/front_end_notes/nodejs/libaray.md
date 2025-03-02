# lib 101

### [nodejs Conditional exports](https://nodejs.org/api/packages.html#conditional-exports)

可以针对不同条件下，配置不同的模块导出路径（esm、cjs）

```json
// package.json
{
  "exports": {
    ".": {
      // 优先级 短路匹配
      "default": null, // 不提供导出路径
      "import": "./index-module.js",
      "require": "./index-require.cjs"
    },
    "./feature.js": {
      "node": "./feature-node.js",
      "default": "./feature.js"
    }
  },
  "type": "module"
}
```

Nodejs 实现了一系列的条件：

- `"node-addons"` - similar to `"node"` and matches for any Node.js environment. 使用 C++ 插件的时候
- `"node"` - matches for any Node.js environment.
- `"import"` - matches when the package is loaded via `import` or `import()`, or via any top-level import or resolve operation by the ECMAScript module loader.
- `"require"` - matches when the package is loaded via `require()`.
- `"default"` - the generic fallback that always matches.

当然也存在不少的工具能够有一些其他的（自定义）条件导出，比如类似 `source`（monorepo 源码依赖场景）

弊端：一些不用 node 的 resolve 模块的 js 运行时（比如 jest），不太能识别到用条件导出方式引用的路径，需要额外配置一下

可以如何组织 dev 和 publish 的 package.json 如何

更多阅读：[link](https://yutengjing.com/posts/moduleresolution%E6%80%BB%E7%BB%93/)（对基本的用法，推荐的用法，相关的注意点都有很好的说明，**以下部分内容来自该文章**）

## 最佳实践

对于项目结构：

```bash
pkg
├── dist
│   ├── cjs
│   │   ├── index.cjs
│   │   └── utils.cjs
│   ├── es
│   │   ├── index.mjs
│   │   └── utils.mjs
│   └── types
│       ├── index.d.ts
│       └── utils.d.ts
├── package.json
├── src
│   ├── index.ts
│   └── utils.ts
├── tsconfig.json
└── vite.config.ts
Copy
```

### 理想情况

- 只发布 `esm` 模块，`package.json` 设置 `"type": "module"`
- 使用类似 vite/rollup 可以不写模块扩展名的打包工具
- `typescript` 版本 >= 5.0，`tsconfig.json` 设置`"moduleResolution": "bundler"`

`package.json`:

```json
{
  "type": "module",
  "exports": {
    // 新的第三方库大可不必考虑 cjs
    ".": {
      "types": "./src/index.ts",
      // 如果用的是 vite, 也可以直接写 "./src"，其实这也是 vite 和 node 标准不完全一致的地方
      // vite dev
      "development": "./src/index.ts",
      // 用 production 条件也行
      // vite build
      "default": "./dist/es/index.mjs"
    },
    "./*": {
      "types": "./src/*.ts",
      // 使用 vite 可以不写扩展名，可能是为了方便用户引用 css，图片等模块
      // 但是如果你是执行 node 脚本引用这个模块就会报错
      "development": "./src/*",
      "default": "./dist/es/*"
    }
  },
  "publishConfig": {
    // 发布出去的包都要写扩展名，因为这个库的使用环境可能要求写扩展名，例如 nodejs
    "exports": {
      ".": {
        "types": "./dist/types/index.d.ts",
        "import": "./dist/es/index.mjs"
      },
      "./*": {
        "types": "./dist/types/*.d.ts",
        "import": "./dist/es/*.mjs"
      }
    }
  }
}
```

exports 检测工具

- [publint](https://github.com/bluwy/publint) cli 工具可以检测出 target pattern 对应的文件是否存在，以及是否出现 import 条件，却指向的是一个 `.cjs` 模块
- [Are the types wrong?](https://arethetypeswrong.github.io/) 在线网站，帮你检测一个 npm package 的 `typescript` 类型配置在各种 `moduleResolution` 是否会出现问题
