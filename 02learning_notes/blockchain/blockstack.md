# Understanding blockstack white paper v2.0

## 论文标题：blockstack white paper v2.0

The Blockstack Decentralized Computing Network，一种区块链的分层架构设计

论文地址：https://blockstack.org/whitepaper.pdf

## Abstract

- A full-stack **alternative** to traditional cloud computing for building secure, private applications.

- Most business logic and data processing runs on the client, instead of on centralized servers hosted by application providers.

- Similar to a transition from mainframes to destop computing.

### Design

- **to scale decentralized applications**

- **to incentivize developers to build high-quality applications**

- a novel **Tunable Proofs election system** to securely bootstrap a new blockchain.

- smart contracting language, Clarity. _Smart contract（智能合约 区块链 2.0）_

A key component of our architecture is a **highly scalable and performant decentralized storage system, called Gaia**, that enables **user-controlled private data lockers.**

用户直接将自己的 private data locker 连到 blockstack 客户端上的应用软件，应用可以直接去写 data locker。

身份认证系统*A universal ID and authentication system, called Blockstack Auth*不需要分别在每个应用上登陆，也不需要密码，原本的密码 based 的登陆是被认为比 cryptographic authentication 会更不安全。

提供了 sdk 和开发者工具

## Introduction

因特网 40 年前因为一个研究项目而诞生，但是如今触及到了几乎所有世界上的电子交互。

尽管他底层的核心和协议比较 lower，但是引用层和服务基础设施的巨大发展支撑着物联网应用的快速成长。

C/S 模型主要的互联网应用模型，90 年代开始流行。短期盛放，长期不 ok。

主要原因还是 web 服务长期依赖远端的服务器。

云计算依托于 C/S 模型，也有不足 call into question 质疑。

Mass data breaches, loss of user privacy, lack of data portability, and the broader mistrust of tech giants stems from the core design of the client/server model。

C/S 模型已经落伍了。

下一代的云计算进化会利用更多强悍的客户端设备，边缘计算，global connectivity 减少中心化的平台。

去中心化计算 Decentralized computing 改变了 app 的构建和使用的方法，开发者可以有一套开发工具，用户对于软件的关系也发生了改变：软件可以保护用户并且更（最）好的优化他们的收益。

Blockstack 是一个开源项目，目的在于设计开发一个去中心化的计算网络，能够作为传统云计算的一个替代，Blockstack is **re-imagining the application layer** of the traditional internet and provides a new network for decentralized applications；applications built on Block- stack enable users to own and control their data directly

和传统云计算的最大区别就是用户可以直接控制和拥有他们自己在应用上的数据。

blockstack 使用的还是原有的传输层和协议，但是去掉了应用层的中心化思想。

根据**端到端的设计思想[1, 2]**，目的在于能保持整个核心网络的简单性，将复杂的计算等推向了用户终端

To **scale** the applications, 最小化了全局的状态改变，提供一个可靠的去中心化存储系统，媲美云计算的表现。

**blockstack 提供了构造去中心化应用的一套（full-stack）方法/框架/sdk，同时是模块化的**，见 section2

提供了一个新的智能合约语言，clarity，见 section3

去中心化存储系统 Gaia，见 section4

认证系统，见 section5

开发者工具，见 section6

section7 讲关于开发应用

### 1.1 decentralized computing overview

去中心化系统其实就是分布式系统的一种特殊类型

中心化系统：where no single entity is in control of the underlying infrastructure，没有一个中心控制的，并且节点参与网络是有经济刺激的。

从比特币开始，区块链和 cryptocurrency**[3]**

比特币的主要目标：记录和解决比特币电子货币的归属权

以太坊**[4]**：构建一个 world computer 来实现智能合约和去中心化应用

Filecoin**[5]**： construct a network for decentralized file hosting and storage

Blockstack：realize _a full- stack_ for decentralized computing, focusing on enabling secure, private applications where the blockchain layer handles minimal state and logic.

### 1.2 design goals

- 使用简单：对终端用户来说和现在的互联网应用一样好用；对于开发者来说和现在云计算应用一样简单开发
- scalability：可量化？就是说随着用户量的增大，网络也应该随之可以运行，荷载能力
- user control：用户控制去中心计算，不想传统依赖服务器，用户可以自己提供自己的算力和存储资源

与同时代的去中心化计算方法不同的设计理念（“heavy” blockchains and “world computer” design philosophy）：

**Minimal logic and state at the blockchain layer:**

