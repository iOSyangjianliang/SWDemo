//
//  UIView+JLExtension.m
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/17.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import "UIView+JLExtension.h"

@implementation UIView (JLExtension)
- (nullable NSIndexPath *)jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:(UIScrollView *)view
{
    UIView *superview = self.superview;
    while (superview) {
        if ([superview isKindOfClass:[UITableViewCell class]])
        {
            if ([view isKindOfClass:[UITableView class]])
            {
                UITableView *tableView = (UITableView *)view;
                UITableViewCell *tableViewCell = (UITableViewCell *)superview;
                NSIndexPath* indexPath = [tableView indexPathForCell:tableViewCell];
                return indexPath;
            }
        }
        if ([superview isKindOfClass:[UICollectionViewCell class]])
        {
            if ([view isKindOfClass:[UICollectionView class]])
            {
                UICollectionView *collectionView = (UICollectionView *)view;
                UICollectionViewCell *collectionViewCell = (UICollectionViewCell *)superview;
                NSIndexPath* indexPath = [collectionView indexPathForCell:collectionViewCell];
                return indexPath;
            }
        }
        superview = superview.superview;
    }
    return nil;
}

@end
