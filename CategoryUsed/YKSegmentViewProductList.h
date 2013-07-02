//
//  YKSegmentView.h
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-8.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol YKSegmentViewProductListDelegate<NSObject>
- (void)doubleClickHappend;
- (void)needButtonClicked;
@end
@interface YKSegmentViewProductList : UIControl{
@private
    NSMutableArray* buttonArray;
    int selectedIndex;
    
}
@property (nonatomic, strong) id<YKSegmentViewProductListDelegate> delegate;
@property (assign) int needIndex;
- (void)addDoubleClick;
-(void) setSelectIndex:(int) index;
- (void)setSelectIndexNoAction:(int)index;
-(int) selectedIndex;
-(UIButton*) buttonAtIndex:(int) index;
-(UIButton*) selectedButton;
- (id)initWithFrame:(CGRect)frame buttonNumber:(int)_number normalImages:(NSArray *)normals selectImages:(NSArray *)selects titles:(NSArray *)titles normalTitleColor:(UIColor*)_normalColor selectColor:(UIColor *)_selectColor selectIndex:(int)_selectIndex buttonClass:(NSString *)_btnClassName;
@end
