# Vue  移动端项目笔记

## 1 vue-router 相关

### 1.1 如何获取路由中的参数

每一个vue实例身上都有一个属性： `$route` ，该属性是路由里的参数对象，其身上有一个 `params` 属性，如下方式获取

```javascript
Vue.$route.params.id   //获取路由中的 id 参数值
```

### 1.2 获取文章的详细内容数据时，图片显示异常

解决方案：将图片的 width 属性设置为 100% （如果没有解决，需要删除 style 标签中的 scoped 属性）

### 1.3 编程式的导航

在每一个 `vue` 实例上，都存在一个 `$router` 属性，该属性是路由里的导航对象；`$router` 为 `VueRouter` 实例，想要导航到不同URL，则使用 `$router.push` 方法 

```javascript
// 使用方式一： 传入一个字符串
// 其中传入 push 中的字符串就是路由中的 path 属性值
this.$router.push('/home/goodsinfo' + id) 

// 使用方式二： 传入一个对象
// 其用法仅仅改为传入了 path 对象
this.$router.push({ path: '/home/goodsinfo' + id }) 

// 使用方式二： 传入命名的路由
// 其用法需规定路由的 name 属性，参数通过 params 获得
this.$router.push({ name: 'goodsinfo', params: { id: id } })
```

## 2 组件相关

### 2.1 什么的组件

组件的出现是为了拆分 Vue 实例的代码量，能够让我们以不同的组件来划分不同的功能模块

### 2.2 组件化和模块化的区别

+ 模块化：是从代码逻辑角度进行划分的；方便代码分层开发，保证每个功能模块的职能单一；
+ 组件化：是从UI界面的角度进行划分的；前端的组件化，方便UI组件的重用；

### 2.3 父组件向子组件传递参数

父组件向子组件传递参数需要在使用子组件的标签上绑定该参数，例：

```html
<!-- 向 comments 子组件传递 id 参数 -->
<comments :id='this.id'></comments>
```

子组件想要使用父组件传递过来的参数，需要接受该参数

```javascript
new Vue({
    props: ['id']   //在 vue 实例中使用 props 接收该参数，并使用 this.id 使用它
})
```

### 2.4 子组件向父组件传递参数

采用事件调用机制，即父组件定义一个方法，并将该方法传递给子组件，子组件接收并调用该方法，将需要传递的数据以参数的形式传递给父组件。例：

**父组件中**

```html
<!-- 给子组件身上绑定一个事件，子组件通过该事件传递数据 -->
<childComponent @getData='getData'></childComponent>
```

```javascript
methods: {
    getData(data){
        this.mydata = data  //可以将传递过来的值保存在自己的 data 中
    }
}
```

**子组件中**

```javascript
// 子组件可以使用 $emit 触发父组件的自定义事件
// 第一个参数为触发的事件名称，第二个参数为需要传递的参数
this.$emit('getData', data)  
```

## 3 相关插件的使用

### 3.1 时间日期插件 Moment.js

使用方法：   

```javascript
// 安装插件
npm i moment -S
// 导入该插件
import moment from 'moment'
//定义全局时间格式化过滤器
Vue.filter('dataFormat', function(datastr, pattern = "YYYY-MM-DD HH:mm:ss"){
    return moment(datastr).format(pattern);
})
```

官方网站： http://momentjs.cn/

### 3.2 图片查看器 Vue preview

使用方法：

```javascript
//安装插件（此处使用的是1.0.5版本）
npm i vue-preview@1.0.5 -S
//导入和挂载插件
import VuePreview from 'vue-preview'
Vue.use(VuePreview)
// html 部分  注意：此处的数据名称只能使用 list , 不能使用其它名称
<img class="preview-img" v-for="(item, index) in list" :src="item.src" height="100" @click="$preview.open(index, list)" :key="item.src">
// javascript 部分
data:{
    list:[
        { src: 'xxxx.jpg', w: 600, h: 400 },
        { src: 'xxxx.png', w: 600, h: 400 }
    ]
}
```

官方 `github` 地址：https://github.com/LS1231/vue-preview

### 3.3 禁用 webpack 的严格模式

使用插件  `babel-plugin-transform-remove-strict-mode`

**安装**

```shell
npm install babel-plugin-transform-remove-strict-mode
```

**.babelrc**

```shell
{
  "plugins": ["transform-remove-strict-mode"]
}
```

**Via CLI**

```shell
$ babel --plugins transform-remove-strict-mode script.js
```

**Via Node API**

```shell
require("babel-core").transform("code", {
  plugins: ["transform-remove-strict-mode"]
});
```

**github地址** 

https://github.com/genify/babel-plugin-transform-remove-strict-mode

## 4 动画相关

Vue 中的动画分为三段

+ `v-enter` 和 `v-leave-to` 初始阶段
+ `v-enter-to` 和 `v-leave` 结束阶段
+ `v-enter-active` 和 `v-leave-active` 运行阶段

