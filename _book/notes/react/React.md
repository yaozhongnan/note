# React

## 核心概念

### 虚拟DOM（Virtual Document Object Model）
 + **DOM 的本质是什么**：浏览器中的概念，用JS对象来表示页面上的元素，并提供了操作 DOM 对象的API；
 + **什么是 React 中的虚拟 DOM**：是框架中的概念，是程序员用JS对象来模拟页面上的 DOM 和 DOM 嵌套；
 + **为什么要实现虚拟 DOM（虚拟 DOM 的目的）：**为了实现页面中， DOM 元素的高效更新
 + **DOM 和虚拟 DOM 的区别**：
    + **DOM：**浏览器中，提供的概念；用 JS 对象，表示页面上的元素，并提供了操作元素的 API；

    + **虚拟 DOM：**是框架中的概念；而是开发框架的程序员，手动用JS对象来模拟DOM元素和嵌套关系；
      + 本质： 用 JS 对象，来模拟 DOM 元素和嵌套关系；
      + 目的：就是为了实现页面元素的高效更新；
### Diff 算法
 - **tree diff:** 新旧两棵DOM树，逐层对比的过程，就是 Tree Diff； 当整颗 DOM 逐层对比完毕，则所有需要被按需更新的元素，必然能够找到；

 - **component diff：**在进行 Tree Diff 的时候，每一层中，组件级别的对比，叫做 Component Diff；
    - 如果对比前后，组件的类型相同，则**暂时**认为此组件不需要被更新；
    - 如果对比前后，组件类型不同，则需要移除旧组件，创建新组件，并追加到页面上；

 - **element diff:  **在进行组件对比的时候，如果两个组件类型相同，则需要进行 元素级别的对比，这叫做 Element Diff；

## 一些知识点

+ setState() 的调用是异步的，不要在调用 setState() 之后，紧接着依赖 this.state 来反射新值

+ 当组件中的 state 数据发生变化，则组件会重新调用 render 函数。父组件中的 props 发生变化，则子组件也会重新调用 render 函数。

+ react 中绑定事件传递参数的两种方式（注意使用 bind 传参时 e 对象要放在最后使用，但无需传递）

  + ```jsx
    <button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
    ```

  + ```jsx
    <button onClick={this.deleteRow.bind(this, id)}>Delete Row</button>
    ```

+ react 中阻止事件默认行为只能通过 ``e.preventDefault()`` 的方式。

+ 无状态组件与有状态组件的区别就在于是否拥有自己的 state。

+ 在 React 中，使用组件的组合，而非继承

+ 本质上来讲，JSX 只是为 ``React.createElement(component, props, ...children)``方法提供的语法糖

+ diffing 算法用来找出两棵树的所有不同点

### 受控组件

受控组件基本是一些 HTML 的表单元素，类似 Input, select, textarea 等。它们都会维持各自的状态。

但在 React 中，可变的状态是保存在 state 中的，并且更新只能使用 setState() 方法。

因此结合两者， React 负责渲染表单的组件仍然控制着用户后续输入所发生的变化，但值由 React 控制的输入表单元素称为**受控组件**

简而言之：值由 React 的 state 管理的表单元素称为**受控组件**

### 非受控组件

在大多情况下，推荐使用受控组件来实现表单，表单数据由 React 组件处理。如果让表单数据由 DOM 处理时，替代方案是使用非受控组件。

要编写一个非受控组件，而非为每个状态更新编写事件处理程序，可以使用 ref 从 DOM 获取表单值。

```jsx
render() {
  return (
    <form onSubmit={this.handleSubmit}>
      <label>
        Name:
        <input
          defaultValue="Bob"
          type="text"
          ref={(input) => this.input = input} />	// 这时 this.input 就是该 dom 元素
      </label>
      <input type="submit" value="Submit" />
    </form>
  );
}
```

在React中，`<input type="file" />` 始终是一个不受控制的组件，因为它的值只能由用户设置，而不是以编程方式设置。



## shouldComponentUpdate 钩子

shouldComponentUpdate 这个生命周期函数控制了组件是否应该被更新，也就是执不执行 render 函数

这个生命周期函数返回一个布尔值，如果返回 true，则当 props 或 state 改变的时候会重新 render，反之不会

因此，重写 shouldComponentUpdate 函数可以提升性能。因为它是在 render 前触发的。

> 注意：shouldComponentUpdate 默认返回 ture

```js
class CounterButton extends React.Component {
    constructor(props) {
        super(props);
        this.state = {count: 1};
    }
    shouldComponentUpdate(nextProps, nextState) {
        // 根据 props 和 state 的变化决定返回 ture 还是 false
        if (this.props.color !== nextProps.color) {
            return true;
        }
        if (this.state.count !== nextState.count) {
            return true;
        }
        return false;
    }
    render() {
        return (
            <button
                color={this.props.color}
                onClick={() => this.setState(state => ({count: state.count + 1}))}
            >
                Count: {this.state.count}
            </button>
        );
    }
}
```



## React.PureComponent

我们可以在创建组件时选择继承 React.PureComponent

```jsx
class MyComponent extends React.PureComponent {
    // some codes here
}
```

它和继承自普通 Component 的区别是：

