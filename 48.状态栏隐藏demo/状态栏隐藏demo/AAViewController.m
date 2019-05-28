//
//  AAViewController.m
//  状态栏隐藏demo
//
//  Created by 杨建亮 on 2019/4/17.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "AAViewController.h"
#import "BBViewController.h"
#import "TabBarController.h"
#import "BaseNavigationController.h"

@interface AAViewController ()

@end

@implementation AAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor =[UIColor redColor];
    
    
    self.navigationController.navigationBarHidden = YES;
}
//- (BOOL)prefersStatusBarHidden
//{
//    return YES;
//}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
//    BBViewController*aa = [[BBViewController alloc] init];
//    aa.view.backgroundColor = [UIColor purpleColor];
//    [self.navigationController pushViewController:aa animated:YES];
    
    
    
    BBViewController*aa = [[BBViewController alloc] init];
    aa.view.backgroundColor = [UIColor purpleColor];
    
    BaseNavigationController *base = [[BaseNavigationController alloc] initWithRootViewController:aa];
    
    aa.navigationItem.title = @"666";

    TabBarController *tab = [[TabBarController alloc] init];
    [tab setViewControllers:@[base]];
    
    [self.navigationController pushViewController:tab animated:YES];

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
