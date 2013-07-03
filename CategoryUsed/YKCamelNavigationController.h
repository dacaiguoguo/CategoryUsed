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

/**
 *  首页的右边的search 按钮点击后，跳到搜索页面
 */
-(void) onSearchButtonTap:(id) sender;
/**
 *  搜索页面 进入商品列表页面
 */
- (void)goProductListWithKeyword:(NSString *)kw;
/**
 *  商品列表页面 进入到筛选页面
 */
- (void)goFilterViewController:(id)sender;
@end
