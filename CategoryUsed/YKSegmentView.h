//
//  YKSegmentView.h
//  YKSegmentTableView
//
//  Created by yanguo.sun on 13-4-8.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @declaration: YKSegmentView
 @description:  自定义的SegmentControl
 */
@interface YKSegmentView : UIControl{
@private
    NSMutableArray* buttonArray;
    int selectedIndex;
    
}

-(void) setSelectIndex:(int) index;
-(int) selectedIndex;
-(UIButton*) buttonAtIndex:(int) index;
-(UIButton*) selectedButton;
- (id)initWithFrame:(CGRect)frame buttonNumber:(int)_number normalImages:(NSArray *)normals selectImages:(NSArray *)selects titles:(NSArray *)titles normalTitleColor:(UIColor*)_normalColor selectColor:(UIColor *)_selectColor selectIndex:(int)_selectIndex;
@end
