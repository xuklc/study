### 学习链接

https://blog.csdn.net/qq_35387940/article/details/94597967

https://www.cnblogs.com/xiaoliu66007/p/8993041.html

### 概念

Spring Cloud Sleuth为服务之间调用提供链路追踪，spring cloud sleuth可以结合zipkin，将信息发送到zipkin，利用zipkin的存储来存储信息，利用zipkin ui来展示数据

### 初步使用

1 搭建zipkin Server

~~~xml
<dependencies>
    <dependency>
        <groupId>org.springframework.cloud</groupId>
        <artifactId>spring-cloud-starter-eureka</artifactId>
    </dependency>
    <dependency>
        <groupId>io.zipkin.java</groupId>
        <artifactId>zipkin-server</artifactId>
    </dependency>
    <dependency>
        <groupId>io.zipkin.java</groupId>
        <artifactId>zipkin-autoconfigure-ui</artifactId>
    </dependency>
</dependencies>
~~~



~~~java
@SpringBootApplication
@EnableEurekaClient
@EnableZipkinServer
public class ZipkinApplication {

    public static void main(String[] args) {
        SpringApplication.run(ZipkinApplication.class, args);
    }

}
~~~



2 在需要链路跟踪的模块添加依赖和配置

1 依赖

~~~xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-zipkin</artifactId>
</dependency>
~~~

2  配置文件

~~~yml
spring:
  zipkin:
    base-url: http://localhost:9000
  sleuth:
    sampler:
      percentage: 1.0
~~~

