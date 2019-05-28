//
//  ViewController.m
//  腾讯MTA统计Demo
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "MTA/MTA.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"首页";
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UIViewController *vc = [[NSClassFromString(@"AAViewController") alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
    NSDictionary *dict = @{
                           @"yjl":@"我的萨达萨达大师大师"
                           };
    [MTA trackCustomKeyValueEvent:@"yjl_test" props:dict];
    
    
    [MTA trackCustomKeyValueEvent:@"66666" props:[NSDictionary dictionary]];

    [MTA trackCustomKeyValueEvent:@"首页" props:nil];

}

@end
