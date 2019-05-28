//
//  SWRCGesturesView.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCGesturesView.h"

@interface SWRCGesturesView ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong, nullable) UIPinchGestureRecognizer *pichGes_monitor;
@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_monitor;

@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_pointer ;
@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_pointer_twoPoint;
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer;
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer_twoPoint;
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer_pointTwo;
@property(nonatomic, strong, nullable) UILongPressGestureRecognizer *longPressGes_pointer;

@property(nonatomic, weak, nullable) UIImageView *mouseImageView;//鼠标IMV

@property(nonatomic, assign) CGPoint lastLongPressMovePoint;//长按移动获取偏移量
@property(nonatomic, weak) NSTimer *autoMoveTimer;

@end

@implementation SWRCGesturesView

-(void)setMovingLayer:(SWRCEAGLLayer *)movingLayer
{
    if (movingLayer ) {
        if (![_movingLayer isEqual:movingLayer])
        {
            [_movingLayer removeFromSuperlayer];
            _movingLayer = movingLayer;
            
            [self.layer addSublayer:_movingLayer];
            [self setOpenGLView_MinSize];
        }
    }else{
        [_movingLayer removeFromSuperlayer];
        _movingLayer = movingLayer;
    }
}
-(UIImageView *)mouseImageView
{
    if (!_mouseImageView && self.gesturesMode == SWRCGesturesMode_pointer) {
        UIImageView *mouseIMV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 39.f/4, 71.f/4)];
        mouseIMV.image = [UIImage imageNamed:@"mouse"];
        mouseIMV.center = self.center;
        [self addSubview:mouseIMV];
        _mouseImageView = mouseIMV;
    }
    return _mouseImageView;
}
#pragma maark - ======
-(void)setOpenGLView_MinSize
{
    //重置锚点（缩放时修改了）
    CGRect frame = self.movingLayer.frame;
    _movingLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _movingLayer.frame = frame;

    if ([self isWidthGreaterHeight])
    {//横条形宽高比例图
        frame.size.width = self.frame.size.width;
        frame.size.height = frame.size.width/self.movingLayer.frameSize.width* self.movingLayer.frameSize.height;//该轴有误差
    }else
    {//竖条形宽高比例图
        frame.size.height = self.frame.size.height;
        frame.size.width = frame.size.height/self.movingLayer.frameSize.height* self.movingLayer.frameSize.width;
    }
    _movingLayer.frame = frame;
    _movingLayer.center = self.center;
    
    _mouseImageView.center = self.center;///XXXX
}
-(void)setOpenGLView_MaxSize
{
    //重置锚点（缩放时修改了）
    CGRect frame = self.movingLayer.frame;
    _movingLayer.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _movingLayer.layer.frame = frame;
    
    if (![self isWidthGreaterHeight])
    {//横条形宽高比例图
        frame.size.width = self.frame.size.width-88;
        frame.size.height = frame.size.width/self.movingLayer.frameSize.width* self.movingLayer.frameSize.height;
    }else
    {//竖条形宽高比例图
        frame.size.height = self.frame.size.height-88;
        frame.size.width = frame.size.height/self.movingLayer.frameSize.height* self.movingLayer.frameSize.width;
    }
    _movingLayer.frame = frame;
    _movingLayer.center = self.center;
    
    _mouseImageView.center = self.center;///XXXX

}
- (BOOL)isHorizontalCanMove
{//是否可以水平移动movingLayer
    return self.movingLayer.frame.size.width>self.frame.size.width;
}
- (BOOL)isVerticalCanMove
{//是否可以垂直移动movingLayer
    return self.movingLayer.frame.size.height>self.frame.size.height;
}
-(BOOL)isWidthGreaterHeight
{//是否横条形宽高比例图
    return self.movingLayer.frameSize.width/self.movingLayer.frameSize.height>self.frame.size.width/self.frame.size.height;
}
#pragma mark - 设置手势模式
-(void)setGesturesMode:(SWRCGesturesMode)gesturesMode
{
    _gesturesMode = gesturesMode;
    if (_gesturesMode == SWRCGesturesMode_monitor)
    {
        [_mouseImageView removeFromSuperview];
        [self sw_removeAllRCGestureRecognizer];
        [self registerGesture_Monitor];
    }
    else if (_gesturesMode == SWRCGesturesMode_pointer)
    {
        [self sw_removeAllRCGestureRecognizer];
        [self registerGesture_Pointer];
        [self bringSubviewToFront:self.mouseImageView];
    }
    else if (_gesturesMode == SWRCGesturesMode_touch)
    {
        [_mouseImageView removeFromSuperview];
//        [self sw_removeAllRCGestureRecognizer];
    }
    else
    {
        [_mouseImageView removeFromSuperview];
        [self sw_removeAllRCGestureRecognizer];
    }
}
-(void)sw_removeAllRCGestureRecognizer
{
    if (self.pichGes_monitor && self.pichGes_monitor.view) {
        [self.pichGes_monitor.view removeGestureRecognizer:self.pichGes_monitor];
        self.pichGes_monitor = nil;
    }
    if (self.panGes_monitor && self.panGes_monitor.view) {
        [self.panGes_monitor.view removeGestureRecognizer:self.panGes_monitor];
        self.panGes_monitor = nil;
    }
    //
    if (self.panGes_pointer && self.panGes_pointer.view) {
        [self.panGes_pointer.view removeGestureRecognizer:self.panGes_pointer];
        self.panGes_pointer = nil;
    }
    
    if (self.panGes_pointer_twoPoint && self.panGes_pointer_twoPoint.view) {
        [self.panGes_pointer_twoPoint.view removeGestureRecognizer:self.panGes_pointer_twoPoint];
        self.panGes_pointer_twoPoint = nil;
    }
    if (self.tapGes_pointer && self.tapGes_pointer.view) {
        [self.tapGes_pointer.view removeGestureRecognizer:self.tapGes_pointer];
        self.tapGes_pointer = nil;
    }
    
    if (self.tapGes_pointer_pointTwo && self.tapGes_pointer_pointTwo.view) {
        [self.tapGes_pointer_pointTwo.view removeGestureRecognizer:self.tapGes_pointer_pointTwo];
        self.tapGes_pointer_pointTwo = nil;
    }
    
    if (self.tapGes_pointer_twoPoint && self.tapGes_pointer_twoPoint.view) {
        [self.tapGes_pointer_twoPoint.view removeGestureRecognizer:self.tapGes_pointer_twoPoint];
        self.tapGes_pointer_twoPoint = nil;
    }
    
    if (self.longPressGes_pointer && self.longPressGes_pointer.view) {
        [self.longPressGes_pointer.view removeGestureRecognizer:self.longPressGes_pointer];
        self.longPressGes_pointer = nil;
    }
  
    
    
}
#pragma mark 监控手势
-(void)registerGesture_Monitor
{
    //捏合缩放
    UIPinchGestureRecognizer *pichGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGes_monitor:)];
    [self addGestureRecognizer:pichGes];
    self.pichGes_monitor = pichGes;
    
    //拖动
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes_monitor:)];
    panGes.minimumNumberOfTouches = 1;
    panGes.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGes];
    self.panGes_monitor = panGes;
    
}
#pragma mark 指针模式
-(void)registerGesture_Pointer
{
    //捏合缩放
    UIPinchGestureRecognizer *pichGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGes_monitor:)];
    [self addGestureRecognizer:pichGes];
    self.pichGes_monitor = pichGes;

    //单指拖动(鼠标)
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes_Pointer:)];
    panGes.minimumNumberOfTouches = 1;
    panGes.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:panGes];
    self.panGes_pointer = panGes;
    
    //双指拖动(类似鼠标滚轮效果)
    UIPanGestureRecognizer *panGes2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes_Pointer_twoPoint:)];
    panGes2.minimumNumberOfTouches = 2;
    panGes2.maximumNumberOfTouches = 2;
    [self addGestureRecognizer:panGes2];
    self.panGes_pointer_twoPoint = panGes2;

    //单指单击
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes];
    self.tapGes_pointer = tapGes;

    //单指双击
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes2:)];
    tapGes2.numberOfTapsRequired = 2;
    tapGes2.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes2];
    [tapGes requireGestureRecognizerToFail:tapGes2];//单指双击时,取消单指单击事件
    self.tapGes_pointer_pointTwo = tapGes;

    //双指单击(右键单击)
    UITapGestureRecognizer *tapGes3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes3:)];
    tapGes3.numberOfTapsRequired = 1;
    tapGes3.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:tapGes3];
    self.tapGes_pointer_twoPoint = tapGes;

    //双击后不松开0.5s
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes:)];
    longPressGes.numberOfTapsRequired = 1;
    longPressGes.numberOfTouchesRequired = 1;
    longPressGes.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPressGes];
    self.longPressGes_pointer = longPressGes;
    
}
#pragma mark - ===========指针模式============
- (void)tapGes:(UITapGestureRecognizer *)sender
{
    NSLog(@"单指单击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_SWRCGesturesView:gesturesType:msg:)]) {
        [self.delegate sw_SWRCGesturesView:self gesturesType:SWRCGesturesType_point msg:@"单指单击"];
    }

}
- (void)tapGes2:(UITapGestureRecognizer *)sender
{
    NSLog(@"单指双击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_SWRCGesturesView:gesturesType:msg:)]) {
        [self.delegate sw_SWRCGesturesView:self gesturesType:SWRCGesturesType_pointTwo msg:@"单指双击"];
    }
}
- (void)tapGes3:(UITapGestureRecognizer *)sender
{
    NSLog(@"双指单击(右键单击)");
    if (sender.state == UIGestureRecognizerStateEnded) {
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_SWRCGesturesView:gesturesType:msg:)]) {
        [self.delegate sw_SWRCGesturesView:self gesturesType:SWRCGesturesType_twoPoint msg:@"双指单击(右键单击)"];
    }

}
- (void)longPressGes:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>长按手势");
        _lastLongPressMovePoint = [sender locationInView:sender.view];

        _mouseImageView.backgroundColor = [UIColor redColor];
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [sender locationInView:sender.view];
        CGPoint offSet = CGPointMake(point.x-_lastLongPressMovePoint.x, point.y-_lastLongPressMovePoint.y);//计算偏移量
        [self moveingMouseFrameButNotOutBoundsWithOffset:offSet];//移动鼠标
        [self autoMoveingOpenGLViewWhenNeed];//检查是否处于放大模式并自动移动movingLayer
        _lastLongPressMovePoint = point;
    }
    //手势结束后检查修正位置
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _mouseImageView.backgroundColor = [UIColor clearColor];

    }
    
}
#pragma mark 单指拖动(鼠标)
- (void)panGes_Pointer:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"单指拖动(鼠标)");
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint offSet = [sender translationInView:sender.view];//移动的是偏移量
        [self moveingMouseFrameButNotOutBoundsWithOffset:offSet];//移动鼠标
        [self autoMoveingOpenGLViewWhenNeed];//检查是否处于放大模式并自动移动movingLayer
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self deallocTimer];
    }
}
//鼠标进行一次平移，并自动检查该次平移是否超出边界（不能超出屏幕、也不能超出movingLayer）
-(void)moveingMouseFrameButNotOutBoundsWithOffset:(CGPoint)offset
{
    CGRect oldFrame = _mouseImageView.frame;
    oldFrame.origin.x+= offset.x;
    oldFrame.origin.y+= offset.y;
    
    CGFloat minX = CGRectGetMinX(self.movingLayer.frame)>0.0?CGRectGetMinX(self.movingLayer.frame) : 0.0;//（不能超出屏幕、也不能超出movingLayer）
    CGFloat maxX = CGRectGetMaxX(self.movingLayer.frame) > CGRectGetWidth(self.frame) ? CGRectGetWidth(self.frame) :CGRectGetMaxX(self.movingLayer.frame) ;
    if (oldFrame.origin.x< minX)
    {
        oldFrame.origin.x = minX;
    }
    else if (oldFrame.origin.x> maxX)
    {
        oldFrame.origin.x = maxX;
    }
    
    CGFloat minY = CGRectGetMinY(self.movingLayer.frame)>0.0?CGRectGetMinY(self.movingLayer.frame) : 0.0;
    CGFloat maxY = CGRectGetMaxY(self.movingLayer.frame) > CGRectGetHeight(self.frame) ? CGRectGetHeight(self.frame) :CGRectGetMaxY(self.movingLayer.frame) ;
    if (oldFrame.origin.y< minY)
    {
        oldFrame.origin.y = minY;
    }
    else if (oldFrame.origin.y> maxY)
    {
        oldFrame.origin.y = maxY;
    }
    _mouseImageView.frame = oldFrame;
}
#pragma mark 双指拖动(类似鼠标滚轮效果)
- (void)panGes_Pointer_twoPoint:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"双指拖动(类似鼠标滚轮效果)");
        _mouseImageView.backgroundColor = [UIColor blueColor];

        if (self.delegate && [self.delegate respondsToSelector:@selector(sw_SWRCGesturesView:gesturesType:msg:)]) {
            [self.delegate sw_SWRCGesturesView:self gesturesType:SWRCGesturesType_scrollUp msg:@"双指拖动(类似鼠标滚轮效果)"];
        }
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
//        CGPoint point = [sender translationInView:sender.view];//移动的是偏移量

        
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
        
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _mouseImageView.backgroundColor = [UIColor clearColor];

    }
}
#pragma mark - ===========监控手势============
#pragma mark - 捏合缩放手势
- (void)pinchGes_monitor:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>捏合手势");
//        NSLog(@"%@",NSStringFromCGRect(self.movingLayer.frame));
        
        UIView *vvv = [self viewWithTag:666];
        [vvv removeFromSuperview];
        UIView *vvv2 = [self viewWithTag:888];
        [vvv2 removeFromSuperview];
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint anchorPoint = _movingLayer.layer.anchorPoint;
        
        CGFloat minX = CGRectGetMinX(self.movingLayer.frame);
        CGFloat maxX = CGRectGetMaxX(self.movingLayer.frame)-self.frame.size.width;
        minX = roundf(minX);
        maxX = roundf(maxX);
        if (minX>=0 && maxX<=0){
            anchorPoint.x = 0.5;
        }
        else if (minX<0 && maxX>0){
            if (CGPointEqualToPoint(self.movingLayer.center, self.center) ) {
                anchorPoint.x = 0.5;
            }else{
                CGPoint point = [sender locationInView:sender.view];//以两个点触摸点之间的位置作为锚点
                CGFloat x = (point.x-self.movingLayer.frame.origin.x)/self.movingLayer.frame.size.width;
                anchorPoint.x = x;
            }
        }
        else if (minX>=0 && maxX>0){
            CGRect ff = _movingLayer.layer.frame;
            ff.origin.x = 0;
            _movingLayer.layer.frame = ff;
            anchorPoint.x = 0;
        }
        else if (minX<=0 && maxX<=0) {
            CGRect ff = _movingLayer.layer.frame;
            ff.origin.x = -self.movingLayer.frame.size.width+self.frame.size.width;
            _movingLayer.layer.frame = ff;
            anchorPoint.x = 1;
        }
        CGFloat minY = CGRectGetMinY(self.movingLayer.frame);
        CGFloat maxY = CGRectGetMaxY(self.movingLayer.frame)-self.frame.size.height;
        minY = roundf(minY);
        maxY = roundf(maxY);
        if (minY>=0 && maxY<=0){
            anchorPoint.y = 0.5;
        }
        else if (minY<0 && maxY>0){
            if (CGPointEqualToPoint(self.movingLayer.center, self.center) ) {
                anchorPoint.y = 0.5;
            }else{
                CGPoint point = [sender locationInView:sender.view];//以两个点触摸点之间的位置作为锚点
                CGFloat y = (point.y-self.movingLayer.frame.origin.y)/self.movingLayer.frame.size.height;
                anchorPoint.y = y;
            }
        }
        else if (minY>=0 && maxY>0){
            CGRect ff = _movingLayer.layer.frame;
            ff.origin.y = 0;
            _movingLayer.layer.frame = ff;
            anchorPoint.y = 0;
        }
        else if (minY<=0 && maxY<=0) {
            CGRect ff = _movingLayer.layer.frame;
            ff.origin.y = -self.movingLayer.frame.size.height+self.frame.size.height;
            _movingLayer.layer.frame = ff;
            anchorPoint.y = 1;
        }
        CGRect oldFrame = _movingLayer.frame;
        _movingLayer.layer.anchorPoint = anchorPoint;
        _movingLayer.layer.frame = oldFrame;
        NSLog(@"放大时anchorPoint=%@",NSStringFromCGPoint(_movingLayer.layer.anchorPoint));
        [_movingLayer setTransform:CGAffineTransformScale(_movingLayer.transform, sender.scale, sender.scale)];
        
        
        //        //得到新的rect
        //        CGRect transformOldFrame = _openGLView.frame;
        //        CGRect transformNewFrame = CGRectApplyAffineTransform(_openGLView.frame, CGAffineTransformScale(_openGLView.transform, sender.scale, sender.scale));
        //        //此次缩放处于边界临界状态、存在两种锚点
        //        if (transformOldFrame.origin.x>0  && transformNewFrame.origin.x<0 ) {
        //
        //        }
        //        if (transformOldFrame.origin.x<0  && transformNewFrame.origin.x>0 ) {
        //
        //        }
        //        if (CGRectGetMaxX(transformOldFrame)-self.frame.size.width<0  && CGRectGetMaxX(transformNewFrame)-self.frame.size.width>0 ) {
        //
        //        }
        //        if (CGRectGetMaxX(transformOldFrame)-self.frame.size.width>0  && CGRectGetMaxX(transformNewFrame)-self.frame.size.width<0 ) {
        //
        //        }
        
        //检查修正某一次缩小时中心位置偏移(在某一次临界状态anchorPoint存在两种情况导致误差)
        if ( (_movingLayer.frame.origin.x>0) && (_movingLayer.frame.origin.x+_movingLayer.frame.size.width<self.frame.size.width )) {
            CGRect fframe = _movingLayer.frame;
            _movingLayer.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _movingLayer.layer.frame = fframe;

            CGPoint newCenter = _movingLayer.center;
            newCenter.x = self.center.x;
            _movingLayer.center = newCenter;
        }
        if ( (_movingLayer.frame.origin.y>0) && (_movingLayer.frame.origin.y+_movingLayer.frame.size.height<self.frame.size.height )) {
            CGRect fframe = _movingLayer.frame;
            _movingLayer.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _movingLayer.layer.frame = fframe;

            CGPoint newCenter = _movingLayer.center;
            newCenter.y = self.center.y;
            _movingLayer.center = newCenter;
        }
        
        sender.scale = 1.f;//恢复缩放系数
        [self moveingMouseFrameButNotOutBoundsWithOffset:CGPointZero];//检查缩放前后鼠标是否偏移

