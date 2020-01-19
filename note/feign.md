### feign 服务调用源码流程

学习链接:https://blog.csdn.net/alex_xfboy/article/details/88167400

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



### 服务调用整个过程

https://blog.csdn.net/lgq2626/article/details/80392914

https://segmentfault.com/a/1190000014981170

IOC

~~~java
public void refresh() throws BeansException, IllegalStateException {
        synchronized (this.startupShutdownMonitor) {

            // 扫描本项目里面的java文件，把bean对象封装成BeanDefinitiaon对象，然后调用DefaultListableBeanFactory#registerBeanDefinition()方法把beanName放到DefaultListableBeanFactory 的 List<String> beanDefinitionNames 中去
            ConfigurableListableBeanFactory beanFactory = obtainFreshBeanFactory();

            // Prepare the bean factory for use in this context.
            prepareBeanFactory(beanFactory);

            try {
                postProcessBeanFactory(beanFactory);

                // 在这里调用到FeignClientsRegistrar对象的registerBeanDefinitions()方法
                invokeBeanFactoryPostProcessors(beanFactory);

                //从DefaultListableBeanFactory里面的beanDefinitionNames中找到所有实现了BeanPostProcessor接口的方法，如果有排序进行排序后放到list中
                registerBeanPostProcessors(beanFactory);

                //Spring的国际化
                initMessageSource();

                // 
                initApplicationEventMulticaster();

                // Initialize other special beans in specific context subclasses.
                onRefresh();

                // 
                registerListeners();

                // Spring的IOC、ID处理。Spring的AOP。事务都是在IOC完成之后调用了BeanPostProcessor#postProcessBeforeInitialization()和postProcessBeforeInitialization()方法，AOP(事务)就是在这里处理的
                finishBeanFactoryInitialization(beanFactory);

                // 执行完之后调用实现了所有LifecycleProcessor接口的类的onRefresh()方法，同时调用所有观察了ApplicationEvent接口的事件(观察者模式)
                finishRefresh();
            }

            catch (BeansException ex) {

                // 找到所有实现了DisposableBean接口的方法，调用了destroy()方法，这就是bean的销毁
                destroyBeans();

                // Reset 'active' flag.
                cancelRefresh(ex);

                throw ex;
            }

            finally {
                resetCommonCaches();
            }
        }
    }
~~~

~~~java
com.netflix.hystrix.exception.HystrixRuntimeException: WarehouseFegin#getByheadAndBodyParam(Map) failed and no fallback available.
	at com.netflix.hystrix.AbstractCommand$22.call(AbstractCommand.java:819)
	at com.netflix.hystrix.AbstractCommand$22.call(AbstractCommand.java:804)
	at rx.internal.operators.OperatorOnErrorResumeNextViaFunction$4.onError(OperatorOnErrorResumeNextViaFunction.java:140)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at com.netflix.hystrix.AbstractCommand$DeprecatedOnFallbackHookApplication$1.onError(AbstractCommand.java:1472)
	at com.netflix.hystrix.AbstractCommand$FallbackHookApplication$1.onError(AbstractCommand.java:1397)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at rx.observers.Subscribers$5.onError(Subscribers.java:230)
	at rx.internal.operators.OnSubscribeThrow.call(OnSubscribeThrow.java:44)
	at rx.internal.operators.OnSubscribeThrow.call(OnSubscribeThrow.java:28)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:51)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:35)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OperatorOnErrorResumeNextViaFunction$4.onError(OperatorOnErrorResumeNextViaFunction.java:142)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at com.netflix.hystrix.AbstractCommand$HystrixObservableTimeoutOperator$2.onError(AbstractCommand.java:1194)
	at rx.internal.operators.OperatorSubscribeOn$SubscribeOnSubscriber.onError(OperatorSubscribeOn.java:80)
	at rx.observers.Subscribers$5.onError(Subscribers.java:230)
	at rx.internal.operators.OnSubscribeDoOnEach$DoOnEachSubscriber.onError(OnSubscribeDoOnEach.java:87)
	at rx.observers.Subscribers$5.onError(Subscribers.java:230)
	at com.netflix.hystrix.AbstractCommand$DeprecatedOnRunHookApplication$1.onError(AbstractCommand.java:1431)
	at com.netflix.hystrix.AbstractCommand$ExecutionHookApplication$1.onError(AbstractCommand.java:1362)
	at rx.observers.Subscribers$5.onError(Subscribers.java:230)
	at rx.observers.Subscribers$5.onError(Subscribers.java:230)
	at rx.internal.operators.OnSubscribeThrow.call(OnSubscribeThrow.java:44)
	at rx.internal.operators.OnSubscribeThrow.call(OnSubscribeThrow.java:28)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:51)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:35)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:51)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:35)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:41)
	at rx.internal.operators.OnSubscribeDoOnEach.call(OnSubscribeDoOnEach.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OperatorSubscribeOn$SubscribeOnSubscriber.call(OperatorSubscribeOn.java:100)
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction$1.call(HystrixContexSchedulerAction.java:56)
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction$1.call(HystrixContexSchedulerAction.java:47)
	at com.netflix.hystrix.strategy.concurrency.HystrixContexSchedulerAction.call(HystrixContexSchedulerAction.java:69)
	at rx.internal.schedulers.ScheduledAction.run(ScheduledAction.java:55)
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)
	at java.util.concurrent.FutureTask.run$$$capture(FutureTask.java:266)
	at java.util.concurrent.FutureTask.run(FutureTask.java)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1149)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:624)
	at java.lang.Thread.run(Thread.java:748)
