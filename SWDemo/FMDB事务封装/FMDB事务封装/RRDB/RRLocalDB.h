//
//  RRLocalDB.h
//  RuoRouNotes
//
//  Created by 杨建亮 on 2019/5/28.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DBCompleteBlock)(BOOL success);

typedef void (^DBQueryCompleteBlock)(NSArray *dataArr);

typedef void (^SuccessBlock)(id _Nullable  data);


typedef void (^FaileBlock)(NSError * _Nonnull error);


@interface RRLocalDB : NSObject
+(RRLocalDB *)shareLocalDB;

//-(long)insertDataWithModel:(MSCTranslationModel *)model;
//-(void)updateDataWithModel:(MSCTranslationModel *)model;
//-(void)deleteDataWithModel:(MSCTranslationModel *)model;
//-(NSArray<__kindof MSCTranslationModel *> *)queryAllData;


-(BOOL)mainQueuePerformTableWithSQL:(NSString *)sql;
-(void)asyncPerformTableWithSQL:(NSString *)sql complete:(DBCompleteBlock)complete;


-(BOOL)columnExists:(NSString *)columnName inTableWithName:(NSString *)tableName;


-(BOOL)selfTest:(NSString *)sql;

-(void)selfTestAAAAA:(NSString *)sql;




//[SWRCATool begainAnalyzeTime:@"1"];
//for (int i=0; i<5000; i++) {
//    NSString *sql = @"insert into T_translation(languageType, chinese, english,TranslationFailure,time) values(15,'中文', '英文','nowenti', '20190528');";
//    //        BOOL bo = [db mainQueuePerformTableWithSQL:sql];//5000ms
//    //        if (!bo) {
//    //            NSLog(@"插入失败%d",i);
//    //        }
//
//    [db asyncPerformTableWithSQL:sql complete:^(BOOL success) {//100ms
//        //            if (!success) {
//        //                NSLog(@"插入失败");
//        //            }
//    }];
//
//}
//[SWRCATool endAnalyzeTime:@"1"];

//50ms
@end

NS_ASSUME_NONNULL_END
