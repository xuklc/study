## 1 lambda表达式

### 基本语法

**Lambda表达式的语法**
基本语法:
**(parameters) -> expression**
或
**(parameters) ->{ statements; }**

####1 方法简单的例子

```java
// 1. 不需要参数,返回值为 5  
() -> 5  
  
// 2. 接收一个参数(数字类型),返回其2倍的值  
x -> 2 * x  
  
// 3. 接受2个参数(数字),并返回他们的差值  
(x, y) -> x – y  
  
// 4. 接收2个int型整数,返回他们的和  
(int x, int y) -> x + y  
  
// 5. 接受一个 string 对象,并在控制台打印,不返回任何值(看起来像是返回void)  
(String s) -> System.out.print(s)  
```

#### 2 foreach

```java
String[] atp = {"Rafael Nadal", "Novak Djokovic",  
       "Stanislas Wawrinka",  
       "David Ferrer","Roger Federer",  
       "Andy Murray","Tomas Berdych",  
       "Juan Martin Del Potro"};  
List<String> players =  Arrays.asList(atp);  
  
// 以前的循环方式  
for (String player : players) {  
     System.out.print(player + "; ");  
}  
  
// 使用 lambda 表达式以及函数操作(functional operation)  
players.forEach((player) -> System.out.print(player + "; ")); 
```

#### 3 匿名内部类

```
// 使用匿名内部类  
btn.setOnAction(new EventHandler<ActionEvent>() {  
          @Override  
          public void handle(ActionEvent event) {  
              System.out.println("Hello World!");   
          }  
    });  
   
// 或者使用 lambda expression  
btn.setOnAction(event -> System.out.println("Hello World!")); 
// 1.1使用匿名内部类  
new Thread(new Runnable() {  
    @Override  
    public void run() {  
        System.out.println("Hello world !");  
    }  
}).start();  
  
// 1.2使用 lambda expression  
new Thread(() -> System.out.println("Hello world !")).start();  
  
// 2.1使用匿名内部类  
Runnable race1 = new Runnable() {  
    @Override  
    public void run() {  
        System.out.println("Hello world !");  
    }  
};  
  
// 2.2使用 lambda expression  
Runnable race2 = () -> System.out.println("Hello world !");  
   
// 直接调用 run 方法(没开新线程哦!)  
race1.run();  
race2.run();  
```

#### 4 结合stream使用

```java
ublic class Person {  
  
private String firstName, lastName, job, gender;  
private int salary, age;  
  
public Person(String firstName, String lastName, String job,  
                String gender, int age, int salary)       {  
          this.firstName = firstName;  
          this.lastName = lastName;  
          this.gender = gender;  
          this.age = age;  
          this.job = job;  
          this.salary = salary;  
}  
// Getter and Setter   
// . . . . .  
}  
```

```java
List<Person> javaProgrammers = new ArrayList<Person>() {  
  {  
    add(new Person("Elsdon", "Jaycob", "Java programmer", "male", 43, 2000));  
    add(new Person("Tamsen", "Brittany", "Java programmer", "female", 23, 1500));  
    add(new Person("Floyd", "Donny", "Java programmer", "male", 33, 1800));  
    add(new Person("Sindy", "Jonie", "Java programmer", "female", 32, 1600));  
    add(new Person("Vere", "Hervey", "Java programmer", "male", 22, 1200));  
    add(new Person("Maude", "Jaimie", "Java programmer", "female", 27, 1900));  
    add(new Person("Shawn", "Randall", "Java programmer", "male", 30, 2300));  
    add(new Person("Jayden", "Corrina", "Java programmer", "female", 35, 1700));  
    add(new Person("Palmer", "Dene", "Java programmer", "male", 33, 2000));  
    add(new Person("Addison", "Pam", "Java programmer", "female", 34, 1300));  
  }  
};  
  
List<Person> phpProgrammers = new ArrayList<Person>() {  
  {  
    add(new Person("Jarrod", "Pace", "PHP programmer", "male", 34, 1550));  
    add(new Person("Clarette", "Cicely", "PHP programmer", "female", 23, 1200));  
    add(new Person("Victor", "Channing", "PHP programmer", "male", 32, 1600));  
    add(new Person("Tori", "Sheryl", "PHP programmer", "female", 21, 1000));  
    add(new Person("Osborne", "Shad", "PHP programmer", "male", 32, 1100));  
    add(new Person("Rosalind", "Layla", "PHP programmer", "female", 25, 1300));  
    add(new Person("Fraser", "Hewie", "PHP programmer", "male", 36, 1100));  
    add(new Person("Quinn", "Tamara", "PHP programmer", "female", 21, 1000));  
    add(new Person("Alvin", "Lance", "PHP programmer", "male", 38, 1600));  
    add(new Person("Evonne", "Shari", "PHP programmer", "female", 40, 1800));  
  }  
};  
```

