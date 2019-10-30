

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



### ioc

https://www.imooc.com/article/34150

本文，我们来看一下 Spring 是如何解决循环依赖问题的。在本篇文章中，我会首先向大家介绍一下什么是循环依赖。然后，进入源码分析阶段。为了更好的说明 Spring 解决循环依赖的办法，我将会从获取 bean 的方法`getBean(String)`开始，把整个调用过程梳理一遍。梳理完后，再来详细分析源码。通过这几步的讲解，希望让大家能够弄懂什么是循环依赖，以及如何解循环依赖。

循环依赖相关的源码本身不是很复杂，不过这里要先介绍大量的前置知识。不然这些源码看起来很简单，但读起来可能却也不知所云。那下面我们先来了解一下什么是循环依赖。

**2. 背景知识**

### 2.1 什么是循环依赖

所谓的循环依赖是指，A 依赖 B，B 又依赖 A，它们之间形成了循环依赖。或者是 A 依赖 B，B 依赖 C，C 又依赖 A。它们之间的依赖关系如下：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15282870029143.jpg)

这里以两个类直接相互依赖为例，他们的实现代码可能如下：

```java
public class BeanB {
    private BeanA beanA;
    // 省略 getter/setter
}

public class BeanA {
    private BeanB beanB;
}
```

配置信息如下：

```xml
<bean id="beanA" class="xyz.coolblog.BeanA">
    <property name="beanB" ref="beanB"/>
</bean>
<bean id="beanB" class="xyz.coolblog.BeanB">
    <property name="beanA" ref="beanA"/>
</bean>
```

IOC 容器在读到上面的配置时，会按照顺序，先去实例化 beanA。然后发现 beanA 依赖于 beanB，接在又去实例化 beanB。实例化 beanB 时，发现 beanB 又依赖于 beanA。如果容器不处理循环依赖的话，容器会无限执行上面的流程，直到内存溢出，程序崩溃。当然，Spring 是不会让这种情况发生的。在容器再次发现 beanB 依赖于 beanA 时，容器会获取 beanA 对象的一个早期的引用（early reference），并把这个早期引用注入到 beanB 中，让 beanB 先完成实例化。beanB 完成实例化，beanA 就可以获取到 beanB 的引用，beanA 随之完成实例化。这里大家可能不知道“早期引用”是什么意思，这里先别着急，我会在下一章进行说明。

好了，本章先到这里，我们继续往下看。

### 2.2 一些缓存的介绍

在进行源码分析前，我们先来看一组缓存的定义。如下：

```java
/** Cache of singleton objects: bean name --> bean instance */
private final Map<String, Object> singletonObjects = new ConcurrentHashMap<String, Object>(256);

/** Cache of singleton factories: bean name --> ObjectFactory */
private final Map<String, ObjectFactory<?>> singletonFactories = new HashMap<String, ObjectFactory<?>>(16);

/** Cache of early singleton objects: bean name --> bean instance */
private final Map<String, Object> earlySingletonObjects = new HashMap<String, Object>(16);
```

根据缓存变量上面的注释，大家应该能大致了解他们的用途。我这里简单说明一下吧：

| 缓存                  | 用途                                                         |
| :-------------------- | :----------------------------------------------------------- |
| singletonObjects      | 用于存放完全初始化好的 bean，从该缓存中取出的 bean 可以直接使用 |
| earlySingletonObjects | 存放原始的 bean 对象（尚未填充属性），用于解决循环依赖       |
| singletonFactories    | 存放 bean 工厂对象，用于解决循环依赖                         |

上一章提到了”早期引用“，所谓的”早期引用“是指向原始对象的引用。所谓的原始对象是指刚创建好的对象，但还未填充属性。这样讲大家不知道大家听明白了没，不过没听明白也不要紧。简单做个实验就知道了，这里我们先定义一个对象 Room：

```java
/** Room 包含了一些电器 */
public class Room {
    private String television;
    private String airConditioner;
    private String refrigerator;
    private String washer;
    // 省略 getter/setter
}
```

配置如下：

```xml
<bean id="room" class="xyz.coolblog.demo.Room">
    <property name="television" value="Xiaomi"/>
    <property name="airConditioner" value="Gree"/>
    <property name="refrigerator" value="Haier"/>
    <property name="washer" value="Siemens"/>
</bean>
```

