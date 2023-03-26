# 原型链

> Javascript 修炼之路必须越过的一座大山
>
> - 理解 JS 面向对象
> - 理解 `prototype` 和 `__proto__`；
> - 理解原型链和原型继承；

## 普通对象 & 函数对象

```javascript
function fn1() {}
const fn2 = function () {};
const fn3 = new Function("language", "console.log(language)");
// fn1 fn2 fn3 都是函数对象 可以通过 typeof 查看

const ob1 = {};
const ob2 = new Object();
const ob3 = new fn1();
// ob1 ob2 ob3 都是普通对象
```

**所有 Function 的实例都是函数对象，而其他的都是普通对象。**

普通对象也可以通过任何的函数对象实例化（`new`）生成

## `prototype` & `__proto__`

| 对象类型 | `prototype` | `__proto__` |
| -------- | ----------- | ----------- |
| 普通对象 | ×           | √           |
| 函数对象 | √           | √           |

结论：

- 只有函数对象具有 prototype 属性
- `prototype` 和 `__proto__` 都是 JavaScript 在定义一个函数或对象时自动创建的预定义属性（自带的）
- `prototype` 被实例的 `__proto__` 所指向（构造器视角）
- `__proto__` 指向构造器的 `prototype`（实例视角）

所以也就是说

```javascript
function fn() {}
const ob = {};
fn.__proto__ === Function.prototype; // true
ob.__proto__ === Object.prototype; // true
```

那么问题来了：既然 fn 是一个函数对象，那么 `fn.prototype.__proto__` 到底等于什么？

```javascript
console.log(fn.prototype.__proto__ === Object.prototype); // true
```

上面所说，函数对象的 `prototype` 是在创建时自动生成的，所以我们可以猜测：

```javascript
// 实际代码
function fn1() {}

// JavaScript 自动执行
fn1.prototype = {
  constructor: fn1,
  __proto__: Object.prototype,
};

fn1.__proto__ = Function.prototype;
```

普通对象为什么没有 `prototype`，因为他不可能再次作为一个普通对象的构造器，也没有实例的 `__proto__` 指向他的 `prototype`。

同样，`Function` 也是 `Function` 的实例

```javascript
Function.__proto__ === Function.prototype; // true
```

## 原型链

_同时可以带着这个问题“为什么只有函数对象有 `prototype`？”_

上面讲解的 `prototype` 和 `__proto__` 主要就是为了构造原型链

```javascript
const Person = function (name, age) {
  this.name = name;
  this.age = age;
};

Person.prototype.getName = function () {
  return this.name;
};

const coyote = new Person("coyote", 24);

console.log(coyote);
console.log(coyote.getName());
```

可以通过打印看到 `coyote` 实际上只有 `age` 和 `name` 这两个 “own property”，那么 `getName` 是怎么调用成功的？

- 会向上查找 `__proto__`，找到 `Person.prototype` 那他有 `getName` 方法，于是调用成功

所以在访问**对象**某个属性/方法时，在当前对象找不到时，就会不断的访问 `__proto__` 查找，直到找不到为止（返回 `undefined`）

```javascript
coyote["something"];
coyote.__proto__;
coyote.__proto__["something"];
coyote.__proto__.proto__;
coyote.__proto__.__proto__["something"];
coyote.__proto__.proto__.__proto__; // null 停止
```

万物皆空——原型链的终点，`Object.prototype.__proto__` -> `null`

检验下理解程度

**以下代码的输出结果是？**

```js
console.log(coyote.__proto__ === Function.prototype);
```

- _false_

**`Person.__proto__` 和 `Person.prototype.__proto__` 分别指向何处？**

- 首先 Person 是函数对象，他的 `__proto__` 指向 `Function.prototype`
- `Person.prototype` 是普通对象，他的 `__proto__` 指向 `Object.prototype`

`prototype` 中的 `constructor` 指向构造器自己（循环引用）

为什么只有函数对象有 `prototype`？

- 函数对象可以作为普通对象的**构造器**，而实例化之后的对象需要通过 `__proto__` 去链式访问查找属性

## 小结

对象属性的访问，会通过原型链向上查找，JS 中原型链的入口通常是 `__proto__`（当然也可以是其他属性名，只是一种约定），指向构造器（OOP 中 Class）的样子（`prototype`），最终会找到 `Object.prototype.__proto__` 就到终点了。

### 题外话

`instanceOf(obj, Constr)` 的原理？一路从 `obj.__proto__` 向上找有没有指向 `Constr.prototype`

`Object.create` 生成出来的对象的原型链？对象的 `__proto__` 指向的就是 create 接受的参数对象

中断一个实例的继承？修改 `coyote.__proto__ = null`（瞎搞可以，没事别瞎搞）

## 参考

https://zhuanlan.zhihu.com/p/34481749