为了达到 scalability，在 blockstack 上的应用的逻辑和存储被最小化了，在 chain 上的操作肯定比 off-chain 会慢，需要在网络上同步、验证状态，网络带宽限制了全球连通性，节点的内存/存储也有限制（物理上）。

---

**Localized state changes vs. global state changes:**

本地化状态和全局状态改变？

The Blockstack network uses the full-stack approach to ensure that applications built on Blockstack are _scalable_

就是说，用户在使用应用的时候可能会随时改变本地的状态和全局的状态，因此，存储系统 Gaia 和认证协议，让用户交互应用的时候能用 private data locker，同事认证不需要发布一个区块链的交易

The Stacks blockchain is only used to coordinate global state transitions in a consistent way (such as registering a globally-unique username) in a decentralized fashion.

也就是说 blockstack 是没有本地状态改变的，全部都让全局去直接操作本地的 private data locker（分布式）

---

**Reliable cloud-like storage vs. peer storage:**

Applications built on Blockstack store data with the user (using their private data lockers) and **don’t need to store any user data or access credentials at the server side**. This approach not only puts users in control of their data but also **reduces complexity for developers**: developers no longer need to run servers and databases and pay cloud infrastructure bills on behalf of their users.不需要支付云服务的费用了

利用 p2p 存储**[6]**来确保可靠度和效率问题

---

**Full-stack SDKs for developers:**

smart contract language also makes unique design decisions to optimize for security and predictability of smart contracts

### 1.3 A New Model for Applications

构造应用的新模式，确保去中心化，让用户可以自己控制

1. **no opaque databases:** 开发者不需要关注维护数据库以及数据库安全问题，更多关注逻辑层面，用户下载 app 之后插入他们的 private data lockers。数据库更多像是搜索的索引者？
2. **no servers:** cs 架构的应用下，在服务侧会增加更多的服务器算力来支撑他们的业务。在去中心化计算的网络中，用户提供自己的算力和存储能力。开发者只需要提供很少部分的基础设施来运行他们的 code
3. **smart contracts:** 全局状态的改变通过**智能合约**来执行在开放的区块链上。以前都是服务端有单独的改变权力。
4. **decentralized authentication:** 中心化的登陆授权依赖数据库的密码体系或者第三方的 OAuth 授权（看阮一峰）。在去中心化计算中，授权由用户客户端来操作，by cryptographically signing a statement proving control over a particular username anchored to the blockchain. Any application can independently verify these proofs.
5. **native tokens: ** 传统互联网应用使用第三方信用授权支付，比如信用卡。在区块链和以太坊中使用数字令牌作为 native asset。用户对他们有直接的拥有权，可以注册数字资产和智能合约。

### 1.4 Layers of Decentralized Computing

去中心化计算网络逻辑上/理论上存在于“应用层”。但是 blockstack 网络由不同的系统（提供去中心化应用实现的必要部分）组成（从下而上）：

1. **stack blockchain:** 栈区块链？enables users to register and control digital assets like univer- sal usernames and register/execute smart contracts. Digital assets like universal usernames, in turn, allow users to control their data storage and more—users link their access credentials for private data lockers with their universal usernames.
2. **Gaia:** 用户控制的存储系统，让 app 于 private data locker 交互。用户可以保存这些加密的 data locker。gaia 上的数据是通过用户的私钥加密的，用户的 data 存储室（locker）是在 stacks blockchain 上查询信息得到的。（？）
3. **BlockstackAuthentication:** 去中心应用的授权协议。用户用自己的 id，并且提供 Gaia 上存储用户应用数据的位置信息来授权。
4. **Blockstack Libraries and SDKs:** 最上层是开发库和 sdk，进行应用层的交互。方便开发者开发。

So next, we will dig deeper into those layers.

## 2 Stacks blockchain

global consensus 全局的共识机制

coordination layer 是什么，协调层

native token 的实现，在 blockstack network 中叫做 stacks token

Stacks tokens are consumed as “fuel” when users register digital assets like universal user- names, software licenses, pointers to storage lockers, etc. They are also used to **pay miners for registering/executing smart contracts.**

相当于是货币了

Stacks Improvement Proposals 设计https://github.com/blockstack/blockstack-core/tree/develop/sip：

1. A Tunable Proofs mechanism for leader election.
2. A Proof-of-Burn mining algorithm to reuse hashpower of existing blockchains.
3. A novel peer network (Atlas) which uses random graph walks for peer connec- tivity and reduces the amount of data required to achieve consensus.
4. A smart contracting language (Clarity) that is non-Turing complete and _inter- preted_.

之前的区块链版本是 1，用的共识机制是比特币的，智能合约也是 v1，有比如 blockstack naming system

