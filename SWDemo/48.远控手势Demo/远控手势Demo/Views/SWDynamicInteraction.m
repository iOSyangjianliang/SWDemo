//
//  SWDynamicInteraction.m
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/9/9.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "SWDynamicInteraction.h"

@implementation SWDynamicInteraction
-(void)sssfc{
    //调整缩放系数
//    CGFloat velocity = sender.velocity;
//    if (isnan(velocity)) {
//        //            RCLog(@"=======velocity=%.2f", velocity);
//        velocity = 1.f;
//    }
//    CGFloat pen = velocity/4.f;
//    pen = pen>1.f?1.f:pen;
//    pen = pen<-1.f?-1.f:pen;
//    pen = 0.075*pen;
//    CGFloat scale = sender.scale+pen;
    

    

}


//0～5000
-(CGPoint)sssssss
{
    
    
//    //openGLView移动一定偏移量
//    CGPoint offset = [sender translationInView:sender.view];//移动的是偏移量
//
//    //移动系数随手指移动速率、画面缩放大小动态变化
//    CGPoint pointV = [sender velocityInView:sender.view];//滑动速度（像素/每秒）
//    //        NSLog(@"====%@", NSStringFromCGPoint(pointV));
//
//    //画面缩放系数
//    CGFloat H = _openGLView.frame.size.height/1000.f;
//    H = H>2.0?2.0:H;
//
//    //水平、垂直滑动速率
//    CGFloat penX = ABS(pointV.x)/500.f;//速度
//    penX = penX>1.f?1.f:penX;
//
//    CGFloat penY = ABS(pointV.y)/500.f;
//    penY = penY>1.f?1.f:penY;
//
//    //算法
//    penX = 1.15+0.3*penX+0.20*H;
//    penY = 1.15+0.3*penY+0.20*H;
//    //        NSLog(@"==系数==%.2f==%.2f", penX,penY);
//
//    offset.x = offset.x *penX;
//    offset.y = offset.y *penY;
    
    return CGPointZero;
}

@end
