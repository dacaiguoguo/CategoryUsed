//
//  NSUserDefaults+searchHistory.h
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-9.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KHistory @"K_history"
#define KHistoryNumber @"K_history_number"

/*!
 @class: YKCamelSearchHistory
 @discussion: 处理搜索历史记录的类
 @superclass: NSObject
 */
@interface YKCamelSearchHistory:NSObject

/*!
 @declaration: + (NSArray*)getSearchHistory;
 @description:  获得搜索历史记录
 */
+ (NSArray*)getSearchHistory;

/*!
 @declaration: + (void)setSearchHistory:(NSArray *)_history;
 @description:  保存搜索历史记录
 */
+ (void)setSearchHistory:(NSArray *)_history;

/*!
 @declaration: + (void)clearSearchHistoryOver;
 @description:  清空搜索历史记录
 */
+ (void)clearSearchHistoryOver;

/*!
 @declaration: + (void)setHistoryKeyWord:(NSString *)_keyWord;
 @description:  设置一条历史记录
 */
+ (void)setHistoryKeyWord:(NSString *)_keyWord;

/*!
 @declaration: + (void)deleteHisoryKeyWord:(NSString *)_keyWord;
 @description:  删除一条历史记录
 */
+ (void)deleteHisoryKeyWord:(NSString *)_keyWord;

/*!
 @declaration: + (void)setNumberOfHistory:(int)_numbers;
 @description:  设置历史记录的总条数
 */
+ (void)setNumberOfHistory:(int)_numbers;

/*!
 @declaration: + (int)getNumberOfHistory;
 @description:  取得历史记录的总条数
 */
+ (int)getNumberOfHistory;
@end
