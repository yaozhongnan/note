# JavaScript

## 数据类型的转换

### 强制转换

强制转换主要指使用`Number()`、`String()`和`Boolean()`三个函数，手动将各种类型的值，分别转换成数字、字符串或者布尔值。

#### Number()

> `Number`背后的转换规则比较复杂。

+ 第一步，调用对象自身的`valueOf`方法。如果返回原始类型的值，则直接对该值使用`Number`函数，不再进行后续步骤。

+ 第二步，如果`valueOf`方法返回的还是对象，则改为调用对象自身的`toString`方法。如果`toString`方法返回原始类型的值，则对该值使用`Number`函数，不再进行后续步骤。

+ 第三步，如果`toString`方法返回的是对象，就报错。

#### String()

> `String`方法背后的转换规则，与`Number`方法基本相同，只是互换了`valueOf`方法和`toString`方法的执行顺序。

+ 先调用对象自身的`toString`方法。如果返回原始类型的值，则对该值使用`String`函数，不再进行以下步骤。
+ 如果`toString`方法返回的是对象，再调用原对象的`valueOf`方法。如果`valueOf`方法返回原始类型的值，则对该值使用`String`函数，不再进行以下步骤。

+ 如果`valueOf`方法返回的是对象，就报错。

#### Boolean()

> `Boolean`函数可以将任意类型的值转为布尔值。

它的转换规则相对简单：除了以下五个值的转换结果为`false`，其他的值全部为`true`。

- `undefined`
- `null`
- `-0`或`+0`
- `NaN`
- `''`（空字符串）

### 自动转换

遇到以下三种情况时，JavaScript 会自动转换数据类型，即转换是自动完成的，用户不可见。

第一种情况，不同类型的数据互相运算。

```js
123 + 'abc' // "123abc"
```

第二种情况，对非布尔值类型的数据求布尔值。

```js
if ('abc') {
  console.log('hello')
}  // "hello"
```

第三种情况，对非数值类型的值使用一元运算符（即`+`和`-`）。

```js
+ {foo: 'bar'} // NaN
- [1, 2, 3] // NaN
```

自动转换的规则是这样的：预期什么类型的值，就调用该类型的转换函数。比如，某个位置预期为字符串，就调用`String`函数进行转换。如果该位置即可以是字符串，也可能是数值，那么默认转为数值。

由于自动转换具有不确定性，而且不易除错，建议在预期为布尔值、数值、字符串的地方，全部使用`Boolean`、`Number`和`String`函数进行显式转换。

## 错误处理机制

JavaScript 原生提供`Error`构造函数，所有抛出的错误都是这个构造函数的实例。

```js
var err = new Error('出错了');
err.message // "出错了"
```

`Error`实例对象是最一般的错误类型，在它的基础上，JavaScript 还定义了其他6种错误对象。也就是说，存在`Error`的6个派生对象。

+ `SyntaxError`对象是解析代码时发生的语法错误。
+ `ReferenceError`对象是引用一个不存在的变量时发生的错误。
+ `RangeError`对象是一个值超出有效范围时发生的错误。主要有几种情况，一是数组长度为负数，二是`Number`对象的方法参数超出范围，以及函数堆栈超过最大值。
+ `TypeError`对象是变量或参数不是预期类型时发生的错误。比如，对字符串、布尔值、数值等原始类型的值使用`new`命令，就会抛出这种错误，因为`new`命令的参数应该是一个构造函数。
+ `URIError`对象是 URI 相关函数的参数不正确时抛出的错误，主要涉及`encodeURI()`、`decodeURI()`、`encodeURIComponent()`、`decodeURIComponent()`、`escape()`和`unescape()`这六个函数。
+ `eval`函数没有被正确执行时，会抛出`EvalError`错误。该错误类型已经不再使用了，只是为了保证与以前代码兼容，才继续保留。

## Array 对象



## ES6 知识点

- Symbol 作为对象的属性只能通过 obj[symbol] 的形式添加，不能通过点的方式添加
- 原生具备 Iterator 接口的数据结构有：Array、Map、Set、String、TypedArray、Arguments、NodeList
- Set 数据结构：类似与数组，但它的成员都是唯一的
- Map 数据结构：类似与对象，但它的 key 都是唯一的，且 key 不仅仅是字符串，任何类型的值都可以当 key
- 箭头函数没有 prototype 属性，没有 constructor，没有绑定 this

## DOM

### 一些节点的属性

