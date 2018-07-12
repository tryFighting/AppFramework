//
//  FMDBDemo.m
//  AppFramework
//
//  Created by zrq on 2018/7/12.
//  Copyright © 2018年 zrq. All rights reserved.
//

#import "FMDBDemo.h"

#define dataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject]stringByAppendingPathComponent:dataBaseName]
#define dataBaseName @"test.sqlite"
@implementation FMDBDemo
/*
 使用事务
 */
- (void)useTransaction{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    [queue inDatabase:^(FMDatabase *db) {
        // 开启事务
        [db executeUpdate:@"begin transaction;"];//等价于[db beginTransaction];
        
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @20, @"jack"];
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @20, @"jack"];
        
        if (YES){
            // 回滚事务
            [db executeUpdate:@"rollback transaction;"];//等价于[db rollback];
            
        }
        
        [db executeUpdate:@"update t_student set age = ? where name = ?;", @20, @"jack"];
        
        // 提交事务
        [db executeUpdate:@"commit transaction;"];//等价于[db commit];
        
    }];
    
    //第二种方法
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        [db executeUpdate:@"INSERT INTO t_student(name) VALUES (?)", @"Jack"];
        [db executeUpdate:@"INSERT INTO t_student(name) VALUES (?)", @"Rose"];
        [db executeUpdate:@"INSERT INTO t_student(name) VALUES (?)", @"Jim"];
        if(YES)
        {
            *rollback = YES;//回滚事务
        }
        
        FMResultSet *rs = [db executeQuery:@"select * from t_student"];
        while ([rs next]) {
            // …
        }
    }];
}
/*
 线程安全操作数据库
 */
- (void)safetyDatabase{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dataBasePath];
    [queue inDatabase:^(FMDatabase * _Nonnull db) {
        [db executeUpdate:@""];
        [db executeUpdate:@"INSERT INTO t_student(name) VALUES(?)",@"Jack"];
        FMResultSet *rs = [db executeQuery:@"select * from t_student"];
        while ([rs next]) {
            
        }
    }];
}
/*
 查询数据
 */
- (void)queryData{
    if ([self.db open]) {
        //返回数据库第一条满足条件的结果
        NSString *sql = @"SELECT * FROM t_student";
        //返回全部查询的结果
        FMResultSet *resultSet = [self.db executeQuery:sql];
        while ([resultSet next]) {
            int idNum = [resultSet intForColumn:@"id"];
            NSString *name = [resultSet objectForColumn:@"name"];
            int age = [resultSet intForColumn:@"age"];
            NSLog(@"id= %i,name=%@,age=%i",idNum,name,age);
        }
        [resultSet close];
        [self.db close];
    }
}
/*
 修改数据
 */
- (void)updateData:(NSString *)name{
    if ([self.db open]) {
        NSString *sql = @"UPDATE t_student SET name = ?";
        BOOL res = [self.db executeUpdate:sql,name];
        if (!res) {
            NSLog(@"修改数据失败");
        }else{
            NSLog(@"修改数据成功");
        }
        [self.db close];
    }
}
/*
 删除数据
 */
- (void)delData:(NSString *)name{
    if ([self.db open]) {
        NSString *sql = @"DELETE FROM t_student WHERE name = ?";
        BOOL res = [self.db executeUpdate:sql,name];
        if (!res) {
            NSLog(@"删除数据失败");
        }else{
            NSLog(@"删除数据成功");
        }
        [self.db close];
    }
}
/*
 添加数据
 */
- (void)addData:(NSString *)name withAge:(int)age{
    if ([self.db open]) {
        NSString *sql = @"INSERT INTO t_student(name,age) VALUES(?,?);";
        BOOL res = [self.db executeUpdate:sql,name,@(age)];
        if (!res) {
            NSLog(@"添加数据失败");
        }else{
            NSLog(@"添加数据成功");
        }
        [self.db close];
    }
}
-(void)createTable{
    
}
- (void)dataBase{
    //创建数据库
    FMDatabase *db = [FMDatabase databaseWithPath:dataBasePath];
    //打开数据库
    [db open];
    //关闭数据库
    [db close];
    //创建表
    if ([db open]) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS t_student(id integer PRIMARY KEY AUTOINCREMENT,name text NOT NULL,age integer NOT NULL)";
        BOOL res = [db executeStatements:sqlCreateTable];
        if (!res) {
            NSLog(@"建表失败");
        }else{
            NSLog(@"建表成功");
        }
        [db close];
    }
}
- (instancetype)init{
    if (self = [super init]) {
     //数据库操作
        [self dataBase];
    }
    return self;
}

@end