//        NSLog(@"缩放时anchorPoint=%@",NSStringFromCGPoint(anchorPoint));
    }
    //手势结束后修正位置
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        NSLog(@"放大结束时anchorPoint=%@",NSStringFromCGPoint(_movingLayer.layer.anchorPoint));

        BOOL equalToRect = CGRectEqualToRect(_movingLayer.frame, self.frame);
        //小于自动复原默认大小
        if (!equalToRect)
        {
            BOOL movingLayer_min = CGRectContainsRect(self.frame, _movingLayer.frame);     //返回是否第一个矩形包含了第二个矩形
            if (movingLayer_min)
            {//缩小了放大到最小尺寸
                CGRect oldFrame = _movingLayer.frame;
                _movingLayer.layer.anchorPoint = CGPointMake(0.5, 0.5);
                _movingLayer.layer.frame = oldFrame;
                [UIView animateWithDuration:0.25 animations:^{
                    if ([self isWidthGreaterHeight]) {
                        CGFloat scale = self.frame.size.width/self.movingLayer.frame.size.width;//无法整除时存在误差、只用于动画期间
                        [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
                    }else{
                        CGFloat scale = self.frame.size.height/self.movingLayer.frame.size.height;
                        [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
                    }
                } completion:^(BOOL finished) {
                    [self setOpenGLView_MinSize];//修正误差
                }];
            }else
            {//放大后缩放至最大尺寸
                if (self.center.x == _movingLayer.center.x || self.center.x == _movingLayer.center.x  ) {
//                    [self test];
                }
            }
        }
    }
}
//放大后缩放至最大存在两种锚点
-(void)test
{
    BOOL equalToRect = CGRectEqualToRect(_movingLayer.frame, self.frame);
    CGRect maxFrame = self.frame;
    maxFrame.origin.x    -= 40;
    maxFrame.origin.y    -= 40;
    maxFrame.size.width  += 80;
    maxFrame.size.height += 80;
    
    BOOL movingLayer_max = CGRectContainsRect(_movingLayer.frame,maxFrame);//返回是否第一个矩形包含了第二个矩形
    
    NSLog(@"%@",NSStringFromCGRect(self.movingLayer.frame));
    NSLog(@"%f",self.frame.size.height-_movingLayer.frame.origin.x);
    if (movingLayer_max && !equalToRect ) {
        
        CGRect oldFrame = _movingLayer.frame;
        CGFloat x = (self.center.x-self.movingLayer.frame.origin.x)/self.movingLayer.frame.size.width;
        CGFloat y = (self.center.y-self.movingLayer.frame.origin.y)/self.movingLayer.frame.size.height;
        //            _movingLayer.layer.anchorPoint = CGPointMake(x, y);
//        _movingLayer.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        _movingLayer.layer.frame = oldFrame;
        NSLog(@"结束时中心点%@==%@",NSStringFromCGPoint(self.center),NSStringFromCGPoint(self.movingLayer.center));
        NSLog(@"放大结束时anchorPoint=%@",NSStringFromCGPoint(_movingLayer.layer.anchorPoint));

//        UIView *test = [[UIView alloc] initWithFrame:self.movingLayer.frame];
//        test.tag = 888;
//        test.backgroundColor = [UIColor blueColor];
//        test.alpha = 0.4;
//        test.userInteractionEnabled = NO;
//        [self addSubview:test];
        
//        if (CGPointEqualToPoint( _movingLayer.layer.anchorPoint, CGPointMake(0.5, 0.5))) {
             [UIView animateWithDuration:0.25 animations:^{
                if ( ![self isWidthGreaterHeight]) {
                    CGFloat scale = self.frame.size.width/self.movingLayer.frame.size.width;//无法整除时存在误差、只用于动画期间
                    [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
                }else{
                    CGFloat scale = self.frame.size.height/self.movingLayer.frame.size.height;
                    [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
                }
            } completion:^(BOOL finished) {
            }];
//        }
        
        return;
        
        [UIView animateWithDuration:0.25 animations:^{
            if ( ![self isWidthGreaterHeight]) {
                CGFloat scale = self.frame.size.width/self.movingLayer.frame.size.width;//无法整除时存在误差、只用于动画期间
                [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
            }else{
                CGFloat scale = self.frame.size.height/self.movingLayer.frame.size.height;
                [self.movingLayer setTransform:CGAffineTransformScale(self.movingLayer.transform, scale, scale)];
            }
        } completion:^(BOOL finished) {
            NSLog(@"结束时%@==center",NSStringFromCGPoint(self.movingLayer.center));


//                            UIView *test = [[UIView alloc] initWithFrame:self.movingLayer.frame];
//                            test.tag = 666;
//                            test.backgroundColor = [UIColor blackColor];
//                            test.alpha = 0.5;
//                            test.userInteractionEnabled = NO;
//                            [self addSubview:test];
//            [UIView animateWithDuration:0.25 animations:^{

//                [self setOpenGLView_MaxSize];//修正缩放某一轴误差
//            }];

        }];
    }
}

#pragma mark 单指拖动movingLayer
- (void)panGes_monitor: (UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender translationInView:sender.view];//移动的是偏移量
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>拖动手势");
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGRect frame = self.movingLayer.frame;
        if ([self isHorizontalCanMove])
        {//处于放大时才可以拖动
            frame.origin.x+= point.x;
            if (frame.origin.x> 0.0)
            {
                frame.origin.x = 0.0;
            }
            else if (frame.origin.x+frame.size.width<self.frame.size.width)
            {
                frame.origin.x = -frame.size.width+self.frame.size.width;
            }
        }
        if ([self isVerticalCanMove])
        {
            frame.origin.y+= point.y;
            if (frame.origin.y> 0.0)
            {
                frame.origin.y = 0.0;
            }
            else if (frame.origin.y+frame.size.height<self.frame.size.height)
            {
                frame.origin.y = -frame.size.height+self.frame.size.height;
            }
        }
        self.movingLayer.frame = frame;
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
    }
}
#pragma mark - ===========Super Method============
-(void)layoutSubviews
{
    [super layoutSubviews];
//    NSLog(@"-------layoutSubviews");

}
-(void)setFrame:(CGRect)frame
{
    CGRect oldFrame = self.frame;
    [super setFrame:frame];
    
    if ( !CGRectEqualToRect(oldFrame, frame)) {
        NSLog(@"SWRCGesturesView setFrame");
        [self setOpenGLView_MinSize];
    }
}
//在视图移除时销毁定时器
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self deallocTimer];
    }
}
-(void)dealloc
{
    NSLog(@"SWRCGesturesView dealloc");
}

