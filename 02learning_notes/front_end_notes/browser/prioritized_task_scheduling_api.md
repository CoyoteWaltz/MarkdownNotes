# Prioritized Task Scheduling API

> [MDN](https://developer.mozilla.org/en-US/docs/Web/API/Prioritized_Task_Scheduling_API)
>
> The **Prioritized Task Scheduling API** provides a standardized way to prioritize all tasks belonging to an application, whether they are defined in a website developer's code or in third-party libraries and frameworks.
>
> 一个浏览器提供的标准的接口，来处理任务的优先级
>
> 通过这个 API 用户可以实现更加细粒度的任务优先级控制，对应常规的粗粒度任务(coarse-grained)是基于是否会阻塞用户交互、影响体验。
>
> Promise-based
>
> window 和 worker 都可以使用

## 使用

### API

```javascript
const promise = scheduler.postTask(myTask);
```

`postTask` 接受一个 task function，返回一个 promise

- promise resolve 的值就是任务函数的返回值，或者 `.catch` 抛出 error
- 默认的优先级是 `user-visible`（下文细说）这个优先级是一个固定的，且不能被终止

同时这个方法接受 options

- `priority`：指定优先级，切不能被二次修改
- `signal`：[`TaskSignal`](https://developer.mozilla.org/en-US/docs/Web/API/TaskSignal) or [`AbortSignal`](https://developer.mozilla.org/en-US/docs/Web/API/AbortSignal)，能够改变（如果任务是 mutable）或者终止任务
- `delay`：延迟加入队列的情况

### 优先级

> 以下优先级从高 → 低

`user-blocking`

Tasks that stop users from interacting with the page. This includes rendering the page to the point where it can be used, or responding to user input.

最高优任务，会阻塞用户交互和页面渲染，优先执行

`user-visible`

Tasks that are visible to the user but not necessarily blocking user actions. This might include rendering non-essential parts of the page, such as non-essential images or animations.

This is the default priority.

默认优先级，不会阻塞用户交互

`background`

Tasks that are not time-critical. This might include log processing or initializing third party libraries that aren't required for rendering.

这个有点抽象。。。

优先级可以是可变的 or 不可变

- 不可变：在 `postTask` 中 `options.priority` 指定了 priority 之后就不可变
- 可变：**仅当** [`TaskSignal`](https://developer.mozilla.org/en-US/docs/Web/API/TaskSignal) 传入了 `options.signal` **并且没有指定 priority**，这样 `postTask` 会以[`TaskSignal`](https://developer.mozilla.org/en-US/docs/Web/API/TaskSignal) 的优先级为初始优先级，后续可以通过 [`TaskController.setPriority()`](https://developer.mozilla.org/en-US/docs/Web/API/TaskController/setPriority) 修改

没有设置任何的 priority 或者 signal 之后，默认是 `user-visible` **且不可变**

任务取消：设置 signal 为 TaskSignal or AbortSignal

## 具体应用

### 检查是否有 schedular API

```javascript
"scheduler" in this;
```

### 修改优先级

```javascript
if ("scheduler" in this) {
  // Create a TaskController, setting its signal priority to 'user-blocking'
  const controller = new TaskController({ priority: "user-blocking" });

  // Listen for 'prioritychange' events on the controller's signal.
  controller.signal.addEventListener("prioritychange", (event) => {
    const previousPriority = event.previousPriority;
    const newPriority = event.target.priority;
    mylog(`Priority changed from ${previousPriority} to ${newPriority}.`);
  });

  // Post task using the controller's signal.
  // The signal priority sets the initial priority of the task
  scheduler.postTask(() => mylog("Task 1"), { signal: controller.signal });

  // Change the priority to 'background' using the controller
  controller.setPriority("background");
}
```

可以看到最终结果

```
Priority changed from user-blocking to background.
Task 1
```

### 终止任务

```javascript
if ("scheduler" in this) {
  // Declare a TaskController with default priority
  const abortTaskController = new TaskController();
  // Post task passing the controller's signal
  scheduler
    .postTask(() => mylog("Task executing"), {
      signal: abortTaskController.signal,
    })
    .then((taskResult) => mylog(`${taskResult}`)) // This won't run!
    .catch((error) => mylog(`Error: ${error}`)); // Log the error

  // Abort the task
  abortTaskController.abort();
}
```

### 延迟任务

类似 setTimeout，The `delay` is the minimum amount of time before the task is added to the scheduler; it may be longer.

会延迟一段时间，再 push 到 scheduler

### 获取渲染时长

目标：精准的获取一次浏览器主线程渲染消耗时间（纯主线程渲染，非 js 任务阻塞）

思路：利用 [requestAnimationFrame](https://developer.mozilla.org/en-US/docs/Web/API/window/requestAnimationFrame) 的特性，会在下一次渲染开始前执行 callback，在这个 callback 中记录一个时间戳 `renderStart`，然后同时 `postTask` 一个最高优先级的任务到下一次浏览器执行 JS 任务的时候进行，获取一个 `renderEnd` 时间戳，这样就能确保准确获取渲染的时长了（相对来说比较精准）

问题：

- 在移动端只有安卓才有 API，IOS 用 message channel

## 兼容性

chrome 94

Android Chrome 94

**IOS Safari 不支持**
