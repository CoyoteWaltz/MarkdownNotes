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

### 控制 `@types` 的引入

TS 会默认自动加载所有 `node_modules` 中包的 `@types`（类型文件），这样就能很好的在没有引入这些包的情况下就用到他们的类型（比如 nodejs，jest，mocha 等），他们都是全局的类型。

但这样也会带来比如逻辑足够复杂导致的性能问题，所以可以通过 `types` 字段来控制

```json
// src/tsconfig.json
{
  "compilerOptions": {
    // ...

    // Don't automatically include anything.
    // Only include `@types` packages that we need to import.
    "types": []
  },
  "files": ["foo.ts"]
}
```

按需引入需要的类型（比如：`"types" : ["node", "mocha"]`）

### Skipping `.d.ts` Checking

设置 `compilerOptions.skipDefaultLibCheck` 为 true

可以让 TS 跳过 `.d.ts` 的检查，因为他们一般都是没问题的

也可以设置 `skipLibCheck` 跳过所有的 `.d.ts` 检查

### 更快的协变逆变（variance）检查

开启 `strictFunctionTypes`

The compiler can only take full advantage of this potential speedup if the `strictFunctionTypes` flag is enabled (otherwise, it uses the slower, but more lenient, structural check).

意思是默认的类型能否赋值比较是通过结构对比，开了之后会用协变/逆变来对比？反正开了之后会快就对了。。

## 配合其他构建工具

我们在项目中也会用构建器去完成 ts 的编译，比如在 web app 中的打包器，一些 lib 的构建器（swc/tsup），理想情况下这些工具对于 ts 编译性能的提升是可以泛化的知识。

文章只推荐了 [ts-loader fast build](https://github.com/TypeStrong/ts-loader#faster-builds) 等

## 并行的 type 检查

另开一个线程去做类型检查，不阻塞当前的产物输出，[文章也介绍了](https://github.com/microsoft/TypeScript/wiki/Performance#concurrent-type-checking)两个工具

## Isolated File Emit

和之前提过的 [isolatedModules](./ts-config.md) 有关。检查 `const enum` 和  `namespace` 的时候，是需要上下文的类型信息，也相对比较耗时，并且对于单文件处理的工具（比如 babel）不友好，所以推荐开启 `isolatedModules` 开关，让你的代码更加安全。

可以在深入下为什么是 `const enum` 和 `namespace`？

- `const enum` 会在编译的时候直接 inline 处理，把对应的值替换在引用的地方（[TS Playground](https://www.typescriptlang.org/play?ts=5.0.2&ssl=7&ssc=19&pln=1&pc=1#code/MYewdgzgLgBApmArgWxgMRCGBvAUDAmAMwBp9CBzMwmAa1wF9ddRIQAbOAOnZAoAoMILkQCUQA)）
- `namespace` TODO

文章还介绍了一些工具是如何利用这个开关（`--isolatedModules`）让 ts 构建加速的

## 查看编译效率的一些方法

### 关掉编辑器的一些插件

本身就会拉垮速度

### `--extendedDiagnostics`

这个开关让编译器输出编译所花费的时间

### `--showConfig`

不确定具体 tsc 是用那个 config 的时候可开这个开关

### `--listFilesOnly`

输出哪些文件被读取了

### `--explainFiles`

解释为什么这些文件被读取了

```shell
tsc --explainFiles > explanations.txt
```

### `--traceResolution`

追踪 import 文件的过程是否有异常

```shell
tsc --traceResolution > resolutions.txt
```

剩余部分是一些建议，比如不正确的配置 `include` and `exclude` 可能会导致 ts 检查更深层级的目录文件，以及如何找性能问题，后续在看！
