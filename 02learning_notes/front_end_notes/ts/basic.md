# TS Handbook

https://www.typescriptlang.org/docs/handbook/basic-types.html

TS 不多介绍了，本文只记录一些值得注意的点以及新的特性

> - 2022.12.09 14:46:57 的一点思考：
>   - 学 TS 到底是在学他的什么东西？
>     - TS 存在的意义？类型检查（安全性）、代码提示（便利性）、类型友好（API）、...
>     - 从一开始学如何写类型，能够更好保证类型教研
>     - 更好的推导类型，类型编程，开始做体操（目前自己所在的阶段）
>     - 类型背后的本质、理念、源码
>     - 其他的一些“类型周边”：npm 包的类型，eslint，tsc，...
>     - ...

## Basic types

### Any

ts 可谓一绝的类型，能够 opt-in and opt-out 类型检查，也就意味着只要给 any，就不会再编译前进行类型检查。。。全部都给`any`类型的话就毫无意义了。。

_opt-in/opt-out: 选择加入/退出_

也许认为用`Object`类型能够赋值任何的类型（反正都是引用嘛），但是就不能调用某些类型的特定方法了

```typescript
let a: Object = 123.123;
// a.toFixed(4); // 报错Property 'toFixed' does not exist on type 'Object'.
// let b: object = 123; // 报错类型不匹配
```

