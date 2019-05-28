//
//  MBProgressHUD+JLExtension.h
//  MBProgressHUD二次封装扩展
//
//  Created by 杨建亮 on 2018/12/3.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "MBProgressHUD.h"
#import "UIImage+ZXGIF.h"

/**
 注意：
 支持window显示和自定义view显示，当view＝nil，显示在window上；
 当在UITabelViewController，UICollectionViewController时，可传入nil在window上提示；
 */


/** 当正在展示旧toast时，新来的toast的展示策略*/
typedef NS_ENUM(NSInteger, MBProgressHUDDisplayPloy) {
    
    //默认策略(未传入策略参数的toast方法默认值，可直接修改defaultDisplayPloy修改默认值)
    MBProgressHUDDisplayDefault, //如果展示的toast所在view不同、同时展示在不同view上、如果view相同，则立即移除上一个直接展示当前tosat
   
    MBProgressHUDDisplayIgnore,  //不管展示的toast所在view是否相同，如果有正在展示的toast、直接忽略不展示
    
    MBProgressHUDDisplayWaiting, //不管展示的toast所在view是否相同，如果有正在展示的toast、先记录等待上一个展示结束再展示新toast
    
    MBProgressHUDDisplayWaitingAndIgnoreSameToast, //不管展示的toast所在view是否相同，如果有正在展示的toast、先记录等待上一个展示结束再展示新toast，但是会自动忽略相同的toast
    
    MBProgressHUDDisplayWaitingIfViewSame, //如果展示的toast所在view不同、同时展示在不同view上、如果view相同，则先记录等待上一个展示结束再展示新toast

};
NS_ASSUME_NONNULL_BEGIN

static MBProgressHUDDisplayPloy defaultDisplayPloy = MBProgressHUDDisplayDefault;
@interface MBProgressHUD (JLExtension)

//========================toast提示============================//
/**
 toast提示: 提示完成会自动隐藏,toast展示时间根据文本内容长度计算。
 
 @param message 提示文案
 @param view toast所加的view层，如果传nil，默认window；
 */
+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view;

/**
 toast提示: 提示完成会自动隐藏,toast展示时间由delay指定

 @param message 提示文案
 @param view toast所加的view层，如果传nil，默认window；
 @param delay 展示多久后隐藏、即展示时间
 */
+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay;

/**
 toast提示(带Icon、icon文字上下布局): 提示完成会自动隐藏,toast展示时间由delay指定

 @param message 提示文案
 @param imageName 本地icon的名字
 @param view toast所加的view层，如果传nil，默认window；
 @param delay 展示多久后隐藏、即展示时间
 */
+ (void)jl_showMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay;

//========================Loading提示============================//
/**
 Loading提示: 持续展示小菊花loading及文案，需手动隐藏

 @param message 提示文案
 @param view Loading所加的view层，如果传nil，默认window；
 */
+ (void)jl_showLoadingWithStatus:(nullable NSString *)message toView:(nullable UIView *)view;


/**
 以gif图的Loading提示: 持续展示gif动图及文案，需手动隐藏

 @param gifName 本地gif的名字
 @param message 提示文案
 @param view loading所加的view层，如果传nil，默认window；
 */
+ (void)jl_showGifWithGifName:(NSString *)gifName message:(nullable NSString *)message toView:(nullable UIView *)view;

/**
 多张图片组成loading提示: 持续展示自定义多张图组成的gif效果，需手动隐藏
 
 @param gifName 图片命名方式
 @param imgCount 图片张数
 @param view 所加的view层，如果传nil，默认window；
 
 eg: [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
 即加载load0.png @"load1.png" ....@"load13.png" 组成的gif动画, 动画默认每帧0.05s
 */
+ (void)jl_showGifWithGifName:(NSString *)gifName imagesCount:(NSInteger )imgCount toView:(nullable UIView *)view;

//========================隐藏============================//
/**
 立即隐藏正在展示的loading（toast会自动隐藏）

 @param view 隐藏指定view的提示、和展示所在view相对应
 @return 是否隐藏成功
 */
+ (BOOL)jl_hideHUDForView:(nullable UIView *)view;
/**delay: 延迟多久后隐藏（即展示时间）*/
+ (BOOL)jl_hideHUDForView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay;

@end


static BOOL const jl_isNeedDisplayPloy  = YES;
@interface MBProgressHUD (JLToastDisplayPloy)
//======toast展示策略(当正在展示旧toast时，新来的toast的展示策略，详见最上面枚举)=====//
//若需要使用此功能、将jl_isNeedDisplayPloy设置YES才可使用。//
//对于(JLExtension)分类中的toast使用默认策略、使用下方法可设置自定义设置展示策略。//

+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view displayPloy:(MBProgressHUDDisplayPloy)ploy;
+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy;
+ (void)jl_showMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy;
@end


NS_ASSUME_NONNULL_END
