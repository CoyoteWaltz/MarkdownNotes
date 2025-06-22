# 折腾 mac mini 之旅

## 写在前面

趁着 618 和国补，把家里闲置的 MacBook Pro 16 寸 19 年款（公司回购）给置换了，低价购入了一台 mac mini 万兆网口。顺手入了妙控键盘，带指纹解锁版，贵！但是真香。

mac mini 开机后自动会识别周围的妙控键盘和触控板，就是要等个几分钟才能连接上，苹果生态真妙啊，常常带来小惊喜。显示器连的是家里老古董红米 27 寸 4k，凑合还能用。

首先是装一堆实用软件，可以参考 TODO 贴个链接。

最初的目标是想折腾折腾 mac mini 作为自己家里的软路由，和 Nas。需要用到非常强大的付费代理软件 [surge](https://nssurge.com/)，但 surge 虽然强大，但学习和配置起来也真是令人挠头。先买了 Mac 版的（surge5），IOS 暂时还没买，因为现在主力用安卓。

经过一番配置，暂时给 surge 的定位：

1. 作为我的梯子软件（首当其冲）和网络代理工具
2. 作为家庭 nas 或者 vpn，能够在外同步和读取一些共享数据
3. 作为 mac mini 实现软路由的软件

## 使用和配置

> [入门指南](https://wiki.surge.community/)
>
> [官方教程](https://manual.nssurge.com/)
>
> [文档](https://kb.nssurge.com/surge-knowledge-base/zh)
>
> [社区](https://community.nssurge.com/t/official)

暂且不多赘述，官方和网络上都有很多教程可以看

## 一、Sub Store 梯子节点管理

核心是使用 [Sub-store](https://github.com/sub-store-org/Sub-Store)，管理所有的梯子服务，这是一个 surge 的 module，纯本地的服务，没有订阅链接解析泄漏的风险

### 安装 sub store

> 参考：[官方](https://github.com/sub-store-org/Sub-Store/tree/master/config) 和 [指南](https://wiki.surge.community/othertools)

通过[官方提供的链接](https://github.com/sub-store-org/Sub-Store/tree/master/config)安装 [module](https://raw.githubusercontent.com/sub-store-org/Sub-Store/master/config/Surge.sgmodule)

1. 并且安装证书和信任证书，更新外部资源，开启 sub store 模块功能
2. 开启 Mitm、脚本、重写
3. 将模块生效顺序放到最底部

在浏览器访问 `https://sub.store/` 即可进入 Sub Store 的本地服务应用（提示数据加载成功）

接着就可以将自己的梯子订阅加入进来了

### 订阅添加

可以参考[这个视频](https://www.youtube.com/watch?v=ty5mI3bp6lk)，一步一步配置「单条订阅」和「组合订阅」，可以增加节点操作「名字改写」、「国旗添加」、「排序」等操作

我将所有的 vpn 服务（单条订阅）都加入了组合订阅（一把梭），然后拿到对应的链接配置给 surge，在 surge 中再进行使用

**_注意：关于 SurgeMac_**

> 获取 SurgeMac 的链接上有个小问号说明，为此兜兜转转了很久，简要说明下
>
> 1. 链接参数参考 [wiki](https://github.com/sub-store-org/Sub-Store/wiki/%E9%93%BE%E6%8E%A5%E5%8F%82%E6%95%B0%E8%AF%B4%E6%98%8E)，基本不用动，复制对应的链接即可（SurgeMac），但要注意的是提到了需要用一个 [mihomo](https://github.com/MetaCubeX/mihomo) 的工具，其实只要[下载](https://github.com/MetaCubeX/mihomo/releases)解压后（根据自己的芯片选对应的 release 即可，比如 `mihomo-darwin-arm64-vxx.xx.xx`）
> 2. 将解压后的可执行文件重命名为 `mihomo`，然后设置权限 `chmod 777 mihomo`，将其移动到 `/usr/local/bin/mihomo` 下即可
> 3. 执行 `/usr/local/bin/mihomo -h` 正常显示帮助信息即可。
> 4. 安装完之后我晕了半天，最后才看出来是需要在订阅编辑下面的「节点操作」增加「域名解析」「脚本操作」，**然而这一切似乎都不用重复操作**，选择 SurgeMac 的时候，内部已经处理成 Surge 的 external proxy 格式了，仅需要前面这一步 mihomo 的安装即可（到底和米哈游是啥关系。。。）
>
> 这一步 mihomo 的使用应该只适配于非 surge 格式的订阅链接，如果订阅链接本身已经是 surge 格式，拿到的节点配置不会那么复杂

### 订阅使用

定义了一些 Proxy Group，策略都是 [smart](https://kb.nssurge.com/surge-knowledge-base/zh/guidelines/smart-group)，并对地区进行了筛选，也可以按需筛选（比如名字里包含 neo，是我在 neo 单条订阅中对节点名字加的后缀），策略部分直接用这里定义的 Proxy Group 即可，这里不赘述了，相信大家的配置都各不相同

```toml
[Proxy Group]
PROXY = smart, policy-path=拿到的订阅链接, url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
HK = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇭🇰)|(港)|(Hong)|(HK), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
TW = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇨🇳)|(台)|(Tai)|(TW), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
US = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇺🇸)|(美)|(圣荷)|(States)|(US), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
JP = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇯🇵)|(日)|(Japan)|(JP), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
SG = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇸🇬)|(新)|(Singapore)|(SG), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150
KR = smart, policy-path=拿到的订阅链接, policy-regex-filter=(🇰🇷)|(韩)|(Korea)|(KR), url=http://www.gstatic.com/generate_204, interval=300, tolerance=150

NEO = smart, policy-path=拿到的订阅链接, policy-regex-filter=neo, url=http://www.gstatic.com/generate_204, interval=300, tolerance=150

```

### 其他功能

#### 云同步功能

直接参考[这篇](https://github.com/getsomecat/GetSomeCats/blob/Surge/Substore%E7%9A%84%E4%BA%91%E5%90%8C%E6%AD%A5%E6%93%8D%E4%BD%9C%E6%AD%A5%E9%AA%A4.md)写的挺详细

将配置自动同步到自己 GitHub 的 secret gist（github [官方温馨提示](https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists)：secret 只是不会被搜到，但一旦获得到了链接还是能看到内容，所以注意链接要打码）

最后拿到配置对应的 gist 链接配置到其他设备即可

#### 定时处理订阅

在 module 参数填写参数，体验中

```js
timeout: 脚本超时时长, 按需调整;
sub: 自定义需定时处理的单条订阅名, 多个用, 连接;
col: 自定义需定时处理的组合订阅名, 多个用, 连接;
```

## 二、NAS

## 未完待续...

折腾 Surge 的路还很长，慢慢搞
