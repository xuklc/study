package com.neo.design.proxy.chain;

/**
 * description: ConsoleLogger <br>
 * date: 2020/5/14 16:15 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class ConsoleLogger extends AbstractLogger{

    public ConsoleLogger(int level){
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("Standard Console::Logger: " + message);
    }

}
