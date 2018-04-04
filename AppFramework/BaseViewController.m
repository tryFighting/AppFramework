//
//  BaseViewController.m
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "BaseViewController.h"
///字体设置
#define CustomFont(s) [UIFont systemFontOfSize:s]
///颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define SystemViewBgColor RGBA(0xff, 0xff, 0xff, 1.0)
///系统颜色
#define SystemColor RGBA(0x00, 0x9c, 0x63, 1.0)
@interface BaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation BaseViewController
+ (void)initialize{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundColor:[UIColor clearColor]];
    UIImage *colorImg = [UIImage imageNamed:@"NavigationBar_image"];
    [navBar setBackgroundImage:colorImg forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor blackColor];
    dic[NSFontAttributeName] = CustomFont(22);
    [navBar setTitleTextAttributes:dic];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SystemViewBgColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[UIDevice currentDevice].systemVersion floatValue]>=7.0) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom | UIRectEdgeLeft | UIRectEdgeRight;
        self.edgesForExtendedLayout = UIRectEdgeBottom ;
    }
    //创建基类控制器的视图
    [self createView];
}
#pragma mark --创建基类控制器的视图
- (void)createView{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[NSForegroundColorAttributeName] = [UIColor blackColor];
    dic[NSFontAttributeName] = CustomFont(22);
    [self.navigationController.navigationBar setTitleTextAttributes:dic];
    self.leftAction = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leftAction.frame=CGRectMake(0, 0,30, 44);
    [self.leftAction addTarget:self action:@selector(navbackBtnClick) forControlEvents:UIControlEventTouchDown];
    self.leftAction.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.leftAction setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc]initWithCustomView:self.leftAction];
    self.navigationItem.leftBarButtonItem = leftBar;
    
    self.navigationController.view.backgroundColor = RGBA(0xc6, 0xc6, 0xcb, 1.0);
    
    self.rightAction = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightAction.frame = CGRectMake(0, 0, 30, 44);
    self.rightAction.hidden = YES;
    self.rightAction.titleLabel.font = [UIFont systemFontOfSize:15];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithCustomView:self.rightAction];
    self.navigationItem.rightBarButtonItem = rightBar;
    
    
    CGFloat width = 200;
    if (width > 200) {
        width = 200;
    }
    width = 200;
    
    self.centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , width, 44)];
    self.centerLabel.backgroundColor = [UIColor clearColor];
    
    self.centerLabel.text = self.title;
    self.centerLabel.textColor = SystemColor;//设置文本颜色
    [self.centerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    self.centerLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = self.centerLabel;
    
    [[UITextField appearance] setTintColor:SystemColor];
    
    [[UITextView appearance] setTintColor:SystemColor];

    
}

#pragma Mark -- 是否接收手势触摸
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (void)navbackBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
