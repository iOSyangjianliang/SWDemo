
//
//  SWGroupDetailController.m
//  shunxinwei
//
//  Created by 杨建亮 on 2018/12/12.
//  Copyright © 2018年 shunwang. All rights reserved.
//

#import "MainViewController.h"

#import "LeftSlideViewController.h"

#import "TestViewController.h"


@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) NSMutableArray *groupTitleArrayM;

@end

@implementation MainViewController
-(void)clickBto
{
   LeftSlideViewController *VC = [UIApplication sharedApplication].delegate.window.rootViewController;
    [VC setLeftViewControllerOpen:YES animated:YES];

//    if ([dele.slideVC closed]) {
//        [dele.slideVC openLeftView];
//    }else{
//        [dele.slideVC closed];
//    }
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    
//    
//    // 输出点击的view的类名
//    NSLog(@" 输出点击的view的类名%@", NSStringFromClass([touch.view class]));
//    
//    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return  YES;
//}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"mian";
    self.view.backgroundColor = [UIColor whiteColor];

//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickBto) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    [self setData];
    [self buildUI];
    
    
}
- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"MainViewController viewWillAppear");
    [super viewWillAppear:animated];
    //    self.leftVC.view.hidden = NO;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    UIViewController *vc = [[UIViewController alloc] init];
//    vc.view.backgroundColor  = [UIColor yellowColor];
//    [self.navigationController pushViewController:vc animated:YES];
}
-(void)setData
{
    self.groupTitleArrayM = [NSMutableArray array];
    [self.groupTitleArrayM addObject:@"标题信息"];
    [self.groupTitleArrayM addObject:@"分组内容"];
}
-(void)buildUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.rowHeight = 60.f;
    //    self.tableView.separatorColor = [UIColor colorWithHexString:@"ECECEC"];
    self.tableView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groupTitleArrayM.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return 3;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.001;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.groupTitleArrayM[section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= self.tableView.backgroundColor;
    header.textLabel.textColor = [UIColor colorWithRed:142.f/255.f green:142.f/255.f blue:142.f/255.f alpha:1];
    header.textLabel.font = [UIFont systemFontOfSize:16.f];
    header.clipsToBounds = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld==%ld",(long)indexPath.section,(long)indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"%ld==%ld",(long)indexPath.section,(long)indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{

    NSLog(@"%@",self.leftVC.presentedViewController);
    
    TestViewController *vc = [[TestViewController alloc] init];
    vc.view.backgroundColor  = [UIColor yellowColor];
    [self.leftVC presentViewController:vc animated:YES completion:nil];
    
    
//    TestViewController *vc2 = [[TestViewController alloc] init];
//    vc2.view.backgroundColor  = [UIColor blueColor];
//    [self.navigationController presentViewController:vc2 animated:YES completion:nil];
    
//        [self.navigationController pushViewController:vc animated:YES];
    
}
//设置第二组可以左滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        return YES;
    }
    return NO;
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {
            [self removeBarByAlertVCWithIndexPath:indexPath];
        }
    }
}

-(void)removeBarByAlertVCWithIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
