//
//  YKHeaderDetailListView.h
//  Category
//
//  Created by  yanguo.sun on 13-4-3.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YKFilterSectionHeaderView;
/**
    @protocol YKHeaderDetailListViewDataSource
    @Description The YKHeaderDetailListViewDataSource protocol is adopted by an object that mediates the application’?s data model for a YKHeaderDetailListView object. The data source provides the YKHeaderDetailListView object with the information it needs to construct and modify a YKHeaderDetailListView.
 */
@protocol YKFilterHeaderDetailListViewDataSource <NSObject>
/**
    @Declaration - (int)numOfTop
    @Description Asks the data source to return the number of sections in the view.
    @Return number of sections.
 */
- (int)numOfTop;
/**
    @Declaration - (NSString *)titleAtTopRow:(int)row
    @Description Asks the data source to return the title of sections in the row of view.
    @Return title of row.
 */
- (NSString *)titleAtTopRow:(int)row;
- (NSString *)iconUrlAtTopRow:(int)row;
/**
    @Declaration - (NSArray *)itemsAtRow:(int)row
    @Description Asks the data source to return the sub data of section.
    @Return the sub data of section.
 !!! 这个数组一定要是字符串数组
 */
- (NSArray *)itemsAtRow:(int)row;
/**
 @Declaration - (NSArray *)itemsAtRow:(int)row
 @Description Asks the data source to return the sub data of section.
 @Return the sub data of section.
 */
- (NSString *)subTitleAtTopRow:(int)row;
/**
 @Declaration - (NSInteger)numOfColumn
 @Description Asks the data source to return the sub data of section.
 @Return the sub data of section.
 */
- (NSInteger)numOfColumn;
/**
 @Declaration - (CGFloat)heightForHeader
 @Description Asks the data source to return the number of column.
 @Return the number of column.
 */
- (CGFloat)heightForHeader;
/**
 @Declaration - (CGFloat)heightForRow
 @Description Asks the data source to return the height For Header.
 @Return the height For Header.
 */
- (CGFloat)heightForRow;

@end

@class YKFilterHeaderDetailListView;
@protocol YKFilterHeaderDetailListViewDelegate <NSObject>

- (void)headerDetailList:(YKFilterHeaderDetailListView *)_headerList didTapItemAtIndex:(NSIndexPath*)_index;

@end
/*
    @class YKFilterHeaderDetailListView
    @superClass UIView
    @description 用tableView的header 点击向下展开Cell
 */
@interface YKFilterHeaderDetailListView : UIView
@property (assign,nonatomic) id<YKFilterHeaderDetailListViewDataSource> datasource;
@property (assign,nonatomic) id<YKFilterHeaderDetailListViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *indexPathMutArray;

- (id)initWithFrame:(CGRect)frame withDataSource:(id<YKFilterHeaderDetailListViewDataSource>)datas withDelegate:(id<YKFilterHeaderDetailListViewDelegate>)dele indxArray:(NSMutableArray *)indexArray;
- (YKFilterSectionHeaderView *)sectionHeaderViewForSection:(NSUInteger)section;
-(void) reloadData;
@end
