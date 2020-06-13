官网

https://www.mysql.com/cn/why-mysql/performance/

文档

https://dev.mysql.com/doc/refman/8.0/en/server-system-variable-reference.html

// 红黑树

https://blog.csdn.net/v_july_v/article/details/6105630

### 注意

**SQLyog这个工具，一个连接就只是一个事务，这点PLSQL Developer不一样，PLSQL Developer是新开一个SQL窗口就是一个新的事务，但是SQLyog在一个连接之内，多少个SQL执行窗口都是同一个事务**

## 1 sql语句

 **1.禁止使用count（常量）或者count（列名），因为它们避免不了NULL值    用count(\*)来计算条数**

2 禁用保留字，如 desc 、 **range** 、 match 、 delayed 等，请参考 MySQL 官方保留字

**like只有右边匹配才用索引,LIKE 'ptd_%'**

## 2 索引

https://www.cnblogs.com/nickchen121/p/11152523.html



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



## find_in_set

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

## 慢查询

### 慢查询日志开启

在配置文件my.cnf或my.ini中在[mysqld]一行下面加入两个配置参数

log-slow-queries=/data/mysqldata/slow-query.log           

long_query_time=5

log-slow-queries参数为慢查询日志存放的位置，一般这个目录要有mysql的运行帐号的可写权限，一般都将这个目录设置为mysql的数据存放目录；

long_query_time=5中的**5表示查询超过五秒才记录**

还可以在my.cnf或者my.ini中添加log-queries-not-using-indexes参数，表示记录下没有使用索引的查询

## order by

要尽可能的保证排序字段在驱动表中

排序要避免Using filesort，Using temporary

如果排序查询的数据两大于这个默认值的话，还是会使用Using filesort，order by 出现using filesort的常规解决办法是建索引，或者组合索引

![filesort](D:\resources\study\note\images\filesort.png)

## explain

https://www.jianshu.com/p/73f2c8448722

https://www.cnblogs.com/galengao/p/5780958.html

http://www.cnitblog.com/aliyiyi08/archive/2008/09/09/48878.html

https://www.cnblogs.com/xiaoqiang-code/p/11404149.html

https://blog.csdn.net/kk185800961/article/details/49179619

### id

id相同，从上往下执行，id不同，如果是子查询，则序号会递增，id值越大优先级越高，越先被执行

- **id 为 null**： 最后执行

- 如果id相同，则认为是一组，从上往下顺序执行；**在所有组中，id值越大，优先级越高，越先执行**

### rows

rows：MYSQL认为必须检查的用来返回请求数据的行数

**这里是执行计划中估算的扫描行数，不是精确值**

### key

实际使用的索引，如果为空表示没有使用索引

### key_len

使用索引的长度，在不损失精确度的情况下，长度越短越好

### type

这是重要的列，显示连接的类型，从最好到最差是 **ALL, index,  range, ref, eq_ref, const, system, NULL**

#### const

```mysql
表最多只有一个匹配行，在查询开始时被读取。因为只有一个值，优化器将该列值视为常量。当在`*`primarykey`*`或者`*`unique`*`索引作为常量比较时被使用
```

![image-20200609233358754](mysql.assets/image-20200609233358754.png)

产生“ Impossible WHERE noticed after reading const tables”的原因是这样的，当在查询语句中存在满足如下条件的 WHERE 语句时，MySQL在 EXPLAIN 之前会优先根据这一条件查找出对应的记录，并用记录的实际值替换查询中所有使用到的该表属性。这是因为满足以下四个条件时，就会使得针对该表的查询最多只能产生一条命中结果。**在该表无法命中数据的情况下就会提示“在 const table 表中没有找到匹配的行”**，而这个 “const table”就指的是满足下面四个条件的表。这是 MySQL 的一个优化策略。

当查询条件中包含了某个表的主键或者非空的唯一索引列
该列的判定条件为等值条件
目标值的类型与该列的类型一致
目标值为一个确定的常量

#### eq_ref

唯一性索引扫描，对于每个索引建，表中只有一条记录与之匹配，常见于主键或者唯一性扫描

#### ref

非唯一性索引扫描，返回匹配某个单独值的所有行，本质上也是一种索引访问，它返回所有匹配某个单独值的行，然而它可能会找到多个符合条件的行

