//
//  SWRCGesturesView.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRCOpenGLView.h"
#import "SWRCEAGLLayer.h"

NS_ASSUME_NONNULL_BEGIN

//手势模式
typedef NS_ENUM(NSInteger , SWRCGesturesMode){
    
    SWRCGesturesMode_None        = 0,//无任何手势模式

    SWRCGesturesMode_monitor     = 1,//监控模式(只有窗口缩放、拖动手势)

    SWRCGesturesMode_pointer     = 2,//指针模式
    
    SWRCGesturesMode_touch       = 3,//触屏模式
};

//手势类型
typedef NS_ENUM(NSInteger , SWRCGesturesType){
    
    SWRCGesturesType_point        = 0, //单指单击屏幕
    
    SWRCGesturesType_pointTwo     = 1, //单指双击

    SWRCGesturesType_twoPoint     = 2, //双指单击屏幕(右键单击)
    
    SWRCGesturesType_pointMove    = 3, //鼠标移动

    SWRCGesturesType_scrollUp     = 4, //双指上划（类似鼠标滚轮）
    
    SWRCGesturesType_scrollDown   = 5, //双指下划（类似鼠标滚轮）
    
    SWRCGesturesType_drag         = 6, //单指双击后不松开拖拽
};

@class SWRCGesturesView;
@protocol SWRCGesturesViewDelegate <NSObject>
@optional
- (void)sw_SWRCGesturesView:(SWRCGesturesView*)view gesturesType:(SWRCGesturesType )gesturesType msg:(id)msg;
@end

//移动窗口协议
@protocol SWRCGesturesMovingViewDelegate <NSObject>
@optional
//若遵循协议但不实现该get方法，则movingRect=self.frame; 若实现该get方法，可指定movingView的某一块矩形范围作为移动窗口
//@property(nonatomic, assign) CGRect movingRect;//未开发、预留

@property(nonatomic, assign) CGSize frameSize;//图片、视频每帧宽高


@end

@interface SWRCGesturesView : UIView

//default is SWRCGesturesMode_None.
@property(nonatomic, assign) SWRCGesturesMode gesturesMode;

@property(nonatomic, weak, nullable) id<SWRCGesturesViewDelegate> delegate;

//default is nil. 

@property(nonatomic, strong, nullable) SWRCEAGLLayer *movingLayer;

@end

NS_ASSUME_NONNULL_END
