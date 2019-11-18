//
//  NSObject+RRDeallocBlock.h
//  ThemeManager
//
//  Created by 杨建亮 on 2019/6/26.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RRDeallocBlock)
- (void)sd_executeAtDealloc:(void (^)(void))block;

@end

NS_ASSUME_NONNULL_END