Caused by: java.lang.RuntimeException: com.netflix.client.ClientException: Load balancer does not have available server for client: iservice-admin-liuqi
	at org.springframework.cloud.openfeign.ribbon.LoadBalancerFeignClient.execute(LoadBalancerFeignClient.java:71)
	at feign.SynchronousMethodHandler.executeAndDecode(SynchronousMethodHandler.java:98)
	at feign.SynchronousMethodHandler.invoke(SynchronousMethodHandler.java:77)
	at feign.hystrix.HystrixInvocationHandler$1.run(HystrixInvocationHandler.java:107)
	at com.netflix.hystrix.HystrixCommand$2.call(HystrixCommand.java:302)
	at com.netflix.hystrix.HystrixCommand$2.call(HystrixCommand.java:298)
	at rx.internal.operators.OnSubscribeDefer.call(OnSubscribeDefer.java:46)
	... 27 common frames omitted
Caused by: com.netflix.client.ClientException: Load balancer does not have available server for client: iservice-admin-liuqi
	at com.netflix.loadbalancer.LoadBalancerContext.getServerFromLoadBalancer(LoadBalancerContext.java:483)
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand$1.call(LoadBalancerCommand.java:184)
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand$1.call(LoadBalancerCommand.java:180)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:94)
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:42)
	at rx.Observable.unsafeSubscribe(Observable.java:10327)
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber$1.call(OperatorRetryWithPredicate.java:127)
	at rx.internal.schedulers.TrampolineScheduler$InnerCurrentThreadScheduler.enqueue(TrampolineScheduler.java:73)
	at rx.internal.schedulers.TrampolineScheduler$InnerCurrentThreadScheduler.schedule(TrampolineScheduler.java:52)
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber.onNext(OperatorRetryWithPredicate.java:79)
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber.onNext(OperatorRetryWithPredicate.java:45)
	at rx.internal.util.ScalarSynchronousObservable$WeakSingleProducer.request(ScalarSynchronousObservable.java:276)
	at rx.Subscriber.setProducer(Subscriber.java:209)
	at rx.internal.util.ScalarSynchronousObservable$JustOnSubscribe.call(ScalarSynchronousObservable.java:138)
	at rx.internal.util.ScalarSynchronousObservable$JustOnSubscribe.call(ScalarSynchronousObservable.java:129)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:48)
	at rx.internal.operators.OnSubscribeLift.call(OnSubscribeLift.java:30)
	at rx.Observable.subscribe(Observable.java:10423)
	at rx.Observable.subscribe(Observable.java:10390)
	at rx.observables.BlockingObservable.blockForSingle(BlockingObservable.java:443)
	at rx.observables.BlockingObservable.single(BlockingObservable.java:340)
	at com.netflix.client.AbstractLoadBalancerAwareClient.executeWithLoadBalancer(AbstractLoadBalancerAwareClient.java:112)
	at org.springframework.cloud.openfeign.ribbon.LoadBalancerFeignClient.execute(LoadBalancerFeignClient.java:63)
	... 33 common frames omitted
