# espanso 使用记录

> [官网](https://espanso.org/)，开源的 snippet 工具，[github](https://github.com/espanso/espanso)，rust 写的
>
> 比较完善、全面的全局 snippet 工具，包括插件社区，可以作用在每个 App 里的自定义。官网内容还是比较丰富的，就是个人感觉这么多文档/文字可能还是会吓到/劝退一部分使用者，不过初步体验下来真的很棒！这里就简单记录一下自己的配置和使用。

## 安装

**以 mac 系统为例**，直接下载解压后拖进 Application，或者用 brew 安装都行，见官网。

## 匹配 & 替换

核心交互是在日常使用输入的时候，针对特定的 match pattern 来进行替换 snippet。

比如想输入 `:nowtime` 的时候直接替换成当前的时间，比如：`2023.03.11 23:13:28 +0800`

## 配置

espanso 是基于文件配置的（unix philosophy），配置文件直接放在应用的目录下，可以通过 `espanso path` 看到，配置文件是 [yaml](../../02learning_notes/yaml) 格式

```bash
espanso path

Config: /Users/user/Library/Application Support/espanso
Packages: /Users/user/Library/Application Support/espanso/match/packages
Runtime: /Users/user/Library/Caches/espanso
```

配置改动后，espanso 会自动 restart。以下就记录一下目前用到的一些配置

### config

> config 目录下是 espanso “如何” 工作

默认是 `default.yml` 这个目录，如果是需要在其他 app 中有特殊配置，可以 `config/xxx.yml`（目前还没用到）

```yaml
# Change search bar shortcut 'cause confict with raycast XD
search_shortcut: ALT+SHIFT+SPACE
# toggle disable shortcut (double pressed)
toggle_key: RIGHT_ALT
```

#### Backspace Undo

有的时候可能误输入了 trigger，可以直接通过 BACKSPACE 来撤销，如果要禁用，也可以配置

```bash
undo_backspace: false
```

### match

> 核心：`trigger` `replace`
>
> - 可以在 replace 的字符串中通过变量占位，yaml 写起来还是很直观的
> - 甚至可以获得系统层面的一些信息？

#### 时间（[插件](https://espanso.org/docs/matches/extensions/)之一）

时间的 format [非常丰富](https://espanso.org/docs/matches/extensions/#date-extension)

```yaml
# Print the current now time
- trigger: ":nowtime"
replace: "{{now}}"
vars:
- name: now
type: date
params:
format: "%Y.%m.%d %k:%M:%S"

# Print the current now time with local timezone
- trigger: ":znowtime"
replace: "{{now}}"
vars:
- name: now
type: date
params:
format: "%Y.%m.%d %k:%M:%S %z"
```

#### Case propagation

大小写传播，如果开启的话，可以

```yaml
- trigger: "alh"
  replace: "although"
  propagate_case: true
  word: true
```

- If you write `alh`, the match will be expanded to `although`.
- If you write `Alh`, the match will be expanded to `Although`.
- If you write `ALH`, the match will be expanded to `ALTHOUGH`.

#### Cursor Hints

可以在 replace 的文案中插入光标所在的位置！用 `$|$` 即可，很有用！

```yaml
- trigger: ":div"
  replace: "<div>$|$</div>"
```

#### Match Disambiguation

多个相同的 trigger 不同的 replace 会成为菜单栏可以选择

#### Search Label

可以增加 `label` 属性，这样在 search bar 的时候，就能展示这个 label 信息（类似描述信息）

#### Nested Matches

嵌套 match，可以在一个 replace 中直接替换另一个 trigger 的 replace

```yaml
- trigger: ":one"
  replace: "nested"

- trigger: ":nested"
  replace: "This is a {{output}} match"
  vars:
    - name: output
      type: match
      params:
        trigger: ":one" # 可以直接输出 nested(:one 的 replace)
```

## 插件

> 社区出现，[Espanso Hub](https://hub.espanso.org/)，上面有很多好用的插件

> [获取外网的 ipv4 ipv6](https://hub.espanso.org/ip64)
>
> [Jojo gifs 真行 不过没啥用](https://hub.espanso.org/jojo-gifs)
>
> [script-letters 手写体](https://hub.espanso.org/script-letters)
>
> - 用 `;s*` 来匹配
>
> [mac-symbols](https://hub.espanso.org/mac-symbols)

```bash
espanso install xxx
# espanso uninstall xxx
# espanso list
```

更多内容用到的时候再详细看官网！package、...
