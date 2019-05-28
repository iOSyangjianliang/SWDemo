//
//  AATextViewController.m
//  全字体demo
//
//  Created by 顺网-yjl on 2019/4/22.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "AATextViewController.h"
#import "RRTextToolView.h"


@interface AATextViewController ()<RRTextToolViewDelegate>
{
    UITextView *_textView;
    
    
    RRTextToolView *_bottomView;


    BOOL _isAnimatedBottomToolView;

    CGRect _rect;

}
@end

@implementation AATextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(100, 100, 200, 150)];
    _textView. backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textView];   
    
    RRTextToolView *view= [[RRTextToolView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44, 414, 44+250.f)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    _bottomView = view;
    _bottomView.delegate = self;
    _bottomView.hidden = YES;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

//    [self testss];
}
-(void)testss{
    UIView *testV = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 150)];
    testV.backgroundColor = [UIColor redColor];
    [self.view addSubview:testV];
    
    [UIView animateWithDuration:5 animations:^{
        testV.frame = CGRectMake(100, 300, 200, 150);
    } completion:^(BOOL finished) {
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            testV.frame = CGRectMake(100, 600, 20, 15);
        } completion:^(BOOL finished) {
            
        }];

    });
    
}
-(void)keyboardWillShow:(NSNotification *)sender
{
    _bottomView.hidden = NO;

    CGRect rect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
   
    if (CGRectEqualToRect(_rect, CGRectZero)) {
        _rect = rect;
    }
    
    
    
    NSLog(@"keyboardWillShow%@",NSStringFromCGRect(rect));

    if (!_isAnimatedBottomToolView) {
        

        CGRect frame = _bottomView.frame;
        frame.origin.y = self.view.frame.size.height-rect.size.height-44;

        [UIView animateWithDuration:duration animations:^{
            _bottomView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
       
    }
   
}
-(void)keyboardWillHide:(NSNotification *)sender
{
//    _bottomView.hidden = YES;

    CGRect rect = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[sender.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    if (!_isAnimatedBottomToolView) {

        CGRect frame = _bottomView.frame;
        frame.origin.y = self.view.frame.size.height-44;
        
        [UIView animateWithDuration:duration animations:^{
            _bottomView.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_textView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)rr_textToolView:(RRTextToolView *)view didSelectIndex:(NSInteger)index lastIndex:(NSInteger)lastIndex
{
    if (index==0)
    {
        if ( _textView.isFirstResponder)
        {
            [_textView resignFirstResponder];
            
        }else
        {
            [_textView becomeFirstResponder];
        }
    }
    if (index==1)
    {
        if (index == lastIndex) {
            if ( _textView.isFirstResponder) {
                
                CGRect frame = _bottomView.frame;
                frame.origin.y = self.view.frame.size.height-44-250;
                
                _isAnimatedBottomToolView = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    _bottomView.frame = frame;
                } completion:^(BOOL finished) {
                    _isAnimatedBottomToolView = NO;
                }];
                
                [_textView resignFirstResponder];
                
            }else{
                [_textView becomeFirstResponder];
            }
        }else{
            CGRect frame = _bottomView.frame;
            frame.origin.y = self.view.frame.size.height-44-250;
            
            _isAnimatedBottomToolView = YES;
            [UIView animateWithDuration:0.25 animations:^{
                _bottomView.frame = frame;
            } completion:^(BOOL finished) {
                _isAnimatedBottomToolView = NO;
            }];
            
            [_textView resignFirstResponder];
        }
        
    }
    if (index==2)
    {
        if (index == lastIndex) {
            if ( _textView.isFirstResponder) {
                
                CGRect frame = _bottomView.frame;
                frame.origin.y = self.view.frame.size.height-44-250;
                
                _isAnimatedBottomToolView = YES;
                [UIView animateWithDuration:0.25 animations:^{
                    _bottomView.frame = frame;
                } completion:^(BOOL finished) {
                    _isAnimatedBottomToolView = NO;
                }];
                
                [_textView resignFirstResponder];
                
            }else{
                [_textView becomeFirstResponder];
            }
        }else{
            CGRect frame = _bottomView.frame;
            frame.origin.y = self.view.frame.size.height-44-250;
            
            _isAnimatedBottomToolView = YES;
            [UIView animateWithDuration:0.25 animations:^{
                _bottomView.frame = frame;
            } completion:^(BOOL finished) {
                _isAnimatedBottomToolView = NO;
            }];
            
            [_textView resignFirstResponder];
        }
       
    }

    
    if (index == 4) {
        CGRect frame = _bottomView.frame;
        frame.origin.y = self.view.frame.size.height;
        
        _isAnimatedBottomToolView = YES;

        [UIView animateWithDuration:0.25 animations:^{
            _bottomView.frame = frame;
        } completion:^(BOOL finished) {
            _bottomView.hidden = YES;
            _isAnimatedBottomToolView = NO;
        }];
        
        [_textView resignFirstResponder];
    }
    
    
}
@end
