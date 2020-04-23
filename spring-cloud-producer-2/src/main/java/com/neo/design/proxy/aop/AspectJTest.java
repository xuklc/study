package com.neo.design.proxy.aop;

import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Service;

/**
 * description: AspectJTest <br>
 * date: 2020/4/2 10:46 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */
@Service
@Aspect
public class AspectJTest {

    @Pointcut("execution (* *.say(..))")
    public void test(){}

    @Before("test()")
    public void beforeTest(){
        System.out.println("before test");
    }

    @After("test()")
    public void afterTest(){
        System.out.println("after test");
    }

//    @Around("test()")
//    public void  aroundTest(){
//        System.out.println("around test");
//    }

}
