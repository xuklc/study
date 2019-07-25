package com.neo.controller;

import com.neo.feign.FeignInterface;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
    @RequestMapping("/hello")
    public String index(@RequestParam String name) {
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