package com.neo.feign;

import com.neo.feign.fallback.FirstFallback;
import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * @author xukl
 * @date 2019/1/2
 */
@FeignClient(name ="spring-cloud-producer-2",fallback = FirstFallback.class)
public interface FeignInterface {

    @RequestMapping("feign/feign1")
    public String firstFeign(@RequestParam("feignParam1")String feignParam1,@RequestParam("feignParam2") String feignParam2 );


}
