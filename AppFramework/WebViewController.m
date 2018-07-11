//
//  WebViewController.m
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(show) userInfo:nil repeats:YES];
    //加入到runloop中才可以运行
   // [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    //当textField滑动的时候，timer会失效，停止滑动时，timer恢复
    //原因:当textField滑动的时候，runloop的mode会自动切换成UITrackingRunLoopMode
    // [[NSRunLoop mainRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //两个模式下都添加timer是可以的，但是timer添加了两次，但并不是一个timer
    //因此就是说我们使用NSRunloopCommonModes，timer可以在两种模式下运行
     [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)show{
    NSLog(@"----");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"xxxxxxxxxxxxxxxx哈哈😆");
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
