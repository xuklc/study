package com.nx.springcloud;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * @author xukl
 * @date 2018/11/7
 */

@SpringBootApplication
@EnableDiscoveryClient
public class LoginBootstrap {

    public static void main(String[] args) {
        SpringApplication.run(LoginBootstrap.class);
    }
}
