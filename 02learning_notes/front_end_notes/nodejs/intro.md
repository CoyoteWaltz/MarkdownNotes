关于面试可以看：https://juejin.im/post/5e53cf886fb9a07c91101642

## Node 版本的命名

https://nodejs.org/en/download/releases

每个 LTS 版本都是元素周期。。从 A 开始

## Event Loop

为什么要有事件循环机制？

因为：node 是一个 js 的 runtime，服务端运行的 js 环境，必然会需要各种 I/O（文件、进程等），由于 js 是单线程的（不能开多个线程去异步的处理 I/O），为了实现非阻塞 I/O，引入了 Event Loop

### 事件循环

比浏览器的事件循环要复杂一点

事件循环中细分为这六个**阶段(phase)**，依次如下：

1. `Timers`: 定时器 Interval Timoout 回调事件，将依次执行定时器回调函数
2. `Pending`: 一些系统级回调将会在此阶段执行
3. `Idle,prepare`: 此阶段"仅供内部使用"
4. `Poll`: IO 回调函数，这个阶段较为重要也复杂些，
5. `Check`: 执行 setImmediate() 的回调
6. `Close`: 执行 socket 的 close 事件回调

#### 开发需要关心的阶段

与我们开发相关的三个阶段分别是 `Timers, Poll, Check`

**`Timers` ：**执行定时器的回调，但注意，在 node 11 前，连续的几个定时器回调会连续的执行，而不是像浏览器那样，执行完一个宏任务立即执行微任务。

**`Check` ：**这个阶段执行 setImmediate() 的回调，这个事件只在 nodejs 中存在。

**`Poll` ：**上面两个阶段的触发，其实是在 poll 阶段触发的，poll 阶段的执行顺序（这个阶段应该叫做轮询阶段，Node 都在这里阻塞）：

1. 先查看 check 阶段是否有事件，有的话执行
2. 执行完 check 阶段后，检查 poll 阶段的队列是否有事件，若有则执行
3. poll 的队列执行完成后，执行 check 阶段的事件

### 小结

浏览器中，微任务队列是每个宏任务执行完之后执行的；

Node 中，微任务队列是每个**阶段**执行完就执行

#### process.nextTick

关于 process.nextTick ，这个事件的优先级要高于其他微队列的事件，所以对于需要立即执行的回调事件可以通过该方法将事件放置到微队列的起始位置。

参考：https://juejin.im/post/5e53cf886fb9a07c91101642

## setImmediate() & process.nextTick()

## querystring

提供解析 URL 上的 query 参数功能

`const querystring = require('querystring')`

### 方法

`parse(str[, sep[, eq[, options]]])`

解析 query 字符串为一个对象，返回一个对象（没有原型的，意味着不能拿他当作普通 object 来用，没有一些内置方法比如`toString`等）

