//
//  AdvertiseView.h
//  AppFramework
//
//  Created by zrq on 2018/7/30.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertiseView : UIView
///显示广告页的方法
- (void)show;
//图片路径
@property(nonatomic,copy)NSString *filePath;
@end
