package com.neo.design.proxy.chain;

/**
 *  责任链模式
 * description: AbstractLogger <br>
 * date: 2020/5/14 16:14 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public abstract  class AbstractLogger {
    public static int INFO = 1;
    public static int DEBUG = 2;
    public static int ERROR = 3;

    protected int level;

    //责任链中的下一个元素
    protected AbstractLogger nextLogger;

    public void setNextLogger(AbstractLogger nextLogger){
        this.nextLogger = nextLogger;
    }

    public void logMessage(int level, String message){
        if(this.level <= level){
            write(message);
        }
        if(nextLogger !=null){
            nextLogger.logMessage(level, message);
        }
    }

    abstract protected void write(String message);
}
