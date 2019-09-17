package com.neo.feign.init;

/**
 * @author xukl
 * @date 2019/9/17
 */
public class ParentAndChildrenTest {

    public static void main(String[] args) {
        Parent parent = new Children(8);
        System.out.println( parent.a);
        System.out.println( parent.b);
        System.out.println( parent.getTestA());
        Children child= (Children) parent;
        System.out.println( child.a);
        System.out.println( child.getTestA());
    }
}
