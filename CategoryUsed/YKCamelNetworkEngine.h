//
//  YKCamelNetworkEngine.h
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "MKNetworkEngine.h"

#define CAMEL_HOST @"b2c.test.yekmob.com/api/index.php"
#define CAMEL_HOME_URL [NSString stringWithFormat:@"%@%@",CAMEL_HOST,@"/home"]

typedef void (^CurrencyResponseBlock)(YKHome *home);


@interface YKCamelNetworkEngine : MKNetworkEngine

-(MKNetworkOperation*)completionHandler:(CurrencyResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock;

@end
