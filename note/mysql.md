官网

https://www.mysql.com/cn/why-mysql/performance/

## 1 sql语句

 **1.禁止使用count（常量）或者count（列名），因为它们避免不了NULL值    用count(\*)来计算条数**

2 禁用保留字，如 desc 、 **range** 、 match 、 delayed 等，请参考 MySQL 官方保留字

**like只有右边匹配才用索引,LIKE 'ptd_%'**

##2 索引

**MySQL只能使用B-Tree索引做覆盖索引**

### 1 覆盖索引

**Extra中为Using index**

 MySQL 并不是跳过 offset 行，而是取 offset + N 行，然后返回放弃前 offset 行，返回
N 行，那当 offset 特别大的时候，效率就非常的低下，要么控制返回的总页数，要么对超过
特定阈值的页数进行 SQL 改写

例子:

SELECT a.* FROM 表 1 a, (select id from 表 1 where 条件 LIMIT 100000,20 ) b where a.id=b.id

##instr

INSTR(STR,SUBSTR) 

在一个**字符串(STR)**中搜索**指定的字符(SUBSTR)**,返回发现指定的字符的**位置(INDEX)**,**如果没有找到就直接返回0**



##正则表达式

| 元字符 | 描述                       |
| ------ | -------------------------- |
| _      | 表示单个字符               |
| ^      | 匹配字符串开始位置         |
| $      | 匹配字符串结束位置         |
| *      | 0个或者多个匹配            |
| +      | 个或者多个匹配（等于{1,}） |
| {n}    | 指定数目的匹配             |
| {n,}   | 不少于指定数目的匹配       |
| {n,m}  | 匹配数目的范围             |

##And 和OR执行顺序

**SQL语句碰到OR时，就会自动把条件分成2部分，等于两部分都加了括号！**

**如果where 后面有OR条件的话，则OR自动会把左右的查询条件分开**

例子1



##find_in_set

**注意 find_in_set 是全表扫描的**

####**语法：**FIND_IN_SET(str,strlist)

1. 假如**字符串**str*在由*N子链组成的**字符串列表**strlist*中，则返回值的范围在1到*N*之间

2. 一个字符串列表就是一个由一些被‘,’符号分开的自链组成的字符串
3. 如果第一个参数是一个常数字符串，而第二个是typeSET列，则FIND_IN_SET()函数被优化，使用**比特**计算
4. 如果*str*不在*strlist*或*strlist*为空字符串，则返回值为0
5. 如任意一个参数为NULL，则返回值为NULL。这个函数在第一个参数包含一个逗号(‘,’)时将无法正常运行

示例：**SELECT FIND_IN_SET('b','a,b,c,d');** //返回值为2，即第2个值

例子2:下面查询**btype字段中**包含**”15″这个参数的值**

```sql
SELECT * from test where FIND_IN_SET('15',btype)
```

##sql执行顺序

(1)from 

(2) on 

(3) join

(4) where 

(5)group by(开始使用select中的别名，后面的语句中都可以使用)

(6) avg,sum.... 

(7)having 

(8) select 

(9) distinct 

(10) order by 

##left join

**如果连接方式是inner join，在没有其他过滤条件的情况下MySQL会自动选择小表作为驱动表，但是left join在驱动表的选择上遵循的是左边驱动右边的原则，即left join左边的表名为驱动表**

##STRAIGHT_JOIN

**在STRAIGHT_JOIN左边的表名就是驱动表**

**驱动表的概念，mysql中指定了连接条件时，满足查询条件的记录行数少的表为驱动表；如未指定查询条件，则扫描行数少的为驱动表。mysql优化器就是这么粗暴以小表驱动大表的方式来决定执行顺序的**

##慢查询

###慢查询日志开启

在配置文件my.cnf或my.ini中在[mysqld]一行下面加入两个配置参数

log-slow-queries=/data/mysqldata/slow-query.log           

long_query_time=5

log-slow-queries参数为慢查询日志存放的位置，一般这个目录要有mysql的运行帐号的可写权限，一般都将这个目录设置为mysql的数据存放目录；

long_query_time=5中的**5表示查询超过五秒才记录**