~~~

### feign服务调用的过程

回调模式

异步线程--非阻塞模式

org.springframework.cloud.openfeign.ribbon.LoadBalancerFeignClient.execute(LoadBalancerFeignClient.java:71)

第二个日志

~~~java
com.netflix.client.ClientException: Load balancer does not have available server for client: spring-cloud-producer-1
	at com.netflix.loadbalancer.LoadBalancerContext.getServerFromLoadBalancer(LoadBalancerContext.java:483) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand$1.call(LoadBalancerCommand.java:184) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at com.netflix.loadbalancer.reactive.LoadBalancerCommand$1.call(LoadBalancerCommand.java:180) ~[ribbon-loadbalancer-2.2.5.jar:2.2.5]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:94) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OnSubscribeConcatMap.call(OnSubscribeConcatMap.java:42) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Observable.unsafeSubscribe(Observable.java:10327) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber$1.call(OperatorRetryWithPredicate.java:127) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.schedulers.TrampolineScheduler$InnerCurrentThreadScheduler.enqueue(TrampolineScheduler.java:73) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.schedulers.TrampolineScheduler$InnerCurrentThreadScheduler.schedule(TrampolineScheduler.java:52) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber.onNext(OperatorRetryWithPredicate.java:79) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.operators.OperatorRetryWithPredicate$SourceSubscriber.onNext(OperatorRetryWithPredicate.java:45) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservable$WeakSingleProducer.request(ScalarSynchronousObservable.java:276) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.Subscriber.setProducer(Subscriber.java:209) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservable$JustOnSubscribe.call(ScalarSynchronousObservable.java:138) ~[rxjava-1.3.8.jar:1.3.8]
	at rx.internal.util.ScalarSynchronousObservable$JustOnSubscribe.call(ScalarSynchronousObservable.java:129) ~[rxjava-1.3.8.jar:1.3.8]
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
	at feign.ReflectiveFeign$FeignInvocationHandler.invoke(ReflectiveFeign.java:102) ~[feign-core-9.7.0.jar:na]
	at com.sun.proxy.$Proxy107.feignHello(Unknown Source) ~[na:na]
	at com.neo.controller.HelloController.firstFeign(HelloController.java:28) ~[classes/:na]
~~~

**RxJavaHooks**

调用类

1 LoadBalanceFeignClient

2 



### 配置

1 注解配置

~~~java
@Configuration
public class MyConfig {
    @Bean
    public Request.Options options(){
        Request.Options o = new Options(1000, 1000);
        return o;
    }
}
~~~

然后在注解上@FeignClient指定

```java
@FeignClient(name="",url="",configuration= {MyConfig.class})
```

@EnableFeignClients来全局指定：

```java
@EnableFeignClients(defaultConfiguration=MyConfig.class)
```

2 yml文件配置

~~~yml
# 对所有的feignclient生效
ribbon.ReadTimeout=10000
ribbon.ConnectTimeout=2000

# 对指定的feignclien生效
[feignclientName].ribbon.ReadTimeout=10000
[feignclientName].ribbon.ConnectTimeout=2000
~~~

https://www.jianshu.com/p/cd3557b1a474



### 梳理流程

https://blog.csdn.net/woshilijiuyi/article/details/82959041



#### 1feign调用

#### feign的拦截器

**feign.RequestInterceptor**

拦截器的实现原理

SynchronousMethodHandler.targetRequest()执行RequestInterceptor拦截器的业务代码