这一 section 主要讨论的是第二版本，全功能的共识机制和智能合约语言的大更新

### 2.1 leader election

选举 leader？就是挖矿成功的人。

blockstack 第一代的区块链是在 Layer-1 上操作的，每一个交易和 L1 比特币交易是一对一对应的。这样做的原因是确保重建 blockstack 的区块链和比特币区块链重建一样难！安全原因。

在 leader 选举过程上使用了一个 tunable proofs mechanism。

Tunable Proofs mechanism：一个领导选举的系统，多个（选取）机制的输入，适配对应的**权重**。可以将原生 pow 算法加入其他功能来 reuse 来自另一个更加健全的区块链的哈希功能。

我们的使用可微调证明机制是为了安全的自举 bootstrap 一个区块链并且慢慢的将它过渡到使用原生的 pow 机制。

The current Tunable Proofs mecha- nism has two parts (a) native Proof-of-Work and (b) Proof-of-Burn of another cryp- tocurrency.

**pob？**burn 加密货币来表明他们对加入挖坑过程的兴趣？**取得一定的地位，你不光得有钱，还得要一定的 reputation（声誉）。而你只有不断地为整个社区做好事，才能获得 reputation**。**而每次系统为你发放完代币奖励之后，你的 reputation 就会清零，这样你就会持续不断地为整个社区作出贡献，保证社区的正面发展。**

**To be elected as a leader**, a candidate burns the underlying cryptocurrency (i.e., Bitcoin) and commits to an initial set of transactions in **the leader’s would-be block**. 选取 leader 也需要一个 block，这个 leading block 就是这个区块链的起始块？pob 机制就是证明他们要作为 leader 的决心？烧了自己的币作为第一个块的交易。

This commitment _also_ serves as the leader’s **fork selection**

pob 机制在 stacks blockchain 中应用能够带来：（todo 深入学习）

- **High validation throughput.**高验证吞吐量：解耦了交易的确认和新增 block 的过程，新增 block 在基础的 burn chain 上
- **Low-latency block inclusion.**少的新加入快的等待时间，几秒内就可以确认新块
- **Open leadership set.**不像 pos 一样币越多越有可能成为挖矿的人，pob 使得每个人都可以成为 leader。Further, by performing _single-leader election_, our consensus algorithm ensures that would-be leaders don’t need to coordinate with each other.
- **Participation without mining hardware.** 要成为一个 leader，需要先 burn 一个币，而不是传统的 pow，因此，硬件挖矿机不是必须的了. **Anyone who can acquire the burn cryptocurrency can participate in mining, even if they can only afford a minimal amount**.？？
- **Fair mining pools.**
- **Ability to failover.**故障转移

### 2.2 turanable proofs

stacks 区块链结合了 pow 和 pob，确保安全性的同时确保了链的稳定性。这种 proof 机制是可以调节的，使得：

- opens a path towards migration if the underlying burn chain deteriorates.

- Tunable Proofs also enable us to research other Proof-of-Work or Proof-of-Stake mechanisms and slowly introduce them over the years in a tunable fashion.

### 2.3 Atlas Peer Network

a content-addressable peer network

gossip-protocol: each peer keeps track of which other peers are in the network and each peer attempts to **store a full replica of all the data in the network.**

是一个非结构化的对等网络，避免节点加入/离开网络带来的问题。

所有节点都有一份 copy 数据，新加入的节点可以快速的同步数据，存下他们所需要的数据。

The Atlas network functions as an “**extended storage**” subsystem for the Stacks blockchain.

这样做的目的还是为了在 blockstack 网络上存尽可能少的数据，并且让节点尽可能少的与主干网络交互。

例子：

For many applications on Blockstack, such as the Blockstack Naming System (BNS) smart con- tract, it is essential to have a mechanism for storing _immutable_ and _timestamped_ data. In BNS, this is used to associate usernames with routing information used to discover that user’s profile and application data. In most blockchains, storing this kind of data is done _directly_ on the blockchain itself.

### 2.4 Stacks Token Usage

stacks token 货币的用途（消耗点）

1. **fuel to register digital assets** TheStackstokenisusedtoregisterdifferentkinds of digital assets like usernames, domain names, software licenses, podcasts, and several others.
2. **Fuel to register/execute smart contracts.** 执行智能合约需要消耗燃料去作为证明正确性和执行的（经济）基础
3. **transaction fees**为交易付款
4. **anchored app chains** app 在 blockstack 上会越来越流行，一个 app 需要在 stacks 区块链上初始化自己的区块链，也会花费 stacks token

