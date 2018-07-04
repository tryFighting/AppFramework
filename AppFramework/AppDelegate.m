//
//  AppDelegate.m
//  AppFramework
//
//  Created by zrq on 2018/4/4.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "WebViewController.h"
@interface AppDelegate ()

@end
/*
 一：
 iOS Runtime之一：Class 和 meta-class
 Objective-C类由Class类型来表示的，它实际上是指向objc_class结构体的指针
 struct objc_class{
 Class isa OBJC_ISA_AVAILABILITY;
 #if !__OBJC2__
 Class super_class  OBJC2_UNAVAILABLE;父类
 const char *name   OBJC2_UNAVAILABLE;类名
 long version       OBJC2_UNAVAILABLE;类的版本信息
 long info          OBJC2_UNAVAILABLE;类信息，供运行期间使用的一些位标识
 long instance_size OBJC2_UNAVAILABLE;该类的成员变量大小
 struct objc_ivar_list *ivars OBJC2_UNAVAILABLE;该类的成员变量链表
 struct objc_method_list **methodLists OBJC2_UNAVAILABLE;方法定义的链表
 struct objc_cache *cache   OBJC2_UNAVAILABLE;方法缓存
 struct objc_protocol_list *protocols OBJC2_UNAVAILABLE;协议链表
 #end if
 }OBJC2_UNAVAILABLE;
 1.isa:所有的类自身也是一个对象，这个对象的Class里面也有一个isa指针，它指向metaClass(元类)
 2.super_class:指向该类的父类，如果该类已经是最顶层的根类(NSObject或NSProxy)
 3.cache:用于缓存最近使用的方法。一个接收对象接收到一个消息时，它会根据ISA指针去查找能够响应这个消息的对象。在实际使用中，这个对象只有一部分方法是常用的，很多方法其实很少用或者根本用不上。这种情况下，如果每次消息来时，我们都是methodLists中遍历一遍，性能势必很差。这时cache就派上用场了。在我们每次调用一个方法后，这个方法就会被缓存到cache列表中，下次调用的时候runtime就会优先去cache中查找，如果cache没有，才回去methodLists中查找方法，提高了调用的效率
 4.version:我们可以使用这个字段提供类的版本信息。这对于对象的序列化非常有用，它可是让我们识别出不同类定义版本中实例变量布局的改变。
 针对cache  :  NSArray *array = [NSArray alloc] init]
 runtime执行流程：1.【NSArray alloc]先被执行,因为NSArray没有alloc方法，于是去父类NSObject去查找
 2.检测NSObject是否响应+alloc方法，发现响应，于是检测NSArray类，并根据其所需的内存空间大小开始分配内存空间，然后把isa指针指向NSArray类，同时，+alloc也被加进cache列表里面。
 3.接着执行-init方法，如果NSArray响应该方法，则直接将其加入cache；如果不响应，则去父类查找。
 4.在后期操作中，如果再以【NSArray alloc] init]这种方式来创建数组，则会直接从cache中取出相应的方法，直接调用
 
 二.objc_object与id
 objc_object是表示一个类的实例的结构体
 struct objc_object{
 Class isa OBJC_ISA_AVAILABILITY;
 };
 typedef struct objc_object *id;
 可以看到这个结构体只有一个字体，即指向其类的isa指针。这样，我们向一个Objective-C对象发送消息时，运行时会根据实例对象的isa指针找到这个实例对象所属的类。Runtime库会在类的方法列表及父类的方法列表中去寻找与消息对应的selector指向的方法，找到后即运行这个方法。
 当创建一个特定类的实例对象时，分配的内存包含一个objc_object数据结构，然后是类的实例变量的数据。NSObject类的alloc和allocWithZone:方法使用函数class_createInstance来创建objc_object数据结构
 另外还有我们常见的id,它是一个objc_object结构类型的指针。它的存在可以让我们实现类似于C++中泛型的一些操作。该类型的对象可以转换为任何一种对象，有点类似于C语言中void *指针类型的作用
 三：objc_cache
 这个字段是指向objc_cache结构体的指针
 struct objc_cache{
 unsigned int mask
 unsigned int occupied
 Method buckets[1]
 };
 mask:一个整数，指定分配的缓存bucket的总数。在方法查找过程中，Objective-C runtime使用这个字段来确定开始线性查找数组的索引位置。指向方法selector的指针与该字段做一个AND操作(index = (mask & selector))这个可以作为一个简单的hash散列算法
 occupied:一个整数，指定实际占用的缓存bucket的总数
 buckets:指向Method数组结构指针的数组，这个数组可能包含不超过mask+1个元素，需要注意的是，指针可能是NULL，表示这个缓存bucket没有被占用，另外被占用的bucket可能是不连续的。这个数组可能会随着时间而增长。
 四：元类（Meta Class）
 NSArray *array = [NSArray alloc] init]
 +array消息发送给了NSArray类，而这个NSArray也是一个对象，既然是对象，那么它也是一个objc_object指针，它包含一个指向其类的一个isa指针，这个isa指针也要指向这个类所属的类  这个isa指针指向什么呢 这就引出了meta-class的概念
 meta-class是一个类对象的类
 当我们向一个对象发送消息时，runtime会在这个对象所属的这个类的方法列表中查找方法；而向一个类发送消息时，会在这个类meta-class的方法列表中查找。
 meta-class是必须的，因为它为一个class存储类方法，每个class都必须有一个唯一的meta-class，因为每个class的类方法基本不可能完全相同
 OC让所有的meta-class的isa指向基类的meta-class,以此作为他们所属的类
 即任何NSObject继承体系下的meta-class都使用NSObject的meta-class作为自己所属的类
 基类的meta-class的isa指针指向它自己，这就是说NSObject的meta-class的isa指针指向NSObject的meta-class自己，这样就形成了一个完美的闭环。
 */
