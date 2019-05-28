//
//  UILabel+JLEntension.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/23.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (JLEntension)

/**
 富文本设置最小行高，用于多行显示
 
 @param text 要显示的字符串，传nil则以self.text显示
 @param spacing 最小行高（eg:一般为UI设计图一半）
 */
-(void)jl_setAttributedText:(nullable NSString *)text withMinimumLineHeight:(float)spacing;

//富文本设置行间距
-(void)jl_setAttributedText:(nullable NSString *)text withLineSpacing:(float)spacing;


/**
 富文本添加中划线
 
 @param text 要显示的字符串,传nil则以self.text显示
 @param color 中划线颜色
 */
-(void)jl_addMediumLineWithText:(nullable NSString*)text lineColor:(UIColor*)color;

/**
 将字符串中所有的数字颜色、字体修改
 
 @param text eg:入住商铺139478 上传产品29140124
 @param numColr numColr 数字颜色
 @param font 数字字体
 */
-(void)jl_changeStringOfNumberStyle:(nullable NSString*)text numberColor:(UIColor*)numColr numberFont:(UIFont*)font;

/**
 将字符串中指定字符串修改为指定颜色
 
 @param searchText 网吧-（预想网吧、杰拉网吧）
 @param searchColor 搜索字颜色
 */
-(void)jl_changeSearchText:(nullable NSString*)searchText searchColor:(UIColor *)searchColor ;

@end

NS_ASSUME_NONNULL_END