我们同样使用forEach方法,增加程序员的工资5%:

```java
System.out.println("给程序员加薪 5% :");  
Consumer<Person> giveRaise = e -> e.setSalary(e.getSalary() / 100 * 5 + e.getSalary());  
  
javaProgrammers.forEach(giveRaise);  
phpProgrammers.forEach(giveRaise);
```

另一个有用的方法是过滤器filter() ,让我们显示月薪超过1400美元的PHP程序员:

```java
System.out.println("下面是月薪超过 $1,400 的PHP程序员:")  
phpProgrammers.stream()  
          .filter((p) -> (p.getSalary() > 1400))  
          .forEach((p) -> System.out.printf("%s %s; ", p.getFirstName(), p.getLastName()));
```

我们也可以定义过滤器,然后重用它们来执行其他操作:

```java
// 定义 filters  
Predicate<Person> ageFilter = (p) -> (p.getAge() > 25);  
Predicate<Person> salaryFilter = (p) -> (p.getSalary() > 1400);  
Predicate<Person> genderFilter = (p) -> ("female".equals(p.getGender()));  
  
System.out.println("下面是年龄大于 24岁且月薪在$1,400以上的女PHP程序员:");  
phpProgrammers.stream()  
          .filter(ageFilter)  
          .filter(salaryFilter)  
          .filter(genderFilter)  
          .forEach((p) -> System.out.printf("%s %s; ", p.getFirstName(), p.getLastName()));  
  
// 重用filters  
System.out.println("年龄大于 24岁的女性 Java programmers:");  
javaProgrammers.stream()  
          .filter(ageFilter)  
          .filter(genderFilter)  
          .forEach((p) -> System.out.printf("%s %s; ", p.getFirstName(), p.getLastName()));
```

#### 5注意事项

遍历循环和if结合使用不能抛出异常，只能捕获

![lambda_foreach](D:\software\resources\springcloud\gateway\spring-cloud-gateway-demo-Predicate\note\images\lambda_foreach.png)

##2 stream

代码示例

```java
System.out.println("根据 name 排序,并显示前5个 Java programmers:");  
List<Person> sortedJavaProgrammers = javaProgrammers  
          .stream()  
          .sorted((p, p2) -> (p.getFirstName().compareTo(p2.getFirstName())))  
          .limit(5)  
          .collect(toList()); //collect()操作完之后转换成的集合类型，toList()表示转成List
```

```java
System.out.println("将 PHP programmers 的 first name 拼接成字符串:");  
String phpDevelopers = phpProgrammers  
          .stream()  
          .map(Person::getFirstName)  
          .collect(joining(" ; ")); // 在进一步的操作中可以作为标记(token)     
  
System.out.println("将 Java programmers 的 first name 存放到 Set:");  
Set<String> javaDevFirstName = javaProgrammers  
          .stream()  
          .map(Person::getFirstName)  
          .collect(toSet());  
  
System.out.println("将 Java programmers 的 first name 存放到 TreeSet:");  
TreeSet<String> javaDevLastName = javaProgrammers  
          .stream()  
          .map(Person::getLastName)  
          .collect(toCollection(TreeSet::new));
```

