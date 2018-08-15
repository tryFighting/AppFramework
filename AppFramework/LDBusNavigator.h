//
//  LDBusNavigator.h
//  AppFramework
//
//  Created by zrq on 2018/8/7.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum {
    NavigationModeNone = 0,
    NavigationModePush,
    NavigationModePresent,
    NavigationModeShare
}NavigationMode;
@interface LDBusNavigator : NSObject
/*
 一个应用一个统一的navigator
 */
+ (LDBusNavigator *)navigator;
/*
 在baseviewcontroller下展示URL对应的controller
 */
- (void)showURLController:(UIViewController *)controller baseViewController:(UIViewController *)baseViewController routeMode:(NavigationMode)routeMode;
/*
 设置通用的拦截跳转方式
 */
- (void)setHookRouteBlock:(BOOL (^__nullable)(UIViewController *controller,UIViewController *baseViewController,NavigationMode routeMode))routeBlock;
@end
/**
 * 外部不能调用该类别中的方法，仅供Busmediator中调用
 */
@interface LDBusNavigator (HookRouteBlock)

-(void)hookShowURLController:(nonnull UIViewController *)controller
          baseViewController:(nullable UIViewController *)baseViewController
                   routeMode:(NavigationMode)routeMode;

@end
