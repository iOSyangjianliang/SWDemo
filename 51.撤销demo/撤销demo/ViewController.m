//
//  ViewController.m
//  撤销demo
//
//  Created by 顺网-yjl on 2019/4/11.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    UIView *_testView;
    
    UIView *_testSecondView;

    UIButton *_undoBtn;
    UIButton *_redoBtn;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor purpleColor];
    
   
    [self buildUI];
    [self testBtn];

    _undoBtn.enabled = [self.undoManager canUndo];
    _redoBtn.enabled = [self.undoManager canRedo];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBtn_undo) name:NSUndoManagerDidUndoChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableBtn_redo) name:NSUndoManagerDidRedoChangeNotification object:nil];

}
-(void)enableBtn_undo
{
    _undoBtn.enabled = [self.undoManager canUndo];
    _redoBtn.enabled = [self.undoManager canRedo];

    NSLog(@"enableBtn_undo %d", [self.undoManager canUndo]);
}
-(void)enableBtn_redo
{
    _undoBtn.enabled = [self.undoManager canUndo];

    _redoBtn.enabled = [self.undoManager canRedo];
    NSLog(@"enableBtn_redo %d", [self.undoManager canRedo]);

}
-(void)testBtn
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 580, 100, 40)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"添加视图" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(140, 580, 100, 40)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"修改frame" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(260, 580, 100, 40)];
    btn3.backgroundColor = [UIColor redColor];
    [btn3 setTitle:@"图层顺序" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    
    [btn addTarget:self action:@selector(add_Remove_View) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(change_frame) forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:self action:@selector(change_Layer) forControlEvents:UIControlEventTouchUpInside];

}
-(void)buildUI
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 650, 80, 80)];
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"撤销" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(200, 650, 80, 80)];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 setTitle:@"还原" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    
    [btn addTarget:self action:@selector(undo_) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(redo_) forControlEvents:UIControlEventTouchUpInside];
    
    _undoBtn = btn;
    _redoBtn = btn2;
    
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [btn2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

    
    _testView = [[UIView alloc] initWithFrame:CGRectMake(250, 100, 100, 100)];
    _testView.backgroundColor = [self colorWithRandomColor];
    [self addSubV:_testView];
    
    

    _testSecondView = [[UIView alloc] initWithFrame:CGRectMake(40, 50, 400, 500)];
    _testSecondView.backgroundColor = [self colorWithRandomColor];
    [self addSubV:_testSecondView];

    
}
-(void)undo_
{
    NSLog(@"撤销？");
    if ([self.undoManager canUndo]) {
        NSLog(@"可以撤销");
        [self.undoManager undo];
    }
}
-(void)redo_
{
    NSLog(@"还原？");

    if ([self.undoManager canRedo]) {
        NSLog(@"可以还原");

        [self.undoManager redo];
        [self.view setNeedsLayout];
    }
}
//=========
-(void)add_Remove_View
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    view.backgroundColor = [self colorWithRandomColor];
    [self addSubV:view];
    
    _undoBtn.enabled = [self.undoManager canUndo];
    _redoBtn.enabled = [self.undoManager canRedo];
}
-(void)addSubV:(UIView *)view
{
    [[self.undoManager prepareWithInvocationTarget:self] removeSubV:view];

    [self.view addSubview:view];
}
-(void)removeSubV:(UIView *)view
{
    [[self.undoManager prepareWithInvocationTarget:self] addSubV:view];

    [view removeFromSuperview];
}

//=========
-(void)change_frame
{
    CGFloat r = arc4random_uniform(256);
    [self upDateFrame:CGRectMake(250, 100, r, r)];
    
    
    _undoBtn.enabled = [self.undoManager canUndo];
    _redoBtn.enabled = [self.undoManager canRedo];
}
-(void)upDateFrame:(CGRect)frame
{
    [[self.undoManager prepareWithInvocationTarget:self] upDateFrame:_testView.frame];

    NSLog(@"upDateFrame%@",NSStringFromCGRect(frame));

    [UIView animateWithDuration:0.25 animations:^{
        _testView.frame = frame;
    }];
}

//=========
-(void)change_Layer
{

    NSInteger i = [self.view.subviews indexOfObject:_testSecondView];
    if (i==0) {//
        i=self.view.subviews.count-1;
    }else{
        i = 0;
    }
    [self change_Layer:i];

    _undoBtn.enabled = [self.undoManager canUndo];
    _redoBtn.enabled = [self.undoManager canRedo];
}
-(void)change_Layer:( NSInteger)index
{
    NSInteger last = [self.view.subviews indexOfObject:_testSecondView];

    [[self.undoManager prepareWithInvocationTarget:self] change_Layer:last];
    
    NSLog(@"change_Layer %ld",(long)index);
    
    
    [self.view insertSubview:_testSecondView atIndex:index];
}









- (UIColor *)colorWithRandomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    
    return [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:1];
}
@end
