package com.neo.lock.synchronizeds;

/**
 * 原因是共用的对象本身也是一个线程<br>
 * 所以notify的时候，如果被唤醒的是Go1的线程<br>
 * 那么Go2和Go3中的g.wait();也会跟着返回<br>
 * 所以相当于Go1,Go2,Go3都被唤醒，然后一起5争夺锁<br>
 * 把共用的对象换成一个普通的对象就没有问题了(见NotifyDemo代码)<br>
 * @author xukl
 * @date 2019/8/7
 */
public class NotifyDemo2 {

    public static void main(String[] args)
    {

        Go4 q=new Go4();
        Go5 qq=new Go5(q);
        Go6 qqq=new Go6(q);
        Come1 w=new Come1(q);

        q.start();
        qq.start();
        qqq.start();
        w.start();

    }
}


//线程1，打印1，等待，唤醒后打印一
class Go4 extends Thread
{
    public void run()
    {

        synchronized (this)
        {
            System.out.println("1");
            try
            {
                wait();
            }
            catch (Exception e)
            {
            }
        }
        System.out.println("一");

    }

}
//线程2，打印2，等待，唤醒后打印二
class Go5 extends Thread
{
    Go4 g;
    Go5(Go4 g)
    {
        this.g=g;

    }
    public void run()
    {

        synchronized (g)
        {
            System.out.println("2");
            try
            {
                g.wait();
            }
            catch (Exception e)
            {
            }
        }
        System.out.println("二");
    }
}
//线程3，打印3，等待，唤醒后打印三
class Go6 extends Thread
{
    Go4 g;
    Go6(Go4 g)
    {
        this.g=g;

    }
    public void run()
    {

        synchronized (g)
        {
            System.out.println("3");
            try
            {
                g.wait();
            }
            catch (Exception e)
            {
            }
        }
        System.out.println("三");
    }
}
//唤醒线程
class Come1 extends Thread {
    Go4 r;

    Come1(Go4 r) {
        this.r = r;
    }

    public void run() {
        try {
            sleep(100);
        } catch (Exception e) {
        }
        synchronized (r) {
            r.notify();
            System.out.println("lock open");
        }
    }

}