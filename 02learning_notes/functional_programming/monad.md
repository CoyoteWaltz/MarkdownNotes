# Monad

直接看一篇[图解](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)吧

以及维基百科上用 JS 写的一个 writer 的例子

```js
// a monad is an abstraction that allows structuring programs generically.

// Writer monad
// monad is a data struct

// const writer = [value, []];

// unit produce a writer
const unit = (value) => [value, []];
// 两个 transform
const squared = (x) => [x * x, [`${x} was squared.`]];
const halved = (x) => [x / 2, [`${x} was halved.`]];

const bind = (writer, transform) => {
  const [value, log] = writer;
  const [result, updated] = transform(value);
  // bind 之后还是一个 writer 放回到一个 wrap 中
  return [result, log.concat(updated)];
};

// 这里用 reduce 去做
const pipeLog = (writer, ...transforms) => transforms.reduce(bind, writer);
// reduce 接受的是 (pre, cur) => {}
// 这里的 pre 是 writer cur 是 tranfrom 函数
// bind 返回的还是 writer 就行

const [value, log] = pipeLog(unit(10), squared, halved, halved);
console.log(value);
log.forEach((v) => console.log(v));
```
