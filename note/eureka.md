### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713



### 服务注册



配置的解析，注解是怎么起作用的

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



8 EurekaServiceRegistry.maybeInitializeClient

9 EurekaRegistration.getEurekaClient()

10 

10 ServletContainer.service() --> AbstractInstanceRegistry.register()

​    ServletContainer继承了HttpServlet

包含gateway,ribbon,histryix



### 心跳维持

client和server

### 问题

先搞定服务注册和心跳维持，然后再看配置的解析

@ConditionalOnClass、@ConditionalOnProperty、@AutoConfigureBefore、@AutoConfigureAfter