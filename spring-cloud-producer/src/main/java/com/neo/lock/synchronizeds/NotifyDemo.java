package com.neo.lock.synchronizeds;

/**
 * @author xukl
 * @date 2019/8/7
 */
public class NotifyDemo {
    public static void main(String[] args) {
        Go g = new Go();
        Go1 q = new Go1(g);
        Go2 qq=new Go2(g);
        Go3 qqq=new Go3(g);
        Come w=new Come(g);

        q.start();
        qq.start();
        qqq.start();
        w.start();
    }
}

class Go{


}
//线程1，打印1，等待，唤醒后打印一
class Go1 extends Thread
{
    private Go g;
    public Go1(Go g){
        this.g=g;
    }
    public void run()
    {

        synchronized (g)
        {
            System.out.println("1");
            try
            {
                g.wait();
            }
            catch (Exception e)
            {
            }
        }
        System.out.println("一");

    }

}
//线程2，打印2，等待，唤醒后打印二
class Go2 extends Thread
{
//    Go1 g;
//    Go2(Go1 g)
//    {
//        this.g=g;
//
//    }

    private Go g;
    public Go2(Go g){
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
class Go3 extends Thread
{
//    Go1 g;
//    Go3(Go1 g)
//    {
//        this.g=g;
//
//    }

    private Go g;
    public Go3(Go g){
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
class Come extends Thread
{
    Go r;

    Come(Go r)
    {
        this.r=r;
    }
    public void run()
    {
        try
        {
            sleep(100);
        }
        catch (Exception e)
        {
        }
        synchronized (r)
        {
            r.notify();
            System.out.println("lock open");
        }
    }
}