//
//  RRLocalDB.m
//  RuoRouNotes
//
//  Created by 杨建亮 on 2019/5/28.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "RRLocalDB.h"

#import <FMDB.h>

#define LocalDBPath [NSHomeDirectory() stringByAppendingString:@"/Documents/RRLocalDB"]

static NSString *const T_translation = @"T_translation";
static NSString *const T_translationDelete = @"T_translationDelete";
@interface RRLocalDB ()
{
    FMDatabase *_dataBase;//目前不支持多线程，需要时用FMDatabaseQueue
    

}
@property (nonatomic, strong) FMDatabaseQueue *queue;//_queue源码中发现其就是一个同步串行队列。

@end

@implementation RRLocalDB
+(RRLocalDB *)shareLocalDB
{
    static dispatch_once_t once;
    static RRLocalDB *mInstance;
    dispatch_once(&once, ^{
        mInstance = [[RRLocalDB alloc] init];
//        [mInstance creatDBTable];

    });
    return mInstance;
}
- (instancetype)init
{
    if (self = [super init]) {
//        [self creatDBTable];

    }
    return self;
}
#pragma mark - 创建表
-(void)creatDBTable
{
    //创建文件夹
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:LocalDBPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    //创建数据库
    NSString *dbPath = [LocalDBPath stringByAppendingPathComponent:@"WYTranslation.db"];
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSLog(@"%@",LocalDBPath);
    
    [_dataBase open];
    //创建数据表，一张实际展示、一张存储删除数据（删除暂不真删除,将来可能要数据恢复，因为翻译内容不上传公司服务器,删了就没了）
    NSString * T_translationSql = @"CREATE TABLE IF NOT EXISTS T_translation(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,languageType INTEGER,chinese TEXT,english TEXT,TranslationFailure TEXT,time TEXT)";
    if ([_dataBase executeUpdate:T_translationSql]){
        NSLog(@"T_translation success");
    }
    NSString * T_translationDeleteSql = @"CREATE TABLE IF NOT EXISTS T_translationDelete(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,languageType INTEGER,chinese TEXT,english TEXT,TranslationFailure TEXT,time TEXT)";
    if ([_dataBase executeUpdate:T_translationDeleteSql]) {
        NSLog(@"T_translationDelete success");
    }
    [_dataBase close];
}
/*
#pragma mark - 插入数据
-(long)insertDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        // 插入数据-如果使用问号占位符, 以后只能给占位符传递对象
        BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translation(languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?)",[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
        if (insertOK) {
            NSLog(@"MSCTranslationModel insert Success");
            
            long insertID = [_dataBase lastInsertRowId];//插入id
            [_dataBase close];
            return insertID;
        }else{
            NSLog(@"MSCTranslationModel insert Fail");
        }
        [_dataBase close];
    }
    return model.iid;
}
#pragma mark - 修改数据
-(void)updateDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        BOOL updateOK = [_dataBase executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET chinese = ? , english = ? , TranslationFailure = ? where ID = ? limit 1",T_translation],model.chinese,model.english,model.TranslationFailure,[NSNumber numberWithInt:model.iid]];
        if (updateOK) {
            NSLog(@"MSCTranslationModel updateData Success");
        }else{
            NSLog(@"MSCTranslationModel updateData Fail");
        }
        
        [_dataBase close];
    }
}
#pragma mark - 删除数据，同时将数据插入删除数据表
-(void)deleteDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        NSString *delSQL = [NSString stringWithFormat:@"delete  from T_translation where ID = %d",model.iid];
        if ([_dataBase executeUpdate:delSQL]) {
            NSLog(@"MSCTranslationModel delete Success");
        }else{
            NSLog(@"MSCTranslationModel delete Fail");
        }
        
        //数据迁入删除表(暂时不管删除数据，存着后续数据恢复等)
        BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translationDelete(ID, languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?,?)",@(model.iid),[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
        if (insertOK) {
            NSLog(@"MSCTranslationModel Copy insert Success");
        }else{
            NSLog(@"MSCTranslationModel Copy insert Fail");
        }
        [_dataBase close];
    }
}
 
#pragma mark - 获取所有数据
-(NSArray<__kindof MSCTranslationModel *> *)queryAllData
{
    if ([_dataBase open]) {
        
        NSString *selSql = [NSString stringWithFormat:@"select * from T_translation"];
        NSMutableArray* arrayM = [NSMutableArray array];
        FMResultSet *set = [_dataBase executeQuery:selSql];
        if (set != nil) {
            NSLog(@"T_translation query Success");
            while ([set next]) {
                MSCTranslationModel *model = [[MSCTranslationModel alloc] initWithSet:set];
                [arrayM addObject:model];
            }
            [set close];
            [_dataBase close];
            return arrayM;
        }
    }
    [_dataBase close];
    return [NSArray array];
}
 
// 将删除的数据恢复
-(void)testRestoreData
{
    if ([_dataBase open]) {
        
        NSString *selSql = [NSString stringWithFormat:@"select * from T_translationDelete "];
        FMResultSet *set = [_dataBase executeQuery:selSql];
        if (set != nil) {
            NSLog(@"T_translationDelete query Success");
            while ([set next]) {
                MSCTranslationModel *model = [[MSCTranslationModel alloc] initWithSet:set];
                //存在更新、不存在插入，这只是测试用
                BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translation(ID,languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?,?)",@(model.iid),[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
                NSLog(@"%d",insertOK);
                
            }
            [set close];
        }
    }
    [_dataBase close];
}
 */




