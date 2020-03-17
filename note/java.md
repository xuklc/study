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

#### 1 final修饰的类不能被继承

 final类的成员方法都被隐式指定为final

#### 2 final修饰的方法不被重写

#### 3 final修饰的变量必须初始化，且只能初始化一次,

#### 3.1变量 的赋值必须有两种 

##### 3.1.1 在声明时赋值

##### 3.1.2 只是声明，在构造方法赋值

##### 3.1.3 变量是引用类型

**final修饰引用类型的变量，引用地址不可改变，但是引用对象内容可以改变**



### 10 元空间

对于字符串：其对象的**引用**都是存储在**栈**中的，如果是**编译期**已经创建好(**直接用双引号定义的**)的就存储在常量池中，如果是**运行期（new出来的）**才能确定的就存储在**堆**中。对于equals相等的字符串，在常量池中永远只有一份，在堆中可能有多份。

String s = new String(“xyz”);产生几个对象？一个或两个，如果常量池中原来没有”xyz”,就是两个

**成员变量**存储在堆中的对象里面，由垃圾回收器负责回收

**静态变量对象也是在堆内存分配**



### 11 Deque

双端队列

就是可以从队列的头部和尾部增加或者取出元素

常见的实现是:LinkedList



### 11 ConcurrentHashMap

1 默认有16个Node数组对象，当整个数组为空，使用cas添加元素

2 取出一个Node对象,然后Node

3 当计算下标，取出一个桶，然后synchonized加锁取出的一个Node对象，然后添加元素



### 12 构造方法

1 默认提供无参的构造方法

2 当自己写构造方法之后，java不再提供无参构造方法，需要无参构造方法需要自己手写

### 13 yield,join,sleep

#### 13.1 yield

让出cpu时间片段，当前线程从运行状态转为可运行状态，但不释放对象锁，但是可以重新竞争cpu执行时间

不能执行睡眠时间，

#### 13.2 sleep

sleep指定睡眠时间，从运行态(running)到sleeping

#### 13.3 join

等待调用join()的线程结束，如t.join();//主要用于等待t线程执行结束

~~~java
public class JoinThread {

    public static  void main(String[]args) throws InterruptedException {

        JoinThreads joinThreads = new JoinThreads("join");
        joinThreads.start();
        /**
        *不加join()则main线程和joinThreads子线程互相竞争，执行没有先后顺序，有多结果
        结果1
        0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;--------------
main thread0;main thread1;main thread2;main thread3;main thread4;main thread5;main thread6;main thread7;main thread8;main thread9;--------------
       结果2 
       --------------
0;main thread0;1;2;3;4;5;6;7;8;9;10;11;12;13;main thread1;14;15;16;main thread2;17;main thread3;18;main thread4;19;main thread5;main thread6;main thread7;main thread8;main thread9;-------------- 
        */
        joinThreads.join();
        System.out.println("--------------");
        for (int i=0;i<10;i++){
            System.out.print("main thread"+i+";");
        }
        System.out.println("--------------");

    }
}
class  JoinThreads  extends Thread{
    private String name;
    public JoinThreads(String name){
        this.name=name;
    }

    public void run(){
        for (int i=0;i<20;i++){
            System.out.print(i);
        }
    }
}
~~~



### 14锁深度应用

#### 14.1 公平锁和非公平锁

公平锁:是指多个线程按照申请锁的顺序来获取锁，类似排队打饭，先来后到，遵循先进先出

非公平锁:是指多个线程获取锁的顺序并不是按照申请锁的顺序，有可能后申请的线程比先申请的线程优先获取锁，在高并发的情况下，有可能造成优先级反转或饥饿现象

**非公平锁是直接竞争，如果竞争失败，则采用类似公平锁的方式**

**ReentrantLock有参构造方法，boolean 参数默认是false,所以默认是非公平锁**

#### 14.2 可重入锁(递归锁)

ReentrantLock和synchronized是典型的可重入锁,非公平锁

