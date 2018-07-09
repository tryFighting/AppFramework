//
//  ViewController.h
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
//基于protocol的代理设计模式
@protocol ViewControllerDelegate<NSObject>
@optional
- (void)year:(NSString *)year month:(NSString *)month day:(NSString *)day;
@end
@interface ViewController : BaseViewController
@property(nonatomic,weak)id<ViewControllerDelegate> delegate;
@end
/*
 在AClass中定义一个事件方法，在事件的实现中书写事件代码，并通知代理
 其他类BClass中遵守AClassDelegate协议，并使用self.delegate = self;将这个其他设置为A的代理方法，可以通过代理方法获得第三步传过来的数据
 */
