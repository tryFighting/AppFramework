//
//  NSArray+Blog.h
//  AppFramework
//
//  Created by zrq on 2018/7/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Blog)
//不会生成添加属性的getter和setter方法  必须我们手动生成
@property(nonatomic,copy)NSString *blog;
@end
