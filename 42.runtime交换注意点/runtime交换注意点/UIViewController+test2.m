//
//  UIViewController+test2.m
//  runtime交换注意点
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "UIViewController+test2.h"

@implementation UIViewController (test2)

+ (void)load
{
    [super load];
    jl_Swizzling_exchangeMethod([self class], @selector(viewDidAppear:), @selector(Test2_viewDidAppear:));
    jl_Swizzling_exchangeMethod([self class], @selector(viewDidDisappear:), @selector(Test2_viewDidDisappear:));

}
-(void)Test2_viewDidAppear:(BOOL)animated
{
    [self Test2_viewDidAppear:animated];
    NSLog(@"Test2_viewDidAppear %@",NSStringFromClass(self.class));

}
-(void)Test2_viewDidDisappear:(BOOL)animated
{
    [self Test2_viewDidDisappear:animated];
    NSLog(@"Test2_消失 %@",NSStringFromClass(self.class));

}

@end
