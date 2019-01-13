### feign 服务调用源码流程

每个都一样，不可能一行一行代码的讲解出来的，只能讲出重点，关键点，先列出重点

#### 1 HystrixInvocationHandler

```
HystrixInvocationHandler.invoke	
```

####2AbstractCommand类初始化

```java
protected AbstractCommand(HystrixCommandGroupKey group, HystrixCommandKey key, HystrixThreadPoolKey threadPoolKey, HystrixCircuitBreaker circuitBreaker, HystrixThreadPool threadPool,
        HystrixCommandProperties.Setter commandPropertiesDefaults, HystrixThreadPoolProperties.Setter threadPoolPropertiesDefaults,
        HystrixCommandMetrics metrics, TryableSemaphore fallbackSemaphore, TryableSemaphore executionSemaphore,
        HystrixPropertiesStrategy propertiesStrategy, HystrixCommandExecutionHook executionHook) {

    this.commandGroup = initGroupKey(group);
    //初始化commandKey
    this.commandKey = initCommandKey(key, getClass());
    //初始化以hystrix开头的各种属性，包括超时时间和run()的隔离策略
    this.properties = initCommandProperties(this.commandKey, propertiesStrategy, commandPropertiesDefaults);
    this.threadPoolKey = initThreadPoolKey(threadPoolKey, this.commandGroup, this.properties.executionIsolationThreadPoolKeyOverride().get());
    this.metrics = initMetrics(metrics, this.commandGroup, this.threadPoolKey, this.commandKey, this.properties);
    this.circuitBreaker = initCircuitBreaker(this.properties.circuitBreakerEnabled().get(), circuitBreaker, this.commandGroup, this.commandKey, this.properties, this.metrics);
    this.threadPool = initThreadPool(threadPool, this.threadPoolKey, threadPoolPropertiesDefaults);

    //Strategies from plugins
    this.eventNotifier = HystrixPlugins.getInstance().getEventNotifier();
    this.concurrencyStrategy = HystrixPlugins.getInstance().getConcurrencyStrategy();
    HystrixMetricsPublisherFactory.createOrRetrievePublisherForCommand(this.commandKey, this.commandGroup, this.metrics, this.circuitBreaker, this.properties);
    this.executionHook = initExecutionHook(executionHook);

    this.requestCache = HystrixRequestCache.getInstance(this.commandKey, this.concurrencyStrategy);
    this.currentRequestLog = initRequestLog(this.properties.requestLogEnabled().get(), this.concurrencyStrategy);

    /* fallback semaphore override if applicable */
    this.fallbackSemaphoreOverride = fallbackSemaphore;

    /* execution semaphore override if applicable */
    this.executionSemaphoreOverride = executionSemaphore;
}
```

#### 3 ribbon

ribbon的属性配置类RibbonProperties

连接超时默认时间(ConnectTimeout)--2000和读取超时默认时间(ReadTimeout)--5000

**ConnectTimeout和ReadTimeout属性严格区分大小写,CommonClientConfigKey类下面指定的属性都严格区分大小写**

feign服务调用的过程是ribbon服务调用超时后，就直接进入hystrix的fallback,hystrix的服务调用超时应该是fallback的服务调用超时。



ribbon调用服务的一个入口FeignLoadBalancer.execute(RibbonRequest request, IClientConfig configOverride)

feign

1 属性配置

2 调用流程

  1 负载均衡的关键流程

  2  服务降级的流程

ribbon

hystrix

feign

gateway





