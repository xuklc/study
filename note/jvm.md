### 内存结构

#### 1 堆内存

堆内存细分

![heap细分](D:\resources\study\note\images\heap细分.png)

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

