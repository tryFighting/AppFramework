//
//  main.m
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//
/*
 UIApplicationDelegate与UIViewController生命周期
 一.每个iPhone应用程序都有一个UIApplication,UIApplication是iPhone应用程序的开始并且负责初始化并显示UIWindow,并加载应用程序中的第一个UIView到UIWindow窗体中
 UIApplication的另一个任务是帮助管理应用程序的生命周期，而UIApplication通过一个名字为UIApplicationDelegate的代理类来履行这个任务，尽管UIApplication会负责接收事件，而UIApplicationDelegate则决定应用程序如何去响应这些事件，UIApplicationDelegate可以处理的事件包括应用程序的生命周期事件(比如程序启动和关闭),系统事件(比如来电，记事项警告)
 
 打开程序---执行main函数---执行UIApplicationMain函数----初始化UIApplication(创建和设置代理对象,开启事件循环)---监听系统事件---（程序加载完毕--程序获取焦点--程序进入后台--程序失去焦点--程序从后台回到前台--内存警告,可能要终止程序---程序即将退出）----结束程序
 二.UIViewController是iOS开发中MVC的C，主要包括管理内部各个view的加载显示和卸载，同时负责与其他vc通信与协调
 在iOS开发中 有两类控制器，一类是显示内容的，一类是控制器的容器，导航控制器是以stack的形式来存储和管理控制器，表视图控制器是以Array的形式来管理viewController
 三.UIViewController的生命周期
 @1 view的加载和卸载
 在view加载过程中首先会调用loadview方法，在这个方法中主要完成一些关键view初始化的工作，比如容器类的控制器
 接下来就是加载view,加载成功后会接着调用viewDidLoad方法，在loadview之前是没有view的，也就是说，在这之前，view还没有被初始化，完成viewdidload里面就成功的加载view了
 创建view有两种方式，一种是通过代码创建，一种通过sb,xib,后者可以比较直观的配置view的外观和属性，storyboard适合iOS 6后退出的autolayout,是一种UI定制解决方案
 
 当系统发出内存警告时，会调用didReceiveMemoryWarning方法，如果当前有能被释放的view，系统会调用viewwillUnload方法来释放view,完成调用后，view就被卸载了，原本指向view的变量为nil,具体操作在viewDidUnload方法中调用self.myView = nil;
 
 @2 viewcontroller 生命周期中方法执行流程
 - init ---loadview ---- viewDidLoad--viewwillappear--viewdidappear--viewwilldisappear---viewdiddisappear--viewdidunload--dealloc
 */
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
