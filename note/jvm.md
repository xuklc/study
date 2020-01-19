



### 内存结构

#### 1 堆内存

堆内存细分

![heap细分](D:\resources\study\note\images\heap细分.png)

新生代和老年代默认是1:2

-XX:NewRatio=4,新生代占比是1，老年代占比是4

#### 2 本地方法栈

#### 3 虚拟机栈

#### 4 程序计数器

#### 5 元空间

  不在虚拟机中，在直接内存中

### 垃圾判断算法

1 引用计数法

给对象添加一个计数器，当一个地方引用则加，引用失效则减1，当计数器的值为0则对象失效

2 可达性分析法

从GC Root 对象往下搜索，当一个对象到GC root没有任何引用链相连则不可达

#### GC Root

1 虚拟机栈(栈帧中的局部变量区，也叫局部变量表)中引用的对象

2 方法区中静态属性引用的对象

3 方法去常量引用对象

4 本地方法栈中JNI(native方法)引用的对象

### jvm 参数

**多个jvm参数使用空格隔开**

![多个jvm参数](D:\resources\study\note\images\多个jvm参数.png)

#### 1 标配参数

##### -Xms

-Xms等价于-XX:InitialHeapSize

##### -Xmx

-Xmx等价于-XX:MaxHeapSize

##### -Xss

-Xss等价于-XX:ThreadStackSize。设置每个线程栈的大小，一般默认是512k-1024k

**-Xss的用法: -Xss128k**

![Xss](D:\resources\study\note\images\Xss.png)

Xss官网解释

#### ![Xss的官网参数](D:\resources\study\note\images\Xss的官网参数.png)

##### -Xmn

-Xmn:年轻代的大小

##### -XX:MetaspaceSize

设置元空间的大小，元空间直接使用本地内存，不在jvm之中

**b是字节**,比	特是表示信息的最小单位

元空间默认大小是21807104b

java.lang.OutofMemoryError:Metaspace

#### 2 x参数(了解)

#### 3 xx参数(重点)

##### 3.1 布尔类型(boolean)

​	 -XX:+(-)属性值--其中+表示开启，-表示关闭

##### 3.2 KV设置类型

公式:-XX:属性key=属性value

~~~ shell
jinfo -flag MetespaceSize 5148
~~~



##### 3.3 jinfo

jinfo举例,如何查看当前运行程序的配置

 jps -l

**jps也可以在linux环境使用**

**重要命令:jinfo -flags pid**

jinfo的使用

公式;jinfo -flag  属性名  pid

![jinfo](F:\workspace\idea\study\study\note\images\jinfo.png)

![XX-表示参数关闭](F:\workspace\idea\study\study\note\images\XX-表示参数关闭.png)

##### 3.4 使用串行垃圾回收器

-XX:+UseSerialGC



#### 4 command line

command line是指自己加的jvm参数

![jvm Command line](F:\workspace\idea\study\study\note\images\jvm Command line.png)



### jvm 默认参数查看第二种方法

java -XX:+PrintFlagsInitial -- 查看初始默认值，即没有被人为修改过的

java -XX:+PrintFlagsFinal  --主要查看修改更新之后的参数

![PrintFlagsFinal](D:\resources\study\note\images\PrintFlagsFinal.png)

##### 说明

没有冒号说明是初始值，即没有被人为修改过，有冒号说明被人为修改过

![printFlagFinal说明](D:\resources\study\note\images\printFlagFinal说明.png)

### jvm参数查看第三办法

java -XX:+PrintCommandLineFlags  --- 第三方办法

![PrintCommandLineFlags](D:\resources\study\note\images\PrintCommandLineFlags.png)



### printGCDetails

![printGCDetails](D:\resources\study\note\images\printGCDetails.png)

#### GC和Full GC

![FullGC](D:\resources\study\note\images\FullGC.png)

