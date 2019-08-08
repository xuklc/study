package com.neo.lock;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * 题目:多线程之间按顺序调用，实现A->B->c三个线程启动，要求如下:<br>
 * AA打印5次，BB打印10次，CC打印15次<br>
 * 紧接着<br>
 * AA打印5次，BB打印10次，CC打印15次<br>
 * 循环10次<br>
 * @author xukl
 * @date 2019/8/6
 */
public class ConditionDemo {
    public static void main(String[] args) {
        ConditionThread conditionThread = new ConditionThread();
        new Thread(()->{
            for (int i=0;i<10;i++){
                conditionThread.print5();
            }
        },"A").start();
        new Thread(()->{
            for (int i=0;i<10;i++){
                conditionThread.print10();
            }
        },"B").start();
        new Thread(()->{
            for (int i=0;i<10;i++){
                conditionThread.print15();
            }
        },"C").start();
    }
}

class ConditionThread{

    private int number=1;

    private Lock lock = new ReentrantLock();
    private Condition c1=lock.newCondition();
    private Condition c2=lock.newCondition();
    private Condition c3=lock.newCondition();
    public void print5(){
        lock.lock();
        try {
            while(number!=1){
                c1.await();//阻塞等待
            }
            for (int i=1;i<=5;i++){
                System.out.println(Thread.currentThread().getName()+"\t"+i);
            }
            number=2;
            //  通知c2调用await()方法阻塞的线程开始执行
            c2.signal();
        }catch(Exception e){
            e.printStackTrace();
        }finally{
            lock.unlock();
        }
    }

    public void print10(){
        lock.lock();
        try {
            while(number!=2){
                c2.await();//阻塞等待
            }
            for (int i=1;i<=10;i++){
                System.out.println(Thread.currentThread().getName()+"\t"+i);
            }
            number=3;
            //  通知c3调用await()方法阻塞的线程开始执行
            c3.signal();
        }catch (Exception e){

        }finally {
            lock.unlock();
        }
    }

    public void print15(){
        lock.lock();
        try {
            while(number!=3){
                c3.await();//阻塞等待
            }
            for (int i=1;i<=15;i++){
                System.out.println(Thread.currentThread().getName()+"\t"+i);
            }
            number=1;
            //  通知c1调用await()方法阻塞的线程开始执行
            c1.signal();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            lock.unlock();
        }
    }
}