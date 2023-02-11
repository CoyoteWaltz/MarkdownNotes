# 收集一些有用/有趣的 types

### 部分属性 partial/required

> 参考：https://stackoverflow.com/questions/53741993/typescript-partially-partial-type

挑选对象中某几个 key 变成 partial or required

```typescript
type PickPartial<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>> &
  Partial<Pick<T, K>>;

type PickRequired<T, K extends keyof T> = Pick<T, Exclude<keyof T, K>> &
  Required<Pick<T, K>>;
```





### setTimeout 的返回值类型？

我遇到了在这篇 [stackoverflow](https://stackoverflow.com/questions/51040703/what-return-type-should-be-used-for-settimeout-in-typescript) 上同样的问题

```TypeScript
const timer: ReturnType<typeof setTimeout> = setTimeout(() => '', 1000);
```

### 改字段的类型

```typescript
type ModifyPropType<Base, Props extends keyof Base, NewType> = Omit<Base, Props> & {
    [k in Props]: NewType;
};

type demo = ModifyPropType<{
	id: number
}, 'id', string>,
```

### 关于 enum

Enum to union：`typeof keyof ENUM`

普通 enum 的真正编译结果

```TypeScript
enum K {
    a = 1,
    b,
    c
}
```

⬇️

```JavaScript
var K;

(function (K) {
    K[K["a"] = 1] = "a";
    K[K["b"] = 2] = "b";
    K[K["c"] = 3] = "c";
})(K || (K = {}));
```

const enum 在编译的时候直接会把对应的值取过去

### 取 enum 的 key 的 string 值

（其实和 object 一样，传入对应的 key 即可）

Enum 可以被 `Object.entries` 调用，返回 `[[key, value], ...]`

```TypeScript
enum GenderEnum{
  'male' = '男生',
  'female' = '女生'
}

interface IPerson{
   name:string
   gender:keyof typeof GenderEnum // 如果需要用到 枚举的 key
}

let bob:IPerson = {name:"bob",gender:'male'}

<span>{Gender[bob.gender]}</span>  
```

### 封装条件守卫，便于后续不必要的断言

```TypeScript
function IsString (input: any): input is string { 
    return typeof input === 'string';
}

function foo (input: string | number) {
     if (IsString(input)) {
        input.toString() //被判断为string
     } else {
     }
}
```

### 数组长度生成 union type

*想用数组的 length 生成一个 union type，比如 length = 4 -> type N = 0 | 1 | 2 | 3，这样有可能吗？*

来自 nihouze 大佬的第一版

```TypeScript
type StrIndex<T extends readonly any[]> = Exclude<keyof T, keyof any[]>; // 数组下标的 union string 类型 [1, 2, 3] -> '0' | '1' | '2'
```

第二版

```TypeScript
// 利用递归 数组长度减少来实现 ts 4.1 above

type Tail<T> = T extends [any, ...infer R] ? R : never;

type Length<T extends any[]> = T["length"];

type Cool<Arr extends any[]> = Tail<Arr> extends never

  ? []

  : [Length<Tail<Arr>>, ...Cool<Tail<Arr>>];

type Fin<T extends any[]> = Cool<T>[number];

type D = Fin<[4, 5, 6]>; // 0 | 1 | 2
```

太妙了！！大佬牛逼！