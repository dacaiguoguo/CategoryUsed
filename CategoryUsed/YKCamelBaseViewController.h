//
//  YKCamelBaseViewController.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-7-1.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKBaseModel.h"
#import "UIImageView+WebCache.h"
#import "YKCamelHomeNetworkEngine.h"
#import "YKCamelAppDelegate.h"

@interface YKCamelBaseViewController : UIViewController
-(NSArray *)navTabSelectedImageNames;
-(NSArray *)navTabNormalImageNames;
@end
