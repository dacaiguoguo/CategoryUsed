//
//  YKBaseModel.m
//  YKModule
//
//  Created by TFH on 13-4-1.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKBaseModel.h"



@implementation YKEntity{
    NSMutableDictionary* attrDic;
}

-(id)init{
    self=[super init];
    if(self){
        attrDic=[[NSMutableDictionary alloc] init];
    }
    return self;
}
-(void)setAttributeValue:(NSString *)v forKey:(NSString *)akey{
    [attrDic setObject:v forKey:akey];
}
-(NSString *)attributeValueForKey:(NSString *)akey{
    return [attrDic objectForKey:akey];
}
@end


@interface YKProductList()
@property (strong) NSMutableArray* productList;
@end
@implementation YKProductList
-(id)init{
    self=[super init];
    if(self){
        self.productList=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)addObject:(YKProduct *)aobj{
    [self.productList addObject:aobj];
}
-(YKProduct *)objectAtIndex:(NSUInteger)aindex{
    return [self.productList objectAtIndex:aindex];
}
-(NSUInteger)count{
    return [self.productList count];
}
@end



@interface YKCommentList()
@property (strong) NSMutableArray* commentList;
@end
@implementation YKCommentList
-(id)init{
    self=[super init];
    if(self){
        self.commentList=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)addObject:(YKProduct *)aobj{
    [self.commentList addObject:aobj];
}
-(YKProduct *)objectAtIndex:(NSUInteger)aindex{
    return [self.commentList objectAtIndex:aindex];
}
-(NSUInteger)count{
    return [self.commentList count];
}
@end

//
//
//
//@implementation YKAddress
//@end
//
//@implementation YKBrand
//
//@end
//
//@implementation YKDiscount
//@end
//
//@implementation YKCart
//
//@end
//
//
//@implementation YKCategory
//
//
//@end
//@implementation YKHome
//
//
//@end
//
//@implementation YKSendTime
//@end
//
//
//@implementation YKPayWay
//@end
//
//
//@implementation YKCheckout
//@end
//
//@implementation YKOrder
//
//
//@end
//@implementation YKProduct
//
//
//@end
//@implementation YKProductSize
//
//
//@end
//@implementation YKProductColor
//
//
//@end
//
//@implementation YKComment
//
//@end
//
//
//@implementation YKSecKill
//
//
//@end
//
//@implementation YKTopic
//
//@end
//
//@implementation YKUser
//
//
//@end
//
//@implementation YKGroup
//
//
//@end
//
//
//@implementation YKNotice
//@end
//
//@implementation YKUpdate
//
//@end
//



//@implementation YKEntity @end
@implementation YKProductSize @end
@implementation YKProductColor @end


#import "YKCamelCMethod.h"

#define W_RandomView 270
#define H_RandomView 22
#define H_Add_RandomView 30
#define W_Add_RandomView 10
#define computerRect(data) (retRectArrayFor(data, 14, W_RandomView, W_Add_RandomView, H_Add_RandomView, H_RandomView))

@implementation YKProduct


- (int)countOfColor{
    return self.colorList.count;
    
}

- (int)countOfSizeAtIndex:(int)idx{
    return [self colorAtIndex:idx].sizeList.count;
}
- (NSString *)colorNameAtIndex:(int)indx{
    YKProductColor *color= (YKProductColor *) [self.colorList objectAtIndex:indx];
    return color.colorName;
}
- (NSArray *)productImagesNameArrayAtIndex:(int)idx{
    return [self colorAtIndex:idx].imageList;
}


- (NSArray *)productBigImagesNameArrayAtIndex:(int)idx{
    return [[self colorAtIndex:idx] bigImageList];
}
- (NSArray  *)colorNameArray{
    NSMutableArray *color = [NSMutableArray new];
    for (int i=0; i<[self countOfColor]; i++) {
        [color addObject:[self colorNameAtIndex:i]];
    }
    return [color copy];
}
- (YKProductColor *)colorAtIndex:(int)ind{
    assert(self.colorList);
#ifdef DEBUG
    NSLog(@"colorList:%@",self.colorList);
#endif
    assert(ind!=NSNotFound);
    assert(ind<self.colorList.count);
    YKProductColor *color= (YKProductColor *) [self.colorList objectAtIndex:ind];
    assert(color);
    return color;
}

- (YKProductSize *)sizeInColor:(YKProductColor *)col AtIndex:(int)idx{
    if (idx<col.sizeList.count) {
        return [col.sizeList objectAtIndex:idx];
    }else
        return nil;
}
- (void)computer{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        _firstSelectColor = NSNotFound;
        
        self.productColorNameArray = [self colorNameArray];
        
        self.rectArrayColor = computerRect(self.productColorNameArray);
        
        NSMutableArray *tSize = [NSMutableArray new];
        NSMutableArray *tempSizeName = [NSMutableArray new];
        
        NSMutableArray *tempFirstSelectSize = [NSMutableArray new];
        for (int i=0; i<[self countOfColor]; i++) {
            [tempFirstSelectSize addObject:[NSNull null]];
        }
        
        
        
        for (int i=0; i<[self countOfColor]; i++) {
            
            NSMutableArray *tempArray = [NSMutableArray new];
            YKProductColor *col = [self colorAtIndex:i];
            
            
            for (int j=0; j<[self countOfSizeAtIndex:i]; j++) {
                YKProductSize *size = [self sizeInColor:col AtIndex:j];
                [tempArray addObject:size.sizeName];
                if (_firstSelectColor==NSNotFound) {
                    if (size.stock.intValue>0) {
                        _firstSelectColor = i;
                    }
                }
                
                if ([tempFirstSelectSize objectAtIndex:i]==[NSNull null]) {
                    if (size.stock.intValue>0) {//记住第一个库存不为0的size
                        [tempFirstSelectSize replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:j]];
                    }
                }
                
                
            }
            
            [tempSizeName addObject:tempArray];
            NSArray *toAddSize = computerRect(tempArray);
            [tSize addObject:toAddSize];
            
        }
        
        if (_firstSelectColor==NSNotFound) {
            self.isOffSale = YES;
            _firstSelectColor = 0;
        }
        
        self.firstSelectSizeArray = tempFirstSelectSize;
        
        //当没有时，赋值一个0，防止数组越界
        if (self.firstSelectSizeArray.count==0) {
            self.firstSelectSizeArray = @[[NSNumber numberWithInt:0]];
        }
        self.productSizeNameArrayTotal = tempSizeName;
        self.rectArraySizeTotal = tSize;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.delegate respondsToSelector:@selector(computerFinished)]) {
                [self.delegate computerFinished];
            }
        });
        
    });
}