### 4.1 基本使用

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<style>
		.box{
			width: 100px;
			height: 100px;
			background: red;
		}
         /* 初始阶段 - 透明度为 0，从 200px 位置进入 */
		.v-enter,
		.v-leave-to{
			opacity: 0;
			transform: translateX(200px);
		}
        /* 运行阶段 设置过渡 */
		.v-enter-active,
		.v-leave-active{
			transition: all .4s ease ;
		}
        /* 离开阶段 - 透明度为 1 */
		.v-leave,
		.v-enter-to{
			opacity: 1;
		}
	</style>
	<script src="js/vue-2.4.0.js"></script>
</head>
<body>
	<div id="app">
		<button @click='flag=!flag'>按钮</button>
        <!-- 改变 v-前缀，只需添加 name 属性 -->
		<transition name='my'>
			<div v-if='flag' class="box"></div>
		</transition>
        <!-- 使用第三方动画类库 animate.css 使用方式：添加类名前必须添加基类 animated
		<transition enter-active-class='animated xxx' leave-active-class='animated xxx'>
			也可以把基类放到元素身上，这样 transition 身上则不需要放置基类
			<div v-if='flag' class="animated box"></div>
		</transition>
		-->
        <!-- 使用 :dutation='{ enter: 200, leave: 400 }' 来设置入场和离场的时长-->
	</div>
</body>
</html>
<script>
	var vm = new Vue({
		el: '#app',
		data: {
			flag: false
		},
		methods: {
		}
	})
</script>
```

### 4.2 JavaScript 钩子

```html
<transition
  v-on:before-enter="beforeEnter"
  v-on:enter="enter"
  v-on:after-enter="afterEnter"
  v-on:enter-cancelled="enterCancelled"

  v-on:before-leave="beforeLeave"
  v-on:leave="leave"
  v-on:after-leave="afterLeave"
  v-on:leave-cancelled="leaveCancelled"
>
  <!-- ... -->
</transition>
```

**半场动画案例**

```html
<div class='ball' v-show='flag'></div>
```


```javascript
data: { flag: false }
methods: {
  // --------
  // 进入中
  // 钩子函数的第一个参数都是 el，表示要执行动画的那个DOM参数，是个原生的JS DOM对象
  // --------
  beforeEnter: function (el) {
    // 可以在此处设置动画开始之前的起始位置
    el.style.transform = "translate(0,0)"
  },
  enter: function (el, done) {
    // 动画若想实现过渡，必须加上 el.offsetWidth
    el.offsetWidth
    // 此处表示动画开始之后的样式，这里可以设置小球完成动画之后的结束状态
    el.style.transform = "translate(150px,150px)"
    el.style.transition = "all 1s ease"
    // 这里的 done 其实就是 afterEnter 函数，也就是说 done 是 afterEnter 函数的引用
    done()
  },
  afterEnter: function (el) {
    // 表示动画完成之后
    this.flag = !this.flag
  },
  enterCancelled: function (el) {
    // 进入关闭，一般用不到
  },

  // --------
  // 离开时
  // --------

  beforeLeave: function (el) {
    // ...
  },
  // 此回调函数是可选项的设置
  // 与 CSS 结合时使用
  leave: function (el, done) {
    // ...
    done()
  },
  afterLeave: function (el) {
    // ...
  },
  // leaveCancelled 只用于 v-show 中
  leaveCancelled: function (el) {
    // ...
  }
}
```

### 4.3 列表过渡

如果需要过渡的元素是通过 v-for 循环渲染出来的，则不能使用 transtion 包裹，需要使用 transtion-group 

```html
<ul>
    <transition-group>
    	<li v-for='item in items' :key='item.id'>{{ item.name }}</li>
    </transition-group>
</ul>
```

如果想要动画效果更佳流畅，需要指定两个类，能够实现列表后续的元素渐渐的飘上来的效果

```css
.v-move{
    transition: all .6s ease ;
}
.v-leave-active{
    position: absolute ;
}
```

给 transtion-group 标签加上 appear 属性，可以实现入场时的效果

```html
<transition-group appear></transition-group>
```

可以给 transtion-group 添加 tag 属性，指定将来要渲染的元素，如果不指定，默认渲染为 span

```html
<transition-group tag='ul'>
	<li v-for='item in items' :key='item.id'>{{ item.name }}</li>
