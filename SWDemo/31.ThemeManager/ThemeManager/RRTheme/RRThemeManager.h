//
//  RRThemeManager.h
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// 主题切换通知
FOUNDATION_EXPORT NSString *const RRThemeChangedNotification;



NS_ASSUME_NONNULL_BEGIN

@interface RRThemeManager : NSObject

+ (instancetype)sharedInstance;
@property (nonatomic, assign, readonly) NSString *themeName;  ///< 当前主题名称



/// 改变主题
- (BOOL)changeTheme:(NSString *)themeName;
/// 获取颜色
//+ (UIColor *)colorWithID:(NSString *)colorID;
/// 获取图片
+ (UIImage *)imageWithName:(NSString *)imageName;
/// 获取颜色值
//+ (NSString *)colorStringWithID:(NSString *)colorID;

@end

NS_ASSUME_NONNULL_END
