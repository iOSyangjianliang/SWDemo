//
//  ViewController.m
//  双Window的demo
//
//  Created by 杨建亮 on 2019/3/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"


#import "AAAViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.www)
    {
        // 2. 再创建一个窗口
        AAAWindow *w2 = [[AAAWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        w2.tag = 123;
        AAAViewController *aVC = [[AAAViewController alloc] init];
        w2.rootViewController = aVC;
        w2.backgroundColor = [UIColor yellowColor];
        self.www = w2;//不强引用会被释放、展示不出来
        
        aVC.vc = self;
    }
    
    [self.www makeKeyAndVisible];

}

@end
