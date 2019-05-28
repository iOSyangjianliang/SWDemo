//
//  ViewController.m
//  双Window的demo
//
//  Created by 杨建亮 on 2019/3/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    UIAlertController *alVC = [UIAlertController alertControllerWithTitle:@"sdd" message:@"dasdadasd" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ac = [UIAlertAction actionWithTitle:@"quxiao" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alVC addAction:ac];
    [self presentViewController:alVC animated:YES completion:^{
        
    }];
}

@end
