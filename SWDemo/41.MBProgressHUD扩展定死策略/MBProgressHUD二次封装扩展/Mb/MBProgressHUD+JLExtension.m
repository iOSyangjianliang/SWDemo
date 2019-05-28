//
//  MBProgressHUD+JLExtension.m
//  MBProgressHUD二次封装扩展
//
//  Created by 杨建亮 on 2018/12/3.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "MBProgressHUD+JLExtension.h"

static NSString *const toast_Key_message  = @"message";
static NSString *const toast_Key_imageName  = @"imageName";
static NSString *const toast_Key_view  = @"view";
static NSString *const toast_Key_delay  = @"delay";
static NSString *const toast_Key_ploy  = @"ploy";
static NSString *const toast_Key_showing  = @"showing";

static NSMutableArray<NSMutableDictionary *> *signatureCache = nil;

@implementation MBProgressHUD (JLToastDisplayPloy)
+ (nullable UIWindow *)jl_getFrontWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];//倒序遍历
    for (UIWindow *window in frontToBackWindows)
    {//eg: _UIInteractiveHighlightEffectWindow
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal);
        if(windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
            break;
        }
    }
    return nil;
}

+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view displayPloy:(MBProgressHUDDisplayPloy)ploy
{
    [MBProgressHUD jl_showMessage:message customIcon:nil view:view hideAfterDelay:0 displayPloy:ploy isQueue:NO];
}
+ (void)jl_showMessage:(nullable NSString *)message toView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy
{
    [MBProgressHUD jl_showMessage:message customIcon:nil view:view hideAfterDelay:delay displayPloy:ploy isQueue:NO];
}
+ (void)jl_showMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy
{
    [MBProgressHUD jl_showMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy isQueue:NO];
}
+ (void)jl_showMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy isQueue:(BOOL)queue
{
    if (!view)
    {
        view = [MBProgressHUD jl_getFrontWindow];
    }
    
    BOOL bo = [MBProgressHUD isNeedShowToastWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy isQueue:queue];
    if (!bo) {
        return;
    }
    
    //show
    [MBProgressHUD hideHUDForView:view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }

    //默认白色
    hud.contentColor = [UIColor whiteColor];
    hud.opaque = YES;
    hud.backgroundColor = [UIColor clearColor];
    //默认是模糊样式
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
    
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.backgroundColor = [UIColor clearColor];
    NSTimeInterval delayTime = delay;
    if (message.length>12)
    {
        hud.detailsLabel.text= message?NSLocalizedString(message, nil):nil;
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
        delayTime = delay>0?delay : (1.f+hud.detailsLabel.text.length*0.1); //toast展示时间计算
    }
    else
    {
        hud.label.text= message?NSLocalizedString(message, nil):nil;
        delayTime = delay>0?delay : (1.f+hud.label.text.length*0.1);
    }
    
    if (imageName)
    {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        //放图片时去背景色
        hud.bezelView.color = [UIColor clearColor];
    }
    else
    {
        hud.mode = MBProgressHUDModeText;
    }
    
    [hud hideAnimated:YES afterDelay:delayTime];
    
    hud.completionBlock = ^{ //移除后检查是否有在队列中等待的toast
        if (signatureCache.count>0) {
            [signatureCache removeObjectAtIndex:0];
        }
        if (signatureCache.count>0)
        {
            NSMutableDictionary *dict = signatureCache.firstObject;
            NSString *message = dict[toast_Key_message];
            NSString *imageName = dict[toast_Key_imageName];
            UIView *vi = dict[toast_Key_view];
            NSTimeInterval delay = [dict[toast_Key_delay] doubleValue];
            MBProgressHUDDisplayPloy ploy = [dict[toast_Key_ploy] integerValue];

            NSLog(@"当前队列还有%lu个",(unsigned long)signatureCache.count);
            [MBProgressHUD jl_showMessage:message customIcon:imageName view:vi hideAfterDelay:delay displayPloy:ploy isQueue:YES];
        }
    };
}

//返回是否需要展示toast
+ (BOOL )isNeedShowToastWithMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy isQueue:(BOOL)queue

{
    if (!signatureCache) {
        signatureCache = [NSMutableArray array];
    }
    if (!queue)
    { //如果是等待展示的不再加入
        if (signatureCache.count>0)
        {//如果有正在展示的Toast
            if (ploy == MBProgressHUDDisplayWaiting)
            {
                //如果有正在展示的、先记录等待上一个展示结束再展示
                [MBProgressHUD cacheAllParametersWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy];
                return NO;
            }
            else if (ploy == MBProgressHUDDisplayWaitingAndIgnoreSameToast)
            {
                //如果有正在展示的、如果toast相同自动忽略不展示，否则先记录等待上一个展示结束再展示
                for (int i=0; i<signatureCache.count; ++i) {
                    NSMutableDictionary *isShow = signatureCache[i];
                    BOOL isMessage;
                    if (!message && !isShow[toast_Key_message]) {//nil、nil
                        isMessage = YES;
                    }else{
                        isMessage = [message isEqualToString:isShow[toast_Key_message]];
                    }
                    BOOL isImageName;
                    if (!imageName && !isShow[toast_Key_imageName]) {//nil、nil
                        isImageName = YES;
                    }else{
                        isImageName = [imageName isEqualToString:isShow[toast_Key_imageName]];
                    }
                    BOOL isView = [view isEqual:isShow[toast_Key_view]];
                    BOOL isDelay = [@(delay) isEqualToNumber: isShow[toast_Key_delay]];
                    if (isMessage && isImageName && isView && isDelay ) {
                        break;
                    }
                    if (i==signatureCache.count-1 ) {//遍历到最后一个还是不同
                        [MBProgressHUD cacheAllParametersWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy]; //不同toast记录等待
                    }
                }
                return NO; //要么忽略、要么等待
            }
            else if (ploy == MBProgressHUDDisplaySameViewWaiting)
            {
                [MBProgressHUD cacheAllParametersWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy];

                NSMutableDictionary *isShow = signatureCache.firstObject;
                BOOL isView = [view isEqual:isShow[toast_Key_view]];
                if (isView) {
                    return NO; //如果view相同，则先记录等待上一个展示结束再展示新toast
                }
                
            }
            else if (ploy == MBProgressHUDDisplayIgnore)
            {
                return NO;//如果有正在展示的、直接忽略不展示
            }
            else
            {//默认策略、如果有正在展示的、如果所在view不同、同时展示在不同view上、view相同时立即移除上一个直接展示当前tosat
                [MBProgressHUD cacheAllParametersWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy];
            }
        }else{
            [MBProgressHUD cacheAllParametersWithMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:ploy];
        }
    }
    return YES;
}
+(void )cacheAllParametersWithMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay displayPloy:(MBProgressHUDDisplayPloy)ploy
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (message) {
        [dict setObject:message forKey:toast_Key_message];
    }
    if (imageName) {
        [dict setObject:imageName forKey:toast_Key_imageName];
    }
    if (view) {
        [dict setObject:view forKey:toast_Key_view];
    }
    if (delay) {
        [dict setObject:@(delay) forKey:toast_Key_delay];
    }
    if (ploy) {
        [dict setObject:@(ploy) forKey:toast_Key_ploy];
    }
    [signatureCache addObject:dict];
}
@end

