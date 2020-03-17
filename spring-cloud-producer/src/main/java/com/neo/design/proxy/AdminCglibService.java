package com.neo.design.proxy;

/**
 * description: AdminCglibService <br>
 * date: 2020/3/17 18:22 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class AdminCglibService {
    public void update() {
        System.out.println("修改管理系统数据");
    }

    public Object find() {
        System.out.println("查看管理系统数据");
        return new Object();
    }
}
