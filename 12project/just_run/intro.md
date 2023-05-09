> 始于 idea，终于 github

### 背景

今天被公司的 n 个项目给“折磨”到了，不同的项目不同的包管理器装的依赖，npm/yarn/pnpm，每次都得看一眼 lock 文件是啥，于是就想着自己搞一个命令行工具检查当前的 lock 文件，执行对应的命令，想的挺美 `just dev/start`

于是回家打开 GitHub，用了 antfu 哥的 [ts lib 模版](https://github.com/antfu/starter-ts)准备开始撸代码，琢磨着里头的 `@antfu/ni` 是啥库，结果就是我想要的哈哈哈哈，太牛了。哎。果然早就有人遇到了这样的问题并且给出了很好的解决方案。

### [ni use the right package manager](https://github.com/antfu/ni)

拿 npm 举例子：`ni` → `npm install`, `nr` → `npm run`

看了下源码，还是收获多多：

1. npm/pnpm/yarn/bun 的支持，他们有其他的一些指令是我还不知道的
2. lock 文件

```typescript
// the order here matters, more specific one comes first
export const LOCKS: Record<string, Agent> = {
  "bun.lockb": "bun",
  "pnpm-lock.yaml": "pnpm",
  "yarn.lock": "yarn",
  "package-lock.json": "npm",
  "npm-shrinkwrap.json": "npm",
};
```

3. 很多关于 shell 的 npm 包
   1. which：`which npm`
   2. execa：执行命令
   3. @posva/prompts：命令行 prompt
   4. [kleur](https://github.com/lukeed/kleur)：最快的 nodejs 命令行输出颜色文字
   5. [find-up](https://github.com/sindresorhus/find-up)：向上找父目录找目标文件
