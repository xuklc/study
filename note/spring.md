

## spring

### spring aop

连接点:是程序执行的一个点

切点:是一个匹配连接点的断言或者表达式



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

##### 指定每个 aspect 的执行顺序
方法有两种：

- 实现**org.springframework.core.Ordered**接口，实现它的**getOrder()**方法
- 给aspect添加**@Order**注解，该注解全称为：org.springframework.core.annotation.Order

不管采用上面的哪种方法，都是值越小的 aspect 越先执行。 

![aopeg1](D:\resources\study\note\images\aopeg1.png)

![aopeg2](D:\resources\study\note\images\aopeg2.png)

**@Around注解**

#### 例子1

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

##### 第二个代码示例

~~~java
import com.rq.aop.common.annotation.MyAnnotation;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.stereotype.Component;

@Aspect //标注增强处理类（切面类）
@Component //交由Spring容器管理
public class AnnotationAspect {

	/*
    可自定义切点位置，针对不同切点，方法上的@Around()可以这样写ex：@Around(value = "methodPointcut() && args(..)")
    @Pointcut(value = "@annotation(com.rq.aop.common.annotation.MyAnnotation)")
    public void methodPointcut(){}

    @Pointcut(value = "@annotation(com.rq.aop.common.annotation.MyAnnotation2)")
    public void methodPointcut2(){}
    */

	//定义增强，pointcut连接点使用@annotation（xxx）进行定义
    @Around(value = "@annotation(around)") //around 与 下面参数名around对应
    public void processAuthority(ProceedingJoinPoint point,MyAnnotation around) throws Throwable{
        System.out.println("ANNOTATION welcome");
        System.out.println("ANNOTATION 调用方法："+ around.methodName());
        System.out.println("ANNOTATION 调用类：" + point.getSignature().getDeclaringTypeName());
        System.out.println("ANNOTATION 调用类名" + point.getSignature().getDeclaringType().getSimpleName());
        point.proceed(); //调用目标方法
        System.out.println("ANNOTATION login success");
    }
}

/**
注解类
*/
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Retention(RetentionPolicy.RUNTIME)//运行时有效
@Target(ElementType.METHOD)//作用于方法
public @interface MyAnnotation {
    String methodName () default "";
}

~~~



#### 例子2

使用表达式

~~~shell
execution(public *.com.xkl..*(..))//最后的两个..表示任意参数
~~~

任意公共方法的执行：execution(public * *(..))
任何一个以“set”开始的方法的执行：execution(* set*(..))
AccountService 接口的任意方法的执行：execution(* com.xyz.service.AccountService.*(..))
定义在service包里的任意方法的执行： execution(* com.xyz.service.*.*(..))
定义在service包和所有子包里的任意类的任意方法的执行：execution(* com.xyz.service..*.*(..))

代码示例

~~~java
@Aspect
@Component
@Order(0)
public class MyAspect {
	

	@Pointcut("execution(public * com.xkl.aop.gateway..*Controller.*(..))")
	public void aopIntercepor() {
		logger.info("{} is runing", this.getClass());
	}

	@Around("aopIntercepor()")
	public Object aroundController(ProceedingJoinPoint joinPoint) {
		try {
				return joinPoint.proceed();
		} catch (Throwable e) {
			LoggerFactory.getLogger(this.getClass()).error(e.getMessage(), e);
			return new ResponseDomain<>();
		}
	}
~~~



#### aop的执行顺序

##### 正常

![](D:\note\note\images\around.png)



##### 异常

![](D:\note\note\images\around exception.png)





### IOC

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



#### 拦截器

拦截器的配置

<https://blog.csdn.net/zongyeqing/article/details/80152616>

执行器的默认类型是

```java
protected ExecutorType defaultExecutorType = ExecutorType.SIMPLE;
```

####mybatis二级缓存开启 

1 全局配置文件

```xml
<``settings``>
    ``<!-- 开启二级缓存（默认是开的，这里写出来是为了方便代码维护） -->
    ``<``setting` `name``=``"cacheEnabled"` `value``=``"true"` `/>
</``settings``>
```

2 mapper.xml

~~~xml
<cache type="org.apache.ibatis.cache.impl.PerpetualCache"/>
~~~

**我们不写type就使用mybatis默认的缓存**

整合spring boot

http://www.hellojava.com/a/72278.html

@Signature(type,method.args)

### ClassPathXmlApplicationContext



### ApplicationContextAware

#### 问题背景

在我们的web程序中，用spring来管理各个实例(bean), 有时在程序中为了使用已被实例化的bean, 通常会用到这样的代码：

```cpp
ApplicationContext appContext = new ClassPathXmlApplicationContext("applicationContext-common.xml");  
AbcService abcService = (AbcService)appContext.getBean("abcService");  
```

但是这样就会存在一个问题：因为它会重新装载`applicationContext-common.xml`并实例化上下文bean，如果有些线程配置类也是在这个配置文件中，那么会造成做相同工作的的线程会被启两次。一次是web容器初始化时启动，另一次是上述代码显示的实例化了一次。当于重新初始化一遍！！！！这样就产生了冗余。

#### 解决方法

不用类似new ClassPathXmlApplicationContext()的方式，从已有的spring上下文取得已实例化的bean。通过ApplicationContextAware接口进行实现。

当一个类实现了这个接口（ApplicationContextAware）之后，这个类就可以方便获得ApplicationContext中的所有bean。换句话说，就是这个类可以直接获取[spring](http://lib.csdn.net/base/javaee)配置文件中，所有有引用到的bean对象

#### 用法

1  实现ApplicationContextAware接口

spring能够为我们自动地执行了ApplicationContextAware.setApplicationContext()

**spring不会无缘无故地为某个类执行它的方法的，所以，就很有必要通过注册方法类AppUtil的方式告知spring有这样子一个类的存在。这里我们使用`@Component`来进行注册，或者我们也可以像下面这样在配置文件声明bean：**

~~~xml
<bean id="appUtil" class="com.htsoft.core.util.AppUtil"/>
~~~

