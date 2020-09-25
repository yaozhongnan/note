# mongodb

## 启动数据库

可以使用以下命令检查是否安装成功

```shell
mongod --version
// 如果不可用  检查是否配置环境变量   目录为 mongodb 安装目录的 bin 目录下
```

启动：

```shell
# mongodb默认使用执行 mongod 命令所处盘符根目录下的 /data/db 作为自己的数据存储目录
mongod
# 所以第一次执行该命令之前先自己手动新建一个 /data/db
```

如果想要修改默认的数据存储目录，可以：

```shell
mongod -- dbpath=数据存储目录路径
```

停止：

```shell
在开启服务的控制台，直接 Ctrl+c 即可停止
```



## 连接数据库

连接：（连接数据库之前需保证数据库启动）

```shell
# mongo 命令默认连接本机的 MongoDB 服务
mongo
```

退出：

```shell
# 在连接状态输入 exit 退出链接
exit
```

## 基本命令

- `show dbs`
  - 查看显示所有数据库
- `db`
  - 查看当前操作的数据库
- `use 数据库名称`
  - 切换到指定的数据库（如果没有会新建）
- `show collections`
  - 展示当前数据库下的所有集合（表）

### 查询操作

- ``db.user.insert({'name': 'yzn', 'age': 20})``
  - 往 user 表中插入一条数据
- ``db.user.find()``
  - 查询 user 表中所有数据
- ``db.user.find({'age': 20, 'name': 'yzn'})``
  - 查询 user 表中 age = 20 name = yzn 的数据
- ``db.user.find({'age': { $gt: 20 }})``
  - 查询 uese 表中 age 大于 20 的数据
- ``db.user.find({'age': { $gte: 20 }})``
  - 查询 user 表中 age 大于等于 20 的数据
- db.user.find( {'age': { $gte: 20, $lte: 30 }} )
  - 查询 user 表中 age 大于等于 20 且 小于等于 30 的数据

**模糊查询**

+ db.user.find({"name": /张/})
  + 查询 user 表中 name 包含 张 的数据
+ db.user.find({"name": /^张/})
  + 查询 user 表中 name 以 张 开头数据

**列查询**

+ db.user.find( {}, {age, 1} )    // 第一个参数为空对象, age 可以不加引号，值为 1
  + 查询 user 表中 age 列的所有数据
+ db.user.find( {'age': { $gt: 20 }}, {name: 1} )
  + 查询 age大于 20 的所有数据的 name 列数据
+ db.user.find( {}, { age: 1, name: 1 } )
  + 查询 age 和 name 两列数据

**查询并排序**

+ db.user.find().sort( {'age': 1} )      // -1 为降序
  + 查询 user 表中的所有数据，并按照 age 升序排列

**查询前 n 条数据**

+ db.user.find().limit(5)
  + 查询 user 表中的前 5 条数据

**查询 n 条数据以后的 m 条数据**

+ db.user.find().skip(2).limit(3)
  + 查询 user 表中前 2 条后的 3 条数据

**or 查询** 

+ db.user.find( { $or: [ {"age": 20}, {"age": 24} ] } )
  + 查询 user 表中 age 等于 20 或 24 的数据

**查询第一条数据**

+ db.user.findOne()
  + 查询 user 表中的第一条数据
+ db.user.find().limit(1)
  + 查询 user 表中的第一条数据

**查询数量**

+ db.user.find().count()
  + 查询 user 表中所有数据的数量
+ db.user.find({ 'age': 20 }).count()
  + 查询 user 表中 age 等于 20 的数据的数量 

### 删除操作

+ db.user.remove({ 'age': 20 })
  + 删除 user 表中所有 age 为 20 的数据
+ db.user.remove({'age': 20}, {justOne: true})
  + 删除 user 表中 age 为 20 的第一条数据

**删除数据库**

+ db.dropDatabase()
  + 删除 数据库

**删除集合**

+ db.user.drop()
  + 删除 user 集合

### 修改操作

注：不写 $set 的话默认将一整条数据修改成第二个参数的数据

+ db.user.update( {'name': 'wangwu'}, {$set: { 'age': 60 }} )
  + 将 name 等于 wangwu 的数据的 age改为 60

## 索引

索引是对数据库表中一列或多列的值进行排序的一种结构，可以让我们查询数据库变得
更快。MongoDB 的索引几乎与传统的关系型数据库一模一样，这其中也包括一些基本的查
询优化技巧。 

**创建索引**

​	db.user.ensureIndex({"username":1})  

**获取当前集合的索引**

​	db.user.getIndexes() 

**删除索引**

​	db.user.dropIndex({"username":1})  

**创建复合索引**

​	数字1 表示username 键的索引按升序存储，-1 表示age 键的索引按照降序方式存储。

​	db.user.ensureIndex({"username":1, "age":-1}) 

**唯一索引 **

​	db.user.ensureIndex({"userid":1},{"unique":true})

​	如果再次插入userid 重复的文档时，MongoDB 将报错，以提示插入重复键





## 在 Node 中操作 MongoDB 数据库

使用官方的 `mongodb` 包来操作（比较原生）

