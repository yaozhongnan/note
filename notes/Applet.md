# Applet



## Page：用page()注册一个页面

1. data：页面初始数据
2. onLoad：监听加载
3. onReady：监听初次渲染完成->调用一次，可以和视图层进行交互
4. onShow：监听页面显示->调用一次
5. onHide：监听页面隐藏
6. onUnload：监听页面卸载->close页面
7. onPageScroll：页面滚动触发事件的处理函数

加载顺序：onLoad->onShow->onReady->onHide->onShow->onUnload
页面第一次启动加载顺序：onLaunch->onLoad->onShow->onReady->onHide->onShow->onUnload
页面隐藏后启动加载顺序：onHide->onLoad->onShow->onReady->onHide->onShow->onUnload