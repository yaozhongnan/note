# JavaScript Utils

## 时间格式化

```javascript
// formatDate(new Date().getTime());//2017-05-12 10:05:44
// formatDate(new Date().getTime(),'YY年MM月DD日');//2017年05月12日
// formatDate(new Date().getTime(),'今天是YY/MM/DD hh:mm:ss');//今天是2017/05/12 10:07:45
function formatDate(time,format='YY-MM-DD hh:mm:ss'){
  var date = new Date(time);

  var year = date.getFullYear(),
      month = date.getMonth()+1,//月份是从0开始的
      day = date.getDate(),
      hour = date.getHours(),
      min = date.getMinutes(),
      sec = date.getSeconds();
  var preArr = Array.apply(null,Array(10)).map(function(elem, index) {
      return '0'+index;
  });////开个长度为10的数组 格式为 00 01 02 03

  var newTime = format.replace(/YY/g,year)
                      .replace(/MM/g,preArr[month]||month)
                      .replace(/DD/g,preArr[day]||day)
                      .replace(/hh/g,preArr[hour]||hour)
                      .replace(/mm/g,preArr[min]||min)
                      .replace(/ss/g,preArr[sec]||sec);

  return newTime;         
}
```

## 检测数据类型

```javascript
Object.prototype.toString.call('此处传入要检测的数据')  // 输出格式 例：[object Array]
```

```js
var type = function (o){
  var s = Object.prototype.toString.call(o);
  return s.match(/\[object (.*?)\]/)[1].toLowerCase();
};
type({}); // "object"
type([]); // "array"
type(5); // "number"
type(null); // "null"
type(); // "undefined"
type(/abcd/); // "regex"
type(new Date()); // "date"
```

```js
var type = function (o){
  var s = Object.prototype.toString.call(o);
  return s.match(/\[object (.*?)\]/)[1].toLowerCase();
};

['Null',
 'Undefined',
 'Object',
 'Array',
 'String',
 'Number',
 'Boolean',
 'Function',
 'RegExp'
].forEach(function (t) {
  type['is' + t] = function (o) {
    return type(o) === t.toLowerCase();
  };
});

type.isObject({}) // true
type.isNumber(NaN) // true
type.isRegExp(/abc/) // true
```

## 格式化数字

```javascript
function formatNum (num, n) {
  if (typeof num == "number") {
    num = String(num.toFixed(n || 0));
    var re = /(-?\d+)(\d{3})/;
    while (re.test(num)) num = num.replace(re, "$1,$2");
    return num;
  }
  return num;
}
console.log(formatNum(123456.1, 3))     // 123,456.100


// 格式化金钱，但不补零正则
var test1 = '1234567890'
var format = test1.replace(/\B(?=(\d{3})+(?!\d))/g, ',')

console.log(format) // 1,234,567,890
```

## 判断设备来源

```javascript
function deviceType(){
    var ua = navigator.userAgent;
    var agent = ["Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"];    
    for(var i=0; i<len,len = agent.length; i++){
        if(ua.indexOf(agent[i])>0){         
            break;
        }
    }
}
// 微信的 有些不太一样
function isWeixin(){
    var ua = navigator.userAgent.toLowerCase();
    if(ua.match(/MicroMessenger/i)=='micromessenger'){
        return true;
    }else{
        return false;
    }
}
```

## 生成随机长度的字符串

```javascript
function randomString(len = 32) {
  /****默认去掉了容易混淆的字符oOLl,9gq,Vv,Uu,I1****/
  let chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678' 
  let pwd = '';　　
  for (i = 0; i < len; i++) {　　　　
    pwd += chars.charAt(Math.floor(Math.random() * chars.length));　　
  }　　
  return pwd;
}
```

## 判断是否为空对象

```js
function isEmptyObject( obj ) {
    var name;
    for ( name in obj ) {
        return false;
    }
    return true;
}
console.log(isEmptyObject({}))		// true
```

## 数组和对象的深拷贝

```js
JSON.parse( JSON.stringify(param) );
```

## 上传图片并预览

不兼容 IE 和 safari 等低版本浏览器

```html
<!-- 绑定 onchange 事件 -->
<input type="file" onchange="previewImg(this)">
<!-- 要预览的图片位置 -->
<img id="imgId" src="" alt="">
```

