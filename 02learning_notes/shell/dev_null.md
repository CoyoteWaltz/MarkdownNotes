# 神奇的 /dev/null

> [参考](https://linuxhint.com/what_is_dev_null/)
>
> 记得是在 ChatGPT 求码的时候看到的，将 stdout 定向到 `/dev/null` 就什么都不输出了
>
> _本人使用的是 Mac 实践_

### 是什么

Linux 中所有都是文件，无论是驱动还是设备。`/dev` directory 用来存储所有的虚拟/物理设备。

`ls /dev/` 可以看到很多 disk、tty 之类的，包括我们的 `/null`。也有 `/dev/zero` returns the ASCII NUL characters.

`/dev/null` 是一个空设备，会将所有写入他的内容都抛弃，像一个黑洞

### 使用

它本身的属性

```bash
# 查看设备 什么也没有 EOF
cat /dev/null

# MacOS 下
stat /dev/null
# 829092057 314 crw-rw-rw- 1 root wheel 50331650 0 "Jun 15 00:08:31 2023" "Jun 15 00:09:25 2023" "Jun 15 00:09:25 2023" "Jan  1 08:00:00 1970" 131072 0 0 /dev/null

```

**将所有输出都丢给他，消除任何输出！**

```bash
echo "yes ok" > /dev/null
```

```bash
efffe > /dev/null
# command not found: efffe
```

由于错误信息存在 STDERR，所以不会进入 `/dev/null`，可以通过 STDERR 重定向

```bash
efffe 2> /dev/null
```

将 STDOUT and STDERR 都丢进黑洞！

```bash
efffe > /dev/null 2> /dev/null
```

**简化版如下**

```bash
<command> > /dev/null 2>&1
```

Here, STDOUT is redirected to /dev/null. Then, we redirect the STDERR (2) to STDOUT (1). The “&1” describes to the shell that the destination is a file descriptor, not a file name.

关于上面 `2` `1` `&1` 可以更详细看[这个](https://stackoverflow.com/questions/818255/what-does-21-mean)：

- File descriptor 1 is the standard output (`stdout`).
- File descriptor 2 is the standard error (`stderr`).
- File descriptor 0 is the standard error (`stdin`).
- `&` is only interpreted to mean "file descriptor" **in the context of redirections**.

### 总结

Liunx/类 Unix 系统中的空设备 `/dev/null` 还是很有用途的，有意思
