//
//  UIView+Method.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-7-2.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Method)

@end

extern  UIViewController* ControllerUseClass(Class vClass);

extern  UIBarButtonItem* ControllerLeftBarCustomWithButton(NSString *imagePName,SEL aAction,id target);

extern  UIBarButtonItem* ControllerRightBarCustomWithButton(NSString *imagePName,SEL aAction,id target);

extern  UIBarButtonItem* HomeControllerLeftBarCustomWithButton(NSString *imagePName);

