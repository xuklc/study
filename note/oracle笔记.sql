删除用户

!--1）查看所有用户的进程
select username,sid,serial# from v$session
!--2）kill指定用户的进程
alter system kill session'199,39'
!--3)删除用户
drop user th cascade

!--创建表空间
create tablespace NNC_DATA01 
datafile 	'F:\app\Administrator\oradata\orcl\NNC_DATA01.dbf'
size 	500M 
autoextend on next 50M extent management local uniform size 512k


create tablespace NNC_INDEX01 datafile 	'F:\app\Administrator\oradata\orcl\NNC_DATA01.dbf'
size 	500M autoextend on next 50M extent management local uniform size 256k
!--创建用户，identified by 后面是密码
 create user train
  identified by train
  default tablespace NNC_DATA01
  temporary tablespace TEMP
  
 !--sysdba和dba的权限不一样，授权sysdba没有建表权限
grant dba to train
 grant connect to train  
 
 !-- select * from user$是查询所有用户
select * from user$ where name='TH0519'
update user$ set name='TH0519' where user#=95
  
  !--创建目录，用户数据的输出和输入，即导入和导出

  CREATE DIRECTORY dump_dir AS 'E:\yonyou\tianhe\database'
  
  !--注意，最后不要有分号(";")，如果有分号会被当做一个用户，导入数据报错
  !--说明：remap_schema是设置导出导入用户，前面一个是导出用户，后面一个是导入用户，如果不设置，oracle则会创建使用导出前本身默认的用户，而不是用这里的用户train/train@orcl
  impdp train/train@orcl DIRECTORY=dump_dir DUMPFILE=TH0519.dmp remap_schema=TH0519:train

  !--查看oracle一个用户有多少张数据表
  select count（*） from user_tables


!--查看表空间名字
select distinct TABLESPACE_NAME from tabs
!--查看几个表空间
select count(distinct TABLESPACE_NAME) from tabs

!--1查看表空间的大小和名称
SELECT t.tablespace_name, round(SUM(bytes / (1024 * 1024)), 0) ts_size FROM dba_tablespaces t, dba_data_files d 
WHERE t.tablespace_name = d.tablespace_name  GROUP BY t.tablespace_name
--2、查看表空间物理文件的名称及大小 
SELECT tablespace_name, 
file_id, 
file_name, 
round(bytes / (1024 * 1024), 0) total_space 
FROM dba_data_files 
ORDER BY tablespace_name; 
--4、查看控制文件 
SELECT NAME FROM v$controlfile; 
--5、查看日志文件 
SELECT MEMBER FROM v$logfile; 
--6、查看表空间的使用情况 
SELECT SUM(bytes) / (1024 * 1024) AS free_space, tablespace_name 
FROM dba_free_space 
GROUP BY tablespace_name; 
SELECT a.tablespace_name, 
a.bytes total, 
b.bytes used, 
c.bytes free, 
(b.bytes * 100) / a.bytes "% USED ", 
(c.bytes * 100) / a.bytes "% FREE " 
FROM sys.sm$ts_avail a, sys.sm$ts_used b, sys.sm$ts_free c 
WHERE a.tablespace_name = b.tablespace_name 
AND a.tablespace_name = c.tablespace_name; 
--7、查看数据库库对象 
SELECT owner, object_type, status, COUNT(*) count# 
FROM all_objects 
GROUP BY owner, object_type, status; 

!--查看表空间的数据文件
select tablespace_name, file_id,file_name, 
round(bytes/(1024*1024),0) total_space from dba_data_files order by tablespace_name

!--表空间增加数据文件
ALTER  TABLESPACE   NNC_DATA01   ADD DATAFILE
'E:\ORADATA\NNC_DATA05.DBF' SIZE 100M   AUTOEXTEND ON NEXT 50M MAXSIZE  31768M 
!--删除表空间及数据文件
!--1  alter database datafile 'F:\app\Administrator\oradata\orcl/DM_ECM_DCTM_ACCT20100917155302_IND.DBF' offline drop
!--2  drop tablespace tabaspacename including contents and datafiles

!--
select file#,name from v$datafile


！--ORA-01157: 无法标识/锁定数据文件 oracle 导致database not open的解决方法
!--1 执行命令
alter database datafile 'F:\app\Administrator\oradata\orcl/DM_ECM_DCTM_ACCT20100917155302_IND.DBF' offline drop
!--2执行命令,打开数据库实例
alter database open

!--查看oracle的运行模式，oracle的日志操作模式有归档模式（archivelog mode）和非归档模式（noarchivelog mode），默认是非归档模式
!--Oacle归档模式是ORACLE热备份的必要条件
select name,log_mode from v$database;
!--系统权限 UNLIMITED TABLESPACE 权限，也就是这个用户可以在其他表空间里随意建表
!--查看系统权限
select * from user_sys_privs

