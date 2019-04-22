## zuul 作用

​		把请求转发到具体的微服务上，zuul将自身注册到eureka上，同时从eureka获取其他微服务的信息，然后访问微服务的url都是



## zuul serviceId和path

mydept.serviceId: microservicecloud-dept
​    mydept.path: /mydept/**

上面的配置是url中可以使用  mydept代替 microservicecloud-dept

例如

配置前可以这样写

http:myzuul.com:9527/microservicecloud-dept//dept/1

配置后这样写

http:myzuul.com:9527/mydept/dept/1

###隐藏真实服务名

ignored-services: microservicecloud-dept

这个配置是忽略这个包含路径的访问，当访问这个路径就返回404

###增加前缀

prefix: /atguigu

这个是URL 增加前缀

例如:

增加前缀前

http:myzuul.com:9527/mydept/dept/1

增加配置后的URL

http:myzuul.com:9527/atguigu/mydept/dept/1















