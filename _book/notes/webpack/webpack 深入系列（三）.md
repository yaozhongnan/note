# webpack 深入系列（三）

webpack 深入讲解了 webpack 依赖的 tapable 模块



## Tapable

webpack 本质上是一种事件流的机制，它的工作流程就是将各个插件串联起来，而实现这一切的核心就是 Trapable，Tapable 有点类似于 nodejs 中的 events 库，核心原理也是依赖于发布订阅模式。

tapable 中有一些同步和异步的钩子，这些钩子都可以用来绑定函数，执行函数

异步钩子呢又分为串行和并行，串行需要等待前面一个任务执行完。并行是一起执行，等到所有任务执行完成后执行回调函数。

```js
const {
	Tapable,
	SyncHook,
	SyncBailHook,
	SyncWaterfallHook,
	SyncLoopHook,
	AsyncParallelHook,
	AsyncSeriesHook
} = require("tapable");
```

假如我们要实现一个功能，这个功能又把它拆分开，分成一个个函数，那按照我们的需求，执行这些函数，可能我们需要它们同步执行，也可能异步执行。tapable 就为我们实现了这样的能力。



## SyncHook

SyncHook 是一个同步的钩子，会将注册的方法依次执行

需求场景：先学习 node，再学习 react

模拟实现

```js
class SyncHook {
  // args => ['a', 'b']
  constructor(args) {
    // 保存注册的所有函数
    this.tasks = [];
  }

  // name 作为标识用
  // task 就是注册的函数
  tap(name, task) {
    this.tasks.push(task);
  }

  call(...args) {
    this.tasks.forEach(task => {
      task(...args);
    });
  }
}
```

使用

```js
// 创建实例
const hook = new SyncHook();

// 注册了两个函数
hook.tap('node', (name) => {
    console.log('学习 node', name);
})
hook.tap('react', (name) => {
    console.log('学习 react', name);
})

// 同步执行注册的所有函数
hook.call('yzn');
```

输出

```js
学习 node yzn
学习 react yzn
```



## SyncBailHook

同步保险钩子可以让我们在一个同步任务中指定是否继续向下执行。那么如何指定是否继续向下执行呢，就看同步方法中的返回值是不是 undefined，如果不是则不向下继续执行，反之向下继续执行。

需求场景：先学习 node，但是 node 比较难，卡在了 node，无法向下学习 react 了

模拟实现

```js
class SyncBailHook {
  constructor(args) {
    this.tasks = [];
  }

  tap(name, task) {
    this.tasks.push(task);
  }

  call(...args) {
    // 维护一个索引
    let index = 0;
    // 维护函数的返回值
    let ret;

    // 由于至少也会执行第一个函数，因此使用 do while
    do {
      // 取出 index 对应的任务，执行并拿到返回值
      ret = this.tasks[index++](...args);
    }
    // while 中判断是否执行到头且执行的函数返回值是不是 undefined
    while (index < this.tasks.length && ret === undefined);
  }
}
```

使用

```js
const hook = new SyncBailHook();

hook.tap('node', (name) => {
  console.log('学习 node', name);
  // 这里返回了一个非 undefined 值，因此后面的方法并不会执行了
  return '太难了，卡住了'
})
hook.tap('react', (name) => {
  console.log('学习 react', name);
})

hook.call('yzn');
```

输出

```js
学习 node yzn
```



## SyncWaterfallHook

同步瀑布钩子指的是注册的同步函数之间存在关系，比如第二个方法的参数依赖第一个方法的返回值，第三个方法的参数依赖第二个方法的返回值。

需求场景：先学习 node，做了 node 笔记，在学习 react，依然可以查阅 node 笔记

模拟实现

```js
class SyncWaterfallHook {
  constructor(args) {
    this.tasks = [];
  }

  tap(name, task) {
    this.tasks.push(task);
  }

  call(...args) {
    // 解构拿到第一个函数和其它函数
    const [first, ...other] = this.tasks;
    // 执行第一个函数，并拿到返回值
    const ret = first(...args);

    // 利用数组的 reduce 方法，初始值设为 ret
    other.reduce((prev, next) => {
      // 这里的 prev 初始是 ret，之后就是每一次 next 调用的返回值了
      return next(prev);
    }, ret);
  }
}
```

使用

```js
const hook = new SyncWaterfallHook();

hook.tap('node', (name) => {
  console.log('学习 node', name);
  return 'node 笔记'
})
hook.tap('react', (data) => {
  console.log('学习 react', data);
})

hook.call('yzn');
```

输出

```js
学习 node yzn
学习 react node 笔记
```



## SyncLoopHook

同步循环钩子指的是某个同步任务可以循环执行 n 次，那么如何添加这个规则呢？就是在同步函数中添加返回值，如果返回值不是 undefined，那么这个同步函数将被循环执行。

需求场景：先学习 node，由于 node 太难因此需要学习 3 次，学完 3 次后再学习 react

模拟实现

```js
class SyncLoopHook {
  constructor(args) {
    this.tasks = [];
  }

  tap(name, task) {
    this.tasks.push(task);
  }

  call(...args) {
    // forEach 执行每一个任务
    this.tasks.forEach(task => {
      // 内部维护一个 ret 保存函数的返回值
      let ret;
      // 通过 do while 循环执行任务
      do {
        ret = task(...args);
      } while (ret !== undefined);
    });
  }
}
```

使用

