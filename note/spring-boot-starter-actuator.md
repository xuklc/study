### spring-boot-starter-actuator 是什么

actuator是监控系统健康情况的工具

#### 怎么用?

##### 1. 添加 POM依赖

```xml
<dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

###### 2. 启动的时候就会有下面这些提示

![](D:\note\note\images\spring-boot-starter-actuator.png)

###  actuator 的端点分为3类

1. **应用配置类**

> /configprops /autoconfig /beans /env /info /mappings

1. **度量指标类**

> /dump /health

1. **操作控制类**

- ### 下面找几个来解释

  - ##### /autoconfig

自动化配置报告,可以看出一些自动化配置为什么没有生效

![img](https://upload-images.jianshu.io/upload_images/9211971-02fd1309ccced1d9.png?imageMogr2/auto-orient/strip|imageView2/2/w/933/format/webp)

image.png

- ##### /beans

可以看到定义的所有的bean

![img](https://upload-images.jianshu.io/upload_images/9211971-6c39a9695df30828.png?imageMogr2/auto-orient/strip|imageView2/2/w/969/format/webp)

image.png

- ##### /configprops

可以看到application.properties里面的信息

![img](https://upload-images.jianshu.io/upload_images/9211971-7b75c7b27e34cea9.png?imageMogr2/auto-orient/strip|imageView2/2/w/930/format/webp)

image.png

- ##### /env

![img](https://upload-images.jianshu.io/upload_images/9211971-852d1f9105a166f7.png?imageMogr2/auto-orient/strip|imageView2/2/w/865/format/webp)

image.png

- ##### /mappings



![img](https://upload-images.jianshu.io/upload_images/9211971-91db57ca42a730a2.png?imageMogr2/auto-orient/strip|imageView2/2/w/901/format/webp)

image.png

- ##### /info

返回application.properties文件中info开头的配置信息,如:

```bash
# /info端点信息配置
info.app.name=spring-boot-hello
info.app.version=v1.0.0
```



![img](https://upload-images.jianshu.io/upload_images/9211971-c5644531cabf5726.png?imageMogr2/auto-orient/strip|imageView2/2/w/848/format/webp)

image.png

------

**下面是度量指标类**

- ##### /metrics





![img](https://upload-images.jianshu.io/upload_images/9211971-7802726678e69cc0.png?imageMogr2/auto-orient/strip|imageView2/2/w/765/format/webp)

image.png


我们也可以自定实现  接口来实现count指标.



![img](https://upload-images.jianshu.io/upload_images/9211971-bbcb505a057208c2.png?imageMogr2/auto-orient/strip|imageView2/2/w/516/format/webp)

image.png


也可以用 [/metrics/{name:.*}] 如: /metrics/mem.free 来获取单个指标信息



![img](https://upload-images.jianshu.io/upload_images/9211971-3478e728717daeae.png?imageMogr2/auto-orient/strip|imageView2/2/w/657/format/webp)

image.png



- ##### /health

可以通过实现 `HealthIndicator` 接口来实现健康检查,返回值的状态信息在`org.springframework.boot.actuate.health.Status`内



![img](https://upload-images.jianshu.io/upload_images/9211971-843372a992e100ea.png?imageMogr2/auto-orient/strip|imageView2/2/w/1071/format/webp)

image.png





![img](https://upload-images.jianshu.io/upload_images/9211971-e253daa117f154bc.png?imageMogr2/auto-orient/strip|imageView2/2/w/387/format/webp)

image.png



- ##### /dump

调用 `java.lang.management.ThreadMXBean`的
`public ThreadInfo[] dumpAllThreads(boolean lockedMonitors, boolean lockedSynchronizers);` 方法来返回活动线程的信息



![img](https://upload-images.jianshu.io/upload_images/9211971-8e9ba27da0ec84c2.png?imageMogr2/auto-orient/strip|imageView2/2/w/457/format/webp)

image.png





![img](https://upload-images.jianshu.io/upload_images/9211971-8e046b9f2e7cd8b8.png?imageMogr2/auto-orient/strip|imageView2/2/w/769/format/webp)

image.png



- ##### 操作控制类

如:/shutdown ,通过在application.properties文件中添加
`endpoints.shutdown.enabled=true`
来开启



![img](https://upload-images.jianshu.io/upload_images/9211971-306dc38223319b4e.png?imageMogr2/auto-orient/strip|imageView2/2/w/647/format/webp)

image.png