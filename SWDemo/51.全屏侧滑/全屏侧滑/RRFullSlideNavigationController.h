//
//  RRFullSlideNavigationController.h
//  全屏侧滑
//
//  Created by 顺网-yjl on 2019/4/11.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (RRFullSlide)
@property (nonatomic, assign) BOOL isCloseFullSlide;
@end


@interface RRFullSlideNavigationController : UINavigationController

@end

NS_ASSUME_NONNULL_END
