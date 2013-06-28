//
//  YKCamelCMethod.h
//  YKCamelProductDetailViewModule
//
//  Created by yanguo.sun on 13-4-18.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern float getTextSizeWidth(NSString*text ,float aFontSize) ;
extern NSArray *stringLengthArrayFor(NSArray* _arr,float aFontSize);
extern NSArray *lieInfoFor(NSArray* _lengInfo,float maxWidth,float widthAdd);
extern NSArray *retRectArrayFor(NSArray* _data,float aFontSize,float maxW,float widthAdd,float hAdd,float buttonH);
extern CGFloat getMaxInCGRectArray(NSArray *_rectArray);


