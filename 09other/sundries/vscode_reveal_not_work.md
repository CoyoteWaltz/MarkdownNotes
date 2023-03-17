发现点到 `node_modules` 里面的文件之后，vs code 的 file explorer 不会自动定位了，于是查了下，发现需要改一下设置。操作方法见这个 [issue](https://github.com/microsoft/vscode/issues/168408#issuecomment-1342513210)

将 explorer.autoRevealExclude 里面的 `node_modules` 项给去掉 or 设置成 false，就不会被 exclude 掉了。。

估计是某个版本开始默认加的规则，坑啊。
