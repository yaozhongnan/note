# Docker



## 安装

这里记录一下在低版本 windows 系统中的安装过程。



**步骤一：下载 docker toolbox**

下载地址：<https://get.daocloud.io/toolbox/>



**步骤二：安装**

在 select components 安装页面中，勾选需要的组件，由于我电脑装好了 Git 因此没有勾选 Git 组件。

正因为我没有勾选 Git，让我在安装完成后运行 Docker Quickstart Terminal 时遇到了第一个问题。



**步骤三：运行**

运行安装完成后桌面上的 Docker Quickstart Terminal 快捷方式。

出现第一个问题：windows 正在查找 bash.exe ？

解决：由于没有勾选 Git，所以它无法找到 Git 的 bash.exe 在哪，所以这时候需要手动指定该位置。右键 Docker Quickstart Terminal 选择属性，在目标处修改自己安装的 bash.exe 位置。

再次运行出现第二个问题：No default Boot2Docker ISO found locally, downloading the latest release ？

解决：由于启动时没有检测到 Boot2Docker，因此它会去下载，下载地址通常会显示在命令行当中。它其实是 github 上的 boot2docker 库。去 github 上手动下载下来并放在 c/user/username/.docker/machine/cache 下即可。下载速度很慢可以使用迅雷下载。

至此可以正常启动 Docker Quickstart Terminal



**步骤四：配置国内镜像源**

阿里云镜像：https://gctn5mcm.mirror.aliyuncs.com

如果已经创建了 Docker Machine 实例，可以这样配置：

```bash
# 第一步
docker-machine ssh default

# 第二步
sudo sed -i "s|EXTRA_ARGS='|EXTRA_ARGS='--registry-mirror=https://gctn5mcm.mirror.aliyuncs.com |g" /var/lib/boot2docker/profile

# 第三步
exit

# 第四步
docker-machine restart default
```

如果没有创建 Docker Machine 实例，可以这样配置：

```bash
# 创建一台安装有Docker环境的Linux虚拟机，指定机器名称为default，同时配置Docker加速器地址。
docker-machine create --engine-registry-mirror=加速地址 -d virtualbox default

# 查看机器的环境配置，并配置到本地，并通过Docker客户端访问Docker服务。
docker-machine env default
eval "$(docker-machine env default)"
docker info
```

docker info 命令可以用来查看一些信息，其中的 registry 就是加速地址。

## 在 ubuntu 18.04 中安装 Docker

参考：https://www.yuque.com/grasilife/docker/install-ubuntu

配置镜像加速器：https://www.yuque.com/grasilife/docker/install-mirror



## 常用命令

```shell
# 查看本地仓库的所有镜像
docker images
docker images -a

# 查看所有在运行的容器信息
docker ps

# 查看所有容器信息，包括未运行的
docker ps -a

# 创建并运行一个新的容器
docker run -p 8080:80 --name myNginx -d nginx

# 启动一个或多个已经被停止的容器
docker start 容器名/容器 ID 容器名/容器 ID

# 停止一个运行中的容器
docker stop 容器名/容器 ID

# 重启容器
docker restart 容器名/容器 ID

# 强制删除一个或多个容器
docker rm -f 容器名/容器 ID 容器名/容器 ID

# 从容器创建一个新的对象
docker commit -a '作者' -c(使用 DockerFile) -m 'commit 说明' -p(提交时暂停容器)
```



删除镜像（image）

```bash
docker rmi {仓库}:{标签名}

docker rmi {镜像 ID}
```



查看卷

```bash
docker volume ls
```



删除卷

```bash
docker volume rm {卷名}
```





## Docker 安装 Tomcat



**<u>安装启动</u>**

```bash
# 步骤一：拉取 tomcat 镜像
docker pull tomcat

# 步骤二：启动该 tomcat 镜像
docker run -d -p 8080:8080 镜像ID

# 步骤三：打开浏览器访问 localhost:8080

# 问题：在我打开 localhost:8080 时看到 404 页面，并没有看到 tomcat 启动成功的页面
# 原因：在启动的 tomcat 容器中，webapps 下没有 ROOT 文件夹
# 解决：利用 docker exec -it 容器ID /bin/bash 进入容器，并在 webapps 下新建 ROOT 目录
```



**<u>挂载数据卷</u>**

```bash
# 将宿主机下的 /home/yzn/test/webapps 目录映射到容器内的 /usr/local/tomcat/webapps 目录
# 这样的好处是每次修改宿主机下的文件即可自动映射到容器内部，且不需要重新启动容器。
docker run -d -p 8080:8080 -v /home/yzn/test/webapps:/usr/local/tomcat/webapps 镜像ID
```



