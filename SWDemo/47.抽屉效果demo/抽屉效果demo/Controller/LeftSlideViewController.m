//
//  LeftSlideViewController.m
//  抽屉效果demo
//
//  Created by 杨建亮 on 2019/1/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "LeftSlideViewController.h"


@interface LeftSlideViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, strong, readonly) UINavigationController *naviVC;

@property (nonatomic, strong) UIPanGestureRecognizer *leftPan;

@property(nonatomic, strong) UIView *panGestureView; //手势指定范围view
@property(nonatomic, strong) UIControl *mainVCMaskView;
@property(nonatomic, weak) UIImageView *placeImageView;

@end

@implementation LeftSlideViewController
- (instancetype)initWithLeftVC:(UIViewController *)leftVC naviVC:(UINavigationController *)naviVC
{
    if (self = [super init]) {
    
        _leftVC = leftVC;
        _mainVC = naviVC.childViewControllers.firstObject;
        _naviVC = naviVC;
        
        CGRect frame = self.leftVC.view.frame;
        frame.origin.x = -leftOutSpace;
        self.leftVC.view.frame = frame;
        [self addChildViewController:self.leftVC];

        [self.view addSubview:self.naviVC.view];
        [self addChildViewController:self.naviVC];
        
        [self addLeftSlidePanGestureRecognizer];
    }
    return self;
}
-(void)addLeftSlidePanGestureRecognizer
{
    //只设置左侧70宽度有侧滑、处理tableView侧滑冲突问题(类似QQ)
    UIView *panGestureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftSlideWidth, self.naviVC.view.bounds.size.height)];
    panGestureView.backgroundColor = [UIColor clearColor];

    [self.naviVC.view addSubview:panGestureView];
    self.panGestureView = panGestureView;
    
    //滑动手势
    self.leftPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(leftHandlePan:)];
    self.leftPan.maximumNumberOfTouches = 1;
    
    [panGestureView addGestureRecognizer:self.leftPan];
    self.leftPan.delegate = self;
    
}


-(UIControl *)mainVCMaskView
{
    if ( !_mainVCMaskView) {
        UIControl *v = [[UIControl alloc] initWithFrame:self.naviVC.view.bounds];
        v.backgroundColor = [UIColor blackColor];
        v.alpha = 0;
        [v addTarget:self action:@selector(fastCloseLeftView:) forControlEvents:UIControlEventTouchUpInside];
        [self.naviVC.view addSubview:v];
        _mainVCMaskView = v;
    }
    return _mainVCMaskView;
}
-(UIImageView *)placeImageView
{
    if (!_placeImageView) {
        UIImageView *imV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:imV];
        _placeImageView = imV;
    }
    return _placeImageView;
}
-(void)fastCloseLeftView:(UIControl *)sender
{
    [self closeLeftVC:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    

}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"LeftSlideViewController viewWillAppear");
}
-(void)dealloc{
    NSLog(@"LeftSlideViewController dealloc");

}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{

    NSLog(@"AAA%@",gestureRecognizer);
//    NSLog(@"%@",touch);
    if ([touch.view isDescendantOfView:self.panGestureView]) {
//        if (gestureRecognizer.state == UIGestureRecognizerStatePossible) {
//            [gestureRecognizer delaysTouchesBegan];
//            return NO;
//        }
//            UIPressTypeMenu
//        UITouchTypeDirect
            
        return YES;
    }
    return NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"BBB");
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    NSLog(@"CCC");
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)leftHandlePan: (UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender translationInView:sender.view];
//    NSLog(@"点%f--%f", point.x, point.y);
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别侧滑手势");
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGRect frame = self.naviVC.view.frame;
        CGRect leftViewframe = self.leftVC.view.frame;
        if (frame.origin.x< 0)
        {
            frame.origin.x = 0;
            self.naviVC.view.frame = frame;
            
            leftViewframe.origin.x = -leftOutSpace;
            self.leftVC.view.frame = leftViewframe;
            [self.leftVC.view removeFromSuperview];
            
            self.mainVCMaskView.alpha = 0;
        }
        else if (frame.origin.x>=0 && frame.origin.x<=frame.size.width*leftScale)
        {
            CGFloat X = frame.origin.x + point.x;
            if (point.x<0) {
                X = X<0?0:X;
            }else{
                X = X>frame.size.width*leftScale?frame.size.width*leftScale:X;
            }
            frame.origin.x = X;
            self.naviVC.view.frame = frame;
            
          
            CGFloat percentage = X/ (frame.size.width*leftScale);
            
            leftViewframe.origin.x = (1.0-percentage)* -leftOutSpace;
            self.leftVC.view.frame = leftViewframe;
            [self.view insertSubview:self.leftVC.view belowSubview:self.naviVC.view];

            self.mainVCMaskView.alpha = 0.35*percentage; //设置蒙层
        }
        else
        {
            frame.origin.x = frame.size.width*leftScale;
            self.naviVC.view.frame = frame;
            
            leftViewframe.origin.x = 0;
            self.leftVC.view.frame = leftViewframe;
            [self.view insertSubview:self.leftVC.view belowSubview:self.naviVC.view];

            self.mainVCMaskView.alpha = 0.35;
        }
        // 将位移清零
        [sender setTranslation:CGPointZero inView:sender.view];
    }
    
    //手势结束后修正位置,超过一半时自动打开、关闭
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGRect frame = self.naviVC.view.frame;

        CGFloat criticalPoint = (frame.size.width*leftScale)/2.f;
        if (frame.origin.x< criticalPoint)
        {
            [self closeLeftVC:YES];
        }
        else
        {
            [self openLeftVC:YES];
        }
    }
    
    
