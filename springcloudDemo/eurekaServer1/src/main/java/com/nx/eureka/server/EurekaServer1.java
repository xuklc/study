package com.nx.eureka.server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * @author xukl
 * @date 2018/10/31
 */
@SpringBootApplication
@EnableEurekaServer
public class EurekaServer1 {
    public static void main(String[] args) {
        SpringApplication.run(EurekaServer1.class);
    }
}
