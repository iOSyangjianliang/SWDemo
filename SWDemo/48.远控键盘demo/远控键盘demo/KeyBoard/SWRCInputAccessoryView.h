//
//  SWRCInputAccessoryView.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRCInputView.h"

#import "UIColor+JLHex.h"

NS_ASSUME_NONNULL_BEGIN

@class SWRCInputAccessoryView;
@protocol SWRCInputAccessoryViewDelegate <NSObject>
@optional
//curryHeight 当前键盘高度
- (void)sw_inputAccessoryView:(SWRCInputView*)view didHeightChanged:(CGFloat)curryHeight;
@end

@interface SWRCInputAccessoryView : UIView
//初始化
-(instancetype)initWithInputViewType:(SWRCInputViewType)inputViewType isOpen:(BOOL)isOpen;
//默认值SWRCInputViewType_Default,获取当前键盘类型
@property (nonatomic, assign, readonly) SWRCInputViewType inputViewType;

@property (nonatomic, weak, nullable) UITextView *sw_textView;
@property (nonatomic, weak, nullable) SWRCInputView *inputView;

@property(nonatomic, weak, nullable) id<SWRCInputAccessoryViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
