# webpack 基本使用（二）



## 打包多页应用

直接上代码

```js
// webpack.config.js

const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
    mode: 'development',
    // 多页应用对应多入口
    entry: {
        home: './src/home.js',
        other: './src/other.js'
    },
    output: {
        // 这里的 name 就是 home 和 other
        // 这样就会输出 home.js 和 other.js
        filename: '[name].js',
        path: path.resolve(__dirname, 'dist')
    },
    plugins: [
        // 多页也对应需要 new 多个 HtmlWebpackPlugin 实例
        new HtmlWebpackPlugin({
            // 各自的模板
            templete: './home.html',
            // 各自输出的名称
            filename: 'home.html',
            // 指定需要引入的 js 文件
            chunk: ['home']
        }),
        new HtmlWebpackPlugin({
            templete: './other.html',
            filename: 'other.html',
            chunk: ['other']
        }),
    ]
}
```



## 配置 source-map

source-map 可以帮我们做源码映射，方便我们调试

配置

```js
module.exports = {
    devtool: 'source-map'
}
```

devtool 属性的值有好几种，不过多记录了。



## watch 实时监控

每当我们更改一次代码的时候，都需要重新的去 build 打包，当然你可以用 webpack-dev-server，但是我们也可以让 webpack 进行实时编译

配置

```js
module.exports = {
    // 开启实时监控
    watch: true,
    // watch 的配置对象
    watchOptions: {
        // 每秒询问 1000 次是否需要重新打包
        poll: 1000,
        // 防抖，防止每一个输入都会重新打包，设置间隔时间
        aggregateTimeout: 500,
        // 不需要监控的文件夹
        ignoned: /node_modules/
    }
}
```



## cleanWebpackPlugin 插件

该插件可以帮助我们每次打包的时候删除旧的 dist 目录。

安装

```shell
npm i clean-webpack-plugin -D
```

配置

```js
const CleanWebpackPlugin = require('clean-webpack-plugin');

module.exports = {
    plugins: [
        // 传入要删除的目录路径
        new CleanWebpackPlugin('./dist'),
    ]
}
```



## copyWebpackPlugin 插件

有时我们想让一些目录直接拷贝进 dist 目录中，例如说明文档目录中的文件，不需要打包只需要拷贝

安装

```shell
npm i copy-webpack-plugin -D
```

配置

```js
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    plugins: [
        // 传入一个对象数组
        new CopyWebpackPlugin([
            // 意为将 doc 目录中的文件拷贝到 dist 目录中
            { from: 'doc', to: './' }
        ]),
    ]
}
```



## bannerPlugin 内置插件

有时我们想让打包后的代码首行生成一段版权注释，使用该 webpack 内置插件

配置

```js
const webpack = require('webpack');

module.exports = {
    plugins: [
        // 传入一个对象数组
        new webpack.BannerPlugin('make 2019 by xxx'),
    ]
}
```



## 跨域配置

开发过程中经常会遇到跨域问题，那么前端如何解决跨域呢，就是配置代理

配置方式一：

```js
module.exports = {
    devServer: {
        proxy: {
            // 以 api 开头的请求都去 3000 端口去找
            '/api': 'http://localhost:3000'
        }
    }
}
```

配置方式二：有时后端的接口可能并不是固定以 api 开头的

```js
module.exports = {
    devServer: {
        proxy: {
            '/api': {
                target: 'http://localhost:3000',
                // 重写 api 置为空
                reWrite: {
                    '/api': ''
                }
            }
        }
    }
}
```



## resolve 属性

resolve 属性用来解析第三方包

配置

```js
module.exports = {
    resolve: {
        // 告诉 webpack 找包去 node_modules 目录下找，当然也可以添加其它目录
        modules: [path.resolve('node_modules')],
        alias: {
            // 当使用 import 'bootstrap' 时，让它去找 bootstrap/dist/css/bootstrap.css 文件
            bootstrap: 'bootstrap/dist/css/bootstrap.css'
        }，
        // 引入文件时不写后缀的查找规则，先找 js 再找 css 再找 json
        entensions: ['.js', '.css', '.json']
    }
}
```



## 定义环境变量

配置

```js
const webpack = require('webpack');

module.exports = {
    plugins: [
        new webpack.DefinePlugin({
            // 定义之后，代码中就多了一个 DEV 变量，值为 dev
            DEV: JSON.striigy('dev')
        })
    ]
}
```



## 区分不同环境

将开发和生产环境的配置都写到一个文件内会比较难以维护，因此我们可以借助 webpack-merge 将他们分开

