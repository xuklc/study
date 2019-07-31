package com.neo.test;

import java.util.concurrent.atomic.AtomicInteger;

/**
 * @author xukl
 * @date 2019/7/26
 */
public class CASTest {
    boolean flag=true;
    public static void main(String[]args){
        boolean flags = new CASTest().flag;
        AtomicInteger  cas = new AtomicInteger(5);
        System.out.println(cas.compareAndSet(5,2019)+"current Data:"+cas.get());
        System.out.println(cas.compareAndSet(5,1024)+"current Data:"+cas.get());
    }
}
