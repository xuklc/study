package com.neo.feign.fallback;

import com.neo.feign.FeignInterface;
import com.neo.feign.FeignInterface2;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

/**
 * @author xukl
 * @date 2019/1/2
 */
@Slf4j
@Service
public class FirstFallback implements FeignInterface  {

    @Override
    public String firstFeign(String feignParam1, String feignParam2) {
        log.info(feignParam1+";"+feignParam2);
        return "服务调用失败";
    }

//    @Override
    public String feignHello(String feignParam1) {
        return null;
    }
}
