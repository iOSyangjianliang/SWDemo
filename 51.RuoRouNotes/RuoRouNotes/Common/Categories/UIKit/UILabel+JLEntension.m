//
//  UILabel+JLEntension.m
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/23.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import "UILabel+JLEntension.h"

@implementation UILabel (JLEntension)
-(void)jl_changeStringOfNumberStyle:(NSString *)text numberColor:(UIColor *)numColr numberFont:(UIFont *)font
{
    NSString* str = [self getCurrydisplayText:text];
    if (str) {
      
        NSScanner *scanner = [NSScanner scannerWithString:str];
        [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
        int number;
        [scanner scanInt:&number];
        NSInteger local = 0;
        NSString* strnum = [NSString stringWithFormat:@"%d",number];
        NSRange range_num = [str rangeOfString:strnum];
        
        NSMutableString* strCopy = [NSMutableString stringWithString:str];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        while (range_num.location != NSNotFound) {
            NSRange range = NSMakeRange(range_num.location+local, range_num.length);
            [attributedString addAttribute:NSForegroundColorAttributeName value:numColr range:range];
            [attributedString addAttribute:NSFontAttributeName value:font range:range];
            
            local = range_num.length;
            [strCopy deleteCharactersInRange:range_num];
            
            NSScanner *scanner = [NSScanner scannerWithString:strCopy];
            [scanner scanUpToCharactersFromSet:[NSCharacterSet decimalDigitCharacterSet] intoString:nil];
            int number;
            [scanner scanInt:&number];
            
            NSString* strnum = [NSString stringWithFormat:@"%d",number];
            range_num = [strCopy rangeOfString:strnum];
        }
        self.attributedText = attributedString;
    }
}
-(void)jl_addMediumLineWithText:(NSString*)text lineColor:(UIColor*)color
{
    NSString* str = [self getCurrydisplayText:text];
    if (str) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString setAttributes:@{NSBaselineOffsetAttributeName : @(NSUnderlineStyleSingle)} range:NSMakeRange(0,str.length)]; //不加这个中文ios10就会出bug出不来中划线
        
        [attributedString addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid|NSUnderlineStyleSingle) range:NSMakeRange(0, str.length)];
        [attributedString addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, str.length)];
        
        self.attributedText = attributedString;
    }
    
}
-(void)jl_setAttributedText:(NSString *)text withMinimumLineHeight:(float)spacing
{
    NSString* str = [self getCurrydisplayText:text];
    if (str) {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setMinimumLineHeight:spacing];
        
        paragraphStyle1.lineBreakMode = self.lineBreakMode;
        paragraphStyle1.alignment = self.textAlignment;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        self.attributedText = attributedString;
    }
}
-(void)jl_setAttributedText:(NSString *)text withLineSpacing:(float)spacing
{
    NSString* str = [self getCurrydisplayText:text];
    if (str) {
        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle1 setLineSpacing:spacing];
        
        paragraphStyle1.lineBreakMode = self.lineBreakMode;
        paragraphStyle1.alignment = self.textAlignment;
        
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [str length])];
        self.attributedText = attributedString;
    }
}
- (nullable NSString *)getCurrydisplayText:(NSString *)text
{
    NSString* str = nil;
    if (text) {
        str = [NSString stringWithString:text];
    }else{
        if (self.text) {
            str = [NSString stringWithString:self.text];
        }else{
            return nil;;
        }
    }
    return str;
}


-(void)jl_changeSearchText:(nullable NSString*)searchText searchColor:(UIColor *)searchColor
{
    if (self.text && searchText) {
        NSRange range = [self.text rangeOfString:searchText];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSMutableString* strCopy = [NSMutableString stringWithString:self.text];

        NSInteger local = 0;
        while (range.location != NSNotFound) {
            NSRange reRange = NSMakeRange(range.location+local, range.length);
            [attributedString addAttribute:NSForegroundColorAttributeName value:searchColor range:reRange];
            
            local += range.length;
            [strCopy deleteCharactersInRange:range];
            range = [strCopy rangeOfString:searchText];
        }
        self.attributedText = attributedString;
    }
}
@end