+ 每个节点都有 一个 childNodes 属性，其中保存着一个 NodeList 对象，NodeList 是一种类数组对象，用于保存一组有序的节点。具有 length 属性但不是 Array 的实例。NodeList 具有一个特点，它是基于 DOM 结构动态执行查询的结果，因此 DOM 结构的变化能够自动反映在 NodeList 对象中。
+ children 属性是 HTMLCollection 的实例，它只包含元素中同样还是元素的子节点
+ firstChild、firstElementChild
+ lastChild、lastElementChild
+ parentNode
+ nextSibling、nextElementSibling
+ previonsSibling、previonsElementSibling

### 节点操作

+ appendChild()，用于向 childNodes 列表的末尾添加一个节点，添加完成后返回该新增的节点
+ insertBefore(要插入的节点, 作为参照的节点)，插入到参照节点之前
+ replaceChild(要插入的节点，要替换的节点)，替换节点将会被移除
+ removeChild(要移除的节点)，移除节点
+ cloneNode(boolean)，传入 true 表示深克隆，false 浅克隆
+ normalize()

## 进阶

### apply()、call() 和 bind()

每个函数都有两个非继承而来的方法，apply() 和 call()，这两个方法的作用都是**在特定的作用域中调用函数**。

实际上等同于设置函数体内 this 对象的值。

```js
window.color = "red";
var o = { color: "blue" };

function sayColor(){
 alert(this.color);
}

sayColor(); //red
sayColor.call(this); //red
sayColor.call(window); //red
sayColor.call(o); //blue 
```

apply() 方法接收两个参数，第一个是在其中运行函数的作用域，第二个参数是数组。

call() 方法接收 n 个参数， 第一个是在其中运行函数的作用域，其余参数依次传入。

bind() 这个方法会创建一个函数的实例，其 this 值会被绑定到传给 bind() 函数的值。 

### 创建对象的几种方式

常见的创建对象的几种方式：

+ 字面量的形式。例如： var obj = {}
+ 调用系统的构造函数。例如：var obj = new Object()
+ 自定义构造函数的方式。例：

```javascript
function Person(name, age) {
    this.name = name;
    this.age = age;
    this.sayHi = function () {
        alert('hello')
    }
}

vat per = new Person('yzn', 22)

// 缺点：每个方法都要在每个实例上重新创建一遍
```

+ 工厂模式创建对象：例：

```javascript
function createObj(name, age) {
    var obj = new Object()
    obj.name = name;
    obj.age = age;
    obj.sayHi = function () {
        alert('hello')
    }
    return obj
}

var per = createObj('yzn', 22)

// 缺点：没有解决对象识别的问题（即怎么知道一个对象的类型）
```

+ 原型模式
  + 每个函数都有一个 prototype 属性，这个属性是一个指针，指向一个对象，就是原型对象。原型对象的用途是包含可以由特定类型的所有实例共享的属性和方法。

```javascript
function Person() {}

Person.prototype.name = 'yzn'
Person.prototype.age = 22
Person.prototype.sayHi = function () {
    alert('hello')
}

// 缺点：不适合存储属性，特别是引用类型的属性
```

+ 组合使用原型模式和构造函数模式
+ 动态原型模式
+ 寄生构造函数模式
+ 稳妥构造函数模式

### 原型

原型：每当我们创建一个新函数，这个函数就会创建一个 prototype 属性，这个属性是一个指针，指向一个对象，就是函数的原型对象。

每一个原型对象都会有一个 constructor （构造函数）属性，该属性是一个指向 prototype 属性所在函数的指针

```js
function Person() {}

Person.prototype.constructor === Person  // true
```

当我们创建一个构造函数的实例对象的时候

```js
var p1 = new Person()
```

该实例的内部将包含一个指针（内部属性），指向构造函数的原型对象。ES5 中管这个指针叫 [[Prototype]]，标准没有访问 [[Prototype]] 的方式，但各大浏览器在每一个实例对象上都支持一个属性  ____proto____ 

```js
p1.__proto__ === Person.prototype	// true
```

如果我们在一个实例中添加一个属性，而该属性与实例原型上的一个属性同名。那么该属性将会屏蔽原型上的那个属性。例：

```js
function Person() {}

var p1 = new Person()
p1.name = 'yzn'
Person.prototype.name = 'lll'

console.log(p1.name)	// yzn

delete p1.name	// 可以使用 delete 操作符删除对象身上的属性
console.log(p1.name)	// lll
```

###hasOwnProperty()