//=============JLExtension======================//
@implementation MBProgressHUD (JLExtension)

+ (void)jl_showMessage:(NSString *)message toView:(UIView *)view
{
    [MBProgressHUD jl_showMessage:message customIcon:nil view:view hideAfterDelay:0 displayPloy:defaultDisplayPloy isQueue:NO];
}
+ (void)jl_showMessage:(NSString *)message toView:(UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD jl_showMessage:message customIcon:nil view:view hideAfterDelay:delay displayPloy:defaultDisplayPloy isQueue:NO];
}
+ (void)jl_showMessage:(nullable NSString *)message customIcon:(nullable NSString *)imageName view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    [MBProgressHUD jl_showMessage:message customIcon:imageName view:view hideAfterDelay:delay displayPloy:defaultDisplayPloy isQueue:NO];
}

//======loading==========
+(void)jl_showLoadingWithStatus:(NSString *)message toView:(UIView *)view
{
    if (!view)
    {
        view = [MBProgressHUD jl_getFrontWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud)
    {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:0.75f];
    hud.contentColor = [UIColor whiteColor];
    hud.label.text= NSLocalizedString(message, nil);
    hud.label.font = [UIFont systemFontOfSize:15];
}
+ (void)jl_showGifWithGifName:(NSString *)gifName imagesCount:(NSInteger)imgCount toView:(UIView *)view
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i=0; i<=imgCount; ++i) {
        NSString *strImg = [NSString stringWithFormat:@"%@%d",gifName,i];
        UIImage *image = [UIImage imageNamed:strImg];
        if (image) {
            [arrayM addObject:image];
        }
    }
    
    UIImage *image = arrayM.firstObject;
    CGFloat scale = [UIScreen mainScreen].bounds.size.width/375.f;
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,scale* image.size.width/3, scale *image.size.height/3)];
    gifView.animationImages = arrayM;
    gifView.animationDuration = 0.05*arrayM.count;
    gifView.animationRepeatCount = 0;//播放次数（一直循环播放）
    [gifView startAnimating];//开始播放
    
    [MBProgressHUD jl_showCustomView:gifView message:nil colorAlpha:0 view:view hideAfterDelay:0];
}
+ (void)jl_showGifWithGifName:(NSString *)gifName message:(nullable NSString *)message toView:(nullable UIView *)view
{
    UIImage *image = [UIImage zx_animatedGIFNamed:gifName];
    UIImageView *gifView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    gifView.image = image;
    
    [MBProgressHUD jl_showCustomView:gifView message:message colorAlpha:0 view:view hideAfterDelay:0];
}
/**
 展示一个自定义view和message(如果存在、上下布局,上下间隙为MBDefaultPadding)
 
 @param customView 要展示的自定义view
 @param message 要展示文案
 @param colorAlpha 背景的颜色透明度
 @param view 所加的view层，如果传nil，默认window；
 @param delay 展示多久后隐藏、即展示时间, 小于等于0持续展示
 */
+ (void)jl_showCustomView:(nullable UIView *)customView message:(nullable NSString *)message colorAlpha:(CGFloat)colorAlpha view:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    if (!view)
    {
        view = [MBProgressHUD jl_getFrontWindow];
    }
    [MBProgressHUD hideHUDForView:view animated:NO];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    
    if (message.length>12){
        hud.detailsLabel.text= NSLocalizedString(message, nil);
        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
    }else{
        hud.label.text= NSLocalizedString(message, nil);
    }
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor colorWithWhite:0 alpha:colorAlpha];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    
    if (delay>0){//小于等于0持续展示
        [hud hideAnimated:YES afterDelay:delay];
    }
}
+ (BOOL)jl_hideHUDForView:(nullable UIView *)view
{
    return [MBProgressHUD jl_hideHUDForView:view hideAfterDelay:0];
}
+ (BOOL)jl_hideHUDForView:(nullable UIView *)view hideAfterDelay:(NSTimeInterval)delay
{
    if (!view)
    {
        view = [MBProgressHUD jl_getFrontWindow];
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        [hud hideAnimated:NO afterDelay:delay];
        return YES;
    }
    return NO;
}

@end
