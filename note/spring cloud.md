## spring cloud

###  写在前头

学习一个新的东西，首先是要看官网的介绍，认真的看，看不懂也没关系，百度一下，例如spring cloud gateway,gateway有三个概念routes、predicates和filter，可以这样先百度spring cloud gateway,spring cloud gateway routes,spring cloud gateway predicates,spring cloud gateway filter,gateway  predicates,gateway filter

**还有一个重点，例子可以去github和码云搜索别人的例子入门**

### 1spring cloud dependencies

spring cloud 依赖版本管理器，spring cloud 版本管理器需要集成spring-boot-starter-parent父模块之外，还需要在<dependencyManagement>标签显式声明版本管理器



### 2 spring cloud 日志

  spring cloud 依赖包直接使用 spring cloud dependencies 和 <parent> 来管理就不会出现jar 版本冲突问题



```xml
<!-- 管理spring boot的jar 版本,依赖这个父项目，在该父项目定义的jar都不需要写jar包的版本 -->
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.1.RELEASE</version>
</parent>
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>Finchley.SR2</version>
            <type>pom</type>
           <!-- 通过<parent>标签只能继承一个 spring-boot-start-parent，import可以多继承 -->
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
```

### 3  eureka

  eureka server 依赖

```xml
<!-- starter -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
</dependency>

<!-- eureka -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

~~~yaml
eureka:
  instance:
    hostname:  eurekaServer8089.com  #主机域名或主机ip
  client:
    register-with-eureka: false # 表示不向服务注册本身
    fetch-registry: false # 表示eureka本身就是服务端，职责就是维护服务实例，不需要检索服务
~~~

### 4 spring cloud jar冲突

**注意:<dependencyManagement>标签管理的依赖要注意版本，要和parent标签的版本对应，否则版本冲突，导致jar无法下载**

**另外不同spring cloud版本的依赖的<artifactId>不是一成不变的，而是有可能随版本而改变**

下面这个是eureka server2.0.0.1版本依赖，spring boot 2.0版本一下的可能又不一样

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
```

### 5 spring cloud  学习资料

  码云

idea  spring initalizr插件可以生成依赖，找不到依赖可以使用demo来完成



### 6 gateway

​	**注意：Spring Cloud Gateway requires the Netty runtime provided by Spring Boot and Spring Webflux. It does not work in a traditional Servlet Container or built as a WAR.**

**注意: <!--spring cloud gateway 不兼容 spring-boot-starter-web-->**

**说明:gateway和eureka没有什么必然的关系，gateway负责服务过滤和服务转发，本身也是一个服务，可以注册到eureka中，不注册到eureka也不影响gateway**

  #### 1 概念

