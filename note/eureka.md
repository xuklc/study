### 学习链接

1 https://blog.csdn.net/u012394095/article/details/80693713



### 服务注册

配置的解析，注解是怎么起作用的

1 DefaultLifecycleProcessor

bean.start()

2 EurekaAutoServiceRegistration实现了

3 EurekaRegistration这个类封装了服务端口和注册到eureka Servrer的服务信息

4 EurekaServiceRegistry.maybeInitializeClient

5 EurekaRegistration.getEurekaClient

7 AbstractInstanceRegistry.register()

8 ServletContainer.service() --> AbstractInstanceRegistry.register()

包含gateway,ribbon,histryix



### 心跳维持

client和server

### 问题

先搞定服务注册和心跳维持，然后再看配置的解析

@ConditionalOnClass、@ConditionalOnProperty、@AutoConfigureBefore、@AutoConfigureAfter