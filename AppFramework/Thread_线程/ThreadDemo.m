//
//  ThreadDemo.m
//  AppFramework
//
//  Created by zrq on 2018/7/16.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "ThreadDemo.h"
#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
@implementation ThreadDemo
- (instancetype)init{
    if (self = [super init]) {
        [self method8];
        recursiveLockTest(5);
    }
    return self;
}
/*
 8.GCD栅栏函数 dispatch_barrier_async
 作用:实现高效率的数据库访问和文件访问
 避免数据竞争
 */
- (void)method8{
    //同dispatch_queue_create函数生成的concurrent Dispatch Queue队列一起使用
    dispatch_queue_t queue = dispatch_queue_create("12312312", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"----1");
    });
    dispatch_async(queue, ^{
        NSLog(@"----2");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"----barrier");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"----3");
    });
    dispatch_async(queue, ^{
        NSLog(@"----4");
    });
}
/*
 7.GCD中信号量: dispatch_semaphore
 信号量：就是一种用来控制访问资源的数量的标识。设定了一个信号量，在线程访问之前，加上信号量的处理，则可告知系统按照我们指定的信号量
 来执行多个线程。
 */
- (void)method7{
    //create的value表示，最多几个资源可以访问
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //任务1
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 1");
        sleep(1);
        NSLog(@"complete task 1");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务2
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 2");
        sleep(1);
        NSLog(@"complete task 2");
        dispatch_semaphore_signal(semaphore);
    });
    
    //任务3
    dispatch_async(quene, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task 3");
        sleep(1);
        NSLog(@"complete task 3");
        dispatch_semaphore_signal(semaphore);
    });
}
/*
 6.分布锁：NSDistributedLock
 NSDistributedLock的实现是通过文件系统的，所以使用它才可以有效的实现不同进程之间的互斥
 */
- (void)method6{
//    NSDistributedLock *lock;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//      lock = [[NSDistributedLock alloc] initWithPath:@"/Users/lifengfeng/Desktop/locktest.txt"];
//        [lock breakLock];
//        [lock tryLock];
//        sleep(10);
//        [lock unlock];
//        NSLog(@"appA: OK");
}
/*
 5.条件锁 NSConditionLock
 */
- (void)method5{
    NSConditionLock *theLock = [[NSConditionLock alloc] init];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i <= 2; i++) {
            [theLock lock];
            NSLog(@"thread1:%d",i);
            sleep(2);
            [theLock unlockWithCondition:i];
        }
    });
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [theLock lockWhenCondition:2];
        NSLog(@"thread2");
        [theLock unlock];
    });
    
}
/*
 4.递归锁
 NSRecursiveLock 多次调用不会阻塞已获取该锁的线程
 */
void recursiveLockTest(int value){
    NSRecursiveLock *rcsLock = [[NSRecursiveLock alloc] init];
    [rcsLock lock];
    if (value != 0) {
        --value;
        recursiveLockTest(value);
    }
    [rcsLock unlock];
}
//recursiveLockTest(5);
/*
 3.NSLock
 NSLock对象实现了NSLocking protocol
 方法lock unlock tryLock lockBeforeDate
 */
- (void)method3{
    NSLock *theLock = [[NSLock alloc] init];
    [theLock lock];//锁
    if (YES) {
        // do something here
        [theLock unlock];
    }
}
/*
 2.atomic 原子属性，为setter方法加锁
 */
- (void)setAge:(int)age{
    @synchronized(self){
        _age = age;
    }
}
/*
 1.互斥锁
 @synchronized(id anObject)
 */
- (void)myMethod:(id)anObj{
    @synchronized(anObj){
        //do something here
    }
}

@end
