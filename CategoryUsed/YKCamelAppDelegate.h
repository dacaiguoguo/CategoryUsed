//
//  YKCamelAppDelegate.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKCamelNavigationController.h"

#define ApplicationDelegate ((YKCamelAppDelegate *)[UIApplication sharedApplication].delegate)
#pragma mark 通知
/*! 登陆／注册成功会发送此事件 notify.userinfo["user"] 是 YKUser */
#define YK_NOTIFICATION_LOGIN @"YK_NOTIFICATION_LOGIN"
#define YK_NOTIFICATION_LOGOUT @"YK_NOTIFICATION_LOGOUT"
#define CAMEL_HOST @"b2c.test.yekmob.com/api/index.php"



@class YKCamelHomeNetworkEngine;
@class YKCamelBrandNetworkEngine;
@class YKCamelHomeViewController;

@interface YKCamelAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *iTab;
@property (strong, nonatomic) YKCamelNavigationController *iHomeNav;
@property (strong, nonatomic) YKCamelHomeNetworkEngine *camelHomeNetworkEngine;

@property (strong, nonatomic) YKCamelNavigationController *iBrandNav;
@property (strong, nonatomic) YKCamelBrandNetworkEngine *camelBrandNetworkEngine;

@property (strong, nonatomic) YKCamelNavigationController *iCategoryNav;
@property (strong, nonatomic) YKCamelHomeNetworkEngine *camelCategoryNetworkEngine;

@property (strong, nonatomic) YKCamelNavigationController *iShopCartNav;
@property (strong, nonatomic) YKCamelHomeNetworkEngine *camelShopCartNetworkEngine;

@property (strong, nonatomic) YKCamelNavigationController *iMoreNav;
@property (strong, nonatomic) YKCamelHomeNetworkEngine *camelMoreNetworkEngine;
@property (strong, nonatomic) NSString *userToken;


@end
