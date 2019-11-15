

### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713



### 服务注册



配置的解析，注解是怎么起作用的

#### 1客户端启动注册

SpringApplication.run()

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

8 DiscoveryClient.getAndStoreFullRegistry()

9 SessionEurekaHttpClient.getApplications()

10 AbstractJerseyEurekaHttpClient.register()

11 resourceBuilder.post()//发送post请求

#### 2 服务端处理注册请求

### 

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

DiscoveryClient的注入初始化

CloudEurekaClient是DiscoveryClient子类

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




































