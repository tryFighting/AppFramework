//
//  BaseWebViewController.h
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
@interface BaseWebViewController : BaseViewController
///网页视图
@property (strong, nonatomic) WKWebView *wkWebView;
///设置加载的进度条
@property(nonatomic,strong)UIProgressView *progressView;
///设置加载的URL字符串
@property(nonatomic,copy)NSString *requestUrl;
@end