还可以在my.cnf或者my.ini中添加log-queries-not-using-indexes参数，表示记录下没有使用索引的查询

##order by

要尽可能的保证排序字段在驱动表中

排序要避免Using filesort，Using temporary

如果排序查询的数据两大于这个默认值的话，还是会使用Using filesort，order by 出现using filesort的常规解决办法是建索引，或者组合索引

![filesort](D:\resources\study\note\images\filesort.png)

##explain

<https://www.jianshu.com/p/73f2c8448722>

###id

id相同，从上往下执行，id不同，如果是子查询，则序号会递增，id值越大优先级越高，越先被执行

- **id 为 null**： 最后执行

- 如果id相同，则认为是一组，从上往下顺序执行；**在所有组中，id值越大，优先级越高，越先执行**

### rows

rows：MYSQL认为必须检查的用来返回请求数据的行数

### key

实际使用的索引，如果为空表示没有使用索引

### key_len

使用索引的长度，在不损失精确度的情况下，长度越短越好

###type

这是重要的列，显示连接的类型，从最好到最差是 **ALL, index,  range, ref, eq_ref, const, system, NULL**

#### eq_ref

唯一性索引扫描，对于每个索引建，表中只有一条记录与之匹配，常见于主键或者唯一性扫描

####ref

非唯一性索引扫描，返回匹配某个单独值的所有行，本质上也是一种索引访问，它返回所有匹配某个单独值的行，然而它可能会找到多个符合条件的行

#### range

只检索给定范围的行，使用一个索引来选择行，key列显示使用了哪个索引

#### index

Full Index Scan ,index和All区别为index类型只遍历索引树

#### All

Full Table Scan，全表扫描

### select_type

1 simple 2 primary 3 subquery 4 derived  5 union 6 union result

#### 1 simple

简单select 查询，不包含子查询或union

#### 2 primary

查询包含任何复杂的子部分，最外层被标记为primary

#### 3 subquery

在select或where中包含子查询

#### 4 derived

在from列表中包含子查询被标记为derived(衍生)，mysql会递归执行子查询，把结果放在临时表

DERIVED：用于 from 子句里有子查询的情况。MySQL 会递归执行这些子查询，把结果放在临时表里

#### 5 union

若第二个select出现在union之后，则被标记为union,若union包含在from子句的子查询中，外层select将被标记为derived

#### 6 union result

UNION RESULT：UNION 的结果

### 索引

索引文件具有**B-tree**的最左前缀匹配特性，如果左边的值未确定，那么无法使用此索引

复合索引生效遵循最左匹配原则，index(a,b,c)，

1 a

 2 a,b,c

3 a,b

4 a,c  **这四种情况都生效**



5 b,c

6 c

7 b  **都不生效**

### ref

上述表的连接匹配条件，即哪些列或常量被用于查找索引列的值

### extra

#### using temporary

第一种(子查询,适合子查询部分不作为查询条件)

子查询暂时有两种 1 在from子句中使用子查询 2 where子句中用exists子查询

暂时不知left join 是否导致using temporary

第二种 非直接关联变直接关联，慎用left join



