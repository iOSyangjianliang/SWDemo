
//
//  AAViewController.m
//  腾讯MTA统计Demo
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "AAViewController.h"

@interface AAViewController ()

@end

@implementation AAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"A测试";
    self.view.backgroundColor = [UIColor redColor];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
