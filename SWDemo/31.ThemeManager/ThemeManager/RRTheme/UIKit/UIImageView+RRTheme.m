//
//  UIImageView+RRTheme.m
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "UIImageView+RRTheme.h"

#import <objc/runtime.h>


@implementation UIImageView (RRTheme)

- (void)theme_didChanged {
    [super theme_didChanged];
    if (self.theme_image) {
        self.image = [RRThemeManager imageWithName:self.theme_image];
    }
}

// MARK: - ================ Setters ===========================
- (void)setTheme_image:(NSString *)image {
    self.image = [RRThemeManager imageWithName:image];
    objc_setAssociatedObject(self, @selector(theme_image), image, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self theme_registChangedNotification];
}

// MARK: - ================ Getters ===========================

- (NSString *)theme_image {
    return objc_getAssociatedObject(self, @selector(theme_image));
}


@end