A：distinct：在select部分使用了distinc关键字
 B：no tables used：不带from字句的查询或者From dual查询
 C：使用not in()形式子查询或not exists运算符的连接查询，这种叫做反连接。即，一般连接查询是先查询内表，再查询外表，反连接就是先查询外表，再查询内表。
 D：using filesort：排序时无法使用到索引时，就会出现这个。常见于order by和group by语句中
 E：using index：查询时不需要回表查询，直接通过索引就可以获取查询的数据。
 F：using join buffer（block nested loop），using join buffer（batched key accss）：5.6.x之后的版本优化关联查询的BNL，BKA特性。主要是减少内表的循环数量以及比较顺序地扫描查询。
 G：using sort_union，using_union，using intersect，using sort_intersection：
 using intersect：表示使用and的各个索引的条件时，该信息表示是从处理结果获取交集
 using union：表示使用or连接各个使用索引的条件时，该信息表示从处理结果获取并集
 using sort_union和using sort_intersection：与前面两个对应的类似，只是他们是出现在用and和or查询信息量大时，先查询主键，然后进行排序合并后，才能读取记录并返回。
 H：using temporary：表示使用了临时表存储中间结果。临时表可以是内存临时表和磁盘临时表，执行计划中看不出来，需要查看status变量，used_tmp_table，used_tmp_disk_table才能看出来。
 I：using where：表示存储引擎返回的记录并不是所有的都满足查询条件，需要在server层进行过滤。查询条件中分为限制条件和检查条件，5.6之前，存储引擎只能根据限制条件扫描数据并返回，然后server层根据检查条件进行过滤再返回真正符合查询的数据。5.6.x之后支持ICP特性，可以把检查条件也下推到存储引擎层，不符合检查条件和限制条件的数据，直接不读取，这样就大大减少了存储引擎扫描的记录数量。extra列显示using index condition
 J：firstmatch(tb_name)：5.6.x开始引入的优化子查询的新特性之一，常见于where字句含有in()类型的子查询。如果内表的数据量比较大，就可能出现这个
 K：loosescan(m..n)：5.6.x之后引入的优化子查询的新特性之一，在in()类型的子查询中，子查询返回的可能有重复记录时，就可能出现这个

### filtered

使用explain extended时会出现这个列，5.7之后的版本默认就有这个字段，不需要使用explain extended了。这个字段表示存储引擎返回的数据在server层过滤后，剩下多少满足查询的记录数量的比例，注意是百分比，不是具体记录数

### profile

SHOW VARIABLES LIKE '%profiling%';

profiling off表示profile关闭，profiling_history_size 15表示保存最近15条SQL的资源消耗情况

开启profile功能，可以使用命令

```sql
set global profiling = 1;
```

然后就可以使用下面命令

```sql
show profiles;
```

####使用案例

![show_profiles](D:\resources\study\note\images\show_profiles.png)

显示一条SQL的具体花销在哪里

![profile_for_query](D:\resources\study\note\images\profile_for_query.png)



#### Sending data

是包括**收集 + 发送 数据**。
这里的关键是为什么要收集数据，原因在于：mysql使用**索引**完成查询结束后，mysql得到了一堆的**行id**，如果有的列并不在索引中，mysql需要重新到**数据行**上将需要返回的数据读取出来返回个客户端。



### possible_keys

这一列显示查询**可能**使用哪些索引来查找

**将 mod(id, '16')= '5' 函数转换条件放在子查询外层**



## date_format

```mysql
DATE_FORMAT(date,format)
```

| 格式 | 描述                                           |
| ---- | ---------------------------------------------- |
| %a   | 缩写星期名                                     |
| %b   | 缩写月名                                       |
| %c   | 月，数值                                       |
| %D   | 带有英文前缀的月中的天                         |
| %d   | 月的天，数值(00-31)                            |
| %e   | 月的天，数值(0-31)                             |
| %f   | 微秒                                           |
| %H   | 小时 (00-23)                                   |
| %h   | 小时 (01-12)                                   |
| %I   | 小时 (01-12)                                   |
| %i   | 分钟，数值(00-59)                              |
| %j   | 年的天 (001-366)                               |
| %k   | 小时 (0-23)                                    |
| %l   | 小时 (1-12)                                    |
| %M   | 月名                                           |
| %m   | 月，数值(00-12)                                |
| %p   | AM 或 PM                                       |
| %r   | 时间，12-小时（hh:mm:ss AM 或 PM）             |
| %S   | 秒(00-59)                                      |
| %s   | 秒(00-59)                                      |
| %T   | 时间, 24-小时 (hh:mm:ss)                       |
| %U   | 周 (00-53) 星期日是一周的第一天                |
| %u   | 周 (00-53) 星期一是一周的第一天                |
| %V   | 周 (01-53) 星期日是一周的第一天，与 %X 使用    |
| %v   | 周 (01-53) 星期一是一周的第一天，与 %x 使用    |
| %W   | 星期名                                         |
| %w   | 周的天 （0=星期日, 6=星期六）                  |
| %X   | 年，其中的星期日是周的第一天，4 位，与 %V 使用 |
| %x   | 年，其中的星期一是周的第一天，4 位，与 %v 使用 |
| %Y   | 年，4 位                                       |
| %y   | 年，2 位                                       |

