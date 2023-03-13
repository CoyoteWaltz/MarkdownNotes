# mac 添加插入时间的快捷键

> 主要看了 typora 也不支持插入，看了下面的 issue 发现官方也不会支持，需要第三方软件做这个事情
>
> 之前在公司电脑没尝试成功，今天居然在自己的 big sur 系统上实现了
>
> updated on 2023.03.11 22:45:11，用了 [espanso](https://espanso.org/) rust 写的全局可配置的 snippet 工具，真香！

参考：https://apple.stackexchange.com/questions/242547/how-to-automatically-paste-todays-date-with-keyboard-shortcut，[typora issue](https://github.com/typora/typora-issues/issues/1052)

1. 先创建服务：

automator -> quick operation -> Run App Script -> save as whatever you like

```jsx
on run {input, parameters}
	set _Date to (current date)
	tell application "System Events"
		keystroke ¬
			(year of _Date as text) & "." & ¬
			text -2 thru -1 of ("00" & ((month of _Date) as integer)) & "." & ¬
			text -2 thru -1 of ("00" & ((day of _Date) as integer)) & " " & ¬
			text -2 thru -1 of ("00" & ((hours of _Date) as integer)) & ":" & ¬
			text -2 thru -1 of ("00" & ((minutes of _Date) as integer)) & ":" & ¬
			text -2 thru -1 of ("00" & ((seconds of _Date) as integer))
	end tell
end run

```

2. 给 typora 打开安全权限：安全与隐私 -> 辅助功能

3. 绑定快捷键：

系统偏好设置 -> 键盘 -> 快捷键 -> 找到保存的 service -> 设置快捷键

我设置的 `⌘ + ⇧ + ⌥ + d`，当然也可以替换分隔符和显示的日期格式（自己看代码啦，很好理解）

2021.01.02 19:51:35

**_注意：一定要是英文输入法的时候！不然会乱码！就像这样：2021.01.040 0090Å5Å_**
