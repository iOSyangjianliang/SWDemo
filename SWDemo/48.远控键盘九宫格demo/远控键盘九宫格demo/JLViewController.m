//
//  JLViewController.m
//  远控键盘九宫格demo
//
//  Created by 杨建亮 on 2019/4/3.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "JLViewController.h"
#import "SWRCTextViewDelegate.h"

#import "UIView+Log.h"

#import "JLView.h"


@interface JLViewController ()<SWRCTextViewDelegatOutput>
@property(nonatomic, strong) SWRCTextViewDelegate *textInputDelegate;


@property (weak, nonatomic) IBOutlet UILabel *testlab;

@property(nonatomic, strong) UITextView *displayTextView;

@end

@implementation JLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    
    UITextView *textV = [[UITextView alloc ] initWithFrame:CGRectMake(70, 50, 200, 100)];
    textV.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:textV];

    //!!
    textV.text = @" ";
    
    JLView *view = [[JLView alloc] initWithFrame:CGRectMake(0, 0, 0, 32)];
    view.backgroundColor = [UIColor redColor];
    textV.inputAccessoryView = view;
    
    SWRCTextViewDelegate *dele = [[SWRCTextViewDelegate alloc] init];
    dele.outPut = self;
    _textInputDelegate = dele;
    
    textV.delegate = _textInputDelegate;

    
    
    //
    _displayTextView = [[UITextView alloc ] initWithFrame:CGRectMake(70, 160, 200, 100)];
    _displayTextView.backgroundColor = [UIColor lightGrayColor];
    _displayTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _displayTextView.editable = NO;
    _displayTextView.text = @" ";
    [self.view addSubview:_displayTextView];
    
    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggg:) name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}
-(void)loggg:(NSNotification *)sender
{
    NSArray *arr = [UIApplication sharedApplication].windows;
    for (int i=0; i<arr.count; ++i) {
        NSLog(@"\n================begin");

        UIView *vciew= arr[i];
        [UIView zhNSLogSubviewsFromView:vciew andLevel:0];
        
        NSLog(@"\n================end");
    }
  
    

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)sw_textViewDelegatOutputWithInsertString:(NSString *)insertString
{
    if ([insertString isEqualToString:@""]) {
        if (_displayTextView.text.length>1) {
            _displayTextView.text = [NSString stringWithFormat:@"%@", [self.displayTextView.text substringToIndex:self.displayTextView.text.length-1]];
        }
    }else{
        _displayTextView.text = [NSString stringWithFormat:@"%@%@",self.displayTextView.text,insertString];
    }
    
//    [_displayTextView setContentOffset:CGPointMake(0, _displayTextView.contentSize.height-_displayTextView.frame.size.height)];
}
@end