~~~java
Object executeAndDecode(RequestTemplate template) throws Throwable {
    Request request = targetRequest(template);
    ...
}
Request targetRequest(RequestTemplate template) {
    for (RequestInterceptor interceptor : requestInterceptors) {
      interceptor.apply(template);
    }
    return target.apply(new RequestTemplate(template));
  }
~~~

1 HystrixCommand.queue()

2 AbstractCommand.toObservable()

~~~java
final Func0<Observable<R>> applyHystrixSemantics = new Func0<Observable<R>>() {
            @Override
            public Observable<R> call() {
                if (commandState.get().equals(CommandState.UNSUBSCRIBED)) {
                    return Observable.never();
                }
                return applyHystrixSemantics(_cmd);
            }
        };
...
Observable<R> hystrixObservable =
                        Observable.defer(applyHystrixSemantics)
                                .map(wrapWithAllOnNextHooks);
...
~~~

3 AbstractCommand.applyHystrixSemantics()

  ~~~java
if (executionSemaphore.tryAcquire()) {
                try {
                    /* used to track userThreadExecutionTime */
                    executionResult = executionResult.setInvocationStartTime(System.currentTimeMillis());
                    //
                    return executeCommandAndObserve(_cmd)
                            .doOnError(markExceptionThrown)
                            .doOnTerminate(singleSemaphoreRelease)
                            .doOnUnsubscribe(singleSemaphoreRelease);
                } catch (RuntimeException e) {
                    return Observable.error(e);
                }
            } else {
    			// 报错回调这里
                return handleSemaphoreRejectionViaFallback();
            }
  ~~~

4  AbstractCommand.executeCommandAndObserve()

~~~java
if (properties.executionTimeoutEnabled().get()) {
            execution = executeCommandWithSpecifiedIsolation(_cmd)
                    .lift(new HystrixObservableTimeoutOperator<R>(_cmd));
        } else {
            execution = executeCommandWithSpecifiedIsolation(_cmd);
        }
~~~

5 AbstractCommand.executeCommandWithSpecifiedIsolation()

~~~java
try {
                            executionHook.onThreadStart(_cmd);
                            executionHook.onRunStart(_cmd);
                            executionHook.onExecutionStart(_cmd);
                            return getUserExecutionObservable(_cmd);
                        } catch (Throwable ex) {
                            return Observable.error(ex);
                        }
~~~

6 AbstractCommand.getUserExecutionObservable()

~~~java
try {
            userObservable = getExecutionObservable();
        } catch (Throwable ex) {
            // the run() method is a user provided implementation so can throw instead of using Observable.onError
            // so we catch it here and turn it into Observable.error
            userObservable = Observable.error(ex);
        }
~~~

7 HystrixCommand.getExecutionObservable()

~~~java
return Observable.defer(new Func0<Observable<R>>() {
            @Override
            public Observable<R> call() {
                try {
                    return Observable.just(run());
                } catch (Throwable ex) {
                    return Observable.error(ex);
                }
            }
        }).doOnSubscribe(new Action0() {
            @Override
            public void call() {
                // Save thread on which we get subscribed so that we can interrupt it later if needed
                executionThread.set(Thread.currentThread());
            }
        });
~~~

8 HystrixInvocationHandler.invoke()-->run

```java
HystrixCommand<Object> hystrixCommand = new HystrixCommand<Object>(setterMethodMap.get(method)) {
      @Override
      protected Object run() throws Exception {
        try {
          return HystrixInvocationHandler.this.dispatch.get(method).invoke(args);
        } catch (Exception e) {
          throw e;
        } catch (Throwable t) {
          throw (Error) t;
        }
      }
```

9 SynchronousMethodHandler.invoke()

~~~java
public Object invoke(Object[] argv) throws Throwable {
    RequestTemplate template = buildTemplateFromArgs.create(argv);
    Retryer retryer = this.retryer.clone();
    while (true) {
      try {
        return executeAndDecode(template);
      } catch (RetryableException e) {
        retryer.continueOrPropagate(e);
        if (logLevel != Logger.Level.NONE) {
          logger.logRetry(metadata.configKey(), logLevel);
        }
        continue;
      }
    }
  }
