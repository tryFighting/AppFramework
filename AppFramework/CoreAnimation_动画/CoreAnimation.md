#  Core Animation详解
一概述：
CA：核心动画，它是一组非常强大的动画处理API,使用它能做出非常绚丽的动画
CA是直接作用在CALayer上的，并非UIView
二.继承结构
CA是所有动画对象的父类，负责控制动画的持续时间和速度，是个抽象类，不能直接使用，应该使用具体子类，需要注意的是
CAAnimation和CAPropertyAnimation都是抽象类

view是负责响应事件的，layer是负责显示的


核心动画中所有类都遵守CAMediaTiming
CAAnaimation是个抽象类，不具备动画效果，必须用子类CAAnimationGroup和CATransition才会有动画效果
CAAnimationGroup(动画组)可以同时进行缩放，旋转
CATransition转场动画，界面之间跳转都可以用转场动画
CAPropertyAnimation也是个抽象类，本身不具备动画效果，只有子类（CABasicAnimation和CAKeyframeAnimation）才有动画效果
CABasicAnimation 基础动画，做一些简单的效果
CAKeyframeAnimation帧动画，做一些连续的流畅动画
三.CA Steps:

1、使用步骤

第一步：初始化一个CAAnimation对象，并设置一些动画相关属性。

第二步：通过调用CALayer的addAnimation:forKey:方法增加CAAnimation对象到CALayer中，这样就能开始执行动画了。

第三步：通过调用CALayer的removeAnimationForKey:方法可以停止CALayer中的动画。
2.常用属性   keypath  动画填充方式  动画速度控制函数 CALayer上动画的暂停和恢复

四 动画调用方式
1.UIView代码块调用
2.begin ---commit模式动画
3.使用CA中的类



























