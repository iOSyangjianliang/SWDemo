//
//  UIColor+JLHex.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/11.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)



@interface UIColor (JLHex)
// 16进制颜色转换
+ (UIColor *)colorWithHexString:(NSString *)hexString;

// 从十六进制字符串获取颜色，
// color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

// 获取随机颜色
+ (UIColor *)colorWithRandomColor;


@end

NS_ASSUME_NONNULL_END
