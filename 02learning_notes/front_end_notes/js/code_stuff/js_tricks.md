记得看https://www.30secondsofcode.org/js/p/1

[toc]

### `void 0`?

> 起源于 [div.js](https://github.com/willmartindev/div.js) 这个库的源码（能用 `<div is="p">` 来全用 div 写 html 哈哈哈。
>
> 里面看到了熟悉又陌生的 `void 0` 用法，于是谷歌了一下 why

参考[博客](https://www.cnblogs.com/fsjohnhuang/p/4146506.html)

起因：`undefined` 不是 JS 的关键字/保留字，所以是可以对他进行赋值的（`null` 就不能作为左值）！不同浏览器（低版本 IE）可能会对 undefined 变量的取值行为不同

所以，`void` 操作符就是 ecma 提出获得纯正 `undefined` 的。

#### `void` 行为

- 返回纯正的 `undefined`
- 并且对右边的 expression 进行 eval，如果变量有 getter 会执行，**有可能会产生副作用**

#### 其他纯正 undefined

- 未定义的变量/形参

  ```js
  const getUndefined = (u) => u;
  ```

- 没有返回值的函数

- 未定义的属性

_说实话不去谷歌一下，真看不懂 `void 0`。。_

### 对象属性的懒加载计算

> 来自[这篇文章](https://humanwhocodes.com/blog/2021/04/lazy-loading-property-pattern-javascript/)
>
> 对于一些属性值需要复杂计算，可以在第一次需要访问这个属性的时候再进行计算并进行缓存，是一个比较经典的懒加载模型

比如下面的 `data` 属性需要一些复杂计算才能得到

```js
class MyClass {
  constructor() {
    this.data = someExpensiveComputation();
  }
}
```

首先可以用 getter 去解决第一次获取才计算。然后问题是如何缓存，当然可以用另一个类属性去记录和判断（当然我第一直觉是这么想的，但是不够优雅）。

文中提出的方法是用 `Object.defineProperty`，又是这个神器，能够对原本的 getter 进行重新定义为属性，缓存计算之后的值。

直接看代码吧

**Class 的**，为什么在构造函数就先 define 呢，因为 getter 在 class 是不可枚举的，不是实例的 property

```js
class MyClass {
  constructor() {
    Object.defineProperty(this, "data", {
      get() {
        const actualData = someExpensiveComputation();

        Object.defineProperty(this, "data", {
          value: actualData,
          writable: false,
          configurable: false,
        });

        return actualData;
      },
      configurable: true,
      enumerable: true,
    });
  }
}
```

**Object 的**，比较简单，getter 是可枚举的

```js
const object = {
  get data() {
    const actualData = someExpensiveComputation();

    Object.defineProperty(this, "data", {
      value: actualData,
      writable: false,
      configurable: false,
      enumerable: false,
    });

    return actualData;
  },
};
```

_复习一下，属性的 configurable：不可被删除_

P.S. 到这里其实感觉有个 bug，如果这个复杂计算的函数是个动态的类方法，懒加载和缓存应该就没那么简单了，还需要对依赖进行收集和监听，好吧，那就是 vue 干的事情了。。只要给对应的 setter 函数中加上对需要计算的属性的 `defineProperty` 操作就行了！

### 取整

#### 向下取整

```js
n >>> 0;
~~n;
```

### 生成 1-10 的数组

一定要 fill，不然都是空 item ，不会被高阶函数遍历到的（红宝书写过）

```js
const a = Array(10)
  .fill("any")
  .map((v, i) => i + 1);
```

### 生成 0-n 的数组

```js
let n = 10;
const a = Array.from(Array(n).keys());
```

wow，很炫

```js
const aa = [...Array(n).keys()];
```

这个更加简洁！

### range()

```js
const range = (start, end) =>
  Array.from({ length: end - start }, (_, i) => start + i);
```

当然也可以直接 map 成你想要的东西

### 逆序字符串

~~split 成数组~~用 `Array.from` 转换为数组， reverse 之后再 join 起来

```js
const reverseStr = (value) => Array.from(value).reverse().join("");
```

### 数组添加尾部元素的方法

- `arr[arr.length] = 'tail'`，长度重新计算，最后 index+1

### Array.fill() 共享内存

想构造二维数组，结果用 fill 发现共享内存...踩坑（这里仅是引用类型会共享）

```js
const dp = Array(lenB).fill(Array(lenA));
```

正确的方法可以

TODO dp 算法那篇

### Math.floor() 用 >> 0

右移 0 可以实现向下取整

### JSON.stringify()

#### 乞丐版深拷贝

```js
let a = { m: 3, k: { jj: 123, oo: 321 } };
let b = JSON.parse(JSON.stringify(a));
```

当然对于这样仅包含对象的情况来说足够了

对于拷贝其他引用类型、拷贝函数、循环引用等情况，就需要手动递归

#### 判断两个对象是否相等（有同样的属性）

```js
let a = [1, 2, 3];
let b = [1, 2, 3];
JSON.stringify(a) === JSON.stringify(b);
```

#### 判读一个对象的属性是否在另一个对象中

都 stringify 成字符串之后用 indexOf 看下标即可

#### webStorage 存储对象

stringify 之后存在 localStorage/sessionStorage

#### 按照指定 key 的顺序

> [参考](https://stackoverflow.com/questions/16167581/sort-object-properties-and-json-stringify)
>
> 默认的顺序就是对象定义的时候的顺序？

```js
JSON.stringify(sortMyObj, Object.keys(sortMyObj).sort());
```

在第二个参数指定 key 的数组就行

### 类型判断

```js
Object.prototype.toString.call(element).slice(8, -1) === "Array";
```

回忆：

- typeof：对基本类型的判断
- instanceof：检查原型链上的原型是否是目标构造函数的原型

### flat

#### 最简单版本

```js
let a = [1, 2, 3, [4, 5, 6], [4, 5, 6, [4, 5, 6], [4, 5, 6]]];

const flatten = (arr) => {
  const res = [];
  arr.forEach((v) => {
    if (Array.isArray(v)) {
      res.push(...flatten(v));
    } else {
      res.push(v);
    }
  });
  return res;
};

console.log(flatten(a));
```

#### polyfill 版本

```js
Array.prototype.myFlat = function (num = 1) {
  if (!Array.isArray(this)) {
    return;
  }
  const result = [];
  this.forEach((item) => {
    if (Array.isArray(item)) {
      if (num <= 0) {
        result.push(item);
        return result; // 后面不走了 进入下一次循环
      }
      result.push(...item.myFlat(num - 1));
    } else {
      result.push(item);
    }
  });
  return result;
};
```

网上找的，我记得我也写过，但找不到了。。。

### console

#### console.table

当遇到 array of objects 的时候很好用（node 命令行也支持）

```js
const foo = { name: "Suibin", age: 30, coder: true };
const bar = { name: "Borja", age: 40, coder: true };
const baz = { name: "Paul", age: 50, coder: false };
console.table([foo, bar, baz]);
```

#### console.log with ‘%’ sign 定制 CSS 样式

浏览器中有效。。node 没有 CSS

用`%c`

```js
console.log("%cfirst: ", "color: MidnightBlue; background: Aquamarine;", first);

console.log("%cStyled log", "color: orange; font-weight: bold;");
console.log("Normal log");
```

#### 多个对象可以放到一个`{}`里 log

```js
const foo = { name: "Suibin", age: 30, coder: true };
const bar = { name: "Borja", age: 40, coder: true };
const baz = { name: "Paul", age: 50, coder: false };
console.log({ foo, bar, baz });
```

这样可以看的更加清楚变量了...

### 解构赋值剩余属性

用 `...X` 来获取没有被解构的对象

```javascript
let a = { k: 12, e: 3, rr: 33, es: 13 };
let { k, ...restData } = a;
// > k
// 12
// > restData
// { e: 3, rr: 33, es: 13 }
```
