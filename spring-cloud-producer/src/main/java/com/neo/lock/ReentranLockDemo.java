package com.neo.lock;

import java.util.concurrent.locks.ReentrantLock;

/**
 * 可重入锁:<br>
 * 指的是同一线程外层方法获得锁之后，内层递归方法仍然能获取该锁的代码<br>
 * 在同一个线程在外层方法获取该锁的后，进入内层方法自动获取锁<br>
 * 即线程可以进入任何一个它已经拥有的锁所同步的代码块<br>
 * @author xukl
 * @date 2019/8/1
 */
public class ReentranLockDemo {

    public static void main(String[]args){
        Phone phone = new Phone();
        new Thread(()->{
            try {
                phone.sendSMS();
            } catch (Exception e) {
                e.printStackTrace();
            }
        },"t1").start();
        new Thread(()->{
            try {
                phone.sendSMS();
            } catch (Exception e) {
                e.printStackTrace();
            }
        },"t2").start();

        Thread t3= new Thread(phone);
        Thread t4= new Thread(phone);
        t3.start();
        t4.start();
    }

}
class Phone implements Runnable{
    ReentrantLock lock = new ReentrantLock();
    /**
     * 只有一把锁，两个同步共用一个对象锁
     * @throws Exception
     */
    public synchronized  void sendSMS() throws Exception{
        System.out.println(Thread.currentThread().getId()+"\t send SMS");
        sendEmail();
    }
    public synchronized  void sendEmail() throws Exception{
        System.out.println(Thread.currentThread().getId()+"\t ### send Email");
    }

    @Override
    public void run(){
        get();
    }

    public void get(){
        lock.lock();
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getId()+"\t ### get");
            set();
        }finally{
            lock.unlock();
            lock.unlock();
        }

    }
    public void set(){
        lock.lock();
        try {
            System.out.println(Thread.currentThread().getId()+"\t ### set");
        }finally{
            lock.unlock();
        }

    }

}
