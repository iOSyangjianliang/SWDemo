//
//  SWRCGesturesView.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
// 注意:self.frame.origin目前只适配了{0,0}

#import "SWRCGesturesView.h"
#import "AudioToolbox/AudioToolbox.h"//调用系统震动

@interface SWRCGesturesView ()<UIGestureRecognizerDelegate>
@property(nonatomic, strong, nullable) UIPinchGestureRecognizer *pichGes_monitor;//捏合缩放窗口
@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_monitor;//拖动显示窗口

@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_pointer;//单指拖动
@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_pointer_twoPoint;//双指拖动(类似鼠标滚轮效果)
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer;//单指单击
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer_twoPoint;//双指单击
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_pointer_pointTwo;//单指双击
@property(nonatomic, strong, nullable) UILongPressGestureRecognizer *longPressGes_pointer;//单指双击后长按（左键按住拖动）

@property(nonatomic, strong, nullable) UIPanGestureRecognizer *panGes_pointer_twoTouch;//双指拖动(类似鼠标滚轮效果)
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_touch;//单指单击
@property(nonatomic, strong, nullable) UITapGestureRecognizer *tapGes_touchTwo;//单指双击
@property(nonatomic, strong, nullable) UILongPressGestureRecognizer *longPressGes_touch;//单击长按（右键单击）
@property(nonatomic, strong, nullable) UILongPressGestureRecognizer *longPressGes_touch_touchTwo;//单指双击后长按（左键按住拖动）

@property(nonatomic, weak, nullable) UIImageView *mouseImageView;//鼠标
@property(nonatomic, strong, nullable) UIImageView *bluePointImageView;//鼠标指示蓝点

@property(nonatomic, strong, nullable) SWRCTouchAnimatedView *touchAnimatedView;//触屏动画view

@property(nonatomic, assign) CGPoint lastLongPressMovePoint;//长按移动计算偏移量

@property(nonatomic, weak) NSTimer *autoMoveTimer;//放大时移动鼠标到边界时、自动移动openGLView（每秒移动50次*10像素/每次）

@property(nonatomic, assign) UIEdgeInsets glSectionInset;//内部方法、暂不开放

@property(nonatomic, assign) BOOL isOpenGLViewMinSize;//缩放直最小

//@property(nonatomic, strong) NSDate *curryDate;//时间控制、每秒发送鼠标坐标信号次数

@property (nonatomic, strong) UIDynamicAnimator *animator;//触屏物理仿真

@end