常用:

date_format(date,'%Y-%m-%d %H:%i:%s')

##TIMESTAMPDIFF

TIMESTAMPDIFF(unit,datetime_expr1,datetime_expr2)

unit值如下:

FRAC_SECOND (microseconds), SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR

###例子

\#计算两日期之间相差多少周

select timestampdiff(week,'2011-09-30','2015-05-04');

\#计算两日期之间相差多少天

select timestampdiff(day,'2011-09-30','2015-05-04');

### FROM_UNIXTIME

语法:FROM_UNIXTIME(unix_timestamp,format)

例子

FROM_UNIXTIME(create_time/1000,'%Y-%m-%d %H:%i:%S')

sql

### mysql varchar

```sql
首先要确定mysql版本
4.0版本以下，varchar(50)，指的是50字节，如果存放UTF8汉字时，只能存16个（每个汉字3字节） 
5.0版本以上，varchar(50)，指的是50字符，无论存放的是数字、字母还是UTF8汉字（每个汉字3字节），都可以存放50个
```

### show processlist

processlist命令的输出结果**显示了有哪些线程在运行**，不仅可以查看当前所有的连接数，还可以查看当前的连接状态帮助识别出有问题的查询语句等。

如果是root帐号，能看到所有用户的当前连接。如果是其他普通帐号，则只能看到自己占用的连接。showprocesslist只能列出当前100条。如果想全部列出，可以使用**SHOW FULL PROCESSLIST**命令

### 索引原则

1 =和in可以乱序，比如a = 1 and b = 2 and c = 3 建立**(a,b,c)索引**可以任意顺序，mysql的查询优化器会帮你优化成索引可以识别的形式。

2.索引列不能参与计算，保持列“干净”，比如from_unixtime(create_time) = ’2014-05-29’就不能使用到索引，原因很简单，b+树中存的都是数据表中的字段值，但进行检索时，需要把所有元素都应用函数才能比较，显然成本太大。所以语句应该写成create_time = unix_timestamp(’2014-05-29’)

3 建索引的列的值要区分度要高，例如某列只有-1,0,1三个值，加上索引也不能锁定少量数据

第一：不要指望所有语句都能通过SQL优化，第二：不要过于自信，只针对具体case来优化，而忽略了更复杂的情况

### 索引

#### hash索引和B+Tree索引

1 区别:hash索引没有办法利用索引完成排序,hash索引不支持多列联合索引的最左匹配规则，如果有大量重复键值,hash的性能比较低

2 hash索引是基于key-value的存储结构，B+Tree是一种多路平衡查询树

3 字符串用in不走索引

  例子:user_account in ('','')

4 or分割的条件，如果or前的条件中的列有索引，二后面的列没有索引，那么涉及的索引都不会用到

在倒入数据前限制性set unique_checks=0，关闭唯一性校验，再倒入结束后执行set unique_checks=1，恢复唯一性校验可以提高到付效率。

### innoDB

1 InnoDB支持事,MyISAM不支持事务

2 InnoDB支持行级锁

#### 特性

1 插入缓冲(insert buffer)

2 二次写(double write)

~~~sql
show global status like 'innodb_dblwr%'
~~~

说明：用户若需要统计数据库在生产环境中写入的量，可以通过innodb_dblwr_pages_written进行统计。

参数skip_innodb_doublewrite可以禁止使用doublewrite功能

3 自适应哈希索引

4 预读(read ahead)

### mysql id自增

https://www.csdn.net/gather_20/MtTaIgzsMTAwMC1ibG9n.html

http://ju.outofmemory.cn/entry/370625

InnoDB会为自增的列维护一个计数器，这个计数器的值维护在内存中，而不是数据文件中

MyISAM存入数据文件中

![auto_increment](F:\workspace\idea\study\study\note\images\auto_increment.png)

### 事务的实现原理

1、实现事务特性的原理：
使用Redo Log和Undo Log，Undo Log用于帮助未提交事务进行回滚，Redo Log记录
已经提交的事务，Undo Log会随机读写，而Redo Log基本是顺序