## 3 jvm

给JVM设置-XX:+HeapDumpOnOutOfMemoryError参数，让JVM碰到OOM场景时输出 dump信息

**jvm可能是只对class加载到jvm中，部分文件应该是动态加载解析，例如md文件**，后续再研究

##4 Function 接口

```java
  ### 1 apply(),andThen()和compose
```

```java
public static void main(String[] args) {
        Function<Integer, Integer> name = e -> e * 2;
        Function<Integer, Integer> square = e -> e * e;
        int value = name.andThen(square).apply(3);
        System.out.println("andThen value=" + value);
        int value2 = name.compose(square).apply(3);
        System.out.println("compose value2=" + value2);
        //返回一个执行了apply()方法之后只会返回输入参数的函数对象
        Object identity = Function.identity().apply("huohuo");
        System.out.println(identity);
}
```

输出结果:

andThen value=36
compose value2=18
huohuo

##5 NIO

教程:

<https://mp.weixin.qq.com/s?__biz=MzI4Njg5MDA5NA==&mid=2247484235&idx=1&sn=4c3b6d13335245d4de1864672ea96256&chksm=ebd7424adca0cb5cb26eb51bca6542ab816388cf245d071b74891dd3f598ccd825f8611ca20c&token=1834317504&lang=zh_CN&scene=21#wechat_redirect>

易百教程: https://www.yiibai.com/java_nio/nio-timeserver.html

![nio](D:\software\resources\note\images\nio.png)

BIO

![bio](D:\software\resources\note\images\bio.png)



### 1buffer

nio通过buffer读取和写入数据，注意点

#### 1 每次读取数据前，buffer都要先清空

~~~xml-dtd
Clears this buffer. The position is set to zero, the limit is set to the capacity, and the mark is discarded.
Invoke this method before using a sequence of channel-read or put operations to fill this buffer. For example:
       buf.clear();     // Prepare buffer for reading
       in.read(buf);    // Read data
This method does not actually erase the data in the buffer, but it is named as if it did because it will most often be used in situations in which that might as well be the case
~~~

buffer.clear();

####  2 每次写入数据之前都要把buffer翻转过来

~~~xml-dtd
Flips this buffer. The limit is set to the current position and then the position is set to zero. If the mark is defined then it is discarded.
After a sequence of channel-read or put operations, invoke this method to prepare for a sequence of channel-write or relative get operations. For example:
       buf.put(magic);    // Prepend header
       in.read(buf);      // Read data into rest of buffer
       buf.flip();        // Flip buffer
       out.write(buf);    // Write header + data to channel
This method is often used in conjunction with the compact method when transferring data from one place to another
~~~

buffer.flip();

####3 在写入数据之前应该判断buffer是否还有数据

~~~xml-dtd
Tells whether there are any elements between the current position and the limit.
~~~

buffer.hasRemaining();

#### 4 ByteBuffer.allocateDirect()

这个方法直接分配本地内存，不归JVM管控，容易OOM，ByteBuffer.allocate()分配的是堆内存

解决OOM的一个办法是

```java
((DirectBuffer)byteBuffer).cleaner().clean();//清除buffer的本地内存
```

#### 5 大文件操作使用MappedByteBuffer

```java
MappedByteBuffer buff = channel.map(FileChannel.MapMode.READ_ONLY, 0,  channel.size()); 
```

#### 6 buffer操作

缓冲区存入数据

 buffer.put("1");

缓冲区写入数据

buffer.get();

### 2 selector

![selector](D:\software\resources\note\images\selector.png)







### 3 管道

java NIO管道用于在两个线程之间建立单向数据连接。它有一个槽通道和源通道。数据正在写入槽通道，然后可以从源通道读取该数据。

在Java NIO中，包`java.nio.channel.pipe`用于按顺序读取和写入数据。管道用于确保数据必须以写入管道的相同顺序读取

