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


//获取屏幕 宽度、高度
#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef LCDH
#define LCDH ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(LCDW, LCDH))
#define SCREEN_MIN_LENGTH (MIN(LCDW, LCDH))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iphone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
//iphone5,6 一样，plus、X系列放大，用于间距，字体大小，文本控件高度；
//宏定义的变量数字一定要加()才能准、CGFloat right = (LCDScale_5Equal6_To6plus(-93.f))-15.f
#define LCDScale_5Equal6_To6plus(X) ((SCREEN_MIN_LENGTH>(375.f)) ? ((X)*SCREEN_MIN_LENGTH/375) : (X))


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