~~~sql
explain select * from tabname where tid=2
~~~

![image-20200610000604761](mysql.assets/image-20200610000604761.png)

####  ref_or_null

~~~sql
explain select id,tid from tabname where tid=2 or tid is null
~~~

![image-20200610000854637](mysql.assets/image-20200610000854637.png)

#### fulltext

~~~sql
// 创建全文索引
ALTER TABLE tabname2 ADD FULLTEXT(NAME)
EXPLAIN SELECT * FROM tabname2 WHERE MATCH(NAME) AGAINST('love');
~~~

![image-20200610001252417](mysql.assets/image-20200610001252417.png)

#### range

只检索给定范围的行，使用一个索引来选择行，key列显示使用了哪个索引

~~~sql
EXPLAIN SELECT * FROM tabname WHERE id>1
/*在主键列使用in查询type类型就是range*/
explain select * from tabname where id in(1,2,3)
~~~

​	![image-20200610001711674](mysql.assets/image-20200610001711674.png)

#### index

Full Index Scan ,index和All区别为index类型只遍历索引树

**索引全表扫描，把索引从头到尾扫一遍，常见于使用索引列就可以处理不需要读取数据文件的查询、可以使用索引排序或者分组的查询**

~~~sql
EXPLAIN SELECT tid FROM tabname
~~~

![image-20200610001928232](mysql.assets/image-20200610001928232.png)

**索引全表扫描，把索引从头到尾扫一遍，常见于使用索引列就可以处理不需要读取数据文件的查询、可以使用索引排序或者分组的查询**

#### All

Full Table Scan，全表扫描

### select_type

~~~sql
// 建表语句
create table tabname (
id int auto_increment not null primary key,
name varchar(10) null,
indate datetime null,
tid int null,
key(tid),
key(indate)
)engine=innodb;


create table tabname2 (
id int auto_increment not null primary key,
name varchar(10) null,
indate datetime null,
tid int null,
key(tid),
key(indate)
)
~~~



1 simple 2 primary 3 subquery 4 derived  5 union 6 union result

#### 1 simple

简单select 查询，不包含子查询或union

#### 2 primary

查询不包含任何复杂的子部分，最外层被标记为primary

#### 3 subquery

在select或where中包含子查询

primary：复杂查询中最外层的select
subquery：包含在select中的子查询（不在from子句中）
derived：包含在from子句中的子查询。MySQL会将结果存放在一个临时表中，也称为派生表

~~~sql
explain select (select 1 from actor where id = 1) from (select * from film
where id = 1) der;
~~~

![derived](.\mysql.assets\1771943-20190824115601832-2143902727.jpg)

![image-20200609230645306](mysql.assets/image-20200609230645306.png)

#### 4 derived

**from子句的查询 例如select  * from (select * from a ) b**

在from列表中包含子查询被标记为derived(衍生)，mysql会递归执行子查询，把结果放在临时表

DERIVED：用于 from 子句里有子查询的情况。MySQL 会递归执行这些子查询，把结果放在临时表里

#### 5 union

若第二个select出现在union之后，则被标记为union,若union包含在from子句的子查询中，外层select将被标记为derived

例如下图，id为null, union result 就是对两个查询结果排序去重，id为null是最后执行，即在两个结果查询完之后对结果集合并去重

![image-20200609231039070](mysql.assets/image-20200609231039070.png)

下图是没有union result的情况

![image-20200609231928875](mysql.assets/image-20200609231928875.png)

#### 6 union result

UNION RESULT：UNION 的结果

#### 7 Materialization

MySQL引入了Materialization（物化）这一关键特性用于子查询（比如在IN/NOT IN子查询以及 FROM 子查询）优化。 具体实现方式是：在SQL执行过程中，第一次需要子查询结果时执行子查询并将子查询的结果保存为临时表 ，后续对子查询结果集的访问将直接通过临时表获得。 与此同时，优化器还具有延迟物化子查询的能力，先通过其它条件判断子查询是否真的需要执行。物化子查询优化SQL执行的关键点在于对子查询只需要执行一次。 与之相对的执行方式是对外表的每一行都对子查询进行调用，其执行计划中的查询类型为“DEPENDENT SUBQUERY”

#### 8 DEPENDENT SUBQUERY

