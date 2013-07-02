//
//  YKCamelProductListViewController.h
//  YKCamelProductListModule
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCamelBaseViewController.h"
/**
    上拉加载和下拉刷新没做
 一次读取20条数据；
 3）下拉刷新、上拉加载；
 4)默认按价格排序；
 排序栏：
 新品：按上架时间，最新到旧；
 销量：按总销量，从多到少；
 价格：默认从低到高排序，再次点击从高到低排序；
 好评：按好评分数；
 双击列表返回该排序下第一项；
 
 [[[YKModuleManager shareInstance] shareDataSourceModule] requestProductListWithParams:@{@"categoryId": CateID,@"keyword":@"",@"filterquery":@"",@"sortBy":@"",@"sortOrder":@"",@"pageIndex":PageIndex,@"pageSize":@"5"} onSuccess:^(YKProductList *productList) {

 */

typedef void (^Block)();

@interface YKCamelProductListViewController : YKCamelBaseViewController
{
    NSMutableString *_filterquery;
}
@property (nonatomic, copy) NSString *categoryId;//分类ID
//品牌ID
@property (nonatomic, copy) NSString *brandId;
//专题ID
@property (nonatomic, copy) NSString *topicId;
//关键字
@property (nonatomic, copy) NSString *keyword;
//筛选条件
@property(nonatomic, retain) NSMutableString *filterquery;
//记住选择的筛选条件
@property (nonatomic, retain) NSMutableArray *filterqueryIndexPathArray;
//价格，新品，销量，好评
@property (nonatomic, copy) NSString *sortBy;
//升序或降序
@property (nonatomic, copy) NSString *sortOrder;
//页码
@property (nonatomic, copy) NSString *pageIndex;
//每页数量
@property (nonatomic, copy) NSString *pageSize;
//搜索成功后执行的Block
@property (nonatomic, copy) Block requestSuccess;
//搜索失败后执行的Block
@property (nonatomic, copy) Block requestFail;
@property(nonatomic, retain) MKNetworkOperation* productListOperation;


@end


