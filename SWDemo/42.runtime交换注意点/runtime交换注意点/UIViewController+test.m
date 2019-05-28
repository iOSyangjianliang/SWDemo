//
//  UIViewController+test.m
//  runtime交换注意点
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "UIViewController+test.h"





@implementation UIViewController (test)
+ (void)load
{
    [super load];
    jl_Swizzling_exchangeMethod([self class], @selector(viewDidAppear:), @selector(Test1_viewDidAppear:));
    jl_Swizzling_exchangeMethod([self class], @selector(viewDidDisappear:), @selector(Test1_viewDidDisappear:));
    
}
-(void)Test1_viewDidAppear:(BOOL)animated
{
    [self Test1_viewDidAppear:animated];
    NSLog(@"Test1_viewDidAppear %@",NSStringFromClass(self.class));
}
-(void)Test1_viewDidDisappear:(BOOL)animated
{
    [self Test1_viewDidDisappear:animated];
    NSLog(@"Test1_消失 %@",NSStringFromClass(self.class));

}
@end
