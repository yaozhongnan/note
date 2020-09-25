# Mysql

Windows 安装：https://www.cnblogs.com/laumians-notes/p/9069498.html
Ubuntu 安装：https://blog.csdn.net/weixx3/article/details/94133847

一些设置：

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';

CREATE USER 'xxh'@'%' IDENTIFIED WITH mysql_native_password BY 'xxh123!@#';

flush privileges;


## 版本

>  mysql  Ver 8.0.18 for Win64 on x86_64 (MySQL Community Server - GPL)



## 基本命令

连接数据库

```bash
mysql -u root -p
```



连接远程主机

```bash
mysql -h 192.168.206.100 -u root -p
```



创建数据库

```bash
create database db_name;
```



显示所有的数据库

```bash
show databases;
```



删除数据库

```bash
drop database db_name;
```



选择数据库

```bash
use db_name;
```



创建表

```bash
create table tb_name (字段名 varchar(20), 字段名 char(1));

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'primary key',
  `name` varchar(30) DEFAULT NULL COMMENT 'user name',
  `age` int(11) DEFAULT NULL COMMENT 'user age',
  `created_at` datetime DEFAULT NULL COMMENT 'created time',
  `updated_at` datetime DEFAULT NULL COMMENT 'updated time',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='user';
```



显示所有表

```bash
show tables;
```



删除表

```bash
drop table tb_name； 
```

