//
//  TestViewController.m
//  抽屉效果demo
//
//  Created by 杨建亮 on 2019/1/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSLog(@"TestViewController presentingViewController %@",self.presentingViewController);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    
    UIViewController * rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor blueColor];
    window.rootViewController  = rootVC;
    [window makeKeyAndVisible];
    
    [self dismissViewControllerAnimated:NO completion:^{
      
    }];
  
    
//    [self dismissViewControllerAnimated:YES completion:nil];
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