!--查看oracle实例（sid），sid一般和实例名相同
select instance_name from  V$instance

!--启动oracle服务
net start OracleServiceORCL
!--关闭oracle服务
net stop OracleServiceORCL
!--教程地址
http://hollenliu.blog.51cto.com/116553/280844

!--查看监听
lsnrctl
!--查看oracle监听状态
lsnrctl status
!--启动监听
lsnrctl start
!--停止监听服务
lsnrctl stop

!--oracle的时间操作和to_date(),floor
!--oracle 求两个日期的函数floor,用法如下例子，说明两个参数都可以用字段代替， 表也可以指定
select floor(sysdate - to_date('20020405','yyyymmdd')) from dual，
!--to_date函数将日期转换为时间类型，转换前后格式要一致，例如在oracle中存储是'2016-08-05 11:38:51',to_date这样使用:to_date(字段名,'yyyy-mm-dd hh24:mi:ss')
!--谨记以后要学会找例子
!--ADD_MONTHS(DATE,COUNT)，指定日期date上增加count个月
select add_months(sysdate,2)                                 as "两个月后的日期",  
  last_day(sysdate)                                          as "本月最后一天",  
  months_between(sysdate, to_date('2012-12-20','yyyy-mm-dd'))as "月份差",  
  new_time(sysdate,'CST','EST')                              as "北京时间转换为东部时间",  
  next_day(sysdate,1)                                        as "下个周日的日期",  
  sysdate                                                    as "当前系统时间"  
from dual
!--查看oracle目录文件夹
select * from dba_directories
!--导入恒兴数据库的语句
impdp train/train@orcl DIRECTORY=dump_dir DUMPFILE=NNC65-2016-08-15.DMP

!--疑问:oracle用char类型来记录时间类型也能做比较？

!--oralce查询所有用户名
select username from dba_users
!--查看用户表空间
  select username,default_tablespace from user_users 
!--查看用户角色
select * from user_role_privs
!--查看权限
select * from user_sys_privs
!--查看用户下的所有表
select * from user_tables

!--导入不同的表空间和不同的用户的sql
impdp  test/test@orcl directory=test2 dumpfile=nc631.dmp   remap_schema=train:test   log=E:\test.log

在使用left jion on  和 left  and where条件的区别如下：

     1、 on条件是在生成临时表时使用的条件，它不管on中的条件是否为真，都会返回左边表中的记录，and只会过滤掉B表中的记录。B表中不符合条件的部分全部被设置为null。

     2、where条件是在临时表生成好后，再对临时表进行过滤的条件。这时已经没有left join的含义（必须返回左边表的记录）了，条件不为真的就全部过滤掉。?
	 
	 http://blog.csdn.net/li2008xue2008ling/article/details/8456619
	 
	 !-- oracle 字符串连接符"||" 例如 "aaa"||"bbb"="aaabbb"
	 
	 !--oracle被win7防火墙拦截处理方法
	 !--http://blog.sina.com.cn/s/blog_66a6172c0101k3sx.html
	 
	 oralce创建触发器end之后一定要有一个分号";"
	 
	 
	 
	 !--数据表被锁的解决办法
	 !--http://www.cnblogs.com/XQiu/p/5212787.html 教程网址
	 !-- 1查询被锁的表的sid，表名和表的id
	 select b.owner,b.object_name,b.object_id,a.session_id sid ,a.locked_mode from v$locked_object a,dba_objects b where b.object_id = a.object_id
	 
	 !-- 2查询serial#
	 select sid, serial#, machine, program from v$session where sid = 第一步查出来的sid(session_id)
	 !--3 结束被锁的session
	 alter system kill session 'sid,serial#'
	 
	 --oracle创建dblink
	 create database link dblink_hxzk6
	 connect to nczk identified by "1qaz2wsx"
	 using '219.129.77.59/orcl';
	 --oracle UTF-8编码设置
	 AMERICAN_AMERICA.AL32UTF8
	 -- oracle gbk编码设置
	 SIMPLIFIED CHINESE_CHINA.ZHS16GBK
 
     --数据还原
	 create table bd_bom_b5 as select * from bd_bom_b as of timestamp to_timestamp('2017-04-01 19:13:00','yyyy-mm-dd hh24:mi:ss')
	 --导出数据库
	 expdp  yhtest/yhtest@orcl  dumpfile=yhtest20170417   directory=DUMP_DIR
	 
	 语法如下： 
