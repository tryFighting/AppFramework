//
//  LDBusNavigator.m
//  AppFramework
//
//  Created by zrq on 2018/8/7.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "LDBusNavigator.h"
@interface LDBusNavigator(){
    BOOL (^_routeBlock)(UIViewController * controller, UIViewController * baseViewController, NavigationMode routeMode);
}
@end
@implementation LDBusNavigator
+ (LDBusNavigator *)navigator{
    static LDBusNavigator *rootNavigator = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (rootNavigator == nil) {
            rootNavigator = [[LDBusNavigator alloc] init];
        }
    });
    return rootNavigator;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        _routeBlock = nil;
    }
    return self;
}
- (UIViewController *)topmostViewController{
    //rootviewController
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    if (!rootViewController || (![rootViewController isKindOfClass:[UITabBarController class]]&&![rootViewController isKindOfClass:[UINavigationController class]])) {
        return nil;
    }
    //当前显示哪个tab页
    UINavigationController *rootNavController = nil;
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        rootViewController = (UINavigationController *)[(UITabBarController *)rootViewController selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        rootViewController = (UINavigationController *)rootViewController;
    }else{
        return rootViewController;
    }
    if (!rootViewController) {
        return nil;
    }
    //当前显示哪个tab页
    UINavigationController *navController = rootNavController;
    return nil;
}
//设置通用的拦截跳转方式
- (void)setHookRouteBlock:(BOOL (^)(UIViewController *, UIViewController *, NavigationMode))routeBlock{
    _routeBlock = routeBlock;
}
- (void)showURLController:(UIViewController *)controller baseViewController:(UIViewController *)baseViewController routeMode:(NavigationMode)routeMode{
    if (routeMode == NavigationModeNone) {
        routeMode = NavigationModePush;
    }
    switch (routeMode) {
        case NavigationModePush:
            
            break;
            
        default:
            break;
    }
}
@end
