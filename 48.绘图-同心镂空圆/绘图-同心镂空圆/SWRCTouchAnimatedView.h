//
//  SWRCTouchAnimatedView.h
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/3/5.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SWRCTouchAnimatedView : UIView
@property(nonatomic, assign) CGPoint touchPoint;

-(void)showHighlighted:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
