# 并发限制的异步任务调度器

## V1

```js
/*
 * @Author: CoyoteWaltz <coyote_waltz@163.com>
 * @Date: 2020-08-06 22:50:17
 * @LastEditTime: 2020-12-26 23:19:40
 * @LastEditors: CoyoteWaltz <coyote_waltz@163.com>
 * @Description: 并发限制的异步任务调度器
 * @TODO:
 */
class Scheduler {
  waitQueue = [];
  count = 0;
  constructor(limit = 2) {
    this.limit = limit;
  }

  add(promiseCreator, ...args) {
    return new Promise((resolve, reject) => {
      // 把每一个任务的 resolve 闭包入这个 task 是很妙的 只有当 promiseCreator 真正执行回调的时候才调用
      const task = this.createTask(promiseCreator, args, resolve, reject);
      // 执行 or 排队
      if (this.count < this.limit) {
        task();
      } else {
        this.waitQueue.push(task);
      }
    });
  }

  // 封装一个 任务 fn
  createTask(fn, args, resolve, reject) {
    // return 一个可执行的 task 当然就是函数啦
    return () => {
      // 执行 就++ 可以放到第一句
      this.count++;
      fn(...args)
        .then(resolve)
        .catch(reject)
        .finally(() => {
          // 结束之后 让下一个等待的任务启动
          this.count--;
          if (this.waitQueue.length) {
            const task = this.waitQueue.shift();
            task();
          }
        });
    };
  }
}

const timeout = (time) =>
  new Promise((resolve) => {
    setTimeout(() => {
      resolve(time);
    }, time);
  });

const scheduler = new Scheduler();

const addTask = (time, order) => {
  scheduler
    .add(
      (x, y, z) => {
        console.log(x, y, z);
        return timeout(time);
      },
      1,
      2,
      3
    )
    .then(() => console.log(order));
};

addTask(1000, 1);
addTask(500, 2);
addTask(300, 3);
addTask(400, 4);
// 2 3 1 4
// 同时最多运行的任务只有两个

// Promise.race([
//   timeout(4000).then(console.log),
//   timeout(3000).then(console.log),
// ]).then((res) => console.log(res));
```

## V2

> 马进分享的代码片段，摘录于 https://thinking.tomotoes.com/archives/2020/12/25-31

```js
// 马老师 version
const getRequestWithLimit = (limit) => {
  let count = 0;
  const blockQueue = [];

  return async (fn) => {
    count++;
    if (count > limit) {
      // 这里 await resolve 理解绝了 resolve 之后再开始后续的 fn()
      // 可以理解为用 await resolve 来阻塞 线程执行
      await new Promise((resolve) => blockQueue.push(resolve));
    }
    try {
      await fn();
    } catch (e) {
      return Promise.reject(e);
    } finally {
      count--;
      blockQueue.length && blockQueue.shift()();
    }
  };
};

const requestWithLimit2 = getRequestWithLimit(2);
requestWithLimit2(timeout(100));
```
