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
```



## ol.layer.Vector

```js

```





## ol.interation.Draw

绘图控件对象

```js
const draw = new Draw({
    // 绘制层的数据源
    source: source,
    // 绘制的元素类型
    type: 'circle',
    // 几何信息变更时的回调函数
    geometryFunction: geometryFunction
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







































