# webpack 基本使用（一）



## 什么是 webpack

webpack 主要功能就是分析你的项目结构，找到 JavaScript 模块以及其它的一些浏览器不能直接运行的拓展语言（Scss，TypeScript等），并将其打包为合适的格式以供浏览器使用。

可以做的事情：

> 代码转换、文件优化、代码分割、模块合并、自动刷新、代码校验、自动发布



## npx 是什么

webpack4.0+ 以上推存 0 配置，而且 webpack 也一直朝着这个方向发展。webpack4.0+ 添加了一个 webpack-cli；

npx 是一个执行 npm 软件包的二进制文件，通俗的讲，他可以执行 npm 的一些指令，比如 npx webpack 他会执行 node_modules 下面的 bin 下的 webpack.cmd 文件，如果没有安装 webpack 的话，它会自动安装。但是 node 版本不低于 8.6， npm 版本不低于 5.2。

npx 可以通过 npm 下载。 webpack 所说的 0 配置就是与他相关。当然 npx 还有很多功能，你可以移驾到 npm 官网上查看 npx。

webpack 支持 0 配置，默认以 src 目录下的 index.js 做为入口文件。



## 运行 webpack

运行 webpack 只需要在项目目录下的命令行里敲入 webpack 命令就可以打包，但是该用法需要你全局安装 webpack 才能使用 webpack 命令。

如果不想全局安装 webpack 的话，也可以使用 npx webpack 运行。



## 执行 npx webpack

执行 npx webpack 会执行 node_modules/bin/webpack.cmd 文件。

文件内容如下：进行了一个判断，判断当前目录下是否有 node.exe

```shell
@IF EXIST "%~dp0\node.exe" (
  "%~dp0\node.exe"  "%~dp0\..\webpack\bin\webpack.js" %*
) ELSE (
  @SETLOCAL
  @SET PATHEXT=%PATHEXT:;.JS;=;%
  node  "%~dp0\..\webpack\bin\webpack.js" %*
)
```



## webpack 的配置

webpack 是 node 写出来的，所以采用 node 的写法，导出一个对象

webpack 的配置文件名称可以是 webpack.config.js 或者 webpackfile.js，这点可以通过 node_modules/webpack-cli/bin/config/config-yargs.js 文件中看出。

新建一个 webpack.config.js 文件到项目根目录下，内容如下：

```js
const path = require('path');

module.exports = {
  // 打包模式，development 代表开发模式，production 代表生产模式
  mode: 'development',

  // 指向入口文件的路径
  entry: './src/index.js',
  
  // 输出的配置对象
  output: {
    // 打包后的文件名
    filename: 'bundle.js',	// 添加 hash 写法 bundle.[hash:8].js
    // path 的值必须为一个绝对路径，这里使用 path 模块
    // path.resolve() 方法可以将当前路径解析为绝对路径，__dirname 指当前路径
    path: path.resolve(__dirname, 'dist'),
    // 指定所有资源的静态路径
    publicPath: 'http://xxxx'
  }
}
```



## 打包输出的文件分析

打包出来的 bundle.js 是一个自调用函数，传入了一个对象，对象的 key 是模块文件路径，value 就是一个函数。这个对象就是 modules 实参。

```js
// bundle.js

(function(modules){})({
    './src/index.js': (function() {})
});
```

接下来看看函数内部是怎么样的

```js
function(modules) {
    // 定义了一个对象，保存以及加载过的模块，加载过的就无需第二次加载了
    var installedModules = {};
    
    // 实现了一个 require 方法
    function __webpack_require__(moduleId) {}
    
    // 返回了 require 函数调用，传入了入口文件的路径
    return __webpack_require__(__webpack_require__.s = "./src/index.js");
}

// 总结：该函数内部核心就是实现了一个 require 方法，然后执行了入口文件对应的方法
```



## webpack-dev-server

webpack-dev-server 可以帮我们启动一个服务，使用方式非常简单，首先安装它

```shell
npm i webpack-dev-server -D
```

安装完成后执行通过下面的命令运行

```shell
npx webpack-dev-server
```

运行后可以发现就就启动了一服务，这个服务的地址是 http://localhost:8080，访问该地址可以看到项目的目录结构。打开 src 目录就默认打开了 Index.html 文件。

**配置 webpack-dev-server**

```js
module.exports = {
    // 开发服务器的配置
    devServer: {
        // 配置端口号
    	port: 3000,
        // 是否展示进度条
        progress: true,
        // 指定静态服务的目录
        contentBase: './src',
        // 是否开启 gzip 压缩
        compress: true
    }
}
```



## html-webpack-plugin 插件

该插件可以帮助我们生成一个 html 文件并自动放到 dist 目录当中，且自动帮我们引用打包后的 bundle.js，非常方便，只需要在我们自己的 src 目录下建一个 html 模板即可。

安装

```shell
npm i html-webpack-plugin -D
```

使用

