## VSCode 目录树跟随文件

发现点到 `node_modules` 里面的文件之后，vs code 的 file explorer 不会自动定位了，于是查了下，发现需要改一下设置。操作方法见这个 [issue](https://github.com/microsoft/vscode/issues/168408#issuecomment-1342513210)

将 explorer.autoRevealExclude 里面的 `node_modules` 项给去掉 or 设置成 false，就不会被 exclude 掉了。。

估计是某个版本开始默认加的规则，坑啊。

## svg 默认打开是 preivew

参考这个 [reddit](https://www.reddit.com/r/vscode/comments/1ibntfy/svg_files_open_as_previews_i_want_them_to_open_as/?tl=zh-hans)

某个版本开始 vscode/cursor 在文件树中点击 svg 文件默认打开的是他的 preview 模式，而我需要的是 svg 的源码

可以在 settings → editorAssociations 中添加解析规则：
`*.svg -> default`
