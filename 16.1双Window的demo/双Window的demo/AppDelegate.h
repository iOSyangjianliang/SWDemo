//
//  AppDelegate.h
//  双Window的demo
//
//  Created by 杨建亮 on 2019/3/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAAWindow.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (weak, nonatomic, nullable) AAAWindow *myWindow;

@end

