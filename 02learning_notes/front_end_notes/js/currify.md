# 柯里化

是什么，Currying is the process of transforming a function that takes multiple arguments into a series of functions that take one argument at a time.

废话不多说直接看代码

```javascript
// 接受需要被柯里化的函数 返回一个函数 如果这个函数的接受的参数不足够原来的函数
// 则继续递归 再返回一个函数 直到原函数 fn 所有的参数 都被放入
const currify = (fn, params = []) => (...args) =>
  params.length + args.length === fn.length
    ? fn(...params, ...args) // 满足参数数量 执行fn
    : currify(fn, [...params, ...args]); // 不满足继续柯里化
```

要注意，函数的 length 属性是其参数列表的长度哦

```js
const add3 = (a, b, c) => a + b + c;
const curryAdd = currify(add3);

console.log(add3(1, 2, 3)); // 6
console.log(curryAdd(1)(2)(3)); // 6
```
