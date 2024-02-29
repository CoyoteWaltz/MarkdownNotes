# v8 相关学习

### [v8 elements kinds](https://v8.dev/blog/elements-kinds)

v8 中是如何处理数组元素的

在 JavaScript 中，对象的属性名称可以是任意的字符，对于数值型的（numerically）的 key，v8 对其有特殊的优化，和属性不同，他们的值（元素）被放在另一个空间存储

常规的元素类型：

```javascript
const array = [1, 2, 3];
// elements kind: PACKED_SMI_ELEMENTS SMI -> small integer
array.push(4.56);
// elements kind: PACKED_DOUBLE_ELEMENTS
array.push("x");
// elements kind: PACKED_ELEMENTS
```

数组的元素一旦从具象到抽象（比如从 smi 到 regular element），是不会再回去的

`PACKED` vs. `HOLEY` kinds：

- 连续紧密（dense）的数组：得到更好的优化
- 有洞的数组：可以从 packed 数组转变

The elements kind lattice：lattice 类似网格框架，意思是从具象 -> 抽象 & 紧密 -> 稀疏这两个维度，都是单向转变的，一旦变化之后，v8 是不会回退的（即使把 double 类型都改回 int），根据这几个维度的排列组合，目前一共有 21 种元素类型（[21 different elements kinds](https://cs.chromium.org/chromium/src/v8/src/elements-kind.h?l=14&rcl=ec37390b2ba2b4051f46f153a8cc179ed4656f5d)），对应都有不同的优化手段，越具象的类型能够得到更细粒度的优化，越往 lattice 下面的，优化就越少。**所以尽可能的不要改变数组的元素类型**

性能优化的 tips：

- Avoid reading beyond the length of the array：不要越界的去查询数组元素，因为这样会引起原型链的搜索，性能开销是很大的（猜测是在 element 空间找不到之后，还回去 property 空间 + 原型链遍历搜索，如果数组元素本来就很大 or 原型链上很大，那这个遍历开销也会非常大）

- Avoid elements kind transitions：尽可能的是单一的元素类型，可以在修改数组的时候进行 normalization

  ```javascript
  const array = [3, 2, 1, +0];
  // PACKED_SMI_ELEMENTS
  array.push(-0);
  // PACKED_DOUBLE_ELEMENTS
  const array = [3, 2, 1];
  // PACKED_SMI_ELEMENTS
  array.push(NaN, Infinity);
  // PACKED_DOUBLE_ELEMENTS  NaN 和 Infinity 都会被标记为 double 类型
  ```

- Prefer arrays over array-like objects：创建了一个 array-like 的对象（length，和数字属性）也没有 Array 对象的一些遍历方法，在使用 `Array.prototype.forEach.call` 的时候实际上会比属性方法调用 `forEach` 效率更差

  ```javascript
  const logArgs = (...args) => {
    args.forEach((value, index) => {
      console.log(`${index}: ${value}`);
    });
  };
  logArgs("a", "b", "c");
  // This logs '0: a', then '1: b', and finally '2: c'.
  // 这个例子是想说明 ES6 的 rest parameters 可以更好的代替 arguments 对象（别用啦）
  ```

- Avoid polymorphism：避免数组的多态性，文中用 `each` 这个例子说明了 v8 会对同一个函数接受的数组类型进行 IC（inline-cache），不同元素类型的数组会导致调用时的额外开销，如果相同则可以通过 IC 进行代码复用（生成码）

- Avoid creating holes：数组有 hole 实际上在生产中并不会造成很大的性能损失！尽可能的按照 literal 的方式声明，而不是用 `new Array`，因为他一开始就被定义为 holey 数组，并且不可逆转

  ```javascript
  const array = new Array(3);
  // The array is sparse at this point, so it gets marked as
  // `HOLEY_SMI_ELEMENTS`, i.e. the most specific possibility given
  // the current information.
  array[0] = "a";
  // Hold up, that’s a string instead of a small integer… So the kind
  // transitions to `HOLEY_ELEMENTS`.
  ```

文章最后给了如何 debug 类型元素的方法

### [v8 shape inline cache](https://mathiasbynens.be/notes/shapes-ics)

视频来自 JS Conf EU 2018

Chrome、Firefox、Edge、Safari 都有各自的 js engine

还是聚焦于 js 的对象，js 引擎可以通过对象的“形状（shape）”，也叫 hidden class

对象的基本操作就是访问属性了，在引擎层是一个寻址的过程，多个结构相同的对象之间可以共享一个 shape，这样就能节省很多空间

transition chain：当对象的结构（shape）发生变化时，会通过一个链式的结构去记录**增量**的变化，每个结点会指向他前一次变化的节点，每一个节点都包含了新增的属性和他们所在的 offset，通过这个 offset 就可以寻址到 value

transition tree：相同结构开始的不同对象，分别增加不同的属性，构造一棵树的 transition chain

属性访问过程：

`a = {x: 1}; a.x = 6; b = {p: 12, x: 3};` 这样的情况，其实就有两颗根节点（`{x}` 和 `{x, p}`）

当继续添加 `b.y = 4; b.z = 3` b 的 chain 就会从 `{x, p} -> {y} -> {z}`，同理 a 也增加 z 和 y 和 p 属性 `{x} -> {y} -> {z} -> {p}`，访问 `a.z` 的时候，就从 p 一路向上寻找到 z，其实会比 `b.z` 访问多一次，也就慢一些

访问 `b.z`：

1. 找到 b 对象对应的 hiddenClass（shape）
2. 在 shape 上寻找他的 z（back chain look up）
3. 找到 z 属性的 offset 信息
4. 通过 offset 找到对应的 value

inline-cache：**记忆从哪里去寻找 js 对象属性的信息**，不用每次都进行很复杂的向上寻找

- 对于 Object：根据相同的 shape 缓存每个属性的 offset 信息，直接寻址
- 对象的 shape 变化，就会导致 IC 失败，需要重新进行缓存
- 对于 Array：之前也学到过数组的 shape 会有 `length` 属性，其元素是放在 elements store 去存储的，不会存储属性值
  - 如果用了 `Object.defineProperty` 在数组上（别这么做！），Elements store 实际上会变成一个 dictionay，key 是数组下标，value 是对应元素（常规的属性，enumable/configurable/writable）

视频也只是对 hiddenClass 和 inline cache 的概念做一个初步的介绍，并且给出了一些编码建议（基于 vm 优化特性）：

- 让 js 对象的 shape（结构）尽可能保持不变，让 hiddenClass 保持不变
- `Object.defineProperty` 别在数组上使用

BTW 视频还是非常不错的！

### [v8 更快的访问 super 属性](https://v8.dev/blog/fast-super)

super 关键字可以访问 class 的父类上的属性，依旧是用了 IC(inline cache)（还得去详细学习下）

class 继承的最根本基础还是原型链！

```javascript
class A {}
A.prototype.x = 100;

class B extends A {
  m() {
    return super.x;
  }
}
const b = new B();
b.m();
```

这里的 B 继承 A，所以 `B.prototype.__proto__` 指向 `A.prototype`，b 是 B 的实例所以 `b.__proto__` 指向 `B.prototype`，执行 `m()` 寻找 `super.x` 的过程就是

1. 从 _home object_（这里就是 m 所定义的对象 `B.prototype`），目标就是让访问 `super.x` 的过程变得更快！
2. 这个 case 中，x 是很快就能被访问到的，但是很多情况可能需要 look up 通过很长的 prototype chain 才能寻找到，此时就需要用 IC 进行加速
3. 另说一下，这里即使 `B.prototype` 有 `x` 也不会去找的，因为 `super` 是从 home object 的 `__proto__`（也就是 `B.prototype.__proto__`）去找，receiver 就是访问 super 函数的调用者（receiver）
4. 实现细节：
   1. [Ignition](https://v8.dev/docs/ignition) bytecode, `LdaNamedPropertyFromSuper`, a new IC, `LoadSuperIC`, for speeding up super property loads.
   2. `LoadSuperIC` reuses the existing IC machinery for property loads, just **with a different lookup start object**.
   3. 具体代码在 [`JSNativeContextSpecialization::ReduceNamedAccess`](https://source.chromium.org/chromium/chromium/src/+/master:v8/src/compiler/js-native-context-specialization.cc;l=1130)，chromium 项目的在线编辑器，搜索代码比较方便（虽然看不懂代码）
5. 最后有一些场景可能是 vm 优化不到的，比如直接给 `super.x = ...` 修改了。或者用 mixin 方式会把 inline cache 变成全局的 cache (megamorphic)就慢了点

### [v8 对象属性访问](https://v8.dev/blog/fast-properties)

V8 是如何处理动态新增的属性，让其的访问也能快速

named properties（具体的 key）和元素（数组，整数下标）

两者存储的形式类似，都是连续的数组 or 字典，两者的存储是独立分开的

```javascript
JS Object
- hiddenClass
- properties
- elements
HiddenClass
- bit field 1 // 并不是 1 bit 而是一种结构体
- bit field 2
- bit field 3 // 这个结构中存了属性的数量 和 descriptor array 的指针
```

HiddenClass：meta data，存储了一个对象的形状信息（shape）以及属性名到下标的映射

- 属性的数量
- 指向原型的引用
- 随着对象的变化会动态更新
- 相同构造的对象共享同一个 HiddenClass
- V8 内部用一个 transition tree 来连接所有 HiddenClass，这样只要是按照一样的属性增加的顺序，最终得到的 HiddenClass 也是同一个（类似状态机流转状态，单向图），每次新增一个属性都会创建一个新的 hiddenClass
- 增加数组的下标属性不会增加 hiddenClass，因为是存在另一个独立的 elemenst 区域
- 指向 descriptor 数组记录了属性名和位置，以及值存在哪里

**三种属性类型**

in-object 属性 vs. 普通属性

- in-object 是 v8 访问最快的属性，直接存储在对象内部
  - 数量是由对象初始化的结构决定的
- 普通属性：运行时新增的属性被加入到 **属性存储区**，多一层间接访问

普通属性又分：fast 属性 vs. slow 属性

- fast：在 **属性存储区** 中可以线性访问的属性（直接通过下标）
- slow：有慢属性的对象有一个内置的字典作为属性存储（不会在 HiddenClass 上共享），属性增加和移除是不会更新 HiddenClass 的，同时 inline cache 也不能作用，所以访问慢，但是增加和删除的效率高（不用改 hiddenClass）

```javascript
Named Property:
1. in-object -> directly on the obj
2. Fast -> properties store; meta info -> descriptor array(HiddenClass)
3. Slow -> properties dictionary
```

**对于数组元素**

如果数组中间有 hole `[1,,3]` 这样，对于下标 1 的访问会去 prototype 上的 elements 找，对于 elements 来说，也是 self-contained 的，不会在 HiddenClass 上共享

如果知道数组对象上没有 hole 就能认为是 packed 的，能够提升访问效率（不会去原型上找）

有 20 种数组[元素类型](https://v8.dev/blog/elements-kinds)。。。为的是 VM 可以根据特定的类型进行访问的加速。

Fast or Dictionary 元素：

- Fast：简单的 VM 数组结构
- Slow：稀疏数组会通过字典来节省内存

```javascript
const sparseArray = [];
sparseArray[9999] = "foo"; // Creates an array with dictionary elements.
```

Smi and Double Elements

- Smi(Small Integers)，纯整数数组，整数是直接 encode 在数组中的，不会经历 GC
- Double，纯浮点数数组 V8 stores raw doubles for pure double arrays to avoid memory and performance overhead

```javascript
const a1 = [1, 2, 3]; // Smi Packed
const a2 = [1, , 3]; // Smi Holey, a2[1] reads from the prototype
const b1 = [1.1, 2, 3]; // Double Packed
const b2 = [1.1, , 3]; // Double Holey, b2[1] reads from the prototype
```

每一种类型其实都通过 C++ 实现的 ElementsAccessor（基于 [CRTP](https://en.wikipedia.org/wiki/Curiously_recurring_template_pattern)），没有深入了解。简单来说像是一个代理，决定是哪种类型的数组。

知道如何访问属性是在 V8 中优化的关键，可以知道为什么某些代码写出来就是快！

### [v8 hash code](https://v8.dev/blog/hash-code)

v8 官方 blog

ES 2015 引入了一些新的数据结构比如 Map Set WeakSet WeakMap，这些底层其实都是用 hash table 实现的。这篇博文介绍了

- Hash Code 是什么：
  - hash function 将一个 key 映射成 hash table 中的一个位置（下标、...）
  - hash code 就是 hash function 执行之后的结果
  - V8 中 hash code 就是一个随机的数字，独立于对象，必须存起来（每个对象可以有一个）
  - 是对象一个类似 `Symbol` 的 privite key，但是不会暴露给用户侧的 js
  - 并且这个 hash code 是当对象需要它时才会计算和存储，不用到的时候可以节省空间
  - V8 优化查找这个 hash code 的方式是一样的用 monomorphic IC lookups，inline-cache!（当对象有相同的 hidden class），但是大多数情况都不能满足，就会 megamorphic IC lookups（可以理解是全局的 cache？比较慢了）
  - 访问这个 prvite symbol 也会触发 hidden class transition
- JS Object 背后如何存数据的
  - one word for storing a pointer to the **elements backing store**, and another word for storing a pointer to the **properties backing store**.
    - elements：就是数组的元素，在内部也是类似数组的结构
    - properties：属性值，string or symbols
- 如何存(hide) hash code
  - 存在 elements，因为数组是不定长，总会浪费空间
  - 所以会存在 properties 的空间：数组 or 字典
    - 空。无 properties
    - array（最大限制 1022 个，超过后 V8 会转成 dictionary 存）
    - dictionary（会新开辟一个空间，但是问题不大）
- 三种方式存储之后，得到的结果是：hash code 的 lookup 不需要和 js 对象属性访问那么复杂了！

小结：

- Map 为什么能比对象取 key 更快？就是因为读取的是元素的 hash code，hash code 又通过上述存储方式可以比常规属性访问快速很多！
- 个人假想：`Map.set(key, value)` 的时候，是先获取 key 的 hash code，将 value 存在 hash table，get 取的时候也直接取 key 的 hash code（很快），所以 Map 的存取操作非常快 O(1)。任何字面量/常量的 hash code 应该也是一样的？或者说存储的地方也是同一个，保证 `getHash(true) === 'xxxx'`
- 个人假想：Map 的 key 为啥是有序的，内部通过数组来存的 key 的引用？Remained Problem
