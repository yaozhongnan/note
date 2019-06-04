# React Diff 算法



传统的 diff 算法会对两颗树形结构进行遍历，找出其中的差异，找到差异后还要计算最小转换方式，最终达到的算法复杂度是 O(n^3)，其中 n 代表节点个数，1000 个节点就需要 10 忆次比较。



那么 react 是如何做到将 O(n^3) 转变成 O(n) 的呢？



首先需要了解一下什么是虚拟 DOM ？



**真实的 DOM 树**

```html
<div class='classname'>
   	<p> text </p>
</div>
```

**虚拟 DOM 树**

```json
{
    type: 'div',
    props: { class: 'classname' },
    children: [
        { type: 'p', props: { value: 'text' } }
    ]
}
```



可以看到虚拟 DOM 就是将真实的 DOM 转换成了 js 对象，react diff 算法实际上比较的就是两个 js 对象的差异。



那么为什么要采用 js 对象这种操作方式呢？



传统的 DOM 操作之所以低效，是因为当你在使用 document.createElement('div') 创建一个 div 元素时，会需要按照标准实现一大堆东西，具体实现了什么呢？可以看看下面的代码输出了什么。

```js
const div = document.createElement('div');
for (let key in div) {
	console.log(key)
}
```



相比之下，js 对象的操作却有着很高的效率。因此 react 才会通过 js 对象的方式构建一颗虚拟 DOM 树。



回到最初的问题：react 是如何做到将 O(n^3) 转变成 O(n) 的呢？



这里就要讲到 react diff 使用的三个策略：

1、页面中发生跨层级的 DOM 节点移动操作频率很低，可以忽略不计。（tree diff）

2、类型相同的两个组件会产生相似的树形结构，类型不同会产生不同的树形结构。（component diff）

3、对于同一层级的一组子节点，它们可以通过唯一 key 进行区分。（element diff）



## 策略一：tree diff



页面中发生跨层级的 DOM 节点移动操作频率很低，可以忽略不计。



首先什么是跨层级的 DOM 节点移动操作呢？例如父节点 A 下有 B 和 C 两个子节点，B 和 C 互为兄弟节点。现在将 B 节点移动到 C 节点内，也就是让 B 成为 C 的子节点。这样的操作就称为跨层级的 DOM 节点移动操作。因为本来 B 和 C 属于同一层，现在 B 移动到了另外一层，的确是跨层移动了节点。



由于真实场景中这类操作发生的频率低到可以忽略不计，因此 react 只进行了同层比较。



![](E:\yzn\markdown\images\react\react 同层比较.png)



那么假如发生了跨层移动操作，react 会怎么做呢？



还是上面的例子，对比第一层，还是 A，没有变化。对比第二层，发现变化，少了 B 节点，因此执行删除操作，删除 B 节点。对比第三层，发现变化，多了 B 节点，因此执行创建操作，创建 B 节点。



可以发现 react 只执行创建和删除操作，并不会出现移动操作，因为 react 无法得知它仅仅只是被移动了。那么这种只创建和删除的操作有什么弊端呢？



事实上删除操作是很简单的，而麻烦的就是创建操作。试想一下，倘若 B 节点拥有 1000 个子节点，那么创建这样一整个节点树，是非常影响 react 性能的，因此官方并不建议进行 DOM 节点跨层级的操作。



基于这一点，给出以下建议：

1、在开发组件时，保持稳定的 DOM 结构会有助于性能的提升。

2、可以通过 CSS 隐藏或显示节点，而不是真的移除或添加 DOM 节点。



## 策略二：component diff



类型相同的两个组件会产生相似的树形结构，类型不同的会产生不同的树形结构。



这个策略是什么意思呢？



比如 A 节点下有一个组件类型的节点 B，对比过程中发现 A 下的节点还是组件 B 的话，则按照原策略继续比较虚拟 DOM 树。如果发现 A 下的节点更改为组件 C 的话。这时就会先删除组件 B，再创建组件 C



在 tree diff 中我们知道，这样创建一整个节点树，是会影响 react 性能的。但由于不同类型的组件是很少存在相似 DOM 树的，因此这种极端因素很难在现实开发过程中造成重大影响的。



有时候对于同一类型的组件，虚拟 DOM 可能并没有发生任何变化。如果能够确切知道这点那可以节省大量的 diff 运算时间，因此 react 提供 shouldComponentUpdate 来判断是否需要 diff 



## 策略三：element diff



对于同一层级的一组子节点，它们可以通过唯一 key 进行区分。



这个 key 就是 react 经常报的一个警告，缺少 unique key，在渲染列表时经常遇到。



那 react 让我们加这个 key 的原因是什么呢？



看一个例子：新老集合所包含的节点如下图所示。当进行差异对比时，发现 B != A，则创建 B 删除 A，同理，创建 A，D，C，删除 B，C，D





![](E:\yzn\markdown\images\react\element tree1.png)





可见这种操作冗余繁琐，因为他们都是相同的节点只是位置发生了变化，一些列的删除创建相当低效。



针对这一策略，react 允许开发者对同一层级的同组子节点，添加唯一 key 进行区分。正是这个小小的改动，性能上却发生了翻天覆地的变化！



如下图所示：



![](E:\yzn\markdown\images\react\element tree2.png)



因为有了 key 作唯一标识，在进行 diff 差异化对比时，根据 key 发现都是相同的节点，只是位置不同，因此 react 给出的 diff 结果为 B，D 不作任何操作，A，C 进行移动操作即可。



尽管如此，react diff 还是存在些许不足的的地方。例如老集合为 A，B，C，D，新集合为 D，A，B，C，一眼就可以看出只是 D 的位置发生了变化，我们只需要将 D 移动到最前面即可。但是 react diff 针对这类现象的操作却是将 A，B，C 三个节点移动到 D 的后面。



基于这一点，给出以下建议：

1、在开发过程中，尽量减少类似将最后一个节点移动到列表首部的操作。

2、因为当节点数量过大或更新操作过于频繁时，在一定程度上会影响 React 的渲染性能。



## 参考资料

[React 源码剖析系列 － 不可思议的 react diff](<https://zhuanlan.zhihu.com/p/20346379?refer=purerender>)

[谈谈React中Diff算法的策略及实现](https://segmentfault.com/a/1190000016539430?utm_source=tag-newest)

[传统diff、react优化diff、vue优化diff](<https://www.jianshu.com/p/398e63dc1969>)

[React源码之Diff算法](https://segmentfault.com/a/1190000010686582#articleHeader3)

[react 官方 diff 文档](<https://zh-hans.reactjs.org/docs/reconciliation.html>)