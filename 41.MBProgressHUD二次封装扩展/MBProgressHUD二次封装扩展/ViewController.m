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
    [MBProgressHUD jl_showMessage:@"这是一个简短的描述信息" toView:nil];
//
//    [MBProgressHUD jl_showMessage:@"又一个好苏啊是吧 sad sad大大大师大师大师大的" toView:self.view hideAfterDelay:4.5];
    
//    [MBProgressHUD jl_showMessage:nil customIcon:@"pic_xitong" view:nil hideAfterDelay:2];

    
//    [MBProgressHUD jl_showGifWithGifName:@"clear_loading" message:@"关注成功" toView:nil];

//    [MBProgressHUD jl_showGifWithGifName:@"clear_loading" message:@"关注成功" toView:nil hideAfterDelay:3.5];
    
//    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:nil];//Assets.xcassets
//
//    [MBProgressHUD jl_showLoadingWithStatus:@"正在加载" toView:nil];
    
    
//    [self test];
    
    
    
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaiting];

//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaitingAndIgnoreSameToast];
//
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:nil hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaiting];
//    [MBProgressHUD jl_showMessage:@"加载成功哟" customIcon:nil view:self.view hideAfterDelay:4 displayPloy:MBProgressHUDDisplayWaiting];

//    [MBProgressHUD jl_hideHUDForView:self.view hideAfterDelay:2.5];
    
//    [MBProgressHUD jl_showMessage:@"网络重连成功" customIcon:nil view:nil hideAfterDelay:0 displayPloy:MBProgressHUDDisplayIgnore];
//    
//    [MBProgressHUD jl_showMessage:@"电话电话电话电话打的的的的的等待成功哟" customIcon:nil view:self.view hideAfterDelay:2.5 displayPloy:MBProgressHUDDisplayWaiting];


//    if (iss) {
//        ViewController *vc = [[ViewController alloc] init];
//        vc.view.backgroundColor = [UIColor yellowColor];
//        [self presentViewController:vc animated:YES completion:nil];
//        iss = NO;
//    }else{
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
   
}
static bool iss = YES;
-(void)test
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
    if (!hud){
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
//    if (message.length>12){
//        hud.detailsLabel.text= NSLocalizedString(message, nil);
//        hud.detailsLabel.font = [UIFont systemFontOfSize:15];
//    }else{
//        hud.label.text= NSLocalizedString(message, nil);
//    }
    hud.square = NO;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor clearColor];// [UIColor colorWithWhite:0 alpha:0.75];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    hud.progress = 0.6;
//    hud.customView = customView;
}
-(void)dealloc
{
    NSLog(@"delloc");
}
@end
