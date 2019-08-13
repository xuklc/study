### 1 redis数据库

redis默认有16个数据库

### 2 键的过期时间

expire设置键的生成时间,pexpireat设置过期时间

### 3 过期策略

#### 3.1删除策略

1 定时删除，到时间就把所有过期的键删除

2 惰性删除，每次从键空间取键时，判断改键是否删除，过期则删除

3 定期删除，每隔一段时间去删除，限制删除的执行时长和频率

### 4 内存淘汰机制

如果定期删除漏掉了很多过期的key,也没有及时去查，大量过期的key堆积在内存里，导致redis的内存耗尽

解决办法是设置redis内存最大使用量，当内存使用量超出时，会执行内存淘汰策略

#### 4.1 内存淘汰机制

| 策略            | 描述                                                 |
| --------------- | ---------------------------------------------------- |
| volatile-lru    | 从已设置过期时间的数据集中挑选最近最少使用的数据淘汰 |
| volatile-ttl    | 从已设置过期时间的数据集中挑选将过期的数据淘汰       |
| volatile-random | 从已设置过期时间的数据集中挑选随机选择数据淘汰       |
| allkeys-lru     | 从所有数据集中挑选最近最少使用的数据淘汰             |
| allkeys-random  | 从所有数据随机选择数据淘汰                           |
| noeviction      | 禁止淘汰数据                                         |

### 5 redis持久化

#### 5.1 RDB

将某一时刻的所有数据保存到RDB文件中

有两个命令可以生成RDB文件

1 save:会阻塞redis服务进程，服务器不能接收任何请求，直到RDB文件创建完为止

2 bgsave:创建出一个子进程，由子进程创建RDB文件，服务器可以继续接收请求

除了手动调用save和bgsave命令，还可以配置定期执行

在默认的配置下，如果以下的条件被触发，就会执行`BGSAVE`命令

```text
save 900 1              #在900秒(15分钟)之后，至少有1个key发生变化，
    save 300 10            #在300秒(5分钟)之后，至少有10个key发生变化
    save 60 10000        #在60秒(1分钟)之后，至少有10000个key发生变化
```

RDB优缺点：

优点:载入数据快，文件体积小

缺点:会一定程度上丢失(当系统宕机则会数据丢失)

#### 5.2 AOF(append-only-file)

当redis执行写命令的时候，将执行写命令保存到AOF文件



AOF优缺点

优点:丢失数据少(默认数据一秒的数据)

缺点:恢复数据慢，体积大

### 6 redis单线程快的原因

1 纯内存操作

2 是基于非阻塞的IO多路复用机制

3 单线程避免了多线程频繁上下文切换的消耗



### 7 集群 的主从复制

主服务器:master

从服务器:replica(slave)

主从复制的实现本质就是通过socket把**主服务器**的**RDB文件**传输到**从服务器**上，

![主从复制1](D:\resources\study\note\images\主从复制1.jpg)

### 8 哨兵机制（sentinal）

哨兵机制用于实现redis的高可用性,功能如下:

1 sentinal监控redis主从服务器是否正常工作

2 如果某个Redis实例有故障，那么哨兵负责**发送消息通知**管理员

3 如果主服务器挂掉了，会**自动**将从服务器提升为主服务器(包括配置都会修改)

4 Sentinel可以作为**配置中心**，能够提供当前主服务器的信息

```java
/org/findAllParents  id  mindjet MindManager
```



### 9 lua

https://blog.csdn.net/fly910905/article/details/78955343

redis会保证lua脚本执行的原子性

~~~tex
Also Redis guarantees that a script is executed in an atomic way: no other script or Redis command will be executed while a script is being executed. This semantic is similar to the one of MULTI / EXEC
~~~

在分布式锁或者分布式事务时会用到lua脚本来保证原子性，这个暂时空缺出来

### 10 分布式锁

zokeeper分布式锁

**https://blog.csdn.net/qiangcuo6087/article/details/79067136**

基于redis实现分布式锁的机制，主要是依赖redis自身的原子操作

使用setnx命令

```shell
set  key  value NX PX 30000
```

分布式锁

http://ifeve.com/redis-lock/

http://developer.51cto.com/art/201812/588335.htm

![分布式锁时延](F:\workspace\idea\study\study\note\images\分布式锁时延.png)

注意看，上面的步骤(3)-->步骤(4.1)并不是**原子性操作**。也就说，你可能出现在步骤(3)的时候返回的是有效这个标志位，但是在传输过程中，因为**延时等原因**，在步骤(4.1)的时候，**锁已经超时失效了**。那么，这个时候锁就会被另一个客户端锁获得。就出现了两个客户端共同操作共享资源的情况

**redis的主从复制是异步，给有可能出现master节点宕机了，slave来不及同步数据就被选为master,从而导致数据丢失**

具体流程如下:

1 客户端1从master获取锁

2 master宕机了，存储锁的key还没来得及同步到slave上

3 slave升级为master

4 客户端2 从新的master获取对应的同一资源锁

解决办法

**redLock算法**



### 11 分布式事务

