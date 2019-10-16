package com.neo.feign.init;

/**
 * @author xukl
 * @date 2019/9/17
 */
public class Parent {
    {
        System.out.println("父类代码块:,"+this.a);
    }
    static{
        System.out.println("父类静态代码块,测试顺序");
    }
    public Parent(){
        System.out.println("父类无参构造方法:,"+b);
    }
     int a=2;
    public static int b=5;
    public String c="c";
    public static long d=0;
    public static float f=1f;
    public static  short g=1;
    // int转double不需要强转
    public static double e=0;
    static{
        System.out.println("父类静态代码块:,"+b);
    }


    public Parent(int a){
        this.a=a;
        this.g=(short) this.a;
        this.a=(int)this.e;
        System.out.println("父类有参构造方法:,"+b);
    }

    public int getTestA(){
        return a;
    }
}