~~~ shell
[GC (Allocation Failure) [PSYoungGen: 2048K->504K(2560K)] 2048K->1020K(9728K), 0.0027086 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[GC (Allocation Failure) [PSYoungGen: 2552K->504K(2560K)] 3068K->1339K(9728K), 0.0006765 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[GC (Allocation Failure) [PSYoungGen: 2552K->504K(2560K)] 3387K->1971K(9728K), 0.0009407 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
initHeapSize9961472字节,9M
maxHeapSize9961472字节,9M
[GC (Allocation Failure) [PSYoungGen: 2179K->504K(2560K)] 3647K->2311K(9728K), 0.0010163 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
--  [PSYoungGen: 504K->504K(2560K)] 2311K->2367K(9728K):PSYoungGen区GC前是504k,GC后是504k，总大小是2560k, 2311K->2367K(9728K):堆内存在GC前是2311k,GC后是2367K,堆的总大小是9728k
-- [Times: user=0.00 sys=0.00, real=0.00 secs]-- user:用户耗时,sys:系统耗时，real:真实耗时
[GC (Allocation Failure) [PSYoungGen: 504K->504K(2560K)] 2311K->2367K(9728K), 0.0004441 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[Full GC (Allocation Failure) [PSYoungGen: 504K->0K(2560K)] [ParOldGen: 1863K->1869K(7168K)] 2367K->1869K(9728K), [Metaspace: 3536K->3536K(1056768K)], 0.0089646 secs] [Times: user=0.11 sys=0.00, real=0.01 secs] 
[GC (Allocation Failure) [PSYoungGen: 0K->0K(1536K)] 1869K->1869K(8704K), 0.0002946 secs] [Times: user=0.00 sys=0.00, real=0.00 secs] 
[Full GC (Allocation Failure) [PSYoungGen: 0K->0K(1536K)] [ParOldGen: 1869K->1810K(7168K)] 1869K->1810K(8704K), [Metaspace: 3536K->3536K(1056768K)], 0.0128252 secs] [Times: user=0.11 sys=0.00, real=0.01 secs] 
Heap
~~~

###  survivorRatio

-XX:survivorRatio=8   ---设置eden区和survivorRatio From survivorRatio to 的比例,默认是8:1:1

![survivorRatio](D:\resources\study\note\images\survivorRatio.png)



### -XX:MaxTenuringThreshold

设置垃圾的最大年龄，如果设置为0，则年轻代对象不经过suvivor去，直接进入老年代，如果此值设置比较大，则年轻代对象会在survivor区进行多次复制，这样可以增加对象在年轻代的存活时间，增加在年轻代被回收的概率

**最大值是15**,值的范围是0-15



### OOM

##### stackOverflowError

虚拟机栈内存爆满

例子1 递归调用没有跳出循环的条件或或者递归调用有比较大对象

#### OutofMemoryError:heap space

堆内存爆满

#### overhead limit exceeded

GC回收时间过长或者GC回收效果不明显，导致频繁GC

### 查看默认的GC回收器

java -XX:+PrintCommandLineFlags



### 垃圾收集器

#### 1 串行垃圾收集器

-XX:+UseSerialGC

1 在垃圾收集过程中所有工作线程都会停止

2 没有线程的交互，简单高效

开启后新生代使用Serial+SerialOld(老年代)

表示新生代和老年代都是串行收集器，新生代使用复制算法，老年代使用标记-整理法

### 2 ParNew收集器

-XX:+UseParaNewGC,启用ParNew收集器，只影响新生代收集器，不影响老年代收集器

开启这个参数使用新生代用ParNewGC收集器，老年代用SerialOld收集器

### 3 Parallel收集器(parallel scavenge)

-XX:+UseParallelGC或-XX:+UseParallelOldGC**可以互相激活**

使用复制算法，并行的多线程收集器，吞吐量垃圾收集器

吞吐量=运行用户代码时间/运行用户代码时间+垃圾收集时间

有两个参数控制吞吐量

1 -XX:MaxGCPauseMillis:设置一个大于0的毫秒数，这个是GC垃圾回收的最大停顿时间，但不一定不超时

2 -XX:GCTimeRatio:设置一个垃圾回收时间的比例，等于加一个倒数，例如比值是19,则垃圾回收是1/(1+19)

3 -XX:ParallelGCThreads=3--启动3个线程回收垃圾，**当cpu>8，实际线程数等于3/8,cpu<8,就是实际数**



线程池，多线程,mybatis,spring cloud常用属性



### 4 G1收集器

-XX:+UseG1GC

**标记整理算法，局部是复制算法**

G1是一种服务端垃圾收集器，在实现高吞吐量 的同时，尽可能的满足垃圾收集暂停时间的要求，具有以下特性

1 能与应用程序并发执行

2 整理空闲空间更快

3 需要更多时间预测GC停顿时间

**主要改变是Eden、suvivor和Tenured等内存区域不再是连续，而是变成了一个个大小一样的region，每个region从1M到32M不等，一个region可能是Eden、Suvivor或Tenured**



### 对象进入老年代参数

-XX:PretenureSizeThreshold设置大对象直接进入年老代的阈值，当对象大小超过这个值时，将直接在年老代分配。默认值是0

-XX:MaxTenuringThreshold是给Serial收集器和没有开启UseAdaptiveSizePolicy的ParNew GC收集器用的(`在计算存活周期这个阈值时，hotspot会遍历所有age的table，并对其所占用的大小进行累积，当累积的大小超过了survivor space的一半时，则以这个age作为新的存活周期阈值，最后取age和MaxTenuringThreshold中更小的一个值。`)



### GC参数

-Xms9m -Xmx9m -XX:+PrintGCDetails -XX:MetaspaceSize=10m -XX:MaxMetaspaceSize=10m



### CAS

比较并替换，将传入的值和真实值比较，相同则更新值，不相同则不更新

cas是一种系统原语，原语属于操作系统用语范畴，是由若干条指令组成的，用于完成某个功能的一个过程，并且原语的执行必须是连续的，在执行过程不会被打断，不会造成所谓的数据不一致的问题，这是一个依赖于硬件实现的功能

**CAS是一条CPU的原子指令**

![CAS原理](F:\workspace\idea\study\study\note\images\CAS原理.png)



缺点:循环时间长，资源消耗大

#### ABA问题

问题1  线程1从堆内存读取一个共享变量x的值是A,线程2从堆内存读取共享变量x的是A,然后线程2将是改为B，再然后线程2又把变量x的值改为A，这个时候线程1从将栈内存的值A和堆内存的值比较都是A，两者相等，线程1更新变量x的值

解决办法

1 引入AtomicReference(原子引用)

2 加入版本号

### 大对象进入老年代条件

1 对象大小大于Eden区的总大小

2 超过PretenureSizeThreshold的值，默认值是0

### 老年代爆满优化

https://blog.csdn.net/wzygis/article/details/83589764

### jstat

S0 年轻代中第一个survivor（幸存区）已使用的占当前容量百分比

S1 年轻代中第二个survivor（幸存区）已使用的占当前容量百分比

E 年轻代中Eden（伊甸园）已使用的占当前容量百分比

O old代已使用的占当前容量百分比

P perm代已使用的占当前容量百分比

YGC 从应用程序启动到采样时年轻代中gc次数

YGCT 从应用程序启动到采样时年轻代中gc所用时间(s)

FGC 从应用程序启动到采样时old代(全gc)gc次数

FGCT 从应用程序启动到采样时old代(全gc)gc所用时间(s)

GCT 从应用程序启动到采样时gc用的总时间(s)