使用 hasOwnProperty() 可以检测一个一个属性存在与实例中还是原型中。当这个属性存在与实例中时返回 true

```js
function Person() {}

var p1 = new Person()

p1.name = 'yzn'
Person.prototype.age = 23

console.log(p1.hasOwnProperty('name'))	// true
console.log(p1.hasOwnProperty('age'))	// false
```

#### in 

使用 in 操作符也可以检测一个属性是否存在与一个对象中，但它不能检测出该属性在实例中还是原型中，因为但凡两者中有一个存在该属性，那么它就返回 true。例：

```js
function Person() {}

var p1 = new Person()

p1.name = 'yzn'

Person.prototype.age = 23

console.log('name' in p1)	// true
console.log('age' in p1)	// true
```

可以结合 in 操作符和 hasOwnProperty() 方法判断一个属性到底是存在与对象中，还是原型中。

#### for in

使用 for in 循环时，返回的是所有能够通过对象访问的、可枚举的（enumerated）属性。其中既包括存在与实例中的属性也包括存在与原型中的属性。

#### Object.keys()

使用 Object.keys() ，传入一个对象，返回一个包含该对象所有可枚举属性的字符串数组。

#### Object.getOwnPropertyNames()

Object.getOwnPropertyNames()，传入一个对象，返回所有属性，无论是否可枚举。

### 继承

#### 原型链实现继承

ES5 将原型链作为实现继承的主要方法。基本思想是利用原型让一个引用类型继承另一个引用类型的属性和方法。

```js
function SuperType() {
    this.property = true;
}
SuperType.prototype.getSuperValue = function () {
    return this.property;
};

function SubType() {
    this.subproperty = false;
}
//继承了 SuperType，并且该写法相当于重写了 SubType 的原型对象，所以需要写在前面
// 让 SubType 的原型对象等于 new SuperType()，相当于等于了 SuperType 的实例对象，因此 SubType 的原型对象中就包含了 SuperType 的实例属性和方法。即 property 属性和 __proto__ 属性
SubType.prototype = new SuperType();

// 为 SubType 的原型对象上额外增加一个 getSubValue 属性，该属性值是一个方法
SubType.prototype.getSubValue = function () {
    return this.subproperty;
};
var instance = new SubType();

console.log(instance);
console.log(instance.getSuperValue()); //true
```

##### 确定原型和实例的关系

方式一： instanceof 操作符

```js
console.log(instance instanceof Object)			// true
console.log(instance instanceof SuperType)		// true
console.log(instance instanceof SubType)		// true
```

方式二：isPrototypeOf() 方法

```js
console.log(Object.prototype.isPrototypeOf(instance))			// true
console.log(SuperType.prototype.isPrototypeOf(instance))		// true
console.log(SubType.prototype.isPrototypeOf(instance))			// true
```

##### 谨慎的定义方法

子类型有时候需要重写超类型中的某个方法，或者需要添加超类型中不存在的某个方法。但不管怎 样，给原型添加方法的代码一定要放在替换原型的语句之后。 

##### 原型链的问题

问题一：包含引用类型值的原型。

问题二：不能向超类型的构造函数中传递参数。

#### 借用构造函数实现继承（经典继承）

```js
function SuperType(){
 this.colors = ["red", "blue", "green"];
}
function SubType(){
 //继承了 SuperType
 SuperType.call(this);
}
var instance1 = new SubType();
instance1.colors.push("black");
alert(instance1.colors); //"red,blue,green,black"
var instance2 = new SubType();
alert(instance2.colors); //"red,blue,green" 
```

通过使用 call()方法（或 apply()方法 也可以）“借调”了超类型中的构造函数。我们实际上是在（未来将要）新创建的 SubType 实例的环境下调用了 SuperType 构造函数。 这样一来，就会在新 SubType 对象上执行 SuperType()函数中定义的所有对象初始化代码。结果， SubType 的每个实例就都会具有自己的 colors 属性的副本了。 

**优点**

可以向超类型中的构造函数传递参数

```js
function SuperType(name){
 this.name = name;
}
function SubType(){
 //继承了 SuperType，同时还传递了参数
 SuperType.call(this, "Nicholas");

 //实例属性
 this.age = 29;
} 
```

**缺点**

如果仅仅是借用构造函数，那么也将无法避免构造函数模式存在的问题——方法都在构造函数中定 义，因此函数复用就无从谈起了。而且，在超类型的原型中定义的方法，对子类型而言也是不可见的，结 果所有类型都只能使用构造函数模式。考虑到这些问题，借用构造函数的技术也是很少单独使用的。 