~~~

10 重试机制

~~~java
public void continueOrPropagate(RetryableException e) {
      if (attempt++ >= maxAttempts) {
        throw e;
      }

      long interval;
      if (e.retryAfter() != null) {
        interval = e.retryAfter().getTime() - currentTimeMillis();
        if (interval > maxPeriod) {
          interval = maxPeriod;
        }
        if (interval < 0) {
          return;
        }
      } else {
        interval = nextMaxInterval();
      }
      try {
        Thread.sleep(interval);
      } catch (InterruptedException ignored) {
        Thread.currentThread().interrupt();
        throw e;
      }
      sleptForMillis += interval;
    }
~~~

#### 2ribbon负载均衡

**RetryTemplate**

1 SynchronousMethodHandler.invoke()

~~~java
public Object invoke(Object[] argv) throws Throwable {
    RequestTemplate template = buildTemplateFromArgs.create(argv);
    Retryer retryer = this.retryer.clone();
    while (true) {
      try {
        return executeAndDecode(template);
      } catch (RetryableException e) {
        retryer.continueOrPropagate(e);
        if (logLevel != Logger.Level.NONE) {
          logger.logRetry(metadata.configKey(), logLevel);
        }
        continue;
      }
    }
  }
~~~

2 LoadBalancerFeignClient.execute()

~~~java
URI asUri = URI.create(request.url());
			String clientName = asUri.getHost();
			URI uriWithoutHost = cleanUrl(request.url(), clientName);
			FeignLoadBalancer.RibbonRequest ribbonRequest = new FeignLoadBalancer.RibbonRequest(
					this.delegate, request, uriWithoutHost);

			IClientConfig requestConfig = getClientConfig(options, clientName);
			return lbClient(clientName).executeWithLoadBalancer(ribbonRequest,
					requestConfig).toResponse();
~~~

2.2 AbstractLoadBalancerAwareClient.executeWithLoadBalancer()

~~~java
public T executeWithLoadBalancer(final S request, final IClientConfig requestConfig) throws ClientException {
        LoadBalancerCommand<T> command = buildLoadBalancerCommand(request, requestConfig);

        try {
            return command.submit(
                new ServerOperation<T>() {
                    @Override
                    public Observable<T> call(Server server) {
                        URI finalUri = reconstructURIWithServer(server, request.getUri());
                        S requestForServer = (S) request.replaceUri(finalUri);
                        try {
                            return Observable.just(AbstractLoadBalancerAwareClient.this.execute(requestForServer, requestConfig));
                        } 
                        catch (Exception e) {
                            return Observable.error(e);
                        }
                    }
                })
                .toBlocking()
                .single();
        } catch (Exception e) {
            Throwable t = e.getCause();
            if (t instanceof ClientException) {
                throw (ClientException) t;
            } else {
                throw new ClientException(e);
            }
        }
        
    }
~~~

3 RetryableFeignLoadBalancer.executeWithLoadBalancer()

4 RetryableFeignLoadBalancer.execute()

