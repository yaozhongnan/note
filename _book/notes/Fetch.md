# Fetch

## 参考资料

+ https://developer.mozilla.org/zh-CN/docs/Web/API/WindowOrWorkerGlobalScope/fetch
+ https://developer.mozilla.org/zh-CN/docs/Web/API/Fetch_API/Using_Fetch
+ [Fetch API 初探] http://coderlt.coding.me/2016/11/20/JS-Feach/

## fetch()

```js
fetch(url,{ // url: 请求地址
  method: "GET", // 请求的方法POST/GET等
  headers : { // 请求头（可以是Headers对象，也可是JSON对象）
      'Content-Type': 'application/json',
      'Accept': 'application/json'
  }, 
  body: , // 请求发送的数据 blob、BufferSource、FormData、URLSearchParams（get或head方法中不能包含body）
  cache : 'default', // 是否缓存这个请求
  credentials : 'same-origin', //要不要携带 cookie 默认不携带 omit、same-origin 或者 include
  mode : "", 
  /*  
      mode,给请求定义一个模式确保请求有效
      same-origin:只在请求同域中资源时成功，其他请求将被拒绝（同源策略）
      cors : 允许请求同域及返回CORS响应头的域中的资源，通常用作跨域请求来从第三方提供的API获取数据
      cors-with-forced-preflight:在发出实际请求前执行preflight检查
      no-cors : 目前不起作用（默认）

  */
}).then(resp => {
  /*
      Response 实现了 Body, 可以使用 Body 的 属性和方法:

      resp.type // 包含Response的类型 (例如, basic, cors).

      resp.url // 包含Response的URL.

      resp.status // 状态码

      resp.ok // 表示 Response 的成功还是失败

      resp.headers // 包含此Response所关联的 Headers 对象 可以使用

      resp.clone() // 创建一个Response对象的克隆

      resp.arrayBuffer() // 返回一个被解析为 ArrayBuffer 格式的promise对象

      resp.blob() // 返回一个被解析为 Blob 格式的promise对象

      resp.formData() // 返回一个被解析为 FormData 格式的promise对象

      resp.json() // 返回一个被解析为 Json 格式的promise对象

      resp.text() // 返回一个被解析为 Text 格式的promise对象
  */ 
  if(resp.status === 200) return resp.json(); 
  // 注： 这里的 resp.json() 返回值不是 js对象，通过 then 后才会得到 js 对象
  throw New Error ('false of json');
}).then(json => {
  console.log(json);
}).catch(error => {
  consolr.log(error);
})
```



## 获取数据

我们使用 github 为开发者提供的 url，我们可以像这样获取数据

```js
fetch('https://api.github.com/users/chriscoyier/repos');
```

Fetch会返回Promise，所以在获取资源后，可以使用`.then`方法做你想做的。

```js
fetch('https://api.github.com/users/chriscoyier/repos')
  .then(response => {/* do something */})
```

然而打印这个 response，会得到以下信息

```json
{
  // 一个简单的getter用于暴露一个 ReadableStream 类型的 body 内容。
  body: ReadableStream,
  // 包含了一个布尔值来标示该 Response 是否读取过 Body.
  bodyUsed: false,
  // 包含此 Response 所关联的 Headers 对象.
  headers: Headers,	
  // 包含了一个布尔值来标示该 Response 成功（状态码的范围在200-299）
  ok : true,
  redirected : false,
  // 包含 Response 的状态码 （例如 200 表示成功）
  status : 200,		
  // 包含了与该 Response 状态码一致的状态信息 (例如, OK对应 200).
  statusText : "OK",
  // 包含 Response 的类型 (例如, basic, cors).
  type : "cors",
  // 包含 Response 的 URL.
  url : "http://some-website.com/some-url",
  __proto__ : Response
}
```

知识点：

+ 我们想要的 json 信息都存储在 body 中，作为一种可读的流，需要一个[恰当方法](https://link.juejin.im/?target=https%3A%2F%2Fdeveloper.mozilla.org%2Fen-US%2Fdocs%2FWeb%2FAPI%2FResponse)将可读流转换为可用数据
+ Github返回的响应是JSON格式的，所以调用`response.json`方法来转换数据
+ 还有其他方法来处理不同类型的响应。如果请求一个XML格式文件，则调用`response.text`。如果请求图片，使用`response.blob`方法。

```js
fetch('https://api.github.com/users/chriscoyier/repos')
  .then(response => response.json())
  .then(data => {
    // data就是我们请求的 json 数据
    console.log(data)
  });
```





