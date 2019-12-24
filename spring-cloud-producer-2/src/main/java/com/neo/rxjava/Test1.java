package com.neo.rxjava;

import rx.Observable;
import rx.Observer;
import rx.Subscriber;

/**
 * description: Test1 <br>
 * date: 2019/12/24 20:06 <br>
 * author: ex_xukl2 <br>
 * version: 1.0 <br>
 */

public class Test1 {

    public static void main(String[] args) {
        new Test1().testRx();
    }

    public void testRx (){

        Observer<Object> observer = new Observer<Object>() {

            @Override
            public void onCompleted() {
                System.out.println("onCompleted");
            }

            @Override
            public void onError(Throwable e) {
                System.out.println("onError");
            }

            @Override
            public void onNext(Object s) {
                System.out.println("onNext");
            }
        };

        Observable<Object> observable = Observable.create(new Observable.OnSubscribe<Object>() {
            @Override
            public void call(Subscriber<? super Object> subscriber) {
                String str=null;
                System.out.println("call");
                System.out.println(str.length());
            }
        });

        observable.subscribe(observer);
    }
}
