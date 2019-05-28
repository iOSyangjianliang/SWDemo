//
//  RRTabBarController.m
//  RuoRouNotes
//
//  Created by 杨建亮 on 2019/4/10.
//  Copyright © 2019年 yangjianliang. All rights reserved.
//

#import "RRTabBarController.h"

#import "JLCateHeader.h"

#import "RRBaseNavigationController.h"
#import "RRMineViewController.h"
#import "RRNotesListViewController.h"

@interface RRTabBarController ()<UITabBarControllerDelegate,UITabBarDelegate>

@end

@implementation RRTabBarController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#EE3A8C"];
    self.tabBar.translucent = NO;

    [self addViewcontrollers];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
    
}
-(void)addViewcontrollers
{
    [self addViewControllerWithStoryBoardName:@"Note" Identifier:@"RRNotesListViewControllerID" NorImageName:@"toolbar_home" SelImageName:@"toolbar_home_sel"];
    [self addViewControllerWithName:@"RRNotesListViewController" NorImageName:@"" SelImageName:@""];
    [self addViewControllerWithName:@"RRMineViewController"  NorImageName:@"toolbar_me" SelImageName:@"toolbar_me_sel"];
  
  
}


-(void)addViewControllerWithName:(NSString*)VCname  NorImageName:(NSString*)Norname SelImageName:(NSString*)SelName
{
    Class clas = NSClassFromString(VCname);
    UIViewController*  viewC = [[clas alloc] init ];
    
    RRBaseNavigationController* naVC = [[RRBaseNavigationController alloc] initWithRootViewController:viewC];
    
//    [naVC xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    
    naVC.navigationBar.tintColor = [UIColor blueColor];
    naVC.navigationBar.barTintColor = [UIColor colorWithHexString:@"#EE3A8C"];//导航栏颜色

    naVC.tabBarItem.image = [[UIImage imageNamed:Norname] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    naVC.tabBarItem.selectedImage = [[UIImage imageNamed:SelName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (! [VCname isEqualToString:@"PurPublishViewController"]) {
        naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    NSMutableArray* arrayM = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [arrayM addObject:naVC];
    self.viewControllers = arrayM;
}
-(void)addViewControllerWithStoryBoardName:(NSString*)storyboardName Identifier:(NSString*)identifier NorImageName:(NSString*)Norname SelImageName:(NSString*)SelName
{
    //根据storyboard和controller的storeId找到控制器
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewC=[sb instantiateViewControllerWithIdentifier:identifier];
    
    RRBaseNavigationController* naVC = [[RRBaseNavigationController alloc] initWithRootViewController:viewC];
//    [naVC xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    
    naVC.navigationBar.tintColor = [UIColor blueColor];
    naVC.navigationBar.barTintColor = [UIColor colorWithHexString:@"#EE3A8C"];//导航栏颜色

    naVC.tabBarItem.image = [[UIImage imageNamed:Norname] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    naVC.tabBarItem.selectedImage = [[UIImage imageNamed:SelName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    NSMutableArray* arrayM = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [arrayM addObject:naVC];
    self.viewControllers = arrayM;
    
}


@end

