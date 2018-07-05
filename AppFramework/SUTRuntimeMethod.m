//
//  SUTRuntimeMethod.m
//  AppFramework
//
//  Created by zrq on 2018/7/5.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "SUTRuntimeMethod.h"
#import <objc/runtime.h>
/*
 这一步合适我们只想将消息转发到另一个能处理该消息的对象上
 但这一步无法对消息进行处理，如操作消息的参数和返回值
 */
@interface SUTRuntimeMethodHelper:NSObject
- (void)method2;
@end
@implementation SUTRuntimeMethodHelper
- (void)method2{
    NSLog(@"%@,%p",self,_cmd);
}
@end
@interface SUTRuntimeMethod(){
    SUTRuntimeMethodHelper *_helper;
}
@end
@implementation SUTRuntimeMethod
+ (instancetype)object{
    return [[self alloc] init];
}
- (instancetype)init{
    self = [super init];
    if (self != nil) {
        _helper = [[SUTRuntimeMethodHelper alloc] init];
    }
    return self;
}
- (void)test{
    [self performSelector:@selector(method2)];
}
void functionForMethod1(id self,SEL _cmd){
    NSLog(@"%@,%p",self,_cmd);
}
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    NSString *selectorString = NSStringFromSelector(sel);
    if ([selectorString isEqualToString:@"method2"]) {
        class_addMethod(self.class, @selector(method1), (IMP)functionForMethod1, "@:");
    }
    return [super resolveClassMethod:sel];
}
- (void)method1{
    
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([SUTRuntimeMethodHelper instancesRespondToSelector:aSelector]) {
            signature = [SUTRuntimeMethodHelper instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}
- (void)forwardInvocation:(NSInvocation *)anInvocation{
    if ([SUTRuntimeMethodHelper instancesRespondToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:_helper];
    }
}
- (id)forwardingTargetForSelector:(SEL)aSelector{
    NSLog(@"forwardingTargetForSelector");
    NSString *selectorString = NSStringFromSelector(aSelector);
    //将消息转发给_helper来处理
    if ([selectorString isEqualToString:@"method2"]) {
        return _helper;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector   {
    if ( [super respondsToSelector:aSelector] )
        return YES;
    else {
        /* Here, test whether the aSelector message can     *
         * be forwarded to another object and whether that  *
         * object can respond to it. Return YES if it can.  */
    }
    return NO;
}
@end