@implementation SWRCGesturesView
#pragma mark - glSectionInset.bottom
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self registerForKeyboardNotifications];
        [self initRCGData];
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}
-(void)initRCGData
{
    [self setGLSectionInset];
}
-(void)setGLSectionInset
{
    if (@available(iOS 11.0, *)) {
        CGFloat safeTop = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.top;
        CGFloat safeLeft = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.left;
        CGFloat safeBottom = [self sw_safeAreaInsetsBottom];
        CGFloat safeRight = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.right;
        safeTop = safeTop>34.f?34.f:safeTop;
        safeLeft = safeLeft>34.f?34.f:safeLeft;
        safeBottom = safeBottom>34.f?34.f:safeBottom;
        safeRight = safeRight>34.f?34.f:safeRight;
        self.glSectionInset = UIEdgeInsetsMake(safeTop, safeLeft, safeBottom, safeRight);
        
        _glSectionInset.bottom = safeBottom;
    }
}
-(CGFloat)sw_safeAreaInsetsBottom
{
    CGFloat safeBottom = 0.f;
    BOOL isHD = ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight);
    if (isHD)
    {//横屏时、留海适配
        return 0.0;
    }
    
    if (@available(iOS 11.0, *)) {
        safeBottom = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom;
    }
    return safeBottom;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat sectionInsetBottom = rect.size.height+4 ;
    [self setSectionInsetBottom:sectionInsetBottom animatedTime:duration];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGFloat sectionInsetBottom = [self sw_safeAreaInsetsBottom];
    [self setSectionInsetBottom:sectionInsetBottom animatedTime:duration];
}
- (void)keyboardDidHide:(NSNotification *)noti
{
    [self automaticallyRestoreMinSizeIfNeed];//eg：横屏时弹出键盘后缩放最小后再收起键盘
}
#pragma mark - glSectionInset.bottom
-(void)setSectionInsetBottom:(CGFloat)sectionInsetBottom animated:(BOOL)animated
{
    [self setSectionInsetBottom:sectionInsetBottom animatedTime:0.25];
}
-(void)setSectionInsetBottom:(CGFloat)sectionInsetBottom animatedTime:(NSTimeInterval)aTime
{
    if (self.glSectionInset.bottom == sectionInsetBottom){
        return;
    }
    NSLog(@"setglSectionInset.bottom %.2f",sectionInsetBottom);

    CGFloat oldSectionInsetBottom = self.glSectionInset.bottom;
    CGFloat oldMouseYPercent;
    if (self.gesturesMode == SWRCGesturesMode_pointer)
    {
        oldMouseYPercent = (self.mouseImageView.frame.origin.y-self.openGLView.frame.origin.y)/self.openGLView.frame.size.height;
    }else{
        oldMouseYPercent = (((self.frame.size.height-oldSectionInsetBottom+self.glSectionInset.top)/2)-self.openGLView.frame.origin.y)/self.openGLView.frame.size.height;;
    }
    
    //修改
    UIEdgeInsets edg = self.glSectionInset;
    edg.bottom = sectionInsetBottom;
    self.glSectionInset = edg;
    
    CGPoint contentFocalPoint;
    if (self.gesturesMode == SWRCGesturesMode_pointer || self.gesturesMode == SWRCGesturesMode_pointerBorder)
    {
        contentFocalPoint = self.mouseImageView.frame.origin;
        
    }else{
        contentFocalPoint = CGPointMake(self.frame.size.width/2, (self.frame.size.height-oldSectionInsetBottom+self.glSectionInset.top)/2);
    }
    //(鼠标、内容中心)在openGLView下半部分
    BOOL mouseIsDown = contentFocalPoint.y>=CGRectGetMidY(self.openGLView.frame)?YES:NO;
    BOOL biggerHeight = self.openGLView.frame.size.height>(self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top);
    CGFloat newHeightHalf = (self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top)/2;
    
    CGPoint anchorPoint;
    CGPoint position;
    CGFloat anchorPointX = (contentFocalPoint.x-self.openGLView.frame.origin.x)/self.openGLView.frame.size.width;
    if (mouseIsDown)
    {
        //鼠标距离openGLView底部距离
        CGFloat bottomSpacing = CGRectGetMaxY(self.openGLView.frame)-contentFocalPoint.y;
        if (biggerHeight && bottomSpacing<=newHeightHalf )
        {//底部靠边
            anchorPoint = CGPointMake(anchorPointX, 1);
            position =  CGPointMake(contentFocalPoint.x, self.frame.size.height-self.glSectionInset.bottom);
        }
        else
        {//放中心
            if (biggerHeight) {
                anchorPoint = CGPointMake(anchorPointX, oldMouseYPercent);//把鼠标指向的内容移动到新范围的中心(Y值)
            }else{
                anchorPoint = CGPointMake(anchorPointX, 0.5);//把openGLView中心点Y值放入新范围的中心(Y值)
            }
            position =  CGPointMake(contentFocalPoint.x, [self getDisplayCenter].y);
        }
    }else
    {
        //鼠标距离openGLView顶部距离
        CGFloat topSpacing = contentFocalPoint.y- CGRectGetMinY(self.openGLView.frame);
        if (biggerHeight && topSpacing<=newHeightHalf)
        {//顶部靠边
            anchorPoint = CGPointMake(anchorPointX, 0);
            position =  CGPointMake(contentFocalPoint.x, 0.0+self.glSectionInset.top);
        }
        else
        {//放中心
            if (biggerHeight) {
                anchorPoint = CGPointMake(anchorPointX, oldMouseYPercent);
            }else{
                anchorPoint = CGPointMake(anchorPointX, 0.5);
            }
            position =  CGPointMake(contentFocalPoint.x, [self getDisplayCenter].y);
        }
    }
    //移动OpenGLView
    [self changeOpenGLViewFrame:anchorPoint position:position animatedTime:aTime ];
    
    
    if (self.gesturesMode == SWRCGesturesMode_pointer || self.gesturesMode == SWRCGesturesMode_pointerBorder)
    {
        //移动mouseImageView
        CGFloat newOpenGLViewFrameY = position.y - anchorPoint.y * self.openGLView.frame.size.height;
        if (aTime>0.0) {
            [UIView animateWithDuration:aTime animations:^{
                CGRect mouseFrame = self.mouseImageView.frame;
                mouseFrame.origin.y = oldMouseYPercent*self.openGLView.frame.size.height+newOpenGLViewFrameY;
                self.mouseImageView.frame = mouseFrame;
            } completion:^(BOOL finished) {
            }];
        }else{
            CGRect mouseFrame = self.mouseImageView.frame;
            mouseFrame.origin.y = oldMouseYPercent*self.openGLView.frame.size.height+newOpenGLViewFrameY;
            self.mouseImageView.frame = mouseFrame;
        }
    }
}
-(void)changeOpenGLViewFrame:(CGPoint)anchorPoint position:(CGPoint)position animatedTime:(NSTimeInterval)aTime
{
    NSLog(@"change OpenGLView Frame");
    CGFloat newOpenGLViewFrameY = position.y - anchorPoint.y * self.openGLView.frame.size.height;
    if (aTime>0.0) {
        [UIView animateWithDuration:aTime animations:^{
           
            CGRect oldFrame = self.openGLView.frame;
            oldFrame.origin.y = newOpenGLViewFrameY;
            self.openGLView.layer.frame = oldFrame;
        }completion:^(BOOL finished) {
        }];
    }else{
        CGRect oldFrame = self.openGLView.frame;
        oldFrame.origin.y = newOpenGLViewFrameY;
        self.openGLView.layer.frame = oldFrame;
    }
}
#pragma mark - setOpenGLView
-(void)setOpenGLView:(SWRCOpenGLView *)openGLView
{
    if (openGLView ) {
        if (![_openGLView isEqual:openGLView])
        {
            [_openGLView removeFromSuperview];
            _openGLView = openGLView;
            
            [self addSubview:_openGLView];
            [self setOpenGLView_MinSize];
            [self bringSubviewToFront:_mouseImageView];
        }
    }else{
        [_openGLView removeFromSuperview];
        [_mouseImageView removeFromSuperview];
        _openGLView = openGLView;
    }
}
-(UIImageView *)mouseImageView
{
    if (!_mouseImageView && (self.gesturesMode == SWRCGesturesMode_pointer || self.gesturesMode == SWRCGesturesMode_pointerBorder)) {
        CGRect frame = CGRectMake([self getDisplayCenter].x, [self getDisplayCenter].y, 39.f/4, 71.f/4);
        UIImageView *mouseIMV = [[UIImageView alloc] initWithFrame:frame];
        mouseIMV.image = [UIImage imageNamed:@"mouse"];
        [self addSubview:mouseIMV];
        _mouseImageView = mouseIMV;
    }
    return _mouseImageView;
}
-(UIImageView *)bluePointImageView
{//蓝点、配合鼠标指向边界时使用
    if (!_bluePointImageView ) {
        UIImageView *blueIMV = [[UIImageView alloc] initWithFrame:CGRectMake(self.mouseImageView.frame.origin.x-16-0.5, self.mouseImageView.frame.origin.y-16-0.5, 32, 32)];
        blueIMV.image = [UIImage imageNamed:@"blue"];
        [self addSubview:blueIMV];
        
        UIImageView *blueSub = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        blueSub.image = [UIImage imageNamed:@"blue"];//更亮点
        [blueIMV addSubview:blueSub];
        
        _bluePointImageView = blueIMV;
    }
    return _bluePointImageView;
}
-(SWRCTouchAnimatedView *)touchAnimatedView
{
    if (!_touchAnimatedView) {
        SWRCTouchAnimatedView *touchLayer = [[SWRCTouchAnimatedView alloc] init];
        _touchAnimatedView = touchLayer;
    }
    [self addSubview:_touchAnimatedView];
    return _touchAnimatedView;
}
#pragma maark - ===调整展示层openGLView大小===
-(void)setOpenGLView_MinSize
{
    //重置锚点（缩放时修改了）
    CGRect frame = self.openGLView.frame;
    _openGLView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _openGLView.layer.frame = frame;

    if ([self isWidthGreaterHeight])
    {//横条形宽高比例图
        frame.size.width = self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right;
        frame.size.height = frame.size.width/self.openGLView.frameSize.width* self.openGLView.frameSize.height;//该轴有误差
    }else
    {//竖条形宽高比例图
        frame.size.height = self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top;
        frame.size.width = frame.size.height/self.openGLView.frameSize.height* self.openGLView.frameSize.width;
    }
    _openGLView.frame = frame;
    _openGLView.center = [self getDisplayCenter];
    
    _isOpenGLViewMinSize = YES;
}
-(void)setOpenGLView_MaxSize
{
    //重置锚点（缩放时修改了）
    CGRect frame = self.openGLView.frame;
    _openGLView.layer.anchorPoint = CGPointMake(0.5, 0.5);
    _openGLView.layer.frame = frame;
   
    CGPoint center = self.openGLView.center;
    if ( ![self isWidthGreaterHeight])
    {//横条形宽高比例图
        frame.size.width = self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right;
        frame.size.height = frame.size.width/self.openGLView.frameSize.width* self.openGLView.frameSize.height;//该轴有误差
        center.x = [self getDisplayCenter].x;
    }else
    {//竖条形宽高比例图
        frame.size.height = self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top;
        frame.size.width = frame.size.height/self.openGLView.frameSize.height* self.openGLView.frameSize.width;
        center.y = [self getDisplayCenter].y;
    }
    _openGLView.frame = frame;
    _openGLView.center = center;

}
-(CGPoint)getDisplayCenter
{
   return  CGPointMake((self.frame.size.width-self.glSectionInset.right+self.glSectionInset.left)/2, (self.frame.size.height-self.glSectionInset.bottom+self.glSectionInset.top)/2);
}
-(BOOL)isWidthGreaterHeight
{//相对于手机屏幕是否是横条形宽高比例图
    return self.openGLView.frameSize.width/self.openGLView.frameSize.height>(self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right)/(self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top);
}
#pragma mark - =========== 设置手势模式============
-(void)setGesturesMode:(SWRCGesturesMode)gesturesMode
{
    SWRCGesturesMode oldGesturesMode = _gesturesMode;
    if (_gesturesMode != gesturesMode)
    {
        _gesturesMode = gesturesMode;
        if (gesturesMode == SWRCGesturesMode_monitor)
        {
            [_mouseImageView removeFromSuperview];
            [_touchAnimatedView removeFromSuperview];
            [self sw_removeAllRCGestureRecognizer];
            [self registerGesture_Monitor];
        }
        else if (gesturesMode == SWRCGesturesMode_pointer || gesturesMode == SWRCGesturesMode_pointerBorder )
        {
            [_touchAnimatedView removeFromSuperview];
            if (oldGesturesMode == SWRCGesturesMode_pointer || oldGesturesMode == SWRCGesturesMode_pointerBorder )
            {

            }else{
                [self sw_removeAllRCGestureRecognizer];
                [self registerGesture_Pointer];
            }
            [self bringSubviewToFront:self.mouseImageView];
        }
        else if (gesturesMode == SWRCGesturesMode_touch)
        {
            [_mouseImageView removeFromSuperview];
            [self sw_removeAllRCGestureRecognizer];
            [self registerGesture_touch];
        }
        else
        {
            [_mouseImageView removeFromSuperview];
            [_touchAnimatedView removeFromSuperview];
            [self sw_removeAllRCGestureRecognizer];
        }
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
    //
    if (self.panGes_pointer_twoTouch && self.panGes_pointer_twoTouch.view) {
        [self.panGes_pointer_twoTouch.view removeGestureRecognizer:self.panGes_pointer_twoTouch];
        self.panGes_pointer_twoTouch = nil;
    }
    if (self.tapGes_touch && self.tapGes_touch.view) {
        [self.tapGes_touch.view removeGestureRecognizer:self.tapGes_touch];
        self.tapGes_touch = nil;
    }
    if (self.tapGes_touchTwo && self.tapGes_touchTwo.view) {
        [self.tapGes_touchTwo.view removeGestureRecognizer:self.tapGes_touchTwo];
        self.tapGes_touchTwo = nil;
    }
    if (self.longPressGes_touch && self.longPressGes_touch.view) {
        [self.longPressGes_touch.view removeGestureRecognizer:self.longPressGes_touch];
        self.longPressGes_touch = nil;
    }
    if (self.longPressGes_touch_touchTwo && self.longPressGes_touch_touchTwo.view) {
        [self.longPressGes_touch_touchTwo.view removeGestureRecognizer:self.longPressGes_touch_touchTwo];
        self.longPressGes_touch_touchTwo = nil;
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
//    UIPanGestureRecognizer *panGes2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes_Pointer_twoPoint:)];
//    panGes2.minimumNumberOfTouches = 2;
//    panGes2.maximumNumberOfTouches = 2;
//    [self addGestureRecognizer:panGes2];
//    self.panGes_pointer_twoPoint = panGes2;

    //单指单击
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes_Pointer:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes];
    self.tapGes_pointer = tapGes;

    //单指双击
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes2_Pointer:)];
    tapGes2.numberOfTapsRequired = 2;
    tapGes2.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes2];
    [tapGes requireGestureRecognizerToFail:tapGes2];//单指双击时,取消单指单击事件，会导致单击响应变慢(此处不能取消，虽然另外一次可由单击触发发送给控制端，但不取消会影响longPressGes手势多触发一次单击）
    self.tapGes_pointer_pointTwo = tapGes2;

    //双指单击(右键单击)
    UITapGestureRecognizer *tapGes3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes3_Pointer:)];
    tapGes3.numberOfTapsRequired = 1;
    tapGes3.numberOfTouchesRequired = 2;
    [self addGestureRecognizer:tapGes3];
    self.tapGes_pointer_twoPoint = tapGes3;

    //双击后不松开0.35s
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes_Pointer:)];
    longPressGes.numberOfTapsRequired = 1;
    longPressGes.numberOfTouchesRequired = 1;
    longPressGes.minimumPressDuration = 0.35;
    [self addGestureRecognizer:longPressGes];
