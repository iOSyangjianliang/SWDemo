//
//  LeftViewController.m
//  抽屉效果demo
//
//  Created by 杨建亮 on 2019/1/7.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "LeftViewController.h"
#import "TestViewController.h"
#import "LeftSlideViewController.h"

@interface LeftViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *groupTitleArrayM;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor  = [UIColor redColor];
    
        [self setData];
        [self buildUI];
}
- (void) viewWillAppear:(BOOL)animated
{
    NSLog(@"LeftViewController viewWillAppear");
    [super viewWillAppear:animated];
    //    self.leftVC.view.hidden = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
        cell.textLabel.text = [NSString stringWithFormat:@"LeftSlideViewController%ld==%ld",(long)indexPath.section,(long)indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"LeftSlideViewControllerLeftSlideViewController%ld==%ld",(long)indexPath.section,(long)indexPath.row];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
////    [self.leftVC closeLeftVC:NO];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"密码修改成功" message:@"请使用新密码登录" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *doAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//    }];
//    [alertController addAction:doAction];
//    [self.leftVC presentViewController:alertController animated:NO completion:nil];
    

//
//    [self.leftVC closeLeftVC:YES];
//    TestViewController *vc = [[TestViewController alloc] init];
//    vc.view.backgroundColor  = [UIColor yellowColor];
//    [self.leftVC.mainVC pushViewController:vc animated:YES];


//    [self.leftVC closeLeftVC:YES];

    TestViewController *vc = [[TestViewController alloc] init];
    vc.view.backgroundColor  = [UIColor yellowColor];
//    [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    [self.leftVC presentViewController:vc animated:YES completion:nil];

}
////设置第二组可以左滑删除
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 1) {
//        return YES;
//    }
//    return NO;
//}
//// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        if (indexPath.section == 1) {
//            [self removeBarByAlertVCWithIndexPath:indexPath];
//        }
//    }
//}
//
//-(void)removeBarByAlertVCWithIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end
