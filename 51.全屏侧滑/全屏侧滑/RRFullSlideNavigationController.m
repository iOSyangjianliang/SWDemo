//
//  RRFullSlideNavigationController.m
//  全屏侧滑
//
//  Created by 顺网-yjl on 2019/4/11.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "RRFullSlideNavigationController.h"

@interface RRFullSlideNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation RRFullSlideNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id target = self.interactivePopGestureRecognizer.delegate;
    
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIView *targetView = self.interactivePopGestureRecognizer.view;
    
    //  创建pan手势 作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    [targetView addGestureRecognizer:fullScreenGes];
    
    // 关闭边缘触发手势 防止和原有边缘手势冲突
    [self.interactivePopGestureRecognizer setEnabled:NO];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 根据具体控制器对象决定是否开启全屏右滑返回
    UIViewController *viewController = self.topViewController;
    if (viewController.isCloseFullSlide) {
        return NO;
    }
    
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    // 解决右滑和UITableView左滑删除的冲突
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    if (translation.x <= 0) {
        return NO;
    }
    
    return self.childViewControllers.count == 1 ? NO : YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end




@implementation UIViewController (RRFullSlide)
-(void)setIsCloseFullSlide:(BOOL)isCloseFullSlide
{
    objc_setAssociatedObject(self, @"key_isCloseFullSlide", @(isCloseFullSlide), OBJC_ASSOCIATION_ASSIGN);
}
-(BOOL)isCloseFullSlide
{
    return [objc_getAssociatedObject(self, @"key_isCloseFullSlide") boolValue];
}
@end