## Docker 安装 Nginx



```bash
# 步骤一：拉取镜像
docker pull nginx

# 步骤二：启动该镜像
docker run -d -p 8080:80 镜像ID

# 步骤三：打开浏览器访问 localhost:8080
```



**<u>挂载数据卷</u>**

```bash
# /usr/share/nginx/html/index.html 默认的启动页面
# /etc/nginx/nginx.conf 配置文件位置
# /var/log/nginx 日志文件位置

# 例：挂载宿主机 index.html 到容器内并启动
docker run -d -p 8080:8080 -v /home/yzn/test/nginx/index.html:/usr/share/nginx/html/index.html 镜像ID
```



## Docker 安装 Mysql



```bash
# 步骤一：拉取镜像
docker pull mysql

# 步骤二：启动该镜像，-e MYSQL_ROOT_PASSWORD=123456 为设置环境变量，这里是设置登陆 mysql 的密码，不设置将无法启动成功
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 镜像ID

# 步骤三：进入容器内部
docker exec -it 容器ID bash

# 步骤四：在容器内登陆 mysql
mysql -u root -p

# 步骤五：查看用户信息
# host 字段代表可以访问当前用户的主机地址，其中 localhost 仅本地能访问。设为 % 则全部都能访问。
# plugin 字段表示设置加密的插件。mysql 8 之前的版本均使用 mysql_native_password 插件，8 之后统一改成了 caching_sha2_password 插件，插件的差异会影响 navicat 连接报错
# 备注：host为 % 表示不限制ip  localhost表示本机使用    plugin 非 mysql_native_password 则需要修改密码
select host,user,plugin,authentication_string from mysql.user;

# 步骤六：设置用户。这里设置 root 用户不限制 IP，且插件改为 mysql_native_password，并重新设置了密码。
ALTER user 'root'@'%' IDENTIFIED WITH mysql_native_password BY '123456';

# 步骤七：刷新。之后便可以在本地使用 navicat 连接 docker 容器内的 mysql 了
FLUSH PRIVILEGES;
```

安装文件位置

```bash
# 配置文件
/etc/mysql/my.cnf

# 数据库文件存放的地方
/var/lib/mysql

# 日志
/var/log/mysql
```

配置文件样例

```bash
# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA

#
# The MySQL  Server configuration file.
#
# For explanations see
# http://dev.mysql.com/doc/mysql/en/server-system-variables.html

[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

# Custom config should go here
!includedir /etc/mysql/conf.d/

default_authentication_plugin= mysql_native_password
```



## Dockerfile

问答项目：根目录下新建 Dockerfile 文件

```bash
# 这里先用 node 作为基础镜像，主要使用 npm 打包。
# AS frontend 很关键，因为后面使用了第二个 FROM，会覆盖掉第一个 FROM。
# 所以通过 frontend 可以让后面的对它进行引用
FROM node AS frontend

# 进入工作目录，设 /usr/src/wd-app 为我们的工作目录
# 注意 /usr/src/wd-app 中的文件夹如果容器内没有的话会自动创建
WORKDIR /usr/src/wd-app

# 拷贝上下文中的目录文件到工作目录内，这里就是将上下文呢的文件拷贝进了 /usr/src/wd-app 里
COPY ./ ./

# 然后安装依赖并打包
RUN npm i --registry=https://registry.npm.taobao.org
RUN npm run build

# 这里又把 tomcat 作为了基础镜像，那么上面的 node 镜像就没有了
FROM tomcat

# 设置工作目录
WORKDIR /usr/local/tomcat/webapps/ROOT

# 注意这里拷贝使用了 --from=frontend 如果没有这个的话它是找不到 /usr/src/wd-app/dist/ 目录的
# 因为第二个 FROM 让它把基础镜像变成了 tomcat，也就是容器已经变成了 tomcat 了。
# 那么想要获取上一个镜像容器内的文件，就得通过 --from 进行引用
# 这里是把之前打包的 dist 文件夹中的文件拷贝到了 /usr/local/tomcat/webapps/ROOT 内
COPY --from=frontend /usr/src/wd-app/dist/ ./

EXPOSE 8080
```

## 推送镜像到 Docker Hub

```bash
# 登录
sudo docker login

# 打标签
sudo docker tag [imageid] xxx/xxx:tag

# 推送，前提在 docker hub 上已经建好了 xxx/xxx 仓库
sudo docker push xxx/xxx:tag
```

