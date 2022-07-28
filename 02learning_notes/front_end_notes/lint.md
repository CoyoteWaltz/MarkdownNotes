## es-lint import order

参考：https://github.com/import-js/eslint-plugin-import/blob/main/docs/rules/order.md

引入了这个规则之后，就能在 lint 的时候自动将 import 按照模块所在的位置进行分组

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
            {
              "pattern": "components/**",
              "group": "external",
              "position": "after"
            },
            {
              "pattern": "common/**",
              "group": "external",
              "position": "after"
            },
            {
              "pattern": "src/**",
              "group": "external",
              "position": "after"
            }
          ]
        }
      ]
```
