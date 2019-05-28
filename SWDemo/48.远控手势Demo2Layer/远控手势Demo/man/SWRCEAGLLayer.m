//
//  SWRCEAGLLayer.m
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/2/27.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "SWRCEAGLLayer.h"
#import <UIKit/UIKit.h>

@interface SWRCEAGLLayer ()
@property(nonatomic, strong) UIImageView *testIMV;
@end

@implementation SWRCEAGLLayer

-(instancetype)init
{
    if (self = [super init]) {
        [self buildUI];
    }
    return self;
}
-(void)buildUI
{
    //    self.testIMV = [[UIImageView alloc] initWithFrame:self.bounds];
    //    _testIMV.image = [UIImage imageNamed:@"电脑桌面"];
    //    self.frameSize = CGSizeMake(2880, 1800);
    //    [self addSubview:_testIMV];
    
    UIImageView *imv = [[UIImageView alloc] initWithFrame:self.bounds];
    _testIMV = imv;
    [self addSublayer:_testIMV.layer];
    
    _testIMV.image = [UIImage imageNamed:@"手势说明"];
    self.frameSize = CGSizeMake(2170, 1616);
    
    
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void)layoutSublayers
{
    [super layoutSublayers];
    _testIMV.frame = self.bounds;
}
@end
