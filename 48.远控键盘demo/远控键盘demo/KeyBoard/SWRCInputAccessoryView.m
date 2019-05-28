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

//@property (nonatomic, strong) SWRCInputDataSource *inputDataSource;

@end

@implementation SWRCInputAccessoryView
- (instancetype)initWithInputViewType:(SWRCInputViewType)inputViewType isOpen:(BOOL)isOpen
{
    
    CGFloat height = 0.0;
    if (isOpen && inputViewType!=SWRCInputViewType_Default) {
        height = 44.f+40.f;
    }else{
        height = 44.f;
    }
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)]) {
        _inputViewType = inputViewType;
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"e5e5e5" alpha:1];

    if (_inputViewType != SWRCInputViewType_More) {
        SWRCInputDataSource *dataSource = [[SWRCInputDataSource alloc] init];
        SWRCInputView *inputView = [[SWRCInputView alloc] initWithInputType:_inputViewType dataSource:dataSource isDirV:NO];
        self.inputView = inputView;
        [self addSubview:inputView];
    }
    
    self.arrayMBtns = [NSMutableArray array];
    NSArray *array = @[@"",@"Ctrl",@"Alt",@"Delete",@"更多",@""];
    CGFloat W = ([UIScreen mainScreen].bounds.size.width -5*2 -(array.count-1)*4 ) /array.count;
    CGFloat H = W*95.f/164.f;
    CGFloat X = 5;
    CGFloat Y = self.frame.size.height-H -4;
    for (int i=0; i<array.count; ++i) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X,Y , W, H)];//164:95
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
        btn.tag = 100+i;//
        [self addSubview:btn];
        [self.arrayMBtns addObject:btn];
        X = X+W+4;
        
        if (self.inputViewType == i && (i!=array.count-1)) {
            btn.selected = YES;
        }
    }
}
-(void)clickToobarBtn:(UIButton *)sender
{
    if (sender.tag == 105)
    {//关闭键盘
        [self.sw_textView resignFirstResponder];
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
        if (sender.selected)
        {
            SWRCInputViewType inputViewType = sender.tag -100;
            
            if (inputViewType == SWRCInputViewType_More)
            {
                SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:SWRCInputViewType_More isOpen:NO];
                accV.sw_textView = self.sw_textView;
                accV.sw_textView.inputAccessoryView = accV;
                
                SWRCInputView *inputView = [[SWRCInputView alloc] initWithInputType:SWRCInputViewType_More dataSource:[[SWRCInputDataSource alloc] init] isDirV:YES];
                accV.sw_textView.inputView = inputView;
                accV.inputView = inputView;
                [accV.sw_textView reloadInputViews];
            }else{
                SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:inputViewType isOpen:YES];
                accV.sw_textView = self.sw_textView;
                accV.sw_textView.inputAccessoryView = accV;
                accV.sw_textView.inputView = nil;
                [accV.sw_textView reloadInputViews];
            }
        }
        else
        {
            SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:SWRCInputViewType_Default isOpen:NO];
            accV.sw_textView = self.sw_textView;
            accV.sw_textView.inputAccessoryView = accV;
            accV.sw_textView.inputView = nil;
            [accV.sw_textView reloadInputViews];
        }
    }
}


/** 懒加载inputDataSource,键盘不能修改高度，每次创建新的、但自定义键盘的数据源保留 */
//-(SWRCInputDataSource *)inputDataSource
//{
//    if (!_inputDataSource) {
//        _inputDataSource = [[SWRCInputDataSource alloc] init];
//    }
//    return _inputDataSource;
//}
-(void)dealloc
{
    NSLog(@"SWRCInputAccessoryView dealloc");
}

@end
