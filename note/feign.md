### feign 服务调用源码流程

每个都一样，不可能一行一行代码的讲解出来的，只能讲出重点，关键点，先列出重点

#### 1 HystrixInvocationHandler

```
HystrixInvocationHandler.invoke	
```

#### 2AbstractCommand类初始化

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



~~~java
java.net.SocketTimeoutException: Read timed out
	at java.net.SocketInputStream.socketRead0(Native Method) ~[na:1.8.0_181]
	at java.net.SocketInputStream.socketRead(SocketInputStream.java:116) ~[na:1.8.0_181]
	at java.net.SocketInputStream.read(SocketInputStream.java:171) ~[na:1.8.0_181]
	at java.net.SocketInputStream.read(SocketInputStream.java:141) ~[na:1.8.0_181]
	at java.io.BufferedInputStream.fill(BufferedInputStream.java:246) ~[na:1.8.0_181]
	at java.io.BufferedInputStream.read1(BufferedInputStream.java:286) ~[na:1.8.0_181]
	at java.io.BufferedInputStream.read(BufferedInputStream.java:345) ~[na:1.8.0_181]
	at sun.net.www.http.HttpClient.parseHTTPHeader(HttpClient.java:735) ~[na:1.8.0_181]
	at sun.net.www.http.HttpClient.parseHTTP(HttpClient.java:678) ~[na:1.8.0_181]
	at sun.net.www.protocol.http.HttpURLConnection.getInputStream0(HttpURLConnection.java:1587) ~[na:1.8.0_181]
	at sun.net.www.protocol.http.HttpURLConnection.getInputStream(HttpURLConnection.java:1492) ~[na:1.8.0_181]
	at java.net.HttpURLConnection.getResponseCode(HttpURLConnection.java:480) ~[na:1.8.0_181]
	at feign.ClientDefault.convertResponse(Client.java:150) ~[feign-core-9.7.0.jar:na]
	at feign.ClientDefault.execute(Client.java:72) ~[feign-core-9.7.0.jar:na]
	at org.springframework.cloud.openfeign.ribbon.FeignLoadBalancer.execute(FeignLoadBalancer.java:89) ~[spring-cloud-openfeign-core-2.0.2.RELEASE.jar:2.0.2.RELEASE]
	at org.springframework.cloud.openfeign.ribbon.FeignLoadBalancer.execute(FeignLoadBalancer.java:55) ~[spring-cloud-openfeign-core-2.0.2.RELEASE.jar:2.0.2.RELEASE]
	at com.netflix.client.AbstractLoadBalancerAwareClient1.call(AbstractLoadBalancerAwareClient.java:104) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand31.call(LoadBalancerCommand.java:303) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand31.call(LoadBalancerCommand.java:287) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at rx.internal.util.ScalarSynchronousObservable3.call(ScalarSynchronousObservable.java:231) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservable3.call(ScalarSynchronousObservable.java:228) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMapConcatMapSubscriber.drain(OnSubscribeConcatMap.java:286) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMapConcatMapSubscriber.onNext(OnSubscribeConcatMap.java:144) ~[rxjava-1.3.8.jar:1.3.8]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand1.call(LoadBalancerCommand.java:185) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand1.call(LoadBalancerCommand.java:180) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:94) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:42) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicateSourceSubscriber1.call(OperatorRetryWithPredicate.java:127) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.schedulers.TrampolineSchedulerInnerCurrentThreadScheduler.enqueue(TrampolineScheduler.java:73) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.schedulers.TrampolineSchedulerInnerCurrentThreadScheduler.schedule(TrampolineScheduler.java:52) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicateSourceSubscriber.onNext(OperatorRetryWithPredicate.java:79) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicateSourceSubscriber.onNext(OperatorRetryWithPredicate.java:45) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservableWeakSingleProducer.request(ScalarSynchronousObservable.java:276) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Subscriber.setProducer(Subscriber.java:209) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservableJustOnSubscribe.call(ScalarSynchronousObservable.java:138) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservableJustOnSubscribe.call(ScalarSynchronousObservable.java:129) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.subscribe(Observable.java:10423) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.subscribe(Observable.java:10390) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.observables.BlockingObservable.blockForSingle(BlockingObservable.java:443) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.observables.BlockingObservable.single(BlockingObservable.java:340) ~[rxjava-1.3.8.jar:1.3.8]
	at com.netflix.client.AbstractLoadBalancerAwareClient.executeWithLoadBalancer(AbstractLoadBalancerAwareClient.java:112) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at org.springframework.cloud.openfeign.ribbon.LoadBalancerFeignClient.execute(LoadBalancerFeignClient.java:63) ~[spring-cloud-openfeign-core-2.0.2.RELEASE.jar:2.0.2.RELEASE]
	at feign.SynchronousMethodHandler.executeAndDecode(SynchronousMethodHandler.java:98) ~[feign-core-9.7.0.jar:na]
	at feign.SynchronousMethodHandler.invoke(SynchronousMethodHandler.java:77) ~[feign-core-9.7.0.jar:na]
	at feign.hystrix.HystrixInvocationHandler1.run(HystrixInvocationHandler.java:107) ~[feign-hystrix-9.7.0.jar:na]
	at com.netflix.hystrix.HystrixCommand2.call(HystrixCommand.java:302) ~[hystrix-core-1.5.12.jar:1.5.12]
	at com.netflix.hystrix.HystrixCommand2.call(HystrixCommand.java:298) ~[hystrix-core-1.5.12.jar:1.5.12]
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:46) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:35) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:51) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:35) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorSubscribeOnSubscribeOnSubscriber.call(OperatorSubscribeOn.java:100) ~[rxjava-1.3.8.jar:1.3.8]
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction1.call(HystrixContexSchedulerAction.java:56) ~[hystrix-core-1.5.12.jar:1.5.12]
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction1.call(HystrixContexSchedulerAction.java:47) ~[hystrix-core-1.5.12.jar:1.5.12]
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction.call(HystrixContexSchedulerAction.java:69) ~[hystrix-core-1.5.12.jar:1.5.12]
	at rx.internal.schedulers.ScheduledAction.run(ScheduledAction.java:55) ~[rxjava-1.3.8.jar:1.3.8]
	at java.util.concurrent.ExecutorsRunnableAdapter.call(Executors.java:511) ~[na:1.8.0_181]
	at java.util.concurrent.FutureTask.run$$capture(FutureTask.java:266) ~[na:1.8.0_181]
	at java.util.concurrent.FutureTask.run(FutureTask.java) ~[na:1.8.0_181]
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149) ~[na:1.8.0_181]
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624) ~[na:1.8.0_181]
	at java.lang.Thread.run(Thread.java:748) [na:1.8.0_181]



~~~





nested exception is com.netflix.hystrix.exception.HystrixRuntimeException