/*
 iOS Runtime之二：类与对象的操作
 一.类与对象的操作函数
 runtime提供了大量的函数来操作类与对象，操作类的函数一般前缀是class,而操作对象的函数一般前缀objc
 1.类相关操作函数
 //获取类的类名 const char *class_getName(Class cls)
 //获取类的父类 Class class_getsuperclass(Class cls)
 //判断给定的class是否是一个元类 BOOL class_isMetaClass(Class cls)
 //获取实例大小 size_t class_getInstanceSize(Class cls)
 2.成员变量相关操作函数
 //获取类中指定名称实例成员变量的信息 Ivar class_getInstanceVariable(Class cls,const char *name)
 //获取类成员变量的信息  Ivar class_getClassVariable(Class cls,const char *name)
 //添加成员变量  BOOL class_addIvar(Class cls,const char *name,size_t size,uint8_t alignment,const char *types);
 //获取整个成员变量列表 Ivar *class_copyIvarList(Class cls,unsigned int *outCount);
 需要注意:(1)class_copyIvarList:获取的是所有成员实例属性，与property获取不一样
 (2):class_addIvar:OC不支持往已存在的类中添加实例变量,因此不管是系统提供的库，还是我们自定义的类，都无法动态给它添加成员变量。但是如果我们通过运行时创建的类，我们可以用class_addIvar来添加。不过，这个方法只能在objc_allocateClassPair函数与objc_registerClassPair之间调用。另外这个类也不能是元类
 3.属性操作函数
 //获取指定的属性 objc_prperty_t class_getProperty(Class cls,const char *name);
 //获取属性列表   objc_property_t *class_copyPropertyList(Class cls,unsigned int *outCount)
 //为类添加属性 BOOL class_addProperty(Class cls,const char *name,const objc_property_attrubute_t *attrs,unsigned int attributeCount)
 //替换类的属性
 void class_replaceProperty(Class cls,const char *name,const objc_property_attribute_t *attrs,unsigned int attributeCount)
 4.协议相关的函数（添加协议，返回类是否实现指定的协议，返回类实现的协议列表）
 // 添加协议
 BOOL class_addProtocol ( Class cls, Protocol *protocol );
 
 // 返回类是否实现指定的协议
 BOOL class_conformsToProtocol ( Class cls, Protocol *protocol );
 
 // 返回类实现的协议列表
 Protocol * class_copyProtocolList ( Class cls, unsigned int *outCount );
 5.版本号(Version)
 获取版本与设置版本
 四：动态创建类和对象
 1.动态创建类
 //创建一个类和元类 Class objc_allocateClassPair(Class superclass,const char *name,size_t extraBytes);
 //销毁一个类及其相关联的类 void objc_disposeClassPair(Class cls);
 //在应用中注册由objc_allocateClassPair创建的类 void objc_registerClassPair(Class cls)
 (1)其中objc_allocateClassPair函数：如果我们要创建一个根类，则superclass指定为Nil,extraBytes通常指定为0，该参数分配给类和元对象尾部的索引ivars的字节数
 (2)为了创建一个新类，我们需要调用objc_allocateClassPair,然后使用诸如class_addMethod,class_addIvar等函数来为新创建的类添加方法，实例变量和属性等。完成这些后，我们需要调用objc_registerClassPair函数来注册类，之后这个类就可以在程序中使用了
 (3)实例方法和实例变量应该添加到类自身上，而类方法应该添加到类的元类上
 (4)objc_disposeClassPair只能销毁由objc_allocateClassPair创建的类，当有实例存在或者它的子类存在时,调用这个函数会抛出异常
 2.动态创建对象
 //创建类实例，在指定位置创建类实例，销毁类实例
 使用class_createInstance函数获取的是NSString实例，而不是类簇中的默认占位符类__NSCFConstantString
 3.其他类和对象相关操作函数
 // 获取已注册的类定义的列表
 int objc_getClassList ( Class *buffer, int bufferCount );
 
 // 创建并返回一个指向所有已注册类的指针列表
 Class * objc_copyClassList ( unsigned int *outCount );
 
 // 返回指定类的类定义
 Class objc_lookUpClass ( const char *name );
 Class objc_getClass ( const char *name );
 Class objc_getRequiredClass ( const char *name );
 
 // 返回指定类的元类
 Class objc_getMetaClass ( const char *name );
 
 
 // 返回指定对象的一份拷贝
 id object_copy ( id obj, size_t size );
 
 // 释放指定对象占用的内存
 id object_dispose ( id obj );
 // 修改类实例的实例变量的值
 Ivar object_setInstanceVariable ( id obj, const char *name, void *value );
 
 // 获取对象实例变量的值
 Ivar object_getInstanceVariable ( id obj, const char *name, void **outValue );
 
 // 返回指向给定对象分配的任何额外字节的指针
 void * object_getIndexedIvars ( id obj );
 
 // 返回对象中实例变量的值
 id object_getIvar ( id obj, Ivar ivar );
 
 // 设置对象中实例变量的值
 void object_setIvar ( id obj, Ivar ivar, id value );
 // 返回给定对象的类名
 const char * object_getClassName ( id obj );
 
 // 返回对象的类
 Class object_getClass ( id obj );
 
 // 设置对象的类
 Class object_setClass ( id obj, Class cls );
 */
