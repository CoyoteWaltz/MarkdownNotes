# Promise

### Promise 穿透

```js
Promise.resolve("yes ok")
  .then(Promise.resolve("not ok"))
  .then((v) => {
    console.log("2", v);
  });
// 2 yes ok
```

想不到吧，如果 then 链中传递的不是一个 function，会解析为 `then(null)`，前面 resolve 的值会透传！

```js
Promise.resolve("yes ok")
  .then(null)
  .then((v) => 123)
  .then(null)
  .then((v) => {
    console.log(v); // 123
  });
```

**因此记住：永远都是往 `then()` 中传递函数！**

来自：[这篇](https://pouchdb.com/2015/05/18/we-have-a-problem-with-promises.html)（虽然是 15 年的文章，但是对 promise 的理解很好了）

[译文](http://fex.baidu.com/blog/2015/07/we-have-a-problem-with-promises/)

### [Promise.try](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise/try)

> **兼容性：chrome 128（2024/8/20），较新的 API，但可以先来了解一下**
>
> 一个静态的方法，接受一个函数（不论是同步/异步，返回或者 throw）都会将它的结果包装成一个 Promise

```javascript
Promise.try(func);
Promise.try(func, arg1);
Promise.try(func, arg1, arg2);
Promise.try(func, arg1, arg2, /* …, */ argN);
```

返回值：`Promise`

- fulfilled：函数同步的返回了一个值
- rejected：函数同步的 throw 了 error
- 异步 fulfilled 或者 rejected：函数返回了一个 promise

#### 用法

```javascript
new Promise((resolve) => resolve(func()));
```

需要包裹一个函数的返回成 promise，可以直接

```javascript
Promise.try(func);
```

但注意的是，不等价于下面的写法

```javascript
Promise.resolve().then(func);
// 因为这里其实是在异步的执行 func
```

所有 Promise 签名的 Class 都可以实现这样的 try 方法（**注意这个不应该被作为 polyfill）**

```javascript
Promise.try = function (func) {
  return new this((resolve, reject) => {
    try {
      resolve(func());
    } catch (error) {
      reject(error);
    }
  });
};
```