还有其他的功能，等待参与者的发现。

## 3 The Clarity Smart Contracting Language

launching and execution of smart contracts for **programmatic control of digital assets.**

Clarity optimizes for security and predictability

与之前的智能合约设计目标不同的是：

1. The language must readily permit fast and accurate static analysis for runtime and space requirements.合约语言是要被快速批准并且在运行的时候可以被准确静态分析的，所以他在完成单次交易的时候是**非图灵完备**的。但是在完成整个交易历史的时候，语言是可以图灵完备。
2. Smart contracts should be _interpreted_ by our VM, not compiled. The code, as written by developers, must be deployed directly on the blockchain.完全在 blockchain 上解析

_图灵完备：如果一系列操作数据的规则（如指令集、编程语言、细胞自动机）按照一定的顺序可以计算出结果，被称为图灵完备（turing complete）。_

### 3.0.1 language overview

像一种 lisp 语言的变种。但是有以下不同：

1. 不能递归，没有 lambda 匿名函数
2. 循环必须用 map，filter，fold 函数完成
3. 只有原子类型：booleans, integers, fixed length buffers, and principals
4. 支持有名类型的元祖
5. 用 let 来声明变量，没有转换函数
6. 用 define 来定义静态变量和函数
7. define-public 定义变量，参数的类型必须声明

智能合约可以：

1. 调用其他合约的公共方法。都是用 hash 值来代表的。
2. 拥有数字资产。

每个智能合约都有自己的数据空间，数据存在 maps 里。有唯一的 key。

### 3.0.2 Turing Incompleteness and Static Analysis

**非**图灵完备性语言作用：

1. enables static analysis to determine the cost of executing a given transaction. 整个网络可以提前知道这个交易改变的费用是多少。可以快速的传递到用户
2. 可以静态分析快速决定，这样可以提升用户体验，因为客户端可以警告用户交易可能产生的副作用
3. 准确的静态分析可以让程序员在发布合约之前分析出可能存在的错误

但是我们还是不能够把智能合约看成是编程。

### 3.0.3 Interpreted Languages vs. Compiled

解释型 or 编译型

Clarity 在设计的时更倾向于解释型语言，主要原因是这样可以找出实现上的 bugs。

难以将程序员的思路/bugs 在编译后的代码中找出。

## 4 Gaia: User-Controlled Storage

applications to interact with private data lockers.

用户可以自己决定数据存储在什么地方。

数据被用户管理的密钥加密。

Logically, Gaia works as a wide-area file system which can be mounted to store files.

在 Gaia 存储系统中，用户指派 Gaia 的存储地址。

Stacks 区块链只会保存指向 Gaia 位置的指针，当用户通过 Blockstack 认证协议（sec5）登陆 app 后，区块链将地址传给 app，这样 app 就知道如何去具体交互指定用户的数据了。

Gaia’s design philosophy is to **reuse existing cloud providers** and infrastructure in a way that end-users **don’t need to trust the underlying cloud providers.**

虽然用户可能利用了第三方的云存储，但是 Gaia 传过去的用户数据是通过用户自己的密钥加密过的，所以云存储服务商不会得到用户数据（不可见），用户也不必给予必要的信任了。巧妙的复用了现有的云存储或者基础设施。

写数据通过 POST 请求，并且会验证是否带有签名过的授权令牌。

用户给每个 app 都要配置一个密钥。

在 Gaia 系统里，用户的区块链认证路由信息 URL 指向一个 json 对象，包含了只想用户 Gaia 数据仓库的 url。当一个 app 想知道用户 Gaia data locker，通过 http 请求就可以得到一个文件。要找一个由另外的用户创建的文件，需要在整个客户端侧进行搜索时，在初识的查询会有时间的消耗，但是大部分路由信息会被缓存（浏览器，app），之后的查询会快很多。

**Performance.** 这样设计的目标在于能达到传统给予云服务应用的传输效率，在保障安全和容错能力的前提下。

**System Scalability.** 存储层在架构上并不是一个扩展性的瓶颈。Altas peer network 量化性非常好，因为他不存用户文件的索引，而是存指向用户存储后端的指针，而且只有在用户新增或者改变存储后端或公钥映射或者用户注册的时候才介入。目前看来容量问题还需要用大量用户来发现问题，在未来也是一个研究方向和挑战。

## 5 Authentication

blockstack 提供用户一个通用的用户名可以跨应用，无须密码登陆。

Blockstack Auth 连接 app 和用户的 Gaia hub 以及 app 自身的私钥。

### 5.1 Single Sign-On

单点（blockstack core 区块链上）登录

