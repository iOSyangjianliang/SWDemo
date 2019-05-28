//
//  SWRCTouchAnimatedView.m
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/3/5.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "SWRCTouchAnimatedView.h"

@interface SWRCTouchAnimatedView ()
@property(nonatomic, strong) NSMutableArray<CAShapeLayer *> *shapeLayersArrayM;

@property(nonatomic, strong) NSArray<NSNumber *> *arrWH;
@property(nonatomic, strong) NSArray<NSNumber *> *arrOpacity;

@end

@implementation SWRCTouchAnimatedView

-(void)setTouchPoint:(CGPoint)touchPoint
{
    _touchPoint = touchPoint;
    
    CGRect frame = CGRectMake(touchPoint.x-60, touchPoint.y-60, 120, 120);
    self.frame = frame;
    
}
-(NSMutableArray<CAShapeLayer *> *)shapeLayersArrayM
{
//    if (!_shapeLayersArrayM) {
//        [self test];
//        _arrWH = @[@(50),@(60),@(65),@(120)];
//        _arrOpacity = @[@(0.4),@(0.35),@(0.25),@(0.2)];
//    }
//    return _shapeLayersArrayM;
    
    if (!_shapeLayersArrayM) {
        _arrWH = @[@(52),@(62),@(68),@(100)];
        _arrOpacity = @[@(0.4),@(0.35),@(0.25),@(0.2)];
        _shapeLayersArrayM = [NSMutableArray array];
        
        for (int i=0; i<_arrWH.count; ++i) {
            CAShapeLayer *pulseLayer = [CAShapeLayer layer];
            CGFloat W = self.frame.size.width;
            CGFloat WH = [_arrWH[i] floatValue];
            CGFloat X = (W-WH)/2.f;
            CGRect frame = CGRectMake(X, X, WH, WH);
            pulseLayer.frame = frame;
            pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
            pulseLayer.fillRule = kCAFillRuleEvenOdd;
            pulseLayer.fillColor = [UIColor lightGrayColor].CGColor;//填充色
            pulseLayer.opacity = [_arrOpacity[i] floatValue];//透明度
            [self.layer addSublayer:pulseLayer];
            
            [_shapeLayersArrayM addObject:pulseLayer];
        }
    }
    return _shapeLayersArrayM;
}
-(void)showHighlighted:(BOOL)animated
{
    if (animated)
    {
         for (int i=0; i<self.shapeLayersArrayM.count; ++i) {
            CAShapeLayer *pulseLayer = (CAShapeLayer *)self.shapeLayersArrayM[i];
            [pulseLayer removeAllAnimations];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            for (int i=0; i<self.shapeLayersArrayM.count; ++i) {
                CAShapeLayer *pulseLayer = (CAShapeLayer *)self.shapeLayersArrayM[i];
                
                CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
                opacityAnima.fromValue = self.arrOpacity[i];
                opacityAnima.toValue = @(0);
                
                CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
                CGFloat scale = self.frame.size.width/[self.arrWH[i] floatValue];
                if (i==self.shapeLayersArrayM.count-1) {
                    scale = scale*1.2;
                }
                scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1, 1, 0.0)];
                scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, scale, scale, 0.0)];
                
                CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
                groupAnima.animations = @[opacityAnima, scaleAnima];
                groupAnima.duration = 0.5;
                groupAnima.autoreverses = NO;
                groupAnima.repeatCount = 0;
                
                pulseLayer.fillMode = kCAFillModeForwards;
                [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
                
                
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
        });
    }
    else
    {
        [self shapeLayersArrayM];
        for (int i=0; i<self.shapeLayersArrayM.count; ++i) {
            CAShapeLayer *pulseLayer = (CAShapeLayer *)self.shapeLayersArrayM[i];
            [pulseLayer removeAllAnimations];
            pulseLayer.fillColor = [UIColor blueColor].CGColor;//填充色
        }
    }
}


//    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
//    pulseLayer.frame = CGRectMake(14, 14, 32, 32);
//    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
//    pulseLayer.fillColor = [UIColor redColor].CGColor;
//    pulseLayer.opacity = 0.4;
//    [self addSublayer:pulseLayer];
//
//    CAShapeLayer *pulseLayer1 = [CAShapeLayer layer];
//    pulseLayer1.frame = CGRectMake(10, 10, 40, 40);
//    pulseLayer1.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer1.bounds].CGPath;
//    pulseLayer1.fillColor = [UIColor redColor].CGColor;
//    pulseLayer1.opacity = 0.25;
//    [self addSublayer:pulseLayer1];
//
//    CAShapeLayer *pulseLayer2 = [CAShapeLayer layer];
//    pulseLayer2.frame = CGRectMake(7, 7, 46, 46);
//    pulseLayer2.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer2.bounds].CGPath;
//    pulseLayer2.fillColor = [UIColor redColor].CGColor;
//    pulseLayer2.opacity = 0.2;
//    [self addSublayer:pulseLayer2];
//
//    CAShapeLayer *pulseLayer3 = [CAShapeLayer layer];
//    pulseLayer3.frame = self.bounds;
//    pulseLayer3.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer3.bounds].CGPath;
//    pulseLayer3.fillColor = [UIColor redColor].CGColor;
//    pulseLayer3.opacity = 0.1;
//    [self addSublayer:pulseLayer3];
//
//
//    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnima.fromValue = @(0.4);
//    opacityAnima.toValue = @(0.1);
//
//    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 32.f/60.f, 32.f/60.f, 0.0)];
//    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
//
//    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
//    groupAnima.animations = @[opacityAnima, scaleAnima];
//    groupAnima.duration = 5.2;
//    groupAnima.autoreverses = NO;
//    groupAnima.repeatCount = 0;
//    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
//
//    //
//    CABasicAnimation *opacityAnima1 = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    opacityAnima1.fromValue = @(0.25);
//    opacityAnima1.toValue = @(0.1);
//    CABasicAnimation *scaleAnima1 = [CABasicAnimation animationWithKeyPath:@"transform"];
//    scaleAnima1.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 40.f/60.f, 40.f/60.f, 0.0)];
//    scaleAnima1.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
//    CAAnimationGroup *groupAnima1 = [CAAnimationGroup animation];
//    groupAnima1.animations = @[opacityAnima1, scaleAnima1];
//    groupAnima1.duration = 5.2;
//    groupAnima1.autoreverses = NO;
//    groupAnima1.repeatCount = 0;
//    [pulseLayer1 addAnimation:groupAnima1 forKey:@"groupAnimation"];
//
//


