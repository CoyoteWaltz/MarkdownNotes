## 实用小技巧

管道符 `|`

### copy current git branch

```bash
git branch --show-current | xargs | tr -d '\n' | pbcopy
```

可以 alias 一下 `alias cb="git branch --show-current | xargs | tr -d '\n' | pbcopy"`

在任何 git 仓库中直接 `cb` 就能将当前的分支 copy 在剪切板

注意：`pbcopy` 只适用于 macOS，windows 可以换成 [`clip`](https://superuser.com/questions/472598/pbcopy-for-windows)，以及 linux 的[替代方法](https://superuser.com/questions/288320/whats-like-osxs-pbcopy-for-linux)