```js
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    // 配置 plugins 属性，该属性是一个数组，包含所以需要配置的插件
    plugins: [
        // 创建一个 HtmlWebpackPlugin 实例，并传入配置参数
        new HtmlWebpackPlugin({
            // 指定模板路径
            templete: './src/index.html'，
            // 打包后的文件名称
            filename: 'index.html'，
            // 添加 hash
            hash: true
        })，
    ]
};
```



## loader

loader是打包方案，webpack 不能识别非 js 结尾的模块，告知 webpack 某些特定文件如何打包。 

loader 的特点，功能单一，这样多个 loader 就可以结合使用了。

loader 的用法：

+ 字符串形式：只能配置一个 loader
+ 数组形式：可以配置多个 loader
+ 数组对象形式：[{}, {}]

loader 的执行顺序：默认从右向左，从下到上



## 打包 css，less 模块

打包 css 模块需要两个 loader，css-loader 和 style-loader，前者帮助我们解析 css 中的 @import 这种语法，后者帮助我们把 css 插入到 head 标签中。

安装

```shell
npm i css-loader style-loader -D
```

配置

```js
module.exports = {
    // 配置模块参数
    module: {
        // 配置模块对应的规则，它是一个数组，代表可以配置很多规则
        rules: [
            // 配置一个解析 css 模块的规则
            { test: /\.css$/, use: ['style-loader', 'css-loader'] }
        ]
    }
};
```

若要打包 less 模块，只需要多安装 less 和 less-loader，然后在规则中添加一条 Less 的规则

```js
rules: [
    // 配置一个解析 less 模块的规则
    { test: /\.less$/, use: ['style-loader', 'css-loader', 'less-loader'] }
]
```



## mini-css-extract-plugin 插件

打包过后的 css 样式默认是插入到 html 文件的 style 标签内的，如果样式很多的话，这个 style 标签中的内容就会很长。这时候我们可以借助一个插件，帮助我们把样式抽离出来，使用 Link 的方式使用。

安装

```shell
npm i mini-css-extract-plugin -D
```

配置

```js
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    plugins: [
        new MiniCssExtractPlugin({
            // 设置抽离出来的样式名字
            filename: 'main.css'	
        })，
    ]
};
```

当我们配置了该插件之后呢，还需要配置该插件的 loader 来替代掉 style-loader

```js
rules: [
    // 配置一个解析 css 模块的规则
    { test: /\.css$/, use: [MiniCssExtractPlugin.loader, 'css-loader'] }，
    // 配置一个解析 less 模块的规则
    { test: /\.less$/, use: [MiniCssExtractPlugin.loader, 'css-loader', 'less-loader'] }
]
```



## 为样式添加前缀

比如我们写了一个 transform 属性的样式，我们想让打包后的 css 自动我们添加 webkit 前缀，那么就需要借助一个 autoprefixer 包，但是用这个包又需要借助一个 Loader 来帮我们添加上前缀，就是 postcss-loader

安装

```shell
npm i postcss-loader autoprefixer -D
```

 配置 loader，这个前缀我们需要加在 css-loader 之前

```js
rules: [
    // 配置一个解析 css 模块的规则
    { test: /\.css$/, use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader'] }，
    // 配置一个解析 less 模块的规则
    { test: /\.less$/, use: [MiniCssExtractPlugin.loader, 'css-loader', 'postcss-loader', 'less-loader'] }
]
```

配置完 Loader 之后还需要添加一个 postcss 的配置文件，告诉它使用 autoprefixer 这个包来添加前缀。

在项目根目录下创建一个 postcss.config.js 文件

```js
// postcss.config.js

module.exports = {
    plugins: [
        require('autoprefixer')
    ]
}
```



## 压缩打包后的 css 文件

以上步骤打包出来的 css 文件是未经压缩的 css 文件，要想压缩 css 文件需要借助 optimize-css-assets-webpack-plugin 插件

安装

```shell
npm i optimize-css-assets-webpack-plugin -D
```

配置

```js
const OptimizeCss = require('optimize-css-assets-webpack-plugin');

module.exports = {
    // 优化项
    optimization: {
        minimizer: [
            new OptimizeCss()
        ]
    }
}
```

配置过后 css 文件就可以被正常压缩了，但这时注意 js 文件不能压缩了，即使你的 mode 是 production

在使用这个压缩 css 的插件时，必须还要使用 uglifyjs-webpack-plugin 插件来让我们的 js 文件依旧压缩

安装

```shell
npm i uglifyjs-webpack-plugin -D
```

配置

```js
const UglifyjsPlugin = require('uglifyjs-webpack-plugin');
const OptimizeCss = require('optimize-css-assets-webpack-plugin');

module.exports = {
    // 优化项
    optimization: {
        minimizer: [
            new UglifyjsPlugin({
                // 是否缓存
                cache: true,
                // 是否并发打包
                parallel: 4,
                // 源码映射，方便调试
                sourceMap: true
            }),
            new OptimizeCss()
        ]
    }
}
```

这时候 js 文件又重新的被压缩了



## 转化 ES6 语法

在我们书写 js 的时候，可能会用到许多 ES6 语法，然而 webpack 处理 ES6 代码还是会原封不动的返回，所以我们需要借助 babel 将我们的 ES6 语法转换为 ES5

