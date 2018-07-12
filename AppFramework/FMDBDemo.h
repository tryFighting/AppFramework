//
//  FMDBDemo.h
//  AppFramework
//
//  Created by zrq on 2018/7/12.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
/*
 FMDB是iOS平台的SQLite数据库框架,它以OC的方式封装了SQLite的C语言API
 优点:使用起来更加面向对象，更加轻量级和灵活，提供了多线程安全的数据操作方法，有效地防止数据混乱
 FMDB重要的类：
 FMDatabase:一个FMDatabase对象就代表一个单独的SQLite数据库，用来执行SQL语句
 FMResultSet:使用FMDatabase执行查询后的结果集
 FMDatabaseQueue:用于在多线程中执行多个查询或更新，它是线程安全的
 
 FMDatabase这个类是线程不安全的，如果在多个线程中同时使用一个FMDatabase实例，会造成数据混乱等问题
 为了保证线程安全，FMDB提供方便快捷的FMDatabaseQueue类
 */
@interface FMDBDemo : NSObject
@property(nonatomic,strong)FMDatabase *db;
@end
