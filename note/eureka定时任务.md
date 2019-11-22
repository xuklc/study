

### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713

5 instancesMap--本地缓存服务列表

AOP 
redis集群
缓存击穿

# client

## register()

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

```

private boolean fetchRegistry(boolean forceFullRegistryFetch) {
	// 获取当前服务的实例信息
	/**
	* private final Map<String, Application> appNameApplicationMap;
	* applications对象的appNameApplicationMap缓存了上次从eurekaServer获取到所有服务实例信息
	*/
	Applications applications = getApplications();
	
}
```



## fetchRegistry()

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

public int getRegistryFetchIntervalSeconds() {    
    return configInstance.getIntProperty(
        namespace + REGISTRY_REFRESH_INTERVAL_KEY, 30).get();
}
~~~

#### 方法调用链

1 DiscoveryClient.fetchRegistry()

2 DiscoveryClient.getAndStoreFullRegistry();//完成注册后

 DiscoveryClient.getAndUpdateDelta()//定时任务刷新服务的状态和获取全部的服务信息

3 和服务注册的相同是装饰模式的实现，只不过register()改成getDeta()

4  AbstractJerseyEurekaHttpClient.getApplicationsInternal()

~~~java
private EurekaHttpResponse<Applications> getApplicationsInternal(String urlPath, String[] regions) {
        ClientResponse response = null;
        String regionsParamValue = null;
        try {
            WebResource webResource = jerseyClient.resource(serviceUrl).path(urlPath);
            if (regions != null && regions.length > 0) {
                regionsParamValue = StringUtil.join(regions);
                webResource = webResource.queryParam("regions", regionsParamValue);
            }
            Builder requestBuilder = webResource.getRequestBuilder();
            addExtraHeaders(requestBuilder);
            response = requestBuilder.accept(MediaType.APPLICATION_JSON_TYPE).get(ClientResponse.class);
            Applications applications = null;
            if (response.getStatus() == Status.OK.getStatusCode() && response.hasEntity()) {
                applications = response.getEntity(Applications.class);
            }
            return anEurekaHttpResponse(response.getStatus(), Applications.class)
                    .headers(headersOf(response))
                //  设置返回的所有服务实例信息
                    .entity(applications)
                    .build();
        } finally {
            if (response != null) {
                response.close();
            }
        }
    }
~~~

5 DiscoveryClient.updateDelta()

```java
private void updateDelta(Applications delta) {
        int deltaCount = 0;
        for (Application app : delta.getRegisteredApplications()) {
            for (InstanceInfo instance : app.getInstances()) {
                Applications applications = getApplications();
                String instanceRegion = instanceRegionChecker.getInstanceRegion(instance);
                if (!instanceRegionChecker.isLocalRegion(instanceRegion)) {
                    Applications remoteApps = remoteRegionVsApps.get(instanceRegion);
                    if (null == remoteApps) {
                        remoteApps = new Applications();
                        remoteRegionVsApps.put(instanceRegion, remoteApps);
                    }
                    applications = remoteApps;
                }

                ++deltaCount;
                if (ActionType.ADDED.equals(instance.getActionType())) {
                    Application existingApp = applications.getRegisteredApplications(instance.getAppName());
                    if (existingApp == null) {
                        applications.addApplication(app);
                    }
                    logger.debug("Added instance {} to the existing apps in region {}", instance.getId(), instanceRegion);
                    applications.getRegisteredApplications(instance.getAppName()).addInstance(instance);
                } else if (ActionType.MODIFIED.equals(instance.getActionType())) {
                    Application existingApp = applications.getRegisteredApplications(instance.getAppName());
                    if (existingApp == null) {
                        applications.addApplication(app);
                    }
                    logger.debug("Modified instance {} to the existing apps ", instance.getId());

                    applications.getRegisteredApplications(instance.getAppName()).addInstance(instance);

                } else if (ActionType.DELETED.equals(instance.getActionType())) {
                    Application existingApp = applications.getRegisteredApplications(instance.getAppName());
                    if (existingApp == null) {
                        applications.addApplication(app);
                    }
                    logger.debug("Deleted instance {} to the existing apps ", instance.getId());
                    applications.getRegisteredApplications(instance.getAppName()).removeInstance(instance);
                }
            }
        }
        logger.debug("The total number of instances fetched by the delta processor : {}", deltaCount);

        getApplications().setVersion(delta.getVersion());
        getApplications().shuffleInstances(clientConfig.shouldFilterOnlyUpInstances());

        for (Applications applications : remoteRegionVsApps.values()) {
            applications.setVersion(delta.getVersion());
            applications.shuffleInstances(clientConfig.shouldFilterOnlyUpInstances());
        }
    }
```

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

# Server

## register

### 服务端接受注册请求

1 ServletContainer.service()

2 WebApplicationImpl.handleRequest()

  ~~~java
