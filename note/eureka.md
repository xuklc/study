### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713



### 服务注册

EurekaRegistry 

配置的解析，注解是怎么起作用的

#### 1客户端启动注册

SpringApplication

1 AnnotationConfigApplicationContext.refresh()

-- 1 ClassPathXmlApplicationContext.finishRefresh()

1.1 AbstractApplicationContext.refresh()

2 DefaultLifecycleProcessor.onRefresh() 

3 DefaultLifecycleProcessor.startBeans()  

4 EurekaAutoServiceRegistration.start()

 EurekaAutoServiceRegistration实现了SmartLifecycle接口,SmartLifecycle接口继承了Lifecycle

5 EurekaRegistration这个类封装了服务端口和注册到eureka Servrer的服务信息

6 EurekaServiceRegistry.register()

7  EurekaServiceRegistry.getEurekaClient()

~~~java
//DiscoveryClient类

@Override
                public void notify(StatusChangeEvent statusChangeEvent) {
                    if (InstanceStatus.DOWN == statusChangeEvent.getStatus() ||
                            InstanceStatus.DOWN == statusChangeEvent.getPreviousStatus()) {
                        // log at warn level if DOWN was involved
                        logger.warn("Saw local status change event {}", statusChangeEvent);
                    } else {
                        logger.info("Saw local status change event {}", statusChangeEvent);
                    }
                    instanceInfoReplicator.onDemandUpdate();
                }
~~~



7.1.1 InstanceInfoReplicator.onDemandUpdate()

7.1 DiscoveryClient.register()-->fetchRegistry()

7.2 AbstractJerseyEurekaHttpClient.register()

8 DiscoveryClient.getAndStoreFullRegistry()

9 SessionEurekaHttpClient.getApplications()

10 AbstractJerseyEurekaHttpClient.register()

11 resourceBuilder.post()//发送post请求

#### 2 服务端处理注册请求

InstanceInfo--封装客户端的各种信息

1 ServletContainer.service()

2 WebApplicationImpl.handleRequest()

...中间各种//各种反射调用和权限校验

ApplicationResource.addInstance()

在addInstance()方法中校验了instanceId,hostname,ipaddress等基本的参数是否为空

3 AbstractInstanceRegistry.register() 

ConcurrentHashMap  registry//存放实例信息

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



#### 服务端集群转发客户端注册信息

##### 1 判断类型

```java
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
```

##### 2 PeerEurekaNode.register()

##### 3 AbstractJerseyEurekaHttpClient.register

发送post请求

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





### 服务发现

https://www.cnblogs.com/x1mercy/p/9276332.html

`com.netflix.discovery.DiscoveryClient.CacheRefreshThread`刷新缓存，通过一个定时任务，定时向服务端获取服务信息，放在本地缓存中

定时任务默认是30s获取一次

```java
public int getRegistryFetchIntervalSeconds() {    
    return configInstance.getIntProperty(
        namespace + REGISTRY_REFRESH_INTERVAL_KEY, 30).get();
}
```

在DiscoveryClient初始化时就初始化一个定时任务，然后把从获取服务器获取的方法refreshRegistry()提交给CacheRefreshThread的run()



### 配置

EurekaClientAutoConfiguration




