//    [tapGes requireGestureRecognizerToFail:longPressGes];//双击后,取消单指单击事件
    self.longPressGes_pointer = longPressGes;
    
}
#pragma mark 触屏模式
-(void)registerGesture_touch
{
    [self registerGesture_Monitor];
    
    //双指拖动(类似鼠标滚轮效果)
//    UIPanGestureRecognizer *panGes2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes_touch_twoTouch:)];
//    panGes2.minimumNumberOfTouches = 2;
//    panGes2.maximumNumberOfTouches = 2;
//    [self addGestureRecognizer:panGes2];
//    self.panGes_pointer_twoTouch = panGes2;
    
    //单指单击
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes_touch:)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes];
    self.tapGes_touch = tapGes;
    self.tapGes_touch.delegate = self;
    
    //单指双击
    UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes2_touch:)];
    tapGes2.numberOfTapsRequired = 2;
    tapGes2.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGes2];
    [tapGes requireGestureRecognizerToFail:tapGes2];//单指双击时,取消单指单击事件，会导致单击响应变慢(此处不能取消，虽然另外一次可由单击触发发送给控制端，但不取消会影响longPressGes手势多触发一次单击）
    self.tapGes_touchTwo = tapGes2;
    self.tapGes_touchTwo.delegate = self;

    //单击长按（右键单击）
    UILongPressGestureRecognizer *longPressGesOne = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes_touch:)];
    longPressGesOne.numberOfTapsRequired = 0;
    longPressGesOne.numberOfTouchesRequired = 1;
    longPressGesOne.minimumPressDuration = 1.f;
    [self addGestureRecognizer:longPressGesOne];
    self.longPressGes_touch = longPressGesOne;
    
    //双击后不松开0.35s（左键按住拖动）
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes_touchTwo:)];
    longPressGes.numberOfTapsRequired = 1;
    longPressGes.numberOfTouchesRequired = 1;
    longPressGes.minimumPressDuration = 0.35;
    [self addGestureRecognizer:longPressGes];
    self.longPressGes_touch_touchTwo = longPressGes;
    
}
#pragma mark - ===========触屏模式============
//双指拖动(类似鼠标滚轮效果)
- (void)panGes_touch_twoTouch:(UIPanGestureRecognizer *)sender
{
    
}
//单指单击
- (void)tapGes_touch:(UITapGestureRecognizer *)sender
{
    NSLog(@"触屏-单指单击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [sender locationInView:sender.view];
        if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
        {
            [self touchMode_gesturesType:SWRCGesturesType_point touchPoint:touchPoint state:UIGestureRecognizerStateEnded];
            [self gesturesBegainToastMessage:SWRCGesturesType_point];
        }
    }
}
//单指双击
- (void)tapGes2_touch:(UITapGestureRecognizer *)sender
{
    NSLog(@"触屏-单指双击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint touchPoint = [sender locationInView:sender.view];
        if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
        {
            [self touchMode_gesturesType:SWRCGesturesType_pointTwo touchPoint:touchPoint  state:UIGestureRecognizerStateEnded];
            [self gesturesBegainToastMessage:SWRCGesturesType_drag];

        }
    }
}
//单击长按（右键单击）
- (void)longPressGes_touch:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"触屏-正在开始识别>>单击长按（右键单击）");
        CGPoint touchPoint  = [sender locationInView:sender.view];

        if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
        {
            [self touchFeedBack];
            self.touchAnimatedView.touchPoint = touchPoint;
            [self.touchAnimatedView showHighlighted:YES];
            
            [self touchMode_gesturesType:SWRCGesturesType_longPressClick touchPoint:touchPoint state:UIGestureRecognizerStateBegan];
            [self touchMode_gesturesType:SWRCGesturesType_longPressClick touchPoint:touchPoint state:UIGestureRecognizerStateEnded];
            [self gesturesBegainToastMessage:SWRCGesturesType_longPressClick];
        }
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
    }
    //手势结束后检查修正位置
    if (sender.state == UIGestureRecognizerStateEnded)
    {
//        [self.touchAnimatedView removeFromSuperview];
//        CGPoint touchPoint = [sender locationInView:sender.view];
//        [self touchMode_gesturesType:SWRCGesturesType_longPressClick touchPoint:touchPoint state:UIGestureRecognizerStateEnded];
    }
    
}
-(void)touchFeedBack
{
    if (@available(iOS 10.0, *)) {
        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [impactLight impactOccurred];//只有打开了设置中系统触感反馈才有效果
    }
}
//双击后不松开0.35s（左键按住拖动）
- (void)longPressGes_touchTwo:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"触屏-正在开始识别>>双击后不松开0.35s（左键按住拖动）");
        CGPoint touchPoint  = [sender locationInView:sender.view];
        _lastLongPressMovePoint = touchPoint;
        if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
        {
            [self touchFeedBack];
            self.touchAnimatedView.touchPoint = touchPoint;
            [self.touchAnimatedView showHighlighted:YES];
            
            [self touchMode_gesturesType:SWRCGesturesType_drag touchPoint:touchPoint state:UIGestureRecognizerStateBegan];
            [self gesturesBegainToastMessage:SWRCGesturesType_drag];
        }
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint touchPoint = [sender locationInView:sender.view];
        if (CGRectContainsPoint(self.openGLView.frame, _lastLongPressMovePoint))
        {//从openGLView画面内触发手势才有效
            [self touchMode_gesturesType:SWRCGesturesType_pointMove touchPoint:touchPoint state:UIGestureRecognizerStateChanged];
        }
    }
    //手势结束后检查修正位置
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self.touchAnimatedView removeFromSuperview];
        
        CGPoint touchPoint = [sender locationInView:sender.view];
        if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
        {
            [self touchMode_gesturesType:SWRCGesturesType_drag touchPoint:touchPoint state:UIGestureRecognizerStateEnded];//drag end
        }
    }
}

#pragma mark - ===========指针模式============
- (void)tapGes_Pointer:(UITapGestureRecognizer *)sender
{
    NSLog(@"单指单击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pointerMode_gesturesType:SWRCGesturesType_point state:UIGestureRecognizerStateEnded];
        [self gesturesBegainToastMessage:SWRCGesturesType_point];
    }
}
- (void)tapGes2_Pointer:(UITapGestureRecognizer *)sender
{
    NSLog(@"单指双击%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pointerMode_gesturesType:SWRCGesturesType_pointTwo state:UIGestureRecognizerStateEnded];
        [self gesturesBegainToastMessage:SWRCGesturesType_pointTwo];
    }
}
- (void)tapGes3_Pointer:(UITapGestureRecognizer *)sender
{
    NSLog(@"双指单击(右键单击)%ld",(long)sender.state);
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self pointerMode_gesturesType:SWRCGesturesType_twoPoint state:UIGestureRecognizerStateEnded];
        [self gesturesBegainToastMessage:SWRCGesturesType_twoPoint];

    }
}