我们先看一下完全实例化好后的 bean 长什么样的。如下：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15282982554845.jpg)

从调试信息中可以看得出，Room 的每个成员变量都被赋上值了。然后我们再来看一下“原始的 bean 对象”长的是什么样的，如下：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15282981311733.jpg)

结果比较明显了，所有字段都是 null。这里的 bean 和上面的 bean 指向的是同一个对象`Room@1567`，但现在这个对象所有字段都是 null，我们把这种对象成为原始的对象。形象点说，上面的 bean 对象是一个装修好的房子，可以拎包入住了。而这里的 bean 对象还是个毛坯房，还要装修一下（填充属性）才行。

### 2.3 回顾获取 bean 的过程

本节，我们来了解从 Spring IOC 容器中获取 bean 实例的流程（简化版），这对我们后续的源码分析会有比较大的帮助。先看图：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15284164871636.jpg)

先来简单介绍一下这张图，这张图是一个简化后的流程图。开始流程图中只有一条执行路径，在条件 sharedInstance != null 这里出现了岔路，形成了绿色和红色两条路径。在上图中，读取/添加缓存的方法我用蓝色的框和标注了出来。至于虚线的箭头，和虚线框里的路径，这个下面会说到。

我来按照上面的图，分析一下整个流程的执行顺序。这个流程从 getBean 方法开始，getBean 是个空壳方法，所有逻辑都在 doGetBean 方法中。doGetBean 首先会调用 getSingleton(beanName) 方法获取 sharedInstance，sharedInstance 可能是完全实例化好的 bean，也可能是一个原始的 bean，当然也有可能是 null。如果不为 null，则走绿色的那条路径。再经 getObjectForBeanInstance 这一步处理后，绿色的这条执行路径就结束了。

我们再来看一下红色的那条执行路径，也就是 sharedInstance = null 的情况。在第一次获取某个 bean 的时候，缓存中是没有记录的，所以这个时候要走创建逻辑。上图中的 getSingleton(beanName,
new ObjectFactory<Object>() {...}) 方法会创建一个 bean 实例，上图虚线路径指的是 getSingleton 方法内部调用的两个方法，其逻辑如下：

```java
public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
    // 省略部分代码
    singletonObject = singletonFactory.getObject();
    // ...
    addSingleton(beanName, singletonObject);
}
```

如上所示，getSingleton 会在内部先调用 getObject 方法创建 singletonObject，然后再调用 addSingleton 将 singletonObject 放入缓存中。getObject 在内部代用了 createBean 方法，createBean 方法基本上也属于空壳方法，更多的逻辑是写在 doCreateBean 方法中的。doCreateBean 方法中的逻辑很多，其首先调用了 createBeanInstance 方法创建了一个原始的 bean 对象，随后调用 addSingletonFactory 方法向缓存中添加单例 bean 工厂，从该工厂可以获取原始对象的引用，也就是所谓的“早期引用”。再之后，继续调用 populateBean 方法向原始 bean 对象中填充属性，并解析依赖。getObject 执行完成后，会返回完全实例化好的 bean。紧接着再调用 addSingleton 把完全实例化好的 bean 对象放入缓存中。到这里，红色执行路径差不多也就要结束的。

我这里没有把 getObject、addSingleton 方法和 getSingleton(String, ObjectFactory) 并列画在红色的路径里，目的是想简化一下方法的调用栈（都画进来有点复杂）。我们可以进一步简化上面的调用流程，比如下面：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15284160504039.jpg)

这个流程看起来是不是简单多了，命中缓存走绿色路径，未命中走红色的创建路径。好了，本节先到这。

**3. 源码分析**

好了，经过前面的铺垫，现在我们终于可以深入源码一探究竟了，想必大家已等不及了。那我不卖关子了，下面我们按照方法的调用顺序，依次来看一下循环依赖相关的代码。如下：

