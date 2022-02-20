# 踩坑记录

### go pkg 下载不了

报错：`Get https://proxy.golang.org/golang.org/x/tools/gopls/@v/list: dial tcp 172.217.24.17:443: i/o timeout`

google 了下，感觉中国问题就是挺大，要用代理，详见 [goproxy.cn](https://github.com/goproxy/goproxy.cn)

```bash
go env -w GOPROXY=https://goproxy.cn,direct
```

还可以加上 `go clean --modcache` 清除缓存

### VScode 中 `import "fmt"` 居然报错

怀疑是 go path 的问题，在 VScode 设置中添加即可 `"go.gopath"*:* "~/go"` 我的。
