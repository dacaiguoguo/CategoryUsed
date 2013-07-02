//
//  UIView+Method.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-7-2.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "UIView+Method.h"

@implementation UIView (Method)

@end


 UIViewController* ControllerUseClass(Class vClass){
    
    
    UIViewController *ret = [[vClass alloc] initWithNibName:NSStringFromClass(vClass) bundle:nil];
    return ret;
    
}

 UIBarButtonItem* ControllerLeftBarCustomWithButton(NSString *imagePName,SEL aAction,id target){
    
    NSString *nor = [NSString stringWithFormat:@"%@_normal.png",imagePName];
    
    NSString *sel = [NSString stringWithFormat:@"%@_selected.png",imagePName];
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(-5, 1.5, 50, 47);
    [btn setImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:sel] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:sel] forState:UIControlStateSelected];
    
    [btn addTarget:target  action:aAction forControlEvents:UIControlEventTouchUpInside];
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 47)];  //直接设置 btn.frame x=-10 不好使
    view.backgroundColor=[UIColor clearColor];
    [view addSubview:btn];
    
    UIBarButtonItem* ret=[[UIBarButtonItem alloc] initWithCustomView:view];
    return ret;
    
}


 UIBarButtonItem* ControllerRightBarCustomWithButton(NSString *imagePName,SEL aAction,id target){
    
    NSString *nor = [NSString stringWithFormat:@"%@_normal.png",imagePName];
    
    NSString *sel = [NSString stringWithFormat:@"%@_selected.png",imagePName];
    UIButton* btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(14, 1.5, 50, 47);
    [btn setImage:[UIImage imageNamed:nor] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:sel] forState:UIControlStateHighlighted];
    [btn setImage:[UIImage imageNamed:sel] forState:UIControlStateSelected];
    
    [btn addTarget:target  action:aAction forControlEvents:UIControlEventTouchUpInside];
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 47)];  //直接设置 btn.frame x=-10 不好使
    view.backgroundColor=[UIColor clearColor];
    [view addSubview:btn];
    
    UIBarButtonItem* ret=[[UIBarButtonItem alloc] initWithCustomView:view];
    return ret;
    
}





 UIBarButtonItem* HomeControllerLeftBarCustomWithButton(NSString *imagePName){
    
    
    UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 46)];
    v.clipsToBounds=YES;
    UIImageView* iv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePName]];
    [v addSubview:iv];
    UIBarButtonItem* ret=[[UIBarButtonItem alloc] initWithCustomView:iv];
    return ret;
    
}