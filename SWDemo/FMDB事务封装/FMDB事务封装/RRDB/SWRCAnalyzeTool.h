//
//  SWRCAnalyzeTool.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/3/21.
//  Copyright © 2019年 shunwang. All rights reserved.
//
//用于：远控各种参数分析调试

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

#define SWRCATool [SWRCAnalyzeTool standardAnalyzeTool]

//static BOOL constRCAnalyzeControl = YES;
@interface SWRCAnalyzeTool : NSObject
+ (SWRCAnalyzeTool *)standardAnalyzeTool;

//打印代码块执行耗时、单位毫秒
-(void)begainAnalyzeTime:(NSString *)identifier;
-(NSTimeInterval)endAnalyzeTime:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