//双击后长按手势
- (void)longPressGes_Pointer:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>长按手势");
        _lastLongPressMovePoint = [sender locationInView:sender.view];

        _mouseImageView.backgroundColor = [UIColor redColor];
        
        [self pointerMode_gesturesType:SWRCGesturesType_drag state:UIGestureRecognizerStateBegan];//drag Began
        [self gesturesBegainToastMessage:SWRCGesturesType_drag];
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [sender locationInView:sender.view];
        CGPoint offSet = CGPointMake(point.x-_lastLongPressMovePoint.x, point.y-_lastLongPressMovePoint.y);//计算偏移量
        _lastLongPressMovePoint = point;
        //移动系数放大、缩小
//        offSet.x = offSet.x*_mouseMoveCoefficient;
//        offSet.y = offSet.y*_mouseMoveCoefficient;
        
        if (self.gesturesMode==SWRCGesturesMode_pointerBorder)
        {
            [self moveingMouseFrameButNotOutBoundsWithOffset:offSet];//移动鼠标
            [self autoMoveingOpenGLViewWhenNeed];//检查是否处于放大模式并自动移动openGLView
        }else{
            [self moveingMouseOrOpenGLViewWithOffset:offSet];
        }
    }
    //手势结束后检查修正位置
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        _mouseImageView.backgroundColor = [UIColor clearColor];
        
        [self deallocTimer];
        
        [self pointerMode_gesturesType:SWRCGesturesType_drag state:UIGestureRecognizerStateEnded];//drag Began
    }
    
}

//单指拖动(鼠标)
- (void)panGes_Pointer:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"单指拖动(鼠标)");
//        self.curryDate = [NSDate date];
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {//持续移动中系统20ms左右便触发一次
        CGPoint offSet = [sender translationInView:sender.view];//移动的是偏移量
       
        
//        CGPoint pointV = [sender velocityInView:sender.view];//滑动速度（像素/每秒）
//        //        RCLog(@"====%@", NSStringFromCGPoint(pointV));
//        CGFloat moveCoefficientX = ABS(pointV.x)*1.f/1200.f+1.f;
//        CGFloat moveCoefficientY = ABS(pointV.y)*1.f/1200.f+1.f;
//        moveCoefficientX=moveCoefficientX>1.2?1.2:moveCoefficientX;
//        moveCoefficientY=moveCoefficientY>1.2?1.2:moveCoefficientY;
//
//        //移动系数
//        offSet.x = offSet.x*moveCoefficientX;
//        offSet.y = offSet.y*moveCoefficientY;
        
        
        CGPoint pointV = [sender velocityInView:sender.view];//滑动速度（像素/每秒）
        //        NSLog(@"====%@", NSStringFromCGPoint(pointV));
        
        CGFloat H = (_openGLView.frame.size.height-300)/1000.f;
        H = H>2.0?2.0:H;
        
        NSLog(@"鼠标移动-画面系数 H=%.2f",H);

        CGFloat penX = ABS(pointV.x)/500.f;//速度
        penX = penX>1.f?1.f:penX;
        
        CGFloat penY = ABS(pointV.y)/500.f;
        penY = penY>1.f?1.f:penY;

        NSLog(@"鼠标移动-速度 penX=%.2f  penY=%.2f", penX,penY);

        penX = 1.0+0.1*penX+0.30*H;
        penY = 1.0+0.1*penY+0.30*H;
        

        
        NSLog(@"鼠标移动-系数==%.2f==%.2f", penX,penY);
        
        
        offSet.x = offSet.x *penX;
        offSet.y = offSet.y *penY;
        
        
        if (self.gesturesMode==SWRCGesturesMode_pointerBorder)
        {
            [self moveingMouseFrameButNotOutBoundsWithOffset:offSet];//移动鼠标
            [self autoMoveingOpenGLViewWhenNeed];//检查是否处于放大模式并自动移动openGLView
        }else{
            [self moveingMouseOrOpenGLViewWithOffset:offSet];
        }
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self deallocTimer];
    }
}
//鼠标移动中心时，鼠标不动openGLFrame移动
-(void)moveingMouseOrOpenGLViewWithOffset:(CGPoint)offset
{
    NSLog(@"moveingMouseOrOp===%@",NSStringFromCGPoint(offset));
    CGRect oldMouseframe = _mouseImageView.frame;
    CGRect newMouseframe = _mouseImageView.frame;
    newMouseframe.origin.x+= offset.x ;
    newMouseframe.origin.y+= offset.y ;
    if (offset.x>0) {//精度0.001
        newMouseframe.origin.x+= 0.001;
    }else{
        newMouseframe.origin.x-= 0.001;
    }
    if (offset.y>0) {
        newMouseframe.origin.y+= 0.001;
    }else{
        newMouseframe.origin.y-= 0.001;
    }
    
    CGRect openGLFrame = self.openGLView.frame;
    CGPoint openGLOffset = CGPointZero;
    CGPoint mouseOffset = offset;//
    
    CGFloat oldMouseX = oldMouseframe.origin.x - [self getDisplayCenter].x;
    CGFloat oldMouseY = oldMouseframe.origin.y - [self getDisplayCenter].y;

    CGFloat newMouseX = newMouseframe.origin.x - [self getDisplayCenter].x;
    CGFloat newMouseY = newMouseframe.origin.y - [self getDisplayCenter].y;

    if (offset.x>0.0 && openGLFrame.origin.x+openGLFrame.size.width>(self.frame.size.width-self.glSectionInset.right))
    {//手指往右滑
        if (oldMouseX< 0.0 && newMouseX> 0.0)
        {//offset一部分给鼠标偏移、一部分给openGLView偏移
            openGLOffset.x = -newMouseX;
            mouseOffset.x = -oldMouseX;
        }
        if (oldMouseX> 0.0)
        {//鼠标不动，offset全部给openGLView偏移
            openGLOffset.x = -offset.x;
            mouseOffset.x = 0.0;
        }
    }
    if (offset.x<0.0 && openGLFrame.origin.x< (0.0+self.glSectionInset.left) )
    {//手指往左滑
        if (oldMouseX> 0.0 && newMouseX< 0.0)
        {
            openGLOffset.x = -newMouseX;
            mouseOffset.x = -oldMouseX;
        }
        if (oldMouseX< 0.0)
        {
            openGLOffset.x = -offset.x;
            mouseOffset.x = 0.0;
        }
    }
    if (offset.y<0.0 && openGLFrame.origin.y< (0.0+self.glSectionInset.top) )
    {//手指往上滑
        if (oldMouseY> 0.0 && newMouseY< 0.0)
        {
            openGLOffset.y = -newMouseY ;
            mouseOffset.y =  -oldMouseY;
        }
        if (oldMouseY< 0.0)
        {
            openGLOffset.y = -offset.y;
            mouseOffset.y = 0.0;
        }
    }
    if (offset.y>0.0 && openGLFrame.origin.y+openGLFrame.size.height>(self.frame.size.height-self.glSectionInset.bottom) )
    {//手指往下滑
        if (oldMouseY< 0.0 && newMouseY> 0.0)
        {
            openGLOffset.y = -newMouseY ;
            mouseOffset.y =  -oldMouseY;
        }
        if (oldMouseY> 0.0)
        {
            openGLOffset.y = -offset.y;
            mouseOffset.y = 0.0;
        }
    }
    
    //移动鼠标
    [self moveingMouseFrameButNotOutBoundsWithOffset:mouseOffset];
    
    //移动openGLView
    CGRect newFrame = [self moveingAndCheckOpenGLViewWithOffset:openGLOffset];
    BOOL isEqual = CGPointEqualToPoint(openGLFrame.origin, newFrame.origin);
    if (!isEqual)
    {//鼠标相对于openGLView位置改变
        
//        NSLog(@"BBBB——2");
        [self pointerMode_gesturesType:SWRCGesturesType_pointMove state:UIGestureRecognizerStateChanged];
        
        self.openGLView.frame = newFrame;
    }
}
//鼠标进行一次平移，并自动检查该次平移是否超出边界（不能超出屏幕减去上下间距、也不能超出openGLView）offset:鼠标偏移量
-(void)moveingMouseFrameButNotOutBoundsWithOffset:(CGPoint)offset
{
    if (CGPointEqualToPoint(offset, CGPointZero)) {
        return;
    }
    [self.bluePointImageView removeFromSuperview];

    //偏移
    CGRect newMouseFrame = _mouseImageView.frame;
    newMouseFrame.origin.x+= offset.x;
    newMouseFrame.origin.y+= offset.y;
  
    //检查是否超界
    newMouseFrame.origin = [self checkMouseFrameButNotOutBounds:newMouseFrame.origin];
    
    BOOL isEqual = CGPointEqualToPoint(_mouseImageView.frame.origin, newMouseFrame.origin);//移动到边界时由定时器移动负责调用代理
    
    if (!isEqual)
    {//鼠标位置改变
        _mouseImageView.frame = newMouseFrame;
        [self pointerMode_gesturesType:SWRCGesturesType_pointMove state:UIGestureRecognizerStateChanged];
        
    }
}
//检查鼠标不能超出屏幕、也不能超出openGLView。eg:竖条图展示
-(CGPoint)checkMouseFrameButNotOutBounds:(CGPoint)mouseOrigin
{
    CGFloat minX = CGRectGetMinX(self.openGLView.frame)>(0.0+self.glSectionInset.left)?CGRectGetMinX(self.openGLView.frame) : (0.0+self.glSectionInset.left);
    CGFloat maxX = CGRectGetMaxX(self.openGLView.frame) > (CGRectGetWidth(self.frame)-self.glSectionInset.right) ? (CGRectGetWidth(self.frame)-self.glSectionInset.right) :CGRectGetMaxX(self.openGLView.frame) ;
    if (mouseOrigin.x< minX)
    {
        mouseOrigin.x = minX;
    }
    else if (mouseOrigin.x> maxX)
    {
        mouseOrigin.x = maxX;
    }
    
    CGFloat minY = CGRectGetMinY(self.openGLView.frame)>(0.0+self.glSectionInset.top)?CGRectGetMinY(self.openGLView.frame) : (0.0+self.glSectionInset.top);
    CGFloat maxY = CGRectGetMaxY(self.openGLView.frame) > (CGRectGetHeight(self.frame) -self.glSectionInset.bottom)? (CGRectGetHeight(self.frame) -self.glSectionInset.bottom) :CGRectGetMaxY(self.openGLView.frame) ;
    if (mouseOrigin.y< minY)
    {
        mouseOrigin.y = minY;
    }
    else if (mouseOrigin.y> maxY)
    {
        mouseOrigin.y = maxY;
    }
   
    if ( mouseOrigin.x>=self.frame.size.width ||  mouseOrigin.y>=self.frame.size.height)
    {//鼠标在屏幕外面右、下边时、放个蓝点
        CGRect frame = self.bluePointImageView.frame;
        frame.origin.x = mouseOrigin.x-16-0.5;
        frame.origin.y = mouseOrigin.y-16-0.5;
        self.bluePointImageView.frame = frame;
        [self addSubview:self.bluePointImageView];
    }
    return mouseOrigin;
}
// 双指拖动(类似鼠标滚轮效果)
- (void)panGes_Pointer_twoPoint:(UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"双指拖动(类似鼠标滚轮效果)");
//        _mouseImageView.backgroundColor = [UIColor blueColor];


    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
