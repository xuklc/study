

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



### mybatis

####  1调用存储过程

~~~xml
<!--
1、使用select标签定义存储过程
2、statementType=“CALLABLE”：要调用的存储过程
3、in输入，out输出，cursor游标，resultSet结果集，resultMap如何封装结果集
-->
<select id="getPageByProcedure" statementType="CALLABLE" databaseId="oracle">
	{call hello_test(
	  #{start,mode=IN,jdbcType=INTEGER},
	  #{end,mode=IN,jdbcType=INTEGER},
	  #{count,mode=OUT,jdbcType=INTEGER},
	  #{emps,mode=OUT,jdbcType=CURSOR,javaType=ResultSet,resultMap=javaModel}
	)}
</select>

~~~

#### 运行过程梳理

1 MapperMethod.execute()

   根据sql的insert、update、delete和select类型选择执行对应的方法

2 DefaultSqlSession.selectList()

   然后根据nameSpace+id组成的key从mappedStatements容器中获取包含sql信息的MapperStatement

3 CachingExecutor.query()

 3.1 先判断是否开启二级缓存

​    如果开启二级缓存，则构建key(statementId,params和boundSql)

​    从二级缓存获取数据，若返回的数据不为空则直接返回

​    返回数据为空，则进入BaseExecutor.query()

 3.2 没有开启二级缓存则进入BaseExecutor.query()

​     3.2.1根据上一步构建的key从localCache(本地缓存)获取数据，

​    3.2.2若返回的数据不为空则直接返回，

​    3.2.3若为空则从直接从数据库查询数据，并将数据存入本地缓存

​    3.2.4 若开启了二级缓存则将查询结构存入二级缓存中

4 DefaultResultSetHandler.handleResultSets()解析结果

二级缓存

<https://blog.csdn.net/z742182637/article/details/72569014>

一级缓存

<https://blog.csdn.net/luanlouis/article/details/41280959>

**一级缓存失效的情况：**

- SqlSession不同；
- SqlSession相同，但查询条件不同；
- SqlSession相同，但两次查询之间执行了任何一次增删改操作；
- SqlSession相同，但使用clearCache()方法手动清除了一级缓存



​      