~~~sql
explain select *,(select name from tabname b where a.id=b.id) from tabname a;
~~~

![image-20200609230404544](.\mysql.assets\image-20200609230404544.png)

#### 9 PRIMARY / DEPENDENT UNION / DEPENDENT SUBQUERY / UNION RESULT

~~~sql
EXPLAIN SELECT * FROM tabname c WHERE c.id IN (SELECT id FROM tabname a UNION SELECT id FROM tabname b );
~~~

![image-20200609234423148](mysql.assets/image-20200609234423148.png)

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

#### 使用案例

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

## TIMESTAMPDIFF

TIMESTAMPDIFF(unit,datetime_expr1,datetime_expr2)

unit值如下:

FRAC_SECOND (microseconds), SECOND, MINUTE, HOUR, DAY, WEEK, MONTH, QUARTER, YEAR

### 例子

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

#### 数据库重启后恢复自增值

InnoDB 引擎的自增值，其实是保存在了内存里，并且到了 MySQL 8.0 版本后，才有了“自增值持久化”的能力，也就是才实现了“如果发生重启，表的自增值可以恢复为 MySQL 重启前的值”，具体情况是：
在 MySQL 5.7 及之前的版本，自增值保存在内存里，并没有持久化。每次重启后，第一次打开表的时候，都会去找自增值的最大值 max(id)，然后将 max(id)+1 作为这个表当前的自增值。
举例来说，如果一个表当前数据行里最大的 id 是 10，AUTO_INCREMENT=11。这时候，我们删除 id=10 的行，AUTO_INCREMENT 还是 11。但如果马上重启实例，重启后这个表的 AUTO_INCREMENT 就会变成 10。
也就是说，MySQL 重启可能会修改一个表的 AUTO_INCREMENT 的值。
在 MySQL 8.0 版本，将自增值的变更记录在了 redo log 中，重启的时候依靠 redo log 恢复重启之前的值

MyISAM存入数据文件中

![auto_increment](mysql.assets/auto_increment.png)

### 事务的实现原理

1、实现事务特性的原理：
使用Redo Log和Undo Log，Undo Log用于帮助未提交事务进行回滚，Redo Log记录
已经提交的事务，Undo Log会随机读写，而Redo Log基本是顺序

### join

1 left join A表为驱动表

2 inner join MySQL会自动找出数据少的表作为驱动表

3 right join B 表作为驱动表

4 straight_join强制指定左边的表就是驱动表



### 事务

#### show variables

**SHOW VARIABLES **

show variables like '变量名称'

#### 变量

MySQL维护两种变量，一种是全局变量，一种是局部变量，全局变量的值的修改是set global var_name ,

查看全局变量语句

show  [global | session ] variables like 

**修改全局变量需要super权限**

局部变量是 set  session var_name

#### show  status

show status LIKE  '状态名称'

使用show status查看MySQL服务器状态信息



#### 1 隔离级别设置

~~~ sql
//查看数据库版本
mysql> select @@version;    
+-----------+
| @@version |
+-----------+
| 8.0.12    |
+-----------+
1 row in set (0.01 sec)
1.查看当前会话隔离级别
select @@tx_isolation;
2.查看系统当前隔离级别
select @@global.tx_isolation;
3.设置当前会话隔离级别
set session transaction isolation level repeatable read;
4.设置系统当前隔离级别
set global transaction isolation level repeatable read;

//查看数据库隔离级别
//这条sql才能看到事务的隔离级别 SHOW VARIABLES LIKE 'tx_isolation%'
mysql> select @@transaction_isolation;
+-------------------------+
| @@transaction_isolation |
+-------------------------+
| REPEATABLE-READ         |
+-------------------------+
1 row in set (0.02 sec)


//查看数据库是否是自动提交
mysql> show variables like 'autocommit';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| autocommit    | ON    |
+---------------+-------+
1 row in set (0.03 sec)


//将数据库 自动提交 去掉
//永久生效设置方法：
//通过修改配置文件my.cnf文件，通过vim编辑my.cnf文件，在[mysqld]（服务器选项下）添加:
//autocommit=0
mysql> set autocommit = 0;
Query OK, 0 rows affected (0.00 sec)


