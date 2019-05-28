//
//  ViewController.m
//  runtime交换注意点
//
//  Created by 杨建亮 on 2019/1/11.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

#import "AAViewController.h"

#import "UIViewController+test.h"
#import "UIViewController+test2.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AAViewController *vc =[[AAViewController alloc] init];
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

@end
