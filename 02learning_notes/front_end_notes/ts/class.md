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
