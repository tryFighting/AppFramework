//
//  ViewController.m
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <objc/runtime.h>
#import "Student.h"
#import "NSArray+Blog.h"
@interface ViewController ()
{
    NSArray *arr;
    NSString *totol;
}
@property(nonatomic,copy)NSString *cms;
@end

@implementation ViewController
//上面为类添加了成员变量，也可以结合属性操作方法为类添加属性
- (void)addClassTest{
    Class myClass = objc_allocateClassPair([NSObject class], "myclass", 0);
    //添加一个NSString的变量,第四个参数是对其方式，第五个参数是参数类型
    if (class_addIvar(myClass, "myIvar", sizeof(NSString *), 0, "@")) {
        NSLog(@"add ivar success");
    }
    //myclasstest是已经实现的函数，“v@:”这种写法见参数类型连接
    class_addMethod(myClass, @selector(method0:), (IMP)method1, "v@:");
    //注册这个类到runtime系统就可以使用了
    objc_registerClassPair(myClass);
    //生成一个实例化对象
    id myobj = [[myClass alloc] init];
    NSString *str = @"lifengfeng";
    //给刚刚添加的变量赋值
    [myobj setValue:str forKey:@"myIvar"];
    //调用方法，也就是给myobj这个接受发送消息
    [myobj method0:10];
    float a[] = {1.0,2.0,3.0};
    NSLog(@"%s",@encode(typeof(a)));
    [self categoryTest];
    
}
- (void)categoryTest{
    NSArray *myArray = [[NSArray alloc] init];
    myArray.blog = @"xxx";
    NSLog(@"%@",myArray.blog);
}
//这个方法实际上没有被调用，但是必须实现否则不会调用下面的方法
- (void)method0:(int)a{
    
}
//调用的是这个方法
void method1(id self,SEL _cmd,int a){
    //self,_cmd是必须的，在之后可以随意添加其他函数
    Ivar v = class_getInstanceVariable([self class], "myIvar");
    id o = object_getIvar(self, v);
    NSLog(@"%@",o);
    NSLog(@"int a is %d",a);
}
- (void)testVersion {
    int version = class_getVersion([Student class]);
    NSLog(@"%d", version);
    class_setVersion([Student class], 100);
    version = class_getVersion([Student class]);
    NSLog(@"%d", version);
}
- (void)testProtocolList{
    //添加协议
    //Protocol *p = @protocol(Student);
    Protocol *p;
    if(class_addProtocol([Student class], p)) {
        NSLog(@"添加协议成功!");
    }
    else {
        NSLog(@"添加协议失败!");
    }
    
    //判断是否实现了指定的协议
    if(class_conformsToProtocol([Student class], p)) {
        NSLog(@"遵循 %s协议", protocol_getName(p));
    }
    else {
        NSLog(@"不遵循 %s协议", protocol_getName(p));
    }
    
    //获取类的协议列表
    unsigned int outCount;
    Protocol * __unsafe_unretained *protocolList = class_copyProtocolList([Student class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        Protocol *protocol = protocolList[i];
        const char *name = protocol_getName(protocol);
        NSLog(@"%s", name);
    }
    free(protocolList);
}
- (void)testProperty{
    /**
     *  添加property
     */
    objc_property_attribute_t attribute1 = {"T", "@\"NSString\""};
    objc_property_attribute_t attribute2 = {"C", ""};
    objc_property_attribute_t attribute3 = {"N", ""};
    objc_property_attribute_t attribute4 = {"V", "_lcg"};
    objc_property_attribute_t attributesList[] = {attribute1, attribute2, attribute3, attribute4};
    if(class_addProperty([Student class], "lcg", attributesList, 4)) {
        NSLog(@"add property success!");
    }
    else {
        NSLog(@"add property failure!");
    }
    /**
     *  打印property的name和property_attribute_t
     */
    unsigned int outCount;
    objc_property_t *propertyList = class_copyPropertyList([Student class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        objc_property_t property = propertyList[i];
        const char *propertyName = property_getName(property);
        const char *attribute = property_getAttributes(property);
        NSLog(@"propertyName: %s, attribute: %s", propertyName, attribute);
        
        unsigned int attributeCount;
        objc_property_attribute_t *attributeList = property_copyAttributeList(property, &attributeCount);
        for (unsigned int j = 0; j < attributeCount; j++) {
            objc_property_attribute_t attribute = attributeList[j];
            const char *name = attribute.name;
            const char *value = attribute.value;
            NSLog(@"attribute name: %s, value: %s", name, value);
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.centerLabel.text = @"原生";
    WebViewController *web = [[WebViewController alloc] init];
    web.requestUrl = @"http://www.baidu.com";
    [self.navigationController pushViewController:web animated:YES];
    
    [self testIvar];
    
    [self testProperty];
    
    [self testProperty];
    
    [self testVersion];
    
    [self addClassTest];
}
/*
 测试成员变量
 */
- (void)testIvar{
    unsigned int outCount;
    if (class_addIvar([Student class], "_hell", sizeof(id), log2(sizeof(id)), "@")) {
        NSLog(@"Add Ivar Success");
    }else{
        NSLog(@"Add Ivar Failed");
    }
    Ivar *ivarList  = class_copyIvarList([Student class], &outCount);
    for (unsigned int i = 0; i < outCount; i++) {
        Ivar ivar = ivarList[i];
        const char *ivarName = ivar_getName(ivar);
        ptrdiff_t offset = ivar_getOffset(ivar);
        const char *types = ivar_getTypeEncoding(ivar);
        NSLog(@"ivar:%s,offset:%zd,type:%s",ivarName,offset,types);
    }
    free(ivarList);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