![pipe](D:\software\resources\note\images\pipe.png)



###4 nio包

![nioPackage](D:\software\resources\note\images\nioPackage.png)

### 5 IO在系统的运行过程

#### 5.1内核态和用户态

为了保证用户进程不能直接操作内核(kernel)，保证内核安全，操作系统把虚拟空间划分为两部分

![nio_内核态和用户态](D:\software\resources\springcloud\gateway\spring-cloud-gateway-demo-Predicate\note\images\nio_内核态和用户态.jpg)

### 6正则表达式 

| 元字符 | 描述                                      |
| ------ | ----------------------------------------- |
| .      | 表示任意字符                              |
| *      | 表示匹配任意次，包括0次                   |
| \|     | 表示或                                    |
| (abc)  | 表示匹配括号里的abc，不是匹配a,b,c,ab等等 |
| [abc]  | 表示匹配中括号里的abc任意组合             |

###7 字符串

java 字符串截取含头不含尾，字符的下标从0开始



##6线程

Thread.yield( )方法

让出cpu执行时间

使当前线程从**执行状态（运行状态）**变为**可执行态（就绪状态）**。cpu会**从众多的可执行态里选择**，也就是说，**当前也就是刚刚的那个线程还是有可能会被再次执行到的**，并不是说一定会执行其他线程而该线程在下一次中不会执行到了



###  [java.lang.NumberFormatException: multiple points问题

<https://www.cnblogs.com/ljy-20180122/p/9520621.html>

解决办法

1、建议在每个方法中都new一个新的SimpleDateFormat对象，这样子就可以避免这种问题。

2、也可以使用保存线程局部变量的ThreadLocal对象来保存每一个线程的SimpleDateFormat对象，小编主要说说第二种的使用，针对上述代码做的改变。

```java
package com.yongcheng.liuyang.utils;
 2 
 3 import java.text.ParseException;
 4 import java.text.SimpleDateFormat;
 5 import java.util.Date;
 6 
 7 /**
 8  *
 9  * 
10  * @author Administrator
11  *
12  */
13 public class DateUtils {
14 
15 private static final String format = "yyyy-MM-dd";
16     
17     //每一个线程
18     private static final ThreadLocal<SimpleDateFormat> threadLocal = new 
19             ThreadLocal<SimpleDateFormat>();
20     
21     public static Date covertDateStrToDate(String dateStr){
22         SimpleDateFormat sdf = null;
23         sdf = threadLocal.get();
24         if (sdf == null){
25             sdf = new SimpleDateFormat(format);
26         }
27         //
28         Date date = null;
29         try {
30             System.out.println("当前线程为:" + Thread.currentThread().getName());
31             date = sdf.parse(dateStr);
32         } catch (ParseException e) {
33             e.printStackTrace();
34         }
35         
36         return date;
37     }
38 }
```



## 7 线程池

在线程池创建之后，等待提交任务请求

1 当调用execute()方法时，线程池判断当前工作的线程数是否大于核心线程数

2 如果当前工作线程数量小于核心线程数，则直接创建线程执行任务

3 如果当前工作的线程数量大于等于核心线程数，就将任务加入队列

4 如果队列已满且当前工作线程数量小于最大线程数，则创建新的线程来执行任务

5 如果队列已满且当前工作线程数量大于等于最大线程数，就启动拒绝策略来拒绝任务提交请求

**当一个线程闲置时间大于keepAliveTime参数指定的时间，线程池就判断当前线程数是否大于核心线程数，大于则回收该线程**

#### 7.2队列

当阻塞队列是空的时候，从队列中获取元素将被阻塞

当阻塞队列是满的时候，从队列中添加元素将被阻塞

使用队列的好处是:不需要操作什么时候阻塞线程，什么时候唤醒线程，统一是线程从队列获取任务

