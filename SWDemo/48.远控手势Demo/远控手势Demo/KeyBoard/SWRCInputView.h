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
//- (BOOL)sw_inputView:(SWRCInputView*)view shouldSelected:(SWRCInputModel *)model;
- (void)sw_inputView:(SWRCInputView*)view didSelected:(SWRCInputModel *)model;
@end

@interface SWRCInputView : UIView
//指定初始化方式
- (instancetype)initWithInputType:(SWRCInputViewType)inputType dataSource:(SWRCInputDataSource *)dataSource isDirV:(BOOL)isDirV;
//暂不可动态切换(修改自身高度后、键盘刷新没法更改高度)
@property(nonatomic, assign, readonly) SWRCInputViewType inputType;

@property(nonatomic, weak, readonly) SWRCInputDataSource *dataSource;

@property(nonatomic, weak, nullable) id<SWRCInputViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
