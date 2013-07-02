//
//  YKCamelBrandViewController.h
//  YKCamelBrandViewModuleApp
//
//  Created by yanguo.sun on 13-4-21.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCamelBaseViewController.h"
@interface YKCamelBrandViewController : YKCamelBaseViewController

@property (nonatomic, retain) NSMutableArray *brandList;
@property(nonatomic, retain) MKNetworkOperation* brandOperation;


// BI
- (void)goBrandCategoryForBI:(NSString *)_braid;
//单例 品牌

//从品牌到分类列表
- (IBAction)goBrandCategory:(id)sender;

@end
