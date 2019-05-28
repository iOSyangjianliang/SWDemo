//
//  SWRCInputAccessoryView.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCInputAccessoryView.h"

@interface SWRCInputAccessoryView ()
@property(nonatomic, strong) NSMutableArray *arrayMBtns;
@end

static CGFloat height_InputAccessoryView = 40.f;
@implementation SWRCInputAccessoryView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height_InputAccessoryView)]) {
        
        [self buildUI];
        [self addToobarBtns];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)buildUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"e5e5e5" alpha:1];

    // 设置自定义键盘View
//    self.sw_textField.inputView = self.inputView;
//    self.sw_textField.inputAccessoryView =;
//    self.sw_textField.secureTextEntry = YES;
//    self.sw_textField.autocorrectionType = UITextAutocorrectionTypeNo;
}
-(void)addToobarBtns
{
    self.arrayMBtns = [NSMutableArray array];
    NSArray *array = @[@"",@"Ctrl",@"Alt",@"Delete",@"更多",@""];
    CGFloat W = ([UIScreen mainScreen].bounds.size.width -5*2 -(array.count-1)*4 ) /array.count;
    CGFloat X = 5;
    for (int i=0; i<array.count; ++i) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X, 4, W, height_InputAccessoryView-4-3)];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [btn setTitle:array[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"2f2f2f"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if (i==0)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"kb_win_d"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"kb_win_c"] forState:UIControlStateSelected];
        }
        else if (i==array.count-1)
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"kb_pull"] forState:UIControlStateNormal];
        }
        else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"kb_bg"] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"kb_selected"] forState:UIControlStateSelected];
        }
        [btn addTarget:self action:@selector(clickToobarBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        [self addSubview:btn];
        [self.arrayMBtns addObject:btn];
        X = X+W+4;
    }
}
-(void)clickToobarBtn:(UIButton *)sender
{
    if (sender.tag == 105)
    {//关闭键盘
        [self.sw_textField resignFirstResponder];
        return;
    }
    else
    {
        [self.arrayMBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([sender isEqual:obj]){
                sender.selected = !sender.selected;
            }else{
                UIButton *btn = obj;
                btn.selected = NO;
            }
        }];
        
        if (sender.selected){
            SWRCInputView *swrcinputView = [[SWRCInputView alloc] initWithInputType:sender.tag-100 dataSource:self.inputDataSource];
            self.sw_textField.inputView = swrcinputView;
            self.inputView = swrcinputView;
        }else{
            self.sw_textField.inputView = nil;
        }
        [self.sw_textField reloadInputViews];
    }
}


/** 懒加载inputDataSource,键盘不能修改高度，每次创建新的、但自定义键盘的数据源保留 */
-(SWRCInputDataSource *)inputDataSource
{
    if (!_inputDataSource) {
        _inputDataSource = [[SWRCInputDataSource alloc] init];
    }
    return _inputDataSource;
}


@end
