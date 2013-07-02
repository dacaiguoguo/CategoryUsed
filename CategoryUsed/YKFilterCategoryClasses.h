//
//  YKCategoryClasses.h
//  Category
//
//  Created by  yanguo.sun on 13-4-2.
//  Copyright (c) 2013年 YEK. All rights reserved.
//
#import <UIKit/UIKit.h>


@class YKFilterSectionHeaderView;
@interface YKFilterDataMoudleList : NSObject
@property (assign) BOOL open;
@property (nonatomic, strong) YKFilterSectionHeaderView *headerView_cate;
@property (nonatomic, strong) NSArray *subArray;

@end

@protocol YKFilterSectionHeaderViewDelegate;


@interface YKFilterSectionHeaderView : UIView

@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UILabel *subTitleLabel;
@property (nonatomic, assign) UIImageView *iconImage;
@property (nonatomic, assign) UIView *lineImage;
@property (nonatomic, assign) UIButton *disclosureButton;
@property (nonatomic, assign)  UIView *lineLabel;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) id <YKFilterSectionHeaderViewDelegate> delegate;
@property (nonatomic, assign) BOOL iselected;
-(id)initWithFrame:(CGRect)frame title:(NSString*)title subTitle:(NSString*)subTitle section:(NSInteger)sectionNumber delegate:(id <YKFilterSectionHeaderViewDelegate>)delegate;
-(void)toggleOpenWithUserAction:(BOOL)userAction;
- (void)setUpLineChange:(BOOL)change;
@end





/*
 Protocol to be adopted by the section header's delegate; the section header tells its delegate when the section should be opened and closed.
 */
@protocol YKFilterSectionHeaderViewDelegate <NSObject>

@optional
-(void)sectionHeaderView:(YKFilterSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section;
-(void)sectionHeaderView:(YKFilterSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section;
- (int)get_OpenSectionIndex;

@end

