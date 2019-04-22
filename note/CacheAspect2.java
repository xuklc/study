



import cn.com.enersun.commons.cache.parser.impl.DefaultKeyGenerator;
import org.apache.commons.lang3.StringUtils;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.lang.reflect.Type;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author xukl
 * @date 2019/4/10
 */

@Aspect
@Service
public class CacheAspect2 {

    private static final Logger log = LoggerFactory.getLogger(CacheAspect.class);
    @Autowired
    private IKeyGenerator keyParser;
    @Autowired
    private CacheAPI cacheAPI;
    private ConcurrentHashMap<String, ICacheResultParser> parserMap = new ConcurrentHashMap();
    private ConcurrentHashMap<String, IKeyGenerator> generatorMap = new ConcurrentHashMap();

    public CacheAspect2() {
    }

    @Pointcut("@annotation(cn.com.commons.cache.annotation.Cache)")
    public void aspect() {
    }

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

    private String getKey(Cache anno, Class<?>[] parameterTypes, Object[] arguments) throws InstantiationException, IllegalAccessException {
        String generatorClsName = anno.generator().getName();
        IKeyGenerator keyGenerator = null;
        if (anno.generator().equals(DefaultKeyGenerator.class)) {
            keyGenerator = this.keyParser;
        } else if (this.generatorMap.contains(generatorClsName)) {
            keyGenerator = (IKeyGenerator)this.generatorMap.get(generatorClsName);
        } else {
            keyGenerator = (IKeyGenerator)anno.generator().newInstance();
            this.generatorMap.put(generatorClsName, keyGenerator);
        }

        String key = keyGenerator.getKey(anno.key(), anno.scope(), parameterTypes, arguments);
        return key;
    }

    private Object getResult(Cache anno, Object result, String value, Type returnType) throws InstantiationException, IllegalAccessException {
        String parserClsName = anno.parser().getName();
        ICacheResultParser parser = null;
        if (this.parserMap.containsKey(parserClsName)) {
            parser = (ICacheResultParser)this.parserMap.get(parserClsName);
        } else {
            parser = (ICacheResultParser)anno.parser().newInstance();
            this.parserMap.put(parserClsName, parser);
        }

        if (parser != null) {
            if (anno.result()[0].equals(Object.class)) {
                result = parser.parse(value, returnType, (Class[])null);
            } else {
                result = parser.parse(value, returnType, anno.result());
            }
        }

        return result;
    }
}
