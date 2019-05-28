//
//  UITextField+JLEntension.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/13.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (JLEntension)


#pragma mark - textField输入限制
/**
 限制输入textField小数点前面几位，小数点后面几位；
 
 @param textField textField
 @param range range
 @param string string
 @param dotPreBits 小数点前面最多几位
 @param dotAfterBits 小数点后面最多几位
 @return 是否允许输入；
 */
+ (BOOL)jl_limitPayMoneyDot:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
          replacementString:(NSString *)string
                 dotPreBits:(int)dotPreBits
               dotAfterBits:(int)dotAfterBits;


//利用代理方法：- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//设置textField最多输入几个文字，支持表情，支持删除键；回调剩余还有几个文字；

+ (BOOL)jl_limitRemainText:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
         replacementString:(NSString *)string
                 maxLength:(NSInteger)maxLength
             remainTextNum:(nullable void(^)(NSInteger remainLength))remainTextBlock
;




@end

NS_ASSUME_NONNULL_END
