//
//  BBViewController.m
//  JLTextView
//
//  Created by 杨建亮 on 2019/11/18.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "BBViewController.h"
#import "JLTextView/JLTextView.h"

@interface BBViewController ()
{
    JLTextView *_textView;
}
@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    JLTextView *textView = [[JLTextView alloc] initWithFrame:CGRectMake(100, 100, 200, 300)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = [UIFont systemFontOfSize:20];
    
    [textView setTypingAttributesWithLineHeight:20 lineSpacing:100.f/3 textFont:nil textColor:nil];
    [self.view addSubview:textView];
    
    textView.isAutoAdjustTextInsetBehavior = YES;
    textView.maxNumberOfLines  = 4;
    textView.sizeToFitHight = YES;

    textView.text = @"我有一只小魔啊撸";
    
    _textView = textView;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _textView.font = [UIFont systemFontOfSize:40];//编辑状态下直接生效刷新UI（对与富文本）
    NSLog(@"typingAttributes=%@",_textView.typingAttributes);//40字体自动加入富文本

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