//CGRect rect = CGRectMake(200, 400, 50, 50);
//
////中间镂空的同心圆
//CGRect myRect =CGRectMake(200+15,400+15,20, 20);
//
////背景

//
//CAShapeLayer *fillLayer = [CAShapeLayer layer];
//fillLayer.path = path.CGPath;
//fillLayer.fillRule = kCAFillRuleEvenOdd;
//fillLayer.fillColor = [UIColor whiteColor].CGColor;
//fillLayer.opacity = 0.5;
//[self.view.layer addSublayer:fillLayer];
-(void)test
{
//    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(40, 40, 40, 40)];
//    imv.image = [UIImage imageNamed:@"blue"];
//    [self addSubview:imv];
    
    CGRect rect =  CGRectMake(17.5, 17.5, 50, 50);
    CGRect centerRect = CGRectMake(rect.origin.x+15, rect.origin.y+15, 20, 20);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25];
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:centerRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];

    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = rect;
    pulseLayer.path = path.CGPath;
    pulseLayer.fillRule = kCAFillRuleEvenOdd;
    pulseLayer.fillColor = [UIColor redColor].CGColor;
    pulseLayer.opacity = 0.4;
    [self.layer addSublayer:pulseLayer];

    //
    CGRect rect1 = CGRectMake(15, 15, 60, 60);
    CGRect centerRect1 = CGRectMake(rect1.origin.x+20, rect1.origin.y+20, 20, 20);
    UIBezierPath *path1 = [UIBezierPath bezierPathWithRoundedRect:rect1 cornerRadius:30];
    UIBezierPath *circlePath1 = [UIBezierPath bezierPathWithOvalInRect:centerRect1];
    [path1 appendPath:circlePath1];
    [path1 setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *pulseLayer1 = [CAShapeLayer layer];
    pulseLayer1.frame = rect1;
    pulseLayer1.path = path1.CGPath;
    pulseLayer1.fillRule = kCAFillRuleEvenOdd;
    pulseLayer1.fillColor = [UIColor redColor].CGColor;
    pulseLayer1.opacity = 0.35;
    [self.layer addSublayer:pulseLayer1];
    
    //
    CGRect rect2 = CGRectMake(13.75, 13.75, 65, 65);
    CGRect centerRect2 = CGRectMake(rect2.origin.x+22.5, rect2.origin.y+22.5, 20, 20);
    UIBezierPath *path2 = [UIBezierPath bezierPathWithRoundedRect:rect2 cornerRadius:32.5];
    UIBezierPath *circlePath2 = [UIBezierPath bezierPathWithOvalInRect:centerRect2];
    [path2 appendPath:circlePath2];
    [path2 setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *pulseLayer2 = [CAShapeLayer layer];
    pulseLayer2.frame = rect2 ;
    pulseLayer2.path = path2.CGPath;
    pulseLayer2.fillRule = kCAFillRuleEvenOdd;
    pulseLayer2.fillColor = [UIColor redColor].CGColor;
    pulseLayer2.opacity = 0.25;
    [self.layer addSublayer:pulseLayer2];

    //
    CGRect rect3 = CGRectMake(0, 0, 120, 120);
    CGRect centerRect3 = CGRectMake(rect3.origin.x+50, rect3.origin.y+50, 20, 20);
    UIBezierPath *path3 = [UIBezierPath bezierPathWithRoundedRect:rect3 cornerRadius:60];
    UIBezierPath *circlePath3 = [UIBezierPath bezierPathWithOvalInRect:centerRect3];
    [path3 appendPath:circlePath3];
    [path3 setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *pulseLayer3 = [CAShapeLayer layer];
    pulseLayer3.frame = rect3;
    pulseLayer3.path = path3.CGPath;
    pulseLayer3.fillRule = kCAFillRuleEvenOdd;
    pulseLayer3.fillColor = [UIColor redColor].CGColor;
    pulseLayer3.opacity = 0.2;
    [self.layer addSublayer:pulseLayer3];
   
    
    _shapeLayersArrayM = [NSMutableArray array];
    [_shapeLayersArrayM addObject:pulseLayer];
    [_shapeLayersArrayM addObject:pulseLayer1];
    [_shapeLayersArrayM addObject:pulseLayer2];
    [_shapeLayersArrayM addObject:pulseLayer3];

}
@end
