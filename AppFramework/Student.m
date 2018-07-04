//
//  Student.m
//  AppFramework
//
//  Created by zrq on 2018/7/2.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "Student.h"
#import <objc/runtime.h>
@implementation Student
//快速归档
- (id)initWithCode:(NSCoder *)aDecoder{
    if (self = [super init]) {
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        //获取类的属性及属性对应的类型
        NSMutableArray *keys = [NSMutableArray array];
        NSMutableArray *attributes = [NSMutableArray array];
        unsigned int count;
        objc_property_t *properties = class_copyPropertyList([self class], &count);
        for (int i = 0; i < count ; i++) {
            objc_property_t property = properties[i];
            NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            [keys addObject:propertyName];
            //通过函数获得属性名字和@encode编码
            NSString *propertyAttribute = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
            [attributes addObject:propertyAttribute];
        }
        //立即释放properties指向的内存
        free(properties);
        //根据类型给属性赋值
        for (NSString *key in keys) {
            if ([dict valueForKey:key] == nil) continue;
            [self setValue:[dict valueForKey:key] forKey:key];
        }
    }
    return self;
}
@end