　　instr( string1, string2 [, start_position [, nth_appearance ] ] ) 
　　参数分析： 
　　string1 
　　源字符串，要在此字符串中查找。 
　　string2 
　　要在string1中查找的字符串. 
　　start_position 

　　代表string1 的哪个位置开始查找。此参数可选，如果省略默认为1. 字符串索引从1开始。如果此参数为正，从左到右开始检索，如果此参数为负，从右到左检索，返回要查找的字符串在源字符串中的开始索引。 

　　nth_appearance 

　　代表要查找第几次出现的string2. 此参数可选，如果省略，默认为 1.如果为负数系统会报错。 

　　注意： 

　　如果String2在String1中没有找到，instr函数返回0. 
	!--regexp_like函数用法简单实例，包括“|”用法简单实例
	select pk_dept,busi.pk_org,busi.org_function from org_admin_dept h join  org_busi_func busi  on  h.pk_busirole=busi.pk_busichild
	where       regexp_like(org_function,'(st|fa)') 
	
	使用的函数为replace()

	含义为：替换字符串

	replace(原字段，“原字段旧内容“,“原字段新内容“,)
	
	/*使用查询插入数据*/
	insert into  table_name   select column1,column2..... from table_name2   where....
	/*例子*/
	insert into  ic_onhanddim  dim  where  nvl(dim.dr,0)=0  and  not exists  (select 1  from  scm_batchcode  scm  where scm.pk_batchcode=dim.pk_batchcode and  	scm.cmaterialoid=dim.cmaterialoid );
	
	/*日期加一天,date类型直接+1,char或者varchar2类型先转为date类型*/
	to_char(to_date(po.creationtime,'yyyy-mm-dd hh24:mi:ss')+1,'yyyy-mm-dd hh24:mi:ss')

	/*oracle变量声明和使用*/
	declare  
	变量名  数据类型:=初始值;
	例如 qryresult number:=0;  qryresult是变量名，number是数据类型,:=是赋值运算符
	在函数中使用变量接收某个查询条件的值，例子如下
	create or replace  function  is_share(pkorg varchar2,vbillcode varchar2)
    return number
    as 
    total number;
    begin
      select  count(distinct  cgeneralhid)  into  total from  ic_material_b  where nvl(dr,0)=0  and  
      pk_org=pkorg  and  vproductbatch=vbillcode;
      return total;
    end is_share;
	/*oracle自定义事务*/
	Pragma autonomous_transaction; 告诉Oracle触发器是自定义事务处理
	/*oracle自定义项函数*/	定义函数时使用的参数不能定义数据类型的长度，例如数据类型是varchar2，则参数的数据类型就是varchar2,不能写成varchar2(20)、varchar2(10)之类的，同样的number也是，不能写成number(10),number(28,8)之类，直接写成number，例子如下:
	create or replace  function  is_share(pkorg varchar2,vbillcode varchar2)
    return number
    as 
    total number;
    begin
      select  count(distinct  cgeneralhid)  into  total from  ic_material_b  where nvl(dr,0)=0  and  
      pk_org=pkorg  and  vproductbatch=vbillcode;
      return total;
    end is_share;

	windowssqlplus连接数据库的方法
	1)cmd
	--cmd命令窗口输入
	2) sqlplus 用户名/密码@IP/数据库实例名

	--查看所有用户
    select * from all_users;   
    select * from dba_users;  
    select * from user_users;  
	--查看SID
    select * from v$instance;  
　　--查看所有表空间
    select * from v$tablespace;  
　　--查询表空间文件所在路径
    select * from dba_data_files;  
　　--查看用户所拥有的角色
    select * from dba_role_privs;     
    select * from user_role_privs;   
　　--用户修改密码，Oracle给用户解锁
    ALTER USER "SCOTT" IDENTIFIED BY "*******"     
    ALTER USER "SCOTT" ACCOUNT UNLOCK 
