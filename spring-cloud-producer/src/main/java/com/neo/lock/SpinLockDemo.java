package com.neo.lock;

import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

/**
 * 自旋锁<br>
 * 自旋是while循环+CAS
 * @author xukl
 * @date 2019/8/1
 */
public class SpinLockDemo {

    AtomicReference<Thread> atomicReference = new AtomicReference();
    public static void main(String[] args) {
        SpinLockDemo demo = new SpinLockDemo();
        new Thread(()->{
            demo.mylock();
            try {
                TimeUnit.SECONDS.sleep(5);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            demo.unMyLock();
        },"AA").start();

        try {
            TimeUnit.SECONDS.sleep(1);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        new Thread(()->{
            demo.mylock();
            try {
                TimeUnit.SECONDS.sleep(1);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            demo.unMyLock();
        },"BB").start();


    }

    public void mylock(){
        //进入该方法的当前线程
        Thread thread = Thread.currentThread();
        System.out.println(thread.getName()+"\t come in myLock()");
        while(!atomicReference.compareAndSet(null,thread)){

        }
    }

    public void unMyLock(){
        Thread thread = Thread.currentThread();
        atomicReference.compareAndSet(thread,null);
        System.out.println(thread.getName()+"\t unMyLock()");
    }
}
