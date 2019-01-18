package com.neo.controller.test;

/**
 * @author xukl
 * @date 2019/1/18
 */
public class ThreadTest {

    public static void main(String[] args) {
        System.out.println("111111111");
        Thread.yield();
        System.out.println("222222222");
    }
}
