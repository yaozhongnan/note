# JavaScript 深入

## 为何会发生变量提升，函数提升

js 引擎在执行 Js 代码时并非一行一行执行，而是一段一段执行，当执行一段代码时，会创建当前代码段环境的执行上下文，然后做一些准备工作。

先来说下什么叫一段一段的代码，其实就是可执行代码（executable code），全局代码，函数代码和 eval 代码。

那么这个准备工作又是什么意思呢？

实际上 js 引擎在分析代码的时候，分为两个阶段：编译阶段和执行阶段，这里的编译阶段与 c 中将高级语言转换为机器语言不同，这里的编译就可以理解为准备工作。

编译阶段：只会处理声明语句，会将所有声明的变量添加为当前执行上下文变量对象（VO）的属性。如果是变量声明，其值暂时初始化为 undefined，如果是函数声明，它会在堆上开辟内存，并将函数定义放在堆上，函数变量只保存指向函数定义的地址。

执行阶段：编译结束后，js 引擎会再次扫描代码，这个阶段主要的任务的根据执行的语句，更新变量对象等。

之所以会发生变量提升，函数提升，就是 js 引擎在编译阶段只处理声明语句的缘故。

注意：进入执行上下文时，首先会处理函数声明，其次会处理变量声明，如果变量名称跟已经声明的形式参数或函数相同，则变量声明不会干扰已经存在的这类属性。

让我们用一个例子来看看 js 的执行顺序，有以下代码：
```js
function foo() {
  console.log(a);
}

var a = 10;

foo();
```
执行步骤，伪代码：
```js
// 进入全局代码段，创建全局执行上下文对象。js 引擎进入编译阶段
globalContext = {}
// 处理全局环境中的声明语句，函数声明和变量声明.添加到全局执行上下文对象 VO 中
globalContext = {
  VO: {
    foo: 0x0000,    // 保存函数定义的地址
    a: undefined    // 变量声明初始值一律为 undefined
  }
}
// 语句声明处理完成，进入执行阶段
// 发现执行语句 var a = 10
globalContext = {
  VO: {
    foo: 0x0000,
    a: 10
  }
}
// 发现执行语句 foo()，执行函数，函数中打印变量 a，由于函数内部找不到变量 a，因此去全局执行上下文里找，找到 a，打印 10
```

在用一个例子看看变量提升和函数提升：
```js
console.log(foo);
var foo = 1;
console.log(foo);
function foo() {
  console.log('foo');
}

/*
  分析：
    进入编译阶段：首先进行函数提升，在进行变量提升，由于变量提升时发现重名，但变量声明并不会干扰已经提升的函数声明，因此此时的 foo 仍是函数
    执行阶段：执行第一个 console，由于这时 foo 是函数，因此打印函数
    执行第二行语句，将 foo 变量赋值给 1，相当于把原先的 foo 函数改写为了 1
    执行第二个 console，由于 foo 函数以及被改写为 1，因此打印 1
*/
```
例子：
```js
foo();
if (true) {
  function foo() {
    console.log('1111');
  }
} else {
  function foo() {
    console.log('22222');
  }
}

/*
  分析：
    如果照常分析的话 foo 函数调用应该会打印 22222，然而实际上却是报错
    这是因为这里的函数声明都放在的代码块中，js 引擎不将代码块中的函数声明进行提升，而是处理成了函数表达式，函数表达式自然是不会提升的
*/
```
**经典面试题：**

```js
var c = 1;
function c() {
    console.log(c);
}
c();

/*
  分析：
    首先进行变量提升与函数提升，由于重名，因此存下来的为函数 c
    然后开始执行代码，执行第一行，将 c 赋值为 1，这意味着 c 从函数变成了 1
    继续执行到第四行，c 调用，由于此时的 c 已经变成了 1，因此报错 c is not a function
*/
```

## 执行上下文栈

我们知道，每执行一个函数的时候，就会创建函数的一个执行上下文，那我们写的那么多函数，创建的那么多执行上下文如何管理呢？

所以 js 引擎创建了执行上下文栈（execution context stack, ECS）来管理执行上下文。

执行上下文栈的特点在此不在赘述

## 执行上下文

当 js 遇到一段可执行代码时，会创建对应的执行上下文，对于每个执行上下文，都有三个重要属性

变量对象（varialbe object, VO）、作用域链（scope chain）、this

## 变量对象

变量对象是与执行上下文相关的数据作用域，存储了在上下文中定义的变量和函数声明

**全局执行上下文**

很明显，全局执行上下文的变量对象就是全局对象，而全局对象就是 window 对象

**函数执行上下文**

在函数执行上下文中，我们用活动对象（activation object AO）来表示变量对象。

活动对象和变量对象其实是一个东西，只是变量对象是规范上的或者说是引擎实现上的，不可在 JavaScript 环境中访问，只有到当进入一个执行上下文中，这个执行上下文的变量对象才会被激活，所以才叫 activation object 呐，而只有被激活的变量对象，也就是活动对象上的各种属性才能被访问。

