# Typing Effect

> 打字特效，纯 css 实现 太帅了
>
> 1. 文字被逐个打出来的效果
> 2. 输入光标的 blink

### html

```html
<body>
  <div class="wrapper">Yes ok!</div>
</body>
```

### css

用两个动画分别实现两个特效

1. #### 文字被逐个打出来的效果

```css
/* 设置宽度为字符单位 ch -> character */
width: 7ch;
/* 动画 让 整个 div 的宽度开始为 0 */
@keyframes typing {
  from {
    width: 0;
  }
}
/* 应用动画 控制步长 */
animation: typing 1s steps(7);
```

2. #### 光标 blink

```css
/* 光标用什么？伪元素？不 直接用 boarder 即可！如果有其他用处 再考虑伪元素也可 */
border-right: 3px solid;
/* 闪烁就是无限的动画 */
@keyframes blink {
  50% {
    border-color: transparent;
  }
}
/* 注意控制上一个 step 结束再开始这个动画 */
animation: typing 1s steps(7), blink 0.5s step-end infinite alternate;
```

#### 完整代码如下：

```css
.wrapper {
  color: #443344;
  /* font-family: Georgia, 'Times New Roman', Times, serif; */
  width: 7ch;
  animation: typing 1s steps(7), blink 0.5s step-end infinite alternate;
  white-space: nowrap;
  overflow: hidden;
  border-right: 3px solid;
  font-family: monospace;
  font-size: 2em;
}

@keyframes typing {
  from {
    width: 0;
  }
}

@keyframes blink {
  50% {
    border-color: transparent;
  }
}
```

### 关于 steps 函数

> 将 animation or transition 分割成多个步骤执行，相当于是将一个完整的函数等分成多个 segment，每一个 segment 瞬间完成，按照分割的时延等待下一步

`steps(<number_of_steps>, <direction>)`

#### number_of_steps

分步的数量

#### direction

这个方向指定了动画出现的时机，默认是 `end`

- start：函数左连续，可以想象在分割一个连续函数之后，每一段是左连续的（左边的端点是实心），所以第一个步骤会被立刻执行，会立即跳到第一步之后。可以这么理解：从第一个实心端点开始，发现终点是不连续的，于是立刻跳到下一个左端点了。
- end：右连续，从第一步开始执行。

#### 影响 fill mode

> fill mode 就是动画如何执行 infinite or forward

如果是 `forward`，step 函数需要是 end，不然会多走一步

#### 更多应用

**时钟的秒针**

```css
.second {
  animation: tick-tock 60s steps(60, end) infinite;
}

@keyframes tick-tock {
  to {
    transform: rotate(360deg);
  }
}
```

脚印:paw_prints:

进度条

参考文章：https://designmodo.com/steps-css-animations/
