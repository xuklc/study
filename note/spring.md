

## spring

### spring aop

动态代理的部分源码,报错就可以知道aop的源码了

 CglibAopProxy.intercept()

```java
public Object intercept(Object proxy, Method method, Object[] args, MethodProxy methodProxy) throws Throwable {
    Object oldProxy = null;
    boolean setProxyContext = false;
    Object target = null;
    TargetSource targetSource = this.advised.getTargetSource();

    Object var16;
    try {
        if (this.advised.exposeProxy) {
            oldProxy = AopContext.setCurrentProxy(proxy);
            setProxyContext = true;
        }

        target = targetSource.getTarget();
        Class<?> targetClass = target != null ? target.getClass() : null;
        List<Object> chain = this.advised.getInterceptorsAndDynamicInterceptionAdvice(method, targetClass);
        Object retVal;
        if (chain.isEmpty() && Modifier.isPublic(method.getModifiers())) {
            Object[] argsToUse = AopProxyUtils.adaptArgumentsIfNecessary(method, args);
            retVal = methodProxy.invoke(target, argsToUse);
        } else {
            retVal = (new CglibAopProxy.CglibMethodInvocation(proxy, target, method, args, targetClass, chain, methodProxy)).proceed();
        }

        retVal = CglibAopProxy.processReturnType(proxy, target, method, retVal);
        var16 = retVal;
    } finally {
        if (target != null && !targetSource.isStatic()) {
            targetSource.releaseTarget(target);
        }

        if (setProxyContext) {
            AopContext.setCurrentProxy(oldProxy);
        }

    }

    return var16;
}
```

#####指定每个 aspect 的执行顺序
方法有两种：

- 实现**org.springframework.core.Ordered**接口，实现它的**getOrder()**方法
- 给aspect添加**@Order**注解，该注解全称为：org.springframework.core.annotation.Order

不管采用上面的哪种方法，都是值越小的 aspect 越先执行。 

![aopeg1](D:\resources\study\note\images\aopeg1.png)

![aopeg2](D:\resources\study\note\images\aopeg2.png)

**@Around注解**

### spring mvc

spring mvc 接收json数组和一个json对象

**想查看json如何解析，传入的json和目标对象数据类型不一样就可以报错了，然后就可以知道json如何解析的**

```json

```

```json

```



**注意:leaders参数是字符串,并且要@RequestParam标记才能入参**

### HttpServletRequestWrapper

### beetlSql

#### beetlSql参数绑定和返回的结果集暂时不支持基本类型的数组和包装类型的数组



aop

~~~java
// &&@annotation(anno) 表示增加一个参数，参数类型是注解，参数名称是anno,这里的值是和方法的参数名一致
    @Around("aspect()&&@annotation(anno)")
    public Object interceptor(ProceedingJoinPoint invocation, Cache anno) throws Throwable {
        MethodSignature signature = (MethodSignature)invocation.getSignature();
        Method method = signature.getMethod();
        Object result = null;
        Class<?>[] parameterTypes = method.getParameterTypes();
        Object[] arguments = invocation.getArgs();
        String key = "";
        String value = "";

        try {
            key = this.getKey(anno, parameterTypes, arguments);
            value = this.cacheAPI.get(key);
            Type returnType = method.getGenericReturnType();
            result = this.getResult(anno, result, value, returnType);
        } catch (Exception var14) {
            log.error("获取缓存失败：" + key, var14);
        } finally {
            if (result == null) {
                result = invocation.proceed();
                if (StringUtils.isNotBlank(key)) {
                    this.cacheAPI.set(key, result, anno.expire());
                }
            }

        }

        return result;
    }
~~~



### ResourceHttpRequestHandler

该类继承了WebContentGenerator，WebContentGenerator可以对response进行设置header，设置缓存时间等操作，并且提供了对request的method的检查功能

<mvc:resources mapping="/images/**" location="/images/" />



### spring mvc流程

1、  用户发送请求至前端控制器DispatcherServlet。

2、  DispatcherServlet收到请求调用HandlerMapping处理器映射器。

3、  处理器映射器找到具体的处理器(可以根据xml配置、注解进行查找)，生成处理器对象及处理器拦截器(如果有则生成)一并返回给DispatcherServlet。

4、  DispatcherServlet调用HandlerAdapter处理器适配器。

5、  HandlerAdapter经过适配调用具体的处理器(Controller，也叫后端控制器)。

6、  Controller执行完成返回ModelAndView。

7、  HandlerAdapter将controller执行结果ModelAndView返回给DispatcherServlet。

8、  DispatcherServlet将ModelAndView传给ViewReslover视图解析器。

9、  ViewReslover解析后返回具体View。

10、DispatcherServlet根据View进行渲染视图（即将模型数据填充至视图中）。

11、 DispatcherServlet响应用户。