//        CGPoint point = [sender translationInView:sender.view];//移动的是偏移量

        
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
        
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
//        _mouseImageView.backgroundColor = [UIColor clearColor];

    }
}
#pragma mark - ===========监控手势============
#pragma mark 捏合缩放手势
- (void)pinchGes_monitor:(UIPinchGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>捏合手势");
//        NSLog(@"%@",NSStringFromCGRect(self.openGLView.frame));
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sw_gesturesView:state:zoom:)]) {
            [self.delegate sw_gesturesView:self state:UIGestureRecognizerStateBegan zoom:1];
        }
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        if (self.frame.size.width/_openGLView.frame.size.width>10.f) {
            return;//最小画面限制
        }
        
        CGPoint anchorPoint = _openGLView.layer.anchorPoint;
        
        CGFloat minX = CGRectGetMinX(self.openGLView.frame)-self.glSectionInset.left;
        CGFloat maxX = CGRectGetMaxX(self.openGLView.frame)-(self.frame.size.width-self.glSectionInset.right);
        minX = roundf(minX);//四舍五入处里frameSize比例整除误差问题
        maxX = roundf(maxX);
        if (minX>=0 && maxX<=0)
        {//内部
            anchorPoint.x = 0.5;
        }
        else if (minX<0 && maxX>0)
        {//外部
//            if (CGPointEqualToPoint(self.openGLView.center, [self getDisplayCenter]) ) {
            if (_isOpenGLViewMinSize) {

                anchorPoint.x = 0.5;
            }else{
                CGPoint point = [sender locationInView:sender.view];//以两个点触摸点之间的位置作为锚点
                CGFloat x = (point.x-self.openGLView.frame.origin.x)/self.openGLView.frame.size.width;
                anchorPoint.x = x;
            }
        }
        else if (minX>=0 && maxX>0)
        {//左靠边
            CGRect ff = _openGLView.frame;
            ff.origin.x = 0.0+self.glSectionInset.left;
            _openGLView.frame = ff;
            anchorPoint.x = 0;
        }
        else if (minX<0 && maxX<=0)
        {//右靠边
            CGRect ff = _openGLView.frame;
            ff.origin.x = -self.openGLView.frame.size.width+(self.frame.size.width-self.glSectionInset.right);
            _openGLView.frame = ff;
            anchorPoint.x = 1;
        }
        CGFloat minY = CGRectGetMinY(self.openGLView.frame)-self.glSectionInset.top;
        CGFloat maxY = CGRectGetMaxY(self.openGLView.frame)-(self.frame.size.height-self.glSectionInset.bottom);
        minY = roundf(minY);
        maxY = roundf(maxY);
        if (minY>=0 && maxY<=0)
        {//内部
            anchorPoint.y = 0.5;
        }
        else if (minY<0 && maxY>0)
        {//外部
//            if (CGPointEqualToPoint(self.openGLView.center, [self getDisplayCenter]) ) {
            if (_isOpenGLViewMinSize) {
                anchorPoint.y = 0.5;
            }else{
                CGPoint point = [sender locationInView:sender.view];//以两个点触摸点之间的位置作为锚点
                CGFloat y = (point.y-self.openGLView.frame.origin.y)/self.openGLView.frame.size.height;
                anchorPoint.y = y;
            }
        }
        else if (minY>=0 && maxY>0)
        {//上靠边
            CGRect ff = _openGLView.frame;
            ff.origin.y = 0.0+self.glSectionInset.top;
            _openGLView.frame = ff;
            anchorPoint.y = 0;
        }
        else if (minY<0 && maxY<=0)
        {//下靠边
            CGRect ff = _openGLView.frame;
            ff.origin.y = -self.openGLView.frame.size.height+(self.frame.size.height-self.glSectionInset.bottom);
            _openGLView.frame = ff;
            anchorPoint.y = 1;
        }
        //修改锚点
        CGRect oldFrame = _openGLView.frame;
        _openGLView.layer.anchorPoint = anchorPoint;
        _openGLView.layer.frame = oldFrame;
//        NSLog(@"缩放时anchorPoint=%@",NSStringFromCGPoint(anchorPoint));
        
        //调整缩放系数
        CGFloat velocity = sender.velocity;
        if (isnan(velocity)) {
            NSLog(@"=======velocity=%.2f", velocity);
            velocity = 1.f;
        }
        CGFloat pen = velocity/4.f;
        pen = pen>1.f?1.f:pen;
        pen = pen<-1.f?-1.f:pen;
        pen = 0.075*pen;
        CGFloat scale = sender.scale+pen;


        
//        NSLog(@"velocity=%.2f", velocity);
        NSLog(@"old %.2f  new=%f", sender.scale,scale);
        
        [_openGLView setTransform:CGAffineTransformScale(_openGLView.transform, scale, scale)];
