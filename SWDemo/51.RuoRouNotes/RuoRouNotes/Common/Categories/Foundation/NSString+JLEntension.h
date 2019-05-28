//
//  NSString+JLEntension.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/11.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JLEntension)

/**
 判断字符串是否为NULL，nil,字符串空
 
 @param string string description
 @return return value description
 */
+ (BOOL)jl_IsBlankString:(nullable NSString *)string;

/**
 过滤json字符串的转义字符；
 
 @param str json原字符串
 @return 过滤后的json字符串
 */
+ (NSString *)jl_FilterEscapeCharacterWithJsonString:(NSString *)str;

/**
 根据jsonSerialization方法把json格式（NSArray／NSDictionary）对象转换为字符串

 @param responseObject json对象
 @return 转换后的json字符串
 */
+ (nullable NSString *)jl_GetJSONSerializationStringFromObject:(nullable id)responseObject;


/**
 根据jsonSerialization方法把json字符串转换为json格式（NSArray／NSDictionary）对象

 @param string json字符串
 @return json对象（NSArray／NSDictionary）
 */
+ (nullable id)jl_GetJSONSerializationObjectFormString:(nullable NSString *)string;

/**
 *  @brief 过滤输入的字符串2端的空格和换行符
 *
 *  @param str  原字符串
 *
 *  @return 过滤2端的空格和换行符后的字符串
 */
+ (NSString *)jl_FilterInputTextWithWittespaceAndLine:(NSString *)str;


/**
 *  @brief 判断string是否是整数/即是否是纯数字
 *
 *  @param  string  原字符串
 *
 *  @return  YES／NO @"您的密码过于简单，请使用数字+字母的组合"
 */
+ (BOOL)jl_IsIntScan:(nullable NSString *)string;

/**
 *  @brief 判断string是否是纯字母
 *
 *  @param  string  原字符串
 *
 *  @return  YES／NO @"您的密码过于简单，请使用数字+字母的组合"
 */
+ (BOOL)jl_IsABCScan:(nullable NSString *)string;

#pragma mark - 字符串的邮箱／手机号／URL／密码等验证
#pragma mark-(只能多排除一些错误可能性,不能全部排除)
/**
 *    @brief    通过区分字符串 验证 邮箱的合法性;
 *    @param  email  邮箱;
 *    @return    YES／NO
 */
+ (BOOL)jl_validateEmail:(nullable NSString *)email;


/**
 *    @brief    利用正则表达式验证 邮箱的合法性
 *    @param  email    邮箱
 *    @return    YES／NO
 */
+ (BOOL)jl_validateEmail2:(nullable NSString *)email;


/**
 *    @brief    利用正则表达式验证 手机号合法性、目前改成简单匹配1开头11位了
 *    @param  phone    手机号字符串
 *    @return    YES／NO
 */

+ (BOOL)jl_validatePhoneNumber:(nullable NSString *)phone;


//验证url网址，链接是否正常
+ (BOOL)jl_validateURL:(NSString *)url;

//MD5加密
+ (NSString *)jl_CreatedMD5String:(NSString *)key;

//检查密码复杂度并返回相应描述文案====顺网规则===
+ (nullable NSString *)jl_TextFieldPassword:(NSString *)str;


@end

NS_ASSUME_NONNULL_END