+ 继承PureComponent时，不能再重写shouldComponentUpdate，否则会引发警告
+ 继承PureComponent时，进行的是浅比较，也就是说，如果是引用类型的数据，只会比较是不是同一个地址，而不会比较具体这个地址存的数据是否完全一致
+ 比较会忽略属性或状态突变的情况，其实也就是，数据引用指针没变而数据被改变的时候，也不新渲染组件。但其实很大程度上，我们是希望重新渲染的。所以，这就需要开发者自己保证避免数据突变。

> 注：PureComponent 需要依靠 class 创建的组件才可以使用



## React.memo()

React.memo() 和 PureComponent 很相似，它帮助我们控制何时重新渲染组件。

> 组件仅在它的 props 发生改变的时候进行重新渲染。通常来说，在组件树中 React 组件，只要有变化就会走一遍渲染流程。但是通过 PureComponent 和 React.memo()，我们可以仅仅让某些组件进行渲染。

PureComponent 要依靠 class 才能使用。而 React.memo() 可以和 functional component 一起使用。

```jsx
import React from 'react';

const MySnowyComponent = React.memo(function MyComponent(props) {
  // only renders if props have changed!
});

// can also be an es6 arrow function
const OtherSnowy = React.memo(props => {
  return <div>my memoized component</div>;
});

// and even shorter with implicit return
const ImplicitSnowy = React.memo(props => (
  <div>implicit memoized component</div>
));
```

这种方式依然是一种对象的浅比较，有复杂对象时无法`render`。在`React.memo`中可以自定义其比较方法的实现。

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

### 为什么被称为 memo

> 维基百科：在计算机领域，记忆化是一种主要用来提升计算机程序速度的优化技术方案。它将开销较大的函数调用的返回结果存储起来，当同样的输入再次发生时，则返回缓存好的数据，以此提升运算效率。

这就是 React.memo() 所做的事情，所以叫做 `memo` 也很说得通。它会检查接下来的渲染是否与前一次的渲染相同，如果两者是一样的，那么就会保留上一次的渲染结果。



## 错误边界处理

错误边界是**用于捕获其子组件树 JavaScript 异常，记录错误并展示一个回退的 UI** 的 React 组件，而不是整个组件树的异常。错误边界在渲染期间、生命周期方法内、以及整个组件树构造函数内捕获错误。

错误边界无法捕获：

+ 事件处理
+ 异步代码
+ 服务端渲染
+ 错误边界自身抛出来的错误

一个类组件变成一个错误边界。如果它定义了生命周期方法 `static getDerivedStateFromError()`或者`componentDidCatch()`中的任意一个或两个。当一个错误被扔出后，使用`static getDerivedStateFromError()`渲染一个退路UI。使用`componentDidCatch()`去记录错误信息。

```js
class ErrorBoundary extends React.Component {ffmpegffmpeg
class ErrorBoundary extends React.Component {ffmpegffmpeg
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(error) {
    // Update state so the next render will show the fallback UI.
    return { hasError: true };
  }

  componentDidCatch(error, info) {
    // You can also log the error to an error reporting service
    logErrorToMyService(error, info);
  }

  render() {
    if (this.state.hasError) {
      // You can render any custom fallback UI
      return <h1>Something went wrong.</h1>;
    }

    return this.props.children; 
  }
}
```

而后你可以像一个普通的组件一样使用：

```jsx
<ErrorBoundary>
  <MyWidget />
</ErrorBoundary>
```



## 事件委托

react 内部帮助我们完成了事件委托，因此我们可以像下面这样绑定事件

```jsx
{lis.map(li => {
    return <li key={li.id} onClick={this.handleClick}>{li.text}</li>
})}
```



### 错误边界放到哪里

错误边界的粒度是由你决定。你可以将其包装在最顶层的路由组件显示给用户”有东西出错”消息，就像服务端框架经常处理崩溃一样。你也可以将单独的插件包装在错误边界内以保护应用其他部分不崩溃。

## 相关文章

- [2018 年，React 将独占前端框架鳌头？](https://mp.weixin.qq.com/s/gV-w_rRfdBVAqsOpBGZaVw)
- [前端框架三巨头年度走势对比：Vue 增长率最高](https://mp.weixin.qq.com/s/0wXWqKIigaKzMSfy4vJMVw)

- [React数据流和组件间的沟通总结](http://www.cnblogs.com/tim100/p/6050514.html)
- [单向数据流和双向绑定各有什么优缺点？](https://segmentfault.com/q/1010000005876655/a-1020000005876751)
- [怎么更好的理解虚拟DOM?](https://www.zhihu.com/question/29504639?sort=created)
- [React中文文档 - 版本较低](http://www.css88.com/react/index.html)
- [React 源码剖析系列 － 不可思议的 react diff](http://blog.csdn.net/yczz/article/details/49886061)
- [深入浅出React（四）：虚拟DOM Diff算法解析](http://www.infoq.com/cn/articles/react-dom-diff?from=timeline&isappinstalled=0)
- [一看就懂的ReactJs入门教程（精华版）](http://www.cocoachina.com/webapp/20150721/12692.html)
- [CSS Modules 用法教程](http://www.ruanyifeng.com/blog/2016/06/css_modules.html)
- [将MarkDown转换为HTML页面](http://blog.csdn.net/itzhongzi/article/details/66045880)
- [win7命令行 端口占用 查询进程号 杀进程](https://jingyan.baidu.com/article/0320e2c1c9cf0e1b87507b26.html)







