

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
[	
	{"regulationsName":"安全生产制度13","fileId":"64659abad173495c96da716723236e3b"},
	{"regulationsName":"安全生产制度14","fileId":"8501529ce1d84f0c918e68d62a7ac573"}
]
```

```json
{
		"isBrowser":1,
		"recordId":2,
		"tableName":"notification",
		"userAccount":"guochuntao_01@csg.cn"
}
```

####map参数

java

```java
public InvokeResult<ObaPlanDTO>  ActivityImpl(@RequestParam Map<String,Object> params){
        log.info(params.get("confirmFlag").toString());
//        List<ObaPlanDTO> obaPlanDTOS = obaPlanBiz.ActivityImpl(ConfirmFlag, viewFlag,leaders);
        return InvokeResult.success();
    }
```

url:

http://localhost:6068/oba/plan/activityImpl?confirmFlag=confirm&viewFlag=week&leaders=["wenlimin_01@csg.cn","hexiqiang_01@csg.cn"]

**注意:leaders参数是字符串,并且要@RequestParam标记才能入参**

### HttpServletRequestWrapper

### beetlSql

#### beetlSql参数绑定和返回的结果集暂时不支持基本类型的数组和包装类型的数组

