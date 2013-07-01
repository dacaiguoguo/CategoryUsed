//
//  YKCamelBaseViewController.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-7-1.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelBaseViewController.h"

@interface YKCamelBaseViewController ()

@end

@implementation YKCamelBaseViewController



-(NSArray *)navTabNormalImageNames{
    NSArray* ret=@[@"common_btn_shouye_normal.png", @"common_btn_pinpai_normal.png", @"common_btn_fenlei_normal.png",@"common_btn_gouwuche_normal.png",@"common_btn_gengduo_normal.png"];
    return ret;
}
-(NSArray *)navTabSelectedImageNames{
    NSArray* ret=@[@"common_btn_shouye_selected.png", @"common_btn_pinpai_selected.png", @"common_btn_fenlei_selected.png",@"common_btn_gouwuche_selected.png",@"common_btn_gengduo_selected.png"];
    return ret;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
