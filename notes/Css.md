# CSS

## 圣杯布局

+ 两边固定  当中自适应
+ 当中列要完整显示
+ 当中列要优先加载

+ 浮动:搭建完整的布局框架
+ margin 为负值（控制边界）:调整旁边两列的位置(使三列布局到一行上)  --- 重点
+ 使用相对定位:调整旁边两列的位置（使两列位置调整到两头）

```html
<div id="wrap">
  <div class="middle">middle</div>   <!-- middle 盒子在前保证优先加载  -->
  <div class="left">left</div>
  <div class="right">right</div>
</div>
```

```css
#wrap{
  padding: 0 200px;
}
.middle {
  float: left;
  width: 100%;
  height: 100px;
  background-color: red;
}
.left{
  position: relative;
  left: -200px;
  float: left;
  width: 200px;
  height: 100px;
  margin-left: -100%;   /* 设置 -100% 让 left 盒子贴 middle 左侧 */ 
  background-color: pink;
}
.right{
  position: relative;
  right: -200px;
  float: left;
  width: 200px;
  height: 100px;
  margin-left: -200px;  /* 设置 -200px 让 right 盒子贴 middle 右侧 */ 
  background-color: green;
}
```

## 等高布局

为上面的圣杯布局添加等高，就是让 left、right、middle 三个盒子等高，三个盒子始终以最高的盒子为高度保持等高

```css
.middle,.left,.right{
  padding-bottom: 10000px;
  margin-bottom: -10000px;    /* 使用 margin 负值恢复边界控制 */
}
```

## 双飞翼布局

在圣杯布局的基础下，去掉了定位的使用和 wrap盒子的边距。改成给 middle 盒子在套一个内部 div ，给该 div 加上 padding 即可

```html
<div class="middle">
  <div class='inner-middle' style='padding: 0 200px;'>middle</div>
</div>
```

## BFC 实现两列布局

左边固定，右边自适应

在 IE 6 7中没有 BFC 的概念，但有一个 haslayout 概念，可以使用 zoom : 1 开启 haslayout

```html
<div class="left">left</div>
<div class="right">right</div>
```

```css
.left {
  float: left;
  width:300px;
  height: 300px;
  background-color: pink;
  opacity: 0;
}
.right{
  overflow: hidden;    /* 核心：开启新的 BFC，利用 BFC 不会与浮动盒子重叠规则 */
  height: 300px;
  background-color: red;
}
```


## 实现多行文本溢出显示 ...

```css
.class{
  width: 200px;  
  /* 用来限制在一个块元素显示的文本的行数。 为了实现该效果，它需要组合其他的WebKit属性。常见结合属性如下 */
  -webkit-line-clamp: 3;
  /* 必须结合的属性 ，将对象作为弹性伸缩盒子模型显示  */
  display: -webkit-box;
  -webkit-box-orient: vertical;
  /* 必须结合的属性 ，设置或检索伸缩盒对象的子元素的排列方式 */ 
  overflow: hidden;
}
```

## 让图文不可复制

```css
.class{
  -webkit-user-select: none; 
	-ms-user-select: none;
	-moz-user-select: none;
	-khtml-user-select: none;
	user-select: none;
}
```

## 修改 placeholder 颜色

```css
input::-webkit-input-placeholder { 
  /* WebKit browsers */ 
  font-size:14px;
  color: red;
} 
input::-moz-placeholder { 
  /* Mozilla Firefox 19+ */ 
  font-size:14px;
  color: red;
} 
input:-ms-input-placeholder { 
  /* Internet Explorer 10+ */ 
  font-size:14px;
  color: red;
}
```