**不保证原子性，一条命令执行失败，其他命令继续执行**

// 先加锁监控

watch

//开始事务

multi

提交的命令加入任务队列，但是没有加锁

// 原子操作

exec

exec命令在key在watch监视加锁的情况没有被改动才能执行成功，否则会事务回滚

// 取消监控，放弃锁

unwatch

//监控加锁

watch

multi

exec

### 12安装

1 解压压缩包

tar -zxvf redis-xxx.tar.gz

2 执行maker命令安装

  ~~~sh
make
  ~~~

3 若没有gcc命令则需要安装

gcc是linux是一个编译程序

 安装方法

1 上网

~~~shell
yum install gcc-c++
~~~

2 本地安装gcc

// todo

### 13 配置和启动redis

#### 13.1配置redis

1 修改redis.conf文件，设置redis线程为守护线程  

~~~properties
daemonize yes
~~~

 **查找启动的redis进程命令**

~~~shell
ps -ef|grep redis
~~~

#### 13.2 启动redis

~~~shell
./redis-server ../redis.conf
~~~

#####  redis-cli

~~~shell
redis-cli -p 6379
~~~

![redis-cli](F:\workspace\idea\study\study\note\images\redis-cli.png)

### 14 基础知识

1 redis是单线程(指处理读写请求是使用单线程,不止一个线程)

2 使用多路IO复用模型

3 对读写等事件的响应是通过epoll函数的包装来实现的，Epoll是linux内核为处理大批量文件描述而改进的epoll,是linux下多路复用IO接口select/poll的增强版本

4 select index切换数据库 

例子

~~~shell
select 7  --(第8个数据库的下表是7)
~~~

#### 5 DBSIZE

查看当前数据库有多少key

~~~shell
key *  --查看当前数据库所有的key
~~~

#### 6 清空当前数据库的key

~~~shell
FLUSHDB
FLUSHALL --清空所有数据库的key
~~~

### 数据类型

**命令参考**

http://redisdoc.com/hash/hlen.html

#### hash

KV模式不变，但V是一个键值对

**hset、hget、hmset、hmget、hgetall、hdel**

例子

~~~shell
hset user id 11
hget user id
~~~

![redis_hash](F:\workspace\idea\study\study\note\images\redis_hash.png)

hmset(其中的m是more的意思)

![hmset](F:\workspace\idea\study\study\note\images\hmset.png)

hdel是删除key

![hdel](F:\workspace\idea\study\study\note\images\hdel.png)

hlen key--返回key的数量

hkeys --返回一个hash中key包含所有的key,等同于获取map中所有的key

hvals --返回hash中包含的所有value,等同于获取map中所有的values

hincrby customer age 2 --表示customer.age属性增加2，该操作是原子操作

hincrbyfloat customer score 0.5 -- 表示customer.score 属性增加0.5，该操作是原子操作

hsetnx key  value --当key不存在则创建一个，否则什么也不做，返回值0表示false,1表示true

#### sorted set

sorted set是有序集合

#### set



1 主从复制

2 容错，复制的整个过程(全复制和增量复制)

3 

### 配置文件

配置文件的修改有两种1 是用命令config set  propeties value

2 修改配置文件

#### includes包含

例子:包含其他的配置文件

include /path/to/local.conf

#### general

##### 日志级别

debug,verbose,notice,warning

timeout 表示客户端限制多长时间关闭该连接，**值为0表示关闭该功能，即该客户端永远不关闭**

dir 设置本地数据库的存放目录

#### SNAPSHOTTING(快照)

#### SECURITY

设置密码

config  set  requirepass "123456"

验证密码

auth  password

#### limits

Maxclients

Maxmemory

Maxmemory-policy

缓存的过期策略

Maxmemory-samples

### AOF



### RDB



### 乐观锁



### 悲观锁

当需要修改数据是会被阻塞知道拿到锁为止，例如表锁、行锁、写锁，在操作之前先上锁



### 主从复制

http://redisdoc.com/topic/index.html

1 复制粘贴几个配置文件

2 修改配置文件

3 学习一个命令 info  repliation

4 slaveof host port

#### 复制原理

slave启动成功连接到master后发送一个sync命令

Master接到命令后启动后台的存盘进程，同时收集所有接收的用于**修改数据集命令**

在后台进程执行完毕之后，master将传送整个数据文件到slave,完成一次完全同步

全量复制:slave服务在接收到数据文件后，将数据文件写到硬盘并加载到内存中

增量复制:Master继续将新的所有收集到的修改命令依次传给slave，完成同步

#### 哨兵机制

1 自定义sentinel.conf文件,**文件名不能出错**

文件内容

~~~properties
sentinel  monitor host6379 127.0.0.1 6379 1 --最后一个是表示Master宕机之后，slave得票多少才能成为master
~~~

2 启动sentinel

~~~shell
redis-sentinel ../src/sentinel.conf  --配置sentinel文件的路径
~~~

master宕机启动之后会变成slave,(sentinel会将master设置成slave)

分布式锁才是重点，今晚要搞定

