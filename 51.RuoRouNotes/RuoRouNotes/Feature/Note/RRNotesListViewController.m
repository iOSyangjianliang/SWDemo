//
//  RRNotesListViewController.m
//  RuoRouNotes
//
//  Created by 杨建亮 on 2019/4/10.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "RRNotesListViewController.h"
#import "RRNoteDetailViewController.h"

@interface RRNotesListViewController ()

@end

@implementation RRNotesListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationItem.title = @"时光轴";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    RRNoteDetailViewController *vc = [[RRNoteDetailViewController alloc] init];
    vc.view.backgroundColor = [UIColor yellowColor];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
