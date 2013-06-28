//
//  YKCamelNoticeView.h
//  HomeUpView
//
//  Created by yanguo.sun on 13-5-20.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

/**
 * shouye_bg_tixing.png  是背景图片名称。
 *  只有一个的时候不会滚动
 *  多个的时候会以 YK_NOTICE_VIEW_ANIM_DURATION 循环滚动
 *  在最右边有一个关闭按钮， shouye_btn_guanbi.png 是图片名称
 *  点击后会 执行 delegate 的
 *  - (void)noticeView:(YKCamelNoticeView *)noticeV closeAction:(UIButton*)sender;
 *  方法
 *  点击其它区域会执行
 *  - (void)noticeView:(YKCamelNoticeView *)noticeV didSelectRow:(int)row;
 *
 *
 */


#import <UIKit/UIKit.h>


#define YK_NOTICE_VIEW_ANIM_DURATION 5
#define YK_TITLE_TEXT_COLOR [UIColor colorWithRed:70./255. green:70./255. blue:70./255. alpha:1.]
#define YK_TITLE_TEXT_FONT [UIFont boldSystemFontOfSize:16]

@class YKCamelNoticeView;
@protocol YKCamelNoticeViewDelegate <NSObject>

- (void)noticeView:(YKCamelNoticeView *)noticeV didSelectRow:(int)row;
- (void)noticeView:(YKCamelNoticeView *)noticeV closeAction:(UIButton*)sender;

@end

@protocol YKCamelNoticeViewDataSource <NSObject>

- (NSString *)titleForRow:(int)_r;

@end

@interface YKCamelNoticeView : UIView<UITableViewDelegate,UITableViewDataSource>{
    int count;
    BOOL toEnd;
}
@property (nonatomic, retain) UITableView *interTableView;
@property (nonatomic, retain) UIButton *accessoryButton;
@property (nonatomic, retain) NSTimer *moveTimer;
@property     int totalRow;
@property (nonatomic, assign) IBOutlet id<YKCamelNoticeViewDelegate> delegate;
@property (nonatomic, assign) IBOutlet id<YKCamelNoticeViewDataSource> dataSource;
- (void)reloadData;
- (void)startUp;
- (void)stopUp;
@end