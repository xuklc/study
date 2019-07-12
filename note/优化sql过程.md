###  1建表sql

```sql
CREATE TABLE notification (
  id bigint(20) NOT NULL AUTO_INCREMENT,
  start_time date DEFAULT NULL COMMENT '开始时间',
  end_time date DEFAULT NULL COMMENT '结束时间',
  name varchar(200) DEFAULT NULL COMMENT '名称',
  compilation_date date DEFAULT NULL COMMENT '编制时间',
  info_status varchar(100) DEFAULT NULL COMMENT '状态',
  scope varchar(500) DEFAULT NULL COMMENT '发送范围',
  document varchar(500) DEFAULT NULL COMMENT '正文',
  user_account varchar(50) DEFAULT NULL COMMENT '创建人账号',
  dept_id varchar(50) DEFAULT NULL COMMENT '部门',
  create_time bigint(20) DEFAULT NULL COMMENT '创建时间',
  update_time bigint(20) DEFAULT NULL COMMENT '更新时间',
  proc_inst_id varchar(32) DEFAULT NULL COMMENT '流程实例id',
  proc_start_time bigint(20) DEFAULT NULL COMMENT '流程开始时间',
  proc_end_time bigint(20) DEFAULT NULL COMMENT '流程结束时间',
  proc_startor varchar(64) DEFAULT NULL COMMENT '流程发起人',
  proc_state varchar(30) DEFAULT NULL COMMENT '流程状态',
  proc_task_handler varchar(64) DEFAULT NULL COMMENT '流程当前处理人',
  release_time datetime DEFAULT NULL COMMENT '发布时间',
  range varchar(1000) DEFAULT NULL COMMENT '发送范围',
  isfinalized varchar(20) DEFAULT NULL COMMENT '是否已定稿',
  corp_id varchar(50) DEFAULT NULL COMMENT '单位id',
  corp_name varchar(50) DEFAULT NULL COMMENT '单位名称',
  tenant_info_id varchar(10) DEFAULT NULL COMMENT '租户ID',
  dept_name varchar(50) DEFAULT NULL COMMENT '部门名称',
  subordinate_unit_ids varchar(1000) DEFAULT NULL COMMENT '要发送给下属单位的人员账号',
  periods bigint(20) DEFAULT NULL COMMENT '期数',
  total_periods bigint(20) DEFAULT NULL COMMENT '总期数',
  periods_year bigint(20) DEFAULT NULL COMMENT '年度',
  PRIMARY KEY (id)
) ENGINE=InnoDB AUTO_INCREMENT=21123 DEFAULT CHARSET=utf8;
```

### 2 sql

```sql
EXPLAIN 
SELECT 
  COUNT(1) 
FROM
  (SELECT 
    id,
    NAME,
    compilation_date,
    info_status,
    scope,
    document,
    user_account,
    dept_id,
    proc_inst_id,
    proc_start_time,
    proc_end_time,
    proc_startor,
    proc_state,
    proc_task_handler,
    release_time,
    isfinalized,
    tenant_info_id,
    create_time 
  FROM
    notification n 
  WHERE proc_task_handler = 'chengwei_01@csg.cn'
    OR user_account = 'chengwei_01@csg.cn'
    OR (
      FIND_IN_SET('chengwei_01@csg.cn', subordinate_unit_ids) > 0 
      AND n.info_status = 'notify'
    ) 
  UNION
  SELECT 
    id,
    NAME,
    compilation_date,
    info_status,
    scope,
    document,
    user_account,
    dept_id,
    proc_inst_id,
    proc_start_time,
    proc_end_time,
    proc_startor,
    proc_state,
    proc_task_handler,
    release_time,
    isfinalized,
    tenant_info_id,
    create_time 
  FROM
    notification a 
  WHERE corp_id = 'c29cd3da9458461191b5b2d5e8417346'
    AND FIND_IN_SET('总部各部门', a.range) > 0
    ) t 
WHERE 1 = 1 
ORDER BY FIELD(proc_task_handler, 'chengwei_01@csg.cn') DESC,
  create_time DESC 
```

### 3 优化

#### 1  常用查询的字段加索引

ALTER  TABLE submit_notification  ADD INDEX corp_index(corp_id);

**sending Data上耗时最长**

#### 2 加索引调整sql

```sql
EXPLAIN SELECT 
  id,
  NAME,
  compilation_date,
  info_status,
  scope,
  document,
  user_account,
  dept_id,
  proc_inst_id,
  proc_start_time,
  proc_end_time,
  proc_startor,
  proc_state,
  proc_task_handler,
  release_time,
  isfinalized,
  tenant_info_id,
  create_time 
FROM
  (
  SELECT 
    id,
    NAME,
    compilation_date,
    info_status,
    scope,
    document,
    user_account,
    dept_id,
    proc_inst_id,
    proc_start_time,
    proc_end_time,
    proc_startor,
    proc_state,
    proc_task_handler,
    release_time,
    isfinalized,
    tenant_info_id,
    create_time 
  FROM
    submit_notification n 
  WHERE ( FIND_IN_SET('chengwei_01@csg.cn', subordinate_unit_ids) > 0 
      AND n.info_status = 'notify')
  UNION
   SELECT 
    id,
    NAME,
    compilation_date,
    info_status,
    scope,
    document,
    user_account,
    dept_id,
    proc_inst_id,
    proc_start_time,
    proc_end_time,
    proc_startor,
    proc_state,
    proc_task_handler,
    release_time,
    isfinalized,
    tenant_info_id,
    create_time 
  FROM
    submit_notification n 
  WHERE corp_id = 'c29cd3da9458461191b5b2d5e8417346'
    AND FIND_IN_SET('总部各部门', n.range) > 0
    ) t 
WHERE 1 = 1 
    -- 调整sql项
    OR proc_task_handler = 'chengwei_01@csg.cn'
    OR user_account = 'chengwei_01@csg.cn'
ORDER BY FIELD(proc_task_handler, 'chengwei_01@csg.cn') DESC,
  create_time DESC 
```

