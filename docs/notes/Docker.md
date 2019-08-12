# Docker

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



## 参考文档

+ [Docker — 从入门到实践](https://www.yuque.com/grasilife/docker)
+ [菜鸟教程 - Docker 教程](https://www.runoob.com/docker/docker-tutorial.html)