活动对象是在进入函数上下文时刻被创建的，它通过函数的 arguments 属性初始化。arguments 属性值是 Arguments 对象。

未进入执行阶段之前，变量对象(VO)中的属性都不能访问！但是进入执行阶段之后，变量对象(VO)转变为了活动对象(AO)，里面的属性都能被访问了，然后开始进行执行阶段的操作。

它们其实都是同一个对象，只是处于执行上下文的不同生命周期。

函数执行上下文的代码会分为两个阶段进行：分析和执行阶段，也可以叫进入执行上下文和代码执行阶段

进入执行上下文阶段与 js 引擎的编译阶段相似，不仅处理了函数和变量声明，还有函数的所有形参

举个例子，有以下代码：
```js
function foo(a) {
  var b = 2;
  function c() {}
  var d = function() {};

  b = 3;
}

foo(1);
```
在进入执行上下文后，这时候的 AO 是：
```js
AO = {
    arguments: {
        0: 1,
        length: 1
    },
    a: 1,
    b: undefined,
    c: reference to function c(){},
    d: undefined
}
```
当进入代码执行阶段时，AO 为：
```js
AO = {
    arguments: {
        0: 1,
        length: 1
    },
    a: 1,
    b: 3,
    c: reference to function c(){},
    d: reference to FunctionExpression "d"
}
```

## 作用域链

函数的作用域在函数定义的时候就决定了。这是因为函数有一个内部属性 [[scope]]，当函数创建的时候，就会保存所有父变量对象到其中。

在源代码中当你定义（书写）一个函数的时候（并未调用），js引擎也能根据你函数书写的位置，函数嵌套的位置，给你生成一个[[scope]]，作为该函数的属性存在（这个属性属于函数的）。即使函数不调用，所以说基于词法作用域（静态作用域）。

然后进入函数执行阶段，生成执行上下文，执行上下文你可以宏观的看成一个对象，（包含vo,scope,this），此时，执行上下文里的scope和之前属于函数的那个[[scope]]不是同一个，执行上下文里的scope，是在之前函数的[[scope]]的基础上，又新增一个当前的AO对象构成的。

函数定义时候的[[scope]]和函数执行时候的scope，前者作为函数的属性，后者作为函数执行上下文的属性。

## call 方法的模拟实现

call 方法的模拟实现之前，我们需要认识以下原生的 call 方法到底具有哪些特点，只有清楚这些特点，才能更完整的模拟实现。

call 方法在使用一个指定的 this 值和若干个指定的参数值的前提下调用某个函数或方法。

call 的第一个参数，指定了函数内部的 this 指向，可以为 Null，为 null 时视为 window，后续的参数与函数接收的参数一一对应

函数可以有返回值的

call 方法还可以理解为借用函数，借用了这个函数给指定的 this 对象使用，用完就完事儿了。

基于以上特点，ES5 模拟实现如下：
```js
Function.prototype.call2 = function(context) {
  // 传了 context 则为 context，传 null 视为 window
  context = context || window;
  // 获取传递的参数，需要剔除第一个参数 this，以数组形式保存
  var args = Array.prototype.slice.call(arguments, 1);
  // 借用函数，绑定函数为自身的一个属性，这里的 this 就是那个函数
  context.__fn__ = this;  // 这里有一个小问题，就是 context 可能本来就存在 __fn__ 属性
  // 调用函数，并将参数传入，使用 eval 调用，要考虑有返回值
  var result = eval('context.__fn__('+ args +')');
  // 借用完成，删除该属性
  delete context.__fn__;
  return result;
}
```
ES6 模拟实现如下：
```js
Function.prototype.call2 = function(context, ...args) {
  context = context || window;
  const fn = Symbol();
  context[fn] = this;
  context[fn](...args)
  delete context[fn];
  return result;
}
```

## bind 方法的模拟实现

首先要清楚 bind 有哪些特点，bind 和 call 方法的区别就是 bind 返回一个函数并不调用，call 会调用

然后 bind 返回的方法还可以使用 new 创建实例对象

bind 传递的参数可以只传一部分，另一部分参数可以在调用函数的时候接着传递

```js
Function.prototype.bind2 = function (context) {
  // 检查 bind 绑定的是不是函数，不是函数的话报错
  if (typeof this !== "function") {
    throw new Error("Function.prototype.bind - what is trying to be bound is not callable");
  }

  // 拿到绑定函数
  var self = this;
  // 获取绑定时传递的参数，需要截掉第一个参数
  var args = Array.prototype.slice.call(arguments, 1);

  // 创建一个空函数
  var fNOP = function () {};

  // fBound 就是最终要返回的函数
  var fBound = function () {
    // 获取绑定函数调用时传递的参数
    var bindArgs = Array.prototype.slice.call(arguments);
    // fBound 内部执行绑定函数，并根据 this 是否为 fBound 的实例来决定 this 的值，同时传入合并后的参数
    return self.apply(this instanceof fBound ? this : context, args.concat(bindArgs));
  }

  // 让空函数 fNOP 的原型指向绑定函数的原型
  // 之所以没有让 fBound.prototype 直接等于 this.prototype 是因为当 fBound.prototype 改变时 this.prototype 也会改变，因此利用空函数中转
  fNOP.prototype = this.prototype;
  // 让返回的函数原型为 fNOP 的实例原型
  fBound.prototype = new fNOP();
  return fBound;
}
```

