//
//  YKSegTableView.h
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-8.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @protocol: YKSegTableViewDataSource<NSObject>
 @description:  显示几列不同数据用一个TableView,互相切换的datasource。
 */
@protocol YKSegTableViewDataSource<NSObject>

/*!
 @declaration: - (int)numberOfColoms;
 @description:  返回要显示几列数据
 */
- (int)numberOfColoms;

/*!
 @declaration: - (NSArray *)itemsForColom:(int)_colom;
 @description:  返回某一列的数据 
 @tips:         这个数组要求是字符串数组
 */
- (NSArray *)itemsForColom:(int)_colom;


/*!
 @declaration: - (NSArray *)itemsForColom:(int)_colom;
 @description:  返回显示在Table上面HeaderView,在这里应该是一个类似segmentControl的view
 */
- (UIView *)segmentView;


/*!
 @declaration: - (int)showWhichOne;
 @description:  问datasource Footer 要显示哪一列数据
 */
- (int)showWhichOne;


/*!
 @declaration: - (UIView *)buttomViewForColom:(int)_colom;
 @description:  返回显示在底部的View
 */
- (UIView *)buttomViewForColom:(int)_colom;


/*!
 @declaration: - (int)heightForFooterView;
 @description:  问datasource Footer 的高度
 */
- (int)heightForFooterView;
@end
/*!
 @protocol: YKSegTableViewDelegate <NSObject>
 @description:  显示几列不同数据用一个TableView,互相切换 的代理。
 */
@protocol YKSegTableViewDelegate<NSObject>
@optional

- (void)didSelectIndex:(NSIndexPath*)_indexPath withKeyWord:(NSString*)_key;
- (void)didSelectIndex:(NSIndexPath*)_indexPath;
@end

/*!
 @class: YKSegTableView
 @description:  显示几列不同数据用一个TableView,互相切换。
 */
@interface YKSegTableView : UIView
@property (assign, nonatomic) id<YKSegTableViewDataSource> dataSource;
@property (assign, nonatomic) id<YKSegTableViewDelegate> delegate;
-(void) reloadData;
- (id)initWithFrame:(CGRect)frame andDataSource:(id<YKSegTableViewDataSource>)_source andDelegate:(id<YKSegTableViewDelegate>)_dele;
@end
