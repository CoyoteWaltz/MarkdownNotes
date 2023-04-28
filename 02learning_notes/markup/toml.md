# TOML

> [toml](https://toml.io/en/) Tom's Obvious Minimal Language
>
> [github](https://github.com/toml-lang/toml)，各个语言的解析实现可以在[这里](https://github.com/toml-lang/toml/wiki)找到
>
> A config file format for humans.
>
> cargo 创建的 rust 项目就会自带一个 `Cargo.toml`

### example

```toml
title = "TOML Example"

[owner]
name = "Tom Preston-Werner"
dob = 1979-05-27T07:32:00-08:00

[database]
enabled = true
ports = [ 8000, 8001, 8002 ]
data = [ ["delta", "phi"], [3.14] ]
temp_targets = { cpu = 79.5, case = 72.0 }

[servers]

[servers.alpha]
ip = "10.0.0.1"
role = "frontend"

[servers.beta]
ip = "10.0.0.2"
role = "backend"
```
