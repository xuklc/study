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