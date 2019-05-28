//
//  BBViewController.m
//  状态栏隐藏demo
//
//  Created by 杨建亮 on 2019/4/17.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "BBViewController.h"
#import "CCViewController.h"

@interface BBViewController ()

@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    CCViewController *aa = [[CCViewController alloc] init];
    aa.view.backgroundColor = [UIColor purpleColor];
    [self.navigationController pushViewController:aa animated:YES];
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
