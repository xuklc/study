package com.neo.lock;

import java.util.concurrent.locks.ReentrantLock;

/**
 * @author xukl
 * @date 2019/8/7
 */
public class ReentrantLockDemo {
    public static void main(String[] args) {
        ReentrantLock lock = new ReentrantLock();
        lock.lock();
        try {
            System.out.println("123456");
        }finally {
            lock.unlock();
        }
    }
}
