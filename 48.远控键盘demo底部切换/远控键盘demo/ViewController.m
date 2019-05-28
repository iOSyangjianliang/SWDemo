//
//  ViewController.m
//  远控键盘demo
//
//  Created by 杨建亮 on 2019/2/18.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"
#import "SWRCInputAccessoryView.h"

@interface ViewController ()
{
    UITextView *_TextView;
    
    SWRCInputAccessoryView *_accV;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor purpleColor];
//    
//    UITextView *TextView = [[UITextView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
//    TextView.backgroundColor  = [UIColor whiteColor];
//    TextView.autocorrectionType = UITextAutocorrectionTypeNo;
//    [self.view addSubview:TextView];
//    _TextView = TextView;
    
//    SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] init];
//    _TextView.inputAccessoryView = accV;
//    accV.sw_textView = _TextView;
//    _accV = accV;
    
    
    UITextField *textFild = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, 40, 40)];
//    textFild.userInteractionEnabled = NO;
    textFild.backgroundColor  = [UIColor whiteColor];
    
    SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] init];
    textFild.inputAccessoryView = accV;
    accV.sw_textField = textFild;
//    textFild.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textFild];
    
    textFild.secureTextEntry = YES;
//    textFild.autocorrectionType = UITextAutocorrectionTypeNo;

    // 设置自定义键盘View
    //    self.sw_textField.inputView = self.inputView;
    //    self.sw_textField.inputAccessoryView =;
    //    self.sw_textField.secureTextEntry = YES;
    //    self.sw_textField.autocorrectionType = UITextAutocorrectionTypeNo;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    _accV.inputViewType  = (_accV.inputViewType+1)%5;

//    SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 200)];
//    _TextView.inputAccessoryView = accV;
//    accV.sw_textView = _TextView;
//    
//    [_TextView reloadInputViews];

}

@end
