# YAML intro

> YAML: YAML Ain't Markup Language.
>
> YAML: Yet A Markup Language. (When coding)
>
> 为啥起个名字还这么可爱呢，又是和 GNU 一样的递归，又有反差感
>
> [online parser](https://yaml-online-parser.appspot.com/)

## 基本语法

### 基本类型

```yaml
# YAML
int: 1
hex_int: 0xff
float: 2.34
bool: true
implicit_null:
explicit_null: null
str: string
date: 2020-7-1 12:01:02.03 +8
```

### 字符串

plain style（不建议）

quoted style：用 `'` or `"`

block style：用 `|` or `>`，`|-` `>-` 去除末尾的换行，`|+` `>+` 保留所有换行

```yaml
literal: |
  some
  text
# some\ntext\n
folded: >
  some
  text
# some text\n
quoted: "some\ntext\n"
literal: |+
  some
  text

# some text\n\n
literal: |-
  some
  text
# some text
```

### 数组

`[]` or `-`

```yaml
1: [a, b, c]
2: [a, b, c]
3:
  - a
  - b
  - c
```

### Map

```yaml
1: { a: b, c: d }
2: { a: b, c: d, e: f }
3:
  a: b
  c: d
```

### 定义变量

使用 `&` 定义变量，引用 `*` 变量

```yaml
jobs:
  job_a:
    steps:
      - &init_step
        name: Init Step
        commands: [ls, pwd, whoami]
  job_b:
    steps:
      - *init_step
```

等价于

```json
{
  "jobs": {
    "job_a": {
      "steps": [
        {
          "commands": ["ls", "pwd", "whoami"],
          "name": "Init Step"
        }
      ]
    },
    "job_b": {
      "steps": [
        {
          "commands": ["ls", "pwd", "whoami"],
          "name": "Init Step"
        }
      ]
    }
  }
}
```

### 解构

用 `<<`

```yaml
1: &array_of_string
  type: array
  items:
    type: string
2:
  type: boolean
3:
  required: true
  <<: *array_of_string
```

可以很好的复用一些配置
