https://blog.csdn.net/aisemi/article/details/80212836

官网文档

https://www.elastic.co/guide/cn/elasticsearch/guide/current/inside-a-shard.html

1 集群

2 交互

elasticsearch内置了客户端

**索引类似MySQL表的概念，**

### 倒排索引

elasticsearch使用倒排索引来达到关系型数据库的B树索引的效果



### 返回结果

- took ： Elasticsearch执行搜索的时间（以毫秒为单位）
- timed_out ： 告诉我们检索是否超时
- _shards ： 告诉我们检索了多少分片，以及成功/失败的分片数各是多少
- hits ： 检索的结果
- hits.total ： 符合检索条件的文档总数
- hits.hits ： 实际的检索结果数组（默认为前10个文档）
- hits.sort ： 排序的key（如果按分值排序的话则不显示）
- hits._score 和 max_score 现在我们先忽略这些字段



## 基本概念

![](D:\note\note\images\elasticsearch_base(基本概念).png)

### es  vs  DB

1、存储结构不同：

一个Elasticsearch 集群可以包含多个索引（数据库），每个索引又包含了很多类型（表），类型中包含了很多文档（行），每个文档使用 JSON 格式存储数据，包含了很多字段（列）

| 关系型数据库  | 数据库 | 表   | 行   | 列   |
| ------------- | ------ | ---- | ---- | ---- |
| ElasticSearch | 索引   | 类型 | 文档 | 字段 |

### 索引

索引是一个拥有几分相似特征的文档集合，类似于MySQL的数据库

### document

**文档是es中的最小数据单元**

### Field（字段-列）

  Field是Elasticsearch的最小单位。一个document里面有多个field，每个field就是一个数据字段

### mapping（映射-约束）

数据如何存放到索引对象上，需要有一个映射配置，包括：数据类型、是否存储、是否分词等。
  这样就创建了一个名为blog的Index。Type不用单独创建，在创建Mapping 时指定就可以。Mapping用来定义Document中每个字段的类型，即所使用的 analyzer、是否索引等属性，非常关键等。创建Mapping 的代码示例如下：

~~~json
client.indices.putMapping({
    index : 'blog',
    type : 'article',
    body : {
        article: {
            properties: {
                id: {
                    type: 'string',
                    analyzer: 'ik',
                    store: 'yes',
                },
                title: {
                    type: 'string',
                    analyzer: 'ik',
                    store: 'no',
                },
                content: {
                    type: 'string',
                    analyzer: 'ik',
                    store: 'yes',
                }
            }
        }
    }
});
~~~

#### 关于映射的具体操作

![](D:\note\note\images\esMapping.png)

### es查询

#### 1基本查询

例子:

~~~shell
GET  pjt/_search
{
  "query": {
    "match": {
      "NAME":"项目名称8"
    }
  }
}
~~~

#### 2 组合查询

当在请求中看到must（and）、should（or）、must_not（not）、filtered、filter、exists、gt、lt、missing、negative、negative_boost、_cache、constant_score、not_match_query、indices等词时，就是使用了组合查询或者过滤查询

#### 3 过滤查询

### es加锁



### Jest 是一个Java 版的ElasticSearch Http Rest 客户端，基于HttpClient 封装实现。

