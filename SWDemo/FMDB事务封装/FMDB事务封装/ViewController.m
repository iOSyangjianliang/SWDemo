//
//  ViewController.m
//  FMDB事务封装
//
//  Created by 杨建亮 on 2019/5/28.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    RRLocalDB *db = [RRLocalDB shareLocalDB];
    NSString * T_translationSql = @"CREATE TABLE IF NOT EXISTS T_translation(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,languageType INTEGER,chinese TEXT,english TEXT,TranslationFailure TEXT,time TEXT)";
    
    BOOL bo = [db mainQueuePerformTableWithSQL:T_translationSql];
    NSLog(@"%d",bo);
    
    //    [db asyncPerformTableWithSQL:T_translationSql complete:^(BOOL success) {
    //            NSLog(@"success=%d",success);
    //    }];
    //    NSLog(@"是不是异步，若早于success先打印则yes");
    
    //   BOOL boo =  [db columnExists:@"chinese" inTableWithName:@"T_translation"];
    //        NSLog(@"boo=%d",boo);
    
    
    [SWRCATool begainAnalyzeTime:@"1"];
    for (int i=0; i<5000; i++) {
        NSString *sql = @"insert into T_translation(languageType, chinese, english,TranslationFailure,time) values(15,'中文', '英文','nowenti', '20190528');";
        //        BOOL bo = [db mainQueuePerformTableWithSQL:sql];//5000:5000ms 60000:70s
        //        if (!bo) {
        //            NSLog(@"插入失败%d",i);
        //        }
        
        [db asyncPerformTableWithSQL:sql complete:^(BOOL success) {//5000:100ms 60000:25s
            if (!success) {
                NSLog(@"插入失败");
            }
        }];
        
    }
    [SWRCATool endAnalyzeTime:@"1"];
    
    
    //    NSString *sql = @"insert into T_translation(languageType, chinese, english,TranslationFailure,time) values(15,'中文', '英文','nowenti', '20190528');";
    
    //    [db selfTest:sql];//60000:0.3s
    
    //    [db selfTestAAAAA:sql];//5000:40ms
    
    
    return;
    
}

@end
