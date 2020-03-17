package com.neo.design.proxy;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Proxy;

/**
 * description: AdminServiceDynamicProxy <br>
 * date: 2020/3/17 17:01 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class AdminServiceDynamicProxy {

    private Object target;
    private InvocationHandler invocationHandler;
    public AdminServiceDynamicProxy(Object target,InvocationHandler invocationHandler){
        this.target = target;
        this.invocationHandler = invocationHandler;
    }

    public Object getPersonProxy() {
        Object obj = Proxy.newProxyInstance(target.getClass().getClassLoader(), target.getClass().getInterfaces(), invocationHandler);
        return obj;
    }
}
