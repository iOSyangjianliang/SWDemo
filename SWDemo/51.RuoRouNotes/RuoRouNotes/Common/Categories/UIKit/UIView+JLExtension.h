//
//  UIView+JLExtension.h
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/17.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JLExtension)
/**
 通过遍历view的父视图查找到cell，再根据cell获取NSIndexPath
 
 @param view tableview/collectionview
 @return 未找到父视图为cell(tableViewCell、collectionviewCell) 则return nil
 */
- (nullable NSIndexPath *)jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:(UIScrollView *)view;

@end

NS_ASSUME_NONNULL_END
