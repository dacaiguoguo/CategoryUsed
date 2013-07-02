//
//  YKCamelSearchViewController.h
//  YKCamelSearchViewMoudle
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCamelBaseViewController.h"
/*!
 @declaration: YKCamelSearchViewController
 @description:  camel 的searchView
 */
@interface YKCamelSearchViewController : YKCamelBaseViewController
@property(nonatomic, retain) MKNetworkOperation* hotSearchOperation;
@end
