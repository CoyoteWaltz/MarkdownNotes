# 高性能 TS ？

> 来自 [TS Wiki](https://github.com/microsoft/TypeScript/wiki/Performance)
>
> faster **compilations** and editing experiences 的一些实践

## 更高效编译的代码

### Interface Over Intersections

更推荐写 `interface` 而不是 type alias，这个也有过[探讨](./interface_vs_type.md)

```typescript
- type Foo = Bar & Baz & {
-     someProp: string;
- }
+ interface Foo extends Bar, Baz {
+     someProp: string;
+ }
```

一些好处：

- interface 是会处理属性冲突的，而交集只是递归的合并属性，可能会出现 `never` 的情况
- interface 在类型展示上会更加的连贯，type 往往只能看到是有哪些部分组成的。。
- interface 中类型关联会被缓存，type 不会
- intersection 的类型检查会检查所有的类型部分，非常费劲，虽然看上去 type alias 写起来很高效/扁平

### 用 Type Annotations

推荐在将函数的返回类型也显示的声明，这样可以省去编译时的大量工作

但这不是一个必要的要求，而是如果真的发现大项目中有这类的性能问题了再去优化，用 TS 自己推断出的类型也完全没问题。

这个[例子](https://github.com/ant-design/ant-design-icons/pull/479)是 antd-icons 库重复的 types 导致产物 emit 的 ts 文件过大（具体是因为 React.forwardRef 会生成很多匿名的中间 types，ts 输出类型的时候会转成 inline），PR 中重新定义了一个类型来进行复用，大幅的减少了产物大小。

同样 `import()` 导入的类型也会带来很大开销，因为 TS 会判断类型是否可用、目标位置的类型、计算文件导入路径、生成新的类型引用节点、打印。这几个步骤在复杂的大项目每个模块都会经历一遍，会带来非常大的开销。
