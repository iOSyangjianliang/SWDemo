//
//  ViewController.m
//  ThemeManager
//
//  Created by 杨建亮 on 2018/6/11.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+RRTheme.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    imageV.backgroundColor = [UIColor redColor];
    imageV.theme_image = @"home_icon";
    [self.view addSubview:imageV];
}
static bool bo = NO;
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    bo = !bo;
    [[RRThemeManager sharedInstance] changeTheme:[NSString stringWithFormat:@"%d",bo]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
