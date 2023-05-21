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

### Preferring Base Types Over Unions

```typescript
declare function printSchedule(schedule: WeekdaySchedule | WeekendSchedule);
```

Union 类型有非常好的表达力，能够明确的告诉类型的范围，但是在将参数传入给这个 `printSchedule` 的时候，TS 会比较每一个类型的每一个元素，并且在消除 union 类型的重复元素时，编译期间也会造成很大的开销（n 方）

更推荐用 subtype 的形式去拓展（常见的 Dom `HtmlElement` type with common members which `DivElement`, `ImgElement`）

```typescript
interface Schedule {
  day:
    | "Monday"
    | "Tuesday"
    | "Wednesday"
    | "Thursday"
    | "Friday"
    | "Saturday"
    | "Sunday";
  wake: Time;
  sleep: Time;
}

interface WeekdaySchedule extends Schedule {
  day: "Monday" | "Tuesday" | "Wednesday" | "Thursday" | "Friday";
  startWork: Time;
  endWork: Time;
}

interface WeekendSchedule extends Schedule {
  day: "Saturday" | "Sunday";
  familyMeal: Time;
}

declare function printSchedule(schedule: Schedule);
```

### Naming Complex Types

复杂的类型会让 TS 在每次调用 foo 的时候都去运行一遍条件判断，如果用 type alias 抽象一层则能更好的被 TS 缓存，节省运行成本。

```typescript
type FooResult<U, T> = U extends TypeA<T>
  ? ProcessTypeA<U, T>
  : U extends TypeB<T>
  ? ProcessTypeB<U, T>
  : U extends TypeC<T>
  ? ProcessTypeC<U, T>
  : U;

interface SomeType<T> {
  foo<U>(x: U): FooResult<U, T>;
}
```

### 拆分大项目

You can [read up more about project references here](https://www.typescriptlang.org/docs/handbook/project-references.html).

## 配置 `tsconfig.json` or `jsconfig.json`

> 这两个编译相关的配置

### 声明文件

能确保一次不要 include 太多文件

在 `tsconfig.json` 中可以用：

- `files` list
- `include` 和 `exclude` list 字段

两者最主要的区别就是 `files` 预期的是源文件的目录；`include`/`exclude` 用的是 glob pattern 来匹配文件

For best practices, we recommend the following:

- 只引入入口文件
- 不要把源文件和其他项目代码放在一起
- 如果有 test 文件，给一个特殊的名字用来被 exclude
- 避免大量编译产物或者依赖（`node_modules`）被放在源文件中

**`node_modules` is excluded by default，但是一旦在 `exclude` 字段中加了新的，`node_modules` 需要被显式的加入**

```json
{
  "compilerOptions": {
    // ...
  },
  "include": ["src"],
  "exclude": ["**/node_modules", "**/.*/"]
}
```
