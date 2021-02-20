记得看https://www.30secondsofcode.org/js/p/1

[toc]

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

#### webStroag 存储对象

stringify 之后存在 localStorage/sessionStorage

### 深拷贝

一个比较完整的深拷贝函数，需要同时考虑对象和数组，考虑循环引用：

```js
function deepCopy(obj, map = new WeakMap()) {
  if (typeof obj === "object") {
    const newObj = Array.isArray(obj) ? [] : {};
    if (map.has(obj)) {
      // 如果这个对象已经被引用了 有循环引用 直接返回
      return map.get(obj);
    }
    map.set(obj, newObj);
    for (let key in obj) {
      newObj[key] = deepCopy(obj[key], map);
    }
    return newObj;
  } else {
    return obj; // 不是引用类型的直接返回一份 因为形参已经是 copy 了
  }
}
// 测试一下
let aa = {
  abc: 123,
  bbc: { ddd: 433 },
};
aa.eee = aa;
let bb = deepCopy(aa);
aa.eee = 444444;
bb.bbc.ddd = 4444;
console.log(bb.eee);
console.log(aa.eee);
```

### 浅拷贝

```js
let copy = Object.assign({}, obj);
```

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
