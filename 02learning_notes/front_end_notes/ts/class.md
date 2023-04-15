# About Class in TS/JS

### Constructor Assignment: public and private Keywords

可以直接在 constructor 的时候给 public 和 private 属性初始化

```typescript
class TestClass {
  private name: string;

  constructor(name: string) {
    this.name = name;
  }
}

// concise way
class TestClass {
  constructor(private name: string) {}
}
// 同样 public 关键字也能作用
```

### implements 关键字

来自[官方手册](https://www.typescriptlang.org/docs/handbook/2/classes.html#implements-clauses)

`implements` 是用来在**检查** class satisfies a particular **`interface`**. 也可以进行多个 `interface` 的实现。

注意：只是检查类型是否满足，而不会改变任何 Class 本身的方法

```typescript
interface Pingable {
  ping(): void;
}

class Sonar implements Pingable {
  ping() {
    console.log("ping!");
  }
}

class Ball implements Pingable {
  // Error:
  // Class 'Ball' incorrectly implements interface 'Pingable'.
  //   Property 'ping' is missing in type 'Ball' but required in type 'Pingable'.
  pong() {
    console.log("pong!");
  }
}
```
