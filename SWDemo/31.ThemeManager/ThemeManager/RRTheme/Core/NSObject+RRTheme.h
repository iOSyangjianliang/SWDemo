//
//  NSObject+RRTheme.h
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RRThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RRTheme)

/**
 * 注册换肤监听，不会重复监听。
 * 收到通知后会调用 theme_didChanged 方法。
 */
- (void)theme_registChangedNotification;

/**
 * 子类重写，收到换肤通知会调用本方法
 */
- (void)theme_didChanged;

@end

NS_ASSUME_NONNULL_END
