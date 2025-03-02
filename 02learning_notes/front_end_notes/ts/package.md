# When TS project build

## package.json 的 typesVersions

[官方文档](https://www.typescriptlang.org/docs/handbook/declaration-files/publishing.html#version-selection-with-typesversions)

ts 会找到 package.json 里的 `typesVersions`

```json
{
  "name": "package-name",
  "version": "1.0.0",
  "types": "./index.d.ts",
  "typesVersions": {
    ">=3.1": { "*": ["ts3.1/*"] }
  }
}
```

告诉 ts，如果是 **typescript 3.1 以上的版本**，去找这个目录下的类型定义文件

当然也可以定义目录和版本，配合多路径（subpath）导出会更好用，让类型更加明确

BTW：和 `main` 一样的 `types` 或者 `typings` 都是指向单类型文件的入口路径，如果这个包的 `index.d.ts` 就在 `index.js` 同层，也就不需要指明了（ts 会默认去找）
