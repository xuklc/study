package com.neo.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cloud.netflix.ribbon.eureka.ConditionalOnRibbonAndEurekaEnabled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("feign")
@Slf4j
public class HelloController {

    @GetMapping("/hello")
    public String index(@RequestParam String name) {
        return "hello " + name + "，this is two messge";
    }

    @GetMapping("/feign1")
    public String firstFeign( String feignParam1, String feignParam2 ) throws InterruptedException {
      log.info(feignParam1+";"+feignParam2);
      Thread.sleep(500);
      return "feignParam1:"+feignParam1+";feignParam2:"+feignParam2;
    }
}