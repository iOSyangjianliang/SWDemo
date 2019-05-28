//
//  ViewController.m
//  WKWebView内容高度获取
//
//  Created by 杨建亮 on 2019/1/10.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "ViewController.h"

#import <WebKit/WebKit.h>


@interface ViewController ()<WKNavigationDelegate>
@property(nonatomic, strong) WKWebView *wkWebView;

@property(nonatomic, strong) UIScrollView *scrollView;

@end

//static NSString *testUrl = @"http://10.30.251.115:8092/shunXW/barInfoServlet?bussiseType=queryServerDetail&requestJson=%7B%22enServerId%22:%227789fd611cb620395c02886631df17a2105196aae016e63d%22%7D";

//static NSString *testUrl = @"https://www.cnblogs.com/6duxz/p/6952896.html";

static NSString *testUrl = @"https://www.cnblogs.com/6duxz/p/4045147.html";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor purpleColor];
    
    [self buildUI];
    
    [self loadWordData];
}

-(void)buildUI
{
    UIView *V = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
    V.backgroundColor = [UIColor blackColor];
    [self.view addSubview:V];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 100, 300, 500)];
    [self.view addSubview:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(300, 500+100);
    self.scrollView.backgroundColor = [UIColor yellowColor];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:view];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 100, 300, 400) configuration:configuration];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.backgroundColor = [UIColor orangeColor];
    [self.scrollView addSubview:self.wkWebView];
    self.wkWebView.scrollView.scrollEnabled = NO;
    
    if (@available(iOS 11.0, *)){
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;

        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(URL)) options:NSKeyValueObservingOptionNew context:NULL];
//    [self.wkWebView.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:NULL];




}
-(void)loadWordData{
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"集中管理平台用户协议.pdf" ofType:nil];
//    NSURL *url = [NSURL fileURLWithPath:path];
        NSURL *url = [NSURL URLWithString:testUrl];

    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self loadWordData];
}


#pragma mark -KVO的监听代理
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"==========%@",keyPath);

    if ([keyPath isEqualToString:@"contentSize"] && object ==self.wkWebView.scrollView)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

                [self updateScrollView_contentSize];
                NSLog(@"===contentSize=======%@",NSStringFromCGSize(self.wkWebView.scrollView.contentSize));

        });
        
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

// 1 在发送请求之前，决定是否请求
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSLog(@"1.在发送请求之前，决定是否请求跳转:%@",navigationAction.request);
//    [self.wkWebView.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:NULL];
    decisionHandler(WKNavigationActionPolicyAllow);

}
//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@",webView.scrollView);

//        [self updateScrollView_contentSize];
    });

    [self.wkWebView.scrollView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentSize)) options:NSKeyValueObservingOptionNew context:NULL];

}
bool bo = YES;
-(void)updateScrollView_contentSize
{

    [self.wkWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];

    NSLog(@"%.2f==%.2f",self.wkWebView.scrollView.contentSize.height,self.wkWebView.frame.size.height);
    if (self.wkWebView.scrollView.contentSize.height== self.wkWebView.frame.size.height) {
        return;
    }
    CGRect frame = self.wkWebView.frame;
    frame.size.height =  self.wkWebView.scrollView.contentSize.height;
    self.wkWebView.frame =  frame;
   

    CGSize size = self.scrollView.contentSize;
    size.height = self.wkWebView.scrollView.contentSize.height+100+30;
    self.scrollView.contentSize = size;
    
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0))
{
    NSLog(@"QQQQQ%@",webView.scrollView);

}


@end
