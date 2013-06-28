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
