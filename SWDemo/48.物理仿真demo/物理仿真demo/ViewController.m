//
//  ViewController.m
//  物理仿真demo
//
//  Created by 杨建亮 on 2019/3/12.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
@property (nonatomic, weak) UIView *redView;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@property (nonatomic, assign) CGFloat YYYY;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *blue = [[UIView  alloc] initWithFrame:CGRectMake(100, 450, 200, 200)];
    blue.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blue];
    
    UIView *redView = [[UIView  alloc] initWithFrame:CGRectMake(100, 450, 200, 200)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    self.redView = redView;
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self ss];
    return;
    
    
    CGSize size = _redView.frame.size;
    
    _YYYY = CGRectGetMinY(_redView.frame);
    
    // 获取触摸对象
    UITouch *t = touches.anyObject;
    // 获取手指的坐标点
    CGPoint p = [t locationInView:t.view];
    
    // 1.创建动画者对象
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // 2.创建行为
    //     UIPushBehaviorModeContinuous 持续推理(越来越快)
    //     UIPushBehaviorModeInstantaneous (瞬时推理)(越来越慢)
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.redView] mode:UIPushBehaviorModeInstantaneous];
    //推力矢量的大小
    push.magnitude = 1;//h=0.000001
    // 计算手指到redView中心点的偏移量
    CGFloat offsetX = 0.0; //p.x - self.redView.center.x;
    CGFloat offsetY = 1;// p.y - self.redView.center.y;  相当于力的位移
    // 设置手指到redView中心偏移量为推行为的向量方向、值越大力的作用时间越长
    push.pushDirection = CGVectorMake(-offsetX, -offsetY);
    // 设置推行为的活跃状态 YES:活跃 NO:不活跃
    push.active = YES;
    
    // 3.添加行为到动画者对象
    [self.animator addBehavior:push];
    
    // 添加一个碰撞
//    UICollisionBehavior  *collision = [[UICollisionBehavior alloc] initWithItems:@[self.redView]];
//    collision.translatesReferenceBoundsIntoBoundary = YES;
//    [self.animator addBehavior:collision];
    
    //添加一个阻力
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.redView]];
//    线速度阻尼、用于动态元素所受线速度阻尼大小。
//默认值是0.0。有效范围从0.0(没有速度阻尼)到CGFLOAT_MAX(最大速度阻尼)。当设置为CGFLOAT_MAX，动态元素会立马停止就像没有力量作用于它一样。
    itemBehavior.resistance = 1;//

//allowsRotation
//
//resistance: 抗阻力 0~CGFLOAT_MAX ，阻碍原有所加注的行为（如本来是重力自由落体行为，则阻碍其下落，阻碍程度根据其值来决定）
//
//friction: 磨擦力 0.0~1.0 在碰撞行为里，碰撞对象的边缘产生
//
//elasticity:弹跳性 0.0~1.0
//
//density:密度 0~1
    
    
    [self.animator addBehavior:itemBehavior];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"实际%f",CGRectGetMinY(_redView.frame)-_YYYY);

    });
    
    CGFloat s = 1000000*offsetY/(size.height*size.width*itemBehavior.resistance);
    NSLog(@"理论计算停下来位移： %f",s);
    
    //结论： 实际有误差，范围1个像素，且证明和magnitude值无关，为啥呢？

}



-(void)ss
{
    CGSize size = _redView.frame.size;
    
    _YYYY = CGRectGetMinY(_redView.frame);
    
    
    // 1.创建动画者对象
    //    if (!self.animator) {
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    //    }
    
    // 2.创建行为-UIPushBehaviorModeInstantaneous (瞬时推理)(越来越慢)
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.redView] mode:UIPushBehaviorModeInstantaneous];
    //推力矢量的大小
    push.magnitude = 1;//h=0.000001
    // 计算手指到redView中心点的偏移量
    CGFloat offsetX = 0.0; //p.x - self.redView.center.x;
    CGFloat offsetY = 1.0;// p.y - self.redView.center.y;  相当于力的位移
    // 设置手指到redView中心偏移量为推行为的向量方向、值越大力的作用时间越长
    push.pushDirection = CGVectorMake(-offsetX, -offsetY);
    // 设置推行为的活跃状态 YES:活跃 NO:不活跃
    push.active = YES;
    // 3.添加行为到动画者对象
    [self.animator addBehavior:push];
    
    //添加一个阻力
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.redView]];
    //线速度阻尼 默认值是0.0。有效范围从0.0(没有速度阻尼)到CGFLOAT_MAX(最大速度阻尼)。当设置为CGFLOAT_MAX，动态元素会立马停止就像没有力量作用于它一样。
    itemBehavior.resistance = 1;//
    [self.animator addBehavior:itemBehavior];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSLog(@"实际%f",CGRectGetMinY(_redView.frame)-_YYYY);
    //
    //    });
    
        CGFloat s = 1000000*offsetY/(size.height*size.width*itemBehavior.resistance);
    //    NSLog(@"理论计算停下来位移： %f",s);
    
    //结论： 实际有误差，范围1个像素，且证明和magnitude值无关，为啥呢？
    
}
@end
