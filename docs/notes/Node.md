# Node

## 模块

+ url ：用于处理与解析 URL
+ querystring：提供用于解析和格式化 URL 查询字符串的实用工具
+ fs：赋予 node 处理读写文件等能力



## 启动一个 Node 服务

```js
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('hello world');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
```



## 请求不同的 url 返回不同的数据

```js
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  const { url } = req;
  if (url === '/') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain;charset=utf-8');
    res.end('/');
  } else if (url === '/favicon.ico') {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain;charset=utf-8');
    res.end('/favicon.ico');
  } else {
    res.statusCode = 200;
    res.setHeader('Content-Type', 'text/plain;charset=utf-8');
    res.end('其它地址');
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

```



## 返回 favicon.ico 文件

注意 Content-Type 为 image/jpg

该例同样适用返回任何图片

```js
const http = require('http');
const fs = require('fs');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  const { url } = req;
  if (url === '/favicon.ico') {
    fs.readFile('./favicon.ico', (err, data) => {
      if (!err) {
        res.writeHead(200, { 'Content-Type': 'image/jpg' });
        res.end(data);
      } else {
        throw err;
      }
    });
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

```



## 下载 favicon.ico 文件

注意 Content-Type 为 images/jpg，该设置会有一些奇怪的行为，暂不研究。

```js
const http = require('http');
const fs = require('fs');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  const { url } = req;
  if (url === '/favicon.ico') {
    fs.readFile('./favicon.ico', (err, data) => {
      if (!err) {
        res.writeHead(200, { 'Content-Type': 'images/jpg' });
        res.end(data);
      } else {
        throw err;
      }
    });
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
```





 ## 请求 / 路径返回 index.html

```js
const http = require('http');
const fs = require('fs');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  const { url } = req;
  if (url === '/') {
    fs.readFile('./index.html', (err, data) => {
      if (!err) {
        res.writeHead(200, { 'Content-Type': 'text/html;charset=UTF-8' });
        // 该 data 是二进制数据
        res.end(data);
      } else {
        throw err;
      }
    });
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

```



## 返回 JSON 数据

```js
const http = require('http');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  const { url } = req;
  if (url === '/') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    const data = { name: 'yzn' };
    res.end(JSON.stringify(data));
  }
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

```





## 获取 url 中的参数

```js
const http = require('http');
const url = require('url');
const querystring = require('querystring');

const hostname = '127.0.0.1';
const port = 3000;

const server = http.createServer((req, res) => {
  // 利用 url 和 querystring 模块解析 url
  const arg = url.parse(req.url).query;
  const params = querystring.parse(arg);
  console.log(params);
  
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
  res.end('hello world');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});

```

