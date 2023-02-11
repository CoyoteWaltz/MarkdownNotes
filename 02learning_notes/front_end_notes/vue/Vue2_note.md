# Vue2 笔记

[B 站特别好的网课](https://www.bilibili.com/video/av59594689)

---

[toc]

## MVVM

### MVC(Model View Controller)

前后端，前端渲染页面，需要数据从后端获取

#### Model

后端数据库，模型

#### Controller

路由和控制器，后端接收到前端的请求之后，根据路由匹配对应的控制器函数

#### View

前端视图

### MVVM(前端的视图层重新抽离)

View: DOM

Model: 数据（后端获取的）

**VM**: ViewModel，监听 View 对数据的更改，数据驱动 View，双向绑定的过程（双向：view 和 model）

## 响应式数据原理

Object.defineProperty

## 生命周期

## {{}}插值

叫做 mustache 语法

## 计算属性

- 比如有一个变量是需要列表内的元素之和，那么需要用 computed 来计算
- 计算属性，算是一个属性（data），不需要重复 data
- 计算属性有缓存，可以验证，计算属性只会调用一次，缓存起来，如果 this 的数据发生了变化，才会重新计算
- 完整的计算属性是一个对象，有 set 方法和 get 方法，用插值的时候用的是 get 方法返回的值

  - 一般没有 set 方法的属性就是一个 read-only
  - 有 set 方法的时候，设置变量(在 console 里面直接赋值)的时候会调用，此时 set 函数会接受一个参数 newValue

- html 里面不要有繁琐的逻辑代码

## v-on 传递参数 修饰符.native 可以让组件监听原生事件

click 的时候，鼠标的 event，用\$event 传入

```javascript
btnClick(v1, event) {
  console.log(v1, event)
}
```

## vue 渲染 dom 的 vdom 的复用

比如在 v-if 的时候，不希望他复用，就用 key 属性区分

同一个组件要展示不同的内容，切换的时候就会复用 vdom，给 key

## v-if 和 v-show，前者是直接从父标签中插入删除，后者是 display: none

切换频率高的，用 v-show，只用一次的用 v-if，一般用 v-if，根据后台服务器传来的数据

## v-for

- 获取对象的属性:(value, key, index) in obj
- 给循环的对象绑定一个 key，key 和元素一一对应，为了更好的复用，不给 key 的话，插入一个 array 之后会效率差，diff 的时候只看 li 的值会全部替换，如果有 key，diff 先检查 key，key 没问题之后，在插入

![vue_for_key](C:\Users\LokiJW\Desktop\vue_for_key.png)

- 不能使得数组实现响应式的情况：
  - 修改数组中的某个元素
- 可以响应式的：
  - sort
  - reverse
  - shift 删除第一个
  - unshift 添加第一个
  - splice 很多用法。。
  - pop
  - push
  - 所以要替换元素，不要用赋值的方法，要用函数
  - 或者用 Vue.set(对象, 下标, new 值)函数

## 命令式编程，声明式编程，面向对象编程，函数式编程

## JS ES6 高阶函数

for 循环

- for (let i in/of obj)
  - in 遍历 obj 的所有属性
  - of 可以遍历所有的可迭代 obj: array, map, set, Argument

filter 函数:

```javascript
const a = [1, 2, 3, 4, 5];
let b = a.filter((v) => {
  return v % 2 == 0;
});
console.log(b);
```

map 函数和 python 差不多

reduce 作用是对所有元素的总和:

- 回调函数的参数有 previousValue，currentValue，每一次操作之后都会返回这个 previousValue

- 他在 ts 中重载了，还有一个参数可选的是 initialValue

  ```javascript
  let sum = a.reduce((preV, v) => {
    return preV + v;
  }, 0);
  ```

- 每次遍历的时候，操作当前值，返回回调函数的值作为下一次的 preV 保存

## input 标签还有一个 input 事件，监听用户输入

可以用 v-on:input 绑定一个函数

函数默认接受一个 inputEvent，有属性 data，target 等

target 是整个标签的对象，可以用他的属性，直接用 value 属性就可以获得输入框内的值了

## **实现双向绑定的另一种方法，不用 v-model，单向绑定 value，监听输入事件**

## 补充 html 知识：单选框的 name 可以互斥，value 属性获取值

```html
<label for="male"> <input type="radio" id="male" name="sex" />男 </label>
<label for="female"> <input type="radio" id="female" name="sex" />女 </label>
```

## v-model

v-model 和 radio 单选一起

可以发现 v-model 绑定的都是 value 属性值，而且此时 name 可以不用，也互斥

```html
<div>
  v-model和radio单选一起，可以发现v-model绑定的都是value属性值，而且此时name可以不用，也互斥
  <br />
  <label for="male">
    <input type="radio" id="male" name="sex" value="男" v-model="sex" />男
  </label>
  <label for="female">
    <input type="radio" id="female" name="sex" value="女" v-model="sex" />女
  </label>
  <br />
  <span>你的性别 {{sex}}</span>
</div>
```

v-model 和多选框

```html
<div v-if="showHobbies">
  <input type="checkbox" v-model="selectedHobbies" value="篮球" />篮球
  <input type="checkbox" v-model="selectedHobbies" value="乒乓球" />乒乓球
  <input type="checkbox" v-model="selectedHobbies" value="高尔夫球" />高尔夫球
  <input type="checkbox" v-model="selectedHobbies" value="lacrosse??" />lacrosse
  <br />
  一行搞定
  <!-- <ul v-for="(item, idx) in hobbies"> -->
  <label v-for="(item, idx) in hobbies">
    <input type="checkbox" :value="item" v-model="selectedHobbies" />{{item}}
  </label>
  <!-- </ul> -->
  <br />
  <span>爱好是: {{selectedHobbies}}</span>
</div>
```

修饰符:

- lazy，失去焦点，回车的时候再绑定
- number，只能是数字，绑定的对象也是 number 类型
- trim，相当于 py 的 split

## 组件

### 组件中的 data 为什么必须是一个函数？

因为组件会被复用，所有的组件的 data 不能共享，所以需要函数返回一个新的对象，作为这个组件的数据对象，保证解耦！

### 组件通信

父--->子: props，**v-bind 的时候属性不能用小驼峰，要用-转换！记住 cBoy=>c-boy**

- 子组件里面写 props 属性
  - 值为 list，是接受值的 name，可以直接用在 template 中
  - **值为对象，可以指定类型！键为 name，值为类型，也可以是对象，对象中包含 type，default 给默认值！类型是对象或者数组的时候必须是一个 factory function！，required 属性，boolean 告诉他是否必须传递**
- 父组件通过子组件标签中的属性传递值，对应的属性名就是子组件 props 里面的 name，用 bind
- 注意下面那个自定义的验证函数！！

![image-20200203165210617](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200203165210617.png)

子--->父: 自定义事件 emit 向父组件发送，父组件监听子组件，捕获事件

- 小组件切换的时候，告诉父组件，换一批数据在另一个组件中展示
- 子组件通过 this.\$emit(自定义事件名, {事件对象})，向父组件发射事件
- 父组件通过 v-on 监听自定义事件，绑定方法，默认接受这个事件对象

父子组件双向绑定的时候，子组件的属性，要改变的时候必须要父组件传递来的，所以子组件可以用计算属性，或者给个 data，此时，子组件给父组件发送事件

或者用 watch 来监听属性的改变，发生改变了就发送给父组件

## watch

## 父子组件互相访问

- 父访问子：

  - \$children: 获得所有 子组件，默认空数组，下标访问子组件，可以访问子组件的对象的数据，调用方法

    - \$refs: 默认空对象，标签加个属性 ref，才会有

      `<cpn ref="child1"></cpn>`，这样之后\$refs 得到的对象（py 的 dict）就是 child1:Vuecomponent 了，相当于是给了这个子组件一个 id，很常用

- 子访问父:
  - 比较少用，子组件要独立
  - \$parent
  - \$root: 访问根实例

## slot 插槽

使得组件有扩展性

![image-20200203181515205](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200203181515205.png)

![image-20200203181600924](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200203181600924.png)

说白了就是留个空，这个空叫`<slot>`他有默认值的，然后再用组件的时候把所需要插入的模板 template 传入，**非常实用！**不给的时候就用默认值

### 具名插槽

多个 slot 的时候，给每个 slot 一个 name 属性，然后

### 编译作用域

变量所在的组件内才有用

### 作用域插槽

_父组件替换插槽的标签，内容由子组件提供。_

父组件要拿子组件的内容，用不同的方式展示，slot，但是由于作用域，子组件的数据拿不到。

子组件可以将自己的数据作为其的一个属性来用，例如`:user="user"`，这样，在父组件就可以用他的属性了

## js 数组的.join(".")和 py 的".".join(array)类似

## 模块化开发

## el 和 template 的关系

一旦有 template，会替换 app 的 div 的！

## Vue-cli

选 runtime-only，light

3 的配置去哪里了

- 可以 vue ui 启动

## js es6 箭头函数

```javascript
(arguments) => {};
// 一个参数的时候小括号可省略
// 函数体就一行的话，大括号也可以去掉，return也可以去掉
const mul = (n1, n2) => n1 * n2;
const a = () => console.log("return undefined");
```

像 lambda 函数，匿名函数

箭头函数的使用情况:

- 作为参数，传递回调函数

箭头函数的 this:

- 是对象的 this，
- **结论: 箭头函数的 this 是最近作用域的 this，一层层找。**

## 关于导入

只有是 export default 的时候，外部才能用`import Xxx from '...'`起名字

如果 export 了很多东西，导入的时候用对象的方法解包`import {x1, x2} from '...'`

也可以给这个 obj 起名字，as xxx

## web 应用的三个阶段

1. 后端渲染:jps,aps...，后端完成 html 的渲染，返回给浏览器 html+css
2. 前后端分离: axios 的出现，浏览器获得三件套，执行 js 中发送 ajax 获得数据
3. SPA: 单页面富应用，前端完成路由，一次性获得所有静态资源，根据 url 不同映射不同路由，抽取对应的资源渲染，不刷新页面

## url 的 hash 和 history，不刷新页面

console 里 location.hash = "aaa"

于是就`xxxxx/#/aaa`多了一个 hash

或者用 history 对象，`history.pushState(data, title, url)`

就是 history 的路由栈，`history,back()`会出栈

还有`history.replaceState(...)`替换当前的栈顶

`history.go(-1)` == `history.back()`

`history.go(1)` == `history.forward()`

其实这些事为了 vue-router 的铺垫

## Vue-router

### 使用

安装

导入`import VueRouter from 'vue-router'`

Vue 使用`Vue.use(VueRouter)`

创建 VueRouter 的实例，配置映射关系

```javascript
const router = new VueRouter({...})
```

挂载到 vue 的实例上

在模板中用`<router-link>`和`<router-view>`。

### router-link 的三个属性

- tag 可以渲染成不同的标签
- replace，不需要参数，直接内容用 replaceState

- active-class，给定点击的样式，可以统一修改`linkActiveClass: 'active'`在 index.js 中，然后通过 css 统一该样式

### 编程式路由

- this.\$router.push(...)
- this.\$router.go(1)
- this.\$router.replace(...)

### 动态路由

url 里的内容是动态改变的，不写死`/user/4`

`path: '/user/:id'`

### this.\$route 处于活跃的路由对象！

有属性 params 获得参数

### 路由的 lazy load

用到的时候再加载，不要一次性，所以有 lazy load 的时候，打包的 dist 里面的 js 就有多个文件！

```javascript
path: '/xxx',
component: () => import('../../../xxx.vue') // ES6
```

在最开头定义变量`const XXX = () => import('../../../xxx.vue')`更妙啊！

既可以 lazy，注释掉之后就不是 lazy 了。

### 路由嵌套

router 对象中的 children

### 参数

拼接 url

传递对象，path，query，params。。。

![image-20200204154411230](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200204154411230.png)

### route 路由对象，router 路由器

### 全局钩子(见 newt 项目，学过了)

router.beforeEach((to, from, next) => {})

### 路由独享局部钩子

## keep-alive

组件的状态，每次切换不会保留

keep-alive 是 vue 的内置组件，只要是他包含的对象，都会被缓存，不会重新渲染

可以用生命周期的钩子来看，是否被保留了

对应的生命周期钩子: activated 和 deactivated 就有用了

### 属性:

希望某个组件不要被缓存

exclude="cName1,cName2, ..."传入组件的 name。**这里不能加空格正则也不能加**

## document 对象。Html 的对象

![image-20200204160252671](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200204160252671.png)

meta 数据 描述数据的数据

## 项目文件

越往上层越抽象

小组长把具体框架搭好

组员负责每个页面

每个页面放在 views 里面，每个文件夹放该页面的组件

公共的组件放在 components 里面

## v-bind 绑定 class

![image-20200204182153615](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200204182153615.png)

## cli3/4 的配置去哪了

## 文件路径的别名

cli4 的默认是@是'/src'

## Promise(ES6)

异步编程的解决方案，是一个 class

网络请求就会遇到异步，处理结束调用 callback 函数。

回调地域，多层回调

*nodejs*环境就是异步的。单线程，非阻塞，event driven

看个例子，模拟网络请求，异步

```javascript
new Promise((resolve) => {
  // 两个参数都是函数
  // setTimeout(() => {
  //   console.log('jjj')
  // }, 2000);
  // 模拟网络请求发送，延时函数就是网络请求
  // resolve函数执行表示请求得到结果
  // then，就去处理得到的结果
  // 也就是回调函数
  setTimeout(() => {
    console.log("resolve 1");
    resolve("处理操作1");
  }, 2000);
  // 说明异步操作完成，调用回调函数then
}).then((data) => {
  console.log(data);
  console.log(data);
  console.log(data);
  console.log(data);
  return new Promise((resolve) => {
    setTimeout(() => {
      console.log("resolve 2");
      resolve("处理操作2");
    }, 1000);
  }).then((data) => {
    // console.log('2')
    // console.log('2')
    // console.log('2')
    console.log(data);
    console.log(data);
    console.log(data);
    console.log(data);
  });
});
```

链式编程！很清晰

### 什么时候使用

只要有异步操作的时候就封装到 Promise 里面

![image-20200204194830026](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200204194830026.png)

看源码。在 new 构造一个 Promise 的时候，会保存一些状态信息，并且执行传入的这个函数 executor，就是上面的函数原型，有两个参数 resolve 和 reject 都是函数。

```javascript
new Promise((resolve, reject) => {
  // 异步操作...
  resolve(data);
  reject("error msg");
})
  .then((data) => {
    // 处理操作
  })
  .catch((err) => {
    // 处理错误
  });
```

resolve 就是解决了异步，就可以去 then 处理，分离了网络请求和数据处理的操作

reject 就是我不想继续操作，可能网络请求失败了，就去 catch 里面处理错误

所以报错，NavigationDuplicated，出现在`$router.push()`返回的是 Promise 对象，如果报错了就用 catch 来处理

### 三种状态

![image-20200204200217649](C:\Users\LokiJW\AppData\Roaming\Typora\typora-user-images\image-20200204200217649.png)

将异步操作，包裹入 Promise，然后进入了 pending 就是操作时间。。。

```typescript
then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): Promise<TResult1 | TResult2>;
```

看源码。这里的 then 其实可以传入两个参数，一个是在 resolve 的时候执行，第二个是 onrejected 的时候执行

catch 的时候只有 onrejected 了

可以简写。。直接用`Promise.resolve(..)`也可以

还能再简，如果后面还有 then，可以直接 return data，内部会自己封装成一个 Promise

如果在链中，有一个 reject，就直接去找一个 catch，终止。

`throw 'err msg'`也是可以给 catch 的

### all 方法

需求：依赖两个请求，两个请求 all 完成才能 then，所以这里就用`.all()`，Promise 包装两个异步，都完成再。

看了一眼源码，惊了。。写了好多个重载，最多 all 可以接受 10 个 PromiseLike 组成的 list，then 的参数也是一个 list of result

```javascript
Promise.all([
  new Promise((resolve) => {
    setTimeout(() => {
      resolve("111 done");
    }, 1000);
  }),
  new Promise((resolve) => {
    setTimeout(() => {
      resolve("222 done");
    }, 1200);
  }),
]).then((results) => {
  console.log("all done 遍历数组用of");
  for (let i of results) {
    console.log(i);
  }
});
```

## Vuex

状态管理模式

**集中式存储管理**应用的所有**组件的状态**，

### 什么是状态？状态管理？

多个组件共享的一些状态：数据，函数。变量

如何管理，集中式？

存到一个变量，放到顶级的 Vue 实例中，让其他组件都能使用

根据响应式原理，共享。所谓响应式就是监听事件

单例模式！

说白了就是一个 Vue 实例的全局变量，但是是响应式的

### 管理什么状态呢

登录状态: token

用户信息

### 单页面状态管理

就是官网的这张图

![vuex官方](https://vuex.vuejs.org/flow.png)

view 是浏览器渲染出来展示的网页

actions 是用户的操作，会引发数据变化

state 就可以看成是 vue 保存的数据

单页面的就很好理解，多页面其实也差不多

### 安装，配置

cli 选配 vuex 之后再 src/store/index.js 里面就有了

```javascript
import Vue from "vue";
import Vuex from "vuex";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {},
  mutations: {},
  actions: {},
  modules: {},
});
```

然后在 main.js 中配置在 vue 实例中

### 使用

此时 vue 的 prototype 就有一个属性是\$store

state: 保存的数据，官方不建议直接修改这里，最好只是 read-only，按照规定的规则去修改

mutations: 数据发生变化只能通过这个变化才能，会被 vuex-dev-tool 这个浏览器插件监听，推荐都是同步操作。mutations 属性的值都是函数，**默认接收 state！其实所有的变化都默认得到 state**

actions: 异步操作

![官网vuex](https://vuex.vuejs.org/vuex.png)

在组件内使用\$store 发生 mutation 的时候，要用 commit 去提交

```javascript
this.$store.commit("mutations里面的方法名");
```

### 五个核心概念

#### State 唯一的数据源

单一状态树 Single Source of Truth，就是单一数据源

不希望有很多个 vue store。多个 store，管理和维护比较困难

#### Getters 类似计算属性

源码`export type Getter<S, R> = (state: S, getters: any, rootState: R, rootGetters: any) => any;`可见是可以有四个参数，前两个用的多

类似 computed，需要获得对数据进行操作之后的结果

同时 getters 还能拿到 getters 的属性

```javascript
getters: {
    powerCounter(state) {
      return state.counter * state.counter
    },
    stuLess30(state) {
      return state.students.filter(v => v.age < 30)
    },
    stuLess30Length(_, getters) {
      return getters.stuLess30.length
    },
    // 需求 获取年龄大于某指定岁的个数 可以动态传入
    // {{ $store.getters.stuMoreAge(13) }}
    // 用装饰器的思想做！
    stuMoreAge(state) {
        return function (age) {
            return state.students.filter(v => v.age > age)
        }
        // return age => state.students.filter(v => v.age > age)
    }
},
```

#### Mutation 状态更新的唯一方式

事件类型: 回调函数，用 commit 提交事件

也就是可以看成，每次有变化都是一个 event，也就是 commit 的事件，会调用对应的回调函数

call a event then call it' s callback function

`export type Mutation<S> = (state: S, payload?: any) => any;`

第二个参数 payload 可选，也就是他可以接受参数的，也就是事件的载荷

```javascript
add(state, x) {
  state.counter += x
}
// 上面是mutation
btnClick() {
 this.$store.commit('add', this.addCnt)
}
```

commit 也可以提交 obj，另一种风格

```javascript
this.$store.commit({
  type: "add",
  addCnt: this.addCnt,
});
```

如果是这样，那么在 mutation 接收到的 x 就是一个对象，叫 payload 最好

响应规则:

- state 是响应式的，初始化过的 state**属性**都进入了响应式 Dep -> [watcher, watcher]，_观察者模式_，每个 watcher 是响应式数据所在的位置，需要变化，每个 watcher 都会变化，通知变化。**新增的属性，没有 watcher，不在响应式系统中**
- 用 Vue.set 可以响应式
- delete 方法不能响应式，对象会改，页面不会
- 用 Vue.delete 方法可以

用文件定义常量来解决用 mutation 不统一的问题

在/store 文件夹下再新建一个文件放 mutation 的 type 名，导出

`export const INCREMENT = 'increment'`

在 store/index.js 里面导入，`[INCREMENT]() {}`这样去使用，也是可以的

然后在组件里面导入去使用，可以避免名字打错

**必须是同步方法**，devtool 无法捕捉快照

#### Action 可以用异步操作

比如网络请求

`export type ActionHandler<S, R> = (this: Store<R>, injectee: ActionContext<S, R>, payload?: any) => any;`

第一个参数是 store 对象！相当于是上下文

```javascript
asyncIncrement(context) {
  setTimeout(() => {
    context.commit(INCREMENT)
  }, 1200)
}
```

然后，用\$store.dispatch 方法来分发这个 Action

也可以传递 payload

同样异步操作成功之后的要通知外面，可以传入一个对象，有数据部分 payload，也有 success 方法，在 action 里面调用。

或者直接用 Promise，处理就完事了

```javascript
asyncIncrement(context, payload) {
  //   setTimeout(() => {
  //     context.commit(INCREMENT)
  //   }, 1200)
  //   console.log(payload)
  // }
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      context.commit(INCREMENT)
      console.log('done!')
      resolve(payload)
    }, 1200)
  }) // 把这个then留给外面的人去写 返回一个promise就可以了
```

有意思的 Promise

看一下官网的例子

```js
actions: {
   // 可以解包store!!得到commit方法和state
  checkout ({ commit, state }, products) {
    // 把当前购物车的物品备份起来
    const savedCartItems = [...state.cart.added]
    // 发出结账请求，然后乐观地清空购物车
    commit(types.CHECKOUT_REQUEST)
    // 购物 API 接受一个成功回调和一个失败回调 这里是个异步的
    shop.buyProducts(
      products,
      // 成功操作
      () => commit(types.CHECKOUT_SUCCESS),
      // 失败操作
      () => commit(types.CHECKOUT_FAILURE, savedCartItems)
    )
  }
}
```

#### Module

前面说了 vuex 是单一状态树，所以状态多的时候，整个 state 会变得很臃肿，所以可以在模块里分割 state，

```js
const moduleA = {
  state: { ... },
  mutations: { ... },
  actions: { ... },
  getters: { ... }
}

const moduleB = {
  state: { ... },
  mutations: { ... },
  actions: { ... }
}

const store = new Vuex.Store({
  modules: {
    a: moduleA,
    b: moduleB
  }
})

store.state.a // -> moduleA 的状态
store.state.b // -> moduleB 的状态
```

这样子用，每个子模块都有自己的四个属性，每个模块又是局部的，在 actions 访问的 context 也是局部的，**根节点的状态是 context.rootState**

```js
const moduleA = {
  // ...
  actions: {
    // 这里可以解包！解包是按照名字属性一一对应
    incrementIfOddOnRootSum({ state, commit, rootState }) {
      if ((state.count + rootState.count) % 2 === 1) {
        commit("increment");
      }
    },
  },
};
```

感觉就是把虽然写在 modules 里的对象还是放入了 state

getters 注意了，用的时候还是直接用，不分模块的，getters 接受的三个参数`state, getters, rootState`这样，子模块就可以用根模块的 state 了

更简单粗暴一点，这个 context 直接打印看看，有很多属性，rootGetters......

**P.S.解构是按照名字属性一一对应**

### vuex 的文件结构

[看官网](https://vuex.vuejs.org/zh/guide/structure.html)

```bash
├── index.html
├── main.js
├── api
│   └── ... # 抽取出API请求
├── components
│   ├── App.vue
│   └── ...
└── store
    ├── index.js          # 我们组装模块并导出 store 的地方
    ├── actions.js        # 根级别的 action
    ├── mutations.js      # 根级别的 mutation
    └── modules           # 模块也抽出来，按照名字
        ├── cart.js       # 购物车模块
        └── products.js   # 产品模块
```

## Axios 封装

传统的 ajax:XMLHttpRequest(XHR)

jQuery-Ajax，jQuery 太重了

Vue1.x 推出了一个 Vue-resource，比 jQuery 小，但是 2 之后不维护了

推荐 axios

- 在浏览器中发送 http 请求
- 在 nodejs 里面也可以
- 支持 Promise API
- 拦截请求和响应
- 转换请求和响应数据
- ...

[官方 Github](https://github.com/axios/axios)第一句就说'Promise based HTTP client for the browser and node.js'

所以 Promise 很重要啊

### Features

- Make [XMLHttpRequests](https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest) from the browser
- Make [http](http://nodejs.org/api/http.html) requests from node.js
- Supports the [Promise](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise) API
- Intercept request and response
- Transform request and response data
- Cancel requests
- Automatic transforms for JSON data
- Client side support for protecting against [XSRF](http://en.wikipedia.org/wiki/Cross-site_request_forgery)

### 使用

**我觉得直接看 github 上面写的 api 文档吧，很清楚**

并发的 all 用法，传递一个数组，元素是 axios

```js
axios
  .all([
    axios.get("https://www.coyoo.xyz/api/v1.0/boxes"),
    axios.get("https://www.coyoo.xyz/api/v1.0/snacks"),
    // ]).then(results => {
    //   window.console.log(results)
    // })	// 也可以用下面的axios的函数解包，本身then要传入一个回调函数，axios.spread在源码定义里面也是一个callback，其参数也是一个callback，一开始看的时候有些晕
  ])
  .then(
    axios.spread((res1, res2) => {
      window.console.log(res1);
      window.console.log(res2);
      // 这个res1和res2是按照数组的顺序的
    })
  );
```

### 全局配置信息

不用每次是有都去配置了，还是看[官网](https://github.com/axios/axios#config-defaults)

例如 axios.defaults.baseUrl

或者源码

```js
export interface AxiosRequestConfig {
  url?: string;
  method?: Method;
  baseURL?: string;
  transformRequest?: AxiosTransformer | AxiosTransformer[];
  transformResponse?: AxiosTransformer | AxiosTransformer[];
  headers?: any;
  params?: any;
  paramsSerializer?: (params: any) => string;
  data?: any;
  timeout?: number;
  timeoutErrorMessage?: string;
  withCredentials?: boolean;
  adapter?: AxiosAdapter;
  auth?: AxiosBasicCredentials;
  responseType?: ResponseType;
  xsrfCookieName?: string;
  xsrfHeaderName?: string;
  onUploadProgress?: (progressEvent: any) => void;
  onDownloadProgress?: (progressEvent: any) => void;
  maxContentLength?: number;
  validateStatus?: (status: number) => boolean;
  maxRedirects?: number;
  socketPath?: string | null;
  httpAgent?: any;
  httpsAgent?: any;
  proxy?: AxiosProxyConfig | false;
  cancelToken?: CancelToken;
}
```

### 创建 axios 实例，便于封装，也便于配置

每一个 baseUrl 的请求都封装成一个 instance

`const instance = axios.create({...})`

```js
axios.defaults.timeout = 1000;
axios.defaults.baseURL = "https://www.coyoo.xyz/api/v1.0";

axios
  .all([
    // axios.get('https://www.coyoo.xyz/api/v1.0/boxes'),
    axios.get("/boxes"), // 全局配置的baseURL会生效 且不冲突
    axios.get("https://www.coyoo.xyz/api/v1.0/snacks"),
  ])
  .then(
    axios.spread((res1, res2) => {
      window.console.log(res1);
      window.console.log(res2);
    })
  )
  .catch(() => window.console.log("time outttt"));

const instance = axios.create({
  baseURL: "https://www.coyoo.xyz/api/v1.0",
  timeout: 4000,
});

instance
  .get("/boxes")
  .then((res) => window.console.log("instance axios " + res));
```

不要在每一个组件里面都导入 axios，这样太依赖这个第三方模块了，所以比较合理的是

封装起来，然后挂载到 Vue 实例下，如果 axios 挂了，直接该封装的地方，仔细看看下面的封装

```js
import axios from "axios";
// 如果以后要换框架，直接修改下面的函数体 重新用Promise封装就好了

export function requestPromise(config) {
  // // 用Promise封装，then和catch留给用户自己写 这里处理完axios的then和catch调用了
  // // Promise的resolve和reject
  // return new Promise((resolve, reject) => {
  // 	const instance = axios.create({
  // 		baseURL: 'https://www.coyoo.xyz/api/v1.0',
  // 		timeout: 5000
  // 	})

  // 	// 在这里发送网络请求
  // 	instance(config)
  // 		.then(res => {
  // 			resolve(res)
  // 		})
  // 		.catch(err => {
  // 			reject(err)
  // 		}
  // 	)
  // })
  const instance = axios.create({
    baseURL: "https://www.coyoo.xyz/api/v1.0",
    timeout: 5000,
  });
  return instance(config); // 直接返回promise对象 更粗暴
}
export function request(config) {
  const instance = axios.create({
    baseURL: "https://www.coyoo.xyz/api/v1.0",
    timeout: 5000,
  });

  // 在这里发送网络请求，直接传一个config 有success和failure方法的
  instance(config)
    .then((res) => {
      config.success(res);
    })
    .catch((err) => {
      config.failure(err);
    });
  // 有传入success和failure回调函数的
  // instance(config)
  // 	.then(res => {
  // 		success(res)
  // 	})
  // 	.catch(err => {
  // 		failure(err)
  // 	}
  // )
}
```

### 拦截器

拦截请求过程，加过场动画啊什么的

请求失败与否的拦截，有数据

响应的拦截，没有数据，只有错误码

```js
// 拦截器
instance.interceptors.request;
instance.interceptors.response;
```

#### 请求拦截

request 的源码，需要两个函数 use 和 eject，use 里面需要两个函数，分别是请求成功和失败的回调

```ts
export interface AxiosInterceptorManager<V> {
  use(
    onFulfilled?: (value: V) => V | Promise<V>,
    onRejected?: (error: any) => any
  ): number; // 注意这里的都要返回值类型V，传来的也是V
  eject(id: number): void;
}
```

use 的第一个拦截 config，**注意是在请求发送前的拦截**(一般很少出错)，一定要把拦截的东西 return，不然就直接 reject 了，下面的例子

```js
import { requestPromise } from "./network/request";

const config = {
  url: "/boxes",
};

requestPromise(config)
  .then((res) => window.console.log("yes" + res)) // 成功之后遭遇拦截 就失败了
  .catch((err) => window.console.log(err)); // 下面会打印拦截失败信息
// TypeError: Cannot read property 'cancelToken' of undefined
```

为什么要拦截？

- 变化 config 的内容，满足服务器的需求
- 每次发送网络请求，开启请求动画
- 响应拦截成功，关闭动画
- 检查是否有 token，如果没有就拦截请求，让用户先去登录
  - 这里让我想到了爬虫是可以直接向服务器发送请求的，而前端是依附于浏览器的，是浏览器发送了这个请求，好吧说了句废话，但是就想到了

#### 响应拦截

前端接受到服务器传回来的数据之后

` response: AxiosInterceptorManager<AxiosResponse>;`这里的 ts 代码一样用的是这个类，但是他泛型的模板类就是这个 AxiosResponse 了

拦截响应之后，得到的 res 有很多 axios 加进去的东西，我们其实不需要，只关注 data

所以在拦截的时候返回 data 给后面的 promise 就可以了

```js
instance.interceptors.response.use(
  (res) => {
    window.console.log(res);
    return res.data;
  },
  (err) => {
    window.console.log(err);
  }
);
```

## Vue-cli 4 配置文件夹别名

```js
const path = require("path");
function resolve(dir) {
  return path.join(__dirname, dir);
}
// 下面的在vue.config.js里面作为导出对象的一个属性即可
chainWebpack: (config) => {
  config.resolve.alias
    .set("@", resolve("src"))
    .set("assets", resolve("src/assets"))
    .set("components", resolve("src/components"))
    .set("layout", resolve("src/layout"))
    .set("common", resolve("src/common"))
    .set("static", resolve("src/static"));
};
```

番外，这次在 quasar 的项目里面，所以需要在**quasar.config.js**文件里，的 build 属性的对象中加入 chainWebpack 属性

涉及到 webpack 编译的时候

quasar 的官网也写了

> | chainWebpack(chain) | Function | Quasar CLI 生成的扩展 Webpack 配置。 等同于 extendWebpack()，但改为使用 webpack-chain。 |
> | ------------------- | -------- | --------------------------------------------------------------------------------------- |
> |                     |          |                                                                                         |

所以最后在 quasar.config.js 的 build 里面

```js
  extendWebpack (cfg) {
    cfg.module.rules.push({
      enforce: 'pre',
      test: /\.(js|vue)$/,
      loader: 'eslint-loader',
      exclude: /(node_modules|quasar)/
    })
    cfg.resolve.alias
      .set('@', resolve('src'))
      .set('assets',resolve('src/assets'))
      .set('components',resolve('src/components'))
      .set('layout',resolve('src/layout'))
      .set('common',resolve('src/common'))
      .set('static',resolve('src/static'))
  }
```

打扰了。。。第二天居然编译失败报错:`TypeError: cfg.resolve.alias.set is not a function`

放回 chainWebpack 里就可以。。。。。。

## 会被经常用的组件，给 class，仅一个的给 id

## 网络请求函数的分离

从 vue 文件里抽离出来，减少和 vue 数据逻辑代码的耦合

## 编辑器中生成一堆 li 标签

`li{内容和下标$}*10000`

## Better Scroll 框架学习

解决更好的在移动端上的 scroll 操作效果

[github](https://github.com/ustbhuangyi/better-scroll)作者是中国人，一个慕课讲师，很牛逼，better-scroll 是参考了之前的一个 iscroll 开源项目，但是好像不维护很久了。

安装见 github，目前 2.0 版本是 alpha 和 beta 的，稳定的还是 1.x 版本，`npm install better-scroll -S`

> BetterScroll is implemented with plain JavaScript, which means it's dependency free.

### 用法规定

content 作为滚动的部分的外部必须要有一个容器，容器里必须有一个内容容器，在 content 里面滑动

![来自官方](http://static.galileo.xiaojukeji.com/static/tms/shield/scroll-4.png)

将这个容器 wrapper 的 dom 传递给 BScroll 实例，以及所需要的 options。

吐槽一下这个 wrapper 拼错。。

```js
import BScroll from "better-scroll";

new BScroll(document.querySelector(".wrapper"), {
  // options
});
```

配置完的效果真的可以！但是是模拟手指在屏幕上滑动的操作才能看到滚动，鼠标的滚轮其实只是 window 的内容。

### 功能 API

全部的 api 见[文档](https://ustbhuangyi.github.io/better-scroll/doc)

#### on

监听一个自定义事件，仅仅一次，触发之后就移除监听器

Listen for a custom event, but only once. The listener will be removed once it triggers for the first time.

这个**event**，better-scroll 也定义了很多，在文档里看

比如 scroll 这个事件，能实时获取到滚动的 position，需要 probeType 这个**option**

scroll

- Parameters: `{Object} {x, y}` real time coordinates during scroll.
- Trigger timing: During scoll，specific timing depends on the option of [probeType](https://ustbhuangyi.github.io/better-scroll/doc/en/options.html#probetype).
  - 侦测类型，这个选项有 4 个值，0，1，2，3
    - 0 不开启
    - 1 的话不是实时，而是滑动**一段时间**侦测，当手指按住屏幕滑动
    - 2 是实时滑动就会侦测
    - 3 是全时段侦测，也就是松开手指继续惯性滑动也会，滑到底反弹的效果也会

还有很多事件，有需求看文档吧。

**监听的坐标，是左上角的原点位置，所以，页面下滑的时候，y 坐标是负的**

### 在 vue 中封装

封装一个组件，里面用到 better-scroll，可以被其他组件引用，甚至其他的 vue 项目

显然这个 vue 文件里，模板是有 slot 的

```html
<scroll>
  <!-- ...-->
</scroll>
```

但是还是要设置 scroll 的高度

绑定 document.querySelector 不好，因为如果别的文件里的 html 也有一样的 class 或者 id，那么就会选择第一个出现的，会出 bug。

所以用 vue 里的 ref 属性，上面父子通信里面有讲，在元素标签上给 ref 属性，用`this.$refs.xxx`来获得

同时可以封装一个 scrollTo 函数，以便父组件使用

## 单位 vh vw

viewport height/width

就是整个可以看到的视角的高度/宽度

屏幕高 1000px，但是内容可能 4000px 高

确定中间的高度，用视口高度 vh100%-顶部和底部的两个高度即可

## 关于 JS 中的引用

在写 vue 的时候发现，父组件传递参数到子组件的时候，如果传递的是对象，即使加了`.sync`，传递的数据通过`=`直接赋值新的值，子组件的 watcher 也 watch 不到，然后用自己写的 deepCopy 就可以了

deepCopy 就是用 JSON 先解析成字符串，再解析回来。

### 记录几种 js 删除数组元素的方法

用 forEach 找到下标，arr 是 readonly，但是可以调用其 splice 方法来删除

```js
college.courseItems.forEach((value, index, arr) => {
  if (value.id === newValue.id) {
    arr.splice(index, 1);
  }
});
```

用 findIndex 来找下标，同样用 splice 来删

```js
college.courseItems.splice(
  college.courseItems.findIndex((item) => item.id === newValue.id),
  1
);
```
