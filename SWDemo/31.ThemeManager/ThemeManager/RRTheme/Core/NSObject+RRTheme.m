//
//  NSObject+RRTheme.m
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "NSObject+RRTheme.h"

#import <objc/runtime.h>
#import "NSObject+RRDeallocBlock.h"

static NSString *const kHasRegistChangedThemeNotification;

@interface NSObject ()

@property (nonatomic, copy) void(^theme_changeBlock)(id observer);

@end

@implementation NSObject (RRTheme)

- (void)theme_registChangedNotification {
    NSNumber *hasRegist = objc_getAssociatedObject(self, &kHasRegistChangedThemeNotification);
    if (hasRegist) {
        return;
    }
    objc_setAssociatedObject(self, &kHasRegistChangedThemeNotification, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theme_didChanged) name:RRThemeChangedNotification object:nil];
    __weak typeof(self) weakSelf = self;
    [self sd_executeAtDealloc:^{
        [[NSNotificationCenter defaultCenter] removeObserver:weakSelf];
    }];
}


- (void)theme_didChanged {
    if (self.theme_changeBlock) {
        __weak typeof(self) weakSelf = self;
        self.theme_changeBlock(weakSelf);
    }
}

- (void)setTheme_changeBlock:(void (^)(void))block {
    objc_setAssociatedObject(self, @selector(theme_changeBlock), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))theme_changeBlock {
    return objc_getAssociatedObject(self, @selector(theme_changeBlock));
}

@end