~~~java
public RibbonResponse execute(final RibbonRequest request, IClientConfig configOverride){
    // ribbon的连接超时时间和读取时间生效的代码
    options = new Request.Options(
					ribbon.connectTimeout(this.connectTimeout),
					ribbon.readTimeout(this.readTimeout));
    // 负载均衡重试策略
    final LoadBalancedRetryPolicy retryPolicy = loadBalancedRetryFactory.createRetryPolicy(this.getClientName(), this);
    // 回调策略
    BackOffPolicy backOffPolicy = loadBalancedRetryFactory.createBackOffPolicy(this.getClientName());
    
    return retryTemplate.execute(new RetryCallback<RibbonResponse, IOException>() {
			@Override
			public RibbonResponse doWithRetry(RetryContext retryContext) throws IOException {
				Request feignRequest = null;
				//on retries the policy will choose the server and set it in the context
				//extract the server and update the request being made
				if (retryContext instanceof LoadBalancedRetryContext) {
					ServiceInstance service = ((LoadBalancedRetryContext) retryContext).getServiceInstance();
					if (service != null) {
						feignRequest = ((RibbonRequest) request.replaceUri(reconstructURIWithServer(new Server(service.getHost(), service.getPort()), request.getUri()))).toRequest();
					}
				}
				if (feignRequest == null) {
					feignRequest = request.toRequest();
				}
				Response response = request.client().execute(feignRequest, options);
				if (retryPolicy.retryableStatusCode(response.status())) {
					byte[] byteArray = response.body() == null ? new byte[]{} : StreamUtils.copyToByteArray(response.body().asInputStream());
					response.close();
					throw new RibbonResponseStatusCodeException(RetryableFeignLoadBalancer.this.clientName, response,
							byteArray, request.getUri());
				}
				return new RibbonResponse(request.getUri(), response);
			}
		}, new LoadBalancedRecoveryCallback<RibbonResponse, Response>() {
			@Override
			protected RibbonResponse createResponse(Response response, URI uri) {
				return new RibbonResponse(uri, response);
			}
		});
}
~~~





5  feign.Client.execute()

~~~java
@Override
    public Response execute(Request request, Options options) throws IOException {
      HttpURLConnection connection = convertAndSend(request, options);
      return convertResponse(connection).toBuilder().request(request).build();
    }
~~~

6 feign.Client.convertAndSend()

~~~java
HttpURLConnection convertAndSend(Request request, Options options) throws IOException {
     final HttpURLConnection
          connection =
          (HttpURLConnection) new URL(request.url()).openConnection();
    ... 
        connection.setDoOutput(true);
        OutputStream out = connection.getOutputStream();
        if (gzipEncodedRequest) {
          out = new GZIPOutputStream(out);
        } else if (deflateEncodedRequest) {
          out = new DeflaterOutputStream(out);
        }
        try {
          out.write(request.body());
        } finally {
          try {
            out.close();
          } catch (IOException suppressed) { // NOPMD
          }
        }
}
~~~

### 注解和配置的解析

1 FeignClientsRegistrar

**FeignClientsRegistrar类实现了ImportBeanDefinitionRegistrar接口**

// 1 扫描EnableFeignClients注解得到basePackages

// 2 通过basePackages扫描FeignClient客户端，并解析类中的url,fallback等信息

