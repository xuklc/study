

### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713

### 服务注册

#### 2 服务端处理注册请求

##### Lease

renew()服务续约的方法

8 EurekaServiceRegistry.maybeInitializeClient  

9 EurekaRegistration.getEurekaClient()

10 

10 ServletContainer.service() --> AbstractInstanceRegistry.register()

​    ServletContainer继承了HttpServlet

包含gateway,ribbon,histryix

### 定时任务 

PeerReplicationResource.batchReplication()

### 心跳维持

client和server

### 问题

先搞定服务注册和心跳维持，然后再看配置的解析

@ConditionalOnClass、@ConditionalOnProperty、@AutoConfigureBefore、@AutoConfigureAfter







### 定时任务服务续约 

DiscoveryClient

EurekaAotuServiceRegistration smartLifecycle

```java
@Inject
DiscoveryClient(...){
    initScheduledTasks
}
```



~~~java


~~~
#### 客户端

new  CloudEurekaClient()

DiscoveryClient是CloudEurekaClient的父类

1 DiscoveryClient.refreshRegistry()

2 DiscoveryClient.getAndUpdateDelta//发送post请求

2.1 instancesMap.put()//更新实例信息

3 取到返回的数据，更新版本号



#### 服务端



1 InstanceResource.renewLease()//更新是put请求 

2 AbstractInstanceRegistry.renew()

2.1Map<String, Lease<InstanceInfo>> gMap = registry.get(appName);//根据应用名称获取实例信息

2.2 instanceInfo.setStatusWithoutDirty(overriddenInstanceStatus)//设置实例的状态是UP

2.3 leaseToRenew.renew()//更新最后上线时间lastUpdateTimestamp

3 PeerAwareInstanceRegistryImpl.renew()

3.1 replicateToPeers()//转发到集群



5 instancesMap--本地缓存服务列表

AOP 
redis集群
缓存击穿



### 客户端自动注册的过程

配置的解析，注解是怎么起作用的--todo ,看需要

#### DiscoveryClient的初始化

DiscoveryClient的注入初始化

1 CloudEurekaClient是DiscoveryClient子类

~~~java
@Configuration
@ConditionalOnRefreshScope
protected static class RefreshableEurekaClientConfiguration{
   @Bean(destroyMethod = "shutdown")
	@ConditionalOnMissingBean(value = EurekaClient.class, search =SearchStrategy.CURRENT)
		@org.springframework.cloud.context.config.annotation.RefreshScope
		@Lazy
		public EurekaClient eurekaClient(ApplicationInfoManager manager, 		                     EurekaClientConfig config, EurekaInstanceConfig instance) {
			manager.getInfo(); // force initialization
			return new CloudEurekaClient(manager, config, this.optionalArgs,
					this.context);
		} 
}
CloudEurekaClient(){
    super(applicationInfoManager, config, args);
}
~~~

**2 initScheduledTasks()在DisveryClient初始化时被调用**

~~~java
@Inject
    DiscoveryClient(ApplicationInfoManager applicationInfoManager, EurekaClientConfig config, AbstractDiscoveryClientOptionalArgs args,
                    Provider<BackupRegistry> backupRegistryProvider) {
        ...
            scheduler = Executors.newScheduledThreadPool(2,
                    new ThreadFactoryBuilder()
                            .setNameFormat("DiscoveryClient-%d")
                            .setDaemon(true)
                            .build());
            initScheduledTasks();
    }
~~~

3 initScheduledTasks和onDemandUpdate()方法的代码

