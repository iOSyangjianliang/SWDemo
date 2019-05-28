//
//  SWRCInputDataSource.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SWRCInputModel.h"

NS_ASSUME_NONNULL_BEGIN

//键盘类型
typedef NS_ENUM(NSInteger , SWRCInputViewType){
    

    SWRCInputViewType_Win      = 0,
    
    SWRCInputViewType_Ctrl     = 1,
    
    SWRCInputViewType_Alt      = 2,
    
    SWRCInputViewType_Del      = 3,
    
    SWRCInputViewType_More     = 4,
    
    SWRCInputViewType_Default  = 5,

};


@interface SWRCInputDataSource : NSObject

- (NSArray<SWRCInputModel *> *)getDataWithInputType:(SWRCInputViewType)inputType;

@end

NS_ASSUME_NONNULL_END
