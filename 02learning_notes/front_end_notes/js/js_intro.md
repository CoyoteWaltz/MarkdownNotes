## 基础类型

### 基础类型

Boolean

String

Number

Symbol

Bigint

Object

undefined（表示缺少值，还没有定义）

null（和上面一个的区别，可以看[阮一峰](https://www.ruanyifeng.com/blog/2014/03/undefined-vs-null.html)，表示没有对象，无值）

### typeof

用 typeof 可以最直接的检测类型，**但不是类 class**

- undefined
- boolean
- string
- number: 一切数值类型，包括`NaN`，`NaN === NaN // false`
- object: 一切的`Object`或者`null`，`null`被认为是一个空的对象引用，就相当于是空指针的意思了
- function
- **最后两种是引用类型，其余都是按值访问**

### 数值转换

`parseInt(' 123dsf') => 123`

`parseInt('wefsda123dsf') => NaN`

- Number(): 转为数值类型
- parseInt(): 忽略
- parseFloat()

### 位操作

- 取反~
- 与&
- 或|
- 异或^
- 左右移位<<>>(有符号)
- 无符号右移>>>
  - 负数的二进制前面的位置都由符号位填充
  - 无符号右移的时候不再用符号填充了，而直接把所有位都右移
  - `-64 >>> 5 === 134217726`

### 逻辑运算

#### （两个）逻辑非!

用于转换 falsy 成为 false

`!!undefined === false`

`!!null === false`

`!!'' === false`

...

#### 逻辑与&&

两边不仅可以是布尔类型的，依旧短路机制

- 若第一个是 Object，返回第二个操作数
- 若第二个是 Object，只有第一个表达式为`true`才返回第二个
- 若都是对象，返回第二个
- 有`null`就返回`null`，同理`NaN`和`undefined`

总之就是短路原则，falsy 都是 false，Object 都是非空指针

可以这样用`obj = <expression> && obj`

#### 逻辑或||

同样不一定都要是 Boolean

- 若第一个是 Object，返回第一个
- 若第一个求出 false，返回第二个
- 都是 Object，返回第一个
- 都是`null`就返回`null`，同理`NaN`和`undefined`

判断参数是否为空的时候也很好用！

#### 关系操作符

对象比较的时候，先调用`valueOf`方法转换成值，如果没有，就调用`toString`转为字符串比较。

```js
const a = {
  aa: 123,
  valueOf() {
    return this.aa;
  },
};
const b = {
  aa: 232,
  valueOf() {
    return this.aa;
  },
};
const c = {
  toString() {
    return "cccc";
  },
};
const d = {
  toString() {
    return "cccd";
  },
};
console.log(b < a); // false
console.log(c < d); // true
```

#### with 语句

`with (object) statement;`

将语句的作用上下文设置为 with 中的对象。

**strict mode 下不允许使用 with 语句**

### 最大整型

场景重现：后端传的 room_id 是 number 类型，但是太大了。。有多大呢？比 `Number.MAX_SAFE_INTEGER`（9007199254740991）都大。。。（2 的 53 次方 - 1），其他语言都默认是 64 位嘛

所以让 sever 传 string 类型了。以后记得要避免坑！

```JavaScript
> JSON.parse(6887505956205890304)

6887505956205891000  // 吞了后三位。。
```

可以看这篇：https://stackoverflow.com/questions/307179/what-is-javascripts-highest-integer-value-that-a-number-can-go-to-without-losin 和 https://www.zhihu.com/question/29010688

## 内存

### 堆栈

所有的变量都是在栈空间的 reference

对象的引用（指针）指向堆内存

### 参数传递都是引用

```js
const o = {};
const foo = function (obj) {
  obj.name = "eeeee";
  obj = new Object(); // 仅是函数内部的形参改变指向
  // obj = {}
  obj.name = "new";
};
foo(o);
console.log(o.name); // eeeee
```

熟悉 python 或者 c++的就很好理解

### 垃圾收集(garbage collection)

不用像 C/C++一样 new 了一个新对象还要 delete 这样去管理内存。

找出不用的变量，释放他的内存。周期性的做垃圾收集工作。

#### 引用计数

学 C++的时候仿写 String 类就用的引用计数方式，垃圾回收也差不多，当对象被引用的时候计数器就++，每次 GC 的时候将计数器为 0 的对象释放。

但是，循环引用的时候就 gg 了。

```js
const a = {};
const b = {};
a.b = b;
b.a = a;
```

#### 标记清楚

从根对象开始标记所有被引用的对象，gc 的过程中释放没有被标记对象的内存。

详细的看[这篇](https://www.jianshu.com/p/a8a04fd00c3c)讲了几种 gc 的算法。

#### 性能问题

浏览器选择合适的时机触发 gc。

不用的对象通过赋值`null`解除引用，等待离开环境的时候被回收。

## 对象

### 数据属性

- Configurable
  - 是否能够通过 delete 删除属性从而重新定义，默认 true
- Enumerable
  - 一开始不懂这个可枚举，直观来看就是能被`for in`循环和`Object.keys`返回的属性名，默认 true
- Writable 是否可写，默认 true
- Value 属性的数据值，写入的时候保存在此，默认是 undefined

### Object.values

没想到，真的有这个接口来获取一个对象的所有值，返回一个数组

但是`Reflect`没有这个 API。。

### Object.assign

```js
Object.assign(target, ..source)
```

将一个或者多个源对象的**可枚举**属性复制到目标属性

多个重复属性的时候，在参数列表后面的对象属性会覆盖前面的属性

### Object.freeze

冻结一个对象，这个 object 的所有属性都不能修改、删除和增加（defineProperty 会报错 TypeError）

让这个对象 **immutable** ! 返回原对象的引用

```js
let a = { ee: 123 };
let b = Object.freeze(a);
a.ee = "12"; // 不会改变什么 sliently do nothing 严格模式下会报错
// b === a
```

用 `Object.isFrozen` 来判断对象是否被冻结了

ES5 如果冻结一个非 object 会报错，ES6 之后不会（In ES2015, a non-object argument will be treated as if it were a frozen ordinary object, and be simply returned.）

```js
Object.freeze(1);
// TypeError: 1 is not an object // ES5 code

Object.freeze(1);
// 1                             // ES2015 code
```

#### shallow freeze

注意：只是让对象的属性变成了 const 指向，但如果属性指向对象（嵌套），那么只是 reference 是不可变的，所以 freeze 也是**浅冻结**

> To be a constant object, the entire reference graph (direct and indirect references to other objects) must reference only immutable frozen objects. The object being frozen is said to be immutable because the entire object _state_ (values and references to other objects) within the whole object is fixed. **Note that strings, numbers, and booleans are always immutable and that Functions and Arrays are objects.**

需要写一个 deepFreeze 来递归的冻结每个属性

```js
function deepFreeze(obj) {
  const props = Object.getOwnPropertyNames(obj);

  for (const prop of props) {
    const value = obj[prop];
    if (value && typeof value === "object") {
      // value 指向某个 object
      deepFreeze(value);
    }
  }

  return Object.freeze(obj);
}
```

#### 区别

和 `Object.seal` 的区别在于 freeze 让 obj immutable 了（浅的），seal 只是封住固定（fixed）这个 obj。

#### 实现

- 可以先 Object.seal 一下，然后遍历所有 prop，重新 Object.defineProperty 设置为`writable: false, configurable: false`
- 也可以用 Proxy，让 set 失效。（这样感觉会构造和新的 Proxy，不太好）

### Object.seal

封印一个对象，让这个对象不再是 [extensible](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/isExtensible)。（除此之外还可以用 Object.freeze, Object.preventExtensions）

所以不可继续添加属性，并且原有的属性都是不可 config 的（configurable 为 false），但是可以修改

This has the effect of making the set of properties on the object fixed and immutable.

The prototype chain remains untouched. However, the [`__proto__`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/proto) property is sealed as well.

通过 `Object.isSealed()` 来判断是否被封印。

### instanceof

检查`prototype`，用来判断一个**构造函数的** prototype 所指向的对象是否存在另外一个要检测对象的**原型链上**

所以只要目标对象的原型链上的`__proto__`是检测对象的 prototype 即可

```js
const myInstanceOf = (instance, constructor) => {
  const target = constructor.prototype;
  instance = instance.__proto__;
  while (instance) {
    if (instance === target) {
      return true;
    }
    instance = instance.__proto__;
  }
  return false;
};
```

### Object.create(null) 和 {}

```js
let a = Object.create(null); // __proto__ 是没有的
let aa = {}; // __proto__ 就是 {}
```

### Array

#### 添加尾部元素的方法：

- `arr[arr.length] = 'tail'`，长度重新计算，最后 index+1

#### 检测数组的方法

- `a instanceof Array`: 假定在单一的全局执行环境下的，如果网页中有多个框架，Array 的构造函数有不同的话，那就不行了，原因在于 instance 比较的是`a.__proto__ === Array.prototype`
- `Array.isArray(a)`: es5 新增，用它！可看https://stackoverflow.com/questions/28779255/is-instanceof-array-better-than-isarray-in-javascript，以及[MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/isArray)上有Polyfill，用`Object.prototype.toString`call这个对象来判断是否为`[object Array]`
- 其实其他的方法无非就是用原型去判断......`__proto__`、`prototype`

#### 数组的 toString()

- `[1, 2, 3].toString() === '1, 2, 3'`

- 递归调用元素的`toString`or`toLocaleString`

  ```js
  const p1 = {
    toString() {
      return "p1";
    },
    toLocaleString() {
      return "P1";
    },
  };
  const p2 = {
    toString() {
      return "p2";
    },
    toLocaleString() {
      return "P2";
    },
  };
  const pp = [p1, p2];
  console.log(pp.toString()); // p1,p2
  console.log(pp.toLocaleString()); // P1,P2
  ```

#### 数组的 join 方法

- 和 python 的`' '.join(['stra', 'strb', 'strc'])`很像但不一样
- `[1, 2, 3].join('x') === 1x2x3`
- 不传参数默认是`,`

#### pop 方法

- 可以模拟 stack，每次 pop 最后一个元素，并返回该元素

#### push 方法

- 在队尾 append 一个

#### shift 方法

- 可以模拟单向队列，将第一个元素 remove，并返回该元素

#### unshift 方法

- 向头部添加元素，可以是多个，顺序按照参数顺序，返回数组新的长度
- 模拟双向队列了？

#### 重排 reverse&sort

- sort 是比较元素的`toString`值

- sort 接受一个 compare 函数，返回值为大于零 or 小于零 or 等于零==>为 element1-element2 的值

- 数值型元素排序:

  ```js
  [4, 1, 6, 2, 4]
    .sort((a, b) => a - b) // 升序 a - b < 0 ?  -> a < b
    [(4, 1, 6, 2, 4)].sort((a, b) => b - a); // 降序
  ```

- 如果仅仅是要逆序数组，reverse 更快

#### concat 方法

- 返回拼接后的新数组，不改变原数组

  ```js
  console.log([1, 2, 3].concat(1, 2, 3));
  console.log([1, 2, 3].concat([1, 2, 3])); // 都是[1, 2, 3, 1, 2, 3]
  // ts 中的接口 concat(...items: (T | ConcatArray<T>)[]): T[];
  ```

#### splice 方法

- 可以切片，删除，替换，插入。。。很强大的方法

- 改变原始数组

- 返回被删除的元素构成的数组，没删的话就`[]`

- 切片：一个参数，开始的下标

- 删除：两个参数，第一个是开始的下标，第二个为删除的个数

- 替换：在删除的基础上，加上替换的元素

- 插入：在替换的基础上，将删除个数置为 0

  ```typescript
  splice(start: number, deleteCount: number, ...items: T[]): T[];
  // 所以给数组或者一个个元素都ok
  ```

#### indexOf&lastIndexOf 找元素下标

- 返回第一个/最后一个找到的下标，没有找到返回-1

- 用的最多的就是删除某个元素的时候，但要注意哦

  ```js
  const xa = [1, 2, 3, 4, 5];
  xa.splice(xa.indexOf(123), 1); // [1, 2, 3, 4] 123不在其中，返回-1，此时splice删的是最后一个元素！
  ```

#### 迭代的方法！

- every: 接收一个一元谓词，所有元素返回`true`整个才返回`true`，和 mysql 的 all 差不多意思
- filter: 接收一个一元谓词，返回满足谓词的元素数组
- forEach: 接收一个函数，可以对数组元素进行操作，没有返回值
- map: 接收一个函数，返回新的数组，元素是原始元素经过函数 map 之后的值
- some: 和 mysql 的 any 差不多意思
- 以上函数第一个参数是一个 callback function，参数为`value, index, thisArr`，是可以改变原始数组的！但是不推荐这样，第二个参数是 thisArg 可以改变上下文对象

#### reduce&reduceRight 方法

- 对数组做 reduce，归约？缩减数组的操作

- 和 python 里面的一样，接受一个函数，该函数的第一个参数是上一个值，后三个和上面的 callback 一样，返回值会赋值到下一个 previousValue

  ```typescript
  reduce(callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) => T): T;
  reduce(callbackfn: (previousValue: T, currentValue: T, currentIndex: number, array: T[]) => T, initialValue: T): T;
  ```

- 可以给初始值

- reduceRight 是从数组最右边的元素开始 reduce，只是方向不一样

  ```js
  let res = xa.reduce((pre, value) => pre + value, 0); // 不给初始值，默认也是0（对于数值），如果是字符串类型默认为''，以此类推了
  console.log(res);
  ```

### Date

构造一个 Date 类型

- `new Date()`参数是 number，string，Date 类型
- 不给的话就是 now，浏览器是 local time

获得 UTC 时间 parse&UTC，返回 UTC 时间戳

- parse 函数接受的参数为字符串，格式:
  - `'Month date, year'`
  - `'month/date/year'`
  - Date 类型的 toString()得到的字符串
- UTC 接受的参数
  - ` UTC(year: number, month: number, date?: number, hours?: number, minutes?: number, seconds?: number, ms?: number): number;`
  - **月份一定是从 0 开始的！**
  - **小时也是 0-23**

toString 和 toLocaleString

- Sat Apr 11 2020 00:00:00 GMT+0800 (GMT+08:00)

- 2020-4-11 0:00:00

- 当然，每个浏览器都不太一样，上面的是 node

- 其他的格式化方法

  ```js
  console.log(sd.toDateString());
  console.log(sd.toTimeString());
  console.log(sd.toLocaleDateString());
  console.log(sd.toLocaleTimeString());
  console.log(sd.toUTCString());
  ```

toLocaleString 还能传入 option

- 可以去 MDN 看每个基本类型的 toLocaleString 可以传什么 option
- 注意有坑，不要乱用

valueOf()

- 返回毫秒数
- 比较的时候用到

获取时间的方法

- get 各种内容
- getTime()
- setTime(毫秒)
- getFullYear()
- getUTCFullYear()
- setUTCFullYear(year)
- setFullYear(year)
- getMonth()
- getUTCMonth()
- getSeconds
- ......各种

### RegExp

regular expression

啊哈正则，python 里面记录过，这里先不学了，用到再说

非纯中文 or 英文 or 数字组合：

```TypeScript
const checkNameRe = /[^\a-zA-Z0-9\u4E00-\u9FA5]/g; // 非 中文 / 英文 / 数字
```

Emoji 检查

```typescript
const checkEmojiRe = /\uD83C[\uDF00-\uDFFF]|\uD83D[\uDC00-\uDE4F]/; // emoji 检查
```

## Function

### 没有函数重载

函数声明相当于是`const funName = function() {...}`

写相同函数名，想重载的操作，其实就是覆盖了这个引用

### 内部的属性

this

- _this is not in functions but can distinguish the strict mode_

  ```js
  const strict = (function () {
    return !this;
  })();
  ```

- _function chain (method) always return this_

- 函数内的函数的 this

  ```js
  let o = {
    m() {
      let self = this;
      console.log(this === o);
      // define function in functon
      // function f() {
      //     console.log(this === o) // false
      //     console.log(self === o) // true
      // }
      const f = () => {
        // if arrow function, this will be the outside
        console.log(this === o); // true
        console.log(self === o); // true
      };
      f(); // this => arrow function
    },
  };
  ```

- new 关键字对构造函数的 this

arguments

- array-like 的

- _non strict mode can alter the args reference_

- _arguments object accurately save the reference of the args_

  ```js
  function f(x, y, z) {
    console.log(arguments); // like an array but not a array
    console.log(Array.isArray(arguments)); // false
    console.log(arguments[0]);
    console.log(arguments[3]);
    arguments[0] = 123123;
    console.log(x); // 123123
  }
  ```

- _arrow function has no arguments!_

- arguments 的 callee

  - 当前的函数

    ```js
    const factorial = function (x) {
      if (x <= 1) {
        return 1;
      }
      return x * arguments.callee(x - 1); // use callee to recursivly invoke
      // also can use the function name
      // but if function name is changed, inside is highly coupled
      // use arguments.callee is better
    };
    ```

  - _in strict mode throw Error_ Type Error

caller

- 指向调用本函数的函数

  ```js
  function inside() {
    console.log(arguments.callee.caller); // 这样耦合性更小
  }
  function outside() {
    inside();
  }
  outside(); // [Function: outside]
  ```

### 属性和方法

length

- 参数长度，如果是解构的...是不算在内

  ```js
  const oisf = (a, b, ...c) => {};
  console.log(oisf.length); // 2
  ```

call, appliy, bind

- _first arg is the target object, the calling context_

- 区别在于 apply 的第二个参数是一个 array

- call 可以将参数一个个传入

- 严格模式下，如果不指定函数调用上下文，内部的 this 是 undef，除非用 call 或者 apply

- bind 是 es5 的

  - 创建一个函数实例，绑定一个上下文和参数给这个函数

  - 返回的是一个**boundFunction**，有内置的几个属性：

    - **`BoundTargetFunction`**：指向原来的函数
    - **`BoundThis`**：指向绑定的上下文
    - **`BoundArguments`**：被 bind 的参数，也就是给原函数放的参数
    - **`Call`**

  - 手写一个（利用 apply，写的不完善，没考虑参数的问题 TODO

    ```js
    function bbind(func, obj) {
      // return a function
      if (func.bind) {
        return func.bind(obj);
      }
      return function () {
        // this function accept arguments
        return func.apply(o, arguments);
      };
    }
    ```

  - MDN 上也有 [polyfill](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/bind)

## 包装类型

为了便于操作基本类型值，提供了 3 个特殊的引用类型 String, Boolean, Number。

```js
let wes = "wefadsf";
console.log(wes.substring(1, 4));
```

可以看到字符串字面量居然可以调用方法，其中发送了什么呢

```js
let _wes = new String(wes);
let res = _wes.substring(1, 4);
_wes = null;
```

每次读取一个基本类型的时候，就会创建一个基本包装类型的**对象**，能够调用它的一些方法。

但是只是临时的，语句执行完就垃圾回收了。

```js
let wes = "wefadsf";
console.log(wes.substring(1, 4));
wes.name = "name";
console.log(wes.name); // undefined
```

可以显式调用对应的构造函数去创建实例对象，但是就分不清是**基本类型**还是对象类型。

Object 构造函数也会像工厂方法一样

```js
let wer = new Object("123");
console.log(wer instanceof String); // true
```

new 一个基本类型的 type 是 object

```js
let www = String("wwww");
let wwwo = new Object(www);
let wwws = new String(www);
console.log(typeof www); // string
console.log(typeof wwwo); // object
console.log(typeof wwws); // object
```

### Boolean

```js
let fb = new Boolean(false);
let fbv = false; // <=> Boolean(false)
console.log(fb && true); // true
console.log(fbv && true); // false
```

这里 fb 被当成是对象！

**建议永远不要使用 Boolean 哈哈哈**

### Number

toString()接受转换的进制

toFixed()接受保留几位小数

toExponential()接受 n 表示为 xe+n

toPrecision()接受保留几位数值

### String

每个实例都有 length

strr[index]获取..

charAt(index)返回所处下标的字符，不符合的下标返回`''`

charCodeAt(index)返回下标字符的 ASCII 码，10 进制

concat(str1, str2, ...)方法拼接字符串，用+号更简单

slice()切片 substr()和 substring()都可接受两个参数，起始下标和结束下标，**substr()第二个参数是字符个数**

indexOf(char)返回下标，未找到的返回-1 和数组的一样，有 lastIndexOf

trim()方法(ES5)删除前置和后缀的所有空格，类似 py 的 strip

大小写转换：

- toLowerCase()
- toLocaleLowerCase()
- toUpperCase()
- toLocaleUpperCase()

模式匹配

- match

  - 接受一个正则对象，返回匹配结果
  - 匹配成功，返回数组`[str, index, input, groups]`
  - 看似是数组，实际也是一个 object 可以访问`.index`...
  - 匹配失败返回 null

- search

  - 成功返回下标
  - 失败返回-1

- replace

  - 接受两个参数，正则对象/string 和替换的字符串

  - 替换第一个匹配的字符串

  - 如果要全局替换，就要用`/正则表达式/g`，g 表示 global

  - 替换的特殊序列

    - `$$`
    - `$&`
    - `$'`
    - \$`
    - `$n`
    - `$nn`

  - 第二个参数可以是个函数，返回一个字符串

    ```js
    function htmlEscape(text) {
      return text.replace(/[<>"&]/g, (match, pos, ori) => {
        switch (match) {
          case "<":
            return "&lt;";
          case ">":
            return "&gt;";
          case "&":
            return "&amp;";
          case '"':
            return "&quot;";
        }
      });
    }
    ```

- split 方法，类似 py 的返回分隔后的字符串数组，可以有第二个参数指定数组长度

localeCompare()方法

- 比较两个字符串
- 一个个字符按照字典序比较
- 小的（出现在参数字符串之前的）就返回-1
- 完全一样的返回 0
- 有一个相同位置的字符大，返回 1

fromCharCode(...codes)**String 的静态方法**，接受一组编码，转换为一个字符串

- ```js
  console.log(String.fromCharCode(111, 111, 97, 97)); // ooaa
  ```

## 单体内置对象(singleton?)

### Global

全局的一个对象，`isNaN()`,`isFinite`,`parseInt`, `parseFloat`都是他的方法

URI 编码方法

- 对 URL 进行编码，以便发送给浏览器，有效的 URI 中不能有某些字符，比如空格，用 utf8 编码替换

- `encodeURI`: 不会对 URI 本身的特殊字符编码，比如`:, /, ?, #`

- `encodeURIComponent`对任何不符合要求的字符进行替换编码

  ```js
  const sse = "https://www.baidu.com/?s=xx";
  console.log(encodeURI(sse)); // https://www.baidu.com/?s=xx
  console.log(encodeURIComponent(sse)); // https%3A%2F%2Fwww.baidu.com%2F%3Fs%3Dxx
  ```

- 解码的函数：`decodeURI`和`decodeURIComponent`

  - 对应着使用！

eval()方法解析执行一个字符串

各种构造函数都是 Global 的属性

window 对象。。之后详谈

### Math

包含数学计算中的特殊值

```js
Math.E;
Math.LN10;
Math.LN2;
Math.LOG2E;
Math.LOG10E;
Math.PI;
Math.SQRT1_2;
Math.SQRT2;
```

min()和 max()都接受`...values`对于数组，es6 直接`...arr`即可，es5 需要`Math.min.apply(Math, arr)`，就是利用了函数的 apply，参数是数组

舍入方法

- `Math.ceil`
- `Math.floor`
- `Math.round`

random()方法返回 0-1 之间的随机数

- ```js
  let total = 900;
  let first = 4;
  console.log(Math.floor(Math.random() * total + first));
  ```

还有其他一些数学上的方法`abs, exp, log, pow, sqrt, acos, asin, atan, atan2(y / x), cos, sin, tan`

## Error 对象

Error 的细节部分在日常开发中往往被我们忽略，但是在写 Testing 和 Error 相关的 lib 的时候是非常有用的。

### stack trace

```js
function a() {
  console.log("aaa");
  ab();
}
function ab() {
  console.log("abaa");
  ac();
}
function ac() {
  console.log("acaa");
  ad();
}
function ad() {
  console.log("adaa");
  console.trace();
}
a();
```

在 node 执行的时候就会展示函数栈的信息

### Error

Error.prototype 对象通常包含下面属性：

- constructor - 一个错误实例原型的构造函数
- message - 错误信息
- name - 错误名称

这几个都是标准属性，有时不同编译的环境会有其独特的属性。

用 throw 来抛出错误

try 语句来捕获

- try...catch
- try...finally
- try...catch...finally

注意：**你可以抛出非 Error 对象的值**。尽管这看起来很炫酷，很灵活，但实际上这个用法并不好，尤其在一个开发者改另一个开发者写的库的时候。因为这样代码没有一个标准，你不知道其他人会抛出什么信息。这样的话，你就不能简单的相信抛出的 Error 信息了，因为有可能它并不是 Error 信息，而是一个字符串或者一个数字。另外这也导致了如果你需要处理 Stack trace 或者其他有意义的元数据，也将变的很困难。

可以去了解一下 [chaijs](https://www.chaijs.com/)

## 函数式编程

## 关于模块化

```js
// function serve as namespace
(function () {
  // console.log(this)
  let a = 1;
  console.log(a);
})();
```

## OOP

面向对象不多说了，c++学的够透彻了，直接上 js 中的特性

### 定义属性

defineProperty

```js
Object.defineProperty(obj, propName, {
  value: 1,
  enumerable: true,
  writable: false,
  configurable: false,
});
```

也可以 defineProperties

```js
function Range(from, to) {
  let props = {
    from: {
      value: from,
      enumerable: true,
      writable: false,
      configurable: false,
    },
    to: {
      value: to,
      enumerable: true,
      writable: false,
      configurable: false,
    },
  };
  // 可以是构造函数
  if (this instanceof Range) {
    Object.defineProperties(this, props);
  } else {
    // create第一个参数是原型 第二个参数是传入defineProperties的
    return Object.create(Range.prototype, props);
  }
}
```

### 访问器属性 set 和 get

这个还挺有意思，像是计算属性的感觉，python 的 property

- configurable
- enumerable
- get: 读取属性的时候会调用的函数
- set: 写入属性的时候调用的函数

```js
var p = {
  x: 1,
  y: 1,

  get r() {
    return Math.sqrt(this.x * this.x + this.y * this.y);
  },
  set r(newV) {
    var old = this.r;
    var ratio = newV / old;
    this.x *= ratio;
    this.y *= ratio;
  },
  get theta() {
    return 12;
  },
};
```

### 获取属性的特性(描述)

Object.getOwnPropertyDescriptor 方法

```js
// 为对象原型添加拓展方法
Object.defineProperty(Object.prototype, "extend", {
  writable: true,
  enumerable: false,
  configurable: true,
  value: function (o) {
    // 获得o的属性 给自己添加不重复属性
    let names = Object.getOwnPropertyNames(o);
    for (let n of names) {
      if (n in this) {
        // 如果自己有属性就跳过
        // 也可以更新 那就是merge了
        continue;
      }
      // 获取o的属性描述
      let desc = Object.getOwnPropertyDescriptor(o, n);
      // 给自身添加新属性
      Object.defineProperty(this, n, desc);
    }
  },
});
```

### 创建对象

#### 工厂模式

抽象了具体对象创建的过程，为这个对象添加属性。

想到 python 写 flask 的时候也用到了工厂模式，在这个工厂函数中对将要出厂的对象进行具体的加工，最后返回对象

```js
// factory function
const range = function (from, to) {
  let r = inherit(range.methods); // 让所有对象的原型都继承自range的方法
  r.from = from;
  r.to = to; // 其余两个属性是每个对象独有的 不可继承
  // 所以原型就是一堆可继承来的属性，由一个对象传入 类属性
  // 在构造函数中的this赋值是 self属性
  return r;
};
```

但是问题在于，生产出的 object 无法确认类型，也就是对构造函数的 prototype 无法辨别。

#### 构造函数模式

```js
// constructor
function Range(from, to) {
  this.from = from;
  this.to = to;
}
const rrr = new Range(10, 10);
```

必须要用到 new 关键字！

每个对象都有一个 constructor 了，就是构造函数，实际上是在原型上定义好的

```js
// each function can be a class constructor
let F = function () {};
let p = F.prototype; // each has a prototype
let c = p.constructor;
console.log(p);
console.log(c);
console.log(c === p);
console.log(c === F);
console.log(F.prototype.constructor === F); // true
```

构造函数好用，但是也有缺点，就是每个实例的方法都要重新创建一遍，因为每个对象的 this.func 都指向了一个新的函数

当然可以通过让类属性指向全局函数来解决方法

```js
function A() {
  this.name = "A";
  this.class = "A";
  this.call = call;
}
function call() {
  console.log(this.name);
}
```

但是这样做，如果一个类有多个方法，就需要定义多个全局函数，类的封装性就不太好了。

所以用原型模式！

#### 原型模式

prototype 是构造函数的属性，都继承自 Object.prototype

提一句原型链，如果想访问对象实例的某个属性，其实例本身没有的话就去 prototype 找了，所以 prototype 可以算是对象类的静态属性。

将对象信息全部添加到原型中，就可以让所有实例共享了！

上面提到`prototype.constructor`指向的就是构造函数

实例自身添加属性可以覆盖原型中的属性，但不是修改原型，可以用 delete 删除实例属性来访问原型属性

实例的`instance.hasOwnProperty(name)`来查看实例自身有没有该属性

in 操作符，只要属性能被访问就返回 true

```js
function OP() {}
OP.prototype.name = "123";
function OOP() {}
OOP.prototype = OP.prototype;

const ooop = new OOP();
// ooop.name = '1111'
console.log(ooop.name);
console.log(ooop.hasOwnProperty("name")); // false
console.log("name" in ooop); // true
```

for in 循环时，返回的是对象**所有**能访问的、可枚举的属性

通过 Object.keys()获得实例上的可枚举的属性，返回数组

```js
console.log(Object.keys(ooop)); // []
```

也可以直接重写 property，但是记得要加上 constructor 指向构造函数！但是这样子 constructor 就是 enumerable 了，最好用`defineProperty`去写

动态的原型，重写整个原型之后，已经创建的实例的`__proto__`还是指向原来函数的 prototype

#### 构造函数和原型模式组合使用

其实就是将共有的（静态的）属性放在原型以便共享使用

实例 feature 的属性放在构造函数中创建

#### 寄生构造函数

类似 oop 中的继承？

在构造函数内部新建一个其他类型的实例，然后增加新的属性，最后返回

建议不要使用哈哈哈

#### 稳妥构造函数

不用 this，不用 new 关键字

像普通函数一样

比较适合在一些安全的环境中（禁用 this 和 new）

和寄生构造函数一样，内部创建实例返回。

**instanceof 会失效！因为不是当做构造函数来用**

### 继承

#### 原型链

## 关于 new 关键字

```js
// constructor function
// after new keyword
// 'new' try to initialize a object and transfer it to the context
// of the constructor, so the 'this' in constructor can be used
// if the constructor doesnt return any object then return this

function _new(constructor, ...args) {
  let obj = Object.create(constructor.prototype);
  let res = constructor.apply(obj, args);
  // check if constructor return an obj, if not return obj context
  return res instanceof Object ? res : obj;
}
```

这个我们日后详谈

## 浏览器事件

冒泡和捕获

## 防抖和节流(debounce & throttle)

### 防抖

#### 原理

防止浏览器抖动嘛，一直做一件事就好像是在 bounce。。

打个比方：公交车司机到站，什么时候关门呢？等没有乘客上下车了。司机一看，一个乘客下车之后几秒内没有别的乘客下车，于是关门。

在 js 中，乘客上下车可以看成是一个 event，关门是这个 event 对应的 callback，那么防抖的作用就是为了不让这个 event 在短暂 or 连续触发的时候调用 callback，因为这个 callback 会造成很大的资源消耗（比如发送 ajax，后台就崩了；重绘回流），所以就像例子中的公交老司机，等 event 触发后延迟一段时间判断没有后续的 event 再被触发的时候才执行 callback。

通常都是给 div 绑定某个 event 的监听器，注册回调函数，那么就在 callback 做点手脚，让 callback 函数有防抖的功能。

用高阶函数+闭包的方法。

#### 实现

写个代码看看

```js
function debounce(func, wait) {
  let timeout = null;
  // 闭包返回的函数作为回调函数 onxxx = function(e) {}
  return function () {
    // 为了让回调函数能获取到事件event对象
    let args = arguments;
    if (timeout !== null) {
      // 有定时器延迟
      // 清空 重来
      clearTimeout(timeout);
    }
    timeout = setTimeout(function () {
      func.apply(this, args); // 让func作用在调用它的上下文对象
    }, wait);
  };
}
```

加入 immediate 功能，让回调函数在事件触发的时候立即执行，同时也在一定时间内不触发下一次回调

```js
function debounce(func, wait, immediate) {
  let timeout = null;
  let result;
  return function () {
    let args = arguments;
    if (timeout !== null) {
      // 有定时器延迟
      // 清空 重新延迟
      clearTimeout(timeout);
    }
    if (immediate) {
      // 立即执行 下面的代码很巧妙
      // 让callNow这个变量决定是否立即执行
      let callNow = !timeout;
      timeout = setTimeout(() => {
        // 延迟wait之后让yimeout为null 下一次进入的时候就会执行func了
        timeout = null;
      }, wait);
      // 如果没有定时器 callNow为true 那么就执行
      if (callNow) {
        result = func.apply(this, args); // 让func作用在调用它的上下文对象
      }
    } else {
      timeout = setTimeout(function () {
        result = func.apply(this, args); // 让func作用在调用它的上下文对象
      }, wait);
    }
    return result; // 同时返回函数执行的返回值
  };
}
```

加入取消的功能，在延迟的时候，想取消这个回调函数

```js
function debounce(func, wait, immediate) {
  let timeout = null,
    result;
  // 让闭包的函数成为一个对象 最后返回
  const debounced = function () {
    let args = arguments;
    if (timeout !== null) {
      // 有定时器延迟
      // 清空 重新延迟
      clearTimeout(timeout);
    }
    if (immediate) {
      // 立即执行
      // 让callNow这个变量决定是否立即执行
      let callNow = !timeout;
      timeout = setTimeout(() => {
        // 延迟wait之后让yimeout为null 下一次进入的时候就会执行func了
        timeout = null;
      }, wait);
      // 如果没有定时器 callNow为true 那么就执行
      if (callNow) {
        result = func.apply(this, args); // 让func作用在调用它的上下文对象
      }
    } else {
      timeout = setTimeout(function () {
        result = func.apply(this, args); // 让func作用在调用它的上下文对象
      }, wait);
    }
    return result;
  };
  // 为函数添加属性
  debounced.cancel = function () {
    // 关键执行函数的地方都在定时器里面 取消这定时器就取消了执行
    clearTimeout(timeout);
    timeout = null;
  };
  return debounced;
}
```

使用

```js
const div = document.getElementById("container");
deDoSth = debounce(doSth, 5000, false);
div.onmousemove = deDoSth;
// div.onmousemove = _.debounce(doSth, 200, true);
const btn = document.querySelector("#btn"); // 用一个按钮来取消
btn.addEventListener("click", function () {
  deDoSth.cancel();
});
```

使用 underscore 中的防抖。underscore 是一个 js 的函数包，封装了很多方法，[官方文档](http://underscorejs.org/)

其实上面的代码都是参考 underscore 写的，可以看他[源码](https://github.com/jashkenas/underscore/blob/master/underscore.js)其实写的更好。

总的来说就是巧妙的利用闭包+定时器，让函数在事件触发一定时间后执行

**解决频繁事件触发造成页面消耗和卡顿**

#### 使用场景

- scroll 事件，滚动实时监听的
- 搜索框输入搜索，这个蛮重要的
- 表单验证
- 按钮提交
- 窗口 resize 事件

### 节流

#### 原理

在一段时间内事件的回调只触发一次

举个例子：

#### 实现

两种方法可以实现在一段时间内触发 callback 一次

时间戳 or 定时器

- 时间戳的思想很简单，闭包记录前一次的时间戳，然后在触发的时候判断当前时间戳和上一次的差值是否在延迟时间之外，如果是，就执行

  ```js
  // 时间戳方式 第一次立即触发  最后一次不触发
  function throttle1(func, delay) {
    let context, args;
    // 之前的时间戳
    let previous = 0;
    return function () {
      args = arguments;
      // 获取当前时间戳
      let now = new Date().valueOf();
      if (now - previous > delay) {
        // 在相隔时间达到delay 立即执行
        func.apply(this, args);
        previous = now;
      }
    };
  }
  ```

- 定时器

  ```js
  // 定时器方式 第一次不会触发 最后一次会触发
  function throttle2(func, delay) {
    let args, timeout;
    return function () {
      args = arguments;
      // 第一次没有定时器 直接延时触发
      if (!timeout) {
        timeout = setTimeout(() => {
          // 等待下次事件触发
          timeout = null;
          func.apply(this, args);
        }, delay);
      }
    };
  }
  ```

但是呢，节流出现一个问题，第一次和最后一次的触发需要？最后一次是

在 underscore 这个库里，是可以配置的

```js
div2.onmousemove = _.throttle(doSth, 2000, {
  leading: true, // 第一次立即执行
  trailing: false, // 最后一次延迟后不执行
});
```

那我们也写的牛逼完善一点，借鉴一下源码，写个简易版

```js
function throttle(func, delay, options) {
  let previous = 0;
  let args, timeout;
  let context;
  let result;
  options = options || {};
  const later = function () {
    previous = new Date().valueOf();
    // 等待下次事件触发
    timeout = null;
    result = func.apply(context, args);
  };
  const throttled = function () {
    context = this;
    args = arguments;
    let now = new Date().valueOf();
    // 如果是第一次 previous=0的 如果不需要第一次，直接让previous=now 这样就进不去下面的if
    if (!previous && options.leading === false) previous = now;
    if (now - previous > delay) {
      console.log(1);

      if (timeout) {
        clearTimeout(timeout);
        timeout = null;
      }
      result = func.apply(context, args);
      previous = now;
    } else if (!timeout && options.trailing !== false) {
      // 如果需要最后一次 才会设置定时器
      console.log(2);

      // 第一次没有定时器 直接延时触发
      timeout = setTimeout(later, delay);
    }
    return result;
  };
  throttled.cancel = function () {
    clearTimeout(timeout);
    timeout = context = args = null;
    previous = 0;
  };
  return throttled;
}
// 使用
const throttledDoSth = throttle(doSth, 5000, {
  leading: false,
  trailing: true,
});
```

不可以同时不要 leading 和 trailing 的触发，会有 bug。也不合常理。。

#### 使用场景

- dom 元素拖拽
- 射击游戏
- 计算鼠标移动距离，每隔一段时间
- 监听 scroll 滚动

## Promise

异步解决方案，和 callback 的对比

可以封装异步操作，每一个异步操作就是一个 "promise"，操作中：`pending`初始状态，操作完成`fulfilled`，抛出异常`rejected`，状态一旦改变，调用`.then`中注册的回调函数。

### API

https://segmentfault.com/a/1190000007032448

### resolve 和 reject 之后的代码还会执行吗

会！因为 resolve 和 reject 的执行只是改变了这个 Promise 的状态（fulfilled 和 rejected）

但是一个 Promise 状态一旦 settled 就无法改变了，也就是说如果 resolve 和 reject 都执行了，谁先执行就是他的状态

```js
new Promise((resolve, reject) => {
  console.log(112233);
  resolve(1);
  reject(1);
  // return 123
  console.log(4455);
}).catch((e) => {
  console.log(`reject ${e}`);
});
```

**建议：**在改变状态后使用 `return` 避免后续代码的执行吧

### 实现 Promise.all

```js
// 接受 promise 对象的数组 当所有的 promise 都 fulfilled 了返回结果数组
Promise.myAll = function (promises) {
  return new Promise((resolve, reject) => {
    const results = [];
    let count = 0;
    promises.forEach((promise, index) => {
      promise.then((value) => {
        // 注册每个 promise 的回调
        // 保存到 results 中
        results[index] = value;
        console.log(`no.${index} is done: ${value}`);
        if (++count === promises.length) {
          resolve(results);
        }
        return value; // 这里其实可以不用 return
      }, reject);
    });
  });
};
```

测试一下

```js
let p1 = new Promise((resolve, reject) => {
  resolve(123);
}).then((v) => {
  console.log("p1 ", v);
  return v; // 这里需要 return 给 all 的 then 调用
});
let p2 = new Promise((resolve, reject) => {
  resolve(222);
});
let p3 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(3);
  }, 3330);
});
let p4 = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve(4);
  }, 1000);
});

const pa = Promise.myAll([p1, p2, p3, p4]).then(console.log);
console.log(pa);
```

### Promise.finally

在 promise 结束时，无论结果是 fulfilled 或者是 rejected，都会执行指定的回调函数。

这为在`Promise`是否成功完成后都需要执行的代码提供了一种方式。

注意回调函数不接受任何参数！

finally 返回的结果也是一个 Promise，resolve 状态的返回时上一个 resolve 的值

```js
Promise.resolve(123)
  // .then((res) => {
  //   console.log(444);
  //   return res;
  // })
  .finally(() => {
    console.log("finally");
  })
  .then((res) => {
    console.log(res);
  });
// finally
// 123
```

但是如果 then 已经消费过一次 resolve 了，就得不到最初 resolve 的值了

### 有并发限制的异步任务调度器

一道补充代码的面试题（别人告诉我的）

我一开始的思路：有一个当前在线任务的计数器，达到阈值之后再 add 来的任务放到队列中进行，被立即执行的任务注册回调，让队列中下一个任务继续被加入进来。

难点：add 函数还需要返回 promise，如何调度。

我一开始在单个 add 函数里面封装 promise，进行回调注册，发现很失败，然后用了`Promise.race`，发现任务队列中一旦完成，后续任务会被一起加进去执行，就不太行。

然后参考了网上的操作，用一个函数去封装一下任务来解决注册回调难的问题，至于返回 promise，在 add 层封装 promise，再将 resolve 和 reject 闭包再任务里面，这个思路很棒！

并且这个任务也是个函数，等到任务队列空闲的时候执行。

```javascript
/*
 * @Author: CoyoteWaltz <coyote_waltz@163.com>
 * @Date: 2020-08-06 22:50:17
 * @LastEditTime: 2020-08-07 00:09:51
 * @LastEditors: CoyoteWaltz <coyote_waltz@163.com>
 * @Description: 并发限制的异步任务调度器
 * @TODO:
 */
class Scheduler {
  waitQueue = [];
  limit = 2;
  cnt = 0;
  constructor(limit = 2) {
    this.limit = limit;
  }
  add(promiseCreator, ...args) {
    return new Promise((resolve, reject) => {
      // 把 resolve 闭包入这个 task 是很妙的 只有当 promiseCreator 真正执行回调的时候才调用
      const task = this.createTask(promiseCreator, args, resolve, reject);
      if (this.cnt < this.limit) {
        // 直接执行
        task();
      } else {
        this.waitQueue.push(task);
      }
    });
  }

  // 封装一个 任务 fn
  createTask(fn, args, resolve, reject) {
    return () => {
      // 执行 就++ 可以放到第一句
      this.cnt++;
      fn(args)
        .then(resolve)
        .catch(reject)
        .finally(() => {
          // 结束之后 让下一个等待的任务启动
          this.cnt--;
          if (this.waitQueue.length) {
            const task = this.waitQueue.shift();
            task();
          }
        });
    };
  }
}

// 模拟异步任务
const timeout = (time) =>
  new Promise((resolve) => {
    setTimeout(() => {
      resolve(time);
    }, time);
  });

const scheduler = new Scheduler(2);
// 加入调度器
const addTask = (time, order) => {
  scheduler
    .add(() => {
      return timeout(time);
    })
    .then(() => console.log(order));
};

addTask(1000, 1);
addTask(500, 2);
addTask(300, 3);
addTask(400, 4);
// 输出 2 3 1 4
// 同时最多运行的任务只有两个
```

## var 变量/函数提升的坑

先看个代码：

```js
var myname = "小明";

function showName() {
  console.log(myname); // undefined
  if (0) {
    var myname = "小红";
  }
  console.log(myname); // undefined
}
showName();
```

输出的都是`undefined`，原因就是在`showName`函数中的`myname`提升了，而且`if(0)`不赋值，等价于

```js
function showName() {
  var myname;
  console.log(myname); // undefined
  if (0) {
    myname = "小红";
  }
  console.log(myname); // undefined
}
```

至于外面的`myname`是不会被访问的，因为 lookup 直接找到了作用域内的

### 函数和 var 提升的顺序

都是提到顶级层，但是函数优先级 **小于** var

```js
function foo() {
  console.log(a); // a() {}
  var a = 1;
  console.log(a); // 1
  function a() {}
  console.log(a); // 1
}
foo();
```

等价于

```js
function foo() {
  var a;
  function a() {}
  console.log(a); // a() {}
  a = 1;
  console.log(a); // 1
  console.log(a); // 1
}
foo();
```

**有多个 var 的时候会一起提到前面，然后再是 function**

**最后，注意：只有声明的变量和函数才会进行提升，隐式全局变量不会提升。**

```js
function foo() {
  console.log(a);
  console.log(b); // 报错
  b = "aaa";
  var a = "bbb";
  console.log(a);
  console.log(b);
}
foo();
```

## 闭包

什么是闭包？

闭包 = 开放的 lambda 表达式 + 使得开放表达式闭合的一个环境

所谓开放的表达式就是其中的参数没有绑定值，让其闭合就是让每一个自由变量都绑定一个值

MDN 对闭包的定义

> A **closure** is the combination of a function bundled together (enclosed) with references to its surrounding state (the **lexical environment**).
>
> In other words, a closure gives you access to an outer function’s scope from an inner function. In JavaScript, closures are created every time a function is created, at function creation time.

词法环境 **lexical environment** 对象：使得函数“关闭”的词法环境，在函数运行时作为外部环境来使用

是函数的`[[Environment]]`属性指向一个环境，记录变量

其实闭包就是一个环境，以函数为中心，取得一个层级的环境范围

## 立即执行函数

神坑，主要感觉会出在面试题中

```js
// 立即执行函数的官方写法
(function () {})();
W3C建议此种(function () {})();
```

### 功能

#### 旧时代的模块化实现

#### 初始化值

```js
var num = (function (a, b) {
  return a + b;
})(1, 2);
```

#### 面试题

```js
function test(a, b, c, d) {
  console.log(a + b + c + d);
}
1, 2, 3, 4;
```

不报错也不执行，但是会产生 test 这个函数，下面这样就立即执行了

```js
(function test(a, b, c, d) {
  console.log(a + b + c + d);
})(1, 2, 3, 4);
```

主要原因：上面没有括号的函数定义在 js 引擎中只被解析成 函数定义，**_而后面的括号被解析成逗号表达式，只有最右边的值作为这个表达式的值。。_**并没有作为函数的参数执行。下面这个例子也是这个道理

```js
function test(){
  console.log("a");
}()   // 报错

function test(){
  console.log("a");
}(1)   // 不报错不执行
```

再看个难一点的

```js
// 环境 浏览器！
var x = 2;
var y = {
  x: 3,
  z: (function (x) {
    // x = 2
    this.x *= x; // 立即执行函数的作用域 为顶层 window.x *= 2 -> 4 var x 为 4了
    x += 2; // 这里的 x 是形参 x -> 4
    // 返回一个函数 A
    return function (n) {
      this.x *= n; // 注意这里的 this 会随着调用者改变
      x += 3; // 闭包了外面的 x
      console.log(x); // 打印的一直都是闭包的 x
    };
  })(x), // 1.立即执行 参数 x 此时找到最外的 var x = 2 传入
  // 初次执行完毕 z 为返回的函数A
};

var m = y.z; // m 指向 这个函数A
m(4);
// 调用者是 全局 所以 var x 会 *= 4 此时 x 函数中A的 x += 3
// 打印 x -> 7
// 此时 var x == 4*4 -> 16  闭包的 x 为 7 对象y不受影响

y.z(5); // 调用者为 y this.x 改变的是 y.x -> 3 * 5 -> 15 闭包中的 x += 3 -> 10
// 打印 10
console.log(x, y.x); // 16 15
```

**关键是立即执行函数会被提升到顶层！！**

## obj.x 先求值

B 站面试的一个题目

```javascript
let a = { bar: 123 };
let b = a;
a.x = a = { foo: 321 };
console.log(a); // {foo: 321}
console.log(b); // { bar: 123, x: { foo: 321 } }
```

注意第三行的`a.x`会先计算，是`{bar: 123}`的 x 属性，所以会让第一个对象的 x 也变化，再计算`a = {foo: 321}`。

所以，挺坑的。。。

## label

标记语法，

```js
label: statement;
```

- label：可以是任何的 identifier，`$`、`_`也是可以的
- statement：A JavaScript statement. `break` can be used with any labeled statement, and `continue` can be used with looping labeled statements.

具体内容看 [MDN](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/label) 吧，比较冷门的一个点，知道有这个东西就够了。

PS：在 Svelte 中用来做 computed 变量/语句声名`$: statement`