```java
private void registerDefaultConfiguration(AnnotationMetadata metadata,
			BeanDefinitionRegistry registry) {
		Map<String, Object> defaultAttrs = metadata
				.getAnnotationAttributes(EnableFeignClients.class.getName(), true);

		if (defaultAttrs != null && defaultAttrs.containsKey("defaultConfiguration")) {
			String name;
			if (metadata.hasEnclosingClass()) {
				name = "default." + metadata.getEnclosingClassName();
			}
			else {
				name = "default." + metadata.getClassName();
			}
			registerClientConfiguration(registry, name,
					defaultAttrs.get("defaultConfiguration"));
		}
	}

public void registerFeignClients(AnnotationMetadata metadata,
			BeanDefinitionRegistry registry) {
		ClassPathScanningCandidateComponentProvider scanner = getScanner();
		scanner.setResourceLoader(this.resourceLoader);

		Set<String> basePackages;

		Map<String, Object> attrs = metadata
				.getAnnotationAttributes(EnableFeignClients.class.getName());
		AnnotationTypeFilter annotationTypeFilter = new AnnotationTypeFilter(
				FeignClient.class);
		final Class<?>[] clients = attrs == null ? null
				: (Class<?>[]) attrs.get("clients");
		if (clients == null || clients.length == 0) {
			scanner.addIncludeFilter(annotationTypeFilter);
			basePackages = getBasePackages(metadata);
		}
		else {
			final Set<String> clientClasses = new HashSet<>();
			basePackages = new HashSet<>();
			for (Class<?> clazz : clients) {
				basePackages.add(ClassUtils.getPackageName(clazz));
				clientClasses.add(clazz.getCanonicalName());
			}
			AbstractClassTestingTypeFilter filter = new AbstractClassTestingTypeFilter() {
				@Override
				protected boolean match(ClassMetadata metadata) {
					String cleaned = metadata.getClassName().replaceAll("\\$", ".");
					return clientClasses.contains(cleaned);
				}
			};
			scanner.addIncludeFilter(
					new AllTypeFilter(Arrays.asList(filter, annotationTypeFilter)));
		}

		for (String basePackage : basePackages) {
			Set<BeanDefinition> candidateComponents = scanner
					.findCandidateComponents(basePackage);
			for (BeanDefinition candidateComponent : candidateComponents) {
				if (candidateComponent instanceof AnnotatedBeanDefinition) {
					// verify annotated class is an interface
					AnnotatedBeanDefinition beanDefinition = (AnnotatedBeanDefinition) candidateComponent;
					AnnotationMetadata annotationMetadata = beanDefinition.getMetadata();
					Assert.isTrue(annotationMetadata.isInterface(),
							"@FeignClient can only be specified on an interface");

					Map<String, Object> attributes = annotationMetadata
							.getAnnotationAttributes(
									FeignClient.class.getCanonicalName());

					String name = getClientName(attributes);
					registerClientConfiguration(registry, name,
							attributes.get("configuration"));

					registerFeignClient(registry, annotationMetadata, attributes);
				}
			}
		}
	}
// 
private void registerFeignClient(BeanDefinitionRegistry registry,
			AnnotationMetadata annotationMetadata, Map<String, Object> attributes) {
		String className = annotationMetadata.getClassName();
		BeanDefinitionBuilder definition = BeanDefinitionBuilder
				.genericBeanDefinition(FeignClientFactoryBean.class);
		validate(attributes);
		definition.addPropertyValue("url", getUrl(attributes));
		definition.addPropertyValue("path", getPath(attributes));
		String name = getName(attributes);
		definition.addPropertyValue("name", name);
		definition.addPropertyValue("type", className);
		definition.addPropertyValue("decode404", attributes.get("decode404"));
		definition.addPropertyValue("fallback", attributes.get("fallback"));
		definition.addPropertyValue("fallbackFactory", attributes.get("fallbackFactory"));
		definition.setAutowireMode(AbstractBeanDefinition.AUTOWIRE_BY_TYPE);

		String alias = name + "FeignClient";
		AbstractBeanDefinition beanDefinition = definition.getBeanDefinition();

		boolean primary = (Boolean)attributes.get("primary"); // has a default, won't be null

		beanDefinition.setPrimary(primary);

		String qualifier = getQualifier(attributes);
		if (StringUtils.hasText(qualifier)) {
			alias = qualifier;
		}

		BeanDefinitionHolder holder = new BeanDefinitionHolder(beanDefinition, className,
				new String[] { alias });
		BeanDefinitionReaderUtils.registerBeanDefinition(holder, registry);
	}
```

2 配置如何起解析起作用

2.1 AbstractApplicationContext.invokeBeanFactoryPostProcessors()

2.2 ConfigurationClassBeanDefinitionReader.loadBeanDefinitionsForConfigurationClass()

~~~java
private void loadBeanDefinitionsForConfigurationClass(
			ConfigurationClass configClass, TrackedConditionEvaluator trackedConditionEvaluator) {
    // 解析继承ImportBeanDefinitionRegistrar接口的配置
	loadBeanDefinitionsFromRegistrars(configClass.getImportBeanDefinitionRegistrars());   
}

~~~

2.3 

### HystrixFeign



### feign结合ribbon

1 AbstractLoadBalancerAwareClient.executeWithLoadBalancer()