//再次查看事务是否自动提交
mysql> show variables like 'autocommit';
+---------------+-------+
| Variable_name | Value |
+---------------+-------+
| autocommit    | OFF   |
+---------------+-------+
1 row in set (0.04 sec)


现在来看看MySQL数据库为我们提供的四种隔离级别：

　　1.Serializable (串行化)：可避免脏读、不可重复读、幻读的发生。

　　2. Repeatable read (可重复读)：可避免脏读、不可重复读的发生。

　　3. Read committed (读已提交)：可避免脏读的发生。

　　4. Read uncommitted (读未提交)：最低级别，任何情况都无法保证。



//设置数据库的隔离级别
mysql> set transaction isolation level read committed;
Query OK, 0 rows affected (0.00 sec)


//开始事务
mysql> start transaction;
Query OK, 0 rows affected (0.00 sec)


//设置数据库的隔离级别
set session transaction isolation level read committed;
set session transaction isolation level read uncommitted;
set session transaction isolation level repeatable read;
set session transaction isolation level serializable;
~~~

#### 2 设置session隔离级别

![session_isolation](mysql.assets/session_isolation.png)



#### 四种隔离级别

http://www.zsythink.net/archives/1233

https://blog.csdn.net/weishuai528/article/details/90676316

##### 1 read uncommit（读未提交）

当前事务可以看到其他事务未提交的数据，这种现象就是脏读，例如事务1修改了数据，但是**未提交事务**,事务2可以看到事务1修改未提交的数据就是脏读

#### 2  read commit (读已提交)

读已提交就是当前事务只能读取另外一个事务修改并提交是数据，未提交的数据读取不到

可重复读存在的问题就是不可重复读

##### 不可重复读

不可重复读：就是在同一个事务中一条SQL执行两次得到的结果不一致

例子

事务1 

1 设置隔离级别是read committed

2 设置不自动提交

3 使用begin开启事务，并读取表t1的数据

![不可重复读1](mysql.assets/不可重复读1-1591807611833.png)

事务2

1 设置隔离级别是read committed

2 设置不自动提交

3 使用begin开启事务，并读取表t1的数据

![不可重复读2](mysql.assets/不可重复读2.png)

4 修改数据，并提交

![不可重复读3](mysql.assets/不可重复读3.png)



![不可重复读4](mysql.assets/不可重复读4.png)



事务1

t1表更新前

![不可重复读1](mysql.assets/不可重复读1.png)

更新后

​          



![不可重复读5](mysql.assets/不可重复读5.png)

以上的例子就是同一个事务同一SQL在不同的时间查询得到的结果不一致，就是不可重复读

，解决办法就是将隔离级别设置成可重复读(repeatable read)

#### 3 repeatable read(可重复读)

可重复读存在幻读的问题

可重复读就是开启事务1，然后读取数据，然后再开启事务2，然后更新数据提交之后，事务1再执行SQL查询到的结果和第一次查询得到的结果是一样的

例子，如下图

![可重复读](mysql.assets/可重复读.png)

##### 幻读

幻读主要是针对新增和删除的，就是在同一个事务中，执行更新时会多出几条数据

![幻读](mysql.assets/幻读.png)





#### 读写锁并行问题

事务的隔离是由锁实现的，在执行update、insert、delete操作时，会加上写锁，但是其他事务仍然可以读取被加锁的数据，这是因为InnoDB采用了"一致性非锁定读"的机制来提高并发性，即在需要被读取的数据行被加排它锁之后，不会等待排它锁的释放，而是读取一个快照的数据，如下图

![读取快照数据](mysql.assets/读取快照数据.png)

#### 4 串行化

串行化就是写和读操作不能并行执行

![串行化](mysql.assets/串行化.png)

### SQL提示

常用的SQL提示(SQL HiNT)

USE INDEX:使用USE INDEX是希望MySQL去参考索引列表，就可以让MySQL不需要考虑其他可用索引，其实也就是possible_keys属性下参考的索引值

~~~sql
select* from user_info use index(id_index,ind_name_id) where user_id>0;
~~~

FORCE INDEX:强制索引，比如where user_id > 0，但是user_id在表中都是大于0的，自然就会进行ALL全表搜索，但是使用FORCE INDEX虽然执行效率不是最高（where user_id > 0条件决定的）但MySQL还是使用索引。