- **Route**: Route the basic building block of the gateway. It is defined by an ID, a destination URI, a collection of predicates and a collection of filters. A route is matched if aggregate predicate is true.
- **Predicate**: This is a [Java 8 Function Predicate](https://docs.oracle.com/javase/8/docs/api/java/util/function/Predicate.html). The input type is a [Spring Framework `ServerWebExchange`](https://docs.spring.io/spring/docs/5.0.x/javadoc-api/org/springframework/web/server/ServerWebExchange.html). This allows developers to match on anything from the HTTP request, such as headers or parameters.
- **Filter**: These are instances [Spring Framework `GatewayFilter`](https://docs.spring.io/spring/docs/5.0.x/javadoc-api/org/springframework/web/server/GatewayFilter.html) constructed in with a specific factory. Here, requests and responses can be modified before or after sending the downstream request.

####2 工作流程

![gateway](D:\software\resources\note\images\gateway.png)

#### 3 URI定义注意点

**URIs defined in routes without a port will get a default port set to 80 and 443 for HTTP and HTTPS URIs respectively**

#### 4 配置的方式

  1 yml配置文件配置

 2 用java代码配置

#### 5 配置 routes

配置id，uri和端口

#### 6 配置predicates路由规则

predicates：请求匹配规则，为一个数组，每个规则为并且的关系。包含： 

1. name：规则名称，目前有10个，有Path，Query，Method，Header，After，Before，Between，Cookie，Host，RemoteAddr 
2. args：参数key-value键值对,例：

#### 7  配置过滤filter

**内置的过滤器工厂一共有22个，位于 `org.springframework.cloud.gateway.filter.factory`及`org.springframework.cloud.gateway.filter.factory.rewrite`包中**

filters：请求过滤filter，为一个数组，每个filter都会顺序执行。包含： 
1. name：过滤filter名称，**常用的有Hystrix断路由**，**RequestRateLimiter限流**，**StripPrefix截取请求url **
2. args：参数key-value键值对,例：

##### Hystrix

Hystrix是一个断路器，是一个独立的组件，这里只是集成到gateway当中

~~~yml
filters:
- name: Hystrix
  args:
    name: fallbackcmd
    fallbackUri: forward:/incaseoffailureusethis
```

如果args不写key的，会自动生成一个id，如下会生成一个xxx0的key，值为1

```
filters:
- StripPrefix= 1
###spring cloud gateway官方例子
spring:
  cloud:
    gateway:
      routes:
      - id: hystrix_route
        uri: lb://backing-service:8088
        predicates:
        - Path=/consumingserviceendpoint
        filters:
        - name: Hystrix
          args:
            name: fallbackcmd
            fallbackUri: forward:/incaseoffailureusethis
        - RewritePath=/consumingserviceendpoint, /backingserviceendpoint
~~~

##### StripPrefix

```yml
spring:
  cloud:
    gateway:
      routes:
      - id: nameRoot
        uri: http://nameservice
        predicates:
        - Path=/name/**
        filters:
        - StripPrefix=2
```

当 请求网关的路径是http://nameservice/name/bar/foo时，通过网关转发请求的路径将变成http://nameservice/foo

When a request is made through the gateway to `/name/bar/foo` the request made to `nameservice` will look like `http://nameservice/foo`.

**配置的格式要严格遵守官方的例子,严格对照格式**

#####LoadBalancerClient Filter

**LoadBalancerClient Filter的使用比较简单，只需在url前加上lb,以下是这三部分综合使用的一个demo，lb://**

    spring:
      cloud:
        gateway:
          discovery:
            locator:
              enabled: true
          routes:
          - id: Hystrix
            uri: lb://user
            predicates:
            - Path=/test/**
            filters:
            - name: Hystrix
              args:
                name: fallbackcmd
                fallbackUri: forward:/fallback
**总结**

LoadBalancerClientFilter会作用在url以**lb开头**的路由，然后利用loadBalancer来获取服务实例，构造目标requestUrl，设置到**GATEWAY_REQUEST_URL_ATTR**属性中，供NettyRoutingFilter使用

### 7 spring cloud 启动器

```xml
<groupId>org.springframework.boot</groupId>
<artifactId>spring-boot-starter</artifactId>
```

### 8 eureka

服务注册包括属性解析和服务注册

**spring.factories**

```java
DiscoveryClient
```

```java
InstanceResource
```

####1eureka.instance.appname  VS  spring.application.name

```java
@ConfigurationProperties("eureka.instance")
public class EurekaInstanceConfigBean implements CloudEurekaInstanceConfig, EnvironmentAware {
    /**
	 * Default prefix for actuator endpoints
	 */
	private String actuatorPrefix = "/actuator";

	/**
	 * Get the name of the application to be registered with eureka.
	 */
	private String appname = UNKNOWN;

    
    @Override
	public void setEnvironment(Environment environment) {
		this.environment = environment;
		// set some defaults from the environment, but allow the defaults to use relaxed binding
	String springAppName = this.environment.getProperty("spring.application.name", "");
		if(StringUtils.hasText(springAppName)) {
			setAppname(springAppName);
			setVirtualHostName(springAppName);
			setSecureVirtualHostName(springAppName);
		}
	}
```

从以上可以看到，spring.application.name 的优先级比 eureka.instance.appname 高

~~~yml
spring:
  application:
    name: jack
eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka/
  instance:
    appname: client
~~~

两者都配置的时候，注册到Eureka Server上的 appname 是 jack

####2 @EnableEurekaClient VS @EnableDiscoveryClient

当客户端注册Eureka时，它提供关于自身的元数据，例如主机和端口，健康指示符URL，主页等。Eureka从属于服务的每个实例接收心跳消息。如果心跳失败超过可配置的时间表，则通常将该实例从注册表中删除

我们明确地使用`@EnableEurekaClient`，但只有Eureka可用，你也可以使用`@EnableDiscoveryClient`。需要配置才能找到Eureka服务器。

例子:

```yml
eureka:
  client:
    serviceUrl:
      defaultZone: http://localhost:8761/eureka/
```

#### 3 lease-expiration-duration-in-seconds



#### 4 lease-renewal-interval-in-seconds



#### 5 preferIpAddress

#### 6 检查心跳

 lease-renewal-interval-in-seconds 每间隔1s，向服务端发送一次心跳，证明自己依然”存活“

lease-expiration-duration-in-seconds  告诉服务端，如果我2s之内没有给你发心跳，就代表我“死”了，将我踢出掉。

#### 7 删除指定服务

**用postman发送DELTE请求**

**格式为 /eureka/apps/{application.name}/**



**值得注意的是，Eureka客户端每隔一段时间（默认30秒）会发送一次心跳到注册中心续约。如果通过这种方式下线了一个服务，而没有及时停掉的话，该服务很快又会回到服务列表中**

##### 例子1 

下面是下线一个hello-service的例子

![eureka_Delete_appnName](D:\resources\study\note\images\eureka_Delete_appnName.png)

下图是用postman 发送delete请求

![eureka_Delete_url](D:\resources\study\note\images\eureka_Delete_url.png)

####8 属性配置

![eureka](D:\resources\study\note\images\eureka.png)



### 9 profile

除application.properties外，还可以根据**命名约定**（ 命名格式：**application-{profile}.properties**）来配置

如果active赋予的参数没有与使用该命名约定格式文件相匹配的话，app则会**默认**从名为**application-default.properties **的配置文件加载配置。

如：spring.profiles.active=hello-world,sender,dev 有三个参数，其中 **dev** 正好匹配下面配置中的**application-dev.properties **配置文件，所以app启动时，项目会**先从**application-dev.properties加载配置，再从application.properties配置文件加载配置，如果有**重复的配置**，则会**以application.properties的配置为准**。

### 10 feign

**Spring Cloud integrates Ribbon and Eureka to provide a load balanced http client when using Feign**

#### feign使用Hystix和LoadBalancer步骤

#### 1添加依赖

```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```

#### 2 启动类增加注解@EnableFeignClients

```java
@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients
public class ProducerApplication {

    public static void main(String[] args) {
        SpringApplication.run(ProducerApplication.class, args);
    }
}
```

#### 3  定义接口

**FirstFallback要是实现FeignInterface接口，并且多个参数要使用@RequestParam指定参数名称**

```java
@FeignClient(name ="spring-cloud-producer-2",fallback = FirstFallback.class)
public interface FeignInterface {

    @RequestMapping("feign/feign1")
    public String firstFeign(@RequestParam("feignParam1")String feignParam1,@RequestParam("feignParam2") String feignParam2 );


}
```

#### 4 在yml文件中配置

```yaml
#开启hystrix
feign:
  hystrix:
    enabled: true
```

#### 5 超时时间

使用Feign调用接口分两层，ribbon的调用和hystrix的调用，所以ribbon的超时时间和Hystrix的超时时间的结合就是Feign的超时时间

在HystrixCommandProperties类中配置,HystrixCommandProperties的**初始化**是在**feign调用服务的时候进行初始化**

```yaml
hystrix:
  command:
    default:
      execution:
        timeout:
          enabled:  true  ##这个的默认值是true,看下面的源码
        isolation:
           thread:
             timeoutInMilliseconds: 9000  #默认值是1000
```

```java
private static final Boolean default_executionTimeoutEnabled = true; //默认是true
this.executionTimeoutEnabled = getProperty(propertyPrefix, key, "execution.timeout.enabled", builder.getExecutionTimeoutEnabled(), default_executionTimeoutEnabled);
/**
* builder.getExecutionTimeoutEnabled()的是为null,则取default_executionTimeoutEnabled 
*/
```

设置**HystrixCommand.run()**的隔离策略，默认是ExecutionIsolationStrategy.THREAD;

```java
private static final ExecutionIsolationStrategy default_executionIsolationStrategy = ExecutionIsolationStrategy.THREAD;
this.executionIsolationStrategy = getProperty(propertyPrefix, key, "execution.isolation.strategy", builder.getExecutionIsolationStrategy(), default_executionIsolationStrategy);
```

#### 6 @EnableFeignClients

@EnableFeignClients默认只扫描@SpringBootApplication标注的包及子包，但是可以通过basePackages属性指定扫描的包名

#### 7 ribbon



### 11 端口占用的报错

端口占用的报错:

org.springframework.beans.factory.BeanCreationNotAllowedException: Error creating bean with name 'sqlManagerFactoryBean': Singleton bean creation not allowed while singletons of this factory are in destruction (Do not request a bean from a BeanFactory in a destroy method implementation!)

解决办法:

1 查询端口号

netstat -aon|findstr 6068 (端口号)

2  关闭进程

taskkill -PID 17400 -F

![win10端口占用](D:\resources\study\note\images\win10端口占用.png)



### 12 @CrossOrigin

配置cros解决跨域问题

### 13 配置的加载顺序

1 properties文件

2 yaml文件

3 系统环境变量

4 命令行参数



### druid

配置数据源

<https://www.jianshu.com/p/a449e7a7b326>

### 15全局唯一的id

在应用启动时设置一个全局唯一的应用编码，应用编码+UUID

### 16 @Sync

org.springframework.scheduling.annotation.Async



### 17启动器

spring-boot-starter

```xml-dtd
Spring Boot的核心启动器，包含了自动配置、日志和YAML
```

spring-boot-starter-web

web的场景，自动帮我们引入了web模块开发需要的相关jar包



### 18 zookeeper

https://blog.csdn.net/qq_35394707/article/details/80139176



### 19 日志

spring cloud 使用logback日志框架记录日志，spring-boot-starter依赖已经包含spring-boot-starter-logging(即logback框架),在src/main/resource/文件下配置文件名logback-spring.xml日志配置，spring cloud会自动加载，

日志的使用方式有两种

1 安装lombok插件

2 logger

~~~java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class HelloWorld {
  public static void main(String[] args) {
    Logger logger = LoggerFactory.getLogger(HelloWorld.class);
    logger.info("Hello World");
  }
}
~~~