//    NSLog(@"leftHandlePan=%@",sender);
}
-(void)openLeftVC:(BOOL)animated
{
    [self.view insertSubview:self.leftVC.view belowSubview:self.naviVC.view];
    if (animated)
    {
        [self.view insertSubview:self.leftVC.view belowSubview:self.naviVC.view];
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = self.naviVC.view.frame;
            frame.origin.x = frame.size.width*leftScale;
            self.naviVC.view.frame = frame;
           
            CGRect leftViewframe = self.leftVC.view.frame;
            leftViewframe.origin.x = 0;
            self.leftVC.view.frame = leftViewframe;

            self.mainVCMaskView.alpha = 0.35;
            
            
        } completion:^(BOOL finished) {

        }];
    }
    else
    {
        CGRect frame = self.naviVC.view.frame;
        frame.origin.x = frame.size.width*leftScale;
        self.naviVC.view.frame = frame;
        
        CGRect leftViewframe = self.leftVC.view.frame;
        leftViewframe.origin.x = 0;
        self.leftVC.view.frame = leftViewframe;

        self.mainVCMaskView.alpha = 0.35;
    }
   
}
-(void)closeLeftVC:(BOOL)animated
{
    if (animated)
    {
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = self.naviVC.view.frame;
            frame.origin.x = 0;
            self.naviVC.view.frame = frame;
            
            CGRect leftViewframe = self.leftVC.view.frame;
            leftViewframe.origin.x = -leftOutSpace;
            self.leftVC.view.frame = leftViewframe;
            
            self.mainVCMaskView.alpha = 0;

        } completion:^(BOOL finished) {
            [self.leftVC.view removeFromSuperview];
        }];
    }
    else
    {
        CGRect frame = self.leftVC.view.frame;
        frame.origin.x = 0;
        self.naviVC.view.frame = frame;
        
        CGRect leftViewframe = self.leftVC.view.frame;
        leftViewframe.origin.x = -leftOutSpace;
        self.leftVC.view.frame = leftViewframe;
    
        [self.leftVC.view removeFromSuperview];

        self.mainVCMaskView.alpha = 0;
    }
}
- (void)setLeftViewControllerOpen:(BOOL)open animated:(BOOL)animated
{
    if (open) {
        [self openLeftVC:animated];
    }else{
        [self closeLeftVC:animated];
    }
}
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    NSLog(@"_placeImageView %@",_placeImageView);

    BOOL leftVC = self.leftVC.view.superview?YES:NO;
    if (leftVC) {
        self.placeImageView.image = [self getScreenShotImage];//触发懒加载
        [self.leftVC.view removeFromSuperview];//在present时移除、优化系统present好卡问题
    }
    
    BOOL naviVC = self.naviVC.view.superview?YES:NO;
    if (naviVC) {
        self.placeImageView.image = [self getScreenShotImage];
        [self.mainVC.view removeFromSuperview];
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:^{
        
        if (naviVC) {
            [self.view addSubview:self.naviVC.view];
            [self.placeImageView removeFromSuperview];
        }
        
        if (leftVC) {
            [self.view insertSubview:self.leftVC.view belowSubview:self.naviVC.view];
            [self.placeImageView removeFromSuperview];
        }
                
        if (completion) {
            completion();
        }
    }];
}
-(UIImage *)getScreenShotImage
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, window.opaque, 0);
    // 2.渲染
    [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:NO];
    // 3.获取图片
    UIImage *snapshotImage=UIGraphicsGetImageFromCurrentImageContext();
    // 4.结束上下文
    UIGraphicsEndImageContext();
    return snapshotImage;
}
@end
