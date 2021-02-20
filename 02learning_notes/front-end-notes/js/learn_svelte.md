# Svelte

一个 non-virtual dom 的前端框架，很快，很炫酷。[官网](https://svelte.dev/)

官方教程走了一遍，开始本地开发

[教程](https://svelte.dev/blog/the-easiest-way-to-get-started)用的是`npx degit sveltejs/template my-svelte-project`

[degit](https://github.com/Rich-Harris/degit) 是 npm 包，可以直接 clone github 仓库里面的代码`degit some-user/some-repo target-path`（用 npx 吧，npx 真香）

所以在 sveltejs/template 这个仓库里面就是一个项目模版了，复制到`my-svelte-project`这个文件夹了。

进去之后看了眼`package.json`，发现是用 rollup 打包的，以及 [sirv-cli](https://www.npmjs.com/package/sirv-cli) 作为静态资源的服务器 cli？？，当然还需要`npm install`或者`yarn`

去学一学 rollup！

关于 media 元素的[教程](https://svelte.dev/tutorial/media-elements)有点东西

进度条的 tag，`<progress>`
