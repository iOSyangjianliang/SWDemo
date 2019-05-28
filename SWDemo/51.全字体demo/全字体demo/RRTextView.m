//
//  RRTextView.m
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/22.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "RRTextView.h"

@interface RRTextView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewFlowLayout *flowLayout;

@property(nonatomic, strong)NSArray *dataArray;


@end
@implementation RRTextView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  buildUI];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)buildUI
{
    _dataArray = @[@"字体颜色", @"字体填充色", @"背景颜色", @"阴影色",@"下划线颜色", @"strokeColor",@""];
    
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  
    _flowLayout.minimumLineSpacing = 8;
    _flowLayout.minimumInteritemSpacing = 30;
    _flowLayout.sectionInset = UIEdgeInsetsMake(8, 5, 4, 5);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
    //注册
    [_collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"Cell"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"SWRCInputCell"bundle:nil] forCellWithReuseIdentifier:@"Cell"];
//    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    
    if (@available(iOS 11.0, *)){
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    //    else{
    //        self.automaticallyAdjustsScrollViewInsets = NO;
    //    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(160, 40);
}
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeZero;
//}
//-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
//    view.backgroundColor = UIColorFromRGBA_HexValue(0xe5e5e5, 1);
//    return view;
//}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSLog(@"%@",cell);
    cell.backgroundColor = [UIColor redColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(sw_inputView:didSelected:)]) {
//        SWRCInputModel *model = _inputDataArray[indexPath.row];
//        [self.delegate sw_inputView:self didSelected:model];
//    }
}
@end
