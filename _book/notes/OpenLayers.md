# OpenLayers



## example

+ [网格背景 ](<https://openlayers.org/en/latest/examples/canvas-tiles.html>)
+ [几何元素拖动](<https://openlayers.org/en/latest/examples/custom-interactions.html>)
+ [拖拽修改几何元素](<https://openlayers.org/en/latest/examples/draw-and-modify-features.html>)
+ [绘制几何元素](<https://openlayers.org/en/latest/examples/draw-features.html>)
+ [涂鸦绘制几何元素](<https://openlayers.org/en/latest/examples/draw-freehand.html>)
+ [绘制几何形状](<https://openlayers.org/en/latest/examples/draw-shapes.html>)
+ [点对点行走动画](<https://openlayers.org/en/latest/examples/feature-move-animation.html>)
+ [网格地图分划覆盖](<https://openlayers.org/en/latest/examples/graticule.html>)
+ [为线绘制箭头](<https://openlayers.org/en/latest/examples/line-arrows.html>)
+ [Moveend Event](<https://openlayers.org/en/latest/examples/moveend.html>)
+ [Mouse Position](<https://openlayers.org/en/latest/examples/mouse-position.html>)
+ [多边形样式](<https://openlayers.org/en/latest/examples/polygon-styles.html>)
+ [Snap 交互绘制修改几何元素](<https://openlayers.org/en/latest/examples/snap.html>)
+ [选区](<https://openlayers.org/en/latest/examples/box-selection.html>)
+ [Overlay](<https://openlayers.org/en/latest/examples/overlay.html>)
+ [修改几何元素测试](<https://openlayers.org/en/latest/examples/modify-test.html>)
+ [Popup](<https://openlayers.org/en/latest/examples/popup.html>)
+ [Vector labels](<https://openlayers.org/en/latest/examples/vector-labels.html>)



## ol.Map

```js
const map = new Map({
    layers: [],
    target,
    view
});
```



给地图绑定事件：

```js
// 绑定地图事件，singleclick，dblclick，contextmenu、pointermove
map.on('singleclick', (e) => {
    
});

// moveend 事件，当地图 zoom 改变时触发
map.on('moveend', (e) => {
    // 该事件存在 bug，就是当拖动地图停下的时候也会触发事件
});

// 为了防止 moveend 事件的 bug，可以使用下面的方式
map.getView().on('change:resolution', e => {
    console.log(e.target.getZoom());
});
```



## ol.layer.Vector

- brightness，亮度，默认为 `0` ；
- contrast，对比度，默认为 `1` ；
- hue，色调，默认为`0` ；
- opacity，透明度，默认为 `1` ，即完全透明；
- saturation，饱和度，默认为 `1` ；
- source，图层的来源，如果在构造函数中没有传入相应的参数，可以调用 `ol.layer.Layer#setSource`方法来设置来源： `layer.setSource(source)` ；
- visible，是否可见，默认为 `true` ；
- extent，图层渲染的区域，即浏览器窗口中可见的地图区域。extent 是一个矩形范围，格式是`[number, number, number, number]` 分别代表 `[left, bottom, right, top]` 。如果没有设置该参数，图层就不会显示；
- minResolution，图层可见的最小分辨率，当图层的缩放级别小于这个分辨率时，图层就会隐藏；
- maxResolution，图层可见的最大分辨率，当图层的缩放级别等于或超过这个分辨率时，图层就会隐藏。



## ol.interation.Draw

绘图控件对象

```js
const draw = new Draw({
    // 绘制层的数据源
    source: source,
    // 绘制的元素类型
    type: 'circle',
    // 默认的绘制类型只有四种类型，如果我想绘制一个矩形框呢？当然有一个拉框交互可以实现这个效果，这里我们使用 draw 交互来实现拉框的效果，这个要结合 maxPoints 加以限制。
    geometryFunction: geometryFunction,
    // 数值类型，单位是像素，判断用户鼠标（PC）或者手指（移动设备）的行为是添加点，还是按住鼠标或者手指不松开进行拖拽地图，默认值是 6 像素，也就是说当按下鼠标和抬起鼠标左键之间的这段时间段内，如果地图被拖动没有超过 6 像素，那么默认为添加一个点，相反如果超过了 6 像素，那么不会添加点，只是平移一下地图。
    clickTolerance,
    // 绘制的要素所属的要素集合，要素集合（featureCollection）是要素集（source）的一个子集，要素集包含要素集合。要素集合添加到要素集（source），才会显示到 source 所属的矢量图层。这个参数和 source 参数很类似。
    features,
    // 数值，像素为单位，默认值是 12 像素。上面我们提到完成多边形时，可以把最后一个点与第一个点重合来完成，那么我们知道重合很难做到，只有吸附才能做到精确重合。上图可以看到鼠标所指的位置和吸附的矢量点还有一定的距离，也就是说当鼠标位置进入以矢量点为圆心，一定距离为半径的圆范围内，就会被吸附到相应的矢量点。具体的值就是在这里设置的。
    snapTolerance,
    // 都是数值类型，maxPoints 表示绘制单个要素（面和线）最多的点数限制，默认没有限制；minPoints 表示绘制单个要素（面和线）需要的最少点数，面默认为 3，线默认为 2。
    maxPoints & minPoints
});

// 向 map 添加绘制元素的控件对象
map.addInteraction(draw);

// 移除 map 绘制元素的控件对象
map.removeInteraction(draw);
```



## ol.interaction.Modify

修改几何元素

```js
const modify = new Modify({
    source,		// 如果要修改已存在的 source 则配置 source
    features,		// 	如果要修改指定的 feature 则配置 feature
});
```



## ol.interaction.Select

```js
const select = new Select({
    // 控制可以被选中的图层，它是一个数组
    layers: [layer, layer],	
    // 选取方式：点击、移入等
    condition，
    // 设置是否多选
    multi: Boolean
})
```



## 地图坐标偏差问题

在 react 项目中使用 ol 的时候，点击地图上的元素无效，但点击元素旁边的一小块区域时有效，感觉渲染的元素像发生了位移一样。最终解决办法需要给 map 容器定宽，否则在宽度自适应的情况下元素的渲染可能会发生偏差。



































