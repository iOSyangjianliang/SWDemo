//
//  SWRCAnalyzeTool.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/3/21.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCAnalyzeTool.h"

@interface SWRCAnalyzeTool ()
@property(nonatomic, strong) NSMutableDictionary *dictM;
@end

@implementation SWRCAnalyzeTool
+ (SWRCAnalyzeTool *)standardAnalyzeTool
{
    static dispatch_once_t once;
    static SWRCAnalyzeTool *mInstance;
    dispatch_once(&once, ^{
        mInstance = [[SWRCAnalyzeTool alloc] init];
    });
    return mInstance;
}
-(instancetype)init
{
    if ([super init]) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return self;
}
-(void)begainAnalyzeTime:(NSString *)identifier
{
    [self sw_addObject:[NSDate date] forKey:identifier];
}
-(NSTimeInterval)endAnalyzeTime:(NSString *)identifier
{
    NSDate *date = (NSDate *)[self sw_objectForKey:identifier];
    NSTimeInterval timestamp = -[date timeIntervalSinceNow]*1000;
    [self sw_addObject:[NSDate date] forKey:identifier];
    NSLog(@"AnalyzeTime identifier=%@:%.2fms",identifier,timestamp);
    
    return timestamp;
}


- (void)sw_addObject:(id)object forKey:(NSString *)key
{
    if (object == nil || key == nil)
    {
        NSLog(@"object or key should not be nil.");
        return;
    }
    [_dictM setObject:object forKey:key];
}
- (id)sw_objectForKey:(NSString *)key
{
    return [_dictM objectForKey:key];
}
@end
