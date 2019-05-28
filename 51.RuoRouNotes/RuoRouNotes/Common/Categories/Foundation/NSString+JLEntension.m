//
//  NSString+JLEntension.m
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/11.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import "NSString+JLEntension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (JLEntension)
//json对象转json字符串
+ (NSString *)jl_GetJSONSerializationStringFromObject:(nullable id)responseObject
{
    if ([NSJSONSerialization isValidJSONObject:responseObject])
    {
        NSError *error = nil;
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&error];
        if (error==nil && data!=nil)
        {
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *escapeString = [NSString jl_FilterEscapeCharacterWithJsonString:str];
            return escapeString;
        }
    }
    return nil;
}
//过滤转义字符
+ (NSString *)jl_FilterEscapeCharacterWithJsonString:(NSString *)str
{
    NSMutableString *responseString = [NSMutableString stringWithString:str];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}
//json字符串转json对象
+ (nullable id)jl_GetJSONSerializationObjectFormString:(nullable NSString *)string
{
    if ([NSString jl_IsBlankString:string])
    {
        return nil;
    }
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSString jl_GetJSONSerializationObjectByJsonData:data];
}

+ (nullable id)jl_GetJSONSerializationObjectByJsonData:(nullable NSData *)data
{
    NSError *error=nil;
    id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    if (error==nil && data!=nil)
    {
        return dic;
    }
    return nil;
}
+ (BOOL)jl_IsBlankString:(nullable NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
+ (NSString *)jl_FilterInputTextWithWittespaceAndLine:(NSString *)str
{
    NSCharacterSet *whitespaceLine = [NSCharacterSet  whitespaceAndNewlineCharacterSet];
    NSRange spaceRange = [str rangeOfCharacterFromSet:whitespaceLine];
    if (spaceRange.location != NSNotFound)
    {
        str = [str stringByTrimmingCharactersInSet:whitespaceLine];
    }
    
    return str;
}
+(BOOL)jl_IsIntScan:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}
+ (NSString *)jl_CreatedMD5String:(NSString *)key
{
    const char *str = [key UTF8String];//转换成utf-8
    unsigned char result[CC_MD5_DIGEST_LENGTH];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5(str,  (CC_LONG)strlen(str), result);
    NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    for (int i =0; i<CC_MD5_DIGEST_LENGTH; i++)
    {
        [hash appendFormat:@"%02X",result[i]];// x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
    }
    return [hash lowercaseString];
}
#pragma mark - 字符串的邮箱／手机号／URL／密码等验证

+ (BOOL)jl_validateEmail:(nullable NSString *)email
{
    if ([email rangeOfString:@"@"].length != 0 && [email rangeOfString:@"."].length !=0)
    {
        NSCharacterSet *tmpInvalidCharSet = [[NSCharacterSet alphanumericCharacterSet] invertedSet];
        NSMutableCharacterSet *tmpInvalidMutableCharSet = [tmpInvalidCharSet mutableCopy];
        [tmpInvalidMutableCharSet removeCharactersInString:@"_-"];
        NSRange  range1 = [email rangeOfString:@"@" options:NSCaseInsensitiveSearch];
        //取得用户名部分
        NSString *userNameString = [email substringToIndex:range1.location];
        NSArray *userNameArray = [userNameString componentsSeparatedByString:@"."];
        for(NSString *str in userNameArray)
        {
            NSRange rangeOfInavlidChars = [str rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if (rangeOfInavlidChars.length !=0 || [str isEqualToString:@""])
            {
                return NO;
            }
        }
        
        //取得域名部分
        NSString *domainString = [email substringFromIndex:range1.location+1];
        NSArray *domainArray = [domainString componentsSeparatedByString:@"."];
        for(NSString *string in domainArray)
        {
            NSRange rangeOfInavlidChars = [string rangeOfCharacterFromSet:tmpInvalidMutableCharSet];
            if (rangeOfInavlidChars.length !=0 || [string isEqualToString:@""])
            {
                return NO;
            }
        }
        return YES;
    }
    else
    {
        return NO;
    }
}


+ (BOOL)jl_validateEmail2:(nullable NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


+ (BOOL)jl_validatePhoneNumber:(nullable NSString *)phone
{
    NSString *XXX =@"^[1][0-9]{10}$";
    NSPredicate *example = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", XXX];
    BOOL isOK = [example evaluateWithObject:phone];
    return isOK;
    
//    //为啥下面eg最新号码 19979078202不可以？？？
//    /**
//     * 移动号段正则表达式
//     */
//    NSString *CM_NUM =@"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))//d{8}|(1705)//d{7}$";
//    /**
//     * 联通号段正则表达式
//     */
//    NSString *CU_NUM =@"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))//d{8}|(1709)//d{7}$";
//    /**
//     * 电信号段正则表达式
//     */
//    NSString *CT_NUM =@"^((133)|(153)|(177)|(18[0,1,9]))//d{8}$";
//    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//    BOOL isMatch1 = [pred1 evaluateWithObject:phone];
//    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//    BOOL isMatch2 = [pred2 evaluateWithObject:phone];
//    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//    BOOL isMatch3 = [pred3 evaluateWithObject:phone];
//    
//    if (isMatch1 || isMatch2 || isMatch3 ) {
//        return YES;
//    }else{
//        return NO;
//    }
}
+(BOOL)jl_IsABCScan:(NSString *)string
{
    NSString *number = @"^[A-Za-z]+$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:string];
}
+ (BOOL)jl_validateURL:(NSString *)url
{
    NSError *error;
    // 正则1
    NSString *regulaStr =@"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    
    //    // 正则2
    //    regulaStr =@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:url options:0 range:NSMakeRange(0,[url length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [url substringWithRange:match.range];
        NSLog(@"匹配:%@",substringForMatch);
        return YES;
    }
    
    return NO;
}

+ (nullable NSString *)jl_TextFieldPassword:(NSString *)str
{
    NSString *password = [NSString jl_FilterInputTextWithWittespaceAndLine:str];
    NSString *reTitle = nil;
   
    if (password.length==0)
    {
        reTitle= NSLocalizedString(@"密码不能为空", nil) ;
        return reTitle;
    }
//    else if (password.length<6 )
//    {
//        reTitle= NSLocalizedString(@"密码长度过短", nil);
//        return reTitle;
//    }
//    else if (password.length>16)
//    {
//        reTitle= NSLocalizedString(@"密码长度过长", nil);
//        return reTitle;
//    }
    
    if ([NSString jl_IsPassword6_16:password])
    {
        if ([NSString jl_IsIntScan:password] || [NSString jl_IsABCScan:password])
        {
            reTitle= NSLocalizedString(@"密码为6-16位包含英文和数字", nil);
        }
    }else
    {
        reTitle= NSLocalizedString(@"密码为6-16位包含英文和数字", nil);
    }
    // do sth
    return reTitle;
    
}
+(BOOL)jl_IsPassword6_16:(NSString *)string
{
    NSString *number = @"^[a-zA-Z0-9]{6,16}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [emailTest evaluateWithObject:string];
}

@end
