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

#import "SWRCInputAccessoryView.h"

@interface ViewController ()<SWRCGesturesViewDelegate>
@property(nonatomic, strong)SWRCGesturesView *gesturesView;

@property(nonatomic, strong) UIButton *btn;

@property(nonatomic, strong) UITextView *textView;
@end

@implementation ViewController
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];

    //未支持
//    self.gesturesView = [[SWRCGesturesView alloc] initWithFrame:CGRectMake(40, 20, self.view.frame.size.width-50, self.view.frame.size.height-40)];
    
    self.gesturesView = [[SWRCGesturesView alloc] initWithFrame:self.view.bounds];
    _gesturesView.backgroundColor = [UIColor blackColor];
    _gesturesView.clipsToBounds = YES;
    _gesturesView.delegate = self;
    [self.view addSubview:self.gesturesView];


    SWRCOpenGLView *movingView = [[SWRCOpenGLView alloc] init];
    _gesturesView.openGLView = movingView;
    
//    _gesturesView.gesturesMode = SWRCGesturesMode_pointerBorder;

    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(280, 100, 140, 40)];
    [btn addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"无手势模式" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:btn];
    _btn = btn;
    
    
    
    UIImageView *v1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    v1.image = [UIImage imageNamed:@"blue"];
    [self.view addSubview:v1];
    
    v1.center  = self.view.center;
    
    UIImageView *v2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    v2.image = [UIImage imageNamed:@"blue"];
    [self.view addSubview:v2];
    
    CGPoint cen =  v1.center;
    cen.y -=250;
    v2.center  = cen;
    
    iii = 0;
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 100, 80, 80)];
    _textView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;

    SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:SWRCInputViewType_Default] ;
    _textView.inputAccessoryView = accV;
    accV.sw_textView = _textView;
    
    

}
static int iii = 0;
-(void)change:(UIButton *)sender
{
//    [_textView resignFirstResponder];
//    return;
    
    sender.selected = !sender.selected;
    
    
    NSArray *arr = @[@"无手势模式",@"指针模式1",@"指针模式2",@"触屏模式",@"监控模式"];
    NSInteger idx = [arr indexOfObject: sender.titleLabel.text];
    
    _gesturesView.gesturesMode =  (idx+1)%5;
    [sender setTitle:arr[_gesturesView.gesturesMode] forState:UIControlStateNormal];

    
    return;//
   [ self.gesturesView setSectionInsetBottom:500-iii*50 animated:YES];
    
    UIView *tagV = [self.view viewWithTag:666];
    [tagV removeFromSuperview];

    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-(500-iii*50), self.view.frame.size.width, 500-iii*50)];
    v.tag = 666;
    v.backgroundColor = [UIColor yellowColor];
    [self.view insertSubview:v belowSubview:sender];
    
    iii++;
    

 
}
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if ( !CGRectEqualToRect(_gesturesView.frame, self.view.frame)) {
        _gesturesView.frame = self.view.bounds;
    }
}
-(void)sw_gesturesView:(SWRCGesturesView *)view gesturesType:(SWRCGesturesType)gesturesType state:(UIGestureRecognizerState)state touchPoint:(CGPoint)point frameSize:(CGSize)frameSize
{

    NSLog(@"point=%@ frameSize=%@",NSStringFromCGPoint(point),NSStringFromCGSize(frameSize));
}



- (BOOL)prefersHomeIndicatorAutoHidden{
    
    return IsPortrait;
}

@end
