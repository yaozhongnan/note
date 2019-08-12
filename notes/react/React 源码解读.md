# React 源码分析

## 创建一个组件

在我们引入 React 时，引入的是源码中提供的 React 对象。这个对象大致长这样：

```js
const React = {
    Component,
    PureComponent,
    useState,
    createElement: __DEV__ ? createElementWithValidation : createElement,
    ....
};

export default React;
```

通常我们写一个组件大概是这样的：

```js
import React from 'react';

class A extends React.Component {
    constructor() {},
    handle() {},
    render() {
		return (
        	....
        )
    }
};
```

我们的组件一般都会继承 React.Component，那么这个 React.Component 里具体干了什么呢？我们可以在源码中找到对应的一个叫 ReactBaseClasser.js 的文件，看看里面写了什么：

```js
function Component(props, context, updater) {
    this.props = props;
    this.context = context;
    this.refs = emptyObject;
    this.updater = updater || ReactNoopUpdateQueue;
}

Component.prototype.isReactComponent = {};
Component.prototype.setState = function(partialState, callback) {};
Component.prototype.forceUpdate = function(callback) {};
```

可以很明显的看到，Component 是一个构造函数，定义了自身的属性和方法，其中我们最常用的 setState 方法就定义在了原型上。那么当我们自己的组件 A 继承了 React.Component 后，我们就共享了它身上的属性和方法，所以我们就可以使用其中的 props 属性和 setState 方法。

注意我们在写一个组件时，必须要有 render 方法，且 render 方法必须返回一个类似 DOM 的结构。实际上当我们的组件编写完成后，React 会使用它的 createElement 方法将我们的组件创建为一个 ReactElement 类型的对象，这个 ReactElement 对象打印出来大致是这样的：

```json
{
    // 组件的标识信息
    $$typeof: Symbol(react.element),
    // DOM结构标识，提升update性能
    key: null,
    // 子结构相关信息(有则增加children字段/没有为空)和组件属性(如style)
    props: {},
    // 真实DOM的引用
    ref,
    // 	_owner === ReactCurrentOwner.current(ReactCurrentOwner.js),值为创建当前组件的对象，默认值为null。
    _owner
}
```

这也是我们 console.log(A) 打印一个组件时的样子，这个组件在解析成真实 DOM 之前一直都是 ReactElement 类型的 js 对象。