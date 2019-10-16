package com.neo.feign.init;

/**
 * @author xukl
 * @date 2019/9/17
 */
public class Children extends Parent{
    {
        System.out.println("子类代码块:,"+this.a);
    }
    static{
        System.out.println("子类静态代码块,测试顺序");
    }
    public Children(){
        System.out.println("子类无参构造方法:,"+b);
    }
    int a=4;
    public static int b=6;
    public String c="b";
    public static long d=1;
    public static float f=2.2f;
    public static  short g=3;
    // int转double不需要强转
    public static double e=0.3;
    static{
        System.out.println("子类静态代码块:,"+b);
    }


    public Children(int a){
//        super(a);
        this.a=a;
        this.g=(short) this.a;
        this.a=(int)this.e;
        System.out.println("子类有参构造方法:,"+b);
    }

    public int getTestA(){
        return a;
    }
}