/*
 iOS Runtime之三:成员变量与属性
 类型编码：作为runtime的补充,编译器按每个方法的返回值和参数类型编码为一个字符串，并将其与方法的selector关联在一起。
 因此我们可以用@encode编译器指令来获取它.当给定一个类型时，@encode返回这个类型的字符串编码。这些类型可以是诸如int,指针这样的基本类型，也可以是结构体，类等类型。事实上，任何可以作为sizeof()操作参数的类型都可以用于@encode()
 针对属性而言，还会有一些特殊的类型编码，以表明属性是只读，拷贝，retain
 
 1.成员变量:
 Ivar:实例变量类型，是一个指向objc_ivar结构体的指针
 typedef struct objc_ivar *Ivar;
 struct objc_ivar{
 char *ivar_name;
 char *ivar_type;
 int ivar_offset;基地址偏移字节
 #ifdef __LP64__
 int space
 #endif
 }
 2.操作函数
 //获取整个成员变量列表
 Ivar *class_copyIvarList(Class cls,unsigned int *outCount);
 //获取成员变量名
 const char *ivar_getName(Ivar v);
 //获取成员变量类型编码
 const char *ivar_getTypeEncoding(Ivar v);
 //获取类中指定名称实例成员变量的信息
 Ivar class_getInstanceVariable(Class cls,const char *name);
 //获取成员变量的偏移量
 ptrdiff_t ivar_getoffset(Ivar v);
 
 3.属性：
 1.定义 objc_property_t:声明的属性的类型，是一个指向objc_property结构体的指针
 typedef struct objc_property *Property;
 typedef struct objc_property  *objc_property_t;
 2,属性的操作函数
 获取指定的属性，获取属性列表，为类添加属性，替换类的属性，获取属性名，获取属性特性描述字符串
 获取属性中指定的特性 获取属性的特性列表
 常用的属性如下：属性类型,编码类型，非/原子性 变量名称
 
 4.应用实例
 @1 json到model的转化 json-dictionay-model
 原理：用runtime提供的函数遍历model自身所有的属性，如果属性在json中有对应的值，则将其赋值
 @2 快速归档
 原理：用runtime提供的函数变量Model自身所有属性，并对属性进行encode和decode操作
 @3访问私有变量
 OC没有真正意义上的私有变量和方法，要让成员变量私有，要放在m文件中声明，不对外暴露。如果我们知道这个成员变量的名称，可以通过runtime获取成员变量,再通过getIvar来获取它的值
 Ivar ivar = class_getInstanceVariable([Model class],'_str1');
 NSString *str1 = object_getIvar(model,ivar);
 */
