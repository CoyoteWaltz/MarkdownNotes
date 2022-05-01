# ES6789?笔记

[toc]

## Object.fromEntries(ES 2019)

> [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/fromEntries)
>
> Object.entries 的逆操作
>
> 有的时候通过 entries/values 重组的对象可以直接通过这个方法再组装回去

```js
Object.fromEntries([["eee", "ee"]]);
// { eee: 'ee' }
```

From Map

```js
const m = new Map([
  ["23", 123],
  ["eew", 333],
]);

Object.fromEntries(m);
// { '23': 123, eew: 333 }
```

## 数值分隔符 Numeric Separators(ES 2021)

> 还挺好，用起来吧

```js
let fee = 123_00; // $123 (12300 cents, apparently)
let fee = 12_300; // $12,300 (woah, that fee!)
let amount = 12345_00; // 12,345 (1234500 cents, apparently)
let amount = 123_4500; // 123.45 (4-fixed financial)
let amount = 1_234_500; // 1,234,500
```

## logical assignment operators(ES 2021)

> [Stage 4 了](https://github.com/tc39/proposal-logical-assignment)

```js
// "Or Or Equals" (or, the Mallet operator :wink:)
a ||= b;
a || (a = b);

// "And And Equals"
a &&= b;
a && (a = b);

// "QQ Equals" QQ 应该是 question question
a ??= b;
a ?? (a = b);
```

### why

经常会有判断某个变量是否有值，如果没有就给他赋值

```js
function foo(a) {
  if (!a) {
    a = "foo";
  }
  // or 利用 || 的断路机制
  // a || (a = "foo")
}
```

所以 `a ||= "foo"` 就是先判断是否 a 值，没有就给 a 赋值，`??=` 同理

**`&&=` 就有点不太一样了，是当 a 是 truthy 的时候，重新给 a 赋值。**

### 语义

注意逻辑赋值操作符其实是两个过程：

1. 先取值判断 truthy（get）
2. 根据上个过程决定是否需要赋值（set）

所以要注意不一定每次都会调用 setter

_最后注意的是，这个短语法还是有别于算术操作符（比如 `+=`）的，有 [issue](https://github.com/tc39/proposal-logical-assignment/issues/3) 讨论（懒得细看了）_

## String 标签模版

在函数名后紧跟着模版字符串（标签其实就是函数）

```js
alert`yes ok`;
// 等价于
alert(["yes ok"]);
```

当模版字符串中有变量 `${}` 的时候，处理起来就不一样了，会将变量所在的占位符作为 split 的位置将字符串分隔成数组作为函数的第一个参数，变量依次取值作为剩余参数传入，形如

```js
// const tag = (stringVals, ...args) => {}
tag = (stringVals, ...args) => {
  console.log(stringVals);
  console.log(args);
};
// let a = 123;
// tag`yes ok${a}`
// ["yes ok", ""]
// [123]
```

还原字符串

```js
// 还原模版字符串 with 变量
const pass2 = (stringArr, ...args) => {
  // console.log(stringArr, args);
  const res = [];
  for (let i = 0; i < args.length; ++i) {
    res.push(`${stringArr[i]}${args[i]}`);
  }
  res.push(stringArr[stringArr.length - 1]);
  return res.join("");
};

// .... 一行超人 没必要
const pass = (stringArr, ...args) =>
  [
    ...args.map((v, i) => `${stringArr[i]}${v}`), // 可以对 v 做一些操作 比如 safe parse
    stringArr[stringArr.length - 1],
  ].join("");
```

## Set 集合

集合类型的常规方法就不多说了

看一下他的迭代器 `Symbol.iterator` 指向的是 `Set.prototype.values`

```js
Set.prototype[Symbol.iterator] === Set.prototype.values;
```

也有 `keys` 和 `entries`，和 `forEach` 方法，也可以对其使用 `...` 展开

### 集合操作

没有提供官方的 API，但是利用上面的特性去实现也很简单

#### 并集（Union）

```js
const union = new Set([...setA, ...setB]);
```

#### 交集（Intersect）

```js
const intersect = new Set([...setA].filter((v) => setB.has(v)));
```

#### 差集（Difference）

A - B: A 中有的，B 中没有

```js
const differenceAB = new Set([...setA].filter((v) => !setB.has(v)));
```

## Promise.allSettled

和`Promise.all`用法一样，都是接受一组 promise，最大的区别是 all 只有全部的 promise 都是 resolved 了才会返回，allSettled 会等待所有 promise 的状态**都**从 pending 变化了才会返回，**能获得所有的结果**（相当于是 all 做了一个 `.catch` 的处理）

返回的结果会有`status`和`value`来表示，rejected 情况下会是`reason`

```js
const resolved = Promise.resolve(42);
const rejected = Promise.reject(-1);

const allSettledPromise = Promise.allSettled([resolved, rejected]);

allSettledPromise.then(function (results) {
  console.log(results);
});
// [
//    { status: 'fulfilled', value: 42 },
//    { status: 'rejected', reason: -1 }
// ]
```

## Proxy

要明白 Vue3 的响应式原理当然先要学这个 Proxy 和 Reflect 咯

阮一峰的描述：

> Proxy 用于修改某些操作的默认行为，等同于在语言层面做出修改，所以属于一种“元编程”（meta programming），即对编程语言进行编程。

就是在编程语言上的一个代理的作用，对谁做代理呢？当然是 Object，可以对一些对象的操作做拦截，进行改写和过滤（Charles）。

```js
let obj = {
  name: "dio",
};

obj.proxy = new Proxy(obj, {
  get(target, propKey, receiver) {
    console.log(target, propKey, receiver);
    console.log(`getting ${propKey}`);
    return target[propKey];
  },
  set(target, propKey, value, receiver) {
    console.log(target, propKey, receiver);
    if (propKey in target) {
      console.log(`setting ${propKey}`);
      target[propKey] = value;
      return true;
    }
    return false;
  },
});

const p = obj.proxy;

console.log(p.name);
p.name = 123;
console.log(p);
console.log(obj);
```

可以看出，其实 proxy 做的事情是对`.`运算符做了重载（overload），令人怀念的 c++ 重载运算符啊。

`proxy`可以重新定义 handle 来代理原来的各种方法

### 可拦截的操作

摘自：阮一峰，一共 13 种。

- **get(target, propKey, receiver)**：拦截对象属性的读取，比如`proxy.foo`和`proxy['foo']`。
- **set(target, propKey, value, receiver)**：拦截对象属性的设置，比如`proxy.foo = v`或`proxy['foo'] = v`，返回一个布尔值。
- **has(target, propKey)**：拦截`propKey in proxy`的操作，返回一个布尔值。
- **deleteProperty(target, propKey)**：拦截`delete proxy[propKey]`的操作，返回一个布尔值。
- **ownKeys(target)**：拦截`Object.getOwnPropertyNames(proxy)`、`Object.getOwnPropertySymbols(proxy)`、`Object.keys(proxy)`、`for...in`循环，返回一个数组。该方法返回目标对象所有自身的属性的属性名，而`Object.keys()`的返回结果仅包括目标对象自身的可遍历属性。
- **getOwnPropertyDescriptor(target, propKey)**：拦截`Object.getOwnPropertyDescriptor(proxy, propKey)`，返回属性的描述对象。
- **defineProperty(target, propKey, propDesc)**：拦截`Object.defineProperty(proxy, propKey, propDesc）`、`Object.defineProperties(proxy, propDescs)`，返回一个布尔值。
- **preventExtensions(target)**：拦截`Object.preventExtensions(proxy)`，返回一个布尔值。
- **getPrototypeOf(target)**：拦截`Object.getPrototypeOf(proxy)`，返回一个对象。
- **isExtensible(target)**：拦截`Object.isExtensible(proxy)`，返回一个布尔值。
- **setPrototypeOf(target, proto)**：拦截`Object.setPrototypeOf(proxy, proto)`，返回一个布尔值。如果目标对象是函数，那么还有两种额外操作可以拦截。
- **apply(target, object, args)**：拦截 Proxy 实例作为函数调用的操作，比如`proxy(...args)`、`proxy.call(object, ...args)`、`proxy.apply(...)`。
- **construct(target, args)**：拦截 Proxy 实例作为构造函数调用的操作，比如`new proxy(...args)`。

### handler 拦截方法应用

#### get

**让数组访问不越界**

```js
function myArray(...elements) {
  const handler = {
    get(target, propKey, receiver) {
      let index = Number(propKey);
      if (index < 0) {
        // 实现 arr[-1] 获取最后一个 这里仅修改 propKey 的值 让 Reflect 去 get
        propKey = String(target.length + index);
      }
      if (Number(propKey) < 0) {
        propKey = "0";
      }
      return Reflect.get(target, propKey, receiver);
    },
  };
  const target = [];
  target.push(...elements);
  return new Proxy(target, handler);
}

let arr = myArray(1, 2, 3, 4, 5, 6);
console.log(arr);
console.log(arr[0]);
console.log(arr[-124]);
```

`get`方法可继承（让 proxy 成为 prototype）

**利用`get`拦截，实现一个生成各种 DOM 节点的通用函数`dom`。**（来自阮一峰）

**看看 receiver 是什么**

它总是指向原始的读操作所在的那个对象，一般情况下就是 Proxy 实例。所以对 proxy 操作还是对其本身对象进行操作

```js
const px = new Proxy(obj, {
  get(target, propKey, receiver) {
    if (propKey === "_receiver") {
      return receiver;
    }
    if (propKey === "_target") {
      return target;
    }
  },
});
console.log(px._receiver === px); // true
console.log(px._target === obj); // true
```

#### set

**阻止私有变量被修改**

```js
const handler = {
  get(target, key) {
    invariant(key, "get");
    return target[key];
  },
  set(target, key, value) {
    invariant(key, "set");
    target[key] = value;
    return true;
  },
};
function invariant(key, action) {
  if (key[0] === "_") {
    throw new Error(`Invalid attempt to ${action} private "${key}" property`);
  }
}
const target = {};
const proxy = new Proxy(target, handler);
proxy._prop;
// Error: Invalid attempt to get private "_prop" property
proxy._prop = "c";
```

注意，如果目标对象自身的某个属性，不可写（writeable）且不可配置（configurable），那么`set`方法将不起作用。

注意，严格模式下，`set`代理如果没有返回`true`，就会报错。

#### apply

**`apply`方法拦截函数的调用、`call`和`apply`操作**

```js
var handler = {
  apply(target, ctx, args) {
    // ctx 就是 上下文
    return Reflect.apply(...arguments);
  },
};
```

#### has

拦截`hasProperty`的操作，比如用`in`的时候。

```js
const hasHandler = {
  has(target, key) {
    if (key[0] === "_") {
      return false;
    }
    return key in target;
  },
};

const obb = {
  _private: "oops",
  name: "yes",
};

const pobb = new Proxy(obb, { ...hasHandler });
console.log("name" in pobb); // true
console.log("_private" in pobb); // false
console.log("pp" in pobb); // false
for (let k in pobb) {
  console.log(k); // _private name
  // for 循环的 in 不起作用
}
```

注意，`has`方法拦截的是`HasProperty`操作，而不是`HasOwnProperty`操作，即`has`方法不判断一个属性是对象自身的属性，还是继承的属性。

对 for 循环的 in 不起作用

#### construct

**`construct`方法用于拦截`new`命令**

```js
const newHandler = {
  construct(target, args, newTarget) {
    return new target(...args);
  },
};
```

`construct`方法返回的必须是一个对象，否则会报错

#### ownKeys

拦截对象自身属性的读取操作

- `Object.getOwnPropertyNames()`
- `Object.getOwnPropertySymbols()`
- `Object.keys()`
- `for...in`

```js
const ownKey = {
  ownKeys(target) {
    return Reflect.ownKeys(target).filter((key) => key[0] !== "_");
  },
};

const obb = {
  _private: "oops",
  name: "yes",
};

const pobb = new Proxy(obb, { ...hasHandler, ...ownKey });
```

注意，使用`Object.keys()`方法时，有三类属性会被`ownKeys()`方法自动过滤，不会返回。

- 目标对象上不存在的属性
- 属性名为 Symbol 值
- 不可遍历（`enumerable`）的属性

### Proxy 的静态方法

#### Proxt.revocable()

返回一个可取消的 Proxy 实例。返回一个对象属性 proxy 是代理，revoke 是取消代理的函数开关

```js
const { proxy: rep, revoke } = Proxy.revocable(obj, hasHandler);
console.log(rep.name);
revoke();
// console.log(rep.name);  // 这里报错了 如下
```

```bash
const maybeCustom = value[customInspectSymbol];
                             ^
TypeError: Cannot read property 'Symbol(nodejs.util.inspect.custom)' of null
```

可见实际上也是用 Symbol 实现

### this 问题

代理之后，target 内部的 this 指向代理！

```javascript
const target = {
  m: function () {
    console.log(this === proxy);
  },
};
const handler = {};

const proxy = new Proxy(target, handler);

target.m(); // false
proxy.m(); // true
```

## Reflect

`Reflect`对象与`Proxy`对象一样，也是 ES6 为了**操作对象**而提供的新 API

### 增加这个 API 的几个目的

1.  将`Object`对象的一些明显属于语言内部的方法（比如`Object.defineProperty`），**放到`Reflect`对象上**。现阶段，某些方法同时在`Object`和`Reflect`对象上部署，未来的新方法将只部署在`Reflect`对象上。也就是说，从`Reflect`对象上可以拿到语言内部的方法。
2.  修改某些`Object`方法的返回结果，让其变得更合理。比如，`Object.defineProperty(obj, name, desc)`在无法定义属性时，会抛出一个错误，而`Reflect.defineProperty(obj, name, desc)`则会返回`false`。_意味着之后有些方法直接用 Reflect 来操作会更好。_
3.  让`Object`操作都变成函数行为。某些`Object`操作是命令式，比如`name in obj`和`delete obj[name]`，而`Reflect.has(obj, name)`和`Reflect.deleteProperty(obj, name)`让它们变成了**函数行为**。
4.  `Reflect`对象的方法与**`Proxy`对象**的方法**一一对应**，只要是`Proxy`对象的方法，就能在`Reflect`对象上找到对应的方法。这就让`Proxy`对象可以方便地调用对应的`Reflect`方法，完成默认行为，作为修改行为的基础。也就是说，不管`Proxy`怎么修改默认行为，你总可以在`Reflect`上获取默认行为。_在 Proxy 中也不需要考虑原来的行为是如何实现了，直接交给`Reflect`_

### 静态方法

`Reflect`对象一共有 13 个静态方法。

- Reflect.apply(target, thisArg, args)
- Reflect.construct(target, args)
- Reflect.get(target, name, receiver)
- Reflect.set(target, name, value, receiver)
- Reflect.defineProperty(target, name, desc)
- Reflect.deleteProperty(target, name)
- Reflect.has(target, name)
- Reflect.ownKeys(target)
- Reflect.isExtensible(target)
- Reflect.preventExtensions(target)
- Reflect.getOwnPropertyDescriptor(target, name)
- Reflect.getPrototypeOf(target)
- Reflect.setPrototypeOf(target, prototype)

怎么感觉也是一层代理呢？

关于 receiver 可以以 set 为例，会将 this 绑定给 receiver

```javascript
let ssee = {
  _name: "init",
  get name() {
    return this._name;
  },
  set name(value) {
    console.log("set name");
    return (this._name = value);
  },
};

let rec = {
  _name: "eee",
  get name() {
    return this._name;
  },
};
// 有 set 的情况执行
let res = Reflect.set(ssee, "name", 0);
console.log(res);
console.log(ssee.name);
// 给 receiver 的情况下 上下文的 this 会帮绑定给 receiver
res = Reflect.set(ssee, "name", "kekekeke", rec);
console.log(res);
console.log(ssee.name); // 0
console.log(rec.name); // kekekeke
```

#### Reflect.defineProperty(target, propertyKey, attributes)

`Reflect.defineProperty`方法基本等同于`Object.defineProperty`，用来为对象定义属性。**未来，后者会被逐渐废除，请从现在开始就使用`Reflect.defineProperty`代替它。**

#### Reflect.getOwnPropertyDescriptor(target, propertyKey)

`Reflect.getOwnPropertyDescriptor`基本等同于`Object.getOwnPropertyDescriptor`，用于得到指定属性的描述对象，将来会替代掉后者。

#### Reflect.isExtensible (target)

如果参数不是对象，`Object.isExtensible`会返回`false`，因为非对象本来就是不可扩展的，而`Reflect.isExtensible`会报错。

```javascript
Object.isExtensible(1); // false
Reflect.isExtensible(1); // 报错
```

### 观察者模式例子

```js
// 观察者模式
const queuedObservers = new Set();

const observe = (fn) => queuedObservers.add(fn);
const observable = (obj) => new Proxy(obj, { set }); // 对 obj 做观察 set 直接用的下面那个

function set(target, key, value, receiver) {
  const result = Reflect.set(target, key, value, receiver);
  // set 之后 通知所有的 观察者 执行
  console.log("notify");
  queuedObservers.forEach((observer) => observer(value));
  return result;
}

observe((value) => {
  console.log("ob1:", value);
});

const proxyOfObj = observable(obj);
proxyOfObj.foo = "123123";
// notify
// ob1: 123123
```

## 数组 Array.from() Array.of()

### Array.from()

将可迭代对象（有 `Symbol.iterator` ）或者类数组的对象（arguments）转换为数组类型

可以接受第二个参数，一个 function，类似 map，对元素进行转换后放入数组

`Array.from()`的另一个应用是，将**字符串转为数组**，然后返回字符串的长度。因为它能正确处理各种 Unicode 字符，可以避免 JavaScript 将大于`\uFFFF`的 Unicode 字符，算作两个字符的 bug。

那么很多时候就很方便了，比如逆序字符串

```js
const reverseStr = (value) => Array.from(value).reverse().join("");
```

### Array.of()

`Array.of`方法用于将一组值，转换为数组。

`Array.of`基本上可以用来替代`Array()`或`new Array()`，并且不存在由于参数不同而导致的重载。它的行为非常统一：返回的都是有值数组，而不会是 `Array(n)` 返回一个长度为 n 的空数组。

## 数组 flat() flatMap()

第一次见到这两个函数是在一次面试题中。。。

函数顾名思义：将数组拉平（如果是多维数组 nested）

### flat()

```js
[1, [2, 2, 3] 2, 3].flat()
// 1, 2, 2, 3, 2, 3
```

默认拉 1 层，可以给层数，不管多少层都 flat 的时候可以`flat(Infinity)`

### flatMap()

`flatMap()`方法对原数组的每个成员执行一个函数（相当于执行`Array.prototype.map()`），然后对返回值组成的数组执行`flat()`方法。

返回新的数组，不改变原数组，只能展开一层

## 数组 find() findIndex()

都接受一元谓词，还可以接受第二个参数的，一个对象，bind 给第一个方法的

```js
function f(v) {
  return v > this.age;
}
let person = { name: "John", age: 20 };
[10, 12, 26, 15].find(f, person); // 26
```

### find()

返回第一个满足条件的成员，如果都无，返回`undefined`

### findIndex()

返回第一个满足条件的下标，都无则返回 -1

## 数组 some() every()

### some()

有一些（some）满足条件即可

接受一个 callback predicate，只要有一个元素中满足 predicate 为 true 的，整个就返回 true，否则为 false

会遍历整个数组，不会断路

### every()

每一个（every）满足条件即返回 true 否则 false

是可以**断路**的，立即返回 false

## 装饰器

装饰器 for **类**

回忆一下 Python 装饰器，其实也是利用闭包的语法糖，对原始函数进行增强功能，甚至是修改（感觉只有在 JS 中可以），有了这个语法糖，写起来方便，读起来清晰

### 用法

#### 类装饰器

`@ + functionName`基本都是这个语法

```js
@decorator
class A {}

// 等同于
class A {}
A = decorator(A) || A;
```

装饰器函数是一个高阶函数，接收一个 target，

```js
function testable(target) {
  target.isTestabel = true;
}
```

如果需要多个参数，可以再闭包一层

```js
function testable(isTestable) {
  return function (target) {
    target.isTestable = isTestable;
  };
}

@testable(true)
class MyTestableClass {}
MyTestableClass.isTestable; // true

@testable(false)
class MyClass {}
MyClass.isTestable; // false
```

注意，装饰器对类的行为的改变，**是代码编译时发生的**，而不是在运行时。这意味着，装饰器能在编译阶段运行代码。也就是说，装饰器本质就是编译时执行的函数。

在看一些来自阮一峰的例子

```js
// mixins.js
export function mixins(...list) {
  return function (target) {
    Object.assign(target.prototype, ...list);
  };
}

// main.js
import { mixins } from "./mixins";

const Foo = {
  foo() {
    console.log("foo");
  },
};

@mixins(Foo)
class MyClass {}

let obj = new MyClass();
obj.foo(); // 'foo'
```

在 React 和 Redux 一起用的时候（还没学 Redux。。。）

```js
class MyReactComponent extends React.Component {}

export default connect(mapStateToProps, mapDispatchToProps)(MyReactComponent); // 调用
```

可以写成

```js
@connect(mapStateToProps, mapDispatchToProps)
export default class MyReactComponent extends React.Component {}
```

#### for class's method

因为是用在类方法的，装饰器可以接受另外两个参数：name 和 descriptor，对应的是属性 name 和 `Object.getOwnPropertyDescriptor(obj, name)`

```js
class Math {
  @log
  add(a, b) {
    return a + b;
  }
}
function log(target, name, descriptor) {
  var oldValue = descriptor.value;
  // 对 descriptor 进行修改 返回一个新的函数 操作一波
  descriptor.value = function () {
    console.log(`Calling ${name} with`, arguments);
    return oldValue.apply(this, arguments);
  };

  return descriptor;
}

const math = new Math();

// passed parameters should get logged now
math.add(2, 4);
```

### 多个装饰器

洋葱模型

```js
function dec(id) {
  console.log("evaluated", id);
  return (target, property, descriptor) => console.log("executed", id);
}

class Example {
  @dec(1)
  @dec(2)
  method() {}
}
// evaluated 1
// evaluated 2
// executed 2
// executed 1
```

其实可以这么看

```js
@dec(1)
@dec(2)
method(){}
// 等价于
dec(1)(
  dec(2)(method)
)()
```

### why 没有函数的装饰器

python 是有的。。

装饰器只能用于类和类的方法，不能用于函数，因为存在函数提升。

```js
var readOnly = require("some-decorator");

@readOnly
function foo() {
}
// 实际是
var readOnly;  // 此时是 undefined 下面的函数定义就会报错

@readOnly
function foo() {
}

readOnly = require("some-decorator");
```

总之，由于存在函数提升，使得装饰器不能用于函数。类是不会提升的，所以就没有这方面的问题。

另一方面，如果一定要装饰函数，可以采用**高阶函数**的形式直接执行，写一个 wrapper。

#### core-decorators.js

一个第三方库，提供了一些类装饰器，详见[github](https://github.com/jayphelps/core-decorators)

### 一些应用

#### mixin

## class

让 JS 写 OOP 的时候也像其他语言（C++，Java，Python）那么流畅（看起来像那么回事）

class 其实是 ES6 为了实现类的一个语法糖

```js
class Tank {
  constructor(name, year) {
    this.name = name;
    this.year = year;
  }
  toString() {
    return `Tank: ${this.name}-${this.year}`;
  }
}

const KingTiger = new Tank("tiger", 1940);
console.log(Tank); // Function
console.log(Tank.prototype.constructor === Tank); // true
console.log(KingTiger);
```

其实就是写了一个构造函数的 function，只不过用 class 语法糖将一些实现细节给屏蔽了，我们能标准的、顺畅的开发了。

所以我们需要明白的是 class 做了哪些转换规则：

构造函数中的`toString()`和`toValue()`等方法也都放到`prototype`去了，**是不可枚举的**

```js
console.log(Object.keys(Tank.prototype)); // []
console.log(Object.getOwnPropertyNames(Tank.prototype)); // [ 'constructor', 'toString', 'toValue', 'fire' ]
```

### 构造函数

回忆一下 python/c++ 的`__init__(self, )`,`Class::Class()`

```js
class Point {}

// 等同于
class Point {
  constructor() {}
}
```

没有写的话会自动加上这个

也是通过`new`关键字来创建实例，调用这个`constructor`

关于`__proto__`是指向`prototype`的，但是不是标准的用法，可以查阅 MDN

> `__proto__` 并不是语言本身的特性，这是各大厂商具体实现时添加的私有属性，虽然目前很多现代浏览器的 JS 引擎中都提供了这个私有属性，但依旧不建议在生产中使用该属性，避免对环境产生依赖。生产环境中，我们可以使用 `Object.getPrototypeOf` 方法来获取实例对象的原型，然后再来为原型添加方法/属性。

### getter & setter

与 ES5 一样，在“类”的内部可以使用`get`和`set`关键字，对某个属性设置存值函数和取值函数，拦截该属性的存取行为。

```js
class Tank {
  constructor(name, year) {
    this.name = name;
    this.year = year;
  }
  get amount() {
    return this._amount ? this._amount : (this.amount = 0);
  }
  set amount(value) {
    this._amount = this._amount ? this._amount + value : value;
    return this._amount;
  }
}
const KingTiger = new Tank("tiger", 1940);
console.log(KingTiger.amount); // 0
KingTiger.amount = 100;
console.log(KingTiger.amount); // 100
```

写的时候踩坑了，如果上面的`this._amount`没有下划线，那就会无限循环调用`set`和`get`，然后就爆 stack 了

类的名字`Tank.name`和普通对象构造函数一样用法

立即执行的类

```js
let person = new (class {
  constructor(name) {
    this.name = name;
  }
  sayName() {
    console.log(this.name);
  }
})("张三");

person.sayName(); // "张三
```

### 值为类的变量

```js
const ttt = class Tank {
  constructor(name, year) {
    this.name = name + Tank.name;
    this.year = year;
    this.bomb = 100;
    ...
```

可以将类赋值给一个对象，但是类的名称还是`Tank`所以`class`只是声明了一个类，他后面的就是名字`ttt.name => Tank`

### 注意点

#### 1.严格模式

在类和 ES 模块中默认就是`use strict`的

> 考虑到未来所有的代码，其实都是运行在模块之中，所以 ES6 实际上把整个语言升级到了严格模式。

#### 2.不存在变量提升 hoist

```js
{
  let Foo = class {};
  // 如果 class 提升了 这里 Bar 就无法继承 Foo 了
  class Bar extends Foo {}
}
```

#### 3.类的 name

#### 4.Generator 方法

在类方法前面加`*`就可以了

```js
* fire() {
  console.log('boommmmm!');
  for (let i = 0; i < this.bomb; ++i) {
    yield 'booommmm! ' + i;
  }
}
// 这个对象属性 指向实例的默认迭代器 详见下面的 Symbol
* [Symbol.iterator]() {
  for (let i = 0; i < this.amount; ++i) {
    yield `gen no.${i+1} tank`;
  }
}
```

#### 5.this 的指向

类方法的 this 都是指向实例的，但是如果单独拿出来类方法`const {fire} = Tank`就要注意`this`了，在严格模式下就是`undefined`

一个比较简单的解决方法是，在构造方法中绑定`this`，这样就不会找不到`print`方法了。

```js
constructor() {
  // bind 一下
  this.printName = this.printName.bind(this);
}
```

使用箭头函数

```js
class Obj {
  constructor() {
    // 保存的是调用时的上下文
    this.getThis = () => this;
  }
}

const myObj = new Obj();
myObj.getThis() === myObj; // true
```

还有一种解决方法是使用`Proxy`，获取方法的时候，自动绑定`this`。

TODO 这个之后在学！

### 静态方法

和其他的 oop 一样的类静态方法

注意：静态类方法的`this`指向的是这个类！

```js
class Foo {
  static bar() {
    this.baz();
  }
  static baz() {
    console.log("hello");
  }
  baz() {
    console.log("world");
  }
}

Foo.bar(); // hello
```

可以继承父类的静态方法

静态方法也是可以从`super`对象上调用的

### 静态属性

```js
class ModernTank extends ttt {
  static modern = true;
  tag = "TAG";
  constructor(name, year) {
    super(name, year);
    this.modified = 1000;
  }
  static get isModern() {
    // 这里的 this 是 ModernTank 我们调用他的静态成员
    return this.modern;
  }
}
const mtk = new ModernTank("M4A1", 2020);
console.log(ModernTank.isModern); // true
```

### 实例属性写在顶级

不仅可以在`constructor`中写，也可以在类的顶级写，例子见上

### 公有私有属性

现在只有解决方案和提案：[阮一峰](https://es6.ruanyifeng.com/#docs/class#私有属性的提案)有写到

### new.target

`new`关键字的属性！返回`new`命令作用于的那个构造函数，new 的目标，一般用在构造函数里面

```js
function R() {
  if (typeof new.target === "undefined") {
    throw new Error("用 new 来构造！");
  }
  this.e = 123;
  this.name = R.name;
}
R(); // 报错咯
```

可以防止直接调用构造函数

继承的时候，会返回子类

```js
class Rectangle {
  constructor(length, width) {
    console.log(new.target === Rectangle);
    // ...
  }
}

class Square extends Rectangle {
  constructor(length, width) {
    super(length, width);
  }
}
new Square(3, 3);
```

### 继承

关键字`extends`，子类的构造函数必须用`super()`来初始化父类，因为实际上是先构造父类，再将子类的东西添加上去

> ES5 的继承，实质是先创造子类的实例对象`this`，然后再将父类的方法添加到`this`上面（`Parent.apply(this)`）。ES6 的继承机制完全不同，实质是先将父类实例对象的属性和方法，加到`this`上面（所以必须先调用`super`方法），然后再用子类的构造函数修改`this`。

不写构造函数的时候会自动给

```js
class ColorPoint extends Point {}

// 等同于
class ColorPoint extends Point {
  constructor(...args) {
    super(...args);
  }
}
```

#### super

作为方法：只能在构造函数中使用，用来初始化父类

作为对象：在类方法中指向父类**原型**（也就是包含父类的全部属性），在静态方法中指向父类

由于`this`指向子类实例，所以如果通过`super`对某个属性赋值，这时`super`就是`this`，赋值的属性会变成子类实例的属性。

```js
class A {
  constructor() {
    this.x = 1;
  }
}

class B extends A {
  constructor() {
    super();
    this.x = 2;
    super.x = 3;
    console.log(super.x); // undefined
    console.log(this.x); // 3
    // console.log(super) // 会报错
  }
  go(x) {
    super.x = x;
  }
}

let b = new B();
b.go(1000);
console.log(b); // x: 1000
```

#### extends

可以继承原始类型

可以实现 [mixin 模式](https://es6.ruanyifeng.com/#docs/class-extends#Mixin-%E6%A8%A1%E5%BC%8F%E7%9A%84%E5%AE%9E%E7%8E%B0)

## padStart() padEnd()

字符串新增的方法！前后填充到指定长度，默认用空格

```js
"xxx".padStart(5, "a"); // -> aaxxx
"xxx".padStart(5, "abc"); // -> abxxx
"xxx".padStart(5, "0"); // -> 00xxx
"xxx".padStart(10, "pad"); // -> padpadpxxx
```

相当于是将填充字符串 pad 的前 n - str.length 位加到 str 前，当然 pad 如果长度不足 n ，会进行循环重复

## Symbol

用来制作一个唯一的标识（symbol）

_内容很多，介绍常用的，其他的看[阮一峰](https://es6.ruanyifeng.com/#docs/symbol)_

**_以及看[这篇](https://www.keithcirkel.co.uk/metaprogramming-in-es6-symbols/)讲 metaprogramming，非常好的深入 Symbol 的文章，以及一些常用的静态变量（Symbol.species、Symbol.toPrimitive...）_**

结合参考阮一峰 ES6 的描述：对象的属性都是字符串嘛，然后由于模块各种导入，谁知道某个人会在啥地方引入，为这个对象增加一个属性，万一冲突了，就 gg 了，这样 ES6 引入一个 Symbol，能保证每个属性都是独一无二的，根本上能防止属性名的冲突。

**注意：他是一个新的原始类型！**

复习一下其他的：。。。。自己默念一下哈

### 如何使用

#### 获得一个 Symbol

`Symbol`不能用`new`来构造，只是一个原始类型的值，**不是对象**，所以这个函数返回的实例也不是对象。。添加属性也没用

```js
let y = Symbol("hhh"); // 可以给一个字符串描述一下这个标识
console.log(typeof y); // symbol
y.a = "a";
console.log(y); // Symbol(hhh)
```

如果用一个对象去描述

```js
const obj = {
  toString() {
    return "ohla ohla ohla";
  },
};

let sm = Symbol(obj);
console.log(sm); // Symbol(ohla ohla ohla)
```

会调用他的`toString()`方法，对象默认 to string 是`[Object Object]`

不管是什么情况下得到的`Symbol`，都不会有相等的，都是独一无二的（我们）

#### 无法进行运算

```js
console.log(y + "123");
// 直接报错了，但是可以显示的变成字符串
console.log(y.toString() + "123"); // Symbol(hhh)123
```

#### 可以转为布尔值

```js
console.log(Boolean(y)); // true
console.log(!y); // false
```

#### 获取描述

`Symbol.prototype.description`

ES2019 提供的实例属性

```js
console.log(y.description); // hhh
```

#### 作为属性名的 Symbol

```js
const PROP_ABC = Symbol("abc");
const PROP_BBC = Symbol("bbc");
let a = {
  [PROP_BBC]() {
    if (this[PROP_ABC]) {
      console.log(this[PROP_ABC]);
    }
    console.log("bbc");
  },
};

a[PROP_ABC] = "abc for u";
a[PROP_BBC]();
```

就是写起来不能用`.`来取属性了

用作常量的定义（例子来自阮一峰），常量没有值的话给`Symbol`

```js
const log = {};

log.levels = {
  DEBUG: Symbol("debug"),
  INFO: Symbol("info"),
  WARN: Symbol("warn"),
};
console.log(log.levels.DEBUG, "debug message");
console.log(log.levels.INFO, "info message");
```

```js
const COLOR_RED = Symbol(); // 虽然这其实也可以用字符串。。。
const COLOR_GREEN = Symbol();

function getComplement(color) {
  switch (color) {
    case COLOR_RED:
      return COLOR_GREEN;
    case COLOR_GREEN:
      return COLOR_RED;
    default:
      throw new Error("Undefined color");
  }
}
```

常量使用 Symbol 值最大的好处，就是其他任何值都不可能有相同的值了

#### 魔法数字/字符串的值也不重要了！

通常我们会在项目中看到一些定义

```js
type = getType();

if (type === "node") {
  // 魔法字符串哦
  // ...
}
```

我们一般会写成

```js
const TYPES = {
  node: "node",
  path: "path",
};

if (type === TYPES.node) {
  // ...
}
```

可是发现没有，对应的字符串都没有用到，直接用`Symbol`也不是很舒服吗

```js
const TYPES = {
  node: Symbol("node"),
  path: Symbol("path"),
};

if (type === TYPES.node) {
  // ...
}
```

**所以，我们其实在用 vuex 的时候，需要定义`commit`名字常量的时候也可以用`Symbol`了！**

下次记得一定用！

#### 属性名遍历

**Symbol 作为属性名，遍历对象的时候，该属性不会出现在`for...in`、`for...of`循环中，也不会被`Object.keys()`、`Object.getOwnPropertyNames()`、`JSON.stringify()`返回。**

但也不是私有属性，可以通过`Object.getOwnPropertySymbols(obj)`方法得到一个对象的所有`Symbol`属性数组

```js
console.log(Object.getOwnPropertySymbols(a)); // [ Symbol(bbc), Symbol(abc) ]
```

所以遍历上面的结果就可以啦

#### 模块的单例模式

如果要实现模块属性的单例模式，我们通常会将属性挂在全局的`global`或者`window`上，但是这样其他人就可以直接修改属性值

让这个属性值是一个 Symbol，再挂到全局对象上去

#### Symbol.for() & Symbol.keyFor()

有时，我们希望重新使用同一个`Symbol`值，构造一个相同的`Symbol`

用`Symbol.for(string)`返回一个`Symbol`，如果已经有了那个描述的标识就返回那个`Symbol`，如果没有，就新建一个，就是个单例模式啊。

而直接调用`Symbol()`就是创建一个独一无二的

```javascript
let s1 = Symbol.for("foo");
let s2 = Symbol.for("foo");
// 如果给 s1 手贱添加属性的话 就永远是 false... why?
s1 === s2; // true
```

`Symbol.keyFor()`方法返回一个**已登记**的 Symbol 类型值的`key`。

`Symbol.for()`与`Symbol()`这两种写法，都会生成新的 Symbol。

它们的区别是，前者会**被登记**在全局环境中供搜索（再次`Symbol.for()`的时候），后者不会。`Symbol.for()`不会每次调用就返回一个新的 Symbol 类型的值，而是会先检查给定的`key`是否已经存在，如果不存在才会新建一个值。

```js
let x = Symbol.for("eee");
let z = Symbol.for("eee");
let eee = Symbol("eee");
console.log(x === z); // true
console.log(Symbol.keyFor(eee)); // undefined 没有登记
```

注意，`Symbol.for()`为 Symbol 值登记的名字，是全局环境的，不管有没有在全局环境运行。**是 cross-realm 的，在不同的框架或者 service worker 中创建的 Symbol 都是同一个 realm 的！**

```javascript
function foo() {
  return Symbol.for("bar");
}

const x = foo();
const y = Symbol.for("bar");
console.log(x === y); // true
```

### Symbol 内置的 Symbol 值

> 除了定义自己使用的 Symbol 值以外，ES6 还提供了 11 个内置的 Symbol 值，指向语言内部使用的方法。

是`Symbol`内置的属性，用来扩展对象的能力，简单了解几个，其他的见[阮一峰](https://es6.ruanyifeng.com/#docs/symbol#%E5%86%85%E7%BD%AE%E7%9A%84-Symbol-%E5%80%BC)

#### Symbol.hasInstance

对象的`Symbol.hasInstance`属性，指向一个内部方法，使用`instanceof`运算符的时候判断**是否为该对象的实例**

```js
class MyArray {
  [Symbol.hasInstance](obj) {
    console.log(obj);
    return Array.isArray(obj);
  }
}

const ma = new MyArray();
console.log([1, 2, 3] instanceof ma);
// [ 1, 2, 3 ]
// true
```

会将运算符左边的值作为函数的参数，函数返回的值其实会被`Boolean`转换一下

```js
class Odd {
  static [Symbol.hasInstance](obj) {
    return Number(obj) & 1;
  }
}

// 等同于
const Odd = {
  [Symbol.hasInstance](obj) {
    return Number(obj) & 1;
  },
};
console.log(1 instanceof Odd); // true
console.log(2 instanceof Odd); // false
```

#### Symbol.isConcatSpreadable

可以控制一个`Array`对象是否可以在`Array.prototype.concat()`被展开

```js
const ar = [1, 4, 3];
console.log(ar[Symbol.isConcatSpreadable]); // undefined
ar[Symbol.isConcatSpreadable] = false;
console.log([555, 444].concat(ar));
// [ 555, 444, [ 1, 4, 3, [Symbol(Symbol.isConcatSpreadable)]: false ] ]
```

可以看到是不能展开的，而且多了一个属性，而且我们可以展开类似数组的对象，默认是不能在 concat 的时候展开的

```js
const ou = {
  0: 123,
  1: 312,
  length: 2, // 要有 length
};
ou[Symbol.isConcatSpreadable] = true;
console.log([555, 444].concat(ou));
// [ 555, 444, 123, 312 ]
```

#### Symbol.iterator

对象的属性，指向该对象的默认遍历方法，返回迭代器，详细看迭代器的部分

```javascript
const myIterable = {};
myIterable[Symbol.iterator] = function* () {
  yield 1;
  yield 2;
  yield 3;
};

[...myIterable]; // [1, 2, 3]
```

## Map

核心：比 object 更好的映射、遍历 key 等

### 简介

映射，类似字典，**会记住键值对插入的顺序**

底层其实维护的是两个数组，分别存放 key 和 value，遍历 Map 的时候也就是`for...of`这两个数组

key 如果是`NaN`的话，不会出现`NaN !== NaN`的情况，同时`-0`和`+0`在最新标准中是相等的

问题来了，对象也似乎拥有字典的作用，之前我们也都一直用对象来作为字典，新的 Map 有啥不一样呢？

|                 | Map                                              | Object                                                                    |
| :-------------- | :----------------------------------------------- | :------------------------------------------------------------------------ |
| Accidental Keys | 不包含任何的默认 key，每个键值对都需要显式的加入 | 原本就是一个构造函数嘛，会有一些内置的 key，甚至会和你定义的 key 造成冲突 |
| key 的类型      | 可以是任意的！                                   | 是能是字符串 or `Symbol`                                                  |
| Key 的顺序      | 有序的                                           | 无序（es6 之后是只有 string 类型的 key 在遍历时有序的）                   |
| size            | 可以访问`.size`属性看大小                        | 手动的看吧（Object.keys 可枚举属性）                                      |
| **Iteration**   | iterable                                         | 只能遍历 key                                                              |
| 性能            | 处理键值对肯定推荐，处理是做优化的               | 无优化                                                                    |

### 用法

注意别像`object`那样给键值对，因为这个 Map 必然是一个对象啊。。

```js
const m = new Map();
// don't do this below
m["a"] = 123;
m.has("a"); // false
m.delete("a");
console.log(m); // Map(0) { a: 123 }  won't delete
```

**正确用法：**

```js
m.set(2141, "dsfaa");
const o = { a: 123 };
m.set(o, { b: 312 });
console.log(m);
console.log(m.has({ a: 123 })); // false
console.log(m.has(o)); // true
m.delete(o);
```

注意如果是引用类型作为键，那么他寻找的就是那个指针（引用）

### 方法 & 属性

#### 构造函数

```js
const kv1 = [
  [123, "sdf"],
  [223, "erw"],
];

const kv2 = [
  [123, "rrrr"],
  ["22222", "5555"],
];

const mp = new Map(kv1);
const mp2 = new Map([...kv1, ...kv2]);
const mp3 = new Map([...kv1, ...kv2, [{ ae: 33 }, 666]]);
console.log(...mp2); //	可以解构的... => 键值对数组 在 console.log 能解构因为他本身就接受无限参数 ...args
const arr = [...mp2]; // -> [ [ 123, 'rrrr' ], [ 223, 'erw' ], [ '22222', '5555' ] ]
```

注意：解构数组 后面的重复元素（键值对）会在 Map 中 merge 前面的键值对

#### 属性

- `size`：返回键值对的数量

#### 方法

- `clear()`

- `delete(key)`

- `entries()`：返回一个可迭代对象，包含键值对数组`[key, value]`，且有序（插入顺序）

  ```js
  for (const [k, v] of m.entries()) {
    console.log(k + "+" + v);
  }
  ```

- `forEach(callback, [thisArg])`

  ```js
  m.forEach((value, key, map) => {
    if (typeof key !== "object" && typeof value !== "object") {
      map.set(key + value, 0);
    }
  });
  ```

  别这样写代码，是个死循环。。。 map 无限扩容

- `get(key)`

- `has(key)`

- `keys()`

- `values()`

- `set(key, value)`

### 使用场景 v.s object

- key 一开始不确定，只有在运行时可得到（虽然 object 也有 [key] 的动态取值）
- 需要将其他的原始值存为 key 的时候，object 一律存为 string
- **存在对单个元素做操作的时候，用 object**？
- 更直接的迭代`for [key, valye] of map`

更多优势可以看 [Stop Using Objects as Hash Maps in JavaScript](https://medium.com/better-programming/stop-using-objects-as-hash-maps-in-javascript-9a272e85f6a8)（墙外）

## WeakRef(ES 2021)

> 弱引用 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/WeakRef)
>
> 强引用：变量对一个对象的指向，没有强引用之后，对象会被 GC 释放内存（reclaim the memory）
>
> **_Correct use of `WeakRef` takes careful thought, and it's best avoided if possible_**
>
> **_能够避免对象被 GC，但是用之前，请三思，最好别用_**

### 用法

`new WeakRef(targetObj)` 构造函数

`deref()` 返回实例创建时的 target 或者是 `undefined`（已经被 GC 了），**但是并不是去释放空间哦，只是拿到 obj**

具体代码看 MDN 的例子或者 [tc39](https://github.com/tc39/proposal-weakrefs)，感觉实战中不会用到

### 注意点

- 对于同一个 target 生成多个 `WeakRef` 之间是相互关联的，其中一个 `deref` 了 target 之后，其他的 `deref` 只会拿到 `undefined`
- You cannot change the target of a `WeakRef`, it will always only ever be the original target object or `undefined` when that target has been reclaimed. 不能改变 target

## FinalizationRegistry

> _[Finalizater](https://github.com/tc39/proposal-weakrefs)_ 又是一个不被推荐使用的，配合 WeakRef 可以一起用

`FinalizationRegistry` 对象可以在一个对象被垃圾回收的时候调用一个 callback

```js
// 定义 callback
const registry = new FinalizationRegistry((heldValue) => {
  // ....
});
// 注册一个对象
registry.register(theObject, "some value");
```

## WeakMap

> 弱 Map ，其中 key **必须**是 `object` ，值可以是任意的
>
> 核心：防止内存泄漏

### 和 Map 的比较

还记得 Map 的底层其实维护的是两个数组吗，所以每次 set 和 get 的时候都会去便利数组，也就是 O(n) 的效率，这其实和 py 的字典相比，差太多了（人家用哈希表 O(1)）

第二个问题是 Map 会造成内存泄漏，因为维护的两个数组会一直持有元素的引用，不会被 gc

### weak

持有“弱”引用的 key，在没有其他引用时候可以自动的垃圾回收（key 和 value）

所以在映射一些 key 只有在被引用的情况下的时候会非常好用，不引用的时候（置为 null）自动释放内存了

由于 weak，`WeakMap`的 key 是不可枚举的，也获取不到，如果要获取一组 key 还是用`Map`吧

### 方法

- `get(key)`

- `has(key)`

- `delete(key)`

- `set(key, value)`

### 用 WeakMap 来保存类的私有属性

来自 14 年的[一篇](https://fitzgeraldnick.com/2014/01/13/hiding-implementation-details-with-e6-weakmaps.html)

很有趣的用法

```js
// module People.js
const privates = new WeakMap(); // 闭包一个 weakmap 来存放所有实例的私有数据

function Person(name, age, money = 0, longevity = 80) {
  this.name = name;
  this.age = age;
  const me = {
    money,
    longevity,
  };
  privates.set(this, me); // 在这里将 this 作为 key 私有数据 me 作为值
  // this 上是访问不到私有数据的
}
// 定义一些操作私有数据的方法
Person.prototype.getMoney = function () {
  const me = privates.get(this);
  return me.money;
};
Person.prototype.die = function () {
  const me = privates.get(this);
  me.longevity = 0;
};
Person.prototype.buy = function (expense = 0) {
  const me = privates.get(this);
  if (me.money < expense) {
    return false;
  }
  return (me.money -= expense);
};

module.exports = Person;
```

```js
// 调用
const Person = require("./weak_map");
const p = new Person("JoJo", 18, 1500);

console.log(p); // Person { name: 'JoJo', age: 18 }
console.log(p.money); // undefined 不在 this 上
console.log(p.getMoney()); // 1500
console.log(p.buy(4444)); // false
```

TODO https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Keyed_collections

## ?? （nullish coalescing operator ES 2020）

和`||`可以做一个对比，用法相似

```js
let a = undefined ?? 123;
```

看名字，nullish 是指 `null`或者`undefined`，如果`??`左边的值为 nullish，则返回右边的值，否则直接返回左边的值

和 `||` 最大的区别是，`||`是判断左边的是否是`falsy`，

如果能快点加入标准，在很多场景下会比`||`好用的多，比如参数可以传 0 的时候。

配合下面的可选链

```js
const a = obj?.eee?.fff ?? "default"; // 如果没有取到值 当然也可以用 ||
```

**注意**，不能和`||`以及`&&`链式使用，要加个括号

```js
(null || undefined) ?? "foo"; // returns "foo"
```

## 可选链（ ES2020 ）

[optional chaining](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Optional_chaining)

我们之前要访问一个对象的属性的属性时，我们会先判读有没有第一个属性

```js
if (obj.p && obj.p.pp && obj.p.pp.ppp) {
  console.log(obj.p.pp.ppp.pppp);
}
```

或者我们会这样写：

```js
const res = obj.p
  ? obj.p.pp
    ? obj.p.pp.ppp
      ? obj.p.pp.pppp
      : undefined
    : undefined
  : undefined;
```

看到这样的代码就吐了....

用 optional chaining 语法之后，我们可以这样

```js
const res = obj.p?.pp?.ppp?.pppp; // obj?.p?....也是可以的
if (!res) {...}
```

### 语法

```javascript
obj.val?.prop;
obj.val?.[expr];
obj.arr?.[index];
obj.func?.(args);
```

可以少些很多判断了对不对！

如果某个属性是一个函数，也可以这样写，就只是`?.()`有点奇怪

```js
const obj = {
  a: 123,
  b: {
    c: "www",
  },
  d: {
    dd: {
      ddd: "dddd",
      dddd: () => {
        console.log(123123);
        return 123;
      },
    },
  },
};

const bb = obj.d?.dd?.dddd?.();
```

### 注意

- 如果在链中的一个属性不存在或者是 `null`，**就会直接停止，返回`undefined`**，如果最终的取值是 `null`，那么返回的值还是`null`，当然我们要确保目标对象本身是存在的哈。
- Optional chaining not valid on the left-hand side of an assignment：不能用它来作为左值来赋值！
- null v 和 undefined：当我们把`foo && foo.bar`替换为`foo?.bar`的时候，注意当`foo`的值为`null`的时候，第一个情况返回的是`null`，第二个返回的就是`undefined`

比较中的优先级问题：

```javascript
if (foo && foo.bar === baz) {
  /* ... */
}
// 等价于
if (foo && foo.bar === baz) {
  /* ... */
}
```

当`foo`为`null`的时候，表达式直接返回 false 了。

当我们改为

```javascript
if (foo?.bar === baz) {
  /* ... */
}
```

当`baz`为`undefined`的时候，此时的`foo`为`null`的时候，整个表达式是`true`！因为根据上面的规则，可选链返回的也是`undefined`了！这样就出了 bug！

当`===`改为`!==`的时候，更大的问题就来了：

```javascript
if (foo && foo.bar !== baz) {
  /* ... */
}
if (foo?.bar !== baz) {
  /* ... */
}
```

注意比较两者，如果 foo 是`null`，第二个可选链的情况就永远是`true`！

### 如何使用

**但是**目前还只是语法上可以这样写，运行需要 babel 的支持

```bash
npm install --save-dev @babel/plugin-syntax-optional-chaining
```

在`babel.config.json` or `.babelrc`中使用插件

```json
{
  "plugins": ["@babel/plugin-syntax-optional-chaining"]
}
```

或者直接在 CLI 使用

```bash
babel --plugins @babel/plugin-syntax-optional-chaining script.js
```

当然用 node 的 api 也可以

```js
require("@babel/core").transform("code", {
  plugins: ["@babel/plugin-syntax-optional-chaining"],
});
```

## async/await

### `async`

函数修饰符，让这个函数成为一个异步函数

**返回值是一个 Promise 对象**（因为是个异步函数了）

_是 promise 的语法糖_（可以改写**所有**的 Promise 写成 async/await）

#### 原理

直接用 `Promise.resolve()` 将函数体包住了，函数中的`return`的内容需要用`.then()`去接收处理。

> 详细可看[阮一峰](https://es6.ruanyifeng.com/#docs/async#async-%E5%87%BD%E6%95%B0%E7%9A%84%E5%AE%9E%E7%8E%B0%E5%8E%9F%E7%90%86)：将 Generator 函数和自动执行器，包装在一个函数里。

配合`await`使用能够将多个异步 Promise 写成同步的形式（只是代码写起来是）： Promise 都是用`.then()`去处理的，多个异步要顺序执行的时候，会出现`.then()`的疯狂嵌套，用`await`能够使得这些代码写起来是串行的。

这样就让代码可读性提高了，而且让代码不那么 nested ，变的 flat 了

### `await`

只能用在`async`函数中

- 等待一个 Promise 对象或者是其他值
- 等待 Promise 达到 fulfilled 的状态，将 resolve 的值赋值给左边
- 如果是 rejected 状态 则将 Promise 的异常抛出
- 如果不是 promise 则返回那个值
- 以上操作都会阻塞 async 函数，因为要 wait

### 例子

只要看到是返回 promise 的语句，都能在前面加上`await`

```js
function timeout(ms) {
  return new Promise((resolve) => {
    setTimeout(() => {
      resolve(ms);
    }, ms);
  });
}

async function aPrint(value, ms) {
  await timeout(ms);
  console.log(value);
  return ms;
}

const res = aPrint(1000, 2000).then((value) => console.log(`timeout ${value}`));
console.log(res); // 这是个 Promise 会先打印
```

### 踩坑

来看看上面的`console.log`为什么会先打印，可见`async`不是同步方法！一旦遇到`await`之后就会将后面的所有语句放到`resolve`的回调！（写起来是给左值）

也可以理解为

```js
async function aPrint(value, ms) {
  timeout(ms).then((v) => {
    console.log(value);
  });
}
```

所以`await`的实质还是放到微任务队列去做了后续的操作。。。

### Tips

- 在`async`函数中别忘了用`await`

- 不需要使用`await`的时候

  ```js
  async function asyncFunc() {
    const writer = openFile("someFile.txt");
    writer.write("hello");
    writer.write("world");
    await writer.close(); // wait for file to close
    //return writer.close();
  }
  ```

- `await`顺序执行，会阻塞，`Promise.all()`让操作并行，如果在**不考虑执行顺序**的情况，可以加快速度

```js
async function foo() {
  const [result1, result2] = await Promise.all([asyncFunc1(), asyncFunc2()]);
}
```

- 回调的时候使用异步函数

  ```js
  const arr = ["123", "sdaf", "dfaf", "dasf"];
  // 假设发送到服务器做逆序的处理 是异步操作 有没有 await 也不影响
  const reverseAsync = async (value) => value.split("").reverse().join("");
  const reverse = (value) => value.split("").reverse().join("");
  // 非异步函数
  console.log(arr.map(reverse));
  ```

  如果用 `async` 函数作为回调，注意最初描述的 async 返回的都是 promise

  ```js
  console.log(arr.map(reverseAsync));
  // 是一个 Promise 的数组..
  ```

  怎么办呢？都是 Promise 的数组。。想到了什么？ `Promise.all` ！

  ```js
  // 用一个async函数包起来
  async function reverseArr(arr) {
    return await Promise.all(arr.map(reverseAsync));
  }

  reverseArr(arr).then(console.log);
  ```

  概括一下这种情况：数组的每个元素都要经过异步处理，结果要放回数组

  接着可以优化一下代码，反正返回值都是 Promise 嘛，`await` 都可以不用了，直接将 `Promise.all`返回给`.then()`，一行就搞定了，就是可读性不高

  ```js
  const reverseArrayAsync = async (arr) => Promise.all(arr.map(reverseAsync));
  ```

- 异步函数中的`forEach`遍历改成`for ... of`会更好

## 异步迭代器

为什么要迭代器？本质上也是一种遍历数据的方式，让每次迭代得到的数据被“造”出来，而不是预先都造好放在内存里。但有些时候我们需要一些异步操作来得到结果，基础的便利迭代器`next`方法得到的都是同步的结果，所以在 ES2018 引入了异步迭代器接口。

### Symbol.asyncIterator

一个对象的迭代器接口是用`Symbol.iterator`来实现，那么异步的迭代器接口就是用`Symbol.asyncIterator`来实现，其中的`next`方法返回的是一个用 Promise 包装起来的结果。

所以我们可以在每个迭代器的`next`结果通过`.then`注册回调来处理 value，同时在回调中可以返回迭代器的下一个`next`，来链式调用！

```javascript
asyncIterator
  .next()
  .then((iterResult1) => {
    console.log(iterResult1); // { value: 'a', done: false }
    return asyncIterator.next();
  })
  .then((iterResult2) => {
    console.log(iterResult2); // { value: 'b', done: false }
    return asyncIterator.next();
  })
  .then((iterResult3) => {
    console.log(iterResult3); // { value: undefined, done: true }
  });
```

也可以用`await`来写成同步语句，但注意要放在`async`函数中

```javascript
async function f() {
  const asyncIterable = createAsyncIterable(["a", "b"]);
  const asyncIterator = asyncIterable[Symbol.asyncIterator]();
  console.log(await asyncIterator.next());
  // { value: 'a', done: false }
  console.log(await asyncIterator.next());
  // { value: 'b', done: false }
  console.log(await asyncIterator.next());
  // { value: undefined, done: true }
}
```

同样也可以放在一个数组中，最后用`Promise.all`来处理

接着我们可以看一下`for await ... of`，专门引入来处理异步迭代器的

### for await ... of

和`for ... of`最大的不同就是，它是对`Symbol.asyncIterator`来迭代的，并且需要在`async`函数中。

同时，迭代获得的值也是`value`

```javascript
const asyncIter = {
  // 这个 asyncIterator 只能给 for await of 这个 异步迭代接口来用
  [Symbol.asyncIterator]: () => {
    const items = [11, 12, 13, 14, 15];
    return {
      next() {
        return Promise.resolve({
          done: 0 === items.length,
          value: items.shift(),
        });
      },
    };
  },
  [Symbol.iterator]() {
    const N = 5;
    let id = 0;
    return {
      next() {
        return {
          done: id === N,
          value: id++,
        };
      },
    };
  },
};
// for await of
(async function () {
  for await (const s of asyncIter) {
    console.log(s);
  }
})(); // 11 12 13 14 15
```

在迭代器被 reject 的错误会被当作是 unhandled error 被抛出，所以在`for`的外层最好加一个`try catch`

同样也是可以迭代非异步迭代器的！

P.S.那么我们什么时候会用到它呢？不知道。。。遇到再看看吧

## 箭头函数

```js
const foo = (a) => console.log(a);
```

(形参列表)`=>`箭头 {函数体}

- **将调用时的上下文作为函数体的调用上下文**
- 箭头函数不会生成自己的`this` `arguments` `super` `new.target`关键字
- 更适合作为匿名函数
- 函数体只有一行的话可以省略花括号，作为 return 的值

### 更短的函数表达式

举几个例子看吧

```js
let uesa = ["aefjf", "aefjsdf", "aefjf1q", "aefjf1qq34"];
console.log(uesa.map(({ length: len }) => len));
console.log(uesa.map(({ length }) => length));
```

支持解构，默认值，括号包裹函数体(parenthesize)，**如果写在一行的时候需要返回对象，用`()`包裹起来**

```js
// 摘自MDN
// Parenthesize the body of a function to return an object literal expression:
params => ({foo: bar})

// Rest parameters and default parameters are supported
(param1, param2, ...rest) => { statements }
(param1 = defaultValue1, param2, …, paramN = defaultValueN) => {
statements }

// Destructuring within the parameter list is also supported
var f = ([a, b] = [1, 2], {x: c} = {x: a + b}) => a + b + c;
f(); // 6
```

### 箭头函数的 this

会找上下文中闭包的的 this，遵循 look up

### 通过 call，apply 调用

- 只能传递参数

- 第一个参数作为**this 会被忽略！**

  - 看个例子

    ```js
    let a = {
      x: 0,

      add: function (y) {
        let f = (v) => v + this.x;
        return f(y);
      },

      addCall: function (y) {
        let f = (v) => v + this.x;
        const b = {
          x: 123123,
        };
        // 希望f在b上下文中调用
        return f.call(b, y);
      },
    };
    console.log(a.add(10)); // 10
    console.log(a.addCall(10)); // 10
    ```

  - 可见箭头函数在用 call 调用的时候传入的第一个参数不影响 this，this 是在调用的时候直接找上下文

### 解析顺序

箭头=>不是一个操作符！有特殊的解析规则

```js
let callback;

callback = callback || function() {}; // ok

callback = callback || () => {};
// SyntaxError: invalid arrow-function arguments

callback = callback || (() => {});    // ok
```

### 箭头函数不能乱用哦

#### 构造函数不能是 arrow

学 oop 的时候就发现了，问题很大，直接报错了

#### 对象的方法不能

对象调用方法的时候，如果是箭头函数，方法中的 this 是调用时所在的上下文，而不是该对象

```js
let ew = {
  name: "eeee",
  f: () => console.log(this.name),
};
ew.f(); // undefined
```

如果实在不想用`function`那就用 ES6 的新定义方法

```js
let ew = {
  name: "eeee",
  f() {
    console.log(this.name);
  },
};
ew.f(); // eeee
```

#### 事件的 callback

```html
<input id="btn" type="button" value="click" />
<script>
  let btn = document.getElementById("btn");
  // btn.addEventListener('click', () => {
  //     console.log(this === window)
  //     this.value = 'xxxx'
  // })
  btn.addEventListener("click", function () {
    console.log(this === window);
    this.value = "xxxx";
  });
</script>
```

注释的部分使用了箭头函数写这个 callback，事件监听的回调都是异步操作的回调，放在 task queue 中的，等到事件触发的时候才放到主线程，此时的调用上下文是全局！所以在箭头函数中的 this 是找到了 window

##### Use of `prototype` property

Arrow functions do not have a `prototype` property.

```js
var Foo = () => {};
console.log(Foo.prototype); // undefined
```

## 解构...(deconstructing)

### 用作函数参数的剩余部分

```js
function sum(...theArgs) {
  return theArgs.reduce((previous, current) => {
    return previous + current;
  });
}
```

函数形参的最后一个可以用`...`来前缀修饰(?)，来囊括剩下的所有参数，~~**注意类型不是数组，但是打印出来是数组，那就是个 ArrayLike 的对象**，能用 reduce 函数我想是因为底层实现调用了 Array.prototype.reduce 的 apply/call 吧~~

好的刚刚犯二了，用`typeof`去检查类型，清一色`object`，改用~~`instanceof`~~`Array.isArray()`去判断，是 Array，没错，是的，长记性啊。

普通数的`arguments`是个 ArrayLike 的对象。

### 解构赋值

看例子吧

```js
let a, b, rest;
[a, b] = [10, 20];
[a, b, ...rest] = [10, 20, 30, 40, 50];

({ a, b } = { a: 10, b: 20 });

({ a, b, ...rest } = { a: 10, b: 20, c: 30, d: 40 });
```

默认值

```js
let a, b;

[a = 5, b = 7] = [1];
console.log(a); // 1
console.log(b); // 7
```

交换变量，哦哟和 python 有点像了

```js
let ei = 12;
let we = 13; // 有一个小坑 这里分号一定要加 不然解析报错
[ei, we] = [we, ei];
```

```js
const [ae, ...es] = [1, 2, 3, 4, 5];
```

对象解构，直接获取属性和值，import 的时候也很好用，也可以给默认值

```js
const o = { p: 42, q: true };
const { p, q } = o;

console.log(p); // 42
console.log(q); // true
// const {p: foo, q: bar} = o;
```

解构对象的覆盖顺序，**后面的对象有重复属性会覆盖前者**

```js
const ob = { a: 123, b: 223 };
const oc = { a: 333, d: 3123 };
e = { ...ob, ...oc };
// { a: 333, b: 223, d: 3123 }
e = { ...ob, ...oc };
// { a: 333, b: 223, d: 3123 }
e = { ...oc, ...ob };
// { a: 123, d: 3123, b: 223 }
```

函数参数解构的默认值

```js
function f({ a = 123, b, c = "ccc" } = { b: 33 }) {}
```

在迭代里面巧用解构

```js
arr.forEach({name, age} => {...})
```

可以给结构出的原始属性赋给新的变量：

```js
arr.forEach({name: n, age: a} => {...})
```

此时原来的 name 和 age 都不能用了

## 函数参数的默认值

不知道是不是 ES6 新增啊。。

```js
function add(a, b = 1) {
  return a + b;
}
```

- 本身如果不给 function 传递参数，那么调用的时候就是 undefined

- 如果给默认值参数赋值 undefined，默认值还是会起作用的

- 传递其他假值(falsy)的时候上一条不生效

  - 看看什么是 falsy 吧，就是 false 值的字面量
  - `false` `0` `-0` `0n` `''` `null` `undefined` `NaN`

- 默认值在调用的时候创建，不会发生类似闭包的情况

  - 所以默认值完全可以是一个定义过的函数

  - 看个例子

    ```js
    let count = 0;
    const ff = (value = counter()) => console.log(value);
    const counter = () => count++;
    ff();
    ff();
    ff();
    ff(); // 0 1 2 3
    ```

- 默认值左边的参数都可以被调用

  ```js
  const hello = (name, greet = "hello " + name) => greet;
  console.log(hello("jjjjsss"));
  console.log(hello("jjjjsss", "jjjjjj"));
  // hello jjjjsss
  // jjjjjj
  ```

- 可以用解构赋值

## 迭代器 & for ... of

### 迭代器

是一种接口，为不同的数据结构提供统一的访问机制，任何类型只要部署了`Iterator`接口，就可以完成遍历

ES6 提供了`for...of`来遍历迭代器，其实和 python 的 for 循环是一样的，C++ 也有的，内部是一个指针遍历

具备迭代器的数据结构：

- Array
- arguments
- Set
- Map
- String
- TypedArray
- NodeList

其实说到迭代器，会想到生成器（python），会用`next`函数来消费下一个元素

在 js 中也是一样，`next`函数返回一个人对象包含`value:any`和`done:Boolean`

我们可以通过`Symbol.iterator`来得到对象的迭代器

```js
let arr = ["a", "d", "e"];

let iterator = arr[Symbol.iterator]();
console.log(iterator.next()); // { value: 'a', done: false }
console.log(iterator.next()); // { value: 'b', done: false }
console.log(iterator.next()); // { value: 'e', done: false }
console.log(iterator.next()); // { value: undefined, done: false }
```

迭代器能干嘛？可以自定义迭代的顺序

### for ... of

遍历的是对象的迭代器

```js
for (let v of { a: 123, b: 223 }) {
}
```

这样是会报错的，`Object`不是可迭代对象

我们需要构造一个自定义的迭代器

```js
const fyi = {
  to: "JoJo",
  info: ["olaolaola", "hhhhhh", "yeyeyeyeye", "mudamudamuda"],
  [Symbol.iterator]() {
    // 在这里定义一个
    let index = 0;
    const that = this; // 当然下面的 next 也可以写成 箭头函数
    return {
      next() {
        return { value: that.info[index++], done: index > that.info.length };
      },
    };
  },
};
for (let v of fyi) {
  console.log(v);
}
// olaolaola
// hhhhhh
// yeyeyeyeye
// mudamudamuda
```

直到`next()`返回了`{value: undefined, done: true}`才停止

试着自己实现了一个不能`break`的`for..of`

```js
function forOf(iterable, fn) {
  if (!iterable[Symbol.iterator] || !iterable[Symbol.iterator]()) {
    throw new Error("not iterable!");
  }
  const iterator = iterable[Symbol.iterator]();
  let iterVal = iterator.next();
  while (!iterVal.done) {
    fn(iterVal.value);
    iterVal = iterator.next();
  }
}

forOf([1, 2, 3], (v) => {
  console.log(v);
});
```

当然了。。babel 不是这样做的！是直接将那一部分都转为 for 循环，直接可以 break

## 生成器

Generator，很简单。。就是 python

在 js 中是一个异步编程的解决方案！但是现在有`async/await`语法糖了

### 语法

```js
function* gen(doneMsg) {
  yield 123;
  yield 333;
  let x = yield 233;
  console.log(doneMsg + x);
}
let iter = gen("yes");
// 返回一个迭代器对象
iter.next();
iter.next();
iter.next();
iter.next("!!!"); // 作为最后一个 yield 的返回值
// 1
// 2
// 3
// yes!!!
```

每次调用`next()`就会返回下一个`yield`，哎呀和 python 一样，但是可以 `yield* iterable`

```javascript
let generator = function* () {
  yield 1;
  yield* [2, 3, 4];
  yield 5;
};

let iterator = generator();

iterator.next(); // { value: 1, done: false }
iterator.next(); // { value: 2, done: false }
iterator.next(); // { value: 3, done: false }
iterator.next(); // { value: 4, done: false }
iterator.next(); // { value: 5, done: false }
iterator.next(); // { value: undefined, done: true }
```

### 解决回调地狱

```js
// 解决异步编程 回调地狱
function userData(id) {
  setTimeout(() => {
    let user = id + "-JoJo";
    iterator.next(user); // 执行下一步！
  }, 1000);
}

function schoolData(user) {
  setTimeout(() => {
    let school = user + "-Dio";
    iterator.next(school);
  }, 1000);
}

function feeData(school) {
  setTimeout(() => {
    let fee = school + "fee: " + 400000;
    iterator.next(fee);
  }, 1000);
}
// 这些数据都是有先后依赖关系的
// userData()
// schoolData()
// feeData()

// 业务逻辑处理在这里 让异步写的和同步一样
function* getUserTuitionFee(id) {
  const user = yield userData(id);
  console.log(user);
  const school = yield schoolData(user);
  console.log(school);
  const fee = yield feeData(school);
  console.log(fee);
}

const iterator = getUserTuitionFee(1);
iterator.next();
// 分别间隔 1s 输出
// 1-JoJo
// 1-JoJo-Dio
// 1-JoJo-Diofee: 400000
```

### 部署迭代器接口

生成器也是用`next`方法发现吗！所以可以用它包装迭代器

```js
function* iterEntries(obj) {
  let keys = Object.keys(obj);
  for (let i = 0; i < keys.length; i++) {
    let key = keys[i];
    yield [key, obj[key]];
  }
}

let myObj = { foo: 3, bar: 7 };

for (let [key, value] of iterEntries(myObj)) {
  console.log(key, value);
}
```

```js
function* genN(n) {
  for (let i = 0; i < n; ++i) {
    console.log("gen " + i);
    yield { id: i };
  }
}

for (let { id } of genN(10)) {
  console.log(id);
}
```
