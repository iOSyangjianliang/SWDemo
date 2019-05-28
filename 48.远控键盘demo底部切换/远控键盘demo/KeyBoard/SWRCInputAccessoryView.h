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

@interface SWRCInputAccessoryView : UIView
@property (nonatomic, weak) UITextField *sw_textField;
@property (nonatomic, weak) SWRCInputView *inputView;
@property (nonatomic, strong) SWRCInputDataSource *inputDataSource;

@end

NS_ASSUME_NONNULL_END
