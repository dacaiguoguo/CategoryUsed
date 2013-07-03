//
//  YKCamelNavigationController.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-28.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKBaseModel.h"
@interface YKCamelNavigationController : UINavigationController
-(void) onSearchButtonTap:(id) sender;

- (void)goProductListWithKeyword:(NSString *)kw;
- (void)goFilterWithFilterQ:(NSMutableString *)fq andFilterList:(YKFilterList *)flist filterqueryIndexPathArray:(NSMutableArray *)mutQ;
- (void)goFilterViewController:(id)sender;
@end