**可以避免死锁，不代表不会死锁**

**ReentrantLock调用lock，一定调用unlock方法解锁，并且是加锁几次就解锁几次，例子如下**

~~~java
public class LockTest{
    ReentrantLock lock = new ReentrantLock();
	public void lockTest(){
        //加锁两次
    	lock.lock();
        lock.lock();
        try{
            // todo
        }finally{
            //解锁两次，否则死锁
            lock.unlock();
            lock.unlock();
        }
	}    
}

~~~



例子

~~~java
// 当线程获取锁进入method1之后，虽然method2也是同步加锁代码，但是不需要再去获取锁，和method1用同一把锁
public synchronized void methdo1(){
    method2();
}
public synchronized void method2(){
    
}

~~~
#### 14.3 自旋锁

是指尝试获取锁的线程不会立即阻塞，而是采用循环的方式尝试获取锁，这样的好处是减少线程上下文切换的资源消耗，坏处是消耗cpu

#### 14.4读写锁

读写锁共存情况:

读--读共存

读--写不能共存

写--写不能共存

##### 14.1独占锁

指该锁一次只能被一个线程持有，ReentrantLock和synchronized都是独占锁



### 15 hashcode

**两个hashcode相等的对象不一定是相等的对象,hashcode相等只能保证两个对象在一个HASH表里的同一条HASH链上，继而通过equals方法才能确定是不是同一对象**

hashcode 不是代表 对象所在内存地址

 hashCode 的一般约定:

- 在 Java 应用程序中，任何时候对同一对象多次调用 hashCode 方法，都必须一直返回同样的整数，对它提供的信息也用于对象的相等比较，且不会被修改。这个整数在两次对同一个应用程序的执行不中不需要保持一致。
- 如果两个对象通过 equals(Object) 方法来比较相等，那么这两个对象的 hashCode 方法必须产生同样的整型结果。
- 如果两个对象通过 equals(Object) 方法比较结果不等，这两个对象的 hashCode 不必产生同不整型结果。然而，开发者应该了解对不等的对象产生不同的整型结果有助于提高哈希表的性能



**java规范要求对于同一个对象每次生成的hashcode必须相同**

**java规范要求两个equals的对象一定要有相同的hashcode**

### 16volatile

#### 16.1禁止指令重排

指令重排三步骤

1 编译器优化重排

2 指令并行重排

3 内存系统重排

volatile禁止指令重排

![volatile禁止指令重排](F:\workspace\idea\study\study\note\images\volatile禁止指令重排.png)

volatile禁止指令重排2



![volatile禁止指令重排2](F:\workspace\idea\study\study\note\images\volatile禁止指令重排2.png)

多线程环境下指令重排会导致结果不可预测

例如 进行指令重排后，代码的结果变成

~~~java
public void  method01(){
    flag=true;
    a=1;
}
public void method02(){
    if(flag){
        a=a+5;
        System.out.println("value"+a);
    }
}
~~~

在**多线程**环境下，线程1执行method01()，然后flag=true(a=1还没有被执行);这个时候线程2刚好执行method02,结果就变成a=a+5的结果是5；

#### 16.2Memory Barrier内存屏障(内存栅栏)

**是一个CPU指令,编译器和处理器都能执行指令优化，如果在指令间插入内存屏障(memory)则会告诉编译器和CPU,不管什么指令都不能和Memory Barrier指令重排序，通过插入内存屏障禁止在内存屏障的前后的指令执行重排序优化内存屏障的另外一个作用就是强制刷各种CPU的缓存数据**

 作用1 保证特定操作的执行顺序

作用2 保证某些变量的可见性(利用该特性实现volatile的可见性)

### 17synchronized和lock的区别

#### 17.1 notify()

方法notify（）通知任何一个线程任意唤醒。确切唤醒哪个线程的选择是非确定性的 ，取决于实现。

由于notify（）唤醒了一个随机线程，因此它可用于实现线程执行类似任务的互斥锁定，但在大多数情况下，实现notifyAll（）会更可行

