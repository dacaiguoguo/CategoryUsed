//
//  YKCamelFilterViewController.h
//  YKCamelFilterViewModuleApp
//
//  Created by yanguo.sun on 13-4-22.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCamelBaseViewController.h"
#import "YKFilterHeaderDetailListView.h"


@interface YKCamelFilterViewController : YKCamelBaseViewController<YKFilterHeaderDetailListViewDataSource,YKFilterHeaderDetailListViewDelegate>
@property (nonatomic,retain) NSMutableArray *filterList;
@property (nonatomic, retain) NSMutableString *filterquery;
@property (nonatomic, retain) NSMutableArray *filterqueryIndexPathArray;//记住选择的筛选条件

@end
