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

来自：https://pouchdb.com/2015/05/18/we-have-a-problem-with-promises.html（虽然是 15 年的文章，但是对 promise 的理解很好了）

译文：http://fex.baidu.com/blog/2015/07/we-have-a-problem-with-promises/
