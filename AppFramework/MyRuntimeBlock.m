//
//  MyRuntimeBlock.m
//  AppFramework
//
//  Created by zrq on 2018/7/6.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "MyRuntimeBlock.h"
/*
一 Block与外界变量
 @1 截获自动变量(局部变量)值
 对于block外的变量引用，block默认是将其复制到其数据结构来实现访问的，也就是说block的自动变量截获只针对于block内部使用的自动变量，不使用则不截获，因为截获的自动变量存储于block的结构体内部，会导致block体积变大。block只能访问不能修改局部变量的值
 @2 __block修饰的外部变量
 对于用__block修饰的外部变量引用，block是复制其引用地址来实现访问的,block可以修改__block修饰的外部变量的值
 
 二 Block的copy操作
 block有三种类型 全局块 栈块 椎块    栈----椎---.data区数据区域-----.text程序区域
 全局块存在于全局内存中，相当于单例
 栈块存在于栈内存中，超出作用域则马上就被销毁
 椎块内存在椎内存中，是一个带有引用计数的对象，需要自行管理其内存
 
 判断block的存储位置
 @1 block不访问外界变量 既不在栈又不在椎，此时为全局块
 @2 block访问外界变量
 MRC:存储在栈中
 ARC:存储咋椎中（实际上放在栈区，然后ARC情况下自动拷贝到椎区）,自动释放
 为了解决栈块在其变量作用域结束之后被废弃的问题，我们需要把block复制到椎中，延长其生命周期，开启ARC，大多数情况下编译器恰当的进行判断是否需要将block从栈复制到椎，如果有，自动生成将block从栈上拷贝考椎上的代码，block的复制操作执行的是copy实例方法，block只要调用了copy方法，栈块就会变成椎块
 将block从栈上复制到椎上相当消耗CPU,所以当block设置在栈上也能够使用，就不用复制了，复制会浪费CPU资源。
 
 @3 __block变量与__forwarding
 在copy操作之后,既然__block变量也被copy到椎上去了，去哪访问看__forwarding
 通过__forwarding,无论是在block中还是在block外访问__block变量，也不管该变量是在栈上或椎上，都能顺利访问同一个__block变量
 三 防止block循环引用
 解决方法 ARC 使用__weak MRC使用__block
 typedef void (^Block)()
 @interface TestObj : NSObject
 {
 Block _attributBlock;
 }
 @end
 
 @implementation TestObj
 - (id)init {
 self = [super init];
 __block id tmp = self;
 self.attributBlock = ^{
 NSLog(@"Self = %@",tmp);
 tmp = nil;
 };
 }
 
 - (void)execBlock {
 self.attributBlock();
 }
 @end
 
 // 使用类
 id obj = [[TestObj alloc] init];
 [obj execBlock]; // 如果不调用此方法，tmp 永远不会置 nil，内存泄露会一直在
 
 四.Block的copy操作
 @1 Block的存储域及copy操作
 栈----椎-----.data区（数据区域）.text区(程序区域)
 */
typedef void(^MyBlock)(void);
typedef int(^blk_t)(int);
@implementation MyRuntimeBlock
//blk_t func(int rate){
//    return ^(int count){
//        return rate *count;
//    }
//}
- (instancetype)init{
    if (self = [super init]) {
        
//      __block  int age = 10;
//        MyBlock block = ^{
//            NSLog(@"age = %d",age);
//        };
//        age = 18;
//        block();
    }
    return self;
}
@end
