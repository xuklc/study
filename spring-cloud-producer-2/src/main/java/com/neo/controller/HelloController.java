package com.neo.controller;

import com.neo.design.proxy.aop.Person;
import com.neo.feign.FeignInterface2;
import com.netflix.discovery.converters.Auto;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cloud.netflix.ribbon.eureka.ConditionalOnRibbonAndEurekaEnabled;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("feign")
@Slf4j
public class HelloController {
    @Autowired
    private FeignInterface2 feignInterface2;
    @Autowired
    private Person person;
    @GetMapping("/hello")
    public String index(@RequestParam String name) {
        person.say();
        return "hello " + name + "，this is two messge";
    }

    @GetMapping("/feign1")
    public String firstFeign( String feignParam1, String feignParam2 ) throws InterruptedException {
      log.info(feignParam1+";"+feignParam2);
        String name1 = feignInterface2.feignHello("name1");
        log.info(name1);
        Thread.sleep(2000);
      return "feignParam1:"+feignParam1+";feignParam2:"+feignParam2;
    }
}
