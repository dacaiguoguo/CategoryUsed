//
//  YKCamelAppDelegate.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelAppDelegate.h"

#import "YKCamelHomeViewController.h"

#import "YKCamelBrandViewController.h"


#import "YKCamelHomeNetworkEngine.h"


#import "UIDevice.h"

#import "YKBaseModel.h"

#import "UIView+Method.h"





@implementation YKCamelAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpEngines];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    
    self.iHomeNav = [[YKCamelNavigationController alloc] init];

    UIViewController *homeVC = ControllerUseClass([YKCamelHomeViewController class]);
    homeVC.navigationItem.leftBarButtonItem = HomeControllerLeftBarCustomWithButton(@"shouye_img_logo.png");
    homeVC.navigationItem.rightBarButtonItem = ControllerRightBarCustomWithButton(@"common_btn_sousuo", @selector(onSearchButtonTap:), self.iHomeNav);
    
    self.iHomeNav.viewControllers = @[homeVC];


    self.iBrandNav = [[YKCamelNavigationController alloc] initWithRootViewController:ControllerUseClass([YKCamelBrandViewController class])];

    self.iCategoryNav = [[YKCamelNavigationController alloc] initWithRootViewController:ControllerUseClass([YKCamelHomeViewController class])];

    self.iShopCartNav = [[YKCamelNavigationController alloc] initWithRootViewController:ControllerUseClass([YKCamelHomeViewController class])];

    self.iMoreNav = [[YKCamelNavigationController alloc] initWithRootViewController:ControllerUseClass([YKCamelHomeViewController class])];

    

    self.iTab = [[UITabBarController alloc] init];
    self.iTab.viewControllers = @[self.iHomeNav,self.iBrandNav,self.iCategoryNav,self.iShopCartNav,self.iMoreNav];
    self.window.rootViewController = self.iTab;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}





- (NSDictionary *)commonHeaderFields{
    //    通信协议版本号
    //    硬件设备的屏幕尺寸，如“320*480”
    //    客户端设备平台，如iphone、android
    //    设备物理地址
    //    客户端版本号 如：1.0.0
    //    用户签名，登录后获得
    //    签名字符串
#warning 请注意修改
    
    NSMutableDictionary *mutDic = [NSMutableDictionary new];
    NSString* ver=@"1.0.0"; //TODO:check
    
    CGSize scrSize;
    if ([UIScreen instancesRespondToSelector:@selector(currentMode)]) {
        scrSize = [[[UIScreen mainScreen] currentMode] size];
    }else{
        scrSize = [[UIScreen mainScreen] bounds].size;
    }
    
    NSString* screen=[NSString stringWithFormat:@"%d*%d",(int)scrSize.width,(int)scrSize.height];
    NSString* platform=@"iphone";
    NSString* mac=[[UIDevice currentDevice] MACAddress];
    NSString* version=[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleVersionKey];
    
    
    [mutDic setObject:ver forKey:@"ver"];
    [mutDic setObject:screen forKey:@"screen"];
    [mutDic setObject:platform forKey:@"platform"];
    [mutDic setObject:mac forKey:@"mac"];
    [mutDic setObject:ver forKey:@"ver"];
    [mutDic setObject:version forKey:@"ver"];
    if([self.userToken length]>0){
        [mutDic setObject:self.userToken forKey:@"usertoken"];
    }
    return [mutDic copy];
}


- (NSDictionary *)signForHeaderFields{
    return nil;
}

- (void)setUpEngines{
    [[NSNotificationCenter defaultCenter] addObserverForName:YK_NOTIFICATION_LOGIN object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        NSDictionary* dic=note.userInfo;
        YKUser* user=[dic objectForKey:@"user"];
        self.userToken=user.token;
        assert(user!=nil);
        assert(user.token!=nil);
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:YK_NOTIFICATION_LOGOUT object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.userToken=nil;
    }];
    
    self.camelHomeNetworkEngine = [[YKCamelHomeNetworkEngine alloc] initWithHostName:CAMEL_HOST customHeaderFields:[self commonHeaderFields]];
    [self.camelHomeNetworkEngine useCache];
    
    self.camelBrandNetworkEngine = [[YKCamelBrandNetworkEngine alloc] initWithHostName:CAMEL_HOST customHeaderFields:[self commonHeaderFields]];
    [self.camelBrandNetworkEngine useCache];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        self.camelHotSearchNetworkEngine = [[YKCamelHotSearchNetworkEngine alloc] initWithHostName:CAMEL_HOST customHeaderFields:[self commonHeaderFields]];
        [self.camelHotSearchNetworkEngine useCache];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
    
}


@end
