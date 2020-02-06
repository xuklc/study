### servlet 

1 Servlet的设计并不只为了HTTP协议，HTTPServlet才关注HTTP协议

2 service方法内部处理是线程安全的，Servlet实例本身是非线程安全的

### 配置

 GatewayProperties--配置解析类

1 spring.cloud.gateway作为前缀

2 id和uri是必须配置的

3 filters和predicates搭配使用

4 order是多个路由排序字段

**HandlerMapping/WebHandler**

**GatewayAutoConfiguration**

**GatewayFilterFactory**

**RoutePredicateFactory**

### 基本流程

1 请求匹配

  1 前置判断，当前请求是否匹配，RoutePredicateFactory

​    1 After Route Predicate Factory

 	2 Before Route Predicate Factory

​	 3 Between Route Predicate Factory

2 过滤处理

  1 HttpHeadsFilter

  2 GlobalFilter

3 路由规则

  1.RouteLocatorBuilder

  2.RouteLocator

4 请求转发