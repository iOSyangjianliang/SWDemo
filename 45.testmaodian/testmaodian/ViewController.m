//
//  ViewController.m
//  testmaodian
//
//  Created by 杨建亮 on 2019/2/27.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *_testV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _testV = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    _testV.backgroundColor = [UIColor redColor];
    [self.view addSubview:_testV];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGRect oldFrame = _testV.frame;
    _testV.layer.anchorPoint = CGPointZero;
    _testV.layer.frame = oldFrame;

    [UIView animateWithDuration:2.25 animations:^{
        _testV.frame = CGRectMake(100, 100, 200, 200);

    }];
}

@end