安装

```shell
npm i babel-loader @babel/core @babel/preset-env -D
```

配置

```js
module.exports = {
    module: {
        rules: [
            { test: /\.js$/, use: {
                loader: 'babel-loader',
                options: {
                    presets: [
                        '@babel/preset-env'
                    ]
                }
            } }
        ]
    }
}
```



## 转化 ES6 class 语法

babel 默认不认识 class 语法，需要借助插件

安装

```shell
npm i @babel/plugin-proposal-class-properties -D
```

配置

```js
module.exports = {
    module: {
        rules: [
            { test: /\.js$/, use: {
                loader: 'babel-loader',
                options: {
                    presets: [
                        '@babel/preset-env'
                    ],
                    plugins: [
                        '@babel/plugin-proposal-class-properties'
                    ]
                }
            } }
        ]
    }
}
```



## 转化 class decorator

babel 默认也不认识 class decorator 语法，也需要借助插件

安装

```shell
npm i @babel/plugin-proposal-decorators -D
```

配置

```js
module.exports = {
    module: {
        rules: [
            { test: /\.js$/, use: {
                loader: 'babel-loader',
                options: {
                    presets: [
                        '@babel/preset-env'
                    ],
                    plugins: [
                        ['@babel/plugin-proposal-decorators', {'legacy': true}],
                        ['@babel/plugin-proposal-class-properties', {'loose': true}],
                    ]
                }
            } }
        ]
    }
}
```



## 转化 generator

babel 也不认识 generator，需要借助一个运行时的插件

安装

``` shell
npm i @babel/plugin-transform-runtime -D
```

```shell
npm i @babel/runtime -S
```

配置

```js
module.exports = {
    module: {
        rules: [
            { test: /\.js$/, use: {
                loader: 'babel-loader',
                options: {
                    presets: [
                        '@babel/preset-env'
                    ],
                    plugins: [
                        ['@babel/plugin-proposal-decorators', {'legacy': true}],
                        ['@babel/plugin-proposal-class-properties', {'loose': true}],
                        '@babel/plugin-transform-runtime'
                    ]
                }
            } }
        ]
    }
}
```

这时候执行打包可能会出现警告，这是因为我们匹配了所以的 Js 文件，更改以下配置

```js
module.exports = {
    module: {
        rules: [
            { 
                test: /\.js$/, 
                use: {
                	loader: 'babel-loader',
                	options: {
                        presets: [
                            '@babel/preset-env'
                        ],
                        plugins: [
                            ['@babel/plugin-proposal-decorators', {'legacy': true}],
                            ['@babel/plugin-proposal-class-properties', {'loose': true}],
                            '@babel/plugin-transform-runtime'
                        ]
                	}
            	},
                include: path.resolve(__dirname, 'src'),
                exclude: /node_modules/
            }
        ]
    }
}
```



## 转化 ES7 实例方法

安装

```shell
npm i @babel/polyfill -S
```

在使用到 ES7 实例方法的文件中使用

```js
require('@babel/polyfill')
```



## 使用 Eslint 进行代码校验

安装

```shell
npm i eslint eslint-loader -D
```

配置 loader

```js
rules: [
    {
        test: /\.js$/,
        use: {
            loader: 'eslint-loader',
            options: {
                // 设置该规则在普通 loader 之前执行
        		enforce: 'pre'
            }
        }
    }
]
```

配置完成后，可以去 eslint 官网下载一份根据自己需求定制的配置文件 .eslintrc.json，放到根目录



## 图片处理

项目中图片的使用有三种方式

+ 在 js 中创建图片来引入
+ 在 css 中引入 background: url()
+ img 标签

要让 webpack 可以打包图片则需要 file-loader，它默认会在内部生成一张图片到 dist 目录，并返回图片路径

安装

```shell
npm i file-loader -D
```

配置

```js
rules: [
    {
        test: /\.(png|jpg|gif|jpeg)$/,
        use: 'file-loader'
    }
]
```

配置完成后在 js 中创建图片可以直接 Import 图片，在 css 中使用直接可以通过相对路径使用，因为 css-loader 帮我们把相对路径更改成了 require 的方式。

但是在 html 文件中通过 img 标签的形式，在 src 中写相对路径时并不生效

这时我们需要借助另一个插件 html-withimg-loader

安装

```shell
npm i html-withimg-loader -D
```

配置

```js
rules: [
    {
        test: /\.html$/,
        use: 'html-withimg-loader'
    }
]
```

有时我们的图片很小可能只有几 k 的时候，我们可能希望让它不发送请求转换成 base64，利用 url-loader

安装

```shell
npm i url-loader -D
```

配置

```js
rules: [
    {
        test: /\.(png|jpg|gif|jpeg)$/,
        use: {
            loader: 'url-loader',
            options: {
                // 限制图片大小界限为 20k，小于该值会转换为 base64
                limit: 20*1024,
                // 将生成的图片放到 img 路径下
                outputPath: 'img/',
                // 为每张图片路径添加公共 path
                publicPath: 'http://xxx'
            }
        }
    }
]
```





