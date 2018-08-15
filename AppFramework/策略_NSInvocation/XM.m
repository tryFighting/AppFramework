//
//  XM.m
//  算法
//
//  Created by zrq on 2018/8/9.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "XM.h"
@interface XM()
@property(nonatomic,copy)NSDictionary *strategyDict;//策略
@property(nonatomic,copy)NSDictionary *paramDict;//参数
@end
@implementation XM

- (NSInvocation *)invocationWithMethod:(SEL)selector{
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        NSString *reason = [NSString stringWithFormat:@"提示: The method[%@] is not find",NSStringFromSelector(selector)];
        @throw [NSException exceptionWithName:@"错误" reason:reason userInfo:nil];
    }
    NSInvocation  *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    NSDictionary *param = self.paramDict;
    //index表示第几个参数，注意0和1已经被占用了self,_cmd,所以传递的参数从2开始
    [invocation setArgument:&(param) atIndex:2];
    return invocation;
}
- (void)playBasketball:(NSDictionary *)dict{
    NSLog(@"方法:%s 参数:%@",__FUNCTION__,dict);
}
- (void)shopping:(NSDictionary *)dict{
    NSLog(@"方法:%s 参数:%@",__FUNCTION__,dict);
}
- (void)washClothes:(NSDictionary *)dict{
    NSLog(@"方法:%s 参数:%@",__FUNCTION__,dict);
}
- (void)playGames:(NSDictionary *)dict{
    NSLog(@"方法:%s 参数:%@",__FUNCTION__,dict);
}
- (void)sing:(NSDictionary *)dict{
    NSLog(@"方法:%s 参数:%@",__FUNCTION__,dict);
}
- (void)sleep{
    NSLog(@"这是其他情况：%s",__FUNCTION__);
}
- (NSDictionary *)strategyDict{
    if (_strategyDict == nil) {
        _strategyDict = @{
                          @"day1" : [self invocationWithMethod:@selector(playBasketball:)],
                          @"day2" : [self invocationWithMethod:@selector(shopping:)],
                          @"day3" : [self invocationWithMethod:@selector(washClothes:)],
                          @"day4" : [self invocationWithMethod:@selector(playGames:)],
                          @"day5" : [self invocationWithMethod:@selector(sing:)]
                          };
    }
    return _strategyDict;
}
- (void)doSomething:(NSString *)dayStr params:(NSDictionary *)params{
    self.paramDict = params;
    if (self.strategyDict[dayStr]) {
        NSInvocation *doWhat = self.strategyDict[dayStr];
        [doWhat invoke];
    }else{
        [self sleep];
    }
}
@end
