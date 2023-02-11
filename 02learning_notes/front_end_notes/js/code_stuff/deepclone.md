# 关于深浅 copy

### 深拷贝

#### structuredClone

> 参考[这篇](https://www.builder.io/blog/structured-clone)，[MDN](https://developer.mozilla.org/en-US/docs/Web/API/structuredClone)
>
> 是 JS built-in 的方法，能够做到真正的深拷贝

和其他方法的比较：

- `JSON.parse/JSON.stringify`：太 tricky 了，一些对象被 string 之后再转回去就有问题了（比如 Date）
- `lodash/deepClone`：js 实现，性能开销肯定比原生大，第三方库代码体积大

有哪些对象是不能被 clone 的：（会抛 `DataCloneError`）

- functions
- DOM nodes
- getter & setter
- Object prototypes：比如一个 class

[可以被 clone 的类型](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Structured_clone_algorithm#supported_types)

兼容性：

- 算是比较新的特性（chrome 98、ff 94）
- node 要 17 才支持
- polyfill 的话，core-js 支持

#### 手写代码（weakmap）

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

有多种方法，解构展开、assign、create、...当然里面的引用指针也被 copy 了一份一样的地址

```js
const shallowCopy = { ...simpleEvent };
const shallowCopy = Object.assign({}, obj);
const shallowCopy = Object.create(simpleEvent);
```
