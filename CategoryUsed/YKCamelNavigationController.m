//
//  YKCamelNavigationController.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-28.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelNavigationController.h"

#import "YKCamelSearchViewController.h"

#import "YKCamelProductListViewController.h"


#import "UIView+Method.h"
@interface YKCamelNavigationController ()

@end

@implementation YKCamelNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [[self navigationBar] setBackgroundImage:[UIImage imageNamed:@"common_bg_dingtiao.png"] forBarMetrics:UIBarMetricsDefault];

    }
    return self;
}
- (void)goFilterWithFilterQ:(NSString *)fq{
    
}

- (void)goProductListWithKeyword:(NSString *)kw{
    YKCamelProductListViewController *vcP = [[YKCamelProductListViewController alloc] initWithNibName:@"YKCamelProductListViewController" bundle:nil];
    vcP.keyword = kw;
    vcP.navigationItem.leftBarButtonItem = ControllerLeftBarCustomWithButton(@"common_btn_fanhui", @selector(defaultBackButtonTap:), self);
    
    [self pushViewController:vcP animated:YES];
}
- (void)defaultBackButtonTap:(id)sender{
    [self popViewControllerAnimated:YES];
}
-(void) onSearchButtonTap:(id) sender{
    YKCamelSearchViewController *vc = [[YKCamelSearchViewController alloc] initWithNibName:@"YKCamelSearchViewController" bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.navigationItem.leftBarButtonItem = ControllerLeftBarCustomWithButton(@"common_btn_fanhui", @selector(defaultBackButtonTap:), self);
    [self pushViewController:vc
                    animated:YES];
    
}

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [[self navigationBar] setBackgroundImage:[UIImage imageNamed:@"common_bg_dingtiao.png"] forBarMetrics:UIBarMetricsDefault];

        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
