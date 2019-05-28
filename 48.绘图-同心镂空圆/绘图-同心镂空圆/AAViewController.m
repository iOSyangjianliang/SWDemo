//
//  AAViewController.m
//  绘图-同心镂空圆
//
//  Created by 杨建亮 on 2019/3/28.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "AAViewController.h"
#import "SWRCTouchAnimatedView.h"

@interface AAViewController ()
@property(nonatomic, strong) SWRCTouchAnimatedView *touchAnimatedView;


@end

@implementation AAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    _touchAnimatedView = [[SWRCTouchAnimatedView alloc] init];
    [self.view addSubview:_touchAnimatedView];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
   _touchAnimatedView.touchPoint = [touch locationInView:self.view];
    [_touchAnimatedView showHighlighted:YES];
    [self.view addSubview:_touchAnimatedView];

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