#### 组合继承（伪经典继承）

组合继承（combination inheritance），有时候也叫做伪经典继承，指的是将原型链和借用构造函数的 技术组合到一块，从而发挥二者之长的一种继承模式。其背后的思路是使用原型链实现对原型属性和方 法的继承，而通过借用构造函数来实现对实例属性的继承。这样，既通过在原型上定义方法实现了函数 复用，又能够保证每个实例都有它自己的属性。下面来看一个例子。 

```js
function SuperType(name){
 this.name = name;
 this.colors = ["red", "blue", "green"];
}
SuperType.prototype.sayName = function(){
 alert(this.name); 
};
function SubType(name, age){
 //继承属性
 SuperType.call(this, name);

 this.age = age;
}
//继承方法
SubType.prototype = new SuperType();
SubType.prototype.constructor = SubType;
SubType.prototype.sayAge = function(){
 alert(this.age);
};
var instance1 = new SubType("Nicholas", 29);
instance1.colors.push("black");
alert(instance1.colors); //"red,blue,green,black"
instance1.sayName(); //"Nicholas";
instance1.sayAge(); //29
var instance2 = new SubType("Greg", 27);
alert(instance2.colors); //"red,blue,green"
instance2.sayName(); //"Greg";
instance2.sayAge(); //27 
```

组合继承避免了原型链和借用构造函数的缺陷，融合了它们的优点，成为 JavaScript 中最常用的继 承模式。而且，instanceof 和 isPrototypeOf()也能够用于识别基于组合继承创建的对象。 

### 深浅拷贝

#### 浅拷贝

复制一个对象，但复制的对象属性中不能是引用类型值的属性

```js
var obj = {
    name: 'yzn',
    age: 12,
    address: '郑州',
    company: '民蕴',
    arr: [1, 2, 3]
}

var obj2 = obj

function qiankaobei() {
    Object.keys(obj).forEach(item => {
        obj2[item] = obj[item]
    })
}

qiankaobei()

obj.arr.push(4)

console.log(obj2);
console.log(obj);
```

#### 深拷贝

多复杂的对象都可以拷贝，且引用类型值的属性也没关系，且互不影响

```js
var obj = {
    name: 'yzn',
    age: 12,
    address: 'zz',
    company: 'my',
    arr: [1, 2, 3, [2, 2, 2]],
    oo: {
        high: 188,
        cm: 'yyy',
        per: {
            cc: 22,
            zz: 'lll',
            arrc: ['2', 2, ['c', 'a']]
        }
    }
}

function deepCopy(current, target) {
    for (var key in current) {
        // 存当前 key 的 value 值
        var value = current[key]
        // 如果这个值是数组类型
        if (value instanceof Array) {
            // 让目标对象的当前 Key 为一个空数组
            target[key] = []
            // 递归进行拷贝
            arguments.callee(value, target[key])
        } else if (value instanceof Object) {
            // 让目标对象的当前 key 为一个空对象
            target[key] = {}
            // 递归进行拷贝
            arguments.callee(value, target[key])
        } else {
            target[key] = value
        }
    }
}

var obj2 = {}

deepCopy(obj, obj2)
```



### 堆和栈

栈：先进先出

堆：后进先出

### 执行环境及作用域

执行环境定义了变量或函数有权访问的其它数据，决定了它们各自的行为。

**每个执行环境都有一个与之关联的变量对象，环境中定义的所有变量和函数都保存在这个对象中。**

全局执行环境是最外围的执行环境。

每个函数都有自己的执行环境。当**执行流**进入一个函数时，函数的环境就会被推入一个环境栈中。而在函数执行之后，栈将其环境弹出，把控制权返回给之前的执行环境。ES中的执行流正是由这个方便的机制控制着。

当代码在一个环境中执行时，会创建变量对象的一个作用域链。作用域链的用途，是 保证对执行环境有权访问的所有变量和函数的有序访问。 作用域链的前端，始终都是当前执行的代码所 在环境的变量对象。**如果这个环境是函数，则将其活动对象（activation object）作为变量对象。活动对 象在最开始时只包含一个变量，即 arguments 对象**（这个对象在全局环境中是不存在的）。作用域链中 的下一个变量对象来自包含（外部）环境，而再下一个变量对象则来自下一个包含环境。这样，一直延 续到全局执行环境；全局执行环境的变量对象始终都是作用域链中的最后一个对象。 