private void _handleRequest(final WebApplicationContext localContext,
                                ContainerRequest request) {
    ...
    // 在这里开始中间各种//各种反射调用和权限校验
    if (!rootsRule.accept(path, null, localContext)) {
                throw new NotFoundException(request.getRequestUri());
    }
    ... 
}
  ~~~



3 ...中间各种//各种反射调用和权限校验

4  ApplicationResource.addInstance()

5 InstanceRegistry.register()

6 PeerAwareInstanceRegistryImpl

~~~java
super.register(info, leaseDuration, isReplication);
        replicateToPeers(Action.Register, info.getAppName(), info.getId(), info, null, isReplication);
~~~

7 AbstractInstanceRegistry.register()

​	  ConcurrentHashMap  registry//存放实例信息

   1 第一次注册的时候根据应用名称获取实例信息

```java
Map<String, Lease<InstanceInfo>> gMap = registry.get(registrant.getAppName());
```

   2 设置Lease对象的serviceUpTimestamp和lastUpadtedTimestamp属性

  3 把lease对象加到map中

  4 Lease.serviceUp(){serviceUpTimestamp= System.currentTimeMillis();}

   lastUpdatedTimestamp=System.currentTimeMillis()

  5 PeerAwareInstanceRegistryImpl.replicateToPeers--将客户端的信息复制到集群中 

  6 return Response.status(204).build();//返回204状态码

8 PeerAwareInstanceRegistryImpl.register()

replicateToPeers(Action.Register, info.getAppName(), info.getId(), info, null, isReplication);

## renew

### 服务端接受续约请求

1 ServletContainer.service()

2  WebCompoment.handleRequest()

3 InstanceResource.renewLease()

4 InstanceRegistry.renew()

5 PeerAwareInstanceRegistryImpl.renew()

6 AbstractInstanceRegistry.renew()

//  重点在这里

~~~java
// 根据applicaitonName获取已经注册的信息 
Map<String, Lease<InstanceInfo>> gMap = registry.get(appName);
// 不为空则根据ip(域名)+appName+端口=id获取InstanceInfo的信息
if (gMap != null) {
            leaseToRenew = gMap.get(id);
}
// 生成一个UP状态对象
InstanceStatus overriddenInstanceStatus = this.getOverriddenInstanceStatus(
                        instanceInfo, leaseToRenew, isReplication);
//  如果不是UP状态则更新服务的状态为UP
if (!instanceInfo.getStatus().equals(overriddenInstanceStatus)) {
                    logger.info(
                            "The instance status {} is different from overridden instance status {} for instance {}. "
                                    + "Hence setting the status to overridden status", instanceInfo.getStatus().name(),
                                    instanceInfo.getOverriddenStatus().name(),
                                    instanceInfo.getId());
                    instanceInfo.setStatusWithoutDirty(overriddenInstanceStatus);

                }
lastUpdateTimestamp=System.currentTimeMillis() + duration;
~~~



7 PeerAwareInstanceRegistryImpl.renew()

~~~java
public boolean renew(final String appName, final String id, final boolean isReplication) {
    if (super.renew(appName, id, isReplication)) {
        // 转发到其他eurekaServer
            replicateToPeers(Action.Heartbeat, appName, id, null, null, isReplication);
            return true;
        }
        return false;
}
~~~



## getContainerDifferential

ApplicationsResource.getContainerDifferential()--从缓存中获取所有服务实例并返回

~~~java
@Path("delta")
    @GET
    public Response getContainerDifferential(
            @PathParam("version") String version,
            @HeaderParam(HEADER_ACCEPT) String acceptHeader,
            @HeaderParam(HEADER_ACCEPT_ENCODING) String acceptEncoding,
            @HeaderParam(EurekaAccept.HTTP_X_EUREKA_ACCEPT) String eurekaAccept,
            @Context UriInfo uriInfo, @Nullable @QueryParam("regions") String regionsStr) {

        boolean isRemoteRegionRequested = null != regionsStr && !regionsStr.isEmpty();

        // If the delta flag is disabled in discovery or if the lease expiration
        // has been disabled, redirect clients to get all instances
        if ((serverConfig.shouldDisableDelta()) || (!registry.shouldAllowAccess(isRemoteRegionRequested))) {
            return Response.status(Status.FORBIDDEN).build();
        }

        String[] regions = null;
        if (!isRemoteRegionRequested) {
            EurekaMonitors.GET_ALL_DELTA.increment();
        } else {
            regions = regionsStr.toLowerCase().split(",");
            Arrays.sort(regions); // So we don't have different caches for same regions queried in different order.
            EurekaMonitors.GET_ALL_DELTA_WITH_REMOTE_REGIONS.increment();
        }

        CurrentRequestVersion.set(Version.toEnum(version));
        KeyType keyType = Key.KeyType.JSON;
        String returnMediaType = MediaType.APPLICATION_JSON;
        if (acceptHeader == null || !acceptHeader.contains(HEADER_JSON_VALUE)) {
            keyType = Key.KeyType.XML;
            returnMediaType = MediaType.APPLICATION_XML;
        }

        Key cacheKey = new Key(Key.EntityType.Application,
                ResponseCacheImpl.ALL_APPS_DELTA,
                keyType, CurrentRequestVersion.get(), EurekaAccept.fromString(eurekaAccept), regions
        );

        if (acceptEncoding != null
                && acceptEncoding.contains(HEADER_GZIP_VALUE)) {
			// 在缓存中获取服务实例
            return Response.ok(responseCache.getGZIP(cacheKey))
                    .header(HEADER_CONTENT_ENCODING, HEADER_GZIP_VALUE)
                    .header(HEADER_CONTENT_TYPE, returnMediaType)
                    .build();
        } else {
            return Response.ok(responseCache.get(cacheKey))
                    .build();
        }
    }
