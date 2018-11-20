package com.nx.springcloud.controllers;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

/**
 * @author xukl
 * @date 2018/11/7
 */
@RestController
@Slf4j
@RequestMapping("/user")
public class LoginController {

    @RequestMapping("/login")
    public Map<String,Object> login(){
        log.debug("user login");
        return null;
    }

}
