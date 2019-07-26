package com.neo.test;

import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * @author xukl
 * @date 2018/11/23
 */
public class JedisTest {
//    public static
    public static void main(String[]args) throws InterruptedException {
//        Integer[] metaSpace = new Integer[10*1024*1024];
//        System.out.println("asfd"+metaSpace);
//        Thread.sleep(Integer.MAX_VALUE);
        ConcurrentHashMap<String,String> map = new ConcurrentHashMap<>();
        map.put("1","1");
        map.put("2","2");
        ThreadPoolExecutor executor = new ThreadPoolExecutor(3, 3, 60, TimeUnit.SECONDS, new LinkedBlockingDeque<>());
        for (int i=0;i<3;i++){
            executor.execute(()->{
            });
        }
        executor.shutdown();
//        Thread.sleep(Integer.MAX_VALUE);
//        byte[]bytes=new byte[10*1024*1024];
    }


}
