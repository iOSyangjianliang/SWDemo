//
//  MainViewController.h
//  抽屉效果demo
//
//  Created by 杨建亮 on 2019/1/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LeftSlideViewController.h"

@class LeftSlideViewController;
NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController
@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, weak) LeftSlideViewController *leftVC;
@end

NS_ASSUME_NONNULL_END
