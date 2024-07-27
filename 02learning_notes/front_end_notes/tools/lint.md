# ESLint

## 配置说明

## es-lint import order

安装：[plugin](https://github.com/import-js/eslint-plugin-import)

引入了这个规则之后，就能在 lint 的时候自动将 import 按照模块所在的位置进行分组（下为 eslint 配置的 rules 中）

还有一个问题：是 `import './index.css'` [这一类没有赋值的导入没有被 lint 所捕获](https://stackoverflow.com/questions/69814021/eslint-import-order-rule-does-not-work-with-scss-files)，以及这个 [issue](https://github.com/import-js/eslint-plugin-import/issues/2397) 在讨论

[具体配置参考](https://github.com/import-js/eslint-plugin-import/blob/main/docs/rules/order.md)

```json
      "import/order": [
        "warn",
        {
          "groups": ["builtin", "external", "internal", "parent", "sibling", "index", "unknown"],
          "newlines-between": "always",
          "alphabetize": {
            "order": "asc",
            "caseInsensitive": true
          },
          "pathGroupsExcludedImportTypes": ["builtin"],
          "pathGroups": [
						// 可以配置一些 alias 目录
          // {
          //   pattern: 'components/**',
          //   group: 'external', // 认为是外部依赖
          //   position: 'after',
          // },
          // {
          //   pattern: 'common/**',
          //   group: 'external',
          //   position: 'after',
          // },
          // {
          //   pattern: 'services/**',
          //   group: 'external',
          //   position: 'after',
          // },
          ]
        }
      ]
```

## VSCode fix 文件

工作中遇到了使用 eslint 作为 formatter 之后，不能在 vscode 使用代码块格式化（`⌘ + K, ⌘ + F`）的问题

于是乎还是决定用 prettier 来作为 formatter（`js(x)/ts(x)`），同时可以将 eslint 的配置为 onsave 的时候 fix 整个文件

通过 `editor.codeActionsOnSave`：

```json
{
  "editor.codeActionsOnSave": {
    "source.fixAll.stylelint": "explicit", // stylelint 也是如此
    "source.fixAll.eslint": "explicit"
  }
}
```

详情可看 eslint 插件的 [changelog](https://github.com/microsoft/vscode-eslint?tab=readme-ov-file#version-204)
