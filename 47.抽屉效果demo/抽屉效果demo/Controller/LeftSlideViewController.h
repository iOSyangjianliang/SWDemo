//
//  LeftSlideViewController.h
//  抽屉效果demo
//
//  Created by 杨建亮 on 2019/1/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftViewController.h"
#import "MainViewController.h"

NS_ASSUME_NONNULL_BEGIN

//leftVC默认左边偏移距离
static CGFloat leftOutSpace = 150.f;
//打开leftVC左滑菜单时，左滑菜单显示宽度百分比
static CGFloat leftScale = 0.75;
//左滑手势距离左边范围
static CGFloat leftSlideWidth = 60;

@interface LeftSlideViewController : UIViewController

- (instancetype)initWithLeftVC:(UIViewController *)leftVC naviVC:(UINavigationController *)naviVC;
//左侧窗控制器
@property (nonatomic, strong, readonly) LeftViewController *leftVC;
@property (nonatomic, strong, readonly) MainViewController *mainVC;


- (void)setLeftViewControllerOpen:(BOOL)open animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