```java
protected <T> T doGetBean(
            final String name, final Class<T> requiredType, final Object[] args, boolean typeCheckOnly)
            throws BeansException {

    // ...... 

    // 从缓存中获取 bean 实例
    Object sharedInstance = getSingleton(beanName);

    // ......
}

public Object getSingleton(String beanName) {
    return getSingleton(beanName, true);
}

protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    // 从 singletonObjects 获取实例，singletonObjects 中的实例都是准备好的 bean 实例，可以直接使用
    Object singletonObject = this.singletonObjects.get(beanName);
    // 判断 beanName 对应的 bean 是否正在创建中
    if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
        synchronized (this.singletonObjects) {
            // 从 earlySingletonObjects 中获取提前曝光的 bean
            singletonObject = this.earlySingletonObjects.get(beanName);
            if (singletonObject == null && allowEarlyReference) {
                // 获取相应的 bean 工厂
                ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                if (singletonFactory != null) {
                    // 提前曝光 bean 实例（raw bean），用于解决循环依赖
                    singletonObject = singletonFactory.getObject();

                    // 将 singletonObject 放入缓存中，并将 singletonFactory 从缓存中移除
                    this.earlySingletonObjects.put(beanName, singletonObject);
                    this.singletonFactories.remove(beanName);
                }
            }
        }
    }
    return (singletonObject != NULL_OBJECT ? singletonObject : null);
}
```

上面的源码中，doGetBean 所调用的方法 getSingleton(String) 是一个空壳方法，其主要逻辑在 getSingleton(String, boolean) 中。该方法逻辑比较简单，首先从 singletonObjects 缓存中获取 bean 实例。若未命中，再去 earlySingletonObjects 缓存中获取原始 bean 实例。如果仍未命中，则从 singletonFactory 缓存中获取 ObjectFactory 对象，然后再调用 getObject 方法获取原始 bean 实例的应用，也就是早期引用。获取成功后，将该实例放入 earlySingletonObjects 缓存中，并将 ObjectFactory 对象从 singletonFactories 移除。看完这个方法，我们再来看看 getSingleton(String, ObjectFactory) 方法，这个方法也是在 doGetBean 中被调用的。这次我会把 doGetBean 的代码多贴一点出来，如下：

```java
protected <T> T doGetBean(
        final String name, final Class<T> requiredType, final Object[] args, boolean typeCheckOnly)
        throws BeansException {

    // ...... 
    Object bean;

    // 从缓存中获取 bean 实例
    Object sharedInstance = getSingleton(beanName);

    // 这里先忽略 args == null 这个条件
    if (sharedInstance != null && args == null) {
        // 进行后续的处理
        bean = getObjectForBeanInstance(sharedInstance, name, beanName, null);
    } else {
        // ......

        // mbd.isSingleton() 用于判断 bean 是否是单例模式
        if (mbd.isSingleton()) {
            // 再次获取 bean 实例
            sharedInstance = getSingleton(beanName, new ObjectFactory<Object>() {
                @Override
                public Object getObject() throws BeansException {
                    try {
                        // 创建 bean 实例，createBean 返回的 bean 是完全实例化好的
                        return createBean(beanName, mbd, args);
                    } catch (BeansException ex) {
                        destroySingleton(beanName);
                        throw ex;
                    }
                }
            });
            // 进行后续的处理
            bean = getObjectForBeanInstance(sharedInstance, name, beanName, mbd);
        }

        // ......
    }

    // ......

    // 返回 bean
    return (T) bean;
}
```

这里的代码逻辑和我在 `2.3 回顾获取 bean 的过程` 一节的最后贴的主流程图已经很接近了，对照那张图和代码中的注释，大家应该可以理解 doGetBean 方法了。继续往下看：

```java
public Object getSingleton(String beanName, ObjectFactory<?> singletonFactory) {
    synchronized (this.singletonObjects) {

        // ......

        // 调用 getObject 方法创建 bean 实例
        singletonObject = singletonFactory.getObject();
        newSingleton = true;

        if (newSingleton) {
            // 添加 bean 到 singletonObjects 缓存中，并从其他集合中将 bean 相关记录移除
            addSingleton(beanName, singletonObject);
        }

        // ......

        // 返回 singletonObject
        return (singletonObject != NULL_OBJECT ? singletonObject : null);
    }
}

protected void addSingleton(String beanName, Object singletonObject) {
    synchronized (this.singletonObjects) {
        // 将 <beanName, singletonObject> 映射存入 singletonObjects 中
        this.singletonObjects.put(beanName, (singletonObject != null ? singletonObject : NULL_OBJECT));

        // 从其他缓存中移除 beanName 相关映射
        this.singletonFactories.remove(beanName);
        this.earlySingletonObjects.remove(beanName);
        this.registeredSingletons.add(beanName);
    }
}
```

