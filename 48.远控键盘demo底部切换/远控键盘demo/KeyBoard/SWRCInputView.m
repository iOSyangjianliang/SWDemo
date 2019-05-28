//
//  SWRCInputView.m
//  shunxinwei
//
//  Created by 杨建亮 on 2019/2/12.
//  Copyright © 2019年 shunwang. All rights reserved.
//

#import "SWRCInputView.h"
#import "SWRCInputCell.h"

#define IsPortrait ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)

@interface SWRCInputView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UICollectionViewFlowLayout *flowLayout;
@property(nonatomic, strong)NSArray<SWRCInputModel *> *inputDataArray;
@property (strong, nonatomic) UIVisualEffectView *sw_visualEffectView;


@end
static CGFloat rowHeight = 44.f;

@implementation SWRCInputView

- (instancetype)initWithInputType:(SWRCInputViewType)inputType dataSource:(SWRCInputDataSource *)dataSource
{
    if (self = [super init]) {
        _inputType = inputType;
        _dataSource = dataSource;
        [self buildUI];
    }
    return self;
}
-(CGFloat)calculateHeightNeed
{

    NSInteger rows = 0;
    if (_inputType == SWRCInputViewType_Ctrl)
    {
        rows = 2;
    }
    else if (_inputType == SWRCInputViewType_Alt)
    {
        rows = 1;
    }
    else if (_inputType == SWRCInputViewType_Del)
    {
        rows = 1;
    }
    
    else if (_inputType == SWRCInputViewType_More)
    {
        rows = 4;
    }
    else if (_inputType == SWRCInputViewType_Win)
    {
        rows = 2;
    }
    else
    {
        rows = 0;
    }
    if (rows!=0) {
        CGFloat h = rowHeight*rows +_flowLayout.sectionInset.top +_flowLayout.sectionInset.bottom+(rows-1)*_flowLayout.minimumLineSpacing;
        return h;
    }else{
        return 0;
    }
}

-(void)buildUI
{
    //1.初始化布局
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _flowLayout.minimumLineSpacing = 8;
    _flowLayout.minimumInteritemSpacing = 6;
    _flowLayout.sectionInset = UIEdgeInsetsMake(8, 5, 4, 5);
    
    //2.计算自身键盘高度
    CGFloat height = [self calculateHeightNeed];
    if (@available(iOS 11.0, *)) {
        CGFloat safeAreaInsets_bottom = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom;
        height += safeAreaInsets_bottom;
    }
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);

    //添加系统键盘同样模糊效果
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *visualEffView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffView.frame = self.bounds;
    [self addSubview:visualEffView];
    self.sw_visualEffectView = visualEffView;
    
    //获取数据源
    _inputDataArray = [_dataSource getDataWithInputType:_inputType];

    //集合视图
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self addSubview:_collectionView];
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.naviView.mas_bottom);
//        make.left.mas_equalTo(self.view);
//        make.right.mas_equalTo(self.view);
//        make.bottom.mas_equalTo(self.view);
//    }];
    //注册
    [_collectionView registerNib:[UINib nibWithNibName:@"SWRCInputCell"bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    
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
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0){
        return self.inputDataArray.count;
    }
    else if (section == 1){

    }
    else if (section == 2){

    }
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SWRCInputModel *model = _inputDataArray[indexPath.row];
    CGFloat W = self.collectionView.bounds.size.width-_flowLayout.sectionInset.left-_flowLayout.sectionInset.right-_flowLayout.minimumInteritemSpacing*(model.percentWidth.items-1);
    if (_inputType == SWRCInputViewType_More) {
        CGFloat width = W/9.f *model.percentWidth.percent-0.01;
        if ([model.mainTitle isEqualToString:@"BackSpace"] ) {
            width = width +_flowLayout.minimumInteritemSpacing;
        }
        CGSize size = CGSizeMake(width, rowHeight);
        return size;
    }else{
        CGFloat width = W/model.percentWidth.items*model.percentWidth.percent-0.01;
        CGSize size = CGSizeMake(width, rowHeight);
        return size;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeZero;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
    view.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    return view;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWRCInputCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    SWRCInputModel *model = _inputDataArray[indexPath.row];
    [cell setCellData:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
  
    
    
    CGFloat safeLeft = 0.0;
    if (@available(iOS 11.0, *)) {
        safeLeft = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.left;
    }
    CGFloat safeRight = 0.0;
    if (@available(iOS 11.0, *)) {
        safeLeft = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.right;
    }
    CGFloat max = safeLeft>safeRight?safeLeft:safeRight;
    
    self.collectionView.frame = CGRectMake(max , 0, self.bounds.size.width-max*2.f, self.bounds.size.height);
    _sw_visualEffectView.frame = self.bounds;
    
    NSLog(@"SWRCInputView layoutSubviews");
}
@end
