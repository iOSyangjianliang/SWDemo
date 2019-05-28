//
//  SWRCInputCell.h
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/13.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SWRCInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SWRCInputCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backGroundIMV;
@property (weak, nonatomic) IBOutlet UILabel *topLab;
@property (weak, nonatomic) IBOutlet UILabel *upLab;
@property (weak, nonatomic) IBOutlet UILabel *midLab;
@property (weak, nonatomic) IBOutlet UILabel *rightLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;

-(void)setCellData:(SWRCInputModel *)model;

@end

NS_ASSUME_NONNULL_END
