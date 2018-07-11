//
//  AppDelegate.h
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//
/*
 RunLoop祥解
 一般来说，一个线程只能执行一个任务，执行完就会退出。如果我们需要一种机制，让线程能随时处理时间并不退出,那么Runloop就是这样的一个机制，Runloop是事件接收和分发机制的一个实现。
 Runloop实际上是一个对象，这个对象在循环中用来处理程序运行过程中出现的各种事件(比如说触摸事件,UI刷新事件，定时器事件，selector事件)，从而保持程序的持续运行；而且在没有事件处理的时候，会进入睡眠模式，从而节省CPU资源，提高程序性能
 二 Runloop基本使用
 1.保持程序持续运行
 程序一启动就会开一个主线程，主线程一开起来就会跑一个主线程对应的Runloop，Runloop保持主线程不会被销毁，也就保证了程序的持续运行
 2.处理App中的各类事件
 比如：触摸事件，定时器事件，selector事件
 3.节省CPU资源，提高程序性能
 程序运行起来时，当什么操作都没有做的时候，Runloop就告诉CPU，现在没有事情做，我要去休息，这时CPU就会将其资源释放出来去做其他的事情，当有事情做的时候Runloop就会立马起来去做事情
 http://www.imlifengfeng.com/blog/wp-content/uploads/2017/01/20160506091116579.png
 通过上图可以看出，Runloop在跑圈过程中，当接收到Input sources或者Timer sources时就会交给对应的处理方法处理。没有，Runloop就休息啦
 三.Runloop的开启
 程序入口是main函数，就会跑一个和主线程对应的Runloop，那么Runloop一定在程序的入口mian函数中开启
 进入上面mian函数返回的UIApplicationMain函数
 // 用DefaultMode启动
 void CFRunLoopRun(void) {
int32_t result;
do {
    result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
    CHECK_FOR_FORK();
} while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
}
 Runloop确实是do while通过判断result值实现的。因此，我们可以把Runloop看成一个死循环
 四.Runloop对象
 Runloop对象包括Foundation中的NSRunloop对象和CoreFoundation中的CFRunLoopRef对象
 获得RunLoop对象
 //Foundation
 [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
 [NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象
 
 //Core Foundation
 CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
 CFRunLoopGetMain(); // 获得主线程的RunLoop对象
 五.Runloop和线程
 1.Runloop和线程的关系
 @1 每条线程都有唯一的一个与之对应的RunLoop对象
 @2 主线程的Runloop已经自动创建好了，子线程的Runloop需要主动创建
 @3 Runloop在第一次获取时创建，在线程结束时销毁
 2.主线程相关联的Runloop创建
 //创建字典  创建主线程 根据传入的主线程创建主线程对应的Runloop,保存主线程 将主线程-key和Runloop-value保存到字典中
 3.创建与子线程相关联的Runloop
 它只提供两个自动获取的函数：CFRunLoopGetMain()和CFRunLoopGetCurrent()
 CFRunLoopRef源码
 // 全局的Dictionary，key 是 pthread_t， value 是 CFRunLoopRef
 static CFMutableDictionaryRef loopsDic;
 // 访问 loopsDic 时的锁
 static CFSpinLock_t loopsLock;
 
 // 获取一个 pthread 对应的 RunLoop。
 CFRunLoopRef _CFRunLoopGet(pthread_t thread) {
 OSSpinLockLock(&loopsLock);
 
 if (!loopsDic) {
 // 第一次进入时，初始化全局Dic，并先为主线程创建一个 RunLoop。
 loopsDic = CFDictionaryCreateMutable();
 CFRunLoopRef mainLoop = _CFRunLoopCreate();
 CFDictionarySetValue(loopsDic, pthread_main_thread_np(), mainLoop);
 }
 
 // 直接从 Dictionary 里获取。
 CFRunLoopRef loop = CFDictionaryGetValue(loopsDic, thread));
 
 if (!loop) {
 // 取不到时，创建一个
 loop = _CFRunLoopCreate();
 CFDictionarySetValue(loopsDic, thread, loop);
 // 注册一个回调，当线程销毁时，顺便也销毁其对应的 RunLoop。
 _CFSetTSD(..., thread, loop, __CFFinalizeRunLoop);
 }
 
 OSSpinLockUnLock(&loopsLock);
 return loop;
 }
 
 CFRunLoopRef CFRunLoopGetMain() {
 return _CFRunLoopGet(pthread_main_thread_np());
 }
 
 CFRunLoopRef CFRunLoopGetCurrent() {
 return _CFRunLoopGet(pthread_self());
 }
 可以看出，线程和Runloop之间是一一对应的，其关系是保存在一个全局的Dictionary里。线程刚创建时并没有Runloop，如果不主动获取，那它一直不会有。runloop的创建时发生在第一次获取时，runloop的销毁是发生在线程结束时
 [NSRunloop currentrunloop]:方法调用时，会先看一下字典里有没有存子线程相对应用的Runloop，如果有直接返回Runloop,如果没有则会创建一个，并将与之相对应的子线程存入字典中
 六 RunLoop相关类
 CFRunLoopRef//获得当前Runloop和主Runloop
 CFRunLoopModeRef//运行模式，只能选择一种，在不同模式中做不同的操作
 CFRunLoopSourceRef//事件源，输入源
 CFRunLoopTimerRef//定时器时间
 CFRunLoopObserverRef//观察者
 @1 CFRunloopModeRef
 一个Runloop包含若干个Mode,每个Mode又包含若干个Sources/Timer/Observer.每次调用Runloop主函数，只能指定其中一个Mode,这个Mode被称作CurrentMode,如果要切换Mode,只能退出loop，再指定一个Mode进入，这样做主要是为了分隔开不同组的Sources/Timer/Observer，让其互不影响
 系统默认注册了5个Mode,最常见的是kCFRunLoopDefaultMode,(在主线程运行)  UITrackingRunLoopMode(界面跟踪Mode)
 上面的sources/timer/observer被称为mode item,一个item可以被同时加入多个mode，但是一个item被重复加入同一个mode时是不会有效果的。如果一个mode中一个item没有，runloop会直接退出，不进入循环
 Mode间的切换:
 我们平时开发中，一定会遇到，当我们使用NSTimer每一段时间执行一些事情时滑动UIScrollView，NSTimer就会暂停,当我们停止滑动以后，NSTimer又会恢复重新的情况
 
 @2 CFRunLoopSourceRef
 source分为两种：
 source0:非基于Port的 用于用户主动触发的事件(点击button或点击屏幕)
 source1:基于Port的 通过内核和其他线程相互发送消息
 注意：Source1在处理的时候会分发一些操作给source0去处理
 @3 CFRunLoopObserverRef
 观察者,能够监听Runloop的状态改变
*/

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    //创建监听者
//    /*
//     第一个参数 CFAllocatorRef allocator：分配存储空间 CFAllocatorGetDefault()默认分配
//     第二个参数 CFOptionFlags activities：要监听的状态 kCFRunLoopAllActivities 监听所有状态
//     第三个参数 Boolean repeats：YES:持续监听 NO:不持续
//     第四个参数 CFIndex order：优先级，一般填0即可
//     第五个参数 ：回调 两个参数observer:监听者 activity:监听的事件
//     */
//    /*
//     所有事件
//     typedef CF_OPTIONS(CFOptionFlags, CFRunLoopActivity) {
//     kCFRunLoopEntry = (1UL << 0),   //   即将进入RunLoop
//     kCFRunLoopBeforeTimers = (1UL << 1), // 即将处理Timer
//     kCFRunLoopBeforeSources = (1UL << 2), // 即将处理Source
//     kCFRunLoopBeforeWaiting = (1UL << 5), //即将进入休眠
//     kCFRunLoopAfterWaiting = (1UL << 6),// 刚从休眠中唤醒
//     kCFRunLoopExit = (1UL << 7),// 即将退出RunLoop
//     kCFRunLoopAllActivities = 0x0FFFFFFFU
//     };
//     */
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
//        switch (activity) {
//            case kCFRunLoopEntry:
//                NSLog(@"RunLoop进入");
//                break;
//            case kCFRunLoopBeforeTimers:
//                NSLog(@"RunLoop要处理Timers了");
//                break;
//            case kCFRunLoopBeforeSources:
//                NSLog(@"RunLoop要处理Sources了");
//                break;
//            case kCFRunLoopBeforeWaiting:
//                NSLog(@"RunLoop要休息了");
//                break;
//            case kCFRunLoopAfterWaiting:
//                NSLog(@"RunLoop醒来了");
//                break;
//            case kCFRunLoopExit:
//                NSLog(@"RunLoop退出了");
//                break;
//
//            default:
//                break;
//        }
//    });
//
//    // 给RunLoop添加监听者
//    /*
//     第一个参数 CFRunLoopRef rl：要监听哪个RunLoop,这里监听的是主线程的RunLoop
//     第二个参数 CFRunLoopObserverRef observer 监听者
//     第三个参数 CFStringRef mode 要监听RunLoop在哪种运行模式下的状态
//     */
//    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
//    /*
//     CF的内存管理（Core Foundation）
//     凡是带有Create、Copy、Retain等字眼的函数，创建出来的对象，都需要在最后做一次release
//     GCD本来在iOS6.0之前也是需要我们释放的，6.0之后GCD已经纳入到了ARC中，所以我们不需要管了
//     */
//    CFRelease(observer);
//}
/*
 RunLoop处理逻辑
 1.通知Observer:即将进入Loop----->Observer
 
 2.通知Observer:将要处理Timer----->Observer
 3.通知Observer将要处理source0----->Observer
 4.处理source0----->Source0
 5.处理source1----->基于port--source1，调9
 6.通知observe，线程即将休眠 ----->Observer
 7.休眠，等待唤醒
 8.通知Observer:线程刚被唤醒----->Observer
 9.处理唤醒时收到的消息  调2
 10.通知Observer:即将退出loop
 
 内部代码:
 /// 用DefaultMode启动
 void CFRunLoopRun(void) {
 CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 }
 
 /// 用指定的Mode启动，允许设置RunLoop超时时间
 int CFRunLoopRunInMode(CFStringRef modeName, CFTimeInterval seconds, Boolean stopAfterHandle) {
 return CFRunLoopRunSpecific(CFRunLoopGetCurrent(), modeName, seconds, returnAfterSourceHandled);
 }
 
 /// RunLoop的实现
 int CFRunLoopRunSpecific(runloop, modeName, seconds, stopAfterHandle) {
 
 /// 首先根据modeName找到对应mode
 CFRunLoopModeRef currentMode = __CFRunLoopFindMode(runloop, modeName, false);
 /// 如果mode里没有source/timer/observer, 直接返回。
 if (__CFRunLoopModeIsEmpty(currentMode)) return;
 
 /// 1. 通知 Observers: RunLoop 即将进入 loop。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopEntry);
 
 /// 内部函数，进入loop
 __CFRunLoopRun(runloop, currentMode, seconds, returnAfterSourceHandled) {
 
 Boolean sourceHandledThisLoop = NO;
 int retVal = 0;
 do {
 
 /// 2. 通知 Observers: RunLoop 即将触发 Timer 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeTimers);
 /// 3. 通知 Observers: RunLoop 即将触发 Source0 (非port) 回调。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeSources);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 4. RunLoop 触发 Source0 (非port) 回调。
 sourceHandledThisLoop = __CFRunLoopDoSources0(runloop, currentMode, stopAfterHandle);
 /// 执行被加入的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 /// 5. 如果有 Source1 (基于port) 处于 ready 状态，直接处理这个 Source1 然后跳转去处理消息。
 if (__Source0DidDispatchPortLastTime) {
 Boolean hasMsg = __CFRunLoopServiceMachPort(dispatchPort, &msg)
 if (hasMsg) goto handle_msg;
 }
 
 /// 通知 Observers: RunLoop 的线程即将进入休眠(sleep)。
 if (!sourceHandledThisLoop) {
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopBeforeWaiting);
 }
 
 /// 7. 调用 mach_msg 等待接受 mach_port 的消息。线程将进入休眠, 直到被下面某一个事件唤醒。
 /// • 一个基于 port 的Source 的事件。
 /// • 一个 Timer 到时间了
 /// • RunLoop 自身的超时时间到了
 /// • 被其他什么调用者手动唤醒
 __CFRunLoopServiceMachPort(waitSet, &msg, sizeof(msg_buffer), &livePort) {
 mach_msg(msg, MACH_RCV_MSG, port); // thread wait for receive msg
 }
 
 /// 8. 通知 Observers: RunLoop 的线程刚刚被唤醒了。
 __CFRunLoopDoObservers(runloop, currentMode, kCFRunLoopAfterWaiting);
 
 /// 收到消息，处理消息。
 handle_msg:
 
 /// 9.1 如果一个 Timer 到时间了，触发这个Timer的回调。
 if (msg_is_timer) {
 __CFRunLoopDoTimers(runloop, currentMode, mach_absolute_time())
 }
 
 /// 9.2 如果有dispatch到main_queue的block，执行block。
 else if (msg_is_dispatch) {
 __CFRUNLOOP_IS_SERVICING_THE_MAIN_DISPATCH_QUEUE__(msg);
 }
 
 /// 9.3 如果一个 Source1 (基于port) 发出事件了，处理这个事件
 else {
 CFRunLoopSourceRef source1 = __CFRunLoopModeFindSourceForMachPort(runloop, currentMode, livePort);
 sourceHandledThisLoop = __CFRunLoopDoSource1(runloop, currentMode, source1, msg);
 if (sourceHandledThisLoop) {
 mach_msg(reply, MACH_SEND_MSG, reply);
 }
 }
 
 /// 执行加入到Loop的block
 __CFRunLoopDoBlocks(runloop, currentMode);
 
 
 if (sourceHandledThisLoop && stopAfterHandle) {
 /// 进入loop时参数说处理完事件就返回。
 retVal = kCFRunLoopRunHandledSource;
 } else if (timeout) {
 /// 超出传入参数标记的超时时间了
 retVal = kCFRunLoopRunTimedOut;
 } else if (__CFRunLoopIsStopped(runloop)) {
 /// 被外部调用者强制停止了
 retVal = kCFRunLoopRunStopped;
 } else if (__CFRunLoopModeIsEmpty(runloop, currentMode)) {
 /// source/timer/observer一个都没有了
 retVal = kCFRunLoopRunFinished;
 }
 
 /// 如果没超时，mode里没空，loop也没被停止，那继续loop。
 } while (retVal == 0);
 }
 
 /// 10. 通知 Observers: RunLoop 即将退出。
 __CFRunLoopDoObservers(rl, currentMode, kCFRunLoopExit);
 }
 runloop内部是一个do-while循环，run()线程就会一直停留在这个循环里，直到超时或被手动停止，该函数才返回
 
 八 runloop退出
 1.主线程销毁runloop退出
 2.mode中有一些Timer,Source,Observer,这些保证Mode不为空时保证Runloop没有空转并且是在运行时的，当Mode为空时，runloop立即退出
 3.我们在启动runloop的时候可以设置什么时候停止
 
 九 问题
 1.轮播器什么情况会被页面滚动暂停
 /两个模式下都添加timer是可以的，但是timer添加了两次，但并不是一个timer
 //因此就是说我们使用NSRunloopCommonModes，timer可以在两种模式下运行
 2.延迟执行performSelector:afterDelay:实际上其内部会创建一个Timer并添加到当前线程的Runloop中，如果当前线程没有runloop则这个方法失效
 当调用performSelector:onThread:时，实际上其会创建一个Timer加到对应的线程去，同样对应线程没有runloop该方法也会失效
 3.事件响应：苹果注册了一个Source1(基于mach port)用来接收系统事件,其回调函数_IOHIDEventSystemClientQueueCallback()
 当一个硬件事件（触摸，锁屏，摇晃）发生后，首先由IOKit.framework生成一个IOHIDEvent事件并由SpringBoard接收。SpringBoard只接收按键，触摸，加速，接近传感器等几种的event,随后用mach_port转发给需要的App进程，随后苹果注册的source1就会触发回调，并调用_UIApplicationHandleEventQueue()进行应用内部的分发
 _UIApplicationHandleEventQueue()会把IOHIDEvent处理并包装成UIEvent进行处理或分发，其中包括识别UIGesture/处理屏幕旋转/发给UIWindow等 通常事件比如UIButton点击，touchesBegin/Move/End/Cancel事件都是在这个回调中完成的
 手势识别：
 当上面的_UIApplicationHandleEventQueue()识别了一个手势时，其首先会调用Cancel将touchesBegin/Move/End系列回调打断，随后系统将对应的UIGestureRecognizer标记为待处理
 苹果注册了一个Observer监测Before Waiting(Loop 即将进入休眠)事件，这个Observer的回调函数是_UIGestureRecognizerUpdateObserver(),其内部会获取所有刚标记为待处理的GestureRecognizer,并执行GestureRecognizer的回调
 当有UIGestureRecognizer的变化时，这个回调都会进行相应处理
 
 4.界面刷新
 操作UI时，首先调用UIView/CALayer的setNeedsLayout/setNeedsDisplay方法，并被标记为待处理，并被提交到一个全局的容器去
 苹果注册了一个Observer监听即将进入休眠和即将退出Runloop事件，回调去执行一个很长的函数
 _ZN2CA11Transaction17observer_callbackEP19__CFRunLoopObservermPv()。这个函数里会遍历所有待处理的 UIView/CAlayer 以执行实际的绘制和调整，并更新 UI 界面。所以说界面刷新并不一定是在setNeedsLayout相关的代码执行后立刻进行的
 
 5.项目多次自动释放池的创建与销毁
 App启动后，苹果在主线程runloop里面注册了两个Observer其回调都是_wrapRunLoopWithAutoreleasePoolHandler()
 第一个Observer监视即将进入Loop,其回调内会调用_objc_autoreleasePoolPush()创建自动释放池，优先级最高
 第二个事件 监视准备进入休眠，释放旧池并创建新池，优先级最低
 在主线程执行的代码，通常是写在诸如事件回调、Timer回调内的。这些回调会被 RunLoop 创建好的 AutoreleasePool 环绕着，所以不会出现内存泄漏，一般情况下开发者也不必显示创建 Pool 了。
 6.当我们在子线程中需要执行代理或回调，确保当前线程不被销毁
 开启一个循环，保证线程不退出，这就是Event_loop模型。这种模型最大作用就是管理事件/消息，在有新消息时立刻唤醒处理，没有就休眠，避免资源浪费
 */
