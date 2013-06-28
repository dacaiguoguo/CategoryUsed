//
//  YKCamelViewController.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKNetworkOperation;

@interface YKCamelViewController : UIViewController
@property (nonatomic, retain) MKNetworkOperation *homeOperation;


- (IBAction)loadImage:(id)sender;

@end
