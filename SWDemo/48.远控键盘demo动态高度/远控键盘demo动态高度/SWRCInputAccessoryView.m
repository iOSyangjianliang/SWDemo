//
//  SWRCInputAccessoryView.m
//  远控键盘demo动态高度
//
//  Created by 杨建亮 on 2019/4/3.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "SWRCInputAccessoryView.h"

#import "Masonry.h"


@interface SWRCInputAccessoryView ()
@property(nonatomic,strong) UIView *contentHeightView;
@end

@implementation SWRCInputAccessoryView
-(instancetype)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor redColor];
        
        _contentHeightView = [[UIView alloc] init];
        [self addSubview:_contentHeightView];
        [_contentHeightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
            make.height.mas_equalTo(@(0));
        }];
    }
    return self;
}
- (void)setContentHeight:(CGFloat)contentHeight
{
    _contentHeight = contentHeight;
    
    
    [_contentHeightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
        make.height.mas_equalTo(@(contentHeight)).priority(1000);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