　　--显示当前连接用户
    show user;  
	
	
	case when的两种用法
	1 就是case   when 两者之间为空，然后when  then  之间做判断，例子如下
	例子1
	case     when  REGEXP_INSTR(team.name,'[1|一|A|a]',1,1)>0  then  '一班'   
	when  REGEXP_INSTR(team.name,'[2|二|B|b]',1,1)>0  then  '二班'  
	when   REGEXP_INSTR(team.name,'[3|三|C|c]',1,1)>0  then  '三班'  
	else team.name  end teamname
	例子2 
	case when nvl(pu.fstatusflag,0)=0 then '自由'  when nvl(pu.fstatusflag,0)=1  then '生效'  
    when  nvl(pu.fstatusflag,0)=2  then '审批中' when  nvl(pu.fstatusflag,0)=3  then  '审批通过'  
    when  nvl(pu.fstatusflag,0)=4  then '审批未通过'  when nvl(pu.fstatusflag,0)=5  then '冻结'  when  nvl(pu.fstatusflag,0)=6 then  '终止' 
    when  nvl(pu.fstatusflag,0)=7 then '提交'  end  as  fstatusflag 
	2 就是在case  when 有判断条件，when  then 之间直接判断，例子如下:
	例子1
	case  nvl(qcb.fprocessjudge,1)   
	when 1  then  '入库'   
	when 2  then  '合格入库'  
	when  3 then '报废入库' 
	when  4  then  '返工'  
	when  5  then '不入库'  
	when  6  then '合格' 
	when   7  then '料废'  
	when 8  then '工废'   
	when 9  then  '拒收'   
	end as  fprocessjudge 
	
	regexp_instr()函数的一个用法，regexp_instr返回的匹配字符的位置
	例子REGEXP_INSTR(team.name,'[1|一|A|a]',1,1)>0
	说明:1team.name是字段名称，'[1|一|A|a]'是正则表达式，|表示或的意思,
	2 在正则表达式中是()可以表示分组,例如'[(abc)|(123)]'就表示匹配abc或者123
	3 第一个参数1表示从第一个字符开始匹配，第二个参数1表示返回第一次匹配的位置。
	
	/*Oracle正则表达式表示任意字符匹配*/
	例子
	REGEXP_INSTR(doc.name, '(成品(.*)仓库(.*))',1,1)>0
	其中.表示任意字符，*匹配前面的子表达式零次或多次。
	
	/*查询sql执行历史*/
	select * from v$sqlarea  s  where  s.SQL_TEXT like 'update  bd_material  m%'  order by  s.FIRST_LOAD_TIME desc 
	
	!--oracle回复数据命令
	recover database;
	
1  recover database using backup controlfile
2  recover database until cancel
3  recover database using backup controlfile until cancel;
4  recover database until cancel using backup controlfile;
recover database，是做的完全恢复，也就是说你的日志文件归档的和在线的都完好无损，还有数据文件，
控制文件都准备齐全才可！如果有在线日志损坏，或者归档日志确实的话，就无法执行完全恢复，需要不完全恢复了！
recover database using backup controlfile......or until cancel;然后resetlogs打开，
再不行就是使用隐含参数打开！

!--使用sqlserver增加dblink
--使用sp_addlinkedserver来增加链接

EXEC sp_addlinkedserver
@server='dblink_lfp',--被访问的服务器别名（习惯上直接使用目标服务器IP，或取个别名如：dblink_lfp）
@srvproduct='',
@provider='SQLOLEDB',
@datasrc='192.168.112.106' --要访问的服务器

--使用sp_addlinkedsrvlogin 来增加用户登录链接

EXEC sp_addlinkedsrvlogin
'dblink_lfp', --被访问的服务器别名（如果上面sp_addlinkedserver中使用别名dblink_lfp，则这里也是dblink_lfp）
'false',
NULL,
'sa', --帐号
'123456a' --密码
/*查询例子,select * from  dblink(名称).数据库名称.db.表名*/
select * from  dblink_lfp.lfpnc65.dbo.ia_i2bill

/*查看oracle的事务隔离级别*/
-- 1声明一个事务
declare
     trans_id Varchar2(100);
  begin
     trans_id := dbms_transaction.local_transaction_id( TRUE );
  end; 
--2 执行sql查看当前的事务的隔离级别，即oracle数据库的隔离级别
SELECT s.sid, s.serial#,
　　CASE BITAND(t.flag, POWER(2, 28))
　　　　WHEN 0 THEN 'READ COMMITTED'
　　　　ELSE 'SERIALIZABLE'
　　END AS isolation_level
FROM v$transaction t
JOIN v$session s ON t.addr = s.taddr AND s.sid = sys_context('USERENV', 'SID');
/*关于oracle的事务*/
oracle默认的事务隔离级别是read commited(读已提交),
当事务的隔离级别是read commited时，
DML语句的操作的事务都会有一个排他写锁，即最先开始的事务没有提交事务释放锁的时候，
其他事务都处于等待的状态，但是不影响数据的读取。
对于读取数据说明:当执行DML语句后,若在DML语句当前事务读取数据，
则会读取到DML语句修改后的数据，若另起事务则读取DML语句修改前的数。
注意这个排他写锁时行锁，不是表锁。
select语句会加一个读锁。在oracle中写锁的级别高于读锁

服务器参数文件
spfile
v$parameter(视图)
显示服务器参数
show parameter
修改服务器参数
alter system  set  parameter=parameterValue
表分区(分区)
监视索引是否监控



