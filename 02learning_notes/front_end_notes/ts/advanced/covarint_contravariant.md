# 协变与逆变

> 非常陌生和高冷的两个词，深入 ts 的过程中遇到的词，究竟是什么意思呢
>
> 理解起来非常像是在学数学
>
> 学完之后能干嘛？
>
> 参考：
>
> - [blog](https://github.com/sl1673495/blogs/issues/54)
> - [协变与逆变](https://messiahhh.github.io/blog/docs/typescript/%E9%80%86%E5%8F%98%E4%B8%8E%E5%8D%8F%E5%8F%98)
> - [wikipedia](https://zh.wikipedia.org/wiki/%E5%8D%8F%E5%8F%98%E4%B8%8E%E9%80%86%E5%8F%98)

## Intro

> 以下内容摘自维基百科

例如，如果`Cat`是`Animal`的子类型，那么`Cat`类型的表达式可用于任何出现`Animal`类型表达式的地方。所谓的**变型**（variance）是指**如何根据组成类型之间的子类型关系，来确定更复杂的类型之间的子类型关系**。

- `IEnumerable<Cat>`是`IEnumerable<Animal>`的子类型，因为类型构造器`IEnumerable<T>`是协变的（covariant）。注意到复杂类型`IEnumerable`的子类型关系和其接口中的参数类型是一致的，亦即，**参数类型之间的子类型关系被保持住了**。

- `Action<Animal>`是`Action<Cat>`的子类型，因为类型构造器`Action<T>`是逆变的（contravariant）。（在此，`Action<T>`被用来表示一个参数类型为`T`或`sub-T`的[一级函数](https://zh.wikipedia.org/wiki/一級函數)）。注意到**`T`的子类型关系在复杂类型`Action`的封装下是反转的**，但是当它被视为函数的参数时其子类型关系是被保持的。

- `IList<Cat>`或`IList<Animal>`彼此之间没有子类型关系。因为`IList<T>`类型构造器是不变的（invariant），所以参数类型之间的子类型关系被忽略了。

## 子类型

首先什么是子类型，形如 `A extends B`，A 的类型值能够赋值给 B 类型，通常对于基础类型可以认为是子集关系

```typescript
declare let a: "name";
declare let b: string;

b = a; // ok a是b的子类型
a = b; // wrong
```

对于对象类型，尝试将对应类型的变量赋值给另一个类型的变量

```typescript
type A = {
  name: string;
  age: number;
};
type B = A & {
  id: number;
};

declare let a: A;
declare let b: B;

a = b; // ok
b = a; // wrong
b.id.toFixed(); // 不存在id字段
```

所以 B 是 A 的子类型，B 比 A 更加具体（属性更多），`B extends A` 成立

- 在类型系统中，属性更多的类型是子类型。
- 在集合论中，属性更少的集合是子集。

也就是说，子类型是父类型的超集，而父类型是子类型的子集，这是直觉上容易搞混的一点。

记住一个特征，子类型比父类型更加**具体**，这点很关键。

## 协变（covariant）

```typescript
type A = {
  name: string;
  age: number;
};
type B = A & {
  id: number;
};

declare let a: A;
declare let b: B;

type Test<T> = {
  value: T;
};

declare let c: Test<A>;
declare let d: Test<B>;

d = c; // wrong
d.value.id.toFixed(); // 不存在id字段

c = d; // ok
c.value.name.toString();
```

可以看出：A 是 B 的子类型，泛型类型 `Test<T>` 生成的 c，d 赋值的关系可以知道的是：`Test<A>` 是 `Test<B>` 的子类型

`B`是`A`的子类型，而`Test<B>`又是`Test<A>`的子类型，**所以我们称范型`Test<T>`的类型参数`T`在`value: T`这个位置是协变的。**

所谓协变，也就是子类型关系变化一致？

再看个例子

```typescript
type Fn<T> = () => T;
declare let c: Fn<A>;
declare let d: Fn<B>;
```

结论是：`Fn<T>` 的参数 `T` 在函数返回值这个位置是协变的。

## 逆变（contravariant）

**先说结论，范型的类型参数在函数的参数位置上的逆变的。给定范型`Fn<T> = (arg: T) => void`，如果`B`是`A`的子类型，则`Fn<B>`是`Fn<A>`的父类型。**

着实不懂，但可以通过最开始的赋值关系来判断

```typescript
type A = {
  name: string;
  age: number;
};
type B = A & {
  id: number;
};

declare let a: A;
declare let b: B;

type Fn<T> = (arg: T) => void;
let c: Fn<A> = (arg: A) => console.log(arg.name.toString());
let d: Fn<B> = (arg: B) => console.log(arg.id.toFixed());

c = d; // wrong
// Type 'Fn<B>' is not assignable to type 'Fn<A>'.
//   Type 'A' is not assignable to type 'B'.
//     Property 'id' is missing in type 'A' but required in type '{ id: number; }'.
c(a); // wrong 运行时函数内部访问arg.id报错

d = c;
d(b); // ok 运行时函数内部访问arg.name和arg.age都是安全的
```

可以看到当泛型在函数参数的位置，类型对应变量进行赋值，必须要 B 是 A 的子类型（`B extends A`）？

可以看这个例子

```typescript
interface Animal {
  age: number
}

interface Dog extends Animal {
  bark(): void
}

let visitAnimal = (animal: Animal) => void;
let visitDog = (dog: Dog) => void;
// 其中 Dog extends Animal
```

`animal = dog` 是类型安全的（因为 dog 是 animal 的子类型，animal 所用到的属性 dog 必然都有，所以安全），那么 `visitAnimal = visitDog` 好像也是可行的？其实不然

比如实现如下

```typescript
let visitAnimal = (animal: Animal) => {
  animal.age;
};

let visitDog = (dog: Dog) => {
  dog.age;
  dog.bark();
};
```

在 `visitDog` 中会有 Animal 实例上没有的属性

不过 `visitDog = visitAnimal` 是安全可行的，因为 `visitAnimal` 内部所用到的属性 `visitDog` 内部必然也会有

所以 `type MakeFunction<T> = (arg: T) => void` 父子类型关系逆转了，这就是 **`逆变（Contravariance）`**

## 在 TS 中

当然，在 TypeScript 中，由于灵活性等权衡，对于函数参数默认的处理是 `双向协变` 的。也就是既可以 `visitAnimal = visitDog`，也可以 `visitDog = visitAnimal`。在开启了 `tsconfig` 中的 `strictFunctionType` 后才会严格按照 `逆变` 来约束赋值关系。

## 来点例子

```typescript
type Foo<T> = T extends { a: infer U; b: infer U } ? U : never;
type A = Foo<{ a: string; b: string }>; // string
type B = Foo<{ a: string; b: number }>; // string | number
```

对于上方的范型`Foo<T>`，观察可知类型参数`U`所在的两个位置都是协变的，并且`T`是`{ a: infer U, b: infer U}`的子类型。

所以通过先验知识知道了 `Foo<T>` 的 `U` 是协变的（上一句），那就可以推导出：

- `type A` 的最终是 string
- `type B` 的最终是 string | number，因为 string 既要是 U 的子类型，number 也得是 U 的子类型，所以 `U => string | number` 是联合类型

_速记：同一个类型参数在协变位置上的多个候选将会推导成联合类型_

再来看个

```typescript
type Bar<T> = T extends { a: (x: infer U) => void; b: (x: infer U) => void }
  ? U
  : never;
type A = Bar<{ a: (x: string) => void; b: (x: string) => void }>; // string
type B = Bar<{ a: (x: string) => void; b: (x: number) => void }>; // string & number
```

首先观察得出：`Bar<T>`，观察可知类型参数`U`所在的两个位置都是逆变的。

所以：

- 对于 `type A`，是 string 很好看出
- 对于 `type B`，因为是逆变，所以 `U` 是 a string 的子类型，也得是 b number 的子类型，所以最大边界设定为 `string & number` ？（去 [playground](https://www.typescriptlang.org/play?#code/C4TwDgpgBAQghgJwDwBUB8UC8UVQgD2AgDsATAZygG8o4AuKACnwYEtiAzCBKAVQEosGAG4B7VqQA0UAEYNmbTtz6DMI8aSgBfKAH4+UBsQjDuAbgBQoSFACCWWIiQ16TFlHLAE7AOar1EtJybgye3sR+QlBiEtpoZlBQAPRJHl6+VuDQMA7wyC7y7mG+-tEaQYVGAK4AtjLcpTGaWvGJKWnhPlAAZFDEtfUIFhZAA) 试了下 TS 5.2 推出来是 `never`，我裂开）

_速记：同一个类型参数在逆变位置上的多个候选将会推导成交叉类型_？？

最后，至于为什么“返回值类型是协变的，而参数类型是逆变的”

也就是为什么

```typescript
let returnAnimal = (): Animal => {
  return animal;
};

let returnDog = (): Dog => {
  return dog;
};
// Dog extends Animal
returnAnimal = returnDog; // 合法

let paramAnimal = (a: animal) => {};
let paramDog = (d: Dog) => {};
paramAnimal = paramDog; // 不合法！
```

是考虑安全性的 block 不同：

- 返回值类型时，需要在掉用那个函数的 block 里考虑，相当于自身的类型，return 的那个函数类型和直接放在变量位置 `<T>` 的类型完全等价，所以协变
- 参数类型时，需要考虑的 block 是在等号后面函数，也就是说要在函数调用的过程中去看相当于 `Animal` 赋值给 `Dog`（因为 paramAnimal 接受的参数是 Animal 类型），那显然是不安全的（Dog 是比 Animal 更加具体的类型，访问的属性在 Animal 中不存在），但反过来是安全的。