```javascript
function previewImg(e){

	// 单独检测 IE 
	if (e.files === undefined) return alert('IE浏览器版本过低，不支持预览')

	// 用户重新上传时点击取消上传 bug，直接 return
	if (e.files[0] === undefined) return

	// 检测其余浏览器兼容性
	if (!e.files[0] || !window.FileReader) return alert('您的浏览器不支持预览')

	// 得到上传的文件对象
	var file = e.files[0];

	// 验证图片格式
	if (!/\.(jpe?g|png|gif)$/i.test(file.name)) {
		return alert('图片格式不正确')
	}
	// 验证图片大小，默认不超过 1MB
	if (file.size > 1 * 1024 * 1024) {
		return alert('图片大小不能超过 1MB')
	}

	// 以上验证通过，则执行下方预览功能代码
	
	// 创建 FileReader 实例
	var reader = new FileReader()

	// 读取发生错误时触发
	reader.addEventListener('error', function () {
		alert('读取文件时发生错误')
	}, false)

	// 读取文件完成时触发
	reader.addEventListener('load', function () {
		// base64 存在 this.result 中
		// 赋值给 预览图片的 src 即可
		document.getElementById('imgId').src = this.result;
	}, false)

	// 转 base64，核心
	reader.readAsDataURL(file);

}
```

## 原生 ajax 封装

```javascript
export default (type='GET', url='', data={}, async=true) => {
	return new Promise((resolve, reject) => { //定义一个promise
		type = type.toUpperCase();

		let requestObj;
		if (window.XMLHttpRequest) {
			requestObj = new XMLHttpRequest();
		} else {
			requestObj = new ActiveXObject;
		}

		if (type == 'GET') {
			let dataStr = ''; //数据拼接字符串
			Object.keys(data).forEach(key => {
				dataStr += key + '=' + data[key] + '&';
			})
			dataStr = dataStr.substr(0, dataStr.lastIndexOf('&'));
			url = url + '?' + dataStr;
			requestObj.open(type, url, async);
			requestObj.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
			requestObj.send();
		}else if (type == 'POST') {
			requestObj.open(type, url, async);
			requestObj.setRequestHeader("Content-type", "application/json");
			requestObj.send(JSON.stringify(data));
		}else {
			reject('error type');
		}

		requestObj.onreadystatechange = () => {
			if (requestObj.readyState == 4) {
				if (requestObj.status == 200) {
					let obj = requestObj.response
					if (typeof obj !== 'object') {
						obj = JSON.parse(obj);
					}
					resolve(obj);
				}else {
					reject(requestObj);
				}
			}
		}
	})
}
```

## 获取浏览器视口大小

```js
function getViewport() {
    if (document.compatMode == "BackCompat") {
        return {
            width: document.body.clientWidth,
            height: document.body.clientHeight
        };
    } else {
        return {
            width: document.documentElement.clientWidth,
            height: document.documentElement.clientHeight
        };
    }
}
```

## 获取元素的左和上偏移量

```js
function getElementLeft(element) {
    var actualLeft = element.offsetLeft;
    var current = element.offsetParent;

    while (current !== null) {
        actualLeft += current.offsetLeft;
        current = current.offsetParent;
    }

    return actualLeft;
}

function getElementTop(element) {
    var actualTop = element.offsetTop;
    var current = element.offsetParent;

    while (current !== null) {
        actualTop += current.offsetTop;
        current = current.offsetParent;
    }

    return actualTop;
}
```

## 确定元素大小

借助了 getElementLeft 与 getElementTop 方法

```js
function getBoundingClientRect(element) {

    var scrollTop = document.documentElement.scrollTop;
    var scrollLeft = document.documentElement.scrollLeft;

    if (element.getBoundingClientRect) {
        if (typeof arguments.callee.offset != "number") {
            var temp = document.createElement("div");
            temp.style.cssText = "position:absolute;left:0;top:0;";
            document.body.appendChild(temp);
            arguments.callee.offset = -temp.getBoundingClientRect().top - scrollTop;
            document.body.removeChild(temp);
            temp = null;
        }

        var rect = element.getBoundingClientRect();
        var offset = arguments.callee.offset;

        return {
            left: rect.left + offset,
            right: rect.right + offset,
            top: rect.top + offset,
            bottom: rect.bottom + offset

        };
    } else {

        var actualLeft = getElementLeft(element);
        var actualTop = getElementTop(element);

        return {
            left: actualLeft - scrollLeft,
            right: actualLeft + element.offsetWidth - scrollLeft,
            top: actualTop - scrollTop,
            bottom: actualTop + element.offsetHeight - scrollTop
        }
    }
}
```

