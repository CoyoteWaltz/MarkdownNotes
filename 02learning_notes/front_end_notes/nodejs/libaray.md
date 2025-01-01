# lib 101

### [nodejs Conditional exports](https://nodejs.org/api/packages.html#conditional-exports)

可以针对不同条件下，配置不同的模块导出路径（esm、cjs）

```json
// package.json
{
  "exports": {
    ".": {
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
