### 负载均衡规则

BestAvailableRule 选择最小请求数

ClientConfigEnabledRoundRobinRule 轮询

RandomRule 随机选择一个server

RoundRobinRule 轮询选择server

RetryRule 根据轮询的方式重试

WeightedResponseTimeRule 根据响应时间去分配一个weight ，weight越低，被选择的可能性就越低

ZoneAvoidanceRule 根据server的zone区域和可用性来轮询选择

#### RoundRobinRule 

1 获取所有的服务和可用的服务

2  定义一个AtomicInteger变量，然后通过求模运算来获取服务的下标

3 检查通过下标获取 的服务是否可用，不可用就重新求模运算

4 当超过10次之后都没有获取可用的服务则选择服务失败

#### RandomRule 

1 获取所有的服务和可用的服务

2  生成随机数

3 随机数作为下标获取对应你的服务，并返回服务

4 如果获取的服务对象为空，则执行Thead.yield()当前线程让出cpu执行时间，然后等待线程获取cpu执行时间重试



