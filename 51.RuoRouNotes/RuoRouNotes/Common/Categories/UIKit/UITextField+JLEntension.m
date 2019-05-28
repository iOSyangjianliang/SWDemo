//
//  UITextField+JLEntension.m
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/13.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import "UITextField+JLEntension.h"

@implementation UITextField (JLEntension)


#pragma mark - textField输入限制

#define myDotNumbers @"0123456789.\n"
#define myNumbers   @"0123456789\n"

+ (BOOL)jl_limitPayMoneyDot:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
          replacementString:(NSString *)string
                 dotPreBits:(int)dotPreBits
               dotAfterBits:(int)dotAfterBits

{
    //数字键盘是没有"\n"和""的
    if ([string isEqualToString:@"\n"]||[string isEqualToString:@""])
    {
        //按下return
        return YES;
    }
    
    NSCharacterSet *cs;
    NSUInteger nDotLoc = [textField.text rangeOfString:@"."].location;
    //如果之前没有“.”,且不是第一个数
    if (NSNotFound == nDotLoc && 0 != range.location)
    {
        cs = [[NSCharacterSet characterSetWithCharactersInString:myNumbers]invertedSet];
        // 如果现在是“.”，则允许；
        if ([string isEqualToString:@"."])
        {
            return YES;
        }
        else
        {
            if ([textField.text isEqualToString:@"0"])
            {
                return NO;
            }
        }
        // 如果现在不是“.”,如果之前的整数已经到了规定限制，则不允许；
        if (textField.text.length >= dotPreBits)
        {  //小数点前面6位
            // [textField resignFirstResponder];
            //            [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数前%d位", dotPreBits]];
            return NO;
        }
        
        // 其它正常的走以下流程；
    }
    //如果之前有“.”
    else
    {
        //不是0-9－.的字符集合
        cs = [[NSCharacterSet characterSetWithCharactersInString:myDotNumbers]invertedSet];
        // 如果已经到了总限制 位数 ，则不允许；
        if (textField.text.length >= dotPreBits + dotAfterBits + 1)
        {
            //            [textField resignFirstResponder];
            //            [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
            return  NO;
        }
        // 如果又是"."，则不允许输入；
        if ([string isEqualToString:@"."])
        {
            return NO;
        }
    }
    // 先分割开来，再通过“”组合； 不懂哦
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    if (!basicTest)
    {
        //        [textField resignFirstResponder];
        //        [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
        return NO;
    }
    // 如果有小数点；且位数 > 小数点位置+后面限制位数
    if (NSNotFound != nDotLoc && range.location > nDotLoc +dotAfterBits)
    {  //小数点后面两位
        //        [textField resignFirstResponder];
        //        [DCFStringUtil showNotice:[NSString stringWithFormat:@"只允许小数点后%d位", dotAfterBits]];
        return NO;
    }
    return YES;
}


+ (BOOL)jl_limitRemainText:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
         replacementString:(NSString *)string
                 maxLength:(NSInteger)maxLength
             remainTextNum:(nullable void(^)(NSInteger remainLength))remainTextBlock
{
    //如果是删除键,删除range的长度；即使选中1个以上字符删除，length也会增加；
    if ([string length] == 0 && range.length > 0)
    {
        if ([textField markedTextRange] && textField.text.length ==maxLength)
        {
            [textField replaceRange:textField.markedTextRange withText:@""];
            textField.text = textField.text;
            NSInteger remainLength = maxLength-textField.text.length;
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",remian];
            if (remainTextBlock) {
                remainTextBlock(remainLength);
            }
            return NO;
        }
        else
        {
            NSInteger remainLength = maxLength-textField.text.length+range.length;
            if (remainTextBlock) {
                remainTextBlock(remainLength);
            }
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-textField.text.length+range.length)];
        }
        return YES;
    }
    NSString *genString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    UITextRange *markedRange = [textField markedTextRange];
    
    if (genString.length >maxLength)
    {
        //没有选中文本标志
        if (!markedRange)
        {
            NSLog(@"没有正在输入的");
            //截取冥想词
            NSRange range2 = [genString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            textField.text = [genString substringToIndex:range2.location];
            NSInteger remainLength = maxLength-textField.text.length;
            if (remainTextBlock) {
                remainTextBlock(remainLength);
            }
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-textField.text.length)];
        }
        else
        {
            NSLog(@"正在输入中文");
            NSRange range2 = [genString rangeOfComposedCharacterSequenceAtIndex:maxLength];
            NSInteger remainLength = maxLength-range2.location;
            if (remainTextBlock) {

                remainTextBlock(remainLength);
            }
            //            self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-range2.location)];
        }
        return NO;
    }
    else
    {
        NSInteger remainLength =maxLength-genString.length;
        if (remainTextBlock) {

            remainTextBlock(remainLength);
        }
        //        self.reminderLab.text = [NSString stringWithFormat:@"还可以输入:%lu字符",(maxLength-genString.length)];
    }
    
    return YES;
    
}




@end