#### 17.2synchronized(重要)

在JAVA中的Object类型中，都是带有一个内存锁的，在有线程获取该内存锁后，其它线程无法访问该内存，从而实现JAVA中简单的同步、互斥操作

synchronized就是针对内存区块申请内存锁，[this关键字](https://www.baidu.com/s?wd=this关键字&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)代表类的一个对象，所以其内存锁是针对相同对象的互斥操作，而static成员属于类专有，其内存空间为该类所有成员共有，这就导致synchronized()对static成员加锁，相当于对类加锁，也就是在该类的所有成员间实现互斥，在同一时间只有一个线程可访问该类的实例。如果只是简单的想要实现在JAVA中的线程互斥，明白这些基本就已经够了。但如果需要在线程间相互唤醒的话就需要借助Object.wait(), Object.nofity()了

**Obj.wait()，与Obj.notify()必须要与synchronized(Obj)一起使用,语法角度来说就是Obj.wait(),Obj.notify必须在synchronized(Obj){...}语句块内**

**有一点需要注意的是notify()调用后，并不是马上就释放对象锁的，而是在相应的synchronized(){}语句块执行结束，自动释放锁后，JVM会在wait()对象锁的线程中随机选取一线程，赋予其对象锁，唤醒线程，继续执行**

**调用obj的wait(), notify()方法前，必须获得obj锁**

### 18 Function和BiFunction

**定义一个方法就可以实现多种功能**

~~~java
public int compute(int a, Function<Integer, Integer> function) {
    int result = function.apply(a);
    return result;
}
~~~

~~~java
test.compute(5,value -> value * value) //25 计算平方
test.compute(5,value -> value + value) //10 求和
test.compute(5,value -> value - 2) //3 
~~~

andThen方法源码

**在目标方法之后再执行一次，逻辑一样**

BiFunction和Function的区别是BiFunction可以接受两个参数

~~~java
default <V> BiFunction<T, U, V> andThen(Function<? super R, ? extends V> after) {
        Objects.requireNonNull(after);
        return (T t, U u) -> after.apply(apply(t, u));
    }
~~~



### 19FastDateFormat



### 20`<init>`与`<clinit>`

Java在编译之后会在字节码文件中生成`<init>`方法，称之为实例构造器，该实例构造器会将语句块，变量初始化，调用父类的构造器等操作收敛到`<init>`方法中，收敛顺序（这里只讨论非静态变量和语句块）为：

  1父类变量初始化
2. 父类语句块
3. 父类构造函数
4. 子类变量初始化
5. 子类语句块
6. 子类构造函数

**所谓收敛到`<init>`方法中的意思就是，将这些操作放入到`<init>`中去执行**

Java在编译之后会在字节码文件中生成`<clinit>`方法，称之为**类构造器**，类构造器同实例构造器一样，也会将静态语句块，静态变量初始化，收敛到`<clinit>`方法中，收敛顺序为：

1. 父类静态变量初始化
2. 父类静态语句块
3. 子类静态变量初始化
4. 子类静态语句块

**`<clinit>`方法是在类加载过程中执行的，而`<init>`是在对象实例化执行的，所以`<clinit>`一定比`<init>`先执行**

**java默认的执行顺序是从上到下**

**变量没有多态性，变量的调用是根据声明的引用变量来的**

#### 执行顺序

1 父类的静态变量和父类的静态代码块，两者的执行顺序取决于上下的顺序

2 子类的静态变量和子类的静态代码块，两者的执行顺序取决于上下的顺序

3 父类的实例变量和代码块，两者的执行顺序取决两者的上下的顺序

4 父类的构造方法

5 子类的实例变量和代码块,两者的执行顺序取决两者的上下的顺序

6 子类的构造方法

**注意:子类调用父类的构造方法默认是无参的构造方法，除非用super(xx)显式调用父类的有参构造方法，所以当自行提供有参构造方法之后，子类需要显式父类的构造方法，因为只有当没有构造方法，java才自动提供无参构造方法**

### 21强转

1 基本类型是大范围转小范围需要强转,小范围到大范围不需要

  例子 

~~~java
public int a=2;
public short b=3;
b=(short)a;
~~~

2 高精度到到低进度也需要强转

~~~java
{
        System.out.println("父类代码块:,"+this.a);
    }
     int a=2;
    public static int b=5;
    public String c="c";
    public static long d=0;
    public static float f=1f;
    public static  short g=1;
    // int转double不需要强转
    public static double e=0;
    static{
        System.out.println("父类静态代码块:,"+b);
    }

    public Parent(){
        System.out.println("父类无参构造方法:,"+b);
    }
    public Parent(int a){
        this.a=a;
        //大范围转小范围需要强转
        this.g=(short) this.a;
        //高精度到到低进度也需要强转
        this.a=(int)this.e;
        System.out.println("父类有参构造方法:,"+b);
    }
~~~

### 定时任务

ScheduledExecutorService本质上和普通的线程池有两点区别

1 最大线程数是:Integer.MAX_VALUE

2 最大的区别点是使用DelayedWorkQueue队列

 new ScheduledExecutorService().schedule()创建**执行一次**的延迟任务，**不是周期性任务**

###  DelayedWorkQueue 

 使用优先级队列DelayedWorkQueue，保证添加到队列中的任务，会按照任务的延时时间进行排序，延时时间少的任务首先被获取 

最大线程数是:Integer.MAX_VALUE

### 枚举

https://www.cnblogs.com/VergiLyn/p/6753706.html

1 重写enum的toString()

   ~~~java
JSON.toJSONString(SongsEnum.STYLE,SerializerFeature.WriteEnumUsingToString)
   ~~~

2   fastjson的config设置 

~~~java
config.configEnumAsJavaBean(SongsEnum.class);
    String s = JSON.toJSONString(SongsEnum.SOUND_OF_SILENCE, config);
~~~

### CompletableFuture VS Future

https://blog.csdn.net/zhangyu_h321/article/details/55102085

https://www.jianshu.com/p/cd5c9a21ff5d

https://blog.csdn.net/zhangyu_h321/article/details/55102085

https://www.jianshu.com/p/73aaec23009d

**Future只是一个接口，接受Callable的返回值**

FutureTask是Future接口的一个实现类

ForkJoinPool.commonPool()

**CompletableFuture的回调方法，CompletableFuture.runAsync().thenAcceptAsync(),CompletableFuture.thenApplyAsync().thenAcceptAsync()**

### rxJava

https://zhuanlan.zhihu.com/p/20687307

| 名称       | 解释                               |
| ---------- | ---------------------------------- |
| create()   | 创建最简单的事件流                 |
| from()     | 创建事件流，可发送不同类型的数据流 |
| just()     | 创建事件流，可发送多个参数的数据流 |
| defer()    | 创建事件流，可缓存可激活事件流     |
| interval() | 创建延时重复的事件流               |
| range()    | 创建事件流，可发送范围内的数据流   |
| repeat()   | 创建可重复次数的事件流             |
| timer()    | 创建一次延时的事件流               |

***补充：interval()、timer()、delay()的区别***
interval():用于创建事件流，周期性重复发送
timer():用于创建事件流，延时发送一次
delay():用于事件流中，可以延时某次事件流的发送

*背压的概念是在平时业务开发时较为常见，大多数是针对高并发的业务，背压是必须考虑的因素之一。*
在异步场景中，由于数据流的发射速度高于数据流的接收速度，就会导致数据不能及时处理，从而导致数据流的阻塞。**背压所要做的事情就是主动控制数据流发射的速度**

https://blog.csdn.net/qq_35928566/article/details/86157107

https://www.imooc.com/article/68834

#### 基本概念

ObserverSubscriber

1 Observable--发出一系列事件，事件的生产者  

2 Subscriber--负责处理事件，事件的消费者

3 Operator--对Observable发出的事件进行修改和变换

**处理流程是Observable-->Operator(可以省略)-->Subscrible**

区分回调动作

RxJava 自身提供了精简回调方式，我们可以为 Subscriber 中的三种状态根据自身需要分别创建一个回调动**Action**

我们可以根据当前需要，传入对应的 Action， RxJava 会相应的自动创建 Subscriber

Action0 表示一个无回调参数的Action；

Action1 表示一个含有一个回调参数的Action；

当然，还有Action2 ~ Action9，分别对应2~9个参数的Action

#### 线程控制

1. **`Schedulers.io()`**: I/O 操作（读写文件、数据库、网络请求等），与`newThread()`差不多，区别在于io() 的内部实现是是用一个无数量上限的线程池，可以重用空闲的线程，因此多数情况下 `io()` 效率比 `newThread()` 更高。值得注意的是，在 `io()` 下，不要进行大量的计算，以免产生不必要的线程；

2. **`Schedulers.newThread()`**: 开启新线程操作；

3. **`Schedulers.immediate()`**: 默认指定的线程，也就是当前线程； 

    RxJava 2.x 中已经没有了Schedulers.immediate() 这个线程环境，还有Schedulers.test()

4. **`Schedulers.computation()`**:计算所使用的调度器。这个计算指的是 CPU 密集型计算，即不会被 I/O等操作限制性能的操作，例如图形的计算。这个 Scheduler 使用的固定的线程池，大小为 CPU 核数。值得注意的是，不要把 I/O 操作放在 `computation()` 中，否则 I/O 操作的等待时间会浪费 CPU；

5. **`AndroidSchedulers.mainThread()`**: RxJava 扩展的 Android 主线程；

我们可以通过 `subscribeOn()` 和 `observeOn()` 这两个方法来进行线程调度。举个栗子：

~~~java
final ImageView ivLogo = (ImageView) findViewById(R.id.ivLogo);

Observable.create(new Observable.OnSubscribe<Drawable>() {    @Override
    public void call(Subscriber<? super Drawable> subscriber) {        try {
            Drawable drawable = Drawable.createFromStream(new URL("https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=2502144641,437990411&fm=80&w=179&h=119&img.JPEG").openStream(), "src");
            subscriber.onNext(drawable);
        } catch (IOException e) {
            subscriber.onError(e);
        }
    }
})        // 指定 subscribe() 所在的线程，也就是上面call()方法调用的线程
        .subscribeOn(Schedulers.io())        // 指定 Subscriber 回调方法所在的线程，也就是onCompleted, onError, onNext回调的线程
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new Subscriber<Drawable>() {            @Override
            public void onCompleted() {

            }            @Override
            public void onError(Throwable e) {
                Log.e(TAG, e.toString());
            }            @Override
            public void onNext(Drawable drawable) {
                ivLogo.setImageDrawable(drawable);
            }
        });
~~~

#### 变换

将发送的事件或事件序列，加工后转换成不同事件或事件序列

1 map操作符

2 flagMap操作符

####　Retrofit





### CallerSensitive

```rust
这个注解是为了堵住漏洞用的。曾经有黑客通过构造双重反射来提升权限，
原理是当时反射只检查固定深度的调用者的类，看它有没有特权，
例如固定看两层的调用者（getCallerClass(2)）。如果我的类本来没足够
权限群访问某些信息，那我就可以通过双重反射去达到目的：反射相关
的类是有很高权限的，而在 我->反射1->反射2 这样的调用链上，反射2
检查权限时看到的是反射1的类，这就被欺骗了，导致安全漏洞。
使用CallerSensitive后，getCallerClass不再用固定深度去寻找
actual caller（“我”），而是把所有跟反射相关的接口方法都标注上
CallerSensitive，搜索时凡看到该注解都直接跳过，这样就有效解决了
前面举例的问题
```