</transition-group>
```



## 5 其它

### 5.1 $refs 对象

该对象持有注册过 `ref` 特性的所有 DOM 元素和组件实例

**用法**

```html
<!-- 在 input 身上绑定 ref 属性，通过该引用对象可以拿到原生的 DOM 对象 -->
<input @change='changeMethods' ref='inp' value='' name='' type='text' />
```

```javascript
methods: {
    changeMethods(){
        // 这里通过 this.$refs.inp 拿到原生 dom 对象  就可以使用 value 获取该值
        console.log(this.$refs.inp.value)
    }
}
```

### 5.2 watch

watch - 侦听属性，用来观察和响应 `Vue` 实例上的数据变动

```javascript
var vm = new Vue({
    data： {
		count: 1
    },
    watch: {
          // 监听 count 值，改变时发生的回调，接收两个参数，分别为新值和旧值
         'count': function(newVal, oldVal){
    		// 当 count 值发生变化时发生的操作
		}
    }
})
```

### 5.3 vuex

概念：vuex 是 Vue 配套的公共数据管理工具，它可以把一些共享的数据，保存到 vuex 中，方便整个程序中的任何组件直接获取或修改我们的公共数据

#### 5.3.1 安装步骤

1 - 安装：

```shell
npm install vuex --save
```

2 - 在一个模块化的打包系统中，必须显式地通过 `Vue.use()` 来安装 Vuex：

```javascript
import Vue from 'vue'
import Vuex from 'vuex'
// 注册 vuex 到 Vue 实例中
Vue.use(Vuex)
```

3 - `new Vuex.Store()` 实例，得到一个数据仓储对象

```javascript
const store = new Vuex.Store({
    state: {
        // 可以把 state 想象成组件中的 data，专门用来存储数据的
    },	
    mutations: {
        // 存放一些方法，用于修改 state 中的数据
    },
    getters: {
        // 只负责对外提供数据，不负责修改数据，如果想要修改 state 中的数据，使用 mutations 
    }
})
```

4 - 将 vuex 创建的 store 挂载到 vue 实例上

```javascript
var vm = new Vue({
    data: {},
    methods: {},
    store: store   // 也可简写为 store 
})
```

#### 5.3.2 使用 state 中的数据

如果想要在组件中访问 store 中的数据，只能通过 `this.$store.state.xxx` 来访问。

只要挂载了 store 到 vm 实例上，任何组件都能使用 store 来存取数据。

#### 5.3.3 使用 mutations 中的方法

+ 如果要操作 store 中的 state 值，只能通过调调用 mutations 提供的方法，才能操作对应的数据，不推荐直接操作 state 中的数据，因为万一导致了数据的紊乱，不能快速定位到错误的原因，因为每个组件都可能有操作数据的方法

```javascript
// 例：有一个仓储 store，其中存储了一个 count 数据和一个 increment 方法，该方法每次被调用时会把 state 中的 count 值增加 1
const store = new Vuex.Store({
    state: {
        count: 0
    },
    mutations: {
        // 注：mutations 中定义的方法只能接收两个参数
        // 参数1：被规定死，必须为 state
        // 参数2：是通过 commit 提交过来的参数，提交过来的参数可以是对象、字符串、数值
        increment(state){
            state.count ++ 
        }
    }
})
```
组件中如何使用 store 中 mutations 里的方法：

```javascript
// 组件中如果想要使用 mutations 中的方法，只能使用 this.$store.commit('方法名')
var vm = new Vue({
    methods: {
        add(){
            // 调用 store 实例中的 mutations 中的 increment 方法
            this.$store.commit('increment')
        }
    }
})
```

#### 5.3.4 使用 getters 

```javascript
// 例：
const store = new Vuex.Store({
    state: {
        count: 0
    },
    getters: {
        // 每一个 getters 的属性值都是一个方法，该方法的第一个参数必须为 state
        // 只要 state 中的数据发生了变化，那么如果 getters 正好也引用了这个数据，就会立即触发 getter 重新求值
        optCount: function(state){
            return '当前最新的count值是：' + 'state.count'
        }
    }
})
```
组件中如何使用 store 中 getters :  `this.$store.getters.xxx` 

## # 其它知识点

### # vue-router 的 post 请求

+ 使用 `post` 发送数据请求时：需要传入的参数有三个
  + 参数1：请求的 URL 地址
  + 参数2：提交给服务器的数据对象  `{ content: this.msg }`
  + 参数3：定义提交的时候，表单中数据的格式  `{ emulateJSON: true }`
    + 可以将第三个参数配置为全局 `Vue.http.options.emulateJSON = true` 

```javascript
// post 请求书写格式
this.$http.post(参数1，参数2，参数3).then(function(result){
    console.log(result.body)
})
```

### # 将项目托管到码云上

+ 在项目目录下运行 `git init`
+ 使用 `git add .` 将文件放入 站内区
+ 使用 `git commit -m "这是描述"` 将项目提交至本地仓库

可以使用 `git status` 命令查看所有文件的状态（标红的代表未提交）

如何查看自己的电脑是否拥有公钥：进入c://用户/用户名/ 下检查是否有 .ssh 文件夹

git remote add origin https://gitee.com/zahirah/vue-app.git

### # 使用字体图标

```css
@font-face{
    font-family: 'myicon';   /* 自定义名称 */
    src: url('../font/xxx.eot') format('embedded-opentype'), 
         url('../font/xxx.svg') format('svg'), 
         url('../font/xxx.ttf') format('truetype'), 
         url('../font/xxx.woff') format('woff');  
    /* 字体文件路径 - 引入顺序，eto > svg > ttf > woff */
}
/* 给所有已 icon- 开头的类名设置该字体 */
[class^ = 'icon-'],
[class* = ' icon-']{
    font-family: 'myicon' ;
    font-style: normal ;   /* 设置斜体为正常 */ 
}
```