通过公约加密的方式授权。登入 app 后 app 有了生成和存储签名数据的能力。

一个用户在 Blockstack 应用上点击登录，app 会通过 blockstack.js（提供的 SDK）将用户重定向到 Blockstack 的授权 app 去登录。用户可以选择 Blockstack id 去登录，同时有一系列的应用权限。登录成功后会重定向会应用，同时传递给应用以下数据：

1. 用户名或者公钥的 hash 值（在没有用户名的情况）
2. 用户配置的 app 私钥，为了加密用户的数据
3. 指向用户 Gaia hub 的 url 列表

用户的登出就是简单的把应用的本地状态清空，会清楚用户配置的 app 私钥。

## 6 Blockstack Libraries & SDKs

提供的库和 SDK

### 6.1 Developer Libraries

为了方便 web 应用的开发，提供了 JavaScript Web SDK（blockstack.js）和移动端 SDK

详见https://github.com/blockstack

### 6.2 User Software

提供了两个开源的项目供用户和 Blockstack 交互：

1. **Blockstack Browser.** 用户可以在上面浏览应用，注册用户名，授权应用。

2. **Blockstack CLI.** 命令行工具，可以使用 BLockstack 的协议互相交互。用户可以生成原生交易和 Gaia 上的数据任务。

### 6.3 Documentation and Community Resources

https://docs.blockstack.org

- github：https://github.com/blockstack
- 论坛：https://forum.blockstack.org
- Slack：https://blockstack.slack.com

## 7 Apps and Services

**Developer Incentives** 关于开发者的奖励刺激，在 Stacks 区块链中拓宽了“挖矿”的概念，app 的开发者也可以通过发布高质量的应用来“挖”到 stacks 令牌，这个机制成为 App 挖矿。应用会被一组独立的审核员评审，可以在https://app.co/mining上查看更多细节。

## 8 Conclusion

Blockstack 是一个去中心化的计算网络，提供了开发者构建去中心应用的一整套框架。是一个分散式应用程序的新互联网，配备了一整套开源开发工具来构建和引导分散的应用程序和协议生态系统。用户拥有自己的数据，浏览器就是开始所需的一切。

Blockstack 是一款集成了分散式数据、分散式应用程序、分散式用户数据的区块链浏览器应用。所谓分布式互联网，用户在此之上拥有对其身份的所有权，数据和身份绑定，存储在自己的私有设备，或者云端，从而取消了对第三方机构的依赖。而开发者可以开发分布式的应用本地运行，调用用户的 API，在用户许可的情况下访问用户数据，从而不用考虑数据的存储问题。Blockstack 通过这种方式将数据主权交还给用户，用户数据由用户保管，未经用户许可，任何第三方无法访问用户数据。由于用户拥有了数据主权，用户可以随心所欲转移，不用再受到平台限制。

层次结构设计的区块链：

1. Stack Blockchain 核心层：最底层，提供共识机制（pow+pob）；底层区块链服务。
2. Gaia 应用数据管理层：存放用户云服务指针。
3. Blockstack Authentication 鉴权层：去中心化授权，不需要用户密码。
4. Blockstack Libraries and SDKs 面向 App 的 API 层：对应用提供与 Blockstack 的交互。

## 9 参考文献

[0] https://blockstack.org/whitepaper.pdf

[1] J.H.Saltzer,D.P.Reed,andD.D.Clark,“End-to-endargumentsinsystemdesign,”_ACMTrans.Com-_ _put. Syst._, vol. 2, pp. 277–288, Nov. 1984.

[2] D. D. Clark and M. S. Blumenthal, “The end-to-end argument and application design: The role of trust,” _Federal Comm. Law Journal_, vol. 63, no. 2, 2011.

[3] A.Narayanan,J.Bonneau,E.Felten,A.Miller,andS.Goldfeder,_BitcoinandCryptocurrencyTechnologies: A Comprehensive Introduction_. Princeton, NJ, USA: Princeton University Press, 2016.

[4] V.Buterin,“Anext-generationsmartcontractanddecentralizedapplicationplatform,”tech.rep.,2017. https://github.com/ethereum/wiki/wiki/White- Paper.

[5] “Filecoin: A Cryptocurrency Operated File Network,” tech report, 2014. http://filecoin.io/ filecoin.pdf.

[6] Eng Keong Lua, J. Crowcroft, M. Pias, R. Sharma, and S. Lim, “A survey and comparison of peer- to-peer overlay network schemes,” _IEEE Communications Surveys Tutorials_, vol. 7, pp. 72–93, Second 2005.