## new 的模拟实现

new 运算符创建一个用户定义的对象类型的实例或具有构造函数的内置对象类型之一

new 返回一个对象，并且该对象的隐式原型属性指向构造函数的 prototype

注意：构造函数中可能会存在返回值，返回对象与返回基本类型的值完全不一样

```js
function mockNew() {
  var obj = new Object();

  var Constructor = [].shift.call(arguments);

  obj.__proto__ = Constructor.prototype;

  var ret = Constructor.apply(obj, arguments);

  return typeof ret === 'object' ? ret : obj;
}
```

## 创建对象的多种方式

最常见的有工厂模式、构造函数模式、原型模式、组合模式（构造函数与原型模式结合），还有动态原型模式、寄生构造函数模式、稳妥构造函数模式

这里要讲的是寄生构造函数模式，代码如下：

```js
function Person(name) {
  var o = new Object();
  o.name = name;
  o.getName = function () {
      console.log(this.name);
  };
  return o;

}
```
看到函数名 Person，构造函数，再看函数内部，工厂模式啊。所以寄生构造函数模式就是打着构造函数的名义干着工厂模式的事儿，典型的挂羊头卖狗肉

## 继承的多种方式

**原型链继承**

直接让子类的 prototype 等于父类的实例对象，这样就共享了父类的属性和方法

但是缺点是如果父类中的属性值是引用类型，则被所有实例所共享，且子类无法传参给父类
```js
Child.prototype = new Parent()
```


**借用构造函数（经典继承）**

子类构造函数里调用父类构造函数，借用一下，解决了原型链继承中属性值是引用类型的问题

这样可以向父类传参，但好像无法共享父类原型的方法，而是讲方法定义在了构造函数中
```js
function Child () {
    Parent.call(this);
}
```

**组合继承**

原型链继承和经典继承结合。

缺点：调用了两次父类的构造函数

```js
function Child () {
  Parent.call(this);  // 1 次
}

Child.prototype = new Parent()    // 2 次
Child.prototype.constructor = Child;
```

**寄生组合式继承**

解决了组合继承中父类构造函数调用两次的问题

```js
function Parent (name) {
    this.name = name;
    this.colors = ['red', 'blue', 'green'];
}

Parent.prototype.getName = function () {
    console.log(this.name)
}

function Child (name, age) {
    Parent.call(this, name);
    this.age = age;
}

// 关键的三步
var F = function () {};

F.prototype = Parent.prototype;

Child.prototype = new F();


var child1 = new Child('kevin', '18');

console.log(child1);
```

## 惰性函数

DOM 事件添加中，为了兼容现代浏览器和 IE 浏览器，我们需要对浏览器环境进行一次判断：

不使用惰性函数，每次调用 addEvent 事件均会进行判断
```js
function addEvent (type, el, fn) {
  if (window.addEventListener) {
      el.addEventListener(type, fn, false);
  }
  else if(window.attachEvent){
      el.attachEvent('on' + type, fn);
  }
}
```

使用惰性函数，只有初次调用会进行判断，之后再次调用由于方法被重写，不会再判断
```js
function addEvent (type, el, fn) {
  if (window.addEventListener) {
    el.addEventListener(type, fn, false);
    addEvent = function (type, el, fn) {
        el.addEventListener(type, fn, false);
    }
  }
  else if(window.attachEvent){
    el.attachEvent('on' + type, fn);
    addEvent = function (type, el, fn) {
        el.attachEvent('on' + type, fn);
    }
  }
}
```

## 方法内部只执行一次

有时候我们会遇到这样的场景，就是函数内部的代码只在初次调用的时候执行，往后在调用都不执行

以下所有示例，console.log(2) 就是我们想要执行的代码，只在初次执行时运行

以前的常用方法：
```js
// 声明一个全局变量作为标志
var flag = true;
function foo() {
  if (flag) {
    console.log(2);
  }
  flag = false;
}

foo()
foo()
```

也可以用闭包来解决，以免污染全局
```js
var foo = (function() {
  var flag = true;
  return function() {
    if (flag) {
      console.log(2);
    }
    flag = false;
  }
})();

foo()
foo()
```

还可以利用函数也是对象的特性：
```js
function foo() {
  if (!foo.flag) {
    console.log(2);
  } else {
    foo.flag = true;
  }
}
```

利用惰性函数
```js
var foo = function() {
  console.log(2);
  foo = function() {
    return;
  };
  return foo();
};
```