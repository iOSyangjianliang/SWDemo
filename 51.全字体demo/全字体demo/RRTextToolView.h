//
//  RRTextToolView.h
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/22.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "RRTextView.h"

NS_ASSUME_NONNULL_BEGIN

@class RRTextToolView;
@protocol RRTextToolViewDelegate <NSObject>
@required
- (void)rr_textToolView:(RRTextToolView*)view didSelectIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex;
@end


@interface RRTextToolView : UIView
@property(nonatomic, strong, readonly) RRTextView *functionView;
@property(nonatomic, weak) id<RRTextToolViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
