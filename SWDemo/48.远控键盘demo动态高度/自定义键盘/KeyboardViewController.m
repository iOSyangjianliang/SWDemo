//
//  KeyboardViewController.m
//  自定义键盘
//
//  Created by 杨建亮 on 2019/4/9.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "KeyboardViewController.h"

@interface KeyboardViewController ()
@property (nonatomic, strong) UIButton *nextKeyboardButton;
@end

@implementation KeyboardViewController

- (void)updateViewConstraints {
    [super updateViewConstraints];
    
    // Add custom view sizing constraints here
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    // Perform custom UI setup here
//    self.nextKeyboardButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    [self.nextKeyboardButton setTitle:NSLocalizedString(@"Next Keyboard", @"Title for 'Next Keyboard' button") forState:UIControlStateNormal];
//    [self.nextKeyboardButton sizeToFit];
//    self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [self.nextKeyboardButton addTarget:self action:@selector(handleInputModeListFromView:withEvent:) forControlEvents:UIControlEventAllTouchEvents];
//    
//    [self.view addSubview:self.nextKeyboardButton];
//    
//    [self.nextKeyboardButton.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
//    [self.nextKeyboardButton.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIInputView *view = [[UIInputView alloc] initWithFrame:CGRectMake(0, 0, 200, 180) inputViewStyle:UIInputViewStyleKeyboard];
    view.backgroundColor = [UIColor redColor];
    view.allowsSelfSizing = YES;

    self.inputView = view;
    
    
    // 设置数字键盘的UI
    //数字按钮布局
    for (int i=0; i<10; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame=CGRectMake(20+45*(i%3), 20+45*(i/3), 40, 40);
        btn.backgroundColor=[UIColor greenColor];
        [btn setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        btn.tag=101+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    //创建切换键盘按钮
    UIButton * change = [UIButton buttonWithType:UIButtonTypeSystem];
    change.frame=CGRectMake(200,20, 80, 40) ;
    NSLog(@"%f,%f",self.view.frame.size.height,self.view.frame.size.width);
    [change setBackgroundColor:[UIColor blueColor]];
    [change setTitle:@"切换键盘" forState:UIControlStateNormal];
    [change addTarget:self action:@selector(change) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:change];
    //创建删除按钮
    UIButton * delete = [UIButton buttonWithType:UIButtonTypeSystem];
    delete.frame=CGRectMake(200, 120, 80, 40);
    [delete setTitle:@"delete" forState:UIControlStateNormal];
    [delete setBackgroundColor:[UIColor purpleColor]];
    [delete addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
    
    
    UIButton * test = [UIButton buttonWithType:UIButtonTypeSystem];
    test.frame=CGRectMake(280, 100, 60, 60);
    [test setTitle:@"test" forState:UIControlStateNormal];
    [test setBackgroundColor:[UIColor yellowColor]];
    [test addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:test];

    NSLog(@"%@",self.inputView);

}
-(void)test
{
//    NSLog(@"%@",NSStringFromCGRect(self.inputView.frame));

    self.inputView.frame = CGRectMake(0, 0, 400, 260);
    
}

//删除方法
-(void)delete{
    if (self.textDocumentProxy.documentContextBeforeInput) {
        [self.textDocumentProxy deleteBackward];
    }
}
//切换键盘方法
-(void)change{
    [self advanceToNextInputMode];
}
//点击数字按钮 将相应数字输入
-(void)click:(UIButton *)btn{
    [self.textDocumentProxy insertText:[NSString stringWithFormat:@"%ld",btn.tag-101]];
}

- (void)textWillChange:(id<UITextInput>)textInput {
    // The app is about to change the document's contents. Perform any preparation here.
}

- (void)textDidChange:(id<UITextInput>)textInput {
    // The app has just changed the document's contents, the document context has been updated.
    
    UIColor *textColor = nil;
    if (self.textDocumentProxy.keyboardAppearance == UIKeyboardAppearanceDark) {
        textColor = [UIColor whiteColor];
    } else {
        textColor = [UIColor blackColor];
    }
    [self.nextKeyboardButton setTitleColor:textColor forState:UIControlStateNormal];
}

@end
