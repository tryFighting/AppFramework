//
//  LDBusConnectorPrt.h
//  AppFramework
//
//  Created by zrq on 2018/8/7.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 链接点协议
 每个业务模块在对外的挂接点实现这个协议，以便被BusMediator发现和调度
 */
@class UIViewController;
@protocol LDBusConnectorPrt <NSObject>
@optional
/*
 当前业务组件可导航的URL询问判断
 */
- (BOOL)canOpenURL:(NSURL *)URL;
/*
 业务模块挂中间件，注册自己能够处理的URL，完成url的跳转
 如果url跳转需要回传数据，则传入实现了数据接收的调用者
 @return UIViewController的派生实例
 nil表示不能处理
 [UIViewController notURLController]的实例，自动处理present
 */
- (nullable UIViewController *)connectToOpenURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;
/**
 * 业务模块挂接中间件，注册自己提供的service，实现服务接口的调用；
 *
 * 通过protocol协议找到组件中对应的服务实现，生成一个服务单例；
 * 传递给调用者进行protocol接口中属性和方法的调用；
 */
- (nullable id)connectToHandleProtocol:(nonnull Protocol *)servicePrt;
@end
