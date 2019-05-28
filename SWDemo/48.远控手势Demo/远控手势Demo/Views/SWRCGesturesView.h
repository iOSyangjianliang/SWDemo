//
//  SWRCGesturesView.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRCOpenGLView.h"
#import "SWRCTouchAnimatedView.h"

NS_ASSUME_NONNULL_BEGIN

//手势模式
typedef NS_ENUM(NSInteger , SWRCGesturesMode){
    
    SWRCGesturesMode_None        = 0,//无任何手势模式

    SWRCGesturesMode_pointer     = 1,//指针模式-中心模式
    
    SWRCGesturesMode_pointerBorder  = 2,//指针模式-边界自动模式

    SWRCGesturesMode_touch       = 3,//触屏模式
    
    SWRCGesturesMode_monitor     = 4,//监控模式(只有窗口缩放、拖动手势)

};

//手势类型
typedef NS_ENUM(NSInteger , SWRCGesturesType){
    
    SWRCGesturesType_point          = 0, //单指单击屏幕
    
    SWRCGesturesType_pointTwo       = 1, //单指双击

    SWRCGesturesType_twoPoint       = 2, //双指单击屏幕(右键单击)
    
    SWRCGesturesType_pointMove      = 3, //鼠标移动

    SWRCGesturesType_scrollUp       = 4, //双指上划（类似鼠标滚轮）
    
    SWRCGesturesType_scrollDown     = 5, //双指下划（类似鼠标滚轮）
    
    SWRCGesturesType_drag           = 6, //单指双击后不松开拖拽
    
    SWRCGesturesType_longPressClick = 7, //单指按住1s(右键单击)

};


@class SWRCGesturesView;
@protocol SWRCGesturesViewDelegate <NSObject>
@optional
//缩放
- (void)sw_gesturesView:(SWRCGesturesView*)view state:(UIGestureRecognizerState )state zoom:(CGFloat)zoom;
//手势类型-代理
- (void)sw_gesturesView:(SWRCGesturesView*)view gesturesType:(SWRCGesturesType )gesturesType state:(UIGestureRecognizerState )state touchPoint:(CGPoint)point frameSize:(CGSize)frameSize;
//手势触发Begain进行toast提示
- (void)sw_gesturesView:(SWRCGesturesView*)view gesturesBegain:(SWRCGesturesType )gesturesType message:(NSString *)message;
@end

////窗口移动协议
//@protocol SWRCGesturesMovingViewDelegate <NSObject>
//@optional
////若遵循协议但不实现该get方法，则movingRect=self.frame; 若实现该get方法，可指定movingView的某一块矩形范围作为移动窗口
//@property(nonatomic, assign) CGRect movingRect;//未开发、预留
//@property(nonatomic, assign) CGSize frameSize;//图片、视频每帧宽高
//@end

@interface SWRCGesturesView : UIView
//只支持initWithFrame初始化、不支持xib、sb，且frame.origin目前只支持{0,0}
- (instancetype)initWithFrame:(CGRect)frame;

//默认为SWRCGesturesMode_None
@property(nonatomic, assign) SWRCGesturesMode gesturesMode;
@property(nonatomic, weak, nullable) id<SWRCGesturesViewDelegate> delegate;

//default is nil. self父视图存在后再手动配置
@property(nonatomic, strong, nullable) SWRCOpenGLView *openGLView;

//移动窗口距离底部边距限制、是否动画
- (void)setSectionInsetBottom:(CGFloat)sectionInsetBottom animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