~~~sql
mysql> explain select* from user_info where user_id>0;
+----+-------------+-----------+------------+------+----------------------+------+---------+------+------+----------+-------------+
| id | select_type | table     | partitions | type | possible_keys        | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+-----------+------------+------+----------------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | user_info | NULL       | ALL  | ind_name_id,id_index | NULL | NULL    | NULL |    4 |      100 | Using where |
+----+-------------+-----------+------------+------+----------------------+------+---------+------+------+----------+-------------+
1 row in set
~~~

之后强制使用独立索引id_index(user_id)：

~~~sql
mysql> explain select* from user_info force index(id_index) where user_id>0;
+----+-------------+-----------+------------+-------+---------------+----------+---------+------+------+----------+-----------------------+
| id | select_type | table     | partitions | type  | possible_keys | key      | key_len | ref  | rows | filtered | Extra                 |
+----+-------------+-----------+------------+-------+---------------+----------+---------+------+------+----------+-----------------------+
|  1 | SIMPLE      | user_info | NULL       | range | id_index      | id_index | 4       | NULL |    4 |      100 | Using index condition |
+----+-------------+-----------+------------+-------+---------------+----------+---------+------+------+----------+-----------------------+
1 row in set
~~~

### group by 

MySQL中的GROUP BY语句会对其后出现的字段进行默认排序,**使用ORDER BY NULL禁止排序**

### 大批量插入数据优化

（1）对于MyISAM存储引擎的表，可以使用：DISABLE KEYS 和 ENABLE KEYS 用来打开或者关闭 MyISAM 表非唯一索引的更新。

~~~sql
ALTER TABLE tbl_name DISABLE KEYS;
loading the data
ALTER TABLE tbl_name ENABLE KEYS;
~~~

② 导入数据前执行SET UNIQUE_CHECKS=0，关闭唯一性校验，带导入之后再打开设置为1：校验会消耗时间，在数据量大的情况下需要考虑。

③ 导入前设置SET AUTOCOMMIT=0，关闭自动提交，导入后结束再设置为1：这是因为自动提交会消耗部分时间与资源，虽然消耗不是很大，但是在数据量大的情况下还是得考虑



### 查看存储引擎

~~~Sql
// 查看mysql提供什么引擎
SHOW ENGINES
// 查看当前的存储引擎
SHOW VARIABLES LIKE '%storage_engine%'
// 查看某个表的存储引擎
SHOW CREATE TABLE notification
2、设置InnoDB为默认引擎：
在配置文件my.cnf中的 [mysqld] 下面加入
default-storage-engine=INNODB 
~~~

### MySQL临时表

MySQL临时表分为外部临时表和内部临时表

外部临时表对当前会话的当前用户可见

内部临时表对用户不可见

MySQL内部临时表是一种特殊轻量级的临时表，用来进行性能优化。

内部临时表有两种类型：一种是HEAP临时表，这种临时表的所有数据都会存在内存中，对于这种表的操作不需要IO操作。另一种是OnDisk临时表，顾名思义，这种临时表会将数据存储在磁盘上。OnDisk临时表用来处理中间结果比较大的操作。如果HEAP临时表存储的数据大于MAX_HEAP_TABLE_SIZE（详情请参考MySQL手册中系统变量部分），HEAP临时表将会被自动转换成OnDisk临时表。OnDisk临时表在5.7中可以通过INTERNAL_TMP_DISK_STORAGE_ENGINE系统变量选择使用MyISAM引擎或者InnoDB引擎

~~~sql
SHOW VARIABLES LIKE  '%MAX_HEAP_TABLE_SIZE%';
~~~

![image-20200609155544484](mysql.assets/image-20200609155544484.png)

### 日志

MySQL日志管理 ========================================================

 错误日志: 记录 MySQL 服务器启动、关闭及运行错误等信息

 二进制日志: 又称binlog日志，以二进制文件的方式记录数据库中除 SELECT 以外的操作 

查询日志: 记录查询的信息 慢查询日志: 记录执行时间超过指定时间的操作 

中继日志： 备库将主库的二进制日志复制到自己的中继日志中，从而在本地进行重放 

通用日志： 审计哪个账号、在哪个时段、做了哪些事件 

事务日志或称redo日志： 记录Innodb事务相关的如事务执行时间、检查点等