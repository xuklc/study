package com.neo.design.proxy.chain;

/**
 * description: ErrorLogger <br>
 * date: 2020/5/14 16:15 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class ErrorLogger extends AbstractLogger{
    public ErrorLogger(int level){
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("Error Console::Logger: " + message);
    }
}
