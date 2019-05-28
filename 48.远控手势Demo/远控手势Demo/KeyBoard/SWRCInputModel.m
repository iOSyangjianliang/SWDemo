//
//  SWRCInputModel.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCInputModel.h"



@implementation SWRCKeySignalModel
- (instancetype)initWithState:(uint64_t)state value:(uint64_t)value
{
    self = [super init];
    if (self) {
        self.state = state;
        self.value = value;
    }
    return self;
}
@end


@implementation SWRCInputModel

@end
