//
//  SWScrollViewController.m
//  远控手势Demo
//
//  Created by 杨建亮 on 2019/9/19.
//  Copyright © 2019 yangjianliang. All rights reserved.
//

#import "SWScrollViewController.h"

@interface SWScrollViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollerview;

@end

@implementation SWScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.scrollerview = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollerview];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*16.f/9)];
    _imageView.center = _scrollerview.center;
    [self.scrollerview  addSubview:_imageView];
    
 
    
    self.imageView.image = [UIImage imageNamed:@"手势说明"];
    
    self.scrollerview.delegate = self;
    
    self.scrollerview.minimumZoomScale  = 0.5;
    self.scrollerview.maximumZoomScale  = 2;

    
}
// return a view that will be scaled. if delegate returns nil, nothing happens
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
    
}
//- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view NS_AVAILABLE_IOS(3_2); // called before the scroll view begins zooming its content
//- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale; // scale between minimum and maximum. called after any 'bounce' animations



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
