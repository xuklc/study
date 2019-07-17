### ResourceHttpRequestHandler

该类继承了WebContentGenerator，WebContentGenerator可以对response进行设置header，设置缓存时间等操作，并且提供了对request的method的检查功能

<mvc:resources mapping="/images/**" location="/images/" />

**问题1 两个拦截器和wrapper**

2 重点梳理整个流程，表达出来

### 1spring mvc流程

**HttpServletRequestWrapper**

**处理Xss攻击的办法就是，新建一个Xss处理类，然后继承HttpServeltRequestWrapper类**

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

####1 getHandler

![springMVCGetHandler](D:\resources\study\note\images\springMVCGetHandler.png)

####2 handlerMapping

![Hander8个常用的HandlerMapping](D:\resources\study\note\images\Hander8个常用的HandlerMapping.png)

####3RequestMappingHanlderMapping

##### 1 AbstractHandlerMapping

![handler获取和CORS](D:\resources\study\note\images\handler获取和CORS.png)

##### 2 AbstractHanlderMethodMapping

![AbstractHandlerMethodMapping找路径和目标方法](D:\resources\study\note\images\AbstractHandlerMethodMapping找路径和目标方法.png)

#### 4 ServletInvocableHandlerMethod

```java
public void invokeAndHandle(ServletWebRequest webRequest, ModelAndViewContainer mavContainer,
			Object... providedArgs) throws Exception {
		// 调用实现方法
		Object returnValue = invokeForRequest(webRequest, mavContainer, providedArgs);
		setResponseStatus(webRequest);

		if (returnValue == null) {
			if (isRequestNotModified(webRequest) || getResponseStatus() != null || mavContainer.isRequestHandled()) {
				mavContainer.setRequestHandled(true);
				return;
			}
		}
		else if (StringUtils.hasText(getResponseStatusReason())) {
			mavContainer.setRequestHandled(true);
			return;
		}

		mavContainer.setRequestHandled(false);
		Assert.state(this.returnValueHandlers != null, "No return value handlers");
		try {
			this.returnValueHandlers.handleReturnValue(
					returnValue, getReturnValueType(returnValue), mavContainer, webRequest);
		}
		catch (Exception ex) {
			if (logger.isTraceEnabled()) {
				logger.trace(getReturnValueHandlingErrorMessage("Error handling return value", returnValue), ex);
			}
			throw ex;
		}
	}
```

#### 5 InvocableHandlerMethod

```java
public Object invokeForRequest(NativeWebRequest request, @Nullable ModelAndViewContainer mavContainer,
      Object... providedArgs) throws Exception {

   Object[] args = getMethodArgumentValues(request, mavContainer, providedArgs);
   if (logger.isTraceEnabled()) {
      logger.trace("Invoking '" + ClassUtils.getQualifiedMethodName(getMethod(), getBeanType()) +
            "' with arguments " + Arrays.toString(args));
   }
   Object returnValue = doInvoke(args);
   if (logger.isTraceEnabled()) {
      logger.trace("Method [" + ClassUtils.getQualifiedMethodName(getMethod(), getBeanType()) +
            "] returned [" + returnValue + "]");
   }
   return returnValue;
}
```

#### 6 InvocableHandlerMethod

```java
protected Object doInvoke(Object... args) throws Exception {
   ReflectionUtils.makeAccessible(getBridgedMethod());
   try {
       // 桥接模式调用目标方法
      return getBridgedMethod().invoke(getBean(), args);
   }
   catch (IllegalArgumentException ex) {
      assertTargetBean(getBridgedMethod(), getBean(), args);
      String text = (ex.getMessage() != null ? ex.getMessage() : "Illegal argument");
      throw new IllegalStateException(getInvocationErrorMessage(text, args), ex);
   }
   catch (InvocationTargetException ex) {
      // Unwrap for HandlerExceptionResolvers ...
      Throwable targetException = ex.getTargetException();
      if (targetException instanceof RuntimeException) {
         throw (RuntimeException) targetException;
      }
      else if (targetException instanceof Error) {
         throw (Error) targetException;
      }
      else if (targetException instanceof Exception) {
         throw (Exception) targetException;
      }
      else {
         String text = getInvocationErrorMessage("Failed to invoke handler method", args);
         throw new IllegalStateException(text, targetException);
      }
   }
}
```

#### 7 目标方法





### 2 HandlerInterceptorAdapter

拦截器的实现，继承该类



### 3 RequestMapping注解实现controller的方法

**RequestMappingHandlerMapping**

![RequestMapping注解解析](D:\resources\study\note\images\RequestMapping注解解析.png)



### 4 RequestMappingHandlerMapping

RequestMappingHandlerMapping的父类是**AbstrctHandlerMethodMapping**

**AbstractHandlerMethodMapping**的父类是**AbstractHandlerMapping**



### 5 HandlerInterceptor拦截器

MappedInterceptor是HandlerInterceptor的拦截器

![MappedInterceptor](D:\resources\study\note\images\MappedInterceptor.png)

##### 2拦截器在目标方法前后执行的实现

![Interceptors前后](D:\resources\study\note\images\Interceptors前后.png)



### 6 HandlerAdapter

![HandlerAdapter](D:\resources\study\note\images\HandlerAdapter.png)







###整体的流程自己梳理

**applyPreHandle VS applyPostHandle**

1 DispatcherServlet类doService()

   进行属性设置,例如webApplicationContext属性设置

2 进入doDispatch()

​	1 解析request对象里的路径

​        2 (AbstractHandlerMethodMapping.getHandlerInternal)通过路径来找到调用目标方法的信息，包括全类名、返回类型、参数和方法名称等信息

3 进入getHandlerAdapter方法匹配到HttpRequestHanlderAdapter(适配器模式)

4 执行配置好HanlderInterceptor拦截器的逻辑

5 调用目标方法，返回一个ModelAndView对象

   5.1 AbstractHandlerMethodAdapter.handler()----RequestMappingHandlerAdapter.handler()是protected修饰

   5.2 RequestMappingHandlerAdapter.handlerInternal()

   5.3 ServletInvocableHandlerMethod.invokeAndhandler()

   5.4 InvocableHandlerMethod.invoke()方法调用目标方法

6 执行配置好HanlderInterceptor拦截器的逻辑

7 检查回应请求是否有异常，没有则调用render()进行视图渲染

   7.1 从ModelAndView对象获取view名称，然后通过该view名称解析得到一个view对象，然后渲染视图