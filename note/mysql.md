## 1 sql语句

 **1.禁止使用count（常量）或者count（列名），因为它们避免不了NULL值    用count(\*)来计算条数**

2 禁用保留字，如 desc 、 **range** 、 match 、 delayed 等，请参考 MySQL 官方保留字

##2 索引

**MySQL只能使用B-Tree索引做覆盖索引**

### 1 覆盖索引

![using index](D:\software\resources\note\images\using index.png)

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

~~~mysql
SELECT 
  n.id,
  n.name,
  subordinate_unit_ids,
  n.compilation_date,
  n.info_status,
  n.document,
  n.user_account,
  n.dept_id,
  n.proc_inst_id,
  n.proc_startor,
  n.proc_state,
  n.proc_task_handler,
  n.release_time,
  n.range,
  n.isfinalized,
  n.corp_id,
  n.tenant_info_id,
  n.dept_name,
  CASE
    WHEN b.is_browser = 1 
    THEN b.is_browser 
    ELSE 0 
  END is_browser
FROM
  submit_notification n 
  LEFT JOIN submit_browser b 
    ON b.table_name = 'submit_notification' 
    AND n.id = b.record_id 
    AND b.user_account = 'yuanling@gz.csg.cn'
WHERE (n.info_status = 'notify' AND n.range REGEXP '^.*(公司领导|所属单位负责人).*$'-- 1) 
       OR n.proc_task_handler ='yuanling@gz.csg.cn' 
       -- 2
      OR (FIND_IN_SET('yuanling@gz.csg.cn', subordinate_unit_ids) > 0 
          AND n.info_status ='notify') 
       -- 3
     AND tenant_info_id = 6 -- 4 调整这个顺序结果不一样，位置1和2、3、4的结果不一样
~~~



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