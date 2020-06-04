

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

### cat



### tail

语法

```shell
tail [参数] [文件] 
```

**参数：**

- -f 循环读取
- -q 不显示处理信息
- -v 显示详细的处理信息
- -c<数目> 显示的字节数
- -n<行数> 显示文件的尾部 n 行内容
- --pid=PID 与-f合用,表示在进程ID,PID死掉之后结束
- -q, --quiet, --silent 从不输出给出文件名的首部
- -s, --sleep-interval=S 与-f合用,表示在每次反复的间隔休眠S秒

例子

~~~shell
tail -f 1000 xxx.log
~~~

### 网卡设置

~~~she
TYPE=Ethernet    # 网卡类型：为以太网
PROXY_METHOD=none    # 代理方式：关闭状态
BROWSER_ONLY=no      # 只是浏览器：否
BOOTPROTO=dhcp  #设置网卡获得ip地址的方式，可能的选项为static(静态)，dhcp(dhcp协议)或bootp(bootp协议).
DEFROUTE=yes        # 默认路由：是, 不明白的可以百度关键词 `默认路由`
IPV4_FAILURE_FATAL=no     # 是不开启IPV4致命错误检测：否
IPV6INIT=yes         # IPV6是否自动初始化: 是[不会有任何影响, 现在还没用到IPV6]
IPV6_AUTOCONF=yes    # IPV6是否自动配置：是[不会有任何影响, 现在还没用到IPV6]
IPV6_DEFROUTE=yes     # IPV6是否可以为默认路由：是[不会有任何影响, 现在还没用到IPV6]
IPV6_FAILURE_FATAL=no     # 是不开启IPV6致命错误检测：否
IPV6_ADDR_GEN_MODE=stable-privacy   # IPV6地址生成模型：stable-privacy [这只一种生成IPV6的策略]
NAME=ens34     # 网卡物理设备名称  
UUID=8c75c2ba-d363-46d7-9a17-6719934267b7   # 通用唯一识别码，没事不要动它，否则你会后悔的。。
DEVICE=ens34   # 网卡设备名称, 必须和 `NAME` 值一样
ONBOOT=no #系统启动时是否设置此网络接口，设置为yes时，系统启动时激活此设备 
IPADDR=192.168.103.203   #网卡对应的ip地址
PREFIX=24             # 子网 24就是255.255.255.0
GATEWAY=192.168.103.1    #网关  
DNS1=114.114.114.114        # dns
HWADDR=78:2B:CB:57:28:E5  # mac地址
~~~

- 安装ifconfig

  ~~~properties
   yum install net-tools
  ~~~

#### ip命令常用参数

~~~shell
Ip  [选项]  操作对象{link|addr|route...}

# ip link show                           # 显示网络接口信息
# ip link set eth0 upi                   # 开启网卡
# ip link set eth0 down                  # 关闭网卡
# ip link set eth0 promisc on            # 开启网卡的混合模式
# ip link set eth0 promisc offi          # 关闭网卡的混个模式
# ip link set eth0 txqueuelen 1200       # 设置网卡队列长度
# ip link set eth0 mtu 1400              # 设置网卡最大传输单元
# ip addr show                           # 显示网卡IP信息
# ip addr add 192.168.0.1/24 dev eth0    # 设置eth0网卡IP地址192.168.0.1
# ip addr del 192.168.0.1/24 dev eth0    # 删除eth0网卡IP地址

# ip route list                                            # 查看路由信息
# ip route add 192.168.4.0/24  via  192.168.0.254 dev eth0 # 设置192.168.4.0网段的网关为192.168.0.254,数据走eth0接口
# ip route add default via  192.168.0.254  dev eth0        # 设置默认网关为192.168.0.254
# ip route del 192.168.4.0/24                              # 删除192.168.4.0网段的网关
# ip route del default                                     # 删除默认路由
~~~

### 网络配置

https://blog.csdn.net/chinaltx/article/details/86497165