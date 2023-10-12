# Tools Utilities with Tailwind CSS

> From:
>
> - [youtube](https://www.youtube.com/watch?v=U4GYkulA3bk)

### Sort Classes

prettier-plugin-tailwindcss

组织 class，调整 class 的顺序，保持和 css 文件中的顺序一致

踩坑：vscode 使用 prettier 插件会报错

解决：见 [issue](https://github.com/tailwindlabs/prettier-plugin-tailwindcss/issues/207)

- Prettier 需要版本 3.x
- prettier-plugin-tailwindcss 插件版本 0.5.x
- 需要配置 `prettier.config.js`

### Conflicting Classes

tailwind-merge

解决场景：组件接受 classNames 来覆盖基础样式的时候，可能会遇到样式定义冲突，而编译顺序不同导致覆盖失败

### Conditional Classes