| 队列                | 描述                                        |
| ------------------- | ------------------------------------------- |
| ArrayBlockingQueue  | 数组结构的有界队列                          |
| LinkedBolckingQueue | 链表结构的有界队列，默认是Integer.MAX_VALUE |
| SynchronousQueue    | 不存储元素的阻塞队列，单个元素队列          |
| LinkedBlockingDeque | 链表结构的双向队列                          |
| LinkedTransferQueue | 链表结构无解队列                            |
|                     |                                             |
|                     |                                             |

#### 7.2.2ArrayBlockingQueue

ArrayBlockingQueue在初始化时需要指定容量，在增加元素是，当队列已满，再增加元素会抛出异常

1 使用add()在队列满了之后会抛错，add方法本质上也是调用offer方法增加元素

```java
public boolean add(E e) {
        if (offer(e))
            return true;
        else
            throw new IllegalStateException("Queue full");
    }
```

2 offer()在队列满之后不再添加元素，也不抛错，会返回false,如果没有满则添加元素并返回true,**重载方法设置阻塞的等待时间**

```java
public boolean offer(E e) {
        checkNotNull(e);
        final ReentrantLock lock = this.lock;
        lock.lock();
        try {
            if (count == items.length)
                return false;
            else {
                enqueue(e);
                return true;
            }
        } finally {
            lock.unlock();
        }
    }
```

3 poll()会取出元素之后删除当前元素，有**重载方法设置阻塞的等待时间**

```java
 private E dequeue() {
        // assert lock.getHoldCount() == 1;
        // assert items[takeIndex] != null;
        final Object[] items = this.items;
        @SuppressWarnings("unchecked")
        E x = (E) items[takeIndex];
     //清空当前元素
        items[takeIndex] = null;
        if (++takeIndex == items.length)
            takeIndex = 0;
        count--;
        if (itrs != null)
            itrs.elementDequeued();
        notFull.signal();
        return x;
    }
```

4 peek()只是取出元素，不删除元素

5 take和poll方法也是取出元素就删除，take是在队列清空之后会阻塞等待

6 put方法和offer()一样都可以添加元素，不同的事put在队列满了之后会阻塞等待

#### 7.3拒绝策略

AbortPolicy: 直接抛出异常RejectExecutionException，

CallerRunsPolicy:不抛异常，也不丢弃任务，将任务退回给调用者

DiscardOldestPolicy:抛弃队列中等待时间最长的任务，尝试把当前提交给当前任务

DicardPolicy:直接丢弃任务



### 8 return 和 finally

return 和finally的执行顺序，1先执行finally2 再执行return

![return和finally](D:\resources\study\note\images\return和finally.png)



### 9 final

####1 final修饰的类不能被继承

 final类的成员方法都被隐式指定为final

####2 final修饰的方法不被重写

####3 final修饰的变量必须初始化，且只能初始化一次,

#### 3.1变量 的赋值必须有两种 

##### 3.1.1 在声明时赋值

#####3.1.2 只是声明，在构造方法赋值

##### 3.1.3 变量是引用类型

**final修饰引用类型的变量，引用地址不可改变，但是引用对象内容可以改变**



### 10 元空间

对于字符串：其对象的**引用**都是存储在**栈**中的，如果是**编译期**已经创建好(**直接用双引号定义的**)的就存储在常量池中，如果是**运行期（new出来的）**才能确定的就存储在**堆**中。对于equals相等的字符串，在常量池中永远只有一份，在堆中可能有多份。

String s = new String(“xyz”);产生几个对象？一个或两个，如果常量池中原来没有”xyz”,就是两个

**成员变量**存储在堆中的对象里面，由垃圾回收器负责回收

**静态变量对象也是在堆内存分配**



###11 Deque

双端队列

就是可以从队列的头部和尾部增加或者取出元素

常见的实现是:LinkedList



### 11 ConcurrentHashMap

1 默认有16个Node数组对象，当整个数组为空，使用cas添加元素

2 取出一个Node对象,然后Node

3 当计算下标，取出一个桶，然后synchonized加锁取出的一个Node对象，然后添加元素