/*
 RunLoop祥解
 一般来说，一个线程只能执行一个任务，执行完就会退出。如果我们需要一种机制，让线程能随时处理时间并不退出,那么Runloop就是这样的一个机制，Runloop是事件接收和分发机制的一个实现。
 Runloop实际上是一个对象，这个对象在循环中用来处理程序运行过程中出现的各种事件(比如说触摸事件,UI刷新事件，定时器事件，selector事件)，从而保持程序的持续运行；而且在没有事件处理的时候，会进入睡眠模式，从而节省CPU资源，提高程序性能
 二 Runloop基本使用
 1.保持程序持续运行
 程序一启动就会开一个主线程，主线程一开起来就会跑一个主线程对应的Runloop，Runloop保持主线程不会被销毁，也就保证了程序的持续运行
 2.处理App中的各类事件
 比如：触摸事件，定时器事件，selector事件
 3.节省CPU资源，提高程序性能
 程序运行起来时，当什么操作都没有做的时候，Runloop就告诉CPU，现在没有事情做，我要去休息，这时CPU就会将其资源释放出来去做其他的事情，当有事情做的时候Runloop就会立马起来去做事情
 http://www.imlifengfeng.com/blog/wp-content/uploads/2017/01/20160506091116579.png
 通过上图可以看出，Runloop在跑圈过程中，当接收到Input sources或者Timer sources时就会交给对应的处理方法处理。没有，Runloop就休息啦
 三.Runloop的开启
 程序入口是main函数，就会跑一个和主线程对应的Runloop，那么Runloop一定在程序的入口mian函数中开启
 进入上面mian函数返回的UIApplicationMain函数
 // 用DefaultMode启动
 void CFRunLoopRun(void) {
 int32_t result;
 do {
 result = CFRunLoopRunSpecific(CFRunLoopGetCurrent(), kCFRunLoopDefaultMode, 1.0e10, false);
 CHECK_FOR_FORK();
 } while (kCFRunLoopRunStopped != result && kCFRunLoopRunFinished != result);
 }
 Runloop确实是do while通过判断result值实现的。因此，我们可以把Runloop看成一个死循环
 四.Runloop对象
 Runloop对象包括Foundation中的NSRunloop对象和CoreFoundation中的CFRunLoopRef对象
 获得RunLoop对象
 //Foundation
 [NSRunLoop currentRunLoop]; // 获得当前线程的RunLoop对象
 [NSRunLoop mainRunLoop]; // 获得主线程的RunLoop对象
 
 //Core Foundation
 CFRunLoopGetCurrent(); // 获得当前线程的RunLoop对象
 CFRunLoopGetMain(); // 获得主线程的RunLoop对象
 五.Runloop和线程
 1.Runloop和线程的关系
 */
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

