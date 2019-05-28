//
//  AppDelegate.m
//  双Window的demo
//
//  Created by 杨建亮 on 2019/3/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AAAViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.backgroundColor = [UIColor redColor];
//    ViewController *vc = [[ViewController alloc] init];
//    self.window.rootViewController = vc;
//    // 让UIWindow显示出来(让窗口成为主窗口 并且显示出来)、一个应用程序只能有一个主窗口
//    [self.window makeKeyAndVisible];
//
//    // 2. 再创建一个窗口
//    UIWindow *w2 = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    w2.tag = 123;
//    AAAViewController *aVC = [[AAAViewController alloc] init];
//    w2.rootViewController = aVC;
//    w2.backgroundColor = [UIColor yellowColor];
//
//    [w2 makeKeyAndVisible];
//
//
//    // 3.创建两个文本输入框
//    // 3.1将文本输入框添加到window中
//    UITextField *tx1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 200, 40)];
//    tx1.borderStyle = UITextBorderStyleRoundedRect;
//    [self.window addSubview:tx1];
//
//    // 3.2将文本输入框添加到w2中
//    UITextField *tx2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 100, 40)];
//    tx2.borderStyle = UITextBorderStyleRoundedRect;
//    [w2 addSubview:tx2];
//
//
//    // 获取应用程序的主窗口
//    NSLog(@"%@", [UIApplication sharedApplication].keyWindow);
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //更新激活手势密码时间
    [self setGesturePasswordCurryTime];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    
    
    BOOL interval = [self isOutGesturePasswordTimeMore_15min];
    if ( interval) {
        [self.window endEditing:YES];

        if (!self.myWindow) {
            AAAWindow *window = [[AAAWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.tag = 10086;
            
            AAAViewController *aVC = [[AAAViewController alloc] init];
            UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:aVC];
            window.rootViewController = naVC;
            
            [self.window addSubview:window];
            [window makeKeyAndVisible];
            self.myWindow = window;
        }else{
            self.myWindow.hidden = NO;
           
            if (!self.myWindow.rootViewController) {
                AAAViewController *aVC = [[AAAViewController alloc] init];
                UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:aVC];
                self.myWindow.rootViewController = naVC;
            }
            [self.window addSubview:self.myWindow];
            [self.myWindow makeKeyAndVisible];
        }
      
        NSLog(@"keyWindow=%@",[UIApplication sharedApplication].keyWindow);
        
    }
}

- (void)setGesturePasswordCurryTime
{
    NSDate*currentDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:@"66666666"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)isOutGesturePasswordTimeMore_15min
{
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"66666666"];
    NSTimeInterval timestamp = [lastDate timeIntervalSinceNow];
    if (timestamp <= -1) {
        return YES;
    }
    return NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
