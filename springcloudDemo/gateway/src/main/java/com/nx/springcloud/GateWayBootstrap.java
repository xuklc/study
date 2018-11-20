package com.nx.springcloud;


import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.gateway.route.RouteLocator;
import org.springframework.cloud.gateway.route.builder.RouteLocatorBuilder;
import org.springframework.context.annotation.Bean;


@SpringBootApplication
public class GateWayBootstrap {

    public static void main(String... args) throws Exception {
        SpringApplication.run(GateWayBootstrap.class);
    }
    @Bean
    public RouteLocator customRouteLocator(RouteLocatorBuilder builder) {
        return builder.routes()
                // basic proxy
                .route(r -> r.path("/baidu")
                        .uri("http://baidu.com:80/"))
                .build();
    }


}

