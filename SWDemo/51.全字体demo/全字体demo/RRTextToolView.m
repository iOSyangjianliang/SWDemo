//
//  RRTextToolView.m
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/22.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "RRTextToolView.h"


@interface RRTextToolView ()
@property(nonatomic, weak)UIButton *lastSelectedBtn;

@end
@implementation RRTextToolView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    _tooV.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44);
    

}
-(NSString *)addFont:(NSString *)fontPath
{
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithFilename([fontPath UTF8String]);
    CGFontRef customfont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    NSString *fontName = (__bridge NSString *)CGFontCopyFullName(customfont);
    CFErrorRef error;
    CTFontManagerRegisterGraphicsFont(customfont, &error);
    if (error){
        // 为了可以重复注册
        CTFontManagerUnregisterGraphicsFont(customfont, &error);
        CTFontManagerRegisterGraphicsFont(customfont, &error);
    }
    CGFontRelease(customfont);
    
    return fontName;
}
-(void)buildUI
{
    NSString *fontPath  = [[NSBundle mainBundle]pathForResource:@"SentyCandy-color" ofType:@"ttf"];
    NSString *fameName = [self addFont:fontPath];

    NSArray *arr = @[@"键盘",@"若柔笔记",@"颜色",@"样式",@"关闭"];
    CGFloat X = 15.f;
    CGFloat space = (self.frame.size.width-60*arr.count-15*2)/(arr.count-1);

    for (int i=0; i<arr.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(X, 6, 60, 32)];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        if (i==1) {
            btn.titleLabel.font = [UIFont fontWithName:@"Hanyi Senty Candy" size:14];
        }else{
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
        }
        [btn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor whiteColor];
        [self addSubview:btn];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag  = 100+i;
        X = X+60+space;
        
        if (i==0) {
            btn.selected = YES;
            _lastSelectedBtn = btn;
        }
    }

    _functionView = [[RRTextView alloc] initWithFrame:CGRectMake(0, 44.f, self.frame.size.width, self.frame.size.height-44.f)];
    _functionView.backgroundColor = [UIColor purpleColor];
    [self addSubview:_functionView];
}
-(void)click:(UIButton *)sender
{
    _lastSelectedBtn.selected = NO;
    sender.selected = YES;
    [self.delegate rr_textToolView:self didSelectIndex:sender.tag-100 lastIndex:_lastSelectedBtn.tag-100];
   
    _lastSelectedBtn = sender;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
