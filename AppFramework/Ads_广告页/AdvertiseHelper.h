//
//  AdvertiseHelper.h
//  AppFramework
//
//  Created by zrq on 2018/7/30.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdvertiseHelper : NSObject
+ (instancetype)sharedInstance;

+ (void)showAdvertiserView:(NSArray<NSString *> *)imageArray;
@end
