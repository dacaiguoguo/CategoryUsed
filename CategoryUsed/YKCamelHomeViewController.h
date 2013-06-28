//
//  YKCamelHomeViewController.h
//  YKCamelHomeModule
//
//  Created by TFH on 13-4-15. fix by dacaiguoguo
//  Copyright (c) 2013年 yek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKLoopScrollView.h"

/*!
 
 首页
 
 －－－－－－
    noticeView
 －－－－－－
    tableview
    －－－
    cell loop scroll view
    －－－
    cell webview
    －－－
 －－－－－－
 */

@class MKNetworkOperation;
@interface YKCamelHomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate, YKLoopScrollViewDelegate>
@property(nonatomic, retain) MKNetworkOperation* homeOperation;

- (void)BIOperationWith:(NSString *)classname;
//单例 首页
+(id)shareInstance;

@end
