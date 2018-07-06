//
//  UIViewController+Swizzle.m
//  AppFramework
//
//  Created by zrq on 2018/7/6.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "UIViewController+Swizzle.h"
#import <objc/runtime.h>
/*
 系统调用UIViewController的viewDidLoad方法时，实际上执行的是我们实现的swizzleViewDidLoad方法时，实际上执行的是我们实现的SwizzleViewDidLoad方法，而在我们在swizzleViewDidLoad方法内部调用[self swizzleViewDidLoad],执行的是UIViewController的viewDidLoad方法
 */
@implementation UIViewController (Swizzle)
+ (void)load{
    //通过class_getInstanceMethod()函数从当前对象中的method list 获取method的结构体
    Method fromMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method toMethod = class_getInstanceMethod([self class], @selector(swizzleViewDidLoad));
    //检查
    if (!class_addMethod([self class], @selector(swizzleViewDidLoad), method_getImplementation(toMethod), method_getTypeEncoding(toMethod))) {
        method_exchangeImplementations(fromMethod, toMethod);
    }
}
- (void)swizzleViewDidLoad{
    NSString *str = [NSString stringWithFormat:@"%@",self.class];
    if (![str containsString:@"UI"]) {
        NSLog(@"统计打点：%@",self.class);
    }
    [self swizzleViewDidLoad];
}
@end
