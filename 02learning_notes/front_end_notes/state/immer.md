# immer 探索

> https://github.com/immerjs/immer
>
> 源码略难懂，看不下去啦嘿嘿

### 能做什么

allows you to work with immutable state in a more convenient way.

在很多单向数据流场景，我们都需要将最新的 state 返回给下一个 status，会遇到多层嵌套对象需要改属性的场景

```javascript
return {
  ...state,
  foo: {
    ...state.foo,
    gar: 123,
  },
};
```

Immer 是能够通过记录你草稿的方式让不可变数据能更好的被修改！

```javascript
import produce from "immer";

const nextState = produce(baseState, (draft) => {
  draft[1].done = true;
  draft.push({ title: "Tweet about it" });
});
```

### [兼容性问题](https://immerjs.github.io/immer/installation/)

> for old JS engine

若要支持 es5 需要开启 `enableES5()`

使用了 `Map` 或者 `Set` 需要 `enableMapSet()`！看了下源码是在 produce 的时候构造 DraftMap/DraftSet（继承了 Map/Set）

使用 JSON Patch `enablePatches()`

一键开启所有 `enableAllPlugins()`

相当于是内置 polyfill，会增大一定的包体积（每个插件都 < 1KB gzip，vanilla immer 有 ~3KB gzipped）

### 使用

#### basic produce

`produce(baseState, recipe: (draftState) => void): nextState`

```javascript
import produce from "immer";

const baseState = [
  {
    title: "Learn TypeScript",
    done: true,
  },
  {
    title: "Try Immer",
    done: false,
  },
];

const nextState = produce(baseState, (draftState) => {
  draftState.push({ title: "Tweet about it" });
  draftState[1].done = true;
});
```

#### Curried produce

对于 state 的操作，可能会再次封装从而改变想要改变的属性，`produce` 提供了 _currying_ 的做法

```javascript
import produce from "immer";

// curried producer:
const toggleTodo = produce((draft, id) => {
  const todo = draft.find((todo) => todo.id === id);
  todo.done = !todo.done;
}); // -> (state: T) => nextState: T

const baseState = [
  /* as is */
];

const nextState = toggleTodo(baseState, "Immer");
```

#### React & Immer

#### [useImmer](https://github.com/immerjs/use-immer)

> 可以自动的将 update function 包裹在 `produce` 中
>
> 也可以用 useImmerReducer

```jsx
import React, { useCallback } from "react";
import { useImmer } from "use-immer";

const TodoList = () => {
  const [todos, setTodos] = useImmer([
    {
      id: "React",
      title: "Learn React",
      done: true
    },
    {
      id: "Immer",
      title: "Try Immer",
      done: false
    }
  ]);

  const handleToggle = useCallback((id) => {
    setTodos((draft) => {
      const todo = draft.find((todo) => todo.id === id);
      todo.done = !todo.done;
    });
  }, []);

  const handleAdd = useCallback(() => {
    setTodos((draft) => {
      draft.push({
        id: "todo_" + Math.random(),
        title: "A new todo",
        done: false
      });
    });
  }, []);
```

#### [Class](https://immerjs.github.io/immer/complex-objects)

如果用的是 class/有 prototype 生成的对象变量，需要声明和 immer 的兼容性

```javascript
import { immerable } from "immer";

class Foo {
  [immerable] = true; // Option 1

  constructor() {
    this[immerable] = true; // Option 2
  }
}

Foo[immerable] = true; // Option 3
```
