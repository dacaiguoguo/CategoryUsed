//
//  YKProductListView.h
//  productList
//
//  Created by  yanguo.sun on 13-4-7.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum YKCamelProductListType : NSInteger{
    YKCamelProductListTypeTwo = 2,
    YKCamelProductListTypeSingle = 1,
}YKCamelProductListType;


@interface YKProductViewCellSingle :UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *pImageView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *shopPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *salePriceLabel;

@end

@interface YKProductViewCellTwo :UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *leftImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rightImageView;
@property (strong, nonatomic) IBOutlet UILabel *leftNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftSalePriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightSalePriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *leftButton;
@property (strong, nonatomic) IBOutlet UIButton *rightButton;

@end

@class YKCamelProductListView;
/**
 @protocol YKCamelProductListViewDataSource
 @decription data source 按Single 模式提供。
 */
@protocol YKCamelProductListViewDataSource<NSObject>
- (NSString *)imageUrlForIndex:(int )_index;
- (NSString *)salePriceForIndex:(int)_index;
- (NSString *)shopPriceForIndex:(int)_index;
- (NSString *)productNameForIndex:(int)_index;
- (NSInteger)numberOfItems;
- (YKCamelProductListType)productListType;
@end
@protocol YKCamelProductListViewDelegate <NSObject>
/**
 点击了第几个，注意不是第几行
 */
- (void)productListView:(YKCamelProductListView*)productListView didSelectIndex:(int)_row;
-(void)startLoadTop;
-(void)startLoadBottom;


@end

@interface YKCamelProductListView : UIView
@property (assign, nonatomic) id<YKCamelProductListViewDataSource> dataSource;
@property (assign, nonatomic) id<YKCamelProductListViewDelegate> delegate;
@property (assign) int productType;
-(void)finishedLoadingTop;
-(void)finishedLoadingBottom;
-(void)finishedLoadingScrollTop ;
-(void) reloadData;
- (void)hiddenLoadButtom;
- (void)showLoadButtom;

@end

@interface YKLineLabel : UILabel

@end