~~~java
//1 初始化notify()和onDemandUpdate()
private void initScheduledTasks() {
    ... 
   // InstanceInfo replicator
            instanceInfoReplicator = new InstanceInfoReplicator(
                    this,
                    instanceInfo,
                    clientConfig.getInstanceInfoReplicationIntervalSeconds(),
                    2); // burstSize
			// 重点1
            statusChangeListener = new ApplicationInfoManager.StatusChangeListener() {
                @Override
                public String getId() {
                    return "statusChangeListener";
                }

                @Override
                public void notify(StatusChangeEvent statusChangeEvent) {
                    if (InstanceStatus.DOWN == statusChangeEvent.getStatus() ||
                            InstanceStatus.DOWN == statusChangeEvent.getPreviousStatus()) {
                        // log at warn level if DOWN was involved
                        logger.warn("Saw local status change event {}", statusChangeEvent);
                    } else {
                        logger.info("Saw local status change event {}", statusChangeEvent);
                    }
                    // 重点2
                    instanceInfoReplicator.onDemandUpdate();
                }
                // 重点3，这里注册了statusChangeListener监听器
               applicationInfoManager.registerStatusChangeListener(statusChangeListener);
            };
    ...
}
// 2 InstanceInfoReplicator.this.run()
public boolean onDemandUpdate() {
        if (rateLimiter.acquire(burstSize, allowedRatePerMinute)) {
            if (!scheduler.isShutdown()) {
                scheduler.submit(new Runnable() {
                    @Override
                    public void run() {
                        logger.debug("Executing on-demand update of local InstanceInfo");
    
                        Future latestPeriodic = scheduledPeriodicRef.get();
                        if (latestPeriodic != null && !latestPeriodic.isDone()) {
                            logger.debug("Canceling the latest scheduled update, it will be rescheduled at the end of on demand update");
                            latestPeriodic.cancel(false);
                        }
    
                        InstanceInfoReplicator.this.run();
                    }
                });
                return true;
            }
            ...
    }
//InstanceInfoReplicator的run()--InstanceInfoReplicator implements Runnable实现Runnable接口
// 调用discoveryClient.register();    
     public void run() {
        try {
            discoveryClient.refreshInstanceInfo();

            Long dirtyTimestamp = instanceInfo.isDirtyWithTime();
            if (dirtyTimestamp != null) {
                discoveryClient.register();
                instanceInfo.unsetIsDirty(dirtyTimestamp);
            }
        } catch (Throwable t) {
            logger.warn("There was a problem with the instance info replicator", t);
        } finally {
            Future next = scheduler.schedule(this, replicationIntervalSeconds, TimeUnit.SECONDS);
            scheduledPeriodicRef.set(next);
        }
    }
~~~

![](D:\softpackage\note\note\images\eurekaAotuRegister_UP.png)

#### SpringApplication.run()

#### IOC初始化

##### 1 AbstractApplicationContext

1 refresh()-->finishRefresh()-->getLifecycleProcessor().onRefresh();

##### 2 DefaultLifecycleProcessor

onRefresh-->startBeans(true)-->phases.get(key).start();  

##### 3 EurekaAutoServiceRegistration

**EurekaAutoServiceRegistration实现了SmartLifecycle接口,SmartLifecycle接口继承了Lifecycle**

##### 4 EurekaSerivceRegistry

 register()

~~~java
public void register(EurekaRegistration reg) {
    ...
    reg.getApplicationInfoManager()
				.setInstanceStatus(reg.getInstanceConfig().getInitialStatus());
    ...
                                             }

~~~

##### 5 ApplicationInfoManager

~~~java
public synchronized void setInstanceStatus(InstanceStatus status) {
    ...
        InstanceStatus prev = instanceInfo.setStatus(next);
        if (prev != null) {
            for (StatusChangeListener listener : listeners.values()) {
                try {
        // 这里回调了StatusChangeListener接口的notify(),然后调用到DiscoveryClient.register()
                    listener.notify(new StatusChangeEvent(prev, next));
                } catch (Exception e) {
                    logger.warn("failed to notify listener: {}", listener.getId(), e);
                }
            }
        }
     ...
}

~~~

#### DiscoveryClient.regeister()

**EurekaHttpClientDecorator重点使用了装饰模式**

~~~java
// EurekaHttpClientDecorator装饰模式内部接口
public interface RequestExecutor<R> {
        EurekaHttpResponse<R> execute(EurekaHttpClient delegate);

        RequestType getRequestType();
    }
// 具体实现
@Override
    public EurekaHttpResponse<Void> register(final InstanceInfo info) {
        return execute(new RequestExecutor<Void>() {
            @Override
            public EurekaHttpResponse<Void> execute(EurekaHttpClient delegate) {
                //  重点就在这里
                return delegate.register(info);
            }

            @Override
            public RequestType getRequestType() {
                return RequestType.Register;
            }
        });
    }
~~~

#### 装饰器的实现

RetryableEurekaHttpClient、RedirectingEurekaHttpClient、MetricsCollectingEurekaHttpClient都继承了EurekaHttpClientDecorator装饰器

![](D:\softpackage\note\note\images\eurekaClient装饰模式实现.png)

#### AbstractJerseyEurekaHttpClient.register()

发送post请求

~~~java
Builder resourceBuilder = jerseyClient.resource(serviceUrl).path(urlPath).getRequestBuilder();
            addExtraHeaders(resourceBuilder);
            response = resourceBuilder
                    .header("Accept-Encoding", "gzip")
                    .type(MediaType.APPLICATION_JSON_TYPE)
                    .accept(MediaType.APPLICATION_JSON)
                    .post(ClientResponse.class, info);
~~~



### 客户端定时续约的过程

#### 定时器的初始化

~~~java
private void initScheduledTasks() {
    // 默认是30
int registryFetchIntervalSeconds = clientConfig.getRegistryFetchIntervalSeconds();
// 默认是10
    int expBackOffBound = clientConfig.getCacheRefreshExecutorExponentialBackOffBound();
            scheduler.schedule(
                    new TimedSupervisorTask(
                            "cacheRefresh",
                            scheduler,
                            cacheRefreshExecutor,
                            registryFetchIntervalSeconds,
                            TimeUnit.SECONDS,
                            expBackOffBound,
                            new CacheRefreshThread()
                    ),
                    registryFetchIntervalSeconds, TimeUnit.SECONDS);
}

~~~

### 定时任务的刷新

refreshRegistry()-->fetchRegistry()-->getAndStoreFullRegistry();()/getAndUpdateDelta(applications);

#### 定时任务使用scheduler.schedule()实现定时刷新的逻辑

~~~java
public void run() {
    ...
} catch (TimeoutException e) {
            logger.warn("task supervisor timed out", e);
            timeoutCounter.increment();

            long currentDelay = delay.get();
    //  超时之后延迟时间乘以2
            long newDelay = Math.min(maxDelay, currentDelay * 2);
            delay.compareAndSet(currentDelay, newDelay);

        }
    if (!scheduler.isShutdown()) {
                scheduler.schedule(this, delay.get(), TimeUnit.MILLISECONDS);
            }
    ...
}

~~~

### 服务端接受注册请求



### 服务端接受续约请求








































