# Redux 学习手册

## 使用过程中遇到的问题

在使用 redux 和 react-redux 时，遇到了一些麻烦，这个麻烦就是在 react 中如何去使用 redux 管理的一些状态数据啊，还有如何调用一个同步或异步 action 啊。

当要使用 redux 管理的一些状态时，那么就要把 react 中的展示组件变成容器组建，通过 props 的方式向组件传递 state 和一些 action

## 三大原则

**单一数据流**

使用 redux 的程序，所有的 state 都存储在一个单一的数据源 store 内部，类似一个巨大的对象树。

**state 是只读的**

state 是只读的，能改变 state 的唯一方式是通过触发action来修改

**使用纯函数执行修改**

为了描述 action 如何改变 state tree ， 你需要编写 reducers。

reducers 是一些纯函数，接口当前 state 和 action。只需要根据 action，返回对应的 state。而且必须要有返回。

*一个函数的返回结果只依赖于它的参数，并且在执行过程里面没有副作用，我们就把这个函数叫做纯函数*

## action

顾名思义，action就是动作，也就是通过动作来修改state的值。也是修改store的唯一途径。

action本质上就是一个普通js对象，我们约定这个对象必须有一个字段type，来表示我们的动作名称。一般我们会使用一个常量来表示type对应的值。

此外，我们还会把希望state变成什么样子的对应的值通过action传进来，那么这里action可能会类似这样子的

```
{
    type: 'TOGGLE_TODO',
    index: 5
}
```

## Reducer

Action 只是描述了有事情发生了这件事实，但并没有说明要做哪些改变，这正是reducer需要做的事情。

Reducer作为纯函数，内部不建议使用任何有副作用的操作，比如操作外部的变量，任何导致相同输入但输出却不一致的操作。

如果我们的reducer比较多，比较复杂，我们不能把所有的逻辑都放到一个reducer里面去处理，这个时候我们就需要拆分reducer。

幸好，redux提供了一个api就是combineReducers Api。

## store

store是redux应用的唯一数据源，我们调用createStore Api创建store。

## API

### createStore(reducer, [preloadedState], enhancer)

#### 参数

1. `reducer` *(Function)*: 接收两个参数，分别是当前的 state 树和要处理的 [action](https://www.redux.org.cn/docs/Glossary.html#action)，返回新的 [state 树](https://www.redux.org.cn/docs/Glossary.html#state)。
2. [`preloadedState`] *(any)*: 初始时的 state。 在同构应用中，你可以决定是否把服务端传来的 state 水合（hydrate）后传给它，或者从之前保存的用户会话中恢复一个传给它。如果你使用 [`combineReducers`](https://www.redux.org.cn/docs/api/combineReducers.html)创建 `reducer`，它必须是一个普通对象，与传入的 keys 保持同样的结构。否则，你可以自由传入任何 `reducer` 可理解的内容。
3. `enhancer` *(Function)*: Store enhancer 是一个组合 store creator 的高阶函数，返回一个新的强化过的 store creator。这与 middleware 相似，它也允许你通过复合函数改变 store 接口。

#### 返回值

([*Store*](https://www.redux.org.cn/docs/api/Store.html)): 保存了应用所有 state 的对象。改变 state 的惟一方法是 [dispatch](https://www.redux.org.cn/docs/api/Store.html#dispatch) action。你也可以 [subscribe 监听](https://www.redux.org.cn/docs/api/Store.html#subscribe) state 的变化，然后更新 UI。

### subscribu(listener)

#### 参数

1. `listener` (*Function*): 每当 dispatch action 的时候都会执行的回调。state 树中的一部分可能已经变化。你可以在回调函数里调用 [`getState()`](https://www.redux.org.cn/docs/api/Store.html#getState) 来拿到当前 state。store 的 reducer 应该是纯函数，因此你可能需要对 state 树中的引用做深度比较来确定它的值是否有变化。

每次通过`dispatch` 修改数据的时候，其实只是数据发生了变化，如果不手动调用 `render`方法，页面上的内容是不会发生变化的。

但是每次dispatch之后都手动调用很麻烦啊，所以就使用了发布订阅模式，监听数据变化来自动渲染。

## react-thunk

react-thunk作用：使我们可以在action中返回函数，而不是只能返回一个对象。然后我们可以在函数中做很多事情，比如发送异步的ajax请求。

```js
export const getList = () => {
  return (dispatch) => {
      axios.get('/api/headerList.json').then(
        (res) => {
          const data = res.data;
          dispatch(changeList(data.listData))
        }
      )
}
```

这就是react-thunk的使用方法。接受一个dispatch参数，返回一个函数。store发现action是一个函数，就会自动执行这个函数。