首先创建三个文件：webpack.base.js，webpack.dev.js，webpack.prod.js

在 webpack.base.js 文件中，书写开发和生产环境公共的配置

然后再 dev 和 prod 文件中书写各自环境的配置，然后通过插件合并

```js
const { smart } = require('webpack-merge');
const base = require('./webpack.base.js');

module.exports = smart(base, {
    mode: 'production'
})
```



## weback 优化

有时 webpack 的打包速度非常慢，例如当我们使用 jquery 包的时候，webpack 会去检查 jquery 有没有其它依赖项。我们知道 jquery 是没有其它依赖的，那么如何省去这个检查依赖的时间呢？

配置

```js
module.exports = {
    module: {
        noParse: /jquery/,
        rules: []
    }
}
```

还有这样一个场景，我们在使用 moment 这个包的时候，会发先使用它会让我们打包出来 js 文件体积非常大，是因此 moment 这个包就非常大，它里面引入了很多语言的包，因为它支持非常多的语言，那我们只想用中文怎么办？就需要使用 webpack 内置的一个 IgnorePlugin 插件

配置

```js
const webpack = require('webpack');

module.exports = {
    plugins: [
        // 传入的参数意思就是当加载 moment 这个包时，忽略掉引入的 locale 文件
        new webpack.IgnorePlugin(/\.\/locale/, /moment/)
    ]
}
```

配置了上面的选项之后，moment 默认就会使用英语作为主语言，那么要想使用中文就需要自己手动引入



## happypack

使用多线程打包，加快打包速度



## webpack 自带优化

当我们使用 es6 的 import 引入一个文件的时候，可能有一些方法我们是用不到的，那这时候 webpack 通过一种 tree shaking 的方式自动去除掉那些我们引入但没用到的代码在生产模式下。

但是通过 commonjs 的方式引入并没有该优化

webpack 还会自动省略一些可以省略的代码，例如：

```js
const a = 1;
const b = 2;
const c = a + b;

console.log(c)		
```

上面的代码 webpack 会通过 scope hosting 作用于提升的方式简化代码，去除不必要的声明，直接打印结果



## 抽离公共代码

在多页应用中，有很多可以复用的模块，就是那些在多个页面中都有用到的模块，比如页头。这样的公共模块我们可以进行抽取，抽取的好处就是可以被缓存，当一个页面加载过了，下个页面就可以不需要重新加载。

配置

```js
module.exports = {
    optimization: {
        // 分割代码块
        splitChunks: {
            // 缓存组
            cacheGroups: {
                common: {
                    // 从入口就开始判断
                    chunks: 'initial',
                    // 这个模块的大小需要大于 0k 
                    minSize: 0,
                    // 这个模块最少需要被引入 2 次
                    minChunks: 2
                },
                // 第三方模块也可以抽取
                vendor: {
                    // 设置抽取的权重
                    priority: 1,
                    // 指定包的位置
                    test: /node_modules/,
                    chunks: 'initial',
                    minSize: 0,
                    minChunks: 2
                }
            }
        }
    }
}
```



## 动态加载模块

有时我们有这样一个需求，当我点击某个按钮的时候，去引入一个 Js 文件，例如

```js
button.onclick = function () {
    // es6 草案中的语法，实质上使用的是 Jsonp 实现的
    import('./source.js').then(data => {
        console.log(data)
    })
}
```

该使用方法默认 webpack 是不支持的，需要借助 @babel/plugin-syntax-dynamic-import 插件

安装

```shell
npm i @babel/plugin-syntax-dynamic-import -D
```

配置

```js
module.exports = {
    module: {
        rules: [
            {
                test: /\.js$/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: ['@babel/preset-env'],
                        // 添加以下配置
                        plugins: ['@babel/plugin-syntax-dynamic-import']
                    }
                }
            }
        ]
    }
}
```

vue 懒加载和 react 懒加载都是这样实现的



## 热更新

使用 webpack-dev-server 时，当我们改动代码的时候浏览器会自动进行刷新，然而我们并不想让它刷新整个页面，我们只想局部刷新，也就是刷新我们改动代码的地方，那就需要使用热更新。

配置

```js
const webpack = require('webpack');

module.exports = {
    devServer: {
        // 设置热更新
        hot: true
    },
    plugins: [
        // 用来告诉是哪个模块更新了的插件
        new webpack.NamedModulesPlugin(),
        // 热更新的插件
        new webpack.HotModuleReplacementPlugin()
    ]
}
```

