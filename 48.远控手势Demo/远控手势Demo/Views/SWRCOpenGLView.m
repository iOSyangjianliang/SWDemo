//
//  SWRCOpenGLView.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/14.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCOpenGLView.h"

@interface SWRCOpenGLView ()
@property(nonatomic, strong) UIImageView *testIMV;
@end
@implementation SWRCOpenGLView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    self.testIMV = [[UIImageView alloc] initWithFrame:self.bounds];
//    _testIMV.image = [UIImage imageNamed:@"电脑桌面"];
    self.frameSize = CGSizeMake(2880, 1800);
    [self addSubview:_testIMV];
    
//     UIImageView *imv = [[UIImageView alloc] initWithFrame:self.bounds];
//    _testIMV = imv;
//    [self addSubview:_testIMV];
    _testIMV.image = [UIImage imageNamed:@"手势说明"];
//    self.frameSize = CGSizeMake(2170, 1616);
    
   
    
//    self.backgroundColor = [UIColor redColor];

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)layoutSubviews
{
    [super layoutSubviews];
    _testIMV.frame = self.bounds;
}

//设置阴影
- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

//-(CGSize)frameSize
//{
//   return _frameSize;
//    
//    return CGSizeMake(2170, 1616);
//}
@end
