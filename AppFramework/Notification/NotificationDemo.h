//
//  NotificationDemo.h
//  AppFramework
//
//  Created by zrq on 2018/7/12.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 NSNotification顾名思义就是通知的作用，一个对象通知另外一个对象，可以用传递参数通信等作用，与delegate的一对一不同，通知是多对多的，在一个对象中注册了通知，那么其他任意对象都可以发出通知
 专门负责协助不同对象之间的消息通信
 通知是多对多的，代理是一对一的
 注意：这样发出的通知是同步操作，也就是说只有当发生的通知执行完毕以后才会继续执行接下去的代码
 在多线程操作时，发出通知的对象和接收通知的对象需要处于同一个线程
 - (id)addObserverForName:(NSString *)name object:(id)obj queue:
 (NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
 
 NSNotificationQueue
 上面说到NSNotificationCenter是一个同步操作，也就是只有当响应的通知的代码执行完毕以后，发出通知的对象的代码才会继续往下执行，而NSNotificationQueue则与之相反，其通知是异步发送的
 NSNotificationQueue：通知队列,用来管理多个通知的调用。通知队列常以先进先出顺序维护通。NSNotificationQueue就像一个缓冲池把一个通知放进池子中，使用特定方式通过NSNotificationCenter发送到相应的监听者
 //创建通知队列
 - (instancetype)initWithNotificationCenter:(NSNotificationCenter *)notificationCenter NS_DESIGNATED_INITIALIZER;
 //往队列加入通知方法
 - (void)enqueueNotification:(NSNotification *)notification postingStyle:(NSPostingStyle)postingStyle;
 
 - (void)enqueueNotification:(NSNotification *)notification postingStyle:(NSPostingStyle)postingStyle coalesceMask:(NSNotificationCoalescing)coalesceMask forModes:(nullable NSArray<NSRunLoopMode> *)modes;
 NSPostWhenIdle：空闲发送通知，当运行循环处于等待或空闲状态时，发送通知，对于不重要的通知可以使用。
 NSPostASAP：尽快发送通知，当前运行循环迭代完成时，通知将会被发送，有点类似没有延迟的定时器。
 NSPostNow ：同步发送通知，如果不使用合并通知 和postNotification:一样是同步通知。
 
 NSNotificationNoCoalescing：不合并通知。
 NSNotificationCoalescingOnName：合并相同名称的通知。
 NSNotificationCoalescingOnSender：合并相同通知和同一对象的通知。
 
 //移除队列中的方法
  (void)dequeueNotificationsMatching:(NSNotification *)notification coalesceMask:(NSUInteger)coalesceMask;
 
 八、NSNotificatinonCenter实现原理
 
 NSNotificatinonCenter是使用观察者模式来实现的用于跨层传递消息，用来降低耦合度。
 NSNotificatinonCenter用来管理通知，将观察者注册到NSNotificatinonCenter的通知调度表中，然后发送通知时利用标识符name和object识别出调度表中的观察者，然后调用相应的观察者的方法，即传递消息（在Objective-C中对象调用方法，就是传递消息，消息有name或者selector，可以接受参数，而且可能有返回值），如果是基于block创建的通知就调用NSNotification的block。
 
 */
@interface NotificationDemo : NSObject
@property(nonatomic,copy)NSString *name;
- (void)newsCome:(NSNotification *)note;
@end
