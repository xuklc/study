package com.neo.design.proxy.chain;

/**
 * description: FileLogger <br>
 * date: 2020/5/14 16:16 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class FileLogger extends AbstractLogger{

    public FileLogger(int level){
        this.level = level;
    }

    @Override
    protected void write(String message) {
        System.out.println("File::Logger: " + message);
    }
}
