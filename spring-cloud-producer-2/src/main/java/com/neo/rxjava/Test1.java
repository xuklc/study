package com.neo.rxjava;

import rx.Observable;
import rx.Observer;
import rx.Subscriber;
import rx.schedulers.Schedulers;

import java.util.ArrayList;
import java.util.List;

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
        // Observable是被观察者，Observer是观察者
        Observable<Object> observable = Observable.create(new Observable.OnSubscribe<Object>() {
            @Override
            public void call(Subscriber<? super Object> subscriber) {
                String str=null;
                System.out.println("call");
                subscriber.onNext("a");
                subscriber.onCompleted();
                System.out.println(str.length());
            }
        }).observeOn(Schedulers.newThread());
        // Observable订阅
        observable.subscribe(observer);

    }

    public void testBiz2(){
        Observable.create(new Observable.OnSubscribe<Integer>() {

            @Override
            public void call(Subscriber<? super Integer> subscriber) {
                for (int i = 0; i < 5; i++) {
                    subscriber.onNext(i);
                }
                subscriber.onCompleted();
            }

        }).observeOn(Schedulers.newThread()).subscribe(new Observer<Integer>() {

            @Override
            public void onCompleted() {
                System.out.println("onCompleted");
            }

            @Override
            public void onError(Throwable e) {
                System.out.println("onError");
            }

            @Override
            public void onNext(Integer item) {
                System.out.println("Item is " + item);
            }
        });
    }
}
