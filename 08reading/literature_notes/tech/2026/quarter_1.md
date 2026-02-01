[notion ceo 对 AI 时代的理解](https://x.com/ivanhzhao/article/2003192654545539400)

> “We are still in the waterwheel phase of AI, bolting chatbots onto workflows designed for humans. We need to stop asking AI to be merely our copilots. We need to imagine what knowledge work could look like when human organizations are reinforced with steel, when busywork is delegated to minds that never sleep. Steel. Steam. Infinite minds. The next skyline is there, waiting for us to build it.”
>
> 最后一段发人深省

[了解一下 opencode](https://x.com/fkysly/status/2008216983628902879)

>

[shadergraph](https://www.threejsshadergraph.com/)

> 太有意思了，通过画布设置（类似 comfy），生成 shader

[shuding 的 better promise all](https://github.com/shuding/better-all)

> 优雅的处理了 promise 依赖，可以让 promise 都并发运行
>
> `this.$` 用 Proxy 实现，要取值的时候通过 await promise 来阻塞，相应的依赖结束后，通过 resolve 来继续

[A visual guide for SSL tunnel](https://iximiuz.com/en/posts/ssh-tunnels/)

> SSL Tunnel = 用 TLS 加密包一层“安全壳”，在不安全网络上传输原本不安全的 TCP 流量
>
> | 隧道类型          | 隧道协议                |
> | ----------------- | ----------------------- |
> | SSH Tunnel        | SSH                     |
> | SSL Tunnel        | TLS / SSL               |
> | VPN               | IPsec / WireGuard / TLS |
> | Cloudflare Tunnel | TLS + 反向代理          |
>
> 用一条 SSH 连接，临时创建一个 TCP 代理端口
>
> - SSH client 的端口总是开在左侧
>
> `Local → Remote`
>
> ```bash
> ssh -L local_port:remote_addr:remote_port user@sshd
>
> 本机程序
>   ↓
> localhost:local_port   ← 这里在监听
>   ↓
> SSH Tunnel
>   ↓
> remote_addr:remote_port
>
> 把远端服务“拉”到本地
> ```
>
> 典型用途：
>
> - 访问只监听 `127.0.0.1` 的远端服务（DB / 内部 Web）
> - 本地用浏览器 / GUI 调试远端系统
> - 通过 Bastion 访问 VPC / 内网资源
>
> `Remote → Local`
>
> ```bash
> ssh -R remote_port:local_addr:local_port user@gateway
>
> 外部用户
>   ↓
> gateway:remote_port    ← 这里在监听
>   ↓
> SSH Tunnel
>   ↓
> local_addr:local_port
>
> 把本地服务“推”到公网
> ```
>
> 典型用途：
>
> - 把本地 / 内网服务临时暴露到公网
> - demo、调试、临时对外联调
> - home server / NAT 后服务反向打洞

[posthog](https://posthog.com/)

> mark 一下，很牛逼的网站设计
