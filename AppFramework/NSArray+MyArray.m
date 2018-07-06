//
//  NSArray+MyArray.m
//  AppFramework
//
//  Created by zrq on 2018/7/6.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "NSArray+MyArray.h"
#import <objc/runtime.h>
@implementation NSArray (MyArray)
+ (void)load{
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(my_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}
- (id)my_objectAtIndex:(NSUInteger)index{
    if (self.count - 1 < index) {
        @try {
            return [self my_objectAtIndex:index];
        } @catch (NSException *exception) {
            //在崩溃后会打印崩溃信息，方便我们调试
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        } @finally {
            
        }
    }else{
        return [self my_objectAtIndex:index];
    }
}
@end
