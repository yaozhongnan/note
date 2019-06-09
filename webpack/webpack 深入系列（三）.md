# webpack 深入系列（三）



## Tapable

webpack 本质上是一种事件流的机制，它的工作流程就是将各个插件串联起来，而实现这一切的核心就是 Trapable，Tapable 有点类似于 nodejs 中的 events 库，核心原理也是依赖于发布订阅模式。

tapable 中有一些同步和异步的方法

```js
const {
	Tapable,
	SyncHook,
	SyncBailHook,
	AsyncParallelHook,
	AsyncSeriesHook
} = require("tapable");
```



## Tapable SyncHook

SyncHook 是一个同步的钩子，会将传入的方法依次执行