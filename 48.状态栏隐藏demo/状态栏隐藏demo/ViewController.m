//
//  ViewController.m
//  状态栏隐藏demo
//
//  Created by 杨建亮 on 2019/4/17.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "BaseNavigationController.h"
#import "AAViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AAViewController *aa = [[AAViewController alloc] init];
    
    BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:aa];
  
    [self presentViewController:navi animated:YES completion:nil];
    
    
}



@end