~~~java
public T executeWithLoadBalancer(final S request, final IClientConfig requestConfig) throws ClientException {
        LoadBalancerCommand<T> command = buildLoadBalancerCommand(request, requestConfig);

        try {
            return command.submit(
                new ServerOperation<T>() {
                    @Override
                    public Observable<T> call(Server server) {
                        URI finalUri = reconstructURIWithServer(server, request.getUri());
                        S requestForServer = (S) request.replaceUri(finalUri);
                        try {
                            return Observable.just(AbstractLoadBalancerAwareClient.this.execute(requestForServer, requestConfig));
                        } 
                        catch (Exception e) {
                            return Observable.error(e);
                        }
                    }
                })
                .toBlocking()
                .single();
        } catch (Exception e) {
            Throwable t = e.getCause();
            if (t instanceof ClientException) {
                throw (ClientException) t;
            } else {
                throw new ClientException(e);
            }
        }
        
    }
~~~

2 LoadBalancerCommand.submit()

~~~java
public Observable<T> submit(final ServerOperation<T> operation) {
    ...
      Observable<T> o = 
        // 在这里开始进行客户端的负载均衡selectServer()
                (server == null ? selectServer() : Observable.just(server))
                .concatMap(new Func1<Server, Observable<T>>() {
                    @Override
                    // Called for each server being selected
                    public Observable<T> call(Server server) {
                        context.setServer(server);
                        final ServerStats stats = loadBalancerContext.getServerStats(server);
                        
                        // Called for each attempt and retry
                        Observable<T> o = Observable
                                .just(server)
                                .concatMap(new Func1<Server, Observable<T>>() {
                                    @Override
                                    public Observable<T> call(final Server server) {
                                        context.incAttemptCount();
                                        loadBalancerContext.noteOpenConnection(stats);
                                        
                                        if (listenerInvoker != null) {
                                            try {
                                                listenerInvoker.onStartWithServer(context.toExecutionInfo());
                                            } catch (AbortExecutionException e) {
                                                return Observable.error(e);
                                            }
                                        }
                                        
                                        final Stopwatch tracer = loadBalancerContext.getExecuteTracer().start();
                                        
                                        return operation.call(server).doOnEach(new Observer<T>() {
                                            private T entity;
                                            @Override
                                            public void onCompleted() {
                                                recordStats(tracer, stats, entity, null);
                                                // TODO: What to do if onNext or onError are never called?
                                            }

                                            @Override
                                            public void onError(Throwable e) {
                                                recordStats(tracer, stats, null, e);
                                                logger.debug("Got error {} when executed on server {}", e, server);
                                                if (listenerInvoker != null) {
                                                    listenerInvoker.onExceptionWithServer(e, context.toExecutionInfo());
                                                }
                                            }

                                            @Override
                                            public void onNext(T entity) {
                                                this.entity = entity;
                                                if (listenerInvoker != null) {
                                                    listenerInvoker.onExecutionSuccess(entity, context.toExecutionInfo());
                                                }
                                            }                            
                                            
                                            private void recordStats(Stopwatch tracer, ServerStats stats, Object entity, Throwable exception) {
                                                tracer.stop();
                                                loadBalancerContext.noteRequestCompletion(stats, entity, exception, tracer.getDuration(TimeUnit.MILLISECONDS), retryHandler);
                                            }
                                        });
                                    }
                                });
                        
                        if (maxRetrysSame > 0) 
                            o = o.retry(retryPolicy(maxRetrysSame, true));
                        return o;
                    }
                });
    ...
}
~~~



3 LoadBalancerCommand.selectServer()

~~~java
private Observable<Server> selectServer() {
        return Observable.create(new OnSubscribe<Server>() {
            @Override
            public void call(Subscriber<? super Server> next) {
                try {
                    Server server = loadBalancerContext.getServerFromLoadBalancer(loadBalancerURI, loadBalancerKey);   
                    next.onNext(server);
                    next.onCompleted();
                } catch (Exception e) {
                    next.onError(e);
                }
            }
        });
    }
~~~

4 PredicateBasedRule.choose()

~~~java
public Server choose(Object key) {
        ILoadBalancer lb = getLoadBalancer();
        Optional<Server> server = getPredicate().chooseRoundRobinAfterFiltering(lb.getAllServers(), key);
        if (server.isPresent()) {
            return server.get();
        } else {
            return null;
        }       
    }
~~~