```js
// 维护一个 index，记录执行次数
let index = 0;

const hook = new SyncLoopHook();

hook.tap('node', (name) => {
  console.log('学习 node', name);
  // 根据 index 的值决定是否返回 undefined
  return ++index === 3 ? undefined : '继续学习 node';
})
hook.tap('react', (name) => {
  console.log('学习 react', name);
})

hook.call('yzn');
```

输出

```js
学习 node yzn
学习 node yzn
学习 node yzn
学习 react yzn
```



##AsyncParallelHook

异步并行钩子，特点是注册的异步函数一起执行，当所有异步函数执行完成后会执行一个回调

需求场景：一边学习 node，一边学习 react

模拟实现

```js
class AsyncParallelHook {
  constructor(args) {
    this.tasks = [];
  }

  tapAsync(name, task) {
    this.tasks.push(task);
  }

  callAsync(...args) {
    // 维护一个 index，用来计算异步函数的个数
    let index = 0;
    // 拿到最终的 callback 回调函数
    const finalCallBack = args.pop();
    // 每个异步函数执行完成的回调
    // 该 done 的实现类似于 Promise.all 的实现
    const done = () => {
      // 内部自增 Inedx
      index++;
      // 并判断 index 与异步函数的个数是否相同，相同则证明执行完成
      if (index === this.tasks.length) {
        // 执行完成则执行最终的回调函数
        finalCallBack();
      }
    }
    this.tasks.forEach(task => {
      task(...args, done);
    })
  }
}
```

使用

```js
const hook = new AsyncParallelHook();

// 注册异步函数，使用 setTimeout 模拟
hook.tapAsync('node', (name, cb) => {
  setTimeout(() => {
    console.log('学习 node', name);
    // 异步执行完成后需要手动执行 cb 函数，这个 cb 就是 done 函数
    cb();
  }, 1000);
})
hook.tapAsync('react', (name, cb) => {
  setTimeout(() => {
    console.log('学习 react', name);
    cb();
  }, 1000);
})

// call 所有异步函数，并传入一个回调
// 这个回调就是所有异步函数执行完成后需要执行的回调
hook.callAsync('yzn', () => {
  console.log('学习完成');
});
```

输出

```js
学习 node yzn		// 一秒后打印
学习 react yzn	// 两秒后打印
学习完成		  // 异步函数都执行完成后打印		
```

**上面的方式注册的异步函数是一个普通函数，AsyncParallelHook 还可以注册 Promise 函数**

模拟实现

```js
class AsyncParallelHook {
  constructor(args) {
    this.tasks = [];
  }

  tapPromise(name, task) {
    this.tasks.push(task);
  }

  promise(...args) {
    // 这里使用 map 获取 promise 数组
    let tasks = this.tasks.map(task => task(...args));
    // 使用 Promise.all 执行 promise 数组，返回最终结果的 Promise
    return Promise.all(tasks);
  }
}
```

使用

```js
const hook = new AsyncParallelHook();

// 注册异步函数，使用 Promise
hook.tapPromise('node', (name) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('学习 node', name);
      // 执行完成后 resolve
      resolve();
    }, 1000);
  })
})
hook.tapPromise('react', (name) => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log('学习 react', name);
      resolve();
    }, 2000);
  })
})

// 使用 then 替代回调函数
hook.promise('yzn', ).then(() => {
  console.log('学习完成');
});
```

输出

```js
学习 node yzn		// 一秒后打印
学习 react yzn	// 两秒后打印
学习完成		  // 异步函数都执行完成后打印		
```



## AsyncSeriesHook

异步串行钩子，特点是注册的异步函数一个一个执行

需求场景：先学习 node，再学习 react（异步）

模拟实现

```js
class AsyncSeriesHook {
  constructor(args) {
    this.tasks = [];
  }
 
  tapAsync(name, task) {
    this.tasks.push(task);
  }

  callAsync(...args) {
    // 取出最终的回调函数，在参数最后一位
    const finalCallBack = args.pop();
    // 维护一个索引
    let index = 0;

    // 定义一个 next 方法
    const next = () => {
      // 判断递归的终点
      if (this.tasks.length === index) {
        // 调用最终回调函数
        return finalCallBack();
      }
      // 执行每一次的任务，next 作为 callback
      this.tasks[index++](...args, next);
    };
    next();
  }
}



```

使用

```js
const hook = new AsyncSeriesHook();

hook.tapAsync("node", (name, cb) => {
  // setTimeout 模拟异步
  setTimeout(() => {
    console.log("学习 node", name);
    // 任务完成后手动调用 cb，这里的 cb 就是 next 函数
    cb();
  }, 1000);
});
hook.tapAsync("react", (name, cb) => {
  setTimeout(() => {
    console.log("学习 react", name);
    cb();
  }, 2000);
});

hook.callAsync("yzn", () => {
  console.log("学习完成");
});
```

输出

```js
学习 node yzn		// 一秒后打印
学习 react yzn	// 两秒后打印
学习完成		  // 异步函数都执行完成后打印	
```

使用 Promise 模拟实现

```js
class AsyncSeriesHook {
  constructor(args) {
    this.tasks = [];
  }

  tapPromise(name, task) {
    this.tasks.push(task);
  }

  promise(...args) {
    const [first, ...others] = this.tasks;
    return others.reduce((promise, next) => {
      return promise.then(() => next(...args));
    }, first(...args));
  }
}
```

使用

```js
const hook = new AsyncSeriesHook();

hook.tapPromise("node", name => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("学习 node", name);
      resolve();
    }, 1000);
  });
});
hook.tapPromise("react", name => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      console.log("学习 react", name);
      resolve();
    }, 1000);
  });
});

hook.promise("yzn").then(() => {
  console.log("学习完成");
});
```





