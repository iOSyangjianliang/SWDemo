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
    
    [textView setTypingAttributesWithLineHeight:0 lineSpacing:0 textFont:nil textColor:nil];
    [self.view addSubview:textView];
    
//    textView.isAutoAdjustTextInsetBehavior = YES;
//    textView.maxNumberOfLines  = 4;
    textView.sizeToFitHight = YES;

    textView.text = @"我有一只小魔啊撸";
    
    _textView = textView;
    
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(canCanceddd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
    
//    [_textView setTypingAttributesWithLineHeight:20 lineSpacing:10 textFont:nil textColor:nil];
//
//    NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:_textView.text attributes:dictM];
//    _textView.attributedText = attStr;
//    _textView.typingAttributes = dictM;
    
    
//    _textView.font = [UIFont systemFontOfSize:40];//编辑状态下直接生效刷新UI（对与富文本）
    NSLog(@"typingAttributes=%@",_textView.typingAttributes);//40字体自动加入富文本

}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [_textView resignFirstResponder];
//    });
}

-(void)canCanceddd:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    
    if (sender.selected)
    {
//        _textView.jlFontSpacing  = 40;
//        _textView.jlLineSpacing  = 40;
        
        _textView.jlLineHeight  = 60;

    }else
    {
//        _textView.jlFontSpacing  = 10;
//        _textView.jlLineSpacing  = 10;
        
        _textView.jlLineHeight  = 30;

    }
    
//    if (sender.selected)
//    {
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        [dictM setObject:[UIColor redColor] forKey:NSForegroundColorAttributeName];
//
//        if (YES) {
//            NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//            [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//            _textView.attributedText = attStrM;
//        }
//
//        _textView.typingAttributes = dictM;
//
//    }else
//    {
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        [dictM setObject:[UIColor purpleColor] forKey:NSForegroundColorAttributeName];
//
//        if (YES) {
//            NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//            [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//            _textView.attributedText = attStrM;
//        }
//
//        _textView.typingAttributes = dictM;
//    }
    
    
//    if (sender.selected)
//    {
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        NSMutableParagraphStyle *paragraphStyle = [dictM objectForKey:NSParagraphStyleAttributeName];
//        if (paragraphStyle &&  [paragraphStyle isKindOfClass:NSMutableParagraphStyle.class]) {
//            paragraphStyle.lineSpacing = 40;// 字体的行间距
//        }else{
//            NSMutableParagraphStyle *paragraphStyleNew = [[NSMutableParagraphStyle alloc] init];
//            paragraphStyleNew.lineSpacing = 40;// 字体的行间距
//            [dictM setObject:paragraphStyleNew forKey:NSParagraphStyleAttributeName];
//        }
//        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//        [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//
//        _textView.attributedText = attStrM;
//        _textView.typingAttributes = dictM;
//
//    }else
//    {
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        NSMutableParagraphStyle *paragraphStyle = [dictM objectForKey:NSParagraphStyleAttributeName];
//        if (paragraphStyle &&  [paragraphStyle isKindOfClass:NSMutableParagraphStyle.class]) {
//            paragraphStyle.lineSpacing = 10;// 字体的行间距
//        }else{
//            NSMutableParagraphStyle *paragraphStyleNew = [[NSMutableParagraphStyle alloc] init];
//            paragraphStyleNew.lineSpacing = 10;// 字体的行间距
//            [dictM setObject:paragraphStyleNew forKey:NSParagraphStyleAttributeName];
//        }
//        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//        [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//
//        _textView.attributedText = attStrM;
//        _textView.typingAttributes = dictM;
//    }
   
    
//    if (sender.selected) {
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        [dictM setObject:@(40) forKey:NSKernAttributeName];
//
//        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//        [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//
//        _textView.attributedText = attStrM;
//        _textView.typingAttributes = dictM;
//    }else{
//        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:_textView.typingAttributes];
//        [dictM setObject:@(-5) forKey:NSKernAttributeName];
//
//        NSMutableAttributedString *attStrM = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
//        [attStrM setAttributes:dictM range:NSMakeRange(0, _textView.attributedText.length)];
//
//        _textView.attributedText = attStrM;
//        _textView.typingAttributes = dictM;
//    }
//    
  
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
