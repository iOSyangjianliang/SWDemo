//
//  EEViewController.m
//  CALayer子类动画
//
//  Created by 杨建亮 on 2018/10/16.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "EEViewController.h"

@interface EEViewController ()
@property (nonatomic, strong)CAShapeLayer *lineLayer;

@property (nonatomic, strong)CAShapeLayer *curveLayer;

@property (nonatomic, strong)CAShapeLayer *circleLayer;

@end

@implementation EEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];

    [self.view.layer addSublayer:self.lineLayer];
//
    [self.view.layer addSublayer:self.curveLayer];

    [self.view.layer addSublayer:self.circleLayer];

    [self test];
    
    [self testdrawRect];
}
/*线性的CAShapeLayer*/
//- (CAShapeLayer *)lineLayer
//{
//    if(!_lineLayer){
//        _lineLayer = [[CAShapeLayer alloc] init];
//        //        设置线条颜色
//        _lineLayer.strokeColor = [UIColor redColor].CGColor;
//        //        设置线条宽度
//        _lineLayer.lineWidth = 5;
//        //        绘制线条路径
//        UIBezierPath * path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(50, 100)];
//        [path addLineToPoint:CGPointMake(200, 100)];
//        //设置layer的path
//        _lineLayer.path = path.CGPath;
//    }
//    return _lineLayer;
//}

/*虚线性的CAShapeLayer*/
- (CAShapeLayer *)lineLayer
{
    if(!_lineLayer){
        _lineLayer = [[CAShapeLayer alloc] init];
        //        设置线条颜色
        _lineLayer.strokeColor = [UIColor redColor].CGColor;
        //        设置线条宽度
        _lineLayer.lineWidth = 4;
        //        绘制线条路径
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50, 200)];
        [path addLineToPoint:CGPointMake(350, 200)];
        [path addLineToPoint:CGPointMake(350, 600)];
        [path addLineToPoint:CGPointMake(50, 600)];
       
//        [path addLineToPoint:CGPointMake(50, 200)];

        //连接类型为round，就是拐角处的线条类型
        _lineLayer.lineJoin = kCALineJoinRound;
        //线性模版，这是一个NSNumber的数组，索引从1开始记，奇数位数值表示实线长度，偶数位数值表示空白长度。
        //下面表示的是一个等距等宽的虚线。
        _lineLayer.lineDashPattern = @[@5,@5];
        
        //设置layer的path
        _lineLayer.path = path.CGPath;
    }
    return _lineLayer;
}

/*曲线*/
- (CAShapeLayer *)curveLayer
{
    if(!_curveLayer){
        _curveLayer = [[CAShapeLayer alloc] init];
        _curveLayer.strokeColor = [UIColor greenColor].CGColor;
        _curveLayer.fillColor = [UIColor clearColor].CGColor;
        
        //        绘制曲线
        UIBezierPath * path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(50, 350)];
        //        第一个参数是终点位置；第二个参数是第一个控制点；第三个参数是第二个控制点
        [path addCurveToPoint:CGPointMake(250, 350) controlPoint1:CGPointMake(100, 250) controlPoint2:CGPointMake(200, 450)];
        _curveLayer.path = path.CGPath;
    }
    return _curveLayer;
}

/*圆形CAShapeLayer*/
- (CAShapeLayer *)circleLayer
{
    if(!_circleLayer){
        
        _circleLayer = [[CAShapeLayer alloc] init];
        _circleLayer.strokeColor = [UIColor yellowColor].CGColor;
        _circleLayer.lineWidth = 15;
        _circleLayer.position = CGPointMake(70, 150);
        
//        _circleLayer.fillColor = [UIColor redColor].CGColor;
       
        //颜色不支持
        UIColor *color = [UIColor whiteColor];// [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.0];
//        _circleLayer.opacity = 0.35;
        _curveLayer.fillColor = color.CGColor;
        
        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
        _circleLayer.path = path.CGPath;
    }
    return _circleLayer;
}

//中间镂空的矩形框
-(void)test
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    
    CGFloat centerX = self.view.center.x;
    CGFloat centerY = self.view.center.y;
    
    UIBezierPath *bezierpath = [UIBezierPath bezierPath];
    [bezierpath moveToPoint:CGPointMake(centerX + 50, centerY)];
    [bezierpath addCurveToPoint:CGPointMake(centerX, centerY - 50) controlPoint1:CGPointMake(centerX + 50, centerY) controlPoint2:CGPointMake(centerX + 50, centerY - 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX - 50, centerY) controlPoint1:CGPointMake(centerX, centerY - 50) controlPoint2:CGPointMake(centerX - 50, centerY - 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX, centerY + 50) controlPoint1:CGPointMake(centerX - 50, centerY) controlPoint2:CGPointMake(centerX - 50, centerY + 50)];
    [bezierpath addCurveToPoint:CGPointMake(centerX + 50, centerY - 0.00001) controlPoint1:CGPointMake(centerX, centerY + 50) controlPoint2:CGPointMake(centerX + 50, centerY + 50)];
    
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 0.00001)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY + 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX - 100, centerY + 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX - 100, centerY - 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 100)];
    [bezierpath addLineToPoint:CGPointMake(centerX + 100, centerY - 0.00001)];
    
    bezierpath.lineWidth = 1;
    [bezierpath closePath];
    shapeLayer.path = bezierpath.CGPath;
    shapeLayer.fillColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:shapeLayer];
    

}

- (void)testdrawRect
{
    CGRect rect = CGRectMake(200, 400, 50, 50);
    
    //中间镂空的同心圆
    CGRect myRect =CGRectMake(200+15,400+15,20, 20);
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:25];//25切圆角
    //镂空
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:myRect];
    [path appendPath:circlePath];
    [path setUsesEvenOddFillRule:YES];
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor whiteColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.view.layer addSublayer:fillLayer];
    
    
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
