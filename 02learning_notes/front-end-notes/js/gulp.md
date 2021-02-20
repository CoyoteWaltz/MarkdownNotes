# gulp 学习

[toc]

gulp 是啥？

用一个比喻来说： gulp 就好比是家里的保姆，能给他安排任务区完成。

这些任务在 web 前端开发中是什么呢？比如：打包代码，转译语言到浏览器认识到语言等。

所以 gulp 也是一个自动化构建的工具（基于 node ）。

和 webpack 不同，更像是一个 **task runner** ，而 webpack 一切皆 module ，是一个 **module bundler**

## 安装

node 环境

全局的命令行工具`npm install -g gulp-cli` or 用 yarn

在项目目录中`npm install --save-dev gulp`

or `yarn add -D gulp`

查看版本`gulp -v` 可以看到脚手架和项目中的版本

本文使用：`4.0.2`

## 快速上手

### `gulpfile.js` or `GulpFile.js`文件

- 在这个文件中给 gulp 小保姆安排任务，执行`gulp`命令的时候会自动加载这个文件。
- 在这个文件导出的方法会被注册到 gulp 的任务系统。
- 当然也可以将这个文件中的内容分离到各个子文件，然后统一组织起来，由于 node 的模块系统，可以创建一个叫`gulpfile.js`的目录，确保有`index.js`文件即可。

```shell
gulpfile.js/
	--index.js
	--taskA.js
	--taskB.js
```

### 创建任务

每个任务都是一个**异步的函数**：

- 接受一个 callback 函数（而且是 [error-first 回调](https://nodejs.org/api/errors.html#errors_error_first_callbacks)，也就是第一个参数是 err ，没有错误的情况为 `null`）
- 返回是一个 **[stream](https://nodejs.org/api/stream.html#stream_stream)**流对象, promise, event emitter, child process or observable

每个任务可以是 public 或者 private

- public: 在 gulpfile 中被导出的任务，这样用`gulp`指令也可以执行
- private: 只能在 gulpfile 中被其他任务使用，用`series()`或者`parallel()`来组合，就是不能被单独执行罢了

```js
const { series } = require("gulp");

function defaultTask(cb) {
  cb();
}

function build(cb) {
  console.log("build");
  cb();
}
// 导出一个 build
exports.build = build;
exports.default = series(defaultTask, build);
```

查看任务`gulp --tasks`

```shell
❯ gulp --tasks
[20:33:35] Tasks for ~/programming/FrontEnd/learn_gulp/gulpfile.js
[20:33:35] ├── build
[20:33:35] └─┬ default
[20:33:35]   └─┬ <series>
[20:33:35]     ├── defaultTask
[20:33:35]     └── build
```

组合这些任务**`series()`**以及**`parallel`**，可以互相嵌套，他们的返回也能继续给下一个任务

```js
// ...略
const html = series(build, function (cb) {
  cb();
});

exports.build = series(html, css, jsMinify, parallel(defaultTask, build));
```

### 通知任务完成

一个任务结束之后的**返回**会通知 gulp 继续执行或者终止，如果一个任务返回了错误， gulp 就会立即停止

这些东西除了 promise ，其他都是 node 中的。。stream, promise, event emitter, child process, or observable 。还要去学一学。。。

所以别忘了返回这些类型的对象来告诉 gulp 可以开始下一个任务。

当然也可以用 `async/await`来写任务

### 处理文件

`src()` 和 `dest()` 是 gulp 用来交互文件的接口

`src()`从 fs 中读取文件，创建一个 [Node stream](https://nodejs.org/api/stream.html#stream_stream) ，（流就可以理解为数据可能太多了不能一次性被处理，要一点一点读和处理），这个流对象会定位到所有匹配到的文件，然后读到内存，输入到流中。

```js
const { src, dest } = require("gulp");

exports.default = function () {
  return src("src/*.js").pipe(dest("output/"));
};
```

Stream 最重要的一个方法就是`pipe()`能够链式处理流

`dest()`(destination) 方法让流文件到达指定的目录，`symlink()`函数是可以让他成为一个软连接。

#### 在流中加入别的文件

```js
const { series, parallel, src, dest } = require("gulp");
const babel = require("gulp-babel");
const uglify = require("gulp-uglify");

function stream() {
  return src("./src/*.js")
    .pipe(src("./vendor/*.js"))
    .pipe(babel({ presets: ["@babel/preset-env"] }))
    .pipe(uglify())
    .pipe(dest("output"));
}
```

当然这些插件都是需要安装的

#### 在任务流中输出文件

可以输出一份没有压缩/丑化过的代码，然后这些代码会继续在管道中进行下去

```js
// ...
const rename = require("gulp-rename");

function stream() {
  return src("./src/*.js")
    .pipe(src("./vendor/*.js"))
    .pipe(babel({ presets: ["@babel/preset-env"] }))
    .pipe(dest("output/"))
    .pipe(uglify())
    .pipe(rename({ extname: ".min.js" }))
    .pipe(dest("output/"));
}
```

#### src(glob, [option])的三种模式

streaming, buffered, and empty

在 option 中配置 `buffer` true 或者 false

- 默认的是 true， buffer 模式，缓存文件内容在内存中，插件通常都是操作缓存模式的内容，并不支持流模式
- 给 false 的时候是流模式，通常操作大文件，但是插件都不支持。
- 空模式不包含内容，通常操作文件元数据（路径名之类的）比较好用

### Globs

英文直译是：一滴、一团的意思。

这里所指的是字符`*`, `**` or `!`，用来匹配文件路径的。

不要使用`path`模块来连接，也不要用`__dirname`或者`__filename`或者`process.cwd()`因为这样在 windows 会产生很 nc 的 `\\`。

#### single-star

`*` 在一个分割下匹配

匹配类似`index.js`，但是不会匹配带路径的文件`src/index.js`

#### double-star

`** ` 用来跨路径（分割符）的匹配

例如：`script/**/*.js`会匹配`script`路径下所有的 js 文件

_如果最前面没有文件夹限制的话，整个项目中的所有都会被匹配到（包括 node_modules ）。。。。_

#### negative

`! `

匹配可以是按照数组顺序，使用 非 匹配的时候需要跟在一个正常匹配的 glob 之后

`['scripts/**/*.js', '!scripts/vendor/**']`这样后者可以过滤掉前者匹配到的文件，最后的`/**`必须要加（内部会做匹配优化）

例：`src(['**/*.js', '!node_modules/**', '!output/**'])`

### 使用插件

gulp 插件是基于 node 的流变换，能够在管道中对流对象进行各种奇奇怪怪的操作（用`pipe()`）

上面的例子已经用了几个插件了

条件插件：`const gulpif = require('gulp-if');`

- 定义一个函数（一元谓词）
- 使用`.pipe(gulpif(jsJavaScript, uglify()))`

[插件都在这里](https://gulpjs.com/plugins/)

### Watch 文件

监听文件变化，然后执行对应的任务

```js
task("watch", function () {
  watch("./src/*.js", series(build, stream));
});
```
