//
//  RRNoteDetailViewController.m
//  RuoRouNotes
//
//  Created by 杨建亮 on 2019/4/10.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "RRNoteDetailViewController.h"

@interface RRNoteDetailViewController ()

@end

@implementation RRNoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"xiangqing";
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor blueColor];
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
