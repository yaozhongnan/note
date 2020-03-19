/*
 Navicat MongoDB Data Transfer

 Source Server         : localhost
 Source Server Type    : MongoDB
 Source Server Version : 40000
 Source Host           : localhost:27017
 Source Schema         : wd_app

 Target Server Type    : MongoDB
 Target Server Version : 40000
 File Encoding         : 65001

 Date: 19/03/2020 15:24:42
*/


// ----------------------------
// Collection structure for annos
// ----------------------------
db.getCollection("annos").drop();
db.createCollection("annos");

// ----------------------------
// Documents of annos
// ----------------------------
db.getCollection("annos").insert([ {
    _id: ObjectId("5e16cc41cdddfd1038545a30"),
    author: "mh.",
    "watch_num": NumberInt("0"),
    "anno_id": NumberInt("2"),
    title: "这是一个公告标题，点击查看详情",
    content: "这是公告内容",
    "create_time": "2020-01-09 14:46:25",
    __v: NumberInt("0")
} ]);

// ----------------------------
// Collection structure for categories
// ----------------------------
db.getCollection("categories").drop();
db.createCollection("categories");

// ----------------------------
// Documents of categories
// ----------------------------
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa1"),
    "cate_id": NumberInt("1"),
    "cate_name": "前端",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa2"),
    "cate_id": NumberInt("2"),
    "cate_name": "后端",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa3"),
    "cate_id": NumberInt("3"),
    "cate_name": "大数据",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa4"),
    "cate_id": NumberInt("4"),
    "cate_name": "人工智能",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa5"),
    "cate_id": NumberInt("5"),
    "cate_name": "安卓",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);
db.getCollection("categories").insert([ {
    _id: ObjectId("5e16cb89cd42da39f466cfa6"),
    "cate_id": NumberInt("6"),
    "cate_name": "IOS",
    "create_time": "2020-01-09 14:43:21",
    __v: NumberInt("0")
} ]);

// ----------------------------
// Collection structure for ids
// ----------------------------
db.getCollection("ids").drop();
db.createCollection("ids");

// ----------------------------
// Documents of ids
// ----------------------------
db.getCollection("ids").insert([ {
    _id: ObjectId("5e16c2249fb35839c81bf6bf"),
    "user_id": NumberInt("0"),
    "cate_id": NumberInt("6"),
    "question_id": NumberInt("0"),
    "answer_id": NumberInt("0"),
    "anno_id": NumberInt("2"),
    "token_id": NumberInt("0"),
    "slide_id": NumberInt("3"),
    __v: NumberInt("0")
} ]);

// ----------------------------
// Collection structure for slides
// ----------------------------
db.getCollection("slides").drop();
db.createCollection("slides");

// ----------------------------
// Documents of slides
// ----------------------------
db.getCollection("slides").insert([ {
    _id: ObjectId("5e16cd45fea31038144d84ef"),
    sort: NumberInt("0"),
    "slide_id": NumberInt("2"),
    src: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578562634764&di=8a04d489658509346756d0f8fa682d3f&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%3D580%2Fsign%3D0b94d79575d98d1076d40c39113eb807%2Fcfd11739b6003af31fce9d093c2ac65c1038b662.jpg",
    "create_time": "2020-01-09 14:50:45",
    __v: NumberInt("0")
} ]);
db.getCollection("slides").insert([ {
    _id: ObjectId("5e16cd46fea31038144d84f0"),
    sort: NumberInt("0"),
    "slide_id": NumberInt("3"),
    src: "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1578562662282&di=ee1a05f76eec718b33c5c8287c9eb38b&imgtype=0&src=http%3A%2F%2Ff.hiphotos.baidu.com%2Fzhidao%2Fwh%253D450%252C600%2Fsign%3Df46c5789a344ad342eea8f83e59220c2%2F0bd162d9f2d3572c749069b88813632762d0c360.jpg",
    "create_time": "2020-01-09 14:50:46",
    __v: NumberInt("0")
} ]);

// ----------------------------
// Collection structure for users
// ----------------------------
db.getCollection("users").drop();
db.createCollection("users");
db.getCollection("users").createIndex({
    "user_id": NumberInt("1")
}, {
    name: "user_id_1",
    background: true,
    unique: true
});
db.getCollection("users").createIndex({
    nickname: NumberInt("1")
}, {
    name: "nickname_1",
    background: true,
    unique: true
});