上面的代码中包含两步操作，第一步操作是调用 getObject 创建 bean 实例，第二步是调用 addSingleton 方法将创建好的 bean 放入缓存中。代码逻辑并不复杂，相信大家都能看懂。那么接下来我们继续往下看，这次分析的是 doCreateBean 中的一些逻辑。如下：

```java
protected Object doCreateBean(final String beanName, final RootBeanDefinition mbd, final Object[] args)
        throws BeanCreationException {

    BeanWrapper instanceWrapper = null;

    // ......

    //  创建 bean 对象，并将 bean 对象包裹在 BeanWrapper 对象中返回
    instanceWrapper = createBeanInstance(beanName, mbd, args);

    // 从 BeanWrapper 对象中获取 bean 对象，这里的 bean 指向的是一个原始的对象
    final Object bean = (instanceWrapper != null ? instanceWrapper.getWrappedInstance() : null);

    /*
     * earlySingletonExposure 用于表示是否”提前暴露“原始对象的引用，用于解决循环依赖。
     * 对于单例 bean，该变量一般为 true。更详细的解释可以参考我之前的文章
     */ 
    boolean earlySingletonExposure = (mbd.isSingleton() && this.allowCircularReferences &&
            isSingletonCurrentlyInCreation(beanName));
    if (earlySingletonExposure) {
        //  添加 bean 工厂对象到 singletonFactories 缓存中
        addSingletonFactory(beanName, new ObjectFactory<Object>() {
            @Override
            public Object getObject() throws BeansException {
                /* 
                 * 获取原始对象的早期引用，在 getEarlyBeanReference 方法中，会执行 AOP 
                 * 相关逻辑。若 bean 未被 AOP 拦截，getEarlyBeanReference 原样返回 
                 * bean，所以大家可以把 
                 *      return getEarlyBeanReference(beanName, mbd, bean) 
                 * 等价于：
                 *      return bean;
                 */
                return getEarlyBeanReference(beanName, mbd, bean);
            }
        });
    }

    Object exposedObject = bean;

    // ......

    //  填充属性，解析依赖
    populateBean(beanName, mbd, instanceWrapper);

    // ......

    // 返回 bean 实例
    return exposedObject;
}

protected void addSingletonFactory(String beanName, ObjectFactory<?> singletonFactory) {
    synchronized (this.singletonObjects) {
        if (!this.singletonObjects.containsKey(beanName)) {
            // 将 singletonFactory 添加到 singletonFactories 缓存中
            this.singletonFactories.put(beanName, singletonFactory);

            // 从其他缓存中移除相关记录，即使没有
            this.earlySingletonObjects.remove(beanName);
            this.registeredSingletons.add(beanName);
        }
    }
}
```

上面的代码简化了不少，不过看起来仍有点复杂。好在，上面代码的主线逻辑比较简单，由三个方法组成。如下：

```
1. 创建原始 bean 实例  createBeanInstance(beanName, mbd, args)
2. 添加原始对象工厂对象到 singletonFactories 缓存中 
         addSingletonFactory(beanName, new ObjectFactory<Object>{...})
3. 填充属性，解析依赖  populateBean(beanName, mbd, instanceWrapper)
```

到这里，本节涉及到的源码就分析完了。可是看完源码后，我们似乎仍然不知道这些源码是如何解决循环依赖问题的。难道本篇文章就到这里了吗？答案是否。下面我来解答这个问题，这里我还是以 BeanA 和 BeanB 两个类相互依赖为例。在上面的方法调用中，有几个关键的地方，下面一一列举出来：

**1. 创建原始 bean 对象**

```java
instanceWrapper = createBeanInstance(beanName, mbd, args);
final Object bean = (instanceWrapper != null ? instanceWrapper.getWrappedInstance() : null);
```

