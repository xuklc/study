package com.neo.feign;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * ,fallback = FirstFallback.class
 * @author xukl
 * @date 2019/1/2
 */
@FeignClient(name ="spring-cloud-producer-1")
public interface FeignInterface2 {

    @RequestMapping("/hello")
    public String feignHello(@RequestParam("name") String feignParam1);


}