//        [_openGLView setTransform:CGAffineTransformScale(_openGLView.transform, sender.scale, sender.scale)];
        
        //检查修正某一次缩小时中心位置偏移 (在某一次临界状态anchorPoint存在两种情况导致误差)
        if ( (_openGLView.frame.origin.x>(0.0+self.glSectionInset.left)) && (_openGLView.frame.origin.x+_openGLView.frame.size.width<self.frame.size.width-self.glSectionInset.right )) {
            CGRect fframe = _openGLView.frame;
            _openGLView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _openGLView.layer.frame = fframe;

            CGPoint newCenter = _openGLView.center;
            newCenter.x = [self getDisplayCenter].x;
            _openGLView.center = newCenter;
        }
        if ( (_openGLView.frame.origin.y>(0.0+self.glSectionInset.top)) && (_openGLView.frame.origin.y+_openGLView.frame.size.height<self.frame.size.height-self.glSectionInset.bottom )) {
            CGRect fframe = _openGLView.frame;
            _openGLView.layer.anchorPoint = CGPointMake(0.5, 0.5);
            _openGLView.layer.frame = fframe;

            CGPoint newCenter = _openGLView.center;
            newCenter.y = [self getDisplayCenter].y;
            _openGLView.center = newCenter;
        }
        
        //相对移动鼠标，使鼠标指向内容位置不变、同时限制鼠标不越界
        [self keepMouseFocusWhenChangeOpenGLViewFrame:oldFrame newFrame:_openGLView.frame];
        sender.scale = 1.f;//恢复缩放系数
    }
    //手势结束后修正位置
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        _isOpenGLViewMinSize = NO;
        BOOL isCanMin = [self automaticallyRestoreMinSizeIfNeed];
        if (!isCanMin) {
            [self automaticallyRestoreMaxSizeIfNeed];
        }
      
        if (self.delegate && [self.delegate respondsToSelector:@selector(sw_gesturesView:state:zoom:)]) {
            [self.delegate sw_gesturesView:self state:UIGestureRecognizerStateEnded zoom:1];
        }
    }
}
//修改openGLView.frame、保持鼠标指向内容不变(鼠标不超出视图)
-(void)keepMouseFocusWhenChangeOpenGLViewFrame:(CGRect)oldFrame newFrame:(CGRect)newFrame
{
    [self.bluePointImageView removeFromSuperview];

    CGFloat oldMousePercentX = (self.mouseImageView.frame.origin.x-oldFrame.origin.x)/oldFrame.size.width;
    CGFloat oldMousePercentY = (self.mouseImageView.frame.origin.y-oldFrame.origin.y)/oldFrame.size.height;
    
    CGFloat newMouseX = oldMousePercentX*newFrame.size.width+newFrame.origin.x;
    CGFloat newMouseY = oldMousePercentY*newFrame.size.height+newFrame.origin.y;
    CGPoint mouseOrigin = CGPointMake(newMouseX, newMouseY);
   
    mouseOrigin = [self checkMouseFrameButNotOutBounds:mouseOrigin];
    
    CGRect frame = self.mouseImageView.frame;
    frame.origin = mouseOrigin;
    self.mouseImageView.frame = frame;
}
//小于自动复原默认大小
-(BOOL)automaticallyRestoreMinSizeIfNeed
{
    CGRect displayFrame = self.frame;
    // CGRectMake(self.glSectionInset.left, self.glSectionInset.top, self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right, self.frame.size.height-self.glSectionInset.top-self.glSectionInset.bottom);
    
    BOOL equalToRect = CGRectEqualToRect(displayFrame, _openGLView.frame);
    BOOL openGLView_min = CGRectContainsRect(displayFrame, _openGLView.frame); //返回是否第一个矩形包含了第二个矩形
    if (!equalToRect && openGLView_min)
    {//小于自动复原默认大小
        CGRect oldFrame = _openGLView.frame;
        _openGLView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        _openGLView.layer.frame = oldFrame;
        
        [UIView animateWithDuration:0.25 animations:^{
            if ([self isWidthGreaterHeight]) {
                CGFloat scale = (self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right)/self.openGLView.frame.size.width;//无法整除时存在误差、只用于动画期间
                [self.openGLView setTransform:CGAffineTransformScale(self.openGLView.transform, scale, scale)];
            }else{
                CGFloat scale = (self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top)/self.openGLView.frame.size.height;
                [self.openGLView setTransform:CGAffineTransformScale(self.openGLView.transform, scale, scale)];
            }
            //保持鼠标指向内容不变
            [self keepMouseFocusWhenChangeOpenGLViewFrame:oldFrame newFrame:self.openGLView.frame];
            
        } completion:^(BOOL finished) {
            [self setOpenGLView_MinSize];//修正误差
        }];
        return YES;
    }
    return NO;
}
-(void)automaticallyRestoreMaxSizeIfNeed
{
    CGFloat adsorptionValue = 0.f;
    if ([self isWidthGreaterHeight])
    {//横条形宽高比例图
        CGFloat openGLViewWidth = self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right;
        CGFloat openGLViewHeightMin = openGLViewWidth/self.openGLView.frameSize.width* self.openGLView.frameSize.height;
        adsorptionValue = ((self.frame.size.height-self.glSectionInset.top-self.glSectionInset.bottom)-openGLViewHeightMin)*0.15;//0.15*最小距离顶部距离
    }else
    {//竖条形宽高比例图
        CGFloat openGLViewHeight = self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top;
        CGFloat openGLViewWidthMin = openGLViewHeight/self.openGLView.frameSize.height* self.openGLView.frameSize.width;
        adsorptionValue = ((self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right)-openGLViewWidthMin)*0.15;
    }
    
   
    CGRect openGLViewFrame = _openGLView.frame;
    CGFloat oldMousePercentX = (self.mouseImageView.frame.origin.x-self.openGLView.frame.origin.x)/self.openGLView.frame.size.width;
    CGFloat oldMousePercentY = (self.mouseImageView.frame.origin.y-self.openGLView.frame.origin.y)/self.openGLView.frame.size.height;
   
    CGFloat scale = 1.0;
    CGPoint anchorPoint = _openGLView.layer.anchorPoint;
    BOOL isNeedMaxSize = NO;

    CGPoint contentFocalPoint;
    if (self.gesturesMode == SWRCGesturesMode_pointer || self.gesturesMode == SWRCGesturesMode_pointerBorder)
    {
        contentFocalPoint = self.mouseImageView.frame.origin;
        
    }else{
        contentFocalPoint = [self getDisplayCenter];
    }
    
    if ([self isWidthGreaterHeight])
    {//横条形宽高比例图
        CGFloat H = self.frame.size.height-self.glSectionInset.top-self.glSectionInset.bottom;
        BOOL less = openGLViewFrame.size.height<H;
        BOOL bigger = openGLViewFrame.size.height>(H-adsorptionValue*2);
        isNeedMaxSize = less && bigger;
        if (isNeedMaxSize)
        {
            CGFloat minX = CGRectGetMinX(self.openGLView.frame)-self.glSectionInset.left;
            CGFloat maxX = CGRectGetMaxX(self.openGLView.frame)-(self.frame.size.width-self.glSectionInset.right);
            minX = roundf(minX);//四舍五入处里frameSize比例整除误差问题
            maxX = roundf(maxX);
            
            if (minX>=0 && maxX>0)
            {//左靠边
                CGRect ff = _openGLView.frame;
                ff.origin.x = 0.0+self.glSectionInset.left;
                _openGLView.frame = ff;
                anchorPoint.x = 0;
            }
            else if (minX<0 && maxX<=0)
            {//右靠边
                CGRect ff = _openGLView.frame;
                ff.origin.x = -self.openGLView.frame.size.width+(self.frame.size.width-self.glSectionInset.right);
                _openGLView.frame = ff;
                anchorPoint.x = 1;
            }else{
                anchorPoint.x = (contentFocalPoint.x-self.openGLView.frame.origin.x)/self.openGLView.frame.size.width;
            }
            anchorPoint.y = 0.5;
            scale = (self.frame.size.height-self.glSectionInset.bottom-self.glSectionInset.top)/self.openGLView.frame.size.height;
        }
    }
    else
    {//竖
        CGFloat W = self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right;
        BOOL less = openGLViewFrame.size.width<W;
        BOOL bigger = openGLViewFrame.size.width>(W-adsorptionValue*2);
        isNeedMaxSize = less && bigger;
        if (isNeedMaxSize)
        {
            CGFloat minY = CGRectGetMinY(self.openGLView.frame)-self.glSectionInset.top;
            CGFloat maxY = CGRectGetMaxY(self.openGLView.frame)-(self.frame.size.height-self.glSectionInset.bottom);
            minY = roundf(minY);
            maxY = roundf(maxY);
            if (minY>=0 && maxY>0)
            {//上靠边
                CGRect ff = _openGLView.frame;
                ff.origin.y = 0.0+self.glSectionInset.top;
                _openGLView.frame = ff;
                anchorPoint.y = 0;
            }
            else if (minY<0 && maxY<=0)
            {//下靠边
                CGRect ff = _openGLView.frame;
                ff.origin.y = -self.openGLView.frame.size.height+(self.frame.size.height-self.glSectionInset.bottom);
                _openGLView.frame = ff;
                anchorPoint.y = 1;
            }else{
                anchorPoint.y = (contentFocalPoint.y-self.openGLView.frame.origin.y)/self.openGLView.frame.size.height;
            }

            anchorPoint.x = 0.5;
            scale = (self.frame.size.width-self.glSectionInset.left-self.glSectionInset.right)/self.openGLView.frame.size.width;
        }
    }
    
    if (isNeedMaxSize)
    {
        CGRect oldFrame = _openGLView.frame;
        _openGLView.layer.anchorPoint = anchorPoint;
        _openGLView.layer.frame = oldFrame;
        [UIView animateWithDuration:0.25 animations:^{
            
            [self.openGLView setTransform:CGAffineTransformScale(self.openGLView.transform, scale, scale)];
            
            //保持鼠标指向内容不变
            CGFloat newMouseX = oldMousePercentX*self.openGLView.frame.size.width+self.openGLView.frame.origin.x;
            CGFloat newMouseY = oldMousePercentY*self.openGLView.frame.size.height+self.openGLView.frame.origin.y;
            CGRect frame = self.mouseImageView.frame;
            frame.origin = CGPointMake(newMouseX, newMouseY);
            self.mouseImageView.frame = frame;
            
        } completion:^(BOOL finished) {
            [self setOpenGLView_MaxSize];//修正误差
        }];
    }
}
#pragma mark 单指拖动openGLView
- (void)panGes_monitor: (UIPanGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"正在开始识别>>拖动手势");
        [self.animator removeAllBehaviors];
    }
    if (sender.state == UIGestureRecognizerStateChanged)
    {
        //openGLView移动一定偏移量
        CGPoint offset = [sender translationInView:sender.view];//移动的是偏移量

        //移动系数放大、缩小_moveCoefficient
//        offset.x = offset.x *1.4;
//        offset.y = offset.y *1.4;
        
        
        CGPoint pointV = [sender velocityInView:sender.view];//滑动速度（像素/每秒）
//        NSLog(@"====%@", NSStringFromCGPoint(pointV));
        
        CGFloat H = _openGLView.frame.size.height/1000.f;
        H = H>2.0?2.0:H;
        
        CGFloat penX = ABS(pointV.x)/500.f;//速度
        penX = penX>1.f?1.f:penX;
        
        CGFloat penY = ABS(pointV.y)/500.f;
        penY = penY>1.f?1.f:penY;
//        NSLog(@"系数==%.2f", penX);

        penX = 1.15+0.3*penX+0.20*H;
        penY = 1.15+0.3*penY+0.20*H;

  

        NSLog(@"==系数==%.2f==%.2f", penX,penY);

        
        offset.x = offset.x *penX;
        offset.y = offset.y *penY;

//        CGFloat moveCoefficientX = ABS(pointV.x)*1.f/1200.f+1.f;
//        CGFloat moveCoefficientY = ABS(pointV.y)*1.f/1200.f+1.f;
//        moveCoefficientX=moveCoefficientX>1.2?1.2:moveCoefficientX;
//        moveCoefficientY=moveCoefficientY>1.2?1.2:moveCoefficientY;
//
////        NSLog(@"==系数==%@", NSStringFromCGPoint(CGPointMake(moveCoefficientX, moveCoefficientY)));
//
//        //移动系数随手指移动速率变化
//        offset.x = offset.x*moveCoefficientX ;
//        offset.y = offset.y*moveCoefficientY ;
        
        
        self.openGLView.frame = [self moveingAndCheckOpenGLViewWithOffset:offset];
        [sender setTranslation:CGPointZero inView:sender.view];// 将位移清零
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        CGPoint pointV = [sender velocityInView:sender.view];//滑动速度（像素/每秒）
        NSLog(@"StateEnded速率=%@",NSStringFromCGPoint(pointV));
        
        CGFloat penX = ABS(pointV.x)/5000.f;//速度
        penX = penX>1.f?1.f:penX;
        
        [self ss:pointV];
    }
}
-(void)ss:(CGPoint)pointV
{
    CGRect frame = self.openGLView.frame;
    self.openGLView.transform = CGAffineTransformIdentity;
    self.openGLView.frame = frame;

    // 1.创建动画者对象
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    
    // 2.创建行为-UIPushBehaviorModeInstantaneous (瞬时推理)(越来越慢)
    UIPushBehavior *push = [[UIPushBehavior alloc] initWithItems:@[self.openGLView] mode:UIPushBehaviorModeInstantaneous];
    //推力矢量的大小
    push.magnitude = 1;//h=0.000001
    // 计算手指到redView中心点的偏移量
    
    CGFloat offsetX = 200.0; //p.x - self.redView.center.x;
    if (pointV.x>0) {
        offsetX = -offsetX;
    }
    CGFloat offsetY = 0.0;// p.y - self.redView.center.y;  相当于力的位移
    // 设置手指到redView中心偏移量为推行为的向量方向、值越大力的作用时间越长
    push.pushDirection = CGVectorMake(-offsetX, -offsetY);
    // 设置推行为的活跃状态 YES:活跃 NO:不活跃
    push.active = YES;
    // 3.添加行为到动画者对象
    [self.animator addBehavior:push];
    
    //添加一个阻力
    UIDynamicItemBehavior * itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.openGLView]];
    //线速度阻尼 默认值是0.0。有效范围从0.0(没有速度阻尼)到CGFLOAT_MAX(最大速度阻尼)。当设置为CGFLOAT_MAX，动态元素会立马停止就像没有力量作用于它一样。
    itemBehavior.resistance = 5;//
    [self.animator addBehavior:itemBehavior];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        NSLog(@"实际%f",CGRectGetMinY(_redView.frame)-_YYYY);
    //
    //    });
    
        CGFloat s = 1000000*offsetX/(frame.size.height*frame.size.width*itemBehavior.resistance);
        NSLog(@"理论计算停下来位移： %f",s);
    
    //结论： 实际有误差，范围1个像素，且证明和magnitude值无关，为啥呢？
   

}
//移动openGLView一定偏移量、直至拖拽至边界时不再移动
-(CGRect)moveingAndCheckOpenGLViewWithOffset:(CGPoint)offset
{
    if (CGPointEqualToPoint(offset, CGPointZero)) {
        return self.openGLView.frame;
    }
//    NSLog(@"%@",NSStringFromUIEdgeInsets(_glSectionInset));
    CGRect frame = self.openGLView.frame;
    if (offset.x>0.0 && frame.origin.x<(0.0+self.glSectionInset.left))
    {//向右滑动
        frame.origin.x+= offset.x;
        if (frame.origin.x> (0.0+self.glSectionInset.left))
        {
            frame.origin.x = (0.0+self.glSectionInset.left);
        }
    }
    if (offset.x<0.0 && frame.origin.x+frame.size.width>(self.frame.size.width-self.glSectionInset.right))
    {//向左滑动
        frame.origin.x+= offset.x;
        if (frame.origin.x+frame.size.width<(self.frame.size.width-self.glSectionInset.right))
        {
            frame.origin.x = -frame.size.width +(self.frame.size.width-self.glSectionInset.right);
        }
    }
    if (offset.y>0.0 && frame.origin.y<(0.0+self.glSectionInset.top))
    {//向下滑动
        frame.origin.y+= offset.y;
        if (frame.origin.y> (0.0+self.glSectionInset.top))
        {
            frame.origin.y = (0.0+self.glSectionInset.top);
        }
    }
    if (offset.y<0.0 && (frame.origin.y+frame.size.height)>(self.frame.size.height-self.glSectionInset.bottom))
    {//向上滑动
        frame.origin.y+= offset.y;
        if (frame.origin.y+frame.size.height<(self.frame.size.height-self.glSectionInset.bottom))
        {
            frame.origin.y = -frame.size.height +(self.frame.size.height-self.glSectionInset.bottom);
        }
    }
    return frame;
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
        
        [self setGLSectionInset];
        
        CGRect oldFrame = self.openGLView.frame;
        [self setOpenGLView_MinSize];
        
        [self keepMouseFocusWhenChangeOpenGLViewFrame:oldFrame newFrame:self.openGLView.frame];
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
    [self removeObserverForKeyboardNotifications];
    NSLog(@"jl_dealloc SWRCGesturesView");
}

