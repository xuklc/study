### 内存结构

#### 1 堆内存

#### 2 本地方法栈

#### 3 虚拟机栈

#### 4 程序计数器

#### 5 元空间

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

#### 1 标配参数

-Xms等价于-XX:InitialHeapSize

-Xmx等价于-XX:MaxHeapSize

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