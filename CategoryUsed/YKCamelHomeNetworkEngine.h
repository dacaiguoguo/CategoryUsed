//
//  YKCamelNetworkEngine.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "MKNetworkEngine.h"
#import "YKBaseModel.h"

typedef void (^CurrencyResponseBlock)(YKHome *home);


@interface YKCamelHomeNetworkEngine : MKNetworkEngine

-(MKNetworkOperation*)completionHandler:(CurrencyResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end


typedef void (^BrandResponseBlock)(YKBrandList *brandli);


@interface YKCamelBrandNetworkEngine : MKNetworkEngine

-(MKNetworkOperation*)completionHandler:(BrandResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end


typedef void (^HotSearchResponseBlock)(YKKeywordList *keywordli);


@interface YKCamelHotSearchNetworkEngine : MKNetworkEngine

-(MKNetworkOperation*)completionHandler:(HotSearchResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end


typedef void (^ProductListResponseBlock)(YKProductList *keywordli);


@interface YKCamelProductListNetworkEngine : MKNetworkEngine

-(MKNetworkOperation*)searchKeyword:(NSString *)kw completionHandler:(ProductListResponseBlock) completionBlock
                 errorHandler:(MKNKErrorBlock) errorBlock;

@end








