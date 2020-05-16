# Linux



## 目录结构

这里记录一些重要的目录结构

| 目录  | 解释                                                         |
| ----- | ------------------------------------------------------------ |
| /bin  | bin 是 Binary 的缩写，这个目录存放着最经常使用的命令。比如 ls 就在 /bin/ls 下。 |
| /etc  | 存放系统管理所需要的配置文件和子目录，如果更改了该目录下某文件可能会导致系统不能启动。 |
| /home | 用户的主目录。                                               |
| /opt  | 安装额外软件所摆放的目录。比如安装一个 ORACLE 数据库就可以放到这个目录下。默认是空的。 |
| /root | 该目录为系统管理员，也称作超级权限者的用户主目录。           |
| /usr  | 重要。用户的很多应用程序和文件都放在这个目录下，类似 windows 下的 program files 目录。 |
| /var  | 重要。这个目录中存放着在不断扩充着的东西，我们习惯将那些经常被修改的目录放在这个目录下。比如各种日志文件。 |
| /tmp  | 存放临时文件的目录                                           |



## 常用命令

**<u>删除命令</u>**

```bash
# -f 就是强行删除，不作任何提示
# -r 向下递归，不管有多少级目录，一并删除

# 删除文件
rm -f 文件名

# 删除文件夹
rm -rf 文件夹路径
```



## PM2

```bash
1. 启动命令
  1. pm2 start app.js：启动nodeJs应用，进程的默认名称为文件名app
  2. pm2 start app.js --name mynode：启动node，并指定进程名称为mynode
  3. pm2 start app.js -i max：根据有效CPU数目启动最大进程数目
  4. pm2 start app.js -i 3：启动3个进程
  5. pm2 start app.js --watch：实时监控的方式启动，app.js文件有变动时，pm2会自动reload
  6. pm2 start app.js -x：用fork模式启动 app.js 而不是使用 cluster
  7. pm2 start app.js -x -- -a 23：用fork模式启动 app.js 并且传递参数（-a 23）
  8. pm2 start app.json：启动进程, 在 app.json里设置选项
  9. pm2 start app.js -i max -- -a 23：在 -- 之后给 app.js 传递参数
  10. pm2 start app.js -i max -e err.log -o out.log：启动并生成一个配置文件
  
2. 查看与监视进程
  1. pm2 list：显示所有进程；
  2. pm2 show 0，pm2 info 0：查看进程id为 0 的详细信息；
  3. pm2 monit：进入监视页面，监视每个node进程的CPU和内存的使用情况。
  
3. 停止、删除进程
  1. pm2 stop/delete 0：停止/删除id为 0 的进程；
  2. pm2 stop/delete all：停止/删除所有进程。
  
4. 重启、重载
  1. pm2 restart 0：重启id为 0 的进程；
  2. pm2 restart all：重启所有进程；
  3. pm2 reload 0：0秒停机重载id为 0 进程（用于 NETWORKED 进程）；
  4. pm2 reload all：重载所有进程。
  
5. 日志操作
  1. pm2 logs：显示所有进程的日志；
  2. pm2 logs 0：显示进程id为 0 的日志；
  3. pm2 flush：清空所有日志文件；
  4. pm2 reloadLogs：重载所有日志。
  
6. pm2 startup：产生 init 脚本，保持进程活着。
```



## 文件操作之 vi 命令

基本概念：vi 分为三种操作状态。分别是命令模式、插入模式和底线命令模式。

<u>**命令模式**</u>

通过 vi 加文件名默认进入的就是命令模式。

在该模式下是不可以直接进行输入的。此时键盘上的英文字母都代表命令。但是可以通过方向键移动光标。

在命令模式下的一些常用操作有：

| 命令        | 描述                                     |
| ----------- | ---------------------------------------- |
| :           | 进入底线命令模式。                       |
| i 或 a 或 o | 进入插入模式，具体区别这里不做记录。     |
| x / X       | x 以光标处向后删除，X 以光标处向前删除。 |
| dd          | 删除当前行                               |

**<u>插入模式</u>**

在命令模式下通过按下 i 或 a 或 o 均可进入插入模式。

插入模式可以自由进行输入，但此模式下的方向键不可以作为移动光标使用，Backspace 也不可作为删除。

当发生输入错误时，可以通过按下 ESC 键退回命令模式，再通过 x / X 进行删除。或者通过 Backspace 键往前移动光标，移动至要修改的地方进行输入，通过覆盖后方输入的方式进行修改。

> 在插入模式下，通过右键的方式可以粘贴外部文本

