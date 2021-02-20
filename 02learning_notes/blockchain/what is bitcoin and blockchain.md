# what is bitcoin and blockchain

数字货币，基于密码学

去中心化的电子记账系统

交易：记账 => 银行 => 信任

## blockchain

block：打包交易记录 transactions

连接到上一个区块

问题：以谁的 block 为准？原因：网路延迟，记录顺序不同 -> 工作量证明

为什么要记账？ -> 记账的奖励，手续费收益（每一笔交易多付出一笔手续费给记账的人），打包奖励（唯一一个打包的人）10 分钟打一个包，50 个 -> 没过 4 年奖励减半，一共 2100 万个

如何防止伪造的记录？。。。

## 工作量证明 proof of work（mining）

### hash function

sha256(value) => 256 binary

正向计算容易，反向计算困难

### data in block

每个 block 存的字符串信息：

- 前一个 block 的 hash
- 交易信息
- 时间戳，...
- 随机数

hash = sha256(sha256(string))

让这个 hash 的前 n 位必须是 0，改变随机数，不停的尝试

满足条件就将其作为新 block 的 head

### difficulty

保证每十分钟需要有一个 block

调整 n，每个 0 的出现概率为 0.5，n 个则 0.5^n^

有一种计算方式，平均算出 n 个 0 的次数为 2^n^，那么矿机在 10 分钟计算次数如果是 k

那么 2^n^要接近 k

## peer to peer

## 身份认证

用户注册时生产一个随机数产生 -> 私钥 -> 公钥 -> 地址（公开）

非对称加密
