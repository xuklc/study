### 1 计算hash

```java
int hash = spread(key.hashCode());
```

### 2 无限for循环

跳出循环的条件在for循环之中

#### 2.1 计算出一个桶(Node对象)的下标，然后判断是否为空

#### 2.2为空

则直接添加元素

#### 2.3不为空

则synchronized关键字加锁该Node对象

#### 2.4 判断hash和key

两者都相等则替换旧value

#### 2.5 用链表添加hash值一样kV

用链表添加hash值一样kV,同时记录该链表的长度

#### 2.6 当链表的长度大于等于8的时候转为红黑树实现