- sep: 变量之间的分隔符，默认`&`
- eq: 等号符，默认为`=`
- options:
  - decodeURIComponent: function ，解析 url 中特殊符号被 [precent-based](https://en.wikipedia.org/wiki/Percent-encoding) 的特殊字符的函数，默认为`querystring.unescape()`
  - maxKeys: key 的最大值，默认 1000

```js
const query = "&abc=213&abc=444";
const o = qs.parse(query, "&", "=");
```

`stringify(obj[, sep[, eq[, options]]])`

- options: encodeURIComponent ，对特殊符号进行编码，默认是`querystring.escape()`

将对象序列化成 query string，如果值不为基本的几个类型，会直接解析为空字符串

```js
console.log(qs.stringify({ foo: "bar", baz: ["qux", "quux"], corge: "" }));
```

`escape(str)`: 编码字符串的特殊字符

`unescape(str)`: 解编码

decode: 即为 parse

encode: 即为 stringify

## 错误处理

如何捕获错误，同步任务的情况下用`try...catch`就好了，异步的情况要根据使用的 API 来看

比如：

error_first_callback 绑定回调函数

```js
const fs = require("fs");
fs.readFile("a file that does not exist", (err, data) => {
  if (err) {
    console.error("There was an error reading the file!", err);
    return;
  }
  // Otherwise handle the data
});
```

EventEmitter 绑定错误事件触发器的回调函数

```js
const net = require("net");
const connection = net.connect("localhost");

// Adding an 'error' event handler to a stream:
connection.on("error", (err) => {
  // If the connection is reset by the server, or if it can't
  // connect at all, or on any sort of error encountered by
  // the connection, the error will be sent here.
  console.error(err);
});

connection.pipe(process.stdout);
```

### error_first_callbacks

node 中大部分异步方法都是用错误第一的回调函数

异常错误作为第一个参数的回调函数，没有错误的情况 err 为`null`

```js
function errorFirstCallback(err, data) {
  if (err) {
    console.error("There was an error", err);
    return;
  }
  console.log(data);
}
```

为什么这样写呢，因为在异步操作中，`try...catch`的上下文捕获错误是不起作用的，了解异步的应该很明白。。

### Error.captureStackTrace

捕获调用栈信息，[官方文档](https://nodejs.org/api/errors.html#errors_error_capturestacktrace_targetobject_constructoropt)

语法：

```js
Error.captureStackTrace(targetObject[, constructorOpt])
```

在`targetObject`对象中加入`.stack`属性，保存调用`Error.captureStackTrace`时候的代码位置信息

```js
const myObject = {};
Error.captureStackTrace(myObject);
console.log(myObject.stack); // Similar to `new Error().stack`
```

注意这个 stack 属性是不可枚举的，但是能够访问到

trace 信息的第一行会是 `${myObject.name}: ${myObject.message}`，没有这两个属性的话就是`Error`

第二个参数`constructorOpt`是一个函数对象，可选的，可以看成是 trace stack 记录的终点（不包含这个函数本身），这个函数本身及之后的 frame 都会被 omit

```js
function a() {
  console.log("aaa");
  ab();
}
function ab() {
  console.log("abaa");
  ac();
}
function ac() {
  console.log("acaa");
  Error.captureStackTrace(obj, ab);
  ad();
}
function ad() {
  console.log("adaa");
  // console.trace();
}
const obj = { name: "oobb", message: "FYI" };
a();
console.log(obj.stack);
// 下面只从 a 开始
// oobb: FYI
//    at a (../learn_react/err_trace.js:3:3)
//    at Object.<anonymous> (../learn_react/err_trace.js:19:1)
// ...
```

## Child Process

http://nodejs.cn/api/child_process.html

首先，干嘛学他？因为我想通过代码执行 shell 命令

`child_process` 模块能够 spawn child processes，（spawn: 生孩子，产卵。。）

### child_process.exec

`child_process.exec(command[, options][, callback])`

执行指令，command 是字符串`'"/目录/空 格/文件.sh" 参数1 参数2'`

```js
exec('"/目录/空 格/文件.sh" 参数1 参数2');
// 使用双引号，使路径中的空格不会被解释为多个参数的分隔符。

exec('echo "\\$HOME 变量为 $HOME"');
// $HOME 变量在第一个实例中会被转义，但是第二个则不会。
```

## Path

### path.resolve() 和 path.join()

都可以做到连接两个路径，用`path.sep`连接生成规范的路径

不同的是，join 是连接，resolve 是解析成绝对路径！

#### join

```js
console.log(path.join("../ddd/eeee", "/fff")); // ../ddd/eeee/fff
console.log(path.join("../ddd/eeee", "../fff")); // ../ddd/fff
```

#### resolve

`/`被解析为根目录

```js
console.log(path.resolve("/ddd/eeee", "../fff")); // /ddd/fff
console.log(path.resolve("/ddd/eeee", "/fff")); // /fff
```

如果参数为空、空字符串，解析得到的绝对目录就是`__dirname`

若以`../`，`./`开头或者没有`/`开头的，也会作用到所在目录

```js
console.log(path.resolve("ddd/eeee", "./fff")); // __dirname/ddd/eeee/fff
```

## readline

### 可交互

```js
const readline = require("readline");
// 创建一个 interface 对象交互用的...
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

rl.question("What do you think of Node.js? ", (answer) => {
  // TODO: Log the answer in a database
  console.log(`Thank you for your valuable feedback: ${answer}`);

  rl.close();
});
```

### 读取一行输入

## NODE_OPTIONS

> [官方文档](https://nodejs.org/api/cli.html#node_optionsoptions)：A space-separated list of command-line options.
>
> 作为 cli 使用 node 的 options 环境变量，在 node 环境中会读取这个变量里的配置

如果配置需要空格分开，需要用引号包裹下

```bash
NODE_OPTIONS='--require "./my path/file.js"'
```

如果 node 指令后有相同的配置，_如果这个配置时单一值的_，**则会覆盖环境变量中的**

```bash
# The inspector will be available on port 5555

NODE_OPTIONS='--inspect=localhost:4444' node --inspect=localhost:5555
```

_如果是可以重复的配置_，则会以环境变量 `NODE_OPTIONS` 优先，cli 配置为后

```bash
NODE_OPTIONS='--require "./a.js"' node --require "./b.js"
# is equivalent to:
node --require "./a.js" --require "./b.js"
```

### 比较常用的 [v8 的配置](https://nodejs.org/api/cli.html#useful-v8-options)

#### `--max-old-space-size=SIZE` (in megabytes)

Sets the max memory size of V8's old memory section. 当内存达到限制时，v8 会花费更多的时间进行 GC 的操作。也有情况会导致内存爆炸，js 执行直接挂掉，可以设置相对更大的这块内存空间（注意自己电脑的最大内存）

```bash
NODE_OPTIONS=--max-old-space-size=16000 eslint ...
```

P.S. 顺便提下 v8 团队对于配置并不能保证是稳定的，所以 Node 侧也无法保证他的稳定，不过除此之外一部分的 v8 配置已经被 Nodejs 广泛接受，并且记录在了官方文档