**<u>底线命令模式</u>**

在命令模式下通过输入 : 进入底线命令模式。

该模式会在最底部显示一个冒号，冒号后跟下列命令做相应操作。

| 命令 | 描述                       |
| ---- | -------------------------- |
| :x   | 保存文件并退出，相当于 :wq |
| :w   | 保存当前文件               |
| :q!  | 不保存文件并退出 vi        |
| :wq  | 保存并退出 vi              |



## echo 命令

```bash
# 输出文本
echo hello-world

# 重定向输出到某个位置，替换原有文件的所有内容。
echo '<h1>hello-world</h1>' > /index.html

# 重定向追加到某个位置，在原有文件的末尾添加内容。
echo console.log(222) >> /test.js
```





## 查看与 kill 端口进程

```bash
# 查看指定端口的被占用情况
netstat -tunlp | grep 8000

# 杀死该端口进程，PID 通过上面查看的命令可以看到，并不是指端口号
kill -9 PID
```

netstat 是 net-tools 提供的命令。如果 netstat 无法执行，则可以安装。

```bash
sudo apt install net-tools
```



## ubuntu 之 apt 命令

作用：以方便用户安装、删除和管理的软件包。

其中 apt-get 便是一款广受欢迎的命令行工具。类似的命令有 apt-cache，apt-config 等。最常用的 Linux 包管理命令都被分散在了它们当中。

命令 apt 的引入就是为了解决命令过于分散的问题。简单说 apt = apt-get、apt-cache 和 apt-config 中最常用命令选项的集合。

常用命令如下：

| 命令             | 描述                                                         |
| ---------------- | ------------------------------------------------------------ |
| apt list         | 列出本地仓库中所有的软件包名，后可跟关键字筛选               |
| apt install      | 安装软件包                                                   |
| apt remove       | 移除软件包                                                   |
| apt purge        | 移除软件包及配置文件                                         |
| apt update       | 只检查，不更新（已安装的软件包是否有可用的更新，给出汇总报告） |
| apt upgrade      | 更新已安装的软件包                                           |
| apt full-upgrade | 在升级软件包时自动处理依赖关系                               |
| apt autoremove   | 自动删除不需要的包                                           |
| apt search       | 搜索应用程序                                                 |
| apt show         | 查看软件包信息                                               |
| apt clean        | 删除所有已下载的软件包                                       |
| apt autoclen     | 类似clean，但删除的是过期的包（即已不能下载或者是无用的包）  |



## ubuntu 之切换用户

**<u>切换 root 用户</u>**

```bash
# 切换至 root
su root

# 如果输入密码一直错误，可能是没有给 root 设置密码。通过下面的命令设置密码
sudo passwd root

# 切换回原用户
su yzn
```



## ubuntu 之安装 nodejs

**<u>方式一</u>**

```bash
# apt 命令安装 nodejs
sudo apt install nodejs

# 安装成功后查看版本发现 node 版本很低
node -v

# 忽略 node 版本低的问题，继续安装 npm
sudo apt install npm

# npm 安装完成后会发现 npm 的版本也低
npm -v

# 这时可以用到一个 node 的版本管理工具，n 模块
# 通过刚才安装的 npm 来安装 n 模块
sudo npm install n -g

# 这时候在通过 n 模块安装最新稳定版的 nodejs
sudo n stable

# 成功后执行 n
sudo n

# 选择新安装上的 node 回车即可
```

n **<u>模块常用命令</u>**

```bash
# 安装最新稳定版的 node
sudo n stable

# 安装最新版本的 node
sudo n latest

# 删除某个版本
sudo n rm 12.16.1

# 以指定版本来运行文件
sudo n use 12.16.1 test.js
```



## ubuntu 之更改镜像源和语言

更改镜像源

```bash
# 进入目录
cd /etc/apt

# 备份原文件
sudo cp sources.list sources.list.default

# 修改当前文件内容，内容从 https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/ 获取
sudo vi sources.list

# 更新源
sudo apt-get update
```



更改语言

https://blog.csdn.net/qq_19339041/article/details/80058575



## ubuntu 之更改输入法

最简单的方式：https://www.jianshu.com/p/750963a689fb



安装搜狗输入法

```bash

```





## 问题

**<u>关于 Ubuntu 中 Could not get lock /var/lib/dpkg/lock 解决方案</u>**

原因：主要是因为apt还在运行，此时的解决方案是

```bash
# 删除锁定文件
sudo rm /var/lib/dpkg/lock
sudo rm /var/lib/dpkg/lock-frontend
```