标识符解析是沿着作用域链一级一级地搜索标识符的过程。搜索过程始终从作用域链的前端开始， 然后逐级地向后回溯，直至找到标识符为止（如果找不到标识符，通常会导致错误发生）。 

#### 执行上下文栈

1、在全局代码执行前，JS 引擎就会创建一个栈来存储管理所有的执行上下文对象

2、在全局执行上下文（window）确定后，将其添加到栈中（压栈）

3、在函数执行上下文创建后（每当函数被调用就会创建一个函数的执行上下文），将其添加到栈中（压栈）

4、在当前函数执行完后，将栈顶的对象移出（出栈）

5、当所有的代码执行完成后，栈中只剩下 window

注：栈的底部只可能是 window

### 闭包

闭包是指有权访问另一个函数作用域中的变量的**函数**

闭包有两种模式：函数模式的闭包和对象模式的闭包

闭包的作用：缓存数据，延长作用域链

闭包的优点和缺点均为缓存数据

```js
// 函数模式的闭包
function f1() {
    var num = 10
    function f2() {
        console.log(10)
    }
    f2()
}

f1()
```

```js
// 对象模式的闭包
function f1() {
    var num = 10
    var obj = {
        age: num
    }
    console.log(obj.age)
}

f1()
```

当某个函数被调用时，会创建一个执行环境及响应的作用域链。然后，使用 arguments 和其它命名参数的值来初始化函数的活动对象。但在作用域链中，外部函数的活动对象始终处于第二位，外部函数的外部函数的活动对象处于第三位，……直至作为作用域链终点的全局执行环境。 

**闭包的问题**

作用域链的这种配置机制引出了一个值得注意的副作用，即闭包只能取得包含函数中任何变量的最 后一个值。别忘了闭包所保存的是整个变量对象，而不是某个特殊的变量。 

在闭包中使用 this 对象也可能会导致一些问题。 

闭包会导致内存泄漏，例：

```js
function assignHandler(){
 	var element = document.getElementById("someElement");
 	element.onclick = function(){
 		alert(element.id);
 	};
} 
```

### 事件流

事件流描述的是从页面中接收事件的顺序。

#### 事件冒泡

IE 的事件流叫做事件冒泡（从里向外，div => body => html => Document）

#### 事件捕获

网景的事件流叫做事件捕获（从外向里，Dodument => html => body => div）

#### DOM 事件流

“DOM2级事件”规定的事件流包括三个阶段：事件捕获阶段、处于目标阶段和事件冒泡阶段 。首 先发生的是事件捕获，为截获事件提供了机会。然后是实际的目标接收到事件。最后一个阶段是冒泡阶段。

即 Dodument => html => body => div => body => html => Document

### 垃圾收集

+ 标记清除
+ 引用计数

### 内存泄漏与内存溢出

内存泄漏：

占用的内存没有及时释放

内存泄漏积累的多了就容易导致内存溢出

#### 哪些操作会造成内存泄漏

+ 意外的全局变量

![](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2262097129,4197717905&fm=173&app=25&f=JPEG?w=390&h=62 )

+ 闭包引起的内存泄漏

![](https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=604424390,2416475205&fm=173&app=25&f=JPEG?w=382&h=114&s=CED2CD1A87F45C221E4408DE000010B2 )

+ 没有清理的DOM元素引用 

![](https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=209075,4008381855&fm=173&app=25&f=JPEG?w=510&h=242&s=4D42EC1A1D4A55495C7500DB0000C0B2 )

+ 被遗忘的定时器或者回调 

![](https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=372941860,2834490686&fm=173&app=25&f=JPEG?w=436&h=136&s=ED50EC1A93704C2004D41DDA0000D0B2 )

#### 怎样避免内存泄漏

+ 减少不必要的全局变量，或者生命周期较长的对象，及时对无用的数据进行垃圾回收； 
+ 注意程序逻辑，避免“死循环”之类的 ； 
+ 避免创建过多的对象 原则：不用了的东西要及时归还。 

#### 内存溢出

一种程序运行出现的错误

当程序运行需要的内存超过了剩余的内存时，就会抛出内存溢出的错误

### 进程和线程

进程

+ 程序的一次执行，它占有一片独有的内存空间
+ 可以通过 windows 任务管理器查看进程

线程

+ 是进程内的一个独立执行单元
+ 是程序执行的一个完成流程
+ 是 CPU 的最小调度单元






