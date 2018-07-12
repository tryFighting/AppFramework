//
//  NotificationDemo.m
//  AppFramework
//
//  Created by zrq on 2018/7/12.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "NotificationDemo.h"
#import "Student.h"
@implementation NotificationDemo
- (void)newsCome:(NSNotification *)note{
    //通知的 发布者
    Student *obj = note.object;
    NSLog(@"%@接收到了%@发出的通知,通知内容是:%@",self.name,obj.name,note.userInfo);
}
@end
