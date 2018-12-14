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



## find_in_set