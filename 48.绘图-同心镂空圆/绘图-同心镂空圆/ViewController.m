//
//  ViewController.m
//  绘图-同心镂空圆
//
//  Created by 杨建亮 on 2019/3/28.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "AAViewController.h"

@interface ViewController ()
@property(strong)CAShapeLayer *pulseLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
    
    CGRect rect =  CGRectMake(107.5, 107.5, 50, 50);
    
    CGRect rect1 =  CGRectMake(0, 0, 50, 50);
    CGRect centerRect = CGRectMake(0.5, 0.5, 49, 49);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:25];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:centerRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
//    pulseLayer.backgroundColor = [UIColor yellowColor].CGColor;
    pulseLayer.frame = rect;
    pulseLayer.path = path.CGPath;
    pulseLayer.fillRule = kCAFillRuleEvenOdd;
    pulseLayer.fillColor = [UIColor redColor].CGColor;
    pulseLayer.opacity = 0.4;
    [self.view.layer addSublayer:pulseLayer];
    _pulseLayer= pulseLayer;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    AAViewController *AVC = [[AAViewController alloc] init];
    [self presentViewController:AVC animated:YES completion:nil];
    return;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];//关闭隐视动画（path不支持）
    
    CGRect rect1 =  CGRectMake(0, 0, 50, 50);
    CGRect centerRect = CGRectMake(21, 21, 8, 8);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:25];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:centerRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
//    self.pulseLayer.transform = CATransform3DMakeScale(1.5, 1.5, 1);
    
//    self.pulseLayer.path = path.CGPath;

    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"path"];
    
    opacityAnima.fromValue = (__bridge id _Nullable)(_pulseLayer.path);
    opacityAnima.toValue = (__bridge id _Nullable)(path.CGPath);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1, 1, 1)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.5, 1.5, 1)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4.35;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = 0;
    
    _pulseLayer.fillMode = kCAFillModeBoth;
    [_pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
    
    
    
    [CATransaction commit];

}
@end