#pragma mark - Timer auto Moveing OpenGLView
-(BOOL)autoMoveingOpenGLViewWhenNeed
{
    BOOL isNeed = NO;//鼠标放于边界处自动移动OpenGLView

    CGRect mouseframe = _mouseImageView.frame;
    CGRect GLViewframe = _openGLView.frame;
    if (mouseframe.origin.x == (0.0+self.glSectionInset.left))
    {
        if (GLViewframe.origin.x<(0.0+self.glSectionInset.left)) {
            isNeed = YES;
        }
    }
    else if (mouseframe.origin.x== (self.frame.size.width-self.glSectionInset.right))
    {
        if (GLViewframe.origin.x+GLViewframe.size.width>(self.frame.size.width-self.glSectionInset.right) )
        {
            isNeed = YES;
        }
    }
    
    if (mouseframe.origin.y == (0.0+self.glSectionInset.top))
    {
        if (GLViewframe.origin.y<(0.0+self.glSectionInset.top)) {
            isNeed = YES;
        }
    }
    else if (mouseframe.origin.y == self.frame.size.height-self.glSectionInset.bottom)
    {
        if (GLViewframe.origin.y+GLViewframe.size.height>(self.frame.size.height-self.glSectionInset.bottom))
        {
            isNeed = YES;
        }
    }
    if (isNeed) {
        [self addTimer];
        return YES;
    }else{
        if (_autoMoveTimer) {//OpenGLView移动到边界时，自动关闭定时器,此时发送一次鼠标位置（因为移动过程中每秒移动50次，每5次发送一次鼠标位置改变）
            [self pointerMode_gesturesType:SWRCGesturesType_pointMove state:UIGestureRecognizerStateChanged];
        }
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
    CGRect openGLFrame = self.openGLView.frame;
    CGRect mouseFrame = _mouseImageView.frame;
    CGFloat offSetValue = 10;
    CGPoint offset = CGPointZero;
    
    if (mouseFrame.origin.x== (0.0+self.glSectionInset.left))
    {
        offset.x = offSetValue;
    }
    else if (mouseFrame.origin.x== (self.frame.size.width-self.glSectionInset.right))
    {
        offset.x = -offSetValue;
    }

    if (mouseFrame.origin.y== (0.0+self.glSectionInset.top))
    {
        offset.y = offSetValue;
    }
    else if (mouseFrame.origin.y== (self.frame.size.height-self.glSectionInset.bottom))
    {
        offset.y = -offSetValue;
    }
    CGRect newFrame = [self moveingAndCheckOpenGLViewWithOffset:offset];
    BOOL isEqual = CGPointEqualToPoint(openGLFrame.origin, newFrame.origin);
  
    if (!isEqual)
    {
        //鼠标相对于openGLView位置改变
//        NSLog(@"BBBB——1");
        [self pointerMode_gesturesType:SWRCGesturesType_pointMove state:UIGestureRecognizerStateChanged];
        
        self.openGLView.frame = newFrame;
        
        //移动时放个蓝点
        UIImageView *imv = [[UIImageView alloc] initWithFrame:CGRectMake(self.mouseImageView.frame.origin.x-16-0.5, self.mouseImageView.frame.origin.y-16-0.5, 32, 32)];
        imv.image = [UIImage imageNamed:@"blue"];
        [self addSubview:imv];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [imv removeFromSuperview];
        });
    }
}

