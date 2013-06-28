//
//  YKCamelCMethod.c
//  YKCamelProductDetailViewModule
//
//  Created by yanguo.sun on 13-4-18.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

//#include <stdio.h>

//#import <Foundation/Foundation.h>

#import "YKCamelCMethod.h"

float getTextSizeWidth(NSString*text ,float aFontSize) {
    NSString *platFormstr = text;
    CGSize platFormconstraint = CGSizeMake(10000, 10000);
    CGSize platFormsize =[platFormstr sizeWithFont:[UIFont systemFontOfSize:aFontSize] constrainedToSize:platFormconstraint lineBreakMode: UILineBreakModeCharacterWrap ];
    return platFormsize.width;
}

NSArray *stringLengthArrayFor(NSArray* _arr,float aFontSize){
    NSMutableArray *lengthArray = [NSMutableArray array];;
    
    for (int i=0; i<_arr.count; i++) {
        NSString *obj = [_arr objectAtIndex: i];
        float len = getTextSizeWidth(obj, 14)+10;
        [lengthArray addObject:[NSNumber numberWithFloat:len]];
    }
    return lengthArray;
}


NSArray *lieInfoFor(NSArray* _lengInfo,float maxWidth,float widthAdd){
    float total = 0;
    NSMutableArray *lie = [NSMutableArray array];
    [lie addObject:[NSNumber numberWithInt:0]];
    int tempTotal = 0;
    for (int i=0; i<_lengInfo.count; i++) {
        NSNumber *num =   [_lengInfo objectAtIndex: i];
        tempTotal+= (num.floatValue+widthAdd);
        if (tempTotal>maxWidth) {
            /*记下number*/
            [lie addObject:[NSNumber numberWithInt:i]];
            tempTotal = (num.floatValue+widthAdd);
        }
        total  = tempTotal;
    }
    if (total!=0) {
        int lastnumber =  _lengInfo.count;
        [lie addObject:[NSNumber numberWithInt:lastnumber]];
    }
    return lie;
}

NSArray *retRectArrayFor(NSArray* _data,float aFontSize,float maxW,float widthAdd,float hAdd,float buttonH){
    
    NSArray* _lengInfo = stringLengthArrayFor(_data,aFontSize);
    NSArray* _lieInfo = lieInfoFor(_lengInfo, maxW,widthAdd);
    
    int widthadd = widthAdd;
    int hadd = hAdd;
    int buH = buttonH;
    NSMutableArray *cgrectArray = [NSMutableArray array];
    for (int i=0; i<_lieInfo.count-1; i++) {
        NSNumber *obj = [_lieInfo objectAtIndex: i];
        int chushi = obj.intValue;
        obj = [_lieInfo objectAtIndex: i+1];
        float dangqianXTotal = 0;
        int end = obj.intValue;
        
        for (int j = chushi; j<end; j++) {
            NSNumber *wwww = [_lengInfo objectAtIndex: j];
            /*添加button Frame*/
            CGRect fra = CGRectMake(dangqianXTotal+(widthadd*(j-chushi)), hadd*i, wwww.floatValue, buH);
            [cgrectArray addObject:[NSValue valueWithCGRect:fra]];
            dangqianXTotal+=wwww.floatValue;
            
        }
        
    }
    return cgrectArray;
}

CGFloat getMaxInCGRectArray(NSArray *_rectArray){
    NSValue *last = _rectArray.lastObject;
    return CGRectGetMaxY(last.CGRectValue);
}