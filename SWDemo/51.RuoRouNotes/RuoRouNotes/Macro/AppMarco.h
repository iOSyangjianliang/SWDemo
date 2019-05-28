//
//  AppMarco.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/10.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#ifndef AppMarco_h
#define AppMarco_h

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

#import "NotificationMarco.h"
#import "StoryboardHeader.h"

#import "SWBaseNavigationController.h"



//获取屏幕 宽度、高度
#ifndef LCDW
#define LCDW ([[UIScreen mainScreen] bounds].size.width)
#endif

#ifndef LCDH
#define LCDH ([UIScreen mainScreen].bounds.size.height)
#endif

#ifndef SCREEN_MAX_LENGTH
#define SCREEN_MAX_LENGTH (MAX(LCDW, LCDH))
#define SCREEN_MIN_LENGTH (MIN(LCDW, LCDH))
#endif

//设置iphone6尺寸比例/竖屏,UI所有设备等比例缩放
#define LCDScale_iphone6_Width(X)    ((X)*SCREEN_MIN_LENGTH/375)
//iphone5,6 一样，plus、X系列放大，用于间距，字体大小，文本控件高度；
//宏定义的变量数字一定要加()才能准、CGFloat right = (LCDScale_5Equal6_To6plus(-93.f))-15.f
#define LCDScale_5Equal6_To6plus(X) ((SCREEN_MIN_LENGTH>(375.f)) ? ((X)*SCREEN_MIN_LENGTH/375) : (X))

//获取安全区“底部”高度
#ifndef  HEIGHT_TABBAR_SAFE
#define  HEIGHT_TABBAR_SAFE  [UIDevice safeAreaInsets_Bottom]
#endif

//是否是刘海屏X系列
#ifndef  IS_IPHONE_XXX
#define  IS_IPHONE_XXX      HEIGHT_TABBAR_SAFE>(0.0)?YES:NO
#endif

//状态栏高度（若状态栏隐藏则高度为0）
#ifndef  HEIGHT_STATEBAR
#define  HEIGHT_STATEBAR     ([[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

//导航bar高度
#ifndef  HEIGHT_NAVBAR
#define  HEIGHT_NAVBAR       (44.f+HEIGHT_STATEBAR)
#endif

//tabbar高度
#ifndef  HEIGHT_TABBAR
#define  HEIGHT_TABBAR       (49.f+HEIGHT_TABBAR_SAFE)
#endif


//应用程序的主window
#ifndef APP_MainWindow
#define APP_MainWindow    [[[UIApplication sharedApplication] delegate] window]
#endif

#define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//定义block使用的weak引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//NSLog 根据url和dictionary 参数 打印httpURL请求地址
#ifndef JL_NSLog_HTTPURL
#define JL_NSLog_HTTPURL(hostURL, parameterDic) \
NSString *string = [NSString stringWithFormat:@"%@?", hostURL];\
NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameterDic];\
NSMutableArray *array = [NSMutableArray array];\
[dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { \
NSString *para = [NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]];\
[array addObject:para];\
}];\
NSString *p = [array componentsJoinedByString:@"&"];\
NSString *urlString = [string stringByAppendingString:p];\
NSLog(@"%@",urlString);
#endif

//交换二个实例方法的IMP（方法实现）
static inline void jl_Swizzling_exchangeMethod(Class theClass, SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(theClass, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(theClass, swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

//class_addMethod的实现会覆盖父类的方法实现，但不会取代本类中已存在的实现，如果本类中包含一个同名的实现，则函数会返回NO
static inline BOOL jl_addMethod(Class theClass, SEL selector, Method method) {
    return class_addMethod(theClass, selector,  method_getImplementation(method),  method_getTypeEncoding(method));
}

//==========生产包请设置YES！ 生产包请设置YES！ 生产包请设置YES==================
static BOOL const IsProductionEnvironment = NO;//除Appstore生产包、其他环境设置NO、目前用于防止测试数据干扰MTA信息采集

//接口请求域名地址
//static NSString *const APP_BaseURL = @"https://www.weihuyun.cn:8084";


static NSString *const APP_BaseURL = @"http://10.30.251.115:8092/shunXW";
//static NSString *const APP_BaseURL = @"http://www.weihuyun2.cn:8092/shunXW";
//static NSString *const APP_BaseURL = @"http://10.30.251.115:8092/shunXW";
//static NSString *const APP_BaseURL = @"https://www.weihuyun.cn:8084/shunXW";
//static NSString *const APP_BaseURL = @"http://10.30.251.33/shunXW";

static BOOL DEBUG_MODE = YES;
static NSString *GAME_ICON_URL = @"https://www.weihuyun.cn/upload/%@/%@.png";
static NSString *XXTEA_KEY = @"!weihuyun@shunwang#$";
static NSString *KEY_SHOW_GUIDE = @"key_show_guide";
static NSString *EVENT_REMOTE_HELP = @"event_remote_help";//扫码启动APP
static NSString *EVENT_REMOTE_HELP_WillPush = @"event_remote_help_willPush";//扫码协助将要跳转
static NSString *EVENT_REMOTE_HELP_REQ = @"event_remote_help_req";//远控协助
static NSString *EVENT_REMOTE_CONNECTED = @"event_remote_connected";//远控建立连接
static NSString *EVENT_REMOTE_DISCONNECT = @"event_remote_disconnect";//远控中断
static NSString *EVENT_WEBRTC_REMOTE_CONTROL_CONNECTED = @"event_webrtc_remote_control_connected";//webrtc远控建立
static NSString *EVENT_REMOTE_CLOSE = @"event_remote_close";//关闭远控
static NSString *EVENT_REMOTE_KEYBOARD_CMD = @"event_remote_keyboard_cmd";//请求发起远控连接
static NSString *EVENT_FILE_DELETE_SUCCESS = @"event_file_delete_success";//文件删除成功
static NSString *EVENT_APPDIDBECOMEALIVE = @"event_appdidbecomealive";//应用程序进入前台
static NSString *EVENT_ADDGAME = @"event_addgame";//添加游戏

#endif /* AppMarco_h */
