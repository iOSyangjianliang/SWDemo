//
//  ViewController.m
//  远控键盘demo动态高度
//
//  Created by 杨建亮 on 2019/4/3.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "SWRCInputAccessoryView.h"

@interface ViewController ()
@property(nonatomic, strong) UITextField *textFild;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    UIInputViewController
    
    UITextField *textFild = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 140, 140)];
    textFild.backgroundColor  = [UIColor lightGrayColor];
    [self.view addSubview:textFild];

    SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] init];
    textFild.inputAccessoryView = accV;

    _textFild = textFild;
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_textFild.isFirstResponder) {
        [_textFild resignFirstResponder];
    }
//    else{
//        
//        SWRCInputAccessoryView *accV =  _textFild.inputAccessoryView;
//        
//        accV.contentHeight = 40.f;
//    }
    
    
}

@end
