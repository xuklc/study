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

