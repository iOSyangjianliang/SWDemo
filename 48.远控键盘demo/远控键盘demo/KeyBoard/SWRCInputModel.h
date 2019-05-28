//
//  SWRCInputModel.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
//cell样式
typedef NS_ENUM(NSInteger , SWRCItemUIStyle){
    
    SWRCItemUIStyle_TitleOnly        = 0,//只有title居中
    
    SWRCItemUIStyle_ImgOnly          = 1,//只有icon居中、
    
    SWRCItemUIStyle_Title_V_Title    = 2,//上下title
    
    SWRCItemUIStyle_Img_H_Title      = 3,//左icon右title
};

//cell Width
typedef struct _SWPercentWidth{
    CGFloat percent;
    NSInteger items;
}SWPercentWidth;
NS_INLINE SWPercentWidth SWMakePercentWidth(CGFloat percent, NSInteger items) {
    SWPercentWidth pw;
    pw.percent = percent;
    pw.items = items;
    return pw;
}

//远控指令
@interface SWRCKeyboardSignalModel : NSObject
@property(nonatomic, assign) uint64_t state;
@property(nonatomic, assign) uint64_t value;
@end


@interface SWRCInputModel : NSObject
@property(nonatomic, strong) NSString *mainTitle;
@property(nonatomic, strong, nullable) NSString *subTitle;

@property(nonatomic, assign) SWPercentWidth percentWidth;
@property(nonatomic, assign) CGFloat itemWidth;//水平时宽度
@property(nonatomic, assign) SWRCItemUIStyle itemUIStyle;

@property(nonatomic, strong) NSArray<SWRCKeyboardSignalModel *> *keyboardSignals;

@end



NS_ASSUME_NONNULL_END
