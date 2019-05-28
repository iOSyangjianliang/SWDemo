//
//  BBViewController.m
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/19.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "BBViewController.h"

@interface BBViewController ()
{
    UITextView *_textView;
}
@end

@implementation BBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 150, 300, 200)];
    [self.view addSubview:textView];
    _textView = textView;
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 40)];
    [btn setTitle:@"ziti" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(ccc:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)ccc:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        _textView.font = [UIFont fontWithName:@"Hanyi Senty Candy" size:18];
    }else{
        _textView.font = [UIFont systemFontOfSize:18];
    }
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
