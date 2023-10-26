# 深入 webpack 插件机制

## tapable

> [Github](https://github.com/webpack/tapable)
>
> webpack 插件是在整个编译的周期内，基于 tapable 的 hooks 进行的

其实 `Tapable` 本质上就是一个威力加强版的 `EventEmitter`

本质上还是基于事件的方式，只是事件的执行流程加了点花样，允许同步异步和特殊的参数传递流程。

### Hook types

有很多种钩子类型

- Basic hook (without “Waterfall”, “Bail” or “Loop” in its name). This hook simply calls every function it tapped in a row.
- **Waterfall**. A waterfall hook also calls each tapped function in a row. Unlike the basic hook, **it passes a return value from each function to the next function.**
- **Bail**. A bail hook **allows exiting early.** When any of the tapped function returns anything, the bail hook will stop executing the remaining ones.
- **Loop**. When a plugin in a loop hook returns a non-undefined value the hook will **restart from the first plugin.** It will loop until all plugins return undefined.

同样对于如何执行，有 sync、asyncseries、asyncparallel

- **Sync**. A sync hook can only be tapped with synchronous functions (using `myHook.tap()`).
- **AsyncSeries**. An async-series hook can be tapped with synchronous, callback-based and promise-based functions (using `myHook.tap()`, `myHook.tapAsync()` and `myHook.tapPromise()`). They call each async method in a row.
- **AsyncParallel**. An async-parallel hook can also be tapped with synchronous, callback-based and promise-based functions (using `myHook.tap()`, `myHook.tapAsync()` and `myHook.tapPromise()`). However, they run each async method in parallel.

起名上仙显而易见，AsyncSeriesWaterfallHook

### Interception

每个 hook 都可以使用 `intercept` 方法再 hook 一些流程

**call**: `(...args) => void` Adding `call` to your interceptor will trigger when hooks are triggered. You have access to the hooks arguments.

**tap**: `(tap: Tap) => void` Adding `tap` to your interceptor will trigger when a plugin taps into a hook. Provided is the `Tap` object. `Tap` object can't be changed.

**loop**: `(...args) => void` Adding `loop` to your interceptor will trigger for each loop of a looping hook.

**register**: `(tap: Tap) => Tap | undefined` Adding `register` to your interceptor will trigger for each added `Tap` and allows to modify it.

### Context

plugin 和 interceptor 都可以访问到一个可选的上下文对象

```javascript
myCar.hooks.accelerate.intercept({
  context: true,
  tap: (context, tapInfo) => {
    // tapInfo = { type: "sync", name: "NoisePlugin", fn: ... }
    console.log(`${tapInfo.name} is doing it's job`);

    // `context` starts as an empty object if at least one plugin uses `context: true`.
    // If no plugins use `context: true`, then `context` is undefined.
    if (context) {
      // Arbitrary properties can be added to `context`, which plugins can then access.
      context.hasMuffler = true;
    }
  },
});

myCar.hooks.accelerate.tap(
  {
    name: "NoisePlugin",
    context: true,
  },
  (context, newSpeed) => {
    if (context && context.hasMuffler) {
      console.log("Silence...");
    } else {
      console.log("Vroom!");
    }
  }
);
```

### HookMap

方便构造和管理 hooks

```javascript
const keyedHook = new HookMap((key) => new SyncHook(["arg"]));

keyedHook.for("some-key").tap("MyPlugin", (arg) => {
  /* ... */
});
keyedHook.for("some-key").tapAsync("MyPlugin", (arg, callback) => {
  /* ... */
});
keyedHook.for("some-key").tapPromise("MyPlugin", (arg) => {
  /* ... */
});

const hook = keyedHook.get("some-key");
if (hook !== undefined) {
  hook.callAsync("arg", (err) => {
    /* ... */
  });
}
```
