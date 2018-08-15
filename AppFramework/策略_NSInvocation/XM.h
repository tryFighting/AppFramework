//
//  XM.h
//  算法
//
//  Created by zrq on 2018/8/9.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 策略模式一般是指
 1.可以实现目标的方案集合;
 2.根据形势发展而制定的行动方针和斗争方法
 3.有斗争艺术，能注意方式方法
 */
@interface XM : NSObject
- (void)doSomething:(NSString *)dayStr params:(NSDictionary *)params;
@end
