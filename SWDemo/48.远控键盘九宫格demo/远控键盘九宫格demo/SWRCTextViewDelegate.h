//
//  SWRCTextViewDelegate.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/4/3.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SWRCTextViewDelegate;
@protocol SWRCTextViewDelegatOutput <NSObject>
@required
- (void)sw_textViewDelegatOutputWithInsertString:(NSString *)insertString;
@end

@interface SWRCTextViewDelegate : NSObject<UITextViewDelegate>
@property(nonatomic, weak) id<SWRCTextViewDelegatOutput> outPut;

@end

NS_ASSUME_NONNULL_END