#pragma mark - Timer auto Moveing OpenGLView
-(BOOL)autoMoveingOpenGLViewWhenNeed
{
    BOOL isNeed = NO;//鼠标放于边界处自动移动OpenGLView
    if ([self isHorizontalCanMove] )
    {
        CGRect frame = _mouseImageView.frame;
        if (frame.origin.x == 0.0)
        {
            isNeed = YES;
        }
        else if (frame.origin.x== self.frame.size.width)
        {
            isNeed = YES;
        }
    }
    if ([self isVerticalCanMove])
    {
        CGRect frame = _mouseImageView.frame;
        if (frame.origin.y == 0.0)
        {
            isNeed = YES;
        }
        else if (frame.origin.y == self.frame.size.height)
        {
            isNeed = YES;
        }
    }
    if (isNeed) {
        [self addTimer];
        return YES;
    }else{
        [self deallocTimer];
        return NO;
    }
}
-(void)addTimer
{
    [self deallocTimer];
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(autoMoveingOpenGLView) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.autoMoveTimer = timer;
}
-(void)autoMoveingOpenGLView
{
    CGRect openGLFrame = self.movingLayer.frame;
    CGRect mouseFrame = _mouseImageView.frame;
    CGFloat offSet = 10;
    if ([self isHorizontalCanMove])
    {
        if (mouseFrame.origin.x== 0)
        {
            openGLFrame.origin.x +=offSet;//移动
            if (openGLFrame.origin.x> 0.0)
            {
                openGLFrame.origin.x = 0.0;
            }
        }
        else if (mouseFrame.origin.x== self.frame.size.width)
        {
            openGLFrame.origin.x -=offSet;
            if (openGLFrame.origin.x+openGLFrame.size.width<self.frame.size.width)
            {
                openGLFrame.origin.x = -openGLFrame.size.width+self.frame.size.width;
            }
        }
    }
    if ([self isVerticalCanMove])
    {
        if (mouseFrame.origin.y== 0.0)
        {
            openGLFrame.origin.y +=offSet;
            if (openGLFrame.origin.y> 0.0)
            {
                openGLFrame.origin.y = 0.0;
            }
        }
        else if (mouseFrame.origin.y== self.frame.size.height)
        {
            openGLFrame.origin.y -=offSet;
            if (openGLFrame.origin.y+openGLFrame.size.height<self.frame.size.height)
            {
                openGLFrame.origin.y = -openGLFrame.size.height+self.frame.size.height;
            }
        }
    }
    self.movingLayer.frame = openGLFrame;
}
-(void)deallocTimer
{
    if (_autoMoveTimer && _autoMoveTimer.isValid) {
        [_autoMoveTimer invalidate];
        _autoMoveTimer=nil;
    }
}


#pragma mark - delegate
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    NSLog(@"gestureRecognizerShouldBegin %@",(long)gestureRecognizer.name);
//    return YES;
//}
//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
////    NSLog(@"gestureRecognizerShouldBegin %ld  %ld",(long)gestureRecognizer.state ,otherGestureRecognizer.state);
////
//    if ([gestureRecognizer isEqual:self.tapGes_pointer_pointTwo] && [otherGestureRecognizer isEqual:self.longPressGes_pointer]) {
//        return NO;
//    }
//    return YES;
//}

// called once per attempt to recognize, so failure requirements can be determined lazily and may be set up between recognizers across view hierarchies
// return YES to set up a dynamic failure requirement between gestureRecognizer and otherGestureRecognizer
//
// note: returning YES is guaranteed to set up the failure requirement. returning NO does not guarantee that there will not be a failure requirement as the other gesture's counterpart delegate or subclass methods may return YES
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);

// called before touchesBegan:withEvent: is called on the gesture recognizer for a new touch. return NO to prevent the gesture recognizer from seeing this touch
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
//
@end
