# React

官方教程：https://reactjs.org/docs/getting-started.html

https://www.taniarascia.com/getting-started-with-react/

## What is React?

_[v17 release](https://reactjs.org/blog/2020/10/20/react-v17.html)_ 没啥很大的更新，只有一个是将事件委托代理给了 root 元素，而非之前的 document 对象

同时更新了新的 [jsx-transform](https://reactjs.org/blog/2020/09/22/introducing-the-new-jsx-transform.html)，对于原有代码不产生影响，但打包效率和转换代码上有细微差距，同时我们也不需要在 jsx 代码中 import react 了。详情看文档。

---

- React is a JavaScript library - one of the most popular ones, with [over 100,000 stars on GitHub](https://github.com/facebook/react).
- React is **not a framework** (unlike Angular, which is more opinionated).
- React is an open-source project created by Facebook.
- React is used to build user interfaces (UI) on the front end.
- React is the **view** layer of an MVC application (Model View Controller)

### 构建用户界面的 JS 库

并不是一个框架，没有提供完整的解决方案，需要通过结合其他的库（react-router、redux ...）

### 声明式编程、组件化

#### 声明式编程

_V.S 命令式编程：一条一条告诉浏览器怎么做（渲染）_

只需要定义一个组件即可，具体的渲染流程交给 React 去做，不必关心（黑盒操作）

#### 组件化

JSX

### 一次学习，随处编写

渲染器：

- React DOM：web

- React Native：移动端
- React 360：VR 设备界面
- ...

React 只是一个 JS 库来构建用户界面的，配合相应的渲染器转换在不同环境/设备上即可

## Installation

[create-react-app](https://github.com/facebook/create-react-app)

利用了 webpack 打包的一个工具，为了方便开发，维护

我直接安装在全局了，不过[官方](https://create-react-app.dev/docs/getting-started/)推荐用`npx`指令去使用这个脚手架，不推荐安装在全局，因为`npx`总能获得最新的版本，可以看阮一峰对`npx`的[介绍](http://www.ruanyifeng.com/blog/2019/02/npx.html)（npx 将`create-react-app`下载到一个临时目录，使用以后再删除）

```bash
npm i -g create-react-app
```

创建一个

```bash
create-react-app react-tutorial
# or
npx create-react-app react-tutorial
```

## Chrome 调试工具

[React DevTools for Chrome](https://chrome.google.com/webstore/detail/react-developer-tools/fmkadmapgofadopljbjfkapdkoienihi)

## JSX

Javascript + XML 结合体嘛，所以在 jsx 文件中可以使用 html

并不是需要强制（mendatory）用 jsx，而且 JSX 包含了 JS 的全名，所以更接近于 JS

```jsx
// js 和 xml 的结合的写法就叫 jsx
const heading = <h1 className="yes">hello rrrrrr</h1>;

const _heading = React.createElement(
  "h1",
  {
    className: "yes",
  },
  "hello rrrr"
);
```

### 特性

Properties and methods in JSX are camelCase

Self-closing tags _must_ end in a slash - e.g. `<img />`

可用`{}`在 JSX 中插入 js 变量

```jsx
const title = "yes ok";
const heading = <h1 className="yes">hello {title}</h1>;
```

> JSX is easier to write and understand than creating and appending many elements in **vanilla JavaScript**, and is one of the reasons people love React so much.

Ps: 为什么都喜欢用 **vanilla JavaScript**（vanilla: lacking distinction）所以这样解释就可以了：JSX 为原本朴素无华的 JS 增加了活力

## 组件

class 写法和简单写法两种

### class 写法

```jsx
// Table.jsx
// 模块的 jsx 文件名就保持和 class 名一样吧
// 组件都是个 class 感觉思路比较清楚吧 每次使用组件也就是实例化一次

class Table extends Component {
  render() {
    return (
      <table>
        <thead>
          <tr>
            <th>name</th>
            <th>job</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>name</th>
            <th>job</th>
          </tr>
          <tr>
            <th>name</th>
            <th>job</th>
          </tr>
          <tr>
            <th>name</th>
            <th>job</th>
          </tr>
          <tr>
            <th>name</th>
            <th>job</th>
          </tr>
        </tbody>
      </table>
    );
  }
}
```

这个组件类的 render 函数，返回一个 JSX 模版即可

### simple component（函数组件）

```jsx
// simple component 和 class 的写法差不多 相当于是 render 函数
const TableHeader = (column = "", name = "") => {
  return (
    <thead>
      <tr>
        <th>column</th>
        <th>name</th>
      </tr>
    </thead>
  );
};

const TableBody = () => {
  return (
    <tbody>
      <tr>
        <th>name</th>
        <th>job</th>
      </tr>
      <tr>
        <th>name</th>
        <th>job</th>
      </tr>
      <tr>
        <th>name</th>
        <th>job</th>
      </tr>
      <tr>
        <th>name</th>
        <th>job</th>
      </tr>
    </tbody>
  );
};

class Table extends Component {
  render() {
    return (
      <table>
        <TableHeader />
        <TableBody />
      </table>
    );
  }
}
```

**注意：函数组件的函数名[一定要是首字母大写](https://reactjs.org/docs/jsx-in-depth.html#user-defined-components-must-be-capitalized)的。。不然`create-react-app`就给你报错，说你不是个函数组件。。。**

### 组件属性/值/数据

组件可以接受属性值 props，在父组件中将数据以 html 属性的形式传递给子组件

**是 read-only 的**

```jsx
import Child from "./Child";

class App extends Component {
  render() {
    const appName = "yes ok";
    return (
      // 这里的 class 变成了 className 这其实是 js
      <div className="App">
        <h1>Ha ha ha</h1>
        <Child appName={appName} />
      </div>
    );
  }
}
```

在子组件可以通过`this.props`获取，_注意 js 的 props 是 html 上的 attributes，思维需要转换一下，而不是 attribute 传递的值，踩坑。。_

```jsx
import React, { Component } from "react";

class Child extends Component {
  render() {
    console.log(this.props);
    const { appName } = this.props;
    return <div className="child">{appName}</div>;
  }
}

export default Child;
```

在 simple component 中通过函数的参数获取属性

```jsx
const TableBody = (props) => {
  const rows = props.data.map((value) => {
    return (
      // 注意这里加了个 key 感觉和 vue for 的 key 用途一样？
      <tr key={index}>
        <th>{value.name}</th>
        <th>{value.age}岁</th>
      </tr>
    );
  });
  return <tbody>{rows}</tbody>;
};

class Table extends Component {
  render() {
    console.log(this.props.tableData);
    return (
      <table>
        <TableHeader />
        <TableBody data={this.props.tableData} />
      </table>
    );
  }
}
```

## 生命周期

生命周期还是蛮重要的吧，在 Class 组件中用的应该很多，但是在函数组件中就用 Hooks 取代了，其实也是避免去使用生命周期钩子（他们的名字长的不好记忆）

一下生命周期函数都是在 Class 组件，作为类的实例方法

### `static getDerivedStateFromProps()`

> https://reactjs.org/docs/react-component.html#static-getderivedstatefromprops

会在每次 render **之前**调用这个生命周期 hook，在第一次 mount 和后续更新都会触发，需要返回一个 object 或者 null 来更新 state

注意是 render 之前调用，所以会在 componentDidMount 之前就触发

用起来有点束手束脚，因为是 static 方法。。。还是用 componentDidUpdate 吧

### componentDidMount

和 Vue 的`mounted`接近，比如我们可以设置定时器，让类的私有成员记录这个 timer

```jsx
componentDidMount() {
  this.timerID = setInterval(
    () => this.tick(),
    1000);
}
```

在 unmount 的时候清除定时器

```jsx
componentWillUnmount() {
  clearInterval(this.timerID);
}
```

### componentWillUnmount

## state

传递来的属性是只读的（one-way data flow），那么组件怎么保存/改变自己的数据/状态呢

**_source of truth_**

如果我们想对上面的数组数据插入或者删除。

state 能够让我们维护组件内部的数据

```jsx
class App extends Component {
  // 类属性的顶级写法
  state = {
    appName: "yes ok",
    tableData: [
      {
        name: "JOJO",
        age: 12333333333,
      },
    ],
  };
  // 类属性 是一个方法 箭头函数！ 保存当前调用上下文即 App
  removeData = (index) => {
    const { tableData } = this.state;
    this.setState({
      tableData: tableData.filter((v, i) => i !== index),
    });
  };
  // 不能这样用 因为这个类方法要交给子组件 所以里面的 this 是指向 子组件的对象
  // removeData(index) {
  //   console.log('-----', this); // 指向调用他的对象
  //   const { tableData } = this.state;
  //   this.setState({
  //     tableData: tableData.filter((v, i) => i !== index),
  //   });
  // }
  render() {
    return (
      // 这里的 class 变成了 className 这其实是 js
      <div className="App">
        <h1>Ha ha ha</h1>
        // 用 this.state.xxx 得到数据
        <Table tableData={this.state.tableData} />
        <Child appName={this.state.appName} />
      </div>
    );
  }
}
```

**注意这里** ES6 的 class 类方法的`this`，踩坑了！将这个类方法传递给子组件的时候，其实是普通`function`，里面的`this`跟随上下文调用变换，在子组件中调用后，`this`就指向子组件了

所以，用类属性箭头函数来实现，这里其实也不太好用`constructor`因为不知道接受的啥参数，不过`..args`也可以吧

jsx 也必须有一个根元素，和 Vue2 是一个要求

### state 的注意事项

#### 只能通过`setState`去改变 state，不能直接给 state 赋值

#### 可能是异步的更新数据

> React may batch multiple `setState()` calls into a single update for performance.

感觉和 Vue 一样，也是会将 VDOM 的多个变化放到队列里统一做批处理的。

```jsx
// Correct
this.setState((state, props) => ({
  counter: state.counter + props.increment,
}));
```

#### state 的更新是合并的

意味着只需要 set 指定的变更值就可以了，react 自己会合并到新的 state。

但是 useState 不是的哦

## Event handler

和原生的 DOM 事件很像，但是在 react 中都是 camelCase 的

他的值不是字符串，而是在 jsx 中的变量（一个函数）

```jsx
<button onClick={() => doSth()}>Activate Lasers</button>
```

### preventDefault

不能通过在 handler 中 `return false` 来阻止原始行为，必须显式调用 `preventDefault`，比如这样

```jsx
function ActionLink() {
  function handleClick(e) {
    e.preventDefault();
    console.log("The link was clicked.");
  }
  return (
    <a href="#" onClick={handleClick}>
      Click me
    </a>
  );
}
```

> Here, `e` is a synthetic event. React defines these synthetic events according to the [W3C spec](https://www.w3.org/TR/DOM-Level-3-Events/), so you don’t need to worry about cross-browser compatibility. React events do not work exactly the same as native events. See the [`SyntheticEvent`](https://reactjs.org/docs/events.html) reference guide to learn more.

很关键，这里 react 将这个事件都做了一层封装，解决了浏览器兼容性的问题

## lists & keys

### 列表渲染

在 jsx 中渲染列表还是非常简单的，直接用 js 的 map 函数即可

注意 return 的是 jsx，变量用`{}`包裹

```jsx
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) => (
    <li key={number.toString()}>{number}</li>
  ));
  return <ul>{listItems}</ul>;
}

const numbers = [1, 2, 3, 4, 5];
ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById("root")
);
```

上面这个例子中最后将 listItems 放到`ul`中其实也是个数组，但是 jsx 会渲染成多个`li`。

### key

和 Vue 一样，渲染列表的时候给每个 item 都绑定一个 key，给每一个元素一个标识符**（String）**

key 永远都在数组上下文中有效，就是说要把 key 放在 map 函数中。

```jsx
function ListItem(props) {
  // Correct! There is no need to specify the key here:  return <li>{props.value}</li>;}

function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    // Correct! Key should be specified inside the array.
		<ListItem key={number.toString()} value={number} />
	);
  return (
    <ul>
      {listItems}
    </ul>
  );
}

const numbers = [1, 2, 3, 4, 5];
ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById('root')
);
```

以及 key 只是为了给 React 作为组件的提示（[diff 用的](https://reactjs.org/docs/reconciliation.html#keys)），不会传递到组件中

## Form

https://reactjs.org/docs/forms.html

React 中，`textarea`、`selection`标签都用`value`来做双向绑定的语法糖（？），和`input?text`的用法都保持一致了

- controlled components：表单内容被 React 控制的组件，可以理解为`onChange` + `value`

- [uncontrolled components](https://reactjs.org/docs/uncontrolled-components.html)：用 ref 去给元素引用，直接操作他的 DOM，而不是直接操作组件，这样就让

  在 controlled components 中，表单的`value`是在每次 render 的时候被变量所替换的，我们在 uncontrolled components 中是不能这样去控制表单的，如果需要一个初始值，可以给这个元素`defaultValue`

  ```jsx
  render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Name:
          <input
            defaultValue="Bob"          type="text"
            ref={this.input} />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
  ```

`input?file`元素，上传文件，但是这个数据是不可读的，所以在 React 中这个数据流其实是单向的，所以让他作为一个`uncontrolled component`就行了。`this.fileInput = React.createRef();`

官方推荐 [Formik](https://jaredpalmer.com/formik)

## context

[官方教程](https://reactjs.org/docs/context.html)

### context 是什么

> Context provides a way to pass data through the component tree without having to pass props down manually at every level.

也就是说当我们需要向很深的子孙组件传递参数（通信）的时候，可以通过一个上下文（context）变量，而不用在所有组件的 props 中注入

> Context lets us pass a value deep into the component tree without explicitly **threading it through every component**.

### 为什么使用 context

更方便的向组件 broadcast 数据，仅在一处做逻辑更改即可

### API

#### `React.createContext`

```jsx
const MyContext = React.createContext(defaultValue);
```

构造一个 context 对象，当一个组件注册了这个上下文，会读取当前上下文最近的一个`Provider`的数据

The `defaultValue` argument is **only** used when a component does not have a matching Provider above it in the tree. This can be helpful for testing components in isolation without wrapping them. Note: passing `undefined` as a Provider value does not cause consuming components to use `defaultValue`.

#### `Context.Provider`

```jsx
<MyContext.Provider value={/* some value */}>
```

context 对象的`Provider`**组件**（注意是组件）能够让其中的组件注册到这个上下文中，Provider 可以被嵌套的使用，可以在深层 override 他的值

Provider 组件的 value 被改变之后会让其子组件 re-render

#### `Class.contextType`

```jsx
class MyClass extends React.Component {
  componentDidMount() {
    let value = this.context;
    /* perform a side-effect at mount using the value of MyContext */
  }
  componentDidUpdate() {
    let value = this.context;
    /* ... */
  }
  componentWillUnmount() {
    let value = this.context;
    /* ... */
  }
  render() {
    let value = this.context;
    /* render something based on the value of MyContext */
  }
}
MyClass.contextType = MyContext;
```

相当于是让一个（class）组件注册在一个 context 对象上，可以在`this.context`获取到 context 的值

注意只能指定一个 context

#### `Context.Consumer`

上下文的一个 Consumer 组件，可以直接用这个组件来渲染 context 对应变化的结果

```jsx
<MyContext.Consumer>
  {value => /* render something based on the context value */}
</MyContext.Consumer>
```

组件依赖一个函数组件，返回一个 React 节点，value 就是最近 Provider 的 value，如果没有 Provider，参数会是`createContext`创建上下文的`defaultValue`

## React Hook

### 解决的问题

#### 在组件之间复用状态逻辑很难

你可以使用 Hook 从组件中提取状态逻辑，使得这些逻辑可以单独测试并复用。**Hook 使你在无需修改组件结构的情况下复用状态逻辑。** 这使得在组件间或社区内共享 Hook 变得更便捷。

#### 复杂组件变得难以理解

> 我们经常维护一些组件，组件起初很简单，但是逐渐会被状态逻辑和副作用充斥。每个生命周期常常包含一些不相关的逻辑。例如，组件常常在 `componentDidMount` 和 `componentDidUpdate` 中获取数据。但是，同一个 `componentDidMount` 中可能也包含很多其它的逻辑，如设置事件监听，而之后需在 `componentWillUnmount` 中清除。相互关联且需要对照修改的代码被进行了拆分，而完全不相关的代码却在同一个方法中组合在一起。如此很容易产生 bug，并且导致逻辑不一致。

**状态逻辑**在一个组件中的分离，**Hook 将组件中相互关联的部分拆分成更小的函数（比如设置订阅或请求数据）**，而并非强制按照生命周期划分。你还可以使用 reducer 来管理组件的内部状态，使其更加可预测。

#### 难以理解的 class

class 中的**this**，方法的绑定...

> 另外，React 已经发布五年了，我们希望它能在下一个五年也与时俱进。就像 [Svelte](https://svelte.dev/)，[Angular](https://angular.io/)，[Glimmer](https://glimmerjs.com/)等其它的库展示的那样，组件[预编译](https://en.wikipedia.org/wiki/Ahead-of-time_compilation)会带来巨大的潜力。尤其是在它不局限于模板的时候。最近，我们一直在使用 [Prepack](https://prepack.io/) 来试验 [component folding](https://github.com/facebook/react/issues/7323)，也取得了初步成效。但是我们发现使用 class 组件会无意中鼓励开发者使用一些让优化措施无效的方案。class 也给目前的工具带来了一些问题。例如，class 不能很好的压缩，并且会使热重载出现不稳定的情况。因此，我们想提供一个使代码更易于优化的 API。**我觉得这些东西都值得去了解了解**

使用 Hook 就更偏向函数式编程，class 就不用了。

#### Hooks + 函数组件

用 Class 写的组件可以满足我们很多需求（state、生命周期函数等等），但是函数组件太过于简单了（可以用来抽象一些简单的组件），不具备 Class 的各种能力，但是，函数组件的优势就是简单，方便解耦，而这些 Hooks 提供了这些能力（比 Class 写起来还要简单很多），所以他们组合就很香（简单好用）了！

### State Hook

#### useState

返回一对值：`const [state, setState] = useState(0)`

- 第一个是**当前**状态
- 第二个是更新状态的函数，类似 class 组件的 `this.setState`，但是它不会把新的 state 和旧的 state 进行合并。

接受唯一参数：初始的 state

```jsx
function ExampleWithManyStates() {
  // 声明多个 state 变量！
  const [age, setAge] = useState(42);
  const [fruit, setFruit] = useState("banana");
  const [todos, setTodos] = useState([{ text: "Learn Hooks" }]);
  // ...
}
```

解构语法可以让我们取不同的变量名字

### 什么是 Hook

钩子，钩入某些事件（生命周期，或者 state 变化等），每次事件发生就执行的函数

### Effect Hook

我们通常会在组件执行的时候数据获取、订阅或手动修改 DOM，这种操作称作“副作用（side-effect）”。

#### useEffect

> effect 的执行时机：操作 dom 的时候，_异步_ 执行，相当于主线程渲染完才会执行
>
> 和 useLayoutEffect 的区别：useLayoutEffect 是同步执行的，会阻塞主线程

给函数组件增加了副作用的功能，和 class 组件中的 `componentDidMount`、`componentDidUpdate` 和 `componentWillUnmount` 具有相同的用途，只不过被合并成了一个 API。

副作用函数还可以**通过返回一个函数**来指定如何“清除”副作用。例如，在下面的组件中使用副作用函数来订阅好友的在线状态，并通过取消订阅来进行清除操作，看官网的例子

```jsx
import React, { useState, useEffect } from "react";

function FriendStatus(props) {
  const [isOnline, setIsOnline] = useState(null);

  function handleStatusChange(status) {
    setIsOnline(status.isOnline);
  }

  useEffect(() => {
    ChatAPI.subscribeToFriendStatus(props.friend.id, handleStatusChange);
    // 返回一个函数 将在组件销毁的时候执行
    return () => {
      ChatAPI.unsubscribeFromFriendStatus(props.friend.id, handleStatusChange);
    };
  });
  if (isOnline === null) {
    return "Loading...";
  }
  return isOnline ? "Online" : "Offline";
}
```

所以可以看到这个 API 将之前的生命周期合并在一个`useEffect`里面了，同样也可以多次使用，每一个逻辑都不会被拆分和混合了，很棒！

比如在 mounted 的时候添加 interval 定时器，在 destory 的时候释放。。。

但是如果 state 状态改变了，那么会重新执行 render 函数，将重新触发生命周期，可能会导致定时器的重复销毁和构造，此时我们就需要加入 deps 数组。

这个 deps 告诉 React 这个 effect 会依赖哪些变量，这些变量发生变化了才重新执行回调

```jsx
useEffect(() => {
  // 下面每次 setCount 都会 render 每次都会 did mount
  const id = setInterval(() => {
    // setCount(count+1)
    setCount((count) => count + 1); // 这里用函数 来递增 count
  }, 1000);
  console.log(id);
  return () => {
    clearInterval(id);
  };
}, []); // 传入 deps 这里不穿参数 欺骗 react 不依赖变量 所以只会执行一次
```

使用 ESLint 插件 `eslint-plugin-react-hooks@>=2.4.0`，很有必要

该插件除了帮你检查[使用 Hook 需要遵循的两条规则](https://zh-hans.reactjs.org/docs/hooks-rules.html#only-call-hooks-at-the-top-level)外，还会向你提示在使用 useEffect 或者 useMemo 时，deps 应该填入的内容。

### Hook 使用规则

Hook 就是 JavaScript 函数，但是使用它们会有两个额外的规则：

- 只能在**函数最外层**调用 Hook。不要在循环、条件判断或者子函数中调用。
- 只能在 **React 的函数组件**中调用 Hook。不要在其他 JavaScript 函数中调用。（还有一个地方可以调用 Hook —— 就是自定义的 Hook 中，我们稍后会学习到。）

### useMemo

通过一些变量计算出一个值，加入到 deps，如果 deps 没有发生改变，跳过计算。和 Vue 的 computed 属性类似

```js
function makeSentence(data) {
  console.log("computed!!!!!!!!------");
  // 将 quote 每个单词重复两次
  if (!data?.quote) {
    return "";
  }
  const doubled = [];
  data.quote.split(" ").forEach((w) => {
    doubled.push(w);
    doubled.push(w);
  });
  return doubled.join(" ");
}
// 在函数组件中
// 这里 eslint 提示了用 useMemo 仍然会在每次 render 的时候重新计算
// 因为 deps 依赖的是 makeSentence 这个函数 这个函数在每次 render 的时候都被重新创建 所以必然不一样
// 需要用 useCallback 把这个函数先 wrap 一下！ 然后再给 useMemo 用。。
const memoSentence = useMemo(() => makeSentence(data), [data]);
// 解决方案
// 1 在 deps 中去掉这个方法的依赖 不是很好 会有潜在的 bug
// 2 把这个方法放到 函数组件外面！ 推荐 同时也不需要在 deps 中加入 因为不属于组件了
// 3 用 useCallback wrap 这个函数 再放到 useMemo
```

useMemo 中传入的函数，将在 render 函数调用过程被同步调用。

**尽量使用缓存的值**

### useCallback

```jsx
const memoizedCallback = useCallback(() => {
  doSomething(a, b);
}, [a, b]);
```

根据 deps，构造一个 **memorized callback** 并赋值，仅当 deps 变化的时候会重新赋值，因为在函数里面会用到各种闭包外部的函数嘛，hook 本质其实也是闭包嘛，当内部闭包的变量变化之后（deps）重新构造 hook 闭包的这个 callback。

> This is useful when passing callbacks to optimized child components that rely on reference equality to prevent unnecessary renders (e.g. `shouldComponentUpdate`).

`useCallback(fn, deps)` is equivalent to `useMemo(() => fn, deps)`.

> Note
>
> The array of dependencies is not passed as arguments to the callback. Conceptually, though, that’s what they represent: every value referenced inside the callback should also appear in the dependencies array. **In the future, a sufficiently advanced compiler could create this array automatically.**这还挺棒的 hhh

### useRef

> The “ref” object is a generic container whose `current` property is mutable and can hold any value, similar to an instance property on a class.

所以`useRef`构造的 ref 对象就好比是 Class 组件的实例属性，mutable，但不会引起 re-render

初始值会被赋值给`current`属性，接受任何类型，对这个属性可以进行修改

### useReducer

`useState`的另一种选择，为什么呢，可以理解是可以用不同 type 的 action 来改变某个 state，比 useState 更加复杂的逻辑。

`(state, action) => newState`

感觉和 Vuex 的用法差不多，只是把各种的 mutation 封装到一个函数里面用`switch case`去判断了。

可以再去学一学 redux。。。

所以最后的问题是 reduce 到底什么意思呢

### useContext

感觉就是在函数组件里面能使用 context 了（之前是只能在 Class 中使用）

同样用`createContext`构造一个 context 对象，丢给`useContext`即可

[formik](https://formik.org/)，React 的表单 API。。可以去了解一下

### useLayoutEffect

a version of [`useEffect`](https://react.dev/reference/react/useEffect) that fires **before the browser repaints the screen**.

[官方说明](https://react.dev/reference/react/useLayoutEffect)他其实是对性能有损失的，尽可能使用 useEffect

因为：_The code inside `useLayoutEffect` and all state updates scheduled from it **block the browser from repainting the screen.** When used excessively, this makes your app slow. When possible, prefer [`useEffect`.](https://react.dev/reference/react/useEffect)_

所以为什么 useEffect 是异步的，就是让出浏览器的控制权，先绘制页面

什么时候用？比如一些场景：

- Measuring layout before the browser repaints the screen
  - 在 dom 变化之后，paint 之前，需要知道元素的位置/宽高来针对性的作出变化，再次 render 改变 dom，画出正确的页面
  - 具体例子可以看官网，日常也比较实用。**\*All of this needs to happen before the browser repaints the screen.** You don’t want the user to see the component moving.\*

### [useDeferredValue](https://react.dev/reference/react/useDeferredValue)

lets you defer updating a part of the UI.

能够将一部分 UI 更新推迟。

#### 用法

```javascript
const deferredValue = useDeferredValue(value);
```

可以是任意类型的 value，最好是用 state / memo，会随着交互而改变的对象，不然毫无意义。。

返回：

- 在首次 render，返回值和 value 是一致的
- 变更 render 时（value 发生变化），在 re-render 的时候会返回旧的值并渲染，同时 React 会在后台用新的值进行渲染，渲染完后再改变 UI；如果是 Suspense 的内容，React 会放弃这次渲染，在数据获取之后再次渲染

注意

- 传入的值应该是**基础类型**，或者在 render 外部创建的对象，不然每次新对象传入在每次 render 都会是最新的，会导致不必要的后台渲染。
- 由于值变化（`Object.is` 判断）触发的后台渲染是可以被打断的：如果渲染期间 value 的又变化（比如键盘输入）；每次都是用最新的 value 进行后台渲染
- 和 `<Suspense>` 的集成：通过 useDeferredValue 的后台渲染的结果是一个 suspend 的部分，此时不会出现 fallback 元素，会一直渲染旧的值，直到新的数据加载完。（换句话说，Suspense 和 useDeferredValue 一起之后，Suspense 的 fallback 能力会被 old value 的渲染给替代了）
- 后台渲染不会触发 Effects，直到被画在屏幕上才会。

#### 使用场景

> 官网的例子非常生动

1. 在新数据加载的时候，可以渲染旧数据
2. 表示内容是过时的
   1. 在 deferred 的过程中，可以改变样式

```jsx
import { Suspense, useState, useDeferredValue } from "react";
import SearchResults from "./SearchResults.js";

export default function App() {
  const [query, setQuery] = useState("");
  const deferredQuery = useDeferredValue(query);
  const isStale = query !== deferredQuery;
  return (
    <>
      <label>
        Search albums:
        <input value={query} onChange={(e) => setQuery(e.target.value)} />
      </label>
      <Suspense fallback={<h2>Loading...</h2>}>
        <div
          style={{
            opacity: isStale ? 0.5 : 1,
            transition: isStale
              ? "opacity 0.2s 0.2s linear"
              : "opacity 0s 0s linear",
          }}
        >
          <SearchResults query={deferredQuery} />
        </div>
      </Suspense>
    </>
  );
}
```

3. 推迟一部分 UI 的 re-render
   1. **建议直接看官网例子**，对于跟随频繁交互（比如键盘输入）而重新渲染的复杂组件（比如长列表），可以用 deferred value 去优化
      1. 优化前：键盘输入事件的响应会被长列表的渲染给阻塞，导致用户输入卡顿
      2. 优化后：通过后台渲染，交还控制权给浏览器响应和渲染，让输入和渲染不会冲突/卡顿，同时其实也做到了长列表的 debounced render

### [useSyncExternalStore](https://react.dev/reference/react/useSyncExternalStore)

目前大部分的状态管理库都在用这个作为 hooks 的连接。

这个 hook 的作用就是能够让外部 store 和当前组件产生订阅关系，也可以订阅 store、browser API、自定义 hook 逻辑、支持 server rendering

_[React discussion](https://github.com/reactwg/react-18/discussions/86)_

`useSyncExternalStore(subscribe, getSnapshot, getServerSnapshot?)`

- subscribe：用来订阅到一个 store 的**方法**并且返回 unsubscribe 方法，**这个方法接受一个参数是函数，需要在 store 数据发生变化的时候调用，会触发组件的 re-render**
- getSnapshot：返回 store 当前数据的**方法**，需要是幂等的（store 没发生变化的时候，每次调用获取的数据都是一致），如果 store 发生变化，并且比较之后不一致（`Object.is`）也会 re-render

看下 zustand 中是如何将 store 作为 hook 输出的（selector）

```typescript
import { useSyncExternalStoreWithSelector } from "use-sync-external-store/shim/with-selector";

export function useStore<TState, StateSlice>(
  api: WithReact<StoreApi<TState>>,
  selector: (state: TState) => StateSlice = api.getState as any,
  equalityFn?: (a: StateSlice, b: StateSlice) => boolean
) {
  const slice = useSyncExternalStoreWithSelector(
    api.subscribe,
    api.getState,
    api.getServerState || api.getState,
    selector,
    equalityFn
  );
  useDebugValue(slice);
  return slice;
}
```

订阅 browser API（react 官网例子）

```typescript
import { useSyncExternalStore } from "react";

export default function ChatIndicator() {
  const isOnline = useSyncExternalStore(subscribe, getSnapshot);
  return <h1>{isOnline ? "✅ Online" : "❌ Disconnected"}</h1>;
}

function getSnapshot() {
  return navigator.onLine;
}

function subscribe(callback) {
  window.addEventListener("online", callback);
  window.addEventListener("offline", callback);
  return () => {
    window.removeEventListener("online", callback);
    window.removeEventListener("offline", callback);
  };
}
```

### [use](https://react.dev/reference/react/use)

一个还在试验中的 hook，用来在 FC 中读取 Promise/Context 资源的值，在 Promise pending 的时候会直接使用外层的 `Suspense` 渲染，rejected 的时候会触发外层 `ErrorBoundary`

说实话没有太 get 到使用场景。。。后续遇到在看吧

注意点：

- 可以出现在 if/循环语句中（其他 hook 不行）
- 更推荐替代 useContext，灵活度更高
- 将 Promise 从服务端组件传递到客户端组件的时候，resolve 的数据必须是可序列化的

## Fragments

`<React.Fragment>`这个标签里面可以放一组元素标签，可以不需要产生额外的 DOM 节点。

> Fragments let you group a list of children without adding extra nodes to the DOM.

```jsx
render() {
  return (
    <React.Fragment>
      <ChildA />
      <ChildB />
      <ChildC />
    </React.Fragment>
  );
}
```

### 为什么

首先 React 组件和 Vue 是一样的，组件的 template 必须要有一个`<div>`来包裹

如果是下面这个情况，Columns 组件返回的 template 必须只能有一个根结点，但是在`<td>`外用`<div>`来包裹就不能在 HTML 中被正常解析了，所以此时就需要用`React.Fragment`了！

```jsx
class Table extends React.Component {
  render() {
    return (
      <table>
        <tr>
          <Columns />
        </tr>
      </table>
    );
  }
}
```

```jsx
class Columns extends React.Component {
  render() {
    return (
      <div>
        <td>Hello</td>
        <td>World</td>
      </div>
    );
  }
}
```

改成这样：

```jsx
class Columns extends React.Component {
  render() {
    return (
      <React.Fragment>
        <td>Hello</td>
        <td>World</td>
      </React.Fragment>
    );
  }
}
```

### 简写语法

`<>` & `</>`

```jsx
class Columns extends React.Component {
  render() {
    return (
      <>
        <td>Hello</td>
        <td>World</td>
      </>
    );
  }
}
```

### 带 key 的 fragment

```jsx
function Glossary(props) {
  return (
    <dl>
      {props.items.map((item) => (
        // Without the `key`, React will fire a key warning
        <React.Fragment key={item.id}>
          <dt>{item.term}</dt>
          <dd>{item.description}</dd>
        </React.Fragment>
      ))}
    </dl>
  );
}
```

给数组渲染 list 可以在整个外部容器上加 key，也不需要用`div`来包裹了。

## React APIS

### React.memo

一个高阶组件函数，接受一个函数组件，在外面 wrap 一层：

如果这个组件的 props 和 render 结果保持一一对应不变的关系（相同的 props 会 render 出一样的结果），那么在 memo 模式下，可以减少重新渲染（仿佛就是计算 computed 属性/组件）

只会检查 props 是否改变（浅比较），If your function component wrapped in `React.memo` has a `useState` or `useContext` Hook in its implementation, it will still rerender when state or context change.

如果需要自定义的比较函数，可以作为第二个参数

```jsx
function MyComponent(props) {
  /* render using props */
}
function areEqual(prevProps, nextProps) {
  /*
  return true if passing nextProps to render would return
  the same result as passing prevProps to render,
  otherwise return false
  */
}
export default React.memo(MyComponent, areEqual);
```

_This method only exists as a **[performance optimization](https://reactjs.org/docs/optimizing-performance.html).** Do not rely on it to “**prevent**” a render, as this can lead to bugs._

### React.forwardRef

[官方文档](https://reactjs.org/docs/forwarding-refs.html)

> 一句话解释：透传 ref 给内部封装的组件

这个 API 包裹在一个函数组件外（**实际上是接受一个 render function**，也是一个 HOC 吧），能够让其他组件传递 ref 给这个组件，在这个组件中能把这个*透传*的 ref 也传递给内部封装的元素。

```jsx
// 这个 render function 多接受一个 ref
const FancyButton = React.forwardRef((props, ref) => (
  <button ref={ref} className="FancyButton">
    {props.children}
  </button>
));

// You can now get a ref directly to the DOM button:
const ref = React.createRef();
<FancyButton ref={ref}>Click me!</FancyButton>;
```

使用场景？写组件库会的时候比较好用

## Higher-Order Components

所谓的 HOC！