/*
 iOS Runtime之四：关联对象
 @1概述
 类目不允许为已有的类添加新的成员变量，实际上允许添加属性的，同样可以使用@property，但是不会生成_变量，也不会生成添加属性的getter和setter方法。但实际上可以使用runtime去实现类目为已有的类添加新的属性并生成getter和setter方法
 关联对象是指某个OC对象通过一个唯一的key链接到一个类的实例上。
 
 @2如何关联对象
 runtime提供给我们的方法：关联对象，获取关联的对象，移除关联的对象
 当对象释放时，会根据这个策略来决定是否释放关联的对象，策略是RETAIN/COPY时会释放关联的对象，当是ASSIGN,将不会释放
 */
/*
 iOS Runtime之五:方法与消息
 一 基本数据类型
 @1 SEL
 选择器，是表示一个方法的selector的指针
 typedef struct objc_selector *SEL;
 方法的selector用于表示运行时方法的名字。OC在编译时会根据每一个方法的名字，参数序列，生成一个唯一的整型标识(Int类型的地址),这个标识就是SEL;
 SEL sel1 = @selector(method1);
 两个类之间，不管他们是父类与子类的关系，还是之间没有这种关系，只要方法名一样，那么方法的SEL就是一样的，不能存在2个同名的方法，即使参数类型不同也不行
 当然，不同的类可以拥有相同的selector，不同类的实例对象执行相同的selector时，会在各自的方法列表中去根据selector去寻找自己对应的IMP
 本质上，SEL只是一个指向方法的指针，准确的说，只是一个根据方法名hash化了的key值，能唯一代表一个方法，它的存在只是为了加快方法的查询速度。
 我们可以在运行时添加新的selector，也可以在运行时获取已存在的selector，我们可以通过三种方法来获取SEL
 sel_registerName函数  OC编译器提供的@selector() NSSelectorFromString()方法
 
 @2 IMP
 IMP实际上是一个函数指针，指针方法实现的首地址。
 id(*IMP)(id,SEL,...)
 这个函数使用当前CPU架构实现标准的C调用约定
 第一个参数是指向self的指针，如果是实例方法则是实例的内存地址，如果是类方法，则是指向元类的指针，第二个参数是selector
 SEL就是为了查找方法的最终实现IMP的，由于每个方法对应唯一的sel,因此我们可以通过SEL方便快速准确的获得它对应的IMP
 通过取得IMP，我们可以跳过runtime的消息传递机制，直接执行IMP指向的函数实现，这样省去了runtime消息传递过程中所做的一系列查找操作，会比直接向对象发送消息高效一些
 @3 Method用于表示类定义中的方法
 typedef struct objc_method *Method;
 struct objc_method{
 SEL method_name;
 char *method_types;
 IMP method_imp;
 }
 
 我们可以看到该结构体中包含一个SEL和IMP,实际上相当于SEL和IMP之间作了一个映射，有了SEL，我们便可以找到对应的IMP，从而调用方法的实现代码
 @4 objc_method_description
 struct objc_method_description{SEL name; char *types;}
 
 二 方法相关操作函数
 runtime提供了一系列的方法来处理与方法相关的操作，包括方法本身及SEL
 @1 方法操作相关函数
 //调用指定方法的实现
 id method_invoke(id receiver,Method m,...)
 method_invoke函数，返回的是实际实现的返回值，参数receiver不能为空
 //调用返回一个数据结构的方法实现
 void method_invoke_stret(id receiver,Method m,...)
 //获取方法名
 SEL method_getName(Method m)
 //返回方法的实现
 IMP method_getImplementation(Method m)
 // 获取方法的指定位置参数的类型字符串
 char * method_copyArgumentType ( Method m, unsigned int index );
 
 // 通过引用返回方法的返回值类型字符串
 void method_getReturnType ( Method m, char *dst, size_t dst_len );
 
 // 返回方法的参数的个数
 unsigned int method_getNumberOfArguments ( Method m );
 
 // 通过引用返回方法指定位置参数的类型字符串
 void method_getArgumentType ( Method m, unsigned int index, char *dst, size_t dst_len );
 
 // 返回指定方法的方法描述结构体
 struct objc_method_description * method_getDescription ( Method m );
 
 // 设置方法的实现
 IMP method_setImplementation ( Method m, IMP imp );
 
 // 交换两个方法的实现
 void method_exchangeImplementations ( Method m1, Method m2 );
 
 @2方法选择器
 sel_registerName(const char *str);//注册一个方法，将方法名映射到一个选择器，并返回这个选择器
 必须在runtime系统中注册一个方法名以获取方法的选择器
 
 三，方法调用流程
 */
@implementation AppDelegate
/*
 支付宝应用架构  首次加载网络请求 存储本地 下次进入 不再请求 如若请求直接读取本地记录
 如有变更  则就需要在做强制版本更新
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //WebViewController
    ViewController * view = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    self.window.rootViewController = nav;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
