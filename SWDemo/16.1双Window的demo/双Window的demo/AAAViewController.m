//
//  AAAViewController.m
//  双Window的demo
//
//  Created by 杨建亮 on 2019/3/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "AAAViewController.h"

@interface AAAViewController ()

@end

@implementation AAAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];

    UITextField *textF = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 200, 40)];
    textF.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:textF];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
    
    self.vc.www.hidden = YES;
    self.vc.www = nil;
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor = [UIColor blueColor];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    NSLog(@"\n>>>>>>>");
    NSLog(@"keyWindow=%@",[UIApplication sharedApplication].keyWindow);

    NSLog(@"A%@",[UIApplication sharedApplication].windows);
    
    return;
    
//    UIWindow *delegateWindow = [UIApplication sharedApplication].delegate.window;
//    UIWindow *win = [delegateWindow viewWithTag:10086];
//    [win endEditing:YES];
//    win.rootViewController = nil;
////    [win removeFromSuperview];
//    
//    win.hidden = YES;
//    [delegateWindow makeKeyAndVisible];
////    [win resignKeyWindow];
////    win = nil;
//
//    NSLog(@"B%@",[UIApplication sharedApplication].windows);
//
//    NSLog(@"keyWindow=%@",[UIApplication sharedApplication].keyWindow);
//
//    NSLog(@"\n<<<<<<<<<");

}
-(void)dealloc
{
    NSLog(@"dealloc AAAViewController");
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