假设 beanA 先被创建，创建后的原始对象为 `BeanA@1234`，上面代码中的 bean 变量指向就是这个对象。

**2. 暴露早期引用**

```java
addSingletonFactory(beanName, new ObjectFactory<Object>() {
    @Override
    public Object getObject() throws BeansException {
        return getEarlyBeanReference(beanName, mbd, bean);
    }
});
```

beanA 指向的原始对象创建好后，就开始把指向原始对象的引用通过 ObjectFactory 暴露出去。getEarlyBeanReference 方法的第三个参数 bean 指向的正是 createBeanInstance 方法创建出原始 bean 对象 BeanA@1234。

**3. 解析依赖**

```java
populateBean(beanName, mbd, instanceWrapper);
```

populateBean 用于向 beanA 这个原始对象中填充属性，当它检测到 beanA 依赖于 beanB 时，会首先去实例化 beanB。beanB 在此方法处也会解析自己的依赖，当它检测到 beanA 这个依赖，于是调用 BeanFactry.getBean("beanA") 这个方法，从容器中获取 beanA。

**4. 获取早期引用**

```java
protected Object getSingleton(String beanName, boolean allowEarlyReference) {
    Object singletonObject = this.singletonObjects.get(beanName);
    if (singletonObject == null && isSingletonCurrentlyInCreation(beanName)) {
        synchronized (this.singletonObjects) {
            //  从缓存中获取早期引用
            singletonObject = this.earlySingletonObjects.get(beanName);
            if (singletonObject == null && allowEarlyReference) {
                ObjectFactory<?> singletonFactory = this.singletonFactories.get(beanName);
                if (singletonFactory != null) {
                    //  从 SingletonFactory 中获取早期引用
                    singletonObject = singletonFactory.getObject();

                    this.earlySingletonObjects.put(beanName, singletonObject);
                    this.singletonFactories.remove(beanName);
                }
            }
        }
    }
    return (singletonObject != NULL_OBJECT ? singletonObject : null);
}
```

接着上面的步骤讲，populateBean 调用 BeanFactry.getBean("beanA") 以获取 beanB 的依赖。getBean("beanA") 会先调用 getSingleton("beanA")，尝试从缓存中获取 beanA。此时由于 beanA 还没完全实例化好，于是 this.singletonObjects.get("beanA") 返回 null。接着 this.earlySingletonObjects.get("beanA") 也返回空，因为 beanA 早期引用还没放入到这个缓存中。最后调用 singletonFactory.getObject() 返回 singletonObject，此时 singletonObject != null。singletonObject 指向 BeanA@1234，也就是 createBeanInstance 创建的原始对象。此时 beanB 获取到了这个原始对象的引用，beanB 就能顺利完成实例化。beanB 完成实例化后，beanA 就能获取到 beanB 所指向的实例，beanA 随之也完成了实例化工作。由于 beanB.beanA 和 beanA 指向的是同一个对象 BeanA@1234，所以 beanB 中的 beanA 此时也处于可用状态了。

以上的过程对应下面的流程图：

![SpringIOC容器源码分析-循环依赖的解决办法_](https://blog-pictures.oss-cn-shanghai.aliyuncs.com/15283756103006.jpg)

**4. 总结**

到这里，本篇文章差不多就快写完了，不知道大家看懂了没。这篇文章在前面做了大量的铺垫，然后再进行源码分析。相比于我之前写的几篇文章，本篇文章所对应的源码难度上比之前简单一些。但说实话也不好写，我本来只想简单介绍一下背景知识，然后直接进行源码分析。但是又怕有的朋友看不懂，所以还是用了大篇幅介绍的背景知识。这样写，可能有的朋友觉得比较啰嗦。但是考虑到大家的水平不一，为了保证让大家能够更好的理解，所以还是尽量写的详细一点。本篇文章总的来说写的还是有点累的，花了一些心思思考怎么安排章节顺序，怎么简化代码和画图。如果大家看完这篇文章，觉得还不错的话，不妨给个赞吧，也算是对我的鼓励吧。

由于个人的技术能力有限，若文章有错误不妥之处，欢迎大家指出来。好了，本篇文章到此结束，谢谢大家的阅读


