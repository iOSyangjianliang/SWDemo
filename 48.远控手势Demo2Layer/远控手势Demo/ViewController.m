//
//  ViewController.m
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "SWRCGesturesView.h"

#import "SWRCOpenGLView.h"
#import "SWRCEAGLLayer.h"

@interface ViewController ()
@property(nonatomic, strong)SWRCGesturesView *gesturesView;

@property(nonatomic, strong) UIButton *btn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    self.gesturesView = [[SWRCGesturesView alloc] initWithFrame:self.view.bounds];
    _gesturesView.backgroundColor = [UIColor purpleColor];
    _gesturesView.gesturesMode = SWRCGesturesMode_monitor;
    
//    SWRCOpenGLView *movingView = [[SWRCOpenGLView alloc] init];
//    _gesturesView.movingView = movingView;
    
    
    SWRCEAGLLayer *layer = [[SWRCOpenGLView alloc] init];
    _gesturesView.movingLayer = layer;

    [self.view addSubview:self.gesturesView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(280, 800, 80, 40)];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"监控模式" forState:UIControlStateNormal];
    [btn setTitle:@"指针模式" forState:UIControlStateSelected];
    [self.view addSubview:btn];
    _btn = btn;
    
}
-(void)change:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    _gesturesView.gesturesMode =  sender.selected+1;

}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ( !CGRectEqualToRect(_gesturesView.frame, self.view.frame)) {
        _gesturesView.frame = self.view.bounds;
    }
}
@end
