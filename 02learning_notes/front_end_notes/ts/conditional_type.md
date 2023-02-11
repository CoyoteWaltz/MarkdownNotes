# Conditional Type

> [官网](https://www.typescriptlang.org/docs/handbook/2/conditional-types.html)

程序有不同输入对应不同输出，type 也是

关键字 `extends` 类似三元表达式 ` SomeType extends OtherType ? TrueType : FalseType;`

```typescript
type Flatten<Type> = Type extends Array<infer Item> ? Item : Type;
```

```typescript
type GetReturnType<Type> = Type extends (...args: never[]) => infer Return
  ? Return
  : never;
```

重点是 Distributive Conditional Types

当泛型是 union 的时候，`extends` 也会分别进行作用判断，结果也最后 union 起来

**如果不希望分布计算，可以用 []**

```typescript
type ToArrayNonDist<Type> = [Type] extends [any] ? Type[] : never;

type NumOrStrArr = ToArrayNonDist<number | string>; // (number | string)[]
```
