//
//  NSArray+Blog.m
//  AppFramework
//
//  Created by zrq on 2018/7/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "NSArray+Blog.h"
#import <objc/runtime.h>
@implementation NSArray (Blog)
//定义关联的key
static const char *key = "blog";
- (void)setBlog:(NSString *)blog{
    //第一个参数:给哪个对象添加关联 2：关联的key 关联的value 关联的策略
    objc_setAssociatedObject(self, key, blog, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)blog{
    //根据关联的key，获取关联的值
    return objc_getAssociatedObject(self, key);
}
@end
