# About Nvm

> [Node Version Manager](https://github.com/nvm-sh/nvm)
>
> 应该说是 node 必备工具了，切换不同版本的 node

## .nvmrc

`.nvmrc` 这个文件有什么用？在文件中写入指定的 node 版本（**最小满足要求**），可以在进入有这个文件的目录下，如果不满足最低版本要求，就自动切换成所要求 node 版本，前提是安装了 nvm。（[stackoverflow 回答](https://stackoverflow.com/questions/57110542/how-to-write-a-nvmrc-file-which-automatically-change-node-version)）
