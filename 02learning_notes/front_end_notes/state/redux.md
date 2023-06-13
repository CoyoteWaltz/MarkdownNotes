# Redux

> 参考来自[一天一个轮子](https://github.com/haixiangyan/make-wheels)项目的 [redux](https://github.com/haixiangyan/my-redux)

## Redux Intro

Redux 和 React 根本没关系。

看 Redux 的官网开头：**["A Predictable State Container for JS Apps"](https://redux.js.org/)**。再看 Vuex 的官网开头：**["Vuex is a state management pattern + library for Vue.js applications"](https://vuex.vuejs.org/)**。

默认大家写 react 的时候都用过，并且也很熟悉了，就不多说了。

## 源码解读

推荐直接看项目和 [github](https://github.com/reduxjs/redux) 结合，redux 其实并不复杂，非常简单，亮点是比较多的用函数式编程，比如 [applyMiddleware](https://github.com/reduxjs/redux/blob/master/src/applyMiddleware.ts#L69) 里面用到 `compose`
