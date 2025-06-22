# Whistle with Surge5

工作中使用一些代理工具进行本地开发还是比较频繁的，用了 surge 之后就不太想再有其他的一些代理软件入侵到 system proxy 这一层了，同时不想安装浏览器插件 SwitchyOmega（已经无法下载安装了），于是放弃了之前的一些工具，但还是比较适应 whistle 的[规则语法](https://wproxy.org/whistle/rules/)，开始尝试用 [whistle](https://github.com/avwo/whistle)，直接安装了[客户端版本](https://github.com/avwo/whistle-client)

看到网上有利用 module 能力，将各个浏览器进程的请求都转发到 whistle 的[方案](https://1991421.cn/2021/09/30/ea60c0ab/)，但这样就不好对域名维度的请求做单独的规则策略了，不够灵活

所以，目前采用的是用 Surge 做 system proxy，whistle 仅做代理，需要使用 whistle 的时候通过切换 surge 的配置来将流量代理到 whistle，同时在规则上也能前置分流走不需要走 whistle 的域名请求

## Whistle

首先配置 whistle 服务监听的端口（Proxy Port），比如 8888

然后不要开系统代理！

## Surge 配置

在配置之前，可以进行官方推荐的[分散维护配置](https://kb.nssurge.com/surge-knowledge-base/zh/guidelines/detached-profile)，将 General、Proxy、Proxy Group、Rule 都拆分到单独的文件中，可以用 `dconf` 作为拓展名，这样就不会出现在 app 中的配置中被 surge 检测是否完整合法，且在 Surge iOS 里可在列表中显示，并可以使用文本编辑。

配置文件可以通过 `#!include Proxy1.dconf, Proxy2.dconf` 的方式引入，支持多份配置，最后的内容顺序也按照引入顺序，只会在对应的 block 中引入对应的 block 内容

注意：

- 被引用的文件不可以再次去引用另一个文件

- 经我测试，在已经引入过的 block 下方继续手动增加的内容也不生效

  ```bash
  [Rule]
  #!include rule.dconf
  FINAL,DIRECT   // !不生效，所以 Rule 的最后一个配置文件确保有 FINAL 策略

  ```

拆分完之后，得到一些配置，我的配置如下

```bash
.
├── all_whistle.dconf
├── Default.conf
├── general_common.dconf
├── proxy_group_common.dconf
├── rule_domain_common.dconf
├── rule_process_common.dconf
└── rule_set_common.dconf
```

接着就可以组装出一份完整配置 `名字随意.conf`，和一份 whistle 配置 `名字也随意.conf`（需要 whistle 时切换过去用就行）

```bash
├── work.conf
├── whistle.conf
```

在 `whistle.conf` 中的 Proxy 和 Rule 的部分会额外引入 `all_whistle.dconf`

```toml
[Proxy]
#!include all_whistle.dconf, other.dconf

[Rule]
# 这里注意引入顺序 如果有前置域名的分流可以写在前面
#!include rule_domain_common.dconf, all_whistle.dconf, rule_process_common.dconf, rule_set_common.dconf

```

这部分 `all_whistle.dconf` 为（参考上面 module 的[方案](https://1991421.cn/2021/09/30/ea60c0ab/)）：

```toml
[Proxy]
Custom-Dev-Whistle-local = http, 127.0.0.1, 8888 // 8888 替换成自己的 whistle server 的端口，名字任意需要和 Rule 中指定的保持一致

[Rule]
# 解决开发调试-Whistle
PROCESS-NAME,Google Chrome*,Custom-Dev-Whistle-local // Chrome-Whistle代理
OR,((PROCESS-NAME,Safari*), (PROCESS-NAME,/Library/Apple/System/Library/StagedFrameworks/Safari/WebKit.framework/Versions/A/XPCServices/com.apple.WebKit.Networking.xpc/Contents/MacOS/com.apple.WebKit.Networking), (PROCESS-NAME,/System/Library/Frameworks/WebKit.framework/Versions/A/XPCServices/com.apple.WebKit.Networking.xpc/Contents/MacOS/com.apple.WebKit.Networking)),Custom-Dev-Whistle-local
PROCESS-NAME,firefox*,Custom-Dev-Whistle-local // FF-Whistle代理
PROCESS-NAME,Microsoft Edge*,Custom-Dev-Whistle-local // Edge-Whistle代理

```

Ok，这样两套配置就完成了，接下来选择到 whistle 的配置，打开 whistle 就能看到浏览器的流量进来了，同时不影响其他代理策略

## 快捷键

想要更便捷的切换 surge 配置

surge 提供了 http api 给外部来控制 surge，需要在「更多」-「通用」-「远程访问」-「http api」设置好端口和密码

找到一个[raycast 插件](https://www.raycast.com/ysj151215/raycast-surge)，支持了切换配置等功能，配置好端口和 key 就可以使用，不过他暂时没有提供好的快捷指令提供配置全局快捷键

## 弊端

方案不一定是十全十美的，要去修改配置策略还是挺麻烦的，需要手动到自己的 surge 配置文件中修改

在同时引入多份的情况下，会导致在 app 中 Rule 的 UI 界面的策略无法修改，也不能单独未某个网页设置**永久规则**了，在[官方手册](https://manual.nssurge.com/overview/configuration.html)提到：

> Starting from Surge iOS 4.12.0 & Surge Mac 4.5.0, you can include multiple detached profiles in one section. But the section will be marked read-only and can't be edited with UI.

## 也许

也许有空可以做一个 surge module for whistle？满足随开随用的便捷性，也能提供可视化工具管理一些特定的不走代理策略

But，在[surge module 文档](https://manual.nssurge.com/others/module.html)里其实也只开放了部分的能力给 module，包括 Rule 的部分会直接插在原始内容的最开始

## 题外话

移动端我准备直接连电脑 ip，然后让 charles 接管，还没尝试。。

[Charles 和 surge 的思路](https://github.com/wujunchuan/wujunchuan.github.io/issues/1)，如果需要高度依赖 charles 做网络请求分析的？（surge 不够强么）
