//
//  YKCamelViewController.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelViewController.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "MKNetworkKit.h"
@interface YKCamelViewController ()
@property (nonatomic, retain) UIImageView *imageView;
@end

@implementation YKCamelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 200)];
    self.imageView.center  = self.view.center;
    [self.view addSubview:self.imageView];
    
    NSMutableDictionary *dic =[NSMutableDictionary dictionaryWithDictionary: @{@"abc": @"www",@"cdd":@"rrr"}];
    DLog(@"%@",[dic JSONString]);
    
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loadImage:(id)sender {
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"imageArray" ofType:@"plist"]];

    [self.imageView setImageWithURL:array[4] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];

}
@end
