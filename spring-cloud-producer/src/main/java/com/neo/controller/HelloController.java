package com.neo.controller;

import com.neo.feign.FeignInterface;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

/**
 * 1 newFixedThreadPool LinkedBlockingQueue
 * 2 newCacheThreadPool  SynchronousQueue 0 Inetger.MaxValue
 * 3 newSingleThreadPool LinkedBlockingQueue  1 1 Integer.MaxValue
 * 4 双端队列是LinkedList
 */
@RestController
@Slf4j
public class HelloController {

    @Autowired
    FeignInterface feignInterface;
    @GetMapping("/hello")
    public String index(@RequestParam String name) {
//        ThreadPoolExecutor executor = new ThreadPoolExecutor(1,2,0, TimeUnit.MILLISECONDS,new LinkedBlockingQueue<>(1));
//        executor.execute(()->{
//            System.out.println(name);
//        });
        return "hello " + name + "，this is first messge";
    }

    @GetMapping("/consumer")
    public String consumer() {
        log.info("consumer1");
        String s = feignInterface.firstFeign("feign1", "feign2");
        log.info("result:"+s);
        return "consumer1";
    }
}
