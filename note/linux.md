### SSH免密登录

设置完SSH免密登录之后可以不用输密码，因为服务器已经有本地电脑的公钥，只有本地私钥才能解密，所以不用密码登录也是安全的。

**ssh-keygen -t rsa生成的公私钥文件和known_hosts不能移动，因为SSH密码登录时要读取私钥文件，才能登录**

### 常用命令

#### ssh-keygen

~~~shell
ssh-keygen -t -rsa
~~~

### rz和sz

yum install -y lrzsz

不存在sz，rz命令的话，通过这个安装下yum install -y lrzsz



### sudo

sudo是一个程序，普通用户可以使用它以超级用户或其他用户的身份执行命令，sudo用户的访问权限是由 /etc/sudoers文件控制

###  端口占用(window)

netstat -aon|findstr 8080

结束进程

输入tasklist|findstr 2524命令，其中2524加英文双引号，按回车键就可以找到PID为2524的进程，如下图所示

### tail

tail  -fn100  catalina.log   查询日志尾部最后100行的日志,并且随文件;

### /usr/bin/xauth:  file /root/.Xauthority does not exist

#### 原因

添加用户时没有授权对应目录，仅仅执行了user add ,user没有授权对应目录

#### 解决办法

执行以下命令

### vmwarekey

FF31K-AHZD1-H8ETZ-8WWEZ-WUUVA
CV7T2-6WY5Q-48EWP-ZXY7X-QGUWD

### vmware

按照centos8报错 Section %packages dose not end with %end 

原因:vmware默认安装时到处两个CD/DVD,默认读取ios文件的路径没有设置对

### 连接不上网络

1 检查vmware的网络服务启动了没有

![](D:\softpackage\note\note\images\linux\vmware网络服务.jpg)

### 网卡信息

~~~shell
ens33: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        从flags可知该接口已启用，支持广播、组播，mtu值
        inet 10.10.10.140  netmask 255.255.255.0  broadcast 10.10.10.255
        IPv4地址           子网掩码               广播地址
        inet6 fe80::20c:29ff:fec8:ff4e  prefixlen 64  scopeid 0x20<link>
        IPv6地址                        掩码长度      作用域，link表示仅该接口有效
        ether 00:0c:29:c8:ff:4e  txqueuelen 1000  (Ethernet)
        网卡接口的MAC地址        传输队列长度     接口类型为Ethernet
        RX packets 266  bytes 26083 (25.4 KiB)
        上行表示此接口接收的报文个数，总字节数
        RX errors 0  dropped 0  overruns 0  frame 0
        接收报文错误数，丢弃数，溢出数，冲突的帧数
        TX packets 141  bytes 20086 (19.6 KiB)
        上行表示此接口发送的报文个数，总字节数
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
        发送报文错误数，丢弃数，溢出数，载荷数，冲突数
~~~

ens33是网卡的名称

### 关闭防火墙

#### centos8

~~~shell
systemctl stop firewalld
~~~

### 命令

#### find

find和grep结合使用(管道)的例子

1 find find / |grep ".Xauthority"

2 find ~ |grep ".Xauthority"

3 find |grep sudo*

#### cp

cp  源文件路径  目标目录路径

例子

~~~shell
cp /soft/redis-5.0.5/sentinel.conf
cp /soft/redis-5.0.5/sentinel.conf  .  -- 最后面的表示当前目录
~~~

#### ps

例子

~~~shell
ps -ef|grep redis
~~~

#### ls

~~~shell
ls -a
~~~

ls -a 可以查看隐藏的文件

### gcc

### 安装

1 yum install gcc

2 下载安装

  1http://mirrors.nju.edu.cn/gnu/gcc/

  2 http://mirrors.ustc.edu.cn/gnu/gcc/

 3 https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/

// 教程

https://cloud.tencent.com/developer/article/1424725

