## es-lint import order

安装：[plugin](https://github.com/import-js/eslint-plugin-import)

引入了这个规则之后，就能在 lint 的时候自动将 import 按照模块所在的位置进行分组（下为 eslint 配置的 rules 中）

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