~~~

### 服务实例缓存的初始化和定时刷新

https://blog.csdn.net/qq_36960211/article/details/85226088

```java
 @Inject
    ApplicationsResource(EurekaServerContext eurekaServer) {
        this.serverConfig = eurekaServer.getServerConfig();
        this.registry = eurekaServer.getRegistry();
        this.responseCache = registry.getResponseCache();
    }

    public ApplicationsResource() {
        this(EurekaServerContextHolder.getInstance().getServerContext());
    }
```

AbstractInstanceRegistry

```java
@Override
    public synchronized void initializedResponseCache() {
        if (responseCache == null) {
            responseCache = new ResponseCacheImpl(serverConfig, serverCodecs, this);
        }
    }
```

缓存初始化

~~~java
ResponseCacheImpl(EurekaServerConfig serverConfig, ServerCodecs serverCodecs, AbstractInstanceRegistry registry) {
        this.serverConfig = serverConfig;
        this.serverCodecs = serverCodecs;
        this.shouldUseReadOnlyResponseCache = serverConfig.shouldUseReadOnlyResponseCache();
        this.registry = registry;

        long responseCacheUpdateIntervalMs = serverConfig.getResponseCacheUpdateIntervalMs();
    // 初始化缓存
        this.readWriteCacheMap =
                CacheBuilder.newBuilder().initialCapacity(1000)
                        .expireAfterWrite(serverConfig.getResponseCacheAutoExpirationInSeconds(), TimeUnit.SECONDS)
            //  初始化时删除失效的region
                        .removalListener(new RemovalListener<Key, Value>() {
                            @Override
                            public void onRemoval(RemovalNotification<Key, Value> notification) {
                                Key removedKey = notification.getKey();
                                if (removedKey.hasRegions()) {
                                    Key cloneWithNoRegions = removedKey.cloneWithoutRegions();
                                    regionSpecificKeys.remove(cloneWithNoRegions, removedKey);
                                }
                            }
                        })
            //  缓存初始化
                        .build(new CacheLoader<Key, Value>() {
                            @Override
                            public Value load(Key key) throws Exception {
                                if (key.hasRegions()) {
                                    Key cloneWithNoRegions = key.cloneWithoutRegions();
                                    regionSpecificKeys.put(cloneWithNoRegions, key);
                                }
                                Value value = generatePayload(key);
                                return value;
                            }
                        });

        if (shouldUseReadOnlyResponseCache) {
            //  定时更新缓存
            timer.schedule(getCacheUpdateTask(),
                    new Date(((System.currentTimeMillis() / responseCacheUpdateIntervalMs) * responseCacheUpdateIntervalMs)
                            + responseCacheUpdateIntervalMs),
                    responseCacheUpdateIntervalMs);
        }

        try {
            Monitors.registerObject(this);
        } catch (Throwable e) {
            logger.warn("Cannot register the JMX monitor for the InstanceRegistry", e);
        }
    }
~~~



##  集群复制  

### 服务端集群转发客户端注册信息

#### 1 判断类型

~~~java
switch (action) {
                case Cancel:
                    node.cancel(appName, id);
                    break;
                case Heartbeat:
                    InstanceStatus overriddenStatus = overriddenInstanceStatusMap.get(id);
                    infoFromRegistry = getInstanceByAppAndId(appName, id, false);
                    node.heartbeat(appName, id, infoFromRegistry, overriddenStatus, false);
                    break;
                case Register:
                    node.register(info);
                    break;
                case StatusUpdate:
                    infoFromRegistry = getInstanceByAppAndId(appName, id, false);
                    node.statusUpdate(appName, id, newStatus, infoFromRegistry);
                    break;
                case DeleteStatusOverride:
                    infoFromRegistry = getInstanceByAppAndId(appName, id, false);
                    node.deleteStatusOverride(appName, id, infoFromRegistry);
                    break;
            }
~~~

##### 2 PeerEurekaNode.register()

##### 3 AbstractJerseyEurekaHttpClient.register

4 发送post请求






































