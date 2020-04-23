package com.neo.design.proxy.aop;

import org.springframework.stereotype.Service;

/**
 * description: Sutdent <br>
 * date: 2020/4/2 10:42 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */
@Service
public class Sutdent  implements  Person {

    @Override
    public void say() {
        System.out.println("sstudent say");
    }
}