**并且 Note**: Avoid using `Object` in favor of the **non-primitive** `object` type as described in our [Do’s and Don’ts](https://www.typescriptlang.org/docs/handbook/declaration-files/do-s-and-don-ts.html#general-types) section.

不要用`Object`，而用`object`，原因是小写的是大写的类型 notion，大写的其实被认为都是`Object`类型（functuon），反正就用`typeof`得到的类型表示即可

同样在声明数组的时候非常有用

```typescript
let arr: any[] = [1, "2", 33];
```

### Enum

枚举类型也有了哈，也是默认从 0 开始的，后续枚举都是自增 1，对枚举对象访问属性的值即可获得属性名，获取不到的自然就是 undef 了

```typescript
enum Gender {
  Boy = 1.2,
  Girl,
  Alien,
}

interface Person {
  sex: Gender;
}
let sex: Gender = Gender.Boy;
console.log(sex); // 1.2
console.log(Gender.Alien); // 3.2
console.log(Gender.Boy); // 1.2
console.log(Gender.Girl); // 2.2
console.log(Gender[1.2]); // Boy
console.log(Gender[2.2]); // Girl
console.log(Gender[3.2]); // Alien
```

#### 深入 enum

**Enum to Union** 可以通过：`typeof keyof ENUM`

**普通 enum 的真正编译结果**

```TypeScript
enum K {
    a = 1,
    b,
    c
}
```

⬇️ 双向赋值 key value

```JavaScript
var K;

(function (K) {
    K[K["a"] = 1] = "a";
    K[K["b"] = 2] = "b";
    K[K["c"] = 3] = "c";
})(K || (K = {}));

// K 其实长这样
{
  "1": "a",
  "2": "b",
  "3": "c",
  "a": 1,
  "b": 2,
  "c": 3
}
```

const enum 在编译的时候直接会把对应的值取过去

**取 enum 的 key 的 string 值**

（其实和 object 一样，传入对应的 key 即可）

Enum 可以被 `Object.entries` 调用，返回 `[[key, value], ...]`（**但注意上头的双向 key value 情况，不是常规的对象！用 findIndex 之类的可能会不符合预期**）

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

### Void

`any`的反面， the absence of having any type at all

既然没有类型，就是`undefined`（或者`null`，如果没有`--strickNullChecks`指明）

### Null and Undefined

都有对应的类型名了，我们只能对应的赋值。。。没啥大用

`null`和`undefined`

不过这两个类型是其他所有类型的字类型，这样就可以给任意类型赋值`null`或者`undefined`，但是`interface`不可以

_如果`tsc --strictNullChecks`的情况下，只能将`null`和`undefined`赋值给其对应的类型或者是`void`_

推荐尽可能用`--strictNullChecks`，保障强类型检查

### Never

表示从未出现过的类型

For instance, `never` is the return type for a function expression or an arrow function expression that always throws an exception or one that never returns;

```typescript
function ff(): never {
  throw new Error();
}
// 只会抛出异常的函数都返回 never 类型 自动推断
const f = () => {
  throw new Error();
}; // const f: () => never
```

职位描述

1、负责产品研发和工程架构部相关产品迭代改进及移动新产品的开发； 2、优化前端功能设计，解决各种浏览器和终端设备的兼容性问题； 3、通过技术手段，提升用户体验并满足高性能要求。

职位要求

1、本科及以上学历，2021 年应届毕业生； 2、熟练掌握计算机相关的基础知识，具备扎实的数据结构和算法基础； 3、熟悉前端领域相关的知识，如 HTML、CSS、JavaScript 等； 4、具备良好的沟通协作和解决问题能力，热爱技术，责任心强。 加分项： 1、有相关的实习经历、开源项目、个人博客等； 2、有良好的编程习惯和经验，有任意后端的项目经验。

是所有类型的子类型

### Type assertion

类型断言？感觉叫检查会比较好？

为什么要用它？因为我们有时候会比 TypeScript 的编译器更加清楚某个变量的用途（通常是对类型的更加明确，比如有些变量是 any 类型，但是在其他地方必须是 string 才能用）

形式类似其他语言的类型转换，但是在 TS 中只是对类型进行检查，在运行时不影响（不重构数据比如内存分配啥的），仅仅只给编译器用的

两种等价方法：

- `<type>`

  ```typescript
  let sss: any = "adfadsfdsf";
  sss = 123;
  let len: number = (<string>sss).length;
  // let len: number = sss.length;
  console.log(len);
  ```

- `as`（jsx 中的 TS 仅支持 `as`）

  ```typescript
  let len: number = (sss as string).length;
  ```

虽然还不知道什么时候用的到。。

## 变量声明

官方文档提到了`let`声明的变量在嵌套作用域的时候能够*shadow*外层的变量，看一个例子

```typescript
function sumMatrix(matrix: number[][]) {
  let sum = 0;
  for (let i = 0; i < matrix.length; i++) {
    var currentRow = matrix[i];
    for (let i = 0; i < currentRow.length; i++) {
      // 注意这里也是 i
      console.log(i);
      sum += currentRow[i];
    }
  }

  return sum;
}
let res: number = sumMatrix([
  [1, 2, 3, 4, 5],
  [1, 2, 3, 4, 5],
  [1, 2, 3, 4, 5],
  [1, 2, 3, 4, 5],
]);

console.log(res); // 60
```

所以这个*shadow*，很有意思，用影子遮住了外层的`i`，只让当前的`i`发挥作用

// @ts-ignore

## interface

“鸭式辩形”来做类型检查（只要满足形状即可）

- 可选属性
- 属性无排序要求
- 只读属性：在属性前加`readonly`，修改该属性会报错

```typescript
interface SquareConfig {
  name: string;
  color?: string;
  width?: number;
  readonly border: boolean;
}
```

### 函数类型

```ts
interface Foo {
  (a: string): string; // 形参列表: 返回类型
}
```

```typescript
type Foo = (a: string) => string;
```

### `ReadonlyArray<T>`

TypeScript comes with a `ReadonlyArray<T>` type that is the same as `Array<T>` with all mutating methods removed, so you can make sure you don’t change your arrays after creation:

不能修改的数组（注意这还是个泛型）

```typescript
let a: number[] = [1, 2, 3, 4];
let roa: ReadonlyArray<number> = a;
roa.pop(); // 报错
a = roa; // 报错
a = roa as number[]; // 这是可以的
```

注意上面这个例子是共享内存的

#### `readonly` vs `const`：

Variables use `const` whereas properties use `readonly`.

readonly 当然是给属性的啊

### option bags

看个例子来理解一下

```typescript
interface SquareConfig {
  // 这就是一个 option bag
  color?: string;
  width?: number;
}

function createSquare(config: SquareConfig): { color: string; area: number } {
  return { color: config.color || "red", area: config.width || 20 };
}

let mySquare = createSquare({ colour: "red", width: 100 });
```

注意最后一行的属性是**colour**，此时编译器会报错提示我们是不是要输入 color，这种单词拼错是我们在 js 中经常会造成的 bug！

注意我们可能会认为`colour`是一个附加属性，并且`width`是符合的，但是 TS 这里会将作为参数的对象每个属性进行类型检查。

> Object literals get special treatment and undergo _excess property checking_ when assigning them to other variables, or passing them as arguments. If an object literal has any properties that the “target type” doesn’t have, you’ll get an error:

就不要写其他属性`createSquare({color: 'black'})`

当然要绕过这种检查也很简单：用断言告诉编译器我明白他的类型

```typescript
let mySquare = createSquare({ width: 100, opacity: 0.5 } as SquareConfig);
```

当然也有更好的方法，指明一个任意类型的属性

```typescript
interface SquareConfig {
  color?: string;
  width?: number;
  [propName: string]: any;
}
```

> Keep in mind that for simple code like above, you probably **shouldn’t be trying to “get around” these checks**. For more complex object literals that have methods and hold state, you might need to keep these techniques in mind, but a majority of excess property errors are actually bugs. That means if you’re running into excess property checking problems for something like option bags, you might need to revise some of your type declarations. In this instance, if it’s okay to pass an object with both a `color` or `colour` property to `createSquare`, you should fix up the definition of `SquareConfig` to reflect that.

### Function Types

函数类型用函数签名来定义，啊，好怀念啊 C++ 的说法，函数签名：形参列表 + 返回值类型（决定了函数的唯一性）

```typescript
interface SearchFunc {
  (source: string, subString: string): boolean;
}
```

其实函数也是一个对象嘛，他的属性有形参列表，返回值就作为他的值（这样去理解）

```typescript
let myfunc: SearchFunc = (s: string, ss: string) => {
  const idx: number = s.search(ss);
  return true;
};
```

### Indexable Types

能够用下标访问的类型，比如`a[10]`

```typescript
interface StringArray {
  [index: number]: string;
}

let sa: StringArray;

sa = ["aaa ", "bvvv"];
```

index signature

_学语言挺快乐的，能感受到开发语言的人对语言的一些微妙定义、概念，很有意思_

**注意：**index 的访问其实在 js 中也是转为字符串的，所以用 number 和 string 作为键的类型都是一样的，但是两者同时出现的情况下，需要满足 number key 的类型是 string key 的子类型，因为 number 会转换为 string，也希望下面的 Dog 能转换为 Animal

```typescript
interface Animal {
  name: string;
}

interface Dog extends Animal {
  breed: string;
}

// Error: indexing with a numeric string might get you a completely separate type of Animal!
interface NotOkay {
  [y: number]: Animal;
  // Numeric index type 'Animal' is not assignable to string index type 'Dog'.
  [x: string]: Dog;
}

interface okay {
  [y: string]: Animal;
  [x: number]: Dog; // 这样就 ok
}
```

### Class 实现 接口

a class meets a particular contract，满足接口的定义

`implements`

```typescript
interface ClockInterface {
  currentTime: Date;
  setTime(d: Date): void;
}

class Clock implements ClockInterface {
  currentTime = new Date();
  setTime(d: Date) {
    this.currentTime = d;
  }
  constructor(hour: number, minute: number) {}
}
```

注意这里的接口只能规定可拥有的 public 属性，不能用来检查私有成员

同时当类实现接口的时候，只有实例会被检查类型

> **This is because when a class implements an interface, only the instance side of the class is checked.**

所以当实现的接口有构造函数（这个属于静态的部分），实例侧是检查不到的，就报错了。

```typescript
interface ClockConstructor {
  new (hour: number, minute: number);
}

class Clock implements ClockConstructor {
  // Class 'Clock' incorrectly implements interface 'ClockConstructor'.
  currentTime: Date;
  constructor(h: number, m: number) {}
}
```

看来自官网的下面一个例子

```typescript
// 这个接口 定义的 是一个 函数 返回的是 ClockInterface 类型
interface ClockConstructor {
  new (hour: number, minute: number): ClockInterface;
}

interface ClockInterface {
  tick(): void;
}

function createClock(
  ctor: ClockConstructor, // 接受一个构造函数
  hour: number,
  minute: number
): ClockInterface {
  return new ctor(hour, minute);
}
// 只需要实例满足有 tick
class DigitalClock implements ClockInterface {
  constructor(h: number, m: number) {}
  tick() {
    console.log("beep beep");
  }
}
// 只需要实例满足有 tick
class AnalogClock implements ClockInterface {
  constructor(h: number, m: number) {}
  tick() {
    console.log("tick tock");
  }
}

let digital = createClock(DigitalClock, 12, 17);
let analog = createClock(AnalogClock, 7, 32);
```

### 扩展接口

`extends`_感觉更像是融合类型到一起_，就是继承吧

```typescript
interface Shape {
  color: string;
  // penWidth: string; // 下面扩展的时候会报错 类型不一样不能合并
}

interface PenStroke {
  penWidth: number;
}
// 同时扩展可写一起
interface Square extends Shape, PenStroke {
  sideLength: number;
}

// let square = {} as Square;
let square: Square = {} as Square; // 记得初始化 然后告诉 ts 我知道这个类型
square.color = "blue";
square.sideLength = 10;
square.penWidth = 5.0;
```

### 混合类型

```typescript
interface Counter {
  (start: number): string; // 是一个接受 number 返回 string 的函数类型
  interval: number;
  reset(): void;
}

function getCounter(): Counter {
  let counter = function (s: number) {} as Counter;
  counter.interval = 222;
  counter.reset = function () {};
  return counter;
}

let c = getCounter();
c(10);
c.reset();
c.interval = 5.0;
```

### 接口继承 class

官网的例子看着有些晕

```typescript
class Control {
  private state: any;
}
// 这个接口继承了 Control 类 state 属性是被继承的关系
interface SelectableControl extends Control {
  select(): void;
}

class Button extends Control implements SelectableControl {
  select() {}
}

class TextBox extends Control {
  select() {}
}

class ImageControl implements SelectableControl {
  // Class 'ImageControl' incorrectly implements interface 'SelectableControl'.
  //Types have separate declarations of a private property 'state'.
  private state: any;
  select() {}
}
```

来稍微解释一下，SelectableControl 继承了 Control 类，state 属性是被继承的关系。所以 class 在实现 SelectableControl 的时候必须也是对 state 继承的关系，Button 先继承了 Control 再去实现是 ok 的，然而 ImageControl 有自己的私有属性，并非继承的来，就不行了。

目前先这样看，到时候学 class 的时候深入。。

interface 和 type 的区别：https://zhuanlan.zhihu.com/p/92906055

## Function

由于 git 操作失误，这一节的笔记没了，重头来过还是算了。。。

算了还是快速的 recall 一下

#### 类型推断

```typescript
// typed function variable
// 类型的变量名无所谓的
let add2: (xx: number, yy: number) => number = function (
  x: number,
  y: number
): number {
  return x + y;
};
```

如果变量写了类型，函数实体的类型就不用写了，会自动推断

```typescript
// 变量不给类型的时候也会自动推断的
const pt: (x: string) => void = function (x) {
  console.log(x);
};
```

#### 可选参数和默认值

js 中都是可选参数，默认是`undefined`

```typescript
const greet = (name = ""): void => {
  console.log(`Hello ${name}`);
};
```

有默认值的时候不需要写类型了，会自动推断

#### 剩余参数

```typescript
const sum = (...nums: number[]): number => {
  return nums.reduce((acc: number, x: number): number => acc + x);
};
```

#### this 参数

可以显式传入 this

```typescript
interface Card {
  suit: string;
  card: number;
}

interface Deck {
  suits: string[];
  cards: number[];
  createCardPicker(this: Deck): () => Card; // 返回的是一个 Card creator
}

let deck: Deck = {
  suits: ["hearts", "spades", "clubs", "diamonds"],
  cards: Array(52),
  createCardPicker: function (this: Deck) {
    // return function () {
    // 这里用 arrow function 就可以了
    return () => {
      let pickedCard = Math.floor(Math.random() * 52);
      let pickedSuit = Math.floor(pickedCard / 13);

      return { suit: this.suits[pickedSuit], card: pickedCard % 13 };
    };
  },
};
```

#### 重载

为什么需要？当一个函数根据条件判断返回不同类型的值的时候，ts 没办法做类型推断了，此时可以用重载告诉 ts 不同情况下对应参数的类型

```typescript
function pickCard(x: { suit: string; card: number }[]): number;
function pickCard(x: number): { suit: string; card: number };
function pickCard(x: any): any {
  // Check to see if we're working with an object/array
  // if so, they gave us the deck and we'll pick the card
  if (typeof x == "object") {
    let pickedCard = Math.floor(Math.random() * x.length);
    return pickedCard;
  }
  // Otherwise just let them pick the card
  else if (typeof x == "number") {
    let pickedSuit = Math.floor(x / 13);
    return { suit: suits[pickedSuit], card: x % 13 };
  }
}

let myDeck = [
  { suit: "diamonds", card: 2 },
  { suit: "spades", card: 10 },
  { suit: "hearts", card: 4 },
];

let pickedCard1 = myDeck[pickCard(myDeck)];
alert("card: " + pickedCard1.card + " of " + pickedCard1.suit);

let pickedCard2 = pickCard(15);
alert("card: " + pickedCard2.card + " of " + pickedCard2.suit);
```

## Literal Types

字面量类型（这节笔记也丢了。。下面是重来的）

### let const

`let`声明的变量说明这个变量的内容有可能会被改变，所以 ts 会设定类型

`const`声明的变量不会改变了，所以 ts 会直接设定他的内容。可以在 vscode 悬浮在变量上看

### string literal types

```typescript
type Easing = "ease-in" | "ease-out" | "ease-in-out";
```

可以作为枚举类型用

同样 数值型也可以

布尔型也可以

```typescript
interface ValidationSuccess {
  isValid: true; // 定死了？
  reason: null;
}

interface ValidationFailure {
  isValid: false;
  reason: string;
}

type ValidationResult = ValidationSuccess | ValidationFailure;

let succ: ValidationSuccess = {
  isValid: true,
  reason: null,
};
```

## Unions and Intersection Types

类型的并集和交集：为了能够更好的利用和组合已有的类型，而不用重新在写类型了

### Union Types

看下面这个函数

```typescript
const padLeft = (value: string, padding: any): string => {
  if (typeof padding === "number") {
    return Array(padding + 1).join(" ") + value;
  }
  if (typeof padding === "string") {
    return padding + value;
  }
  throw new Error("padding type not match");
};
```

对一个字符串做 pad left 操作，可以接受数字（pad 空格）或者字符串（拼接）

此时 padding 的类型是 any，意味着给一个 true 都是不会被类型检查出来的。。`const res = padLeft('yes ok', true)`

此时我们就可以用联合类型了

```typescript
const padLeft = (value: string, padding: string | number): string => {
  ...
```

### Union types with commom field

官网的例子

```typescript
interface Bird {
  fly(): void;
  layEggs(): void;
}

interface Fish {
  swim(): void;
  layEggs(): void;
}

declare function getSmallPet(): Fish | Bird;

let pet = getSmallPet();
pet.layEggs();

// Only available in one of the two possible types
pet.swim(); // 报错了
```

此时 pet 编译器无法确认到底是 Bird 还是 Fish，所以只能调用他们共有的字段。

### intersection types

将几个类型整合到一起

```typescript
interface ErrorHandling {
  success: boolean;
  error?: { message: string };
}

interface ArtworksData {
  artworks: { title: string }[];
}

interface ArtistsData {
  artists: { name: string }[];
}

// These interfaces are composed to have
// consistent error handling, and their own data.

type ArtworksResponse = ArtworksData & ErrorHandling;
type ArtistsResponse = ArtistsData & ErrorHandling;

let ar: ArtworksResponse = {
  success: false,
  artworks: [{ title: "123" }],
};
```

## Class

TS 在 ES6 之上加了一些强制限制

### inherit

- 继承的时候，子类构造函数必须用`super`函数初始化父类

### Public, private, and protected modifiers

ES6 居然有 private 属性的写法？

```javascript
class MyClass {
  a = 1; // .a is public
  #b = 2222; // .#b is private
  static #c = 3; // .#c is private and static

  incB() {
    this.#b++;
  }

  ptC() {
    console.log(this.#b);
    console.log(MyClass.#c);
  }
}
```

但是，ts 好像不支持 static 同时修饰 private 变量...

ts 支持 es6 的`#privateFeild`，也支持`private`修饰。

注意在 ts 中`private`和`protected`在进行两个类类型比较的时候也会参与比较

protected 修饰和其他 oop 语言一样，只能通过子类内部去获取

readonly 也支持

### Parameter properties

参数的属性，发生在构造函数接受的参数上，声明了属性可以直接完成类属性的初始化

```typescript
class Octopus {
  readonly numberOfLegs: number = 8;
  constructor(readonly name: string, public age: number) {}
  sayName() {
    console.log(this.name, this.age);
  }
}

let dad = new Octopus("Man with the 8 strong legs", 123);
dad.sayName();
```

有点方便啊。。

### get & set

支持

### Static property

支持

### Abstract class

抽象类

基类，写 abstract 函数（就是 virtual 函数），子类具体的去实现

### Class as an interface

```typescript
class Point {
  x: number;
  y: number;
}

interface Point3d extends Point {
  z: number;
}

let point3d: Point3d = { x: 1, y: 2, z: 3 };
```

## Namespace

> [文档](https://www.typescriptlang.org/docs/handbook/namespaces.html)

TS1.5 之前是叫做内部模块，后续改成了 `namespace` 关键字

目的也比较明确：分割类型/变量/方法/...的作用域，在 `namespace` 里面导出的通过 `Namespage.xxx` 引入

第二就是对于大项目需要拆分文件的情况，

```typescript
// Validation.ts
namespace Validation {
  export interface StringValidator {
    isAcceptable(s: string): boolean;
  }
}

// LettersOnlyValidator.ts
/// <reference path="Validation.ts" />
namespace Validation {
  const lettersRegexp = /^[A-Za-z]+$/;
  export class LettersOnlyValidator implements StringValidator {
    isAcceptable(s: string) {
      return lettersRegexp.test(s);
    }
  }
}
```

用的时候

```typescript
// <reference path="Validation.ts" />

/// <reference path="LettersOnlyValidator.ts" />
// ...
```
