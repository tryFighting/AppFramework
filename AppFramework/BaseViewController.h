//
//  BaseViewController.h
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
///导航栏标题
@property (strong, nonatomic) UILabel * centerLabel;
///左侧按钮
@property (strong, nonatomic) UIButton *leftAction;
///右侧按钮
@property (strong, nonatomic) UIButton *rightAction;
@end
