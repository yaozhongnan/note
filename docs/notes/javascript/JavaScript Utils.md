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

## 获取元素的宽高

```js
// 参数一：要获取的元素 Dom
// 参数二：布尔值，是否要加上边框
function getElementSize(element, border) {
    return {
        width: border ? element.offsetWidth : element.clientWidth,
        height: border ? element.offsetHeight : element.clientHeight
    }
}
```



## 正则

```js
手机号
/^1((3[\d])|(4[5,6,9])|(5[0-3,5-9])|(6[5-7])|(7[0-8])|(8[1-3,5-8])|(9[1,8,9]))\d{8}$/

大写字母
/^[A-Z]+$/

日期,如: 2000-01-01
/^\d{4}(-)\d{1,2}\1\d{1,2}$/

email地址
/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/

国内座机电话,如: 0341-86091234
/\d{3}-\d{8}|\d{4}-\d{7}/

身份证号(15位、18位数字)，最后一位是校验位，可能为数字或字符X
/(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/

帐号是否合法(字母开头，允许5-16字节，允许字母数字下划线组合
/^[a-zA-Z][a-zA-Z0-9_]{4,15}$/

只包含中文
/^[\u4E00-\u9FA5]/

是否小数
/^\d+\.\d+$/

是否电话格式(手机和座机)
/^((0\d{2,3}-\d{7,8})|(1[345789]\d{9}))$/

是否8位纯数字
/^[0-9]{8}$/

是否html标签
/<(.*)>.*<\/\1>|<(.*) \/>/

是否qq号格式正确
/^[1-9]*[1-9][0-9]*$/

是否由数字和字母组成
/^[A-Za-z0-9]+$/

是否小写字母组成
/^[a-z]+$/

密码强度正则，最少6位，包括至少1个大写字母，1个小写字母，1个数字，1个特殊字符
/^.*(?=.{6,})(?=.*\d)(?=.*[A-Z])(?=.*[a-z])(?=.*[!@#$%^&*? ]).*$/

用户名正则，4到16位（字母，数字，下划线，减号）
/^[a-zA-Z0-9_-]{4,16}$/

ipv4地址正则
/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/

16进制颜色
/^#?([a-fA-F0-9]{6}|[a-fA-F0-9]{3})$/

微信号，6至20位，以字母开头，字母，数字，减号，下划线
/^[a-zA-Z]([-_a-zA-Z0-9]{5,19})+$/

中国邮政编码
/^(0[1-7]|1[0-356]|2[0-7]|3[0-6]|4[0-7]|5[1-7]|6[1-7]|7[0-5]|8[013-6])\d{4}$/

只包含中文和数字
/^(([\u4E00-\u9FA5])|(\d))+$/

非字母
/[^A-Za-z]/
```

