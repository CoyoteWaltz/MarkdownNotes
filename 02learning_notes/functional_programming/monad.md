# Monad

> 一篇[图解](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)
>
> 以及参考[这篇](https://dev.to/joelnet/functional-javascript---functors-monads-and-promises-1pol)讲的还是挺好的
>
> 2023.06.27 20:09:37 +0800 看了这个[视频](https://www.youtube.com/watch?v=dkZFtimgAcM)，Douglas Crockford（虽然我也不认识是谁）十年前对于 Monad 的解释，很棒，玩了一些哏

首先，知道 Monad 是什么之前还需要知道

### Functors, Monads, and Promises

#### Functors

什么是 Functor

_Definition: A `Functor` is something that is `Mappable` or something that can be mapped between objects in a Category._

得先对这些有一定认识：Categories, Object and Maps (Morphisms)

Category 就是一系列对象和一系列 morphisms（函数）的集合

对象可以是任何东西，number string urls user...

map 就是将一个（种）对象映射成另一个对象的函数

A `map` between objects is called a `Morphism`.

函数也可以通过组合来完成，A -> B -> C 可以直接 A -> C

一个对象是 `Mappable` 的（可以被影射成其他对象的）

数组是 Mappable 的，所以它就是一个 Functor

```javascript
const numberToString = (num) => num.toString();

const array = [1, 2, 3];
array.map(numberToString);
//=> ["1", "2", "3"]
```

Note: One of the properties of a **`Functor` is that they always stay that same type of `Functor`**. You can morph an `Array` containing `Strings` to `Numbers` or any other object, but the `map` will ensure that it will always be an `Array`. You cannot `map` an `Array` of `Number` to just a `Number`.

```javascript
const Thing = (value) => ({
  value,
});
const Thing = (value) => ({
  value,
  map: (morphism) => Thing(morphism(value)),
  //                 ----- -------- -----
  //                /        |            \
  // always a Thing          |             value to be morphed
  //                         |
  //             Morphism passed into map
});

const thing1 = Thing(1); // { value: 1 }
const thing2 = thing1.map((x) => x + 1); // { value: 2 }
```

这样，Thing 有了 map 之后类型还是 Thing，所以它就是个 `Functor`

The `"Thing"` `Functor` we created is known as `Identity`.

#### Monad

但如果你的 morphism 函数，又包裹了一层 `Thing`

```javascript
const getThing = () => Thing(2);
const thing1 = Thing(1);

thing1.map(getThing); //=> Thing (Thing ("Thing 2"))
```

Array 也是如此，map 可以让他变成嵌套数组

不过数组有 `flatMap` 可以解决这个问题

```javascript
const Thing = (value) => ({
  value,
  map: (morphism) => Thing(morphism(value)),
  flatMap: (morphism) => morphism(value),
});

const thing1 = Thing(1); //=> Thing (1)
const thing2 = thing1.flatMap((x) => Thing(x + 1)); //=> Thing (2)
```

下面的 Just 也是

```javascript
const Just = require("mojiscript/type/Just");
const Nothing = require("mojiscript/type/Nothing");
const { fromNullable } = require("mojiscript/type/Maybe");

const prop = (prop) => (obj) => fromNullable(obj[prop]);

Just({ name: "Moji" }).flatMap(prop("name")); //=> Just ("Moji")
Just({}).flatMap(prop("name")); //=> Nothing
```

所以这就是 Monad 了！

**Both mappable and flat-mappable**

#### Promise

在回头看看 promise，到底是 monad 还是 functor 呢

_then -> map? flatMap?_

```javascript
const double = (num) => num * 2;

const thing1 = Thing(1); //=> Thing (1)
const promise1 = Promise.resolve(1); //=> Promise (1)

thing1.map(double); //=> Thing (2)
promise1.then(double); //=> Promise (2)

thing1.flatMap((x) => Thing(double(x))); //=> Thing (2)
promise1.then((x) => Promise.resolve(double(x))); //=> Promise (2)
```

Promise 并不能嵌套 Promise，所以破坏了 Monad 的规则

```javascript
thing1.map((x) => Thing(x + 1)); // Thing (Thing (2))
promise1.then((x) => Promise.resolve(x + 1)); // Promise (2)

thing1.flatMap((x) => x + 1); //=> 2
promise1.then((x) => x + 1); //=> Promise (2)
```

### summary

- A `Functor` is something that is `Mappable` or something that can be mapped between objects in a Category.
- A `Monad` is similar to a `Functor`, but is `Flat Mappable` between Categories.
- `flatMap` is similar to `map`, but yields control of the wrapping of the return type to the mapping function.
- A Promise breaks the `Functor` and `Monad` laws, but still has a lot of similarities. Same same but different.

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