> https://github.com/mongodb/node-mongodb-native

使用第三方 mongoose 来操作 MongoDB 数据库（推荐），它基于 mongodb 官网的 mongodb 包再一次做了封装

# mongoose	

- 官网：http://mongoosejs.com/
- 官方指南：http://mongoosejs.com/docs/guide.html
- 官方API文档：http://mongoosejs.com/docs/api.html

## 1. MongoDB 数据库的基本概念

- 数据库
- 集合（数据表）
- 文档（表结构）
- 可以有多个数据库
- 一个数据库中可以有多个集合（表）
- 一个集合中可以有多个文档（表记录）
- 文档结构很灵活，没有任何限制
- MongoDB 非常灵活，不需要像 MySQL 一样先创建数据库、表、设计表结构
  - 在这里只需要：当你需要插入数据的时候，只需要指定往哪个数据库哪个集合操作就可以了
  - 一切都是由 MongoDB来帮你自动完成建库建表这件事儿

```javascript
{
    // qq 和 taobao 是数据库，users 和 goods 是集合，[] 中的 {} 是文档
    qq:{
        users:[ {name: '张三', age: 15}，{} ],
        goods:[ {}，{} ],
    },
    taobao:{
            
    }
}

```



## 2. 起步

安装：

```shell
npm i mongoose -S     //在需要安装的文件目录下执行该命令
```

hello world：

```javascript
const mongoose = require('mongoose');
mongoose.connect('mongodb://localhost/test');

const Cat = mongoose.model('Cat', { name: String });

const kitty = new Cat({ name: 'Zildjian' });
kitty.save().then(() => console.log('meow'));
```

## 3. 官方指南

### 3.1 设计 Schema 发布 Model

```javascript
// 引入mongoose
const mongoose = require('mongoose');
// 对于Mongoose，一切都源自一个模式
const Schema = mongoose.Schema ;
// 1 - 链接数据库
// 指定的数据库不需要存在，当你插入第一条数据后就自动创建了
mongoose.connect('mongodb://localhost/test');
// 2 - 设计集合结构（表结构）
// 字段名称就是表结构中的属性名称
// 值：约束的目的是为了保证数据的完整性，不要有脏数据
var userSchema = new Schema({
  username:{
    type:String,
    required:true   // 非空
  },
  password:{
    type:String,
    required:true   
  },
  email:{
    type:String
  }
});
// 3 - 将文档结构发布为模型
// mongoose.model 方法就是用来将一个架构发布为 model
// 第一个参数：传入一个大写名词单数字符串用来表示你的数据库名称，
// mongoose会自动将大写的字符串生成小写复数的集合名称 例：User -> users
// 第二个参数：架构 Schema
// 返回值：模型构造函数
var User = mongoose.model('User',userSchema);

// 4 - 当我们有了模型构造函数之后，就可以使用这个构造函数对users集合中的数据为所欲为


```

### 3.2 增加数据

```javascript
// 增加数据
var admin = new User({
  username:'admin',
  password:'123456',
  email:'admin@admin.com'
});  
// 保存数据
admin.save(function(err,result){
  if(err){
    console.log('保存失败')
  }else{
    console.log('保存成功')
    console.log(result)   // result 就是插入的这条数据
  }
})
```

### 3.3 查询数据

```javascript
// 查询所有数据
User.find(function(err,result){
  if(err){
    console.log('查询失败')
  }else{
    console.log(result)   // result 为一个数组，数组内为查询结果
  }
})
// 按条件查询数据
// 传入第一个参数 - 对象  对象内为条件
User.find({
  username:'zs'
},function(err,result){
  if(err){
    console.log('查询失败')
  }else{
    console.log(result)   // result 为一个数组，数组内为查询结果
  }
})
// 按照条件查询单个数据
// 如果没有传入条件 findOne默认查询第一条数据
User.findOne({
  username:'zs',
  password:'123456'
},function(err,result){
  if(err){
    console.log('查询失败')
  }else{
    console.log(result)   // result 为当前的数据对象
  }
})
```

### 3.4 删除数据

根据条件删除所有：

```javascript
// 删除数据
// 此例表示删除所有 username 为 zs 的数据
User.remove({
  username:'zs'
},function(err,result){
  if(err){
    console.log('删除失败')
  }else{
    console.log('删除成功')
    console.log(result)   
  }
})
```

根据条件删除一个：

```javascript
Model.findOneAndRemove(conditions, [options], [callback])
```

根据 id 删除一个：

```javascript
Model.findByIdAndRemove(id, [options], [callback])
```

### 3.5 更新数据

根据 id 更新一个：

```javascript
// 更新数据
// 第一个参数为id的值，第二个参数为修改的内容
User.findByIdAndUpdate('5a001b235',{
  password:'111111'
},function(err,result){
  if(err){
    console.log('更新失败')
  }else{
    console.log('更新成功')
  }
})
```

根据条件更新所有：

```javascript
Model.update(conditions, doc, [options], [callback])
```

根据条件删除一个：

```javascript
Model.findOneAndUpdate([conditions], [update], [options], [callback])
```









