- (NSString *)salePriceInColor:(int)colorIdx sizeIndex:(int)sizeIdx{
    YKProductSize *size = [self sizeInColor:[self colorAtIndex:colorIdx] AtIndex:sizeIdx];
    
    return size.salePrice.length>0?size.salePrice:@"";
}
- (NSString *)marketPriceInColor:(int)colorIdx sizeIndex:(int)sizeIdx{
    YKProductSize *size = [self sizeInColor:[self colorAtIndex:colorIdx] AtIndex:sizeIdx];
    return size.marketPrice.length>0?size.marketPrice:@"";
}


@end
@implementation YKComment @end
@implementation YKCategory @end
//@implementation YKProductList @end
//@interface YKFilter : YKEntity
@implementation YKAddress @end
@implementation YKPayWay @end
@implementation YKSendTime @end
@implementation YKCheckout @end
@implementation YKOrder @end
@implementation YKHome @end
@implementation YKTopic @end
@implementation YKDiscount @end
@implementation YKCart @end
@implementation YKSecKill @end
@implementation YKGroup @end
@implementation YKLottery @end

@implementation YKLotteryResult @end


@implementation YKUser @end
@implementation YKBrand @end
//@interface YKActivity : YKEntity
@implementation YKNotice @end
@implementation YKHelp @end
@implementation YKUpdate @end
@implementation YKCustomerType @end
@implementation YKInvoiceType @end
@implementation YKDeliver @end

@implementation YKFilterOption @end

@implementation YKFilter @end