-(void)deallocTimer
{
    if (_autoMoveTimer && _autoMoveTimer.isValid) {
        [_autoMoveTimer invalidate];
        _autoMoveTimer=nil;
    }
}


#pragma mark - delegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.gesturesMode == SWRCGesturesMode_touch)
    {
//        NSLog(@"gestureRecognizerShouldBegin %@",NSStringFromClass(gestureRecognizer.class));
        if (gestureRecognizer  == self.tapGes_touch) {
            CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            if (CGRectContainsPoint(self.openGLView.frame, touchPoint)) {
                self.touchAnimatedView.touchPoint = touchPoint;
                [self.touchAnimatedView showHighlighted:YES];
            }
//            NSLog(@"tapGes_touch%@",NSStringFromCGPoint(touchPoint));
        }
        if (gestureRecognizer  == self.tapGes_touchTwo) {
            CGPoint touchPoint = [gestureRecognizer locationInView:gestureRecognizer.view];
            if (CGRectContainsPoint(self.openGLView.frame, touchPoint)) {
                self.touchAnimatedView.touchPoint = touchPoint;
                [self.touchAnimatedView showHighlighted:YES];
            }
//            NSLog(@"双击tapGes_touchTwo%@",NSStringFromCGPoint(touchPoint));
        }
    }
 
    return YES;
}
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
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    CGPoint touchPoint = [touch locationInView:self];
//    [self touchAnimated:CGPointMake(touchPoint.x, touchPoint.y+120)];
//
//    return YES;
//}
// called before pressesBegan:withEvent: is called on the gesture recognizer for a new press. return NO to prevent the gesture recognizer from seeing this press
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceivePress:(UIPress *)press;
//


#pragma mark mouse origin鼠标点转换为相对于SWRCOpenGLView坐标系点坐标
-(CGPoint)transformPointWithMouse
{
//将self.mouseImageView{0,0}坐标转换到openGLView坐标系(有时候有误差不准因为anchorPoint)
//CGPoint mousePoint = [self.mouseImageView convertPoint:CGPointZero toView:self.openGLView];

    //1.将鼠标self.mouseImageView.origin换算到openGLView上
    CGPoint origin = self.mouseImageView.frame.origin;
    CGFloat mousePointX = origin.x-self.openGLView.frame.origin.x;
    CGFloat mousePointY = origin.y-self.openGLView.frame.origin.y;
    CGPoint mousePoint = CGPointMake(mousePointX, mousePointY);
    
    //2.openGLView.frame放大或缩小至frameSize时，新的触摸点(鼠标)坐标
    CGFloat scale = (CGFloat)self.openGLView.frameSize.width/self.openGLView.frame.size.width;
    CGPoint mousePointTransform = CGPointApplyAffineTransform(mousePoint,CGAffineTransformMakeScale(scale, scale));
    CGPoint mousePointFinally = CGPointMake(roundf(mousePointTransform.x), roundf(mousePointTransform.y));
    
    return mousePointFinally;
}
#pragma mark mouse origin鼠标点转换为相对于SWRCOpenGLView坐标系点坐标
-(CGPoint)transformPointWithTouchPoint:(CGPoint)touchPoint
{
    //1.
    CGFloat touchPointX = touchPoint.x-self.openGLView.frame.origin.x;
    CGFloat touchPointY = touchPoint.y-self.openGLView.frame.origin.y;
    CGPoint touchPointTran = CGPointMake(touchPointX, touchPointY);
    
    //2.openGLView.frame放大或缩小至frameSize时，新的触摸点(鼠标)坐标
    CGFloat scale = (CGFloat)self.openGLView.frameSize.width/self.openGLView.frame.size.width;
    CGPoint touchPointTransform = CGPointApplyAffineTransform(touchPointTran,CGAffineTransformMakeScale(scale, scale));
    CGPoint touchPointFinally = CGPointMake(roundf(touchPointTransform.x), roundf(touchPointTransform.y));
    
    return touchPointFinally;
}
- (void)pointerMode_gesturesType:(SWRCGesturesType )gesturesType state:(UIGestureRecognizerState )state
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_gesturesView:gesturesType:state:touchPoint:frameSize:)]) {
        
        CGPoint point = [self transformPointWithMouse];
        [self.delegate sw_gesturesView:self gesturesType:gesturesType state:state touchPoint:point frameSize:self.openGLView.frameSize];
    }
}
- (void)touchMode_gesturesType:(SWRCGesturesType )gesturesType touchPoint:(CGPoint)touchPoint state:(UIGestureRecognizerState )state
{
    if (CGRectContainsPoint(self.openGLView.frame, touchPoint))
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sw_gesturesView:gesturesType:state:touchPoint:frameSize:)])
        {
            CGPoint point = [self transformPointWithTouchPoint:touchPoint];
            [self.delegate sw_gesturesView:self gesturesType:gesturesType state:state touchPoint:point frameSize:self.openGLView.frameSize];
        }
    }
}
-(void)gesturesBegainToastMessage:(SWRCGesturesType )gesturesType
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_gesturesView:gesturesBegain:message:)]) {
       
        NSString *message ;
        if (gesturesType == SWRCGesturesType_pointMove)
        {//鼠标移动

        }
        if (gesturesType == SWRCGesturesType_point)
        {//单击
            message = @"选择项目(单击)";
        }
        if (gesturesType == SWRCGesturesType_twoPoint)
        {//双指单击屏幕(右键单击)
            message = @"右键单击";
        }
        if (gesturesType == SWRCGesturesType_longPressClick)
        {//单指按住1s(右键单击)
            message = @"右键单击";
        }
        if (gesturesType == SWRCGesturesType_pointTwo)
        {//单指双击（单击已取消）
            message = @"双击";
        }
        if (gesturesType == SWRCGesturesType_drag)
        {//单指双击后不松开拖拽
            message = @"左键按住拖动";
        }
        
        [self.delegate sw_gesturesView:self gesturesBegain:gesturesType message:message];
    }
}
@end
