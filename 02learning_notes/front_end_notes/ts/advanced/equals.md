# Equals

> TS 类型如何实现“相等”

初级版：

```typescript
type IsEqual<T, Y> = T extends Y ? true : false;
```

但这么有个问题，只要 T 满足 Y 的 duck typing 就能判断正确

利用分布式约束，双向判断

```typescript
/**
 * Tests if two types are equal
 */
export type Equals<T, S> = [T] extends [S]
  ? [S] extends [T]
    ? true
    : false
  : false;
```

但也存在问题是，any 和任何类型互相 extends。

**直接看终极[方案](https://github.com/microsoft/TypeScript/issues/27024#issuecomment-421529650)**

```typescript
export type Equals<X, Y> = (<T>() => T extends X ? 1 : 2) extends <
  T
>() => T extends Y ? 1 : 2
  ? true
  : false;
```

具体是为什么可以实现呢？这个 issue 也非常多的人参与讨论

```typescript
T extends U ? X : Y
```

```typescript
// Two conditional types 'T1 extends U1 ? X1 : Y1' and 'T2 extends U2 ? X2 : Y2' are related if
// one of T1 and T2 is related to the other, U1 and U2 are identical types, X1 is related to X2,
// and Y1 is related to Y2.
```

```
type Foo<X> = <T>() => T extends X ? 1 : 2

type Bar<Y> = <T>() => T extends Y ? number : number

type Related = Foo<number> extends Bar<number> ? true : false // true

type UnRelated = Bar<number> extends Foo<number> ? true : false // false
```

也就是说：

- T1 和 T2 是互相 relate
- **U1 和 U2 是必须要相同**
- X1 和 X2 互相 relate
- Y1 和 Y2 互相 relate

所以再看这两个

```typescript
type left = <T>() => T extends X ? 1 : 2;
type right = <T>() => T extends Y ? 1 : 2;
```

T 是泛型，没指明就是 `unknown`，1 2 都是字面量，互相 relate

所以只要 X 和 Y 是一样的类型就可以相等

当然，笔者能力有限，至于再深入 TS 背后的原理，[逆变/斜变](./covarint_contravariant.md)，就自己去看吧
