//
//  ViewController.m
//  MBProgressHUD二次封装扩展
//
//  Created by 杨建亮 on 2018/12/3.
//  Copyright © 2018年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

#import "MBProgressHUD+JLExtension.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [MBProgressHUD jl_showMessage:@"这是一 个简短的描述信息" toView:nil];
//
    [MBProgressHUD jl_showMessage:@"又一个好苏啊是吧 sad sad大大大师大师大师大的" toView:self.view hideAfterDelay:4.5];
    
    [MBProgressHUD jl_showMessage:nil customIcon:@"pic_xitong" view:nil hideAfterDelay:2];

    
//    [MBProgressHUD jl_showGifWithGifName:@"clear_loading" message:@"关注成功" toView:nil];

//    [MBProgressHUD jl_showGifWithGifName:@"clear_loading" message:@"关注成功" toView:nil hideAfterDelay:3.5];
    
//    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:nil];//Assets.xcassets
//
//    [MBProgressHUD jl_showLoadingWithStatus:@"正在加载" toView:nil];
    
    
//    [self test];
    
    
    
    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4];
    [MBProgressHUD jl_showMessage:nil customIcon:@"pic_xitong" view:nil hideAfterDelay:2];

    
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaitingAndIgnoreSameToast];
//
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:nil hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaiting];
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaiting];

//    [MBProgressHUD jl_hideHUDForView:self.view hideAfterDelay:2.5];
    
//    [MBProgressHUD jl_showMessage:@"网络重连成功" customIcon:nil view:nil hideAfterDelay:0 displayPloy:MBProgressHUDDisplayIgnore];
//    
    [MBProgressHUD jl_showMessage:@"电话电话电话电话打的的的的的等待成功哟" customIcon:nil view:self.view hideAfterDelay:2.5];

    [MBProgressHUD jl_showMessage:@"电话电话电话电话打的的的的的等待成功哟" customIcon:nil view:self.view hideAfterDelay:2.5];

}

@end
