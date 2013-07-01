//
//  YKCamelNavigationController.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-28.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelNavigationController.h"

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


- (id)initWithRootViewController:(UIViewController *)rootViewController{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [[self navigationBar] setBackgroundImage:[UIImage imageNamed:@"common_bg_dingtiao.png"] forBarMetrics:UIBarMetricsDefault];

        // Custom initialization
    }
    return self;
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
