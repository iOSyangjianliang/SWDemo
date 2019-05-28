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

@property(nonatomic, strong) UIView *btnsContentView;

@end

@implementation SWRCInputAccessoryView
- (instancetype)initWithInputViewType:(SWRCInputViewType)inputViewType
{
    CGFloat space = LCDScale_iphone6_Width(8.f);//按钮间隙
    CGFloat W = (SCREEN_MIN_LENGTH -5*2 -5*space)/6;
    CGFloat H = W*95.f/164.f +8;
    
    CGFloat height;
    if (inputViewType !=SWRCInputViewType_Default && inputViewType !=SWRCInputViewType_More) {
        height = H+ 36.f;
    }else{
        height = H;
    }
    
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)]) {
        _inputViewType = inputViewType;
        [self buildUI];
    }
    return self;
}
-(void)setInputViewDelegate:(id<SWRCInputViewDelegate>)inputViewDelegate
{
    _inputViewDelegate = inputViewDelegate;
    if (self.inputView) {
        self.inputView.delegate = inputViewDelegate;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame =  self.btnsContentView.frame;
    frame.origin.x = (self.frame.size.width-frame.size.width)/2;
    self.btnsContentView.frame = frame;

    if (self.inputView) {
        CGRect fra = self.inputView.frame;
        fra.size.width = self.frame.size.width;
        self.inputView.frame = fra;
    }
    
}
-(void)buildUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"e5e5e5" alpha:1];
//    self.backgroundColor = [UIColor redColor];

    if ( _inputViewType!=SWRCInputViewType_Default && _inputViewType!=SWRCInputViewType_More) {
        SWRCInputDataSource *dataSource = [[SWRCInputDataSource alloc] init];
        SWRCInputView *inputView = [[SWRCInputView alloc] initWithInputType:_inputViewType dataSource:dataSource isDirV:NO];
        inputView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        [self addSubview:inputView];
        self.inputView = inputView;
    }
    
    self.arrayMBtns = [NSMutableArray array];
    NSArray *array = @[@"",@"Ctrl",@"Alt",@"Delete",@"更多",@""];

  
    CGFloat W = (SCREEN_MIN_LENGTH -5*2 -(array.count-1)*8 ) /array.count;
    CGFloat H = W*95.f/164.f;
    CGFloat X = 0;
    CGFloat space = LCDScale_iphone6_Width(8.f);//按钮间隙

    UIView *btnsContentView =  [[UIView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-(H+8), self.frame.size.width, H+4*2)];
    btnsContentView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5" alpha:1];
    [self addSubview:btnsContentView];
    self.btnsContentView = btnsContentView;
    
    for (int i=0; i<array.count; ++i) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X,4 , W, H)];//164:95
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:LCDScale_iphone6_Width(13.5f)];
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
        [self.btnsContentView addSubview:btn];
        [self.arrayMBtns addObject:btn];
        X = X+W+space;
        
        if (self.inputViewType == i && (i!=array.count-1)) {
            btn.selected = YES;
        }
    }
    
    CGRect frame =  self.btnsContentView.frame;
    frame.size.width = X-space;
    frame.origin.x = (self.frame.size.width-frame.size.width)/2;
    self.btnsContentView.frame = frame;
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
                SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:SWRCInputViewType_More];
                accV.sw_textView = self.sw_textView;//切换时设置sw_textView（weak）
                accV.sw_textView.inputAccessoryView = accV;
                
                SWRCInputDataSource *dataSource = [[SWRCInputDataSource alloc] init];
                SWRCInputView *inputView = [[SWRCInputView alloc]initWithInputType:SWRCInputViewType_More dataSource:dataSource isDirV:YES];
                inputView.delegate = self.inputViewDelegate;
                accV.sw_textView.inputView = inputView;
                accV.inputView = inputView;
                
                [accV.sw_textView reloadInputViews];
                accV.inputViewDelegate = self.inputViewDelegate;//切换时设置代理（weak）
                
            }else{
                SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:inputViewType];
                accV.sw_textView = self.sw_textView;
                accV.sw_textView.inputAccessoryView = accV;
                accV.sw_textView.inputView = nil;
                [accV.sw_textView reloadInputViews];
                accV.inputViewDelegate = self.inputViewDelegate;//切换时设置代理（weak）
            }
        }
        else
        {
            SWRCInputAccessoryView *accV = [[SWRCInputAccessoryView alloc] initWithInputViewType:SWRCInputViewType_Default];
            accV.sw_textView = self.sw_textView;
            accV.sw_textView.inputAccessoryView = accV;
            accV.sw_textView.inputView = nil;
            [accV.sw_textView reloadInputViews];
            accV.inputViewDelegate = self.inputViewDelegate;//切换时设置代理（weak）
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
//    NSLog(@"SWRCInputAccessoryView dealloc");
}

@end
