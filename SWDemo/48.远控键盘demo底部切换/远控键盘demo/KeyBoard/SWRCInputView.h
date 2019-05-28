//
//  SWRCInputView.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRCInputDataSource.h"

#import "UIColor+JLHex.h"

NS_ASSUME_NONNULL_BEGIN

@class SWRCInputView;
@protocol SWRCInputViewDelegate <NSObject>
@optional
- (BOOL)sw_SWRCInputView:(SWRCInputView*)view shouldSelected:(UIButton *)sender;
- (void)sw_SWRCInputView:(SWRCInputView*)view didSelected:(UIButton *)sender;
@end

@interface SWRCInputView : UIView
//指定初始化方式
- (instancetype)initWithInputType:(SWRCInputViewType)inputType dataSource:(SWRCInputDataSource *)dataSource;
//暂不可动态切换(修改自身高度后、键盘刷新没法更改高度)
@property(nonatomic, assign, readonly) SWRCInputViewType inputType;
@property(nonatomic, weak, readonly) SWRCInputDataSource *dataSource;

@end

NS_ASSUME_NONNULL_END
