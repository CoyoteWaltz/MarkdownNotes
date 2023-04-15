# About Nvm

> [Node Version Manager](https://github.com/nvm-sh/nvm)
>
> 应该说是 node 必备工具了，切换不同版本的 node

## .nvmrc

`.nvmrc` 这个文件有什么用？在文件中写入指定的 node 版本（**最小满足要求**），可以在进入有这个文件的目录下，如果不满足最低版本要求，就自动切换成所要求 node 版本，前提是安装了 nvm。（[stackoverflow 回答](https://stackoverflow.com/questions/57110542/how-to-write-a-nvmrc-file-which-automatically-change-node-version)）

bash 执行 `nvm use` 就会自动找 `.nvmrc` 中配置的版本并且使用，上面的回答中还能通过配置 `.zshrc` 等终端脚本来实现进入目录之后自动寻找 `.nvmrc` 文件然后切换对应版本

```bash
# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
```
