//
//  SWRCInputCell.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCInputCell.h"

@implementation SWRCInputCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.iconIMV.hidden = YES;

//    self.backGroundIMV.image = nil;
//    self.contentView.backgroundColor = [UIColor whiteColor];
//
//    self.contentView.layer.shadowColor = [UIColor redColor].CGColor;// [UIColor colorWithHexString:@"E7E7E7"].CGColor;
//    self.contentView.layer.shadowOffset = CGSizeMake(0,3);
//    self.contentView.layer.shadowOpacity = 0.6;;
//    self.contentView.layer.shadowRadius = 4.f;
//
//    self.contentView.layer.cornerRadius = 6.f;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor =[UIColor blackColor].CGColor;
    
//    self.contentView.layer.masksToBounds = YES;
}
-(void)setCellData:(SWRCInputModel *)model
{
    self.iconIMV.hidden = YES;
    if (model.itemUIStyle == SWRCItemUIStyle_ImgOnly)
    {
        
    }
    else if (model.itemUIStyle == SWRCItemUIStyle_Title_V_Title)
    {
        self.topLab.text = model.mainTitle ;
        self.midLab.text = nil;
        self.upLab.text = model.subTitle;
        self.rightLab.text = @"";
    }
    else if (model.itemUIStyle == SWRCItemUIStyle_Img_H_Title)
    {
        self.topLab.text = @"";
        self.midLab.text = @"";
        self.upLab.text = @"";
        self.rightLab.text = model.mainTitle;
        self.iconIMV.hidden = NO;
    }
    else
    {//SWRCItemUIStyle_TitleOnly

        self.topLab.text = @"";
        self.midLab.text = model.mainTitle;
        self.upLab.text = @"";
        self.rightLab.text = @"";
    }
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.contentView.alpha = 0.4;
    }else{
        [UIView animateWithDuration:0.25 animations:^{
            self.contentView.alpha = 1;
        }];
    }
}
@end