// 懒加载-数据库队列(如果不存在则自动创建数据库)
- (FMDatabaseQueue *)queue {
    if (!_queue) {
        //1.沙盒下创建文件夹
        NSFileManager* fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:LocalDBPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        //2.创建数据库
        NSString *dbPath = [LocalDBPath stringByAppendingPathComponent:@"RRLocalDB.sqlite"];
        _queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        NSLog(@"===数据库地址====:%@",LocalDBPath);
    }
    return _queue;
}
//注：inDatabase 时FMdatabaseQueue已经将打开和关闭数据库封装好了。所以在操作数据库时候不需要单独调用FMDatabase的open与close方法
//直接主线程查找表某个字段是否存在
-(BOOL)columnExists:(NSString *)columnName inTableWithName:(NSString *)tableName
{
    if ([[NSThread currentThread] isMainThread])
    {//主线程执行
        __block BOOL resultSQL = NO;
        [self.queue inDatabase:^(FMDatabase *db) {
            resultSQL = [db columnExists:columnName inTableWithName:tableName];
        }];
        return resultSQL;
    }
    NSLog(@"MainThread must");
    return NO;
    
}
//在主线程执行单条SQL（一般用于新增表、删除表、更新表）
-(BOOL)mainQueuePerformTableWithSQL:(NSString *)sql
{
    if ([[NSThread currentThread] isMainThread])
    {//主线程执行
        __block BOOL resultSQL = NO;
        [self.queue inDatabase:^(FMDatabase *db) {
            resultSQL = [db executeUpdate:sql withArgumentsInArray:nil];
        }];
        return resultSQL;
    }
    NSLog(@"MainThread must");
    return NO;
}
//子线程执行单条SQL（新增表、删除表、更新表）
-(void)asyncPerformTableWithSQL:(NSString *)sql complete:(DBCompleteBlock)complete
{
    //创建子线程执行SQL
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block BOOL resultSQL = NO;
        [self.queue inDatabase:^(FMDatabase *db) {
            resultSQL = [db executeUpdate:sql withArgumentsInArray:nil];
        }];
        //回到主线程回调执行结果
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(resultSQL);
        });
    });
}

-(void)asyncQueryTableWithSQL:(NSString *)sql queryComplete:(DBQueryCompleteBlock)queryComplete
{
    //创建子线程执行SQL
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        __block NSMutableArray *arrayM;
        [self.queue inDatabase:^(FMDatabase *db) {
            arrayM = [NSMutableArray array];

            FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
            
            while (resultSet.next) {
//                NSString *name = [resultSet stringForColumn:@"name"];
//                int age = [resultSet intForColumn:@"age"];
//                double height = [resultSet doubleForColumn:@"height"];
//                NSLog(@"%@, %i, %lf", name, age, height);
                
//                RRUserInfo *model = [[RRUserInfo alloc] initWithSet:];
                [arrayM addObject:resultSet];
            }
        }];
        //回到主线程回调执行结果
        dispatch_async(dispatch_get_main_queue(), ^{
            queryComplete(arrayM);
        });
    });
}




// 查询所有数据
- (void)queryAll {
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"select * from T_human";
        
        FMResultSet *resultSet = [db executeQuery:sql withArgumentsInArray:nil];
        
        while (resultSet.next) {
            NSString *name = [resultSet stringForColumn:@"name"];
            int age = [resultSet intForColumn:@"age"];
            double height = [resultSet doubleForColumn:@"height"];
            
            NSLog(@"%@, %i, %lf", name, age, height);
        }
    }];
}

// 执行多条语句
- (void)excuteStaments {
    
    NSString *sql = @"insert into T_human(name, age, height) values('wangwu', 15, 170);insert into T_human(name, age, height) values('zhaoliu', 13, 160);";
    
    [self.queue inDatabase:^(FMDatabase *db) {
        BOOL result = [db executeStatements:sql];
        if (result) {
            NSLog(@"执行多条语句成功");
        } else {
            NSLog(@"执行多条语句失败");
        }
    }];
}

// 开启事务执行语句
- (void)transaction {
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sql = @"insert into T_human(name, age, height) values('wangwu', 15, 170);insert into T_human(name, age, height) values('zhaoliu', 13, 160);";
        NSString *sql2 = @"insert into T_human(name, age, height) values('zhaoliu', 13, 160);insert into T_human(name, age, height) values('wangwu', 15, 170);";
        
        BOOL result1 = [db executeUpdate:sql withArgumentsInArray:nil];
        BOOL result2 = [db executeUpdate:sql2 withArgumentsInArray:nil];
        
        if (result1 && result2) {
            NSLog(@"执行成功");
        } else {
            [db rollback];
        }
    }];
}

-(BOOL)selfTest:(NSString *)sql
{
    
    __block BOOL isSuccess = NO;
    
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        
        @try {
            CFTimeInterval start=  CFAbsoluteTimeGetCurrent();
            for (int i= 0  ; i< 5000; i++) {
            
                [db executeUpdate:sql];
            }
            
            NSLog(@"时间:%f",CFAbsoluteTimeGetCurrent()-start);
        } @catch (NSException *exception) {
            
            *rollback = YES;
        } @finally {
            
            *rollback = NO;
            isSuccess = YES;
        }
        
    }];
    
    return isSuccess;
}
//异步+事务
-(void)selfTestAAAAA:(NSString *)sql
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
            
            
            @try {
                CFTimeInterval start=  CFAbsoluteTimeGetCurrent();
                for (int i= 0  ; i< 6000; i++) {
                    
                    [db executeUpdate:sql];
                }
                
                NSLog(@"1时间:%.1f",(CFAbsoluteTimeGetCurrent()-start)*1000);
            } @catch (NSException *exception) {
                
                NSLog(@"1触发了回滚");
                *rollback = YES;
            } @finally {
                
                *rollback = NO;
            }
            
        }];
    });
}

@end
