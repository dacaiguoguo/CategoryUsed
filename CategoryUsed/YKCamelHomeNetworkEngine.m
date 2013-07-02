//
//  YKCamelNetworkEngine.m
//  CategoryUsed
//
//  Created by yanguo.sun on 13-6-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKCamelHomeNetworkEngine.h"
#import "YKGDSFacade.h"


@implementation YKCamelHomeNetworkEngine


-(MKNetworkOperation*)completionHandler:(CurrencyResponseBlock) completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock {
    
    MKNetworkOperation *op = [self operationWithPath:@"home" params:nil httpMethod:@"GET"];

    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block

         if([completedOperation isCachedResponse]) {
             DLog(@"Data from cache");
         }
         else {
             DLog(@"Data from server");
         }
         
         NSString* responseString=[completedOperation responseString];
         if([responseString length]<1){
             DLog(@"[ERROR] 服务端返回数据为空 %s ",__FUNCTION__);
//             NSError* error=[NSError errorWithDomain:@"SEVER_ERROR" code:YKGDS_ERROR_CODE_INVALID_RESPONSE_EXCEPTION userInfo:nil];
         }else{
             YKGDSHomeJsonParser* parser=[[YKGDSHomeJsonParser alloc] init];
             YKGDSResponse* resp=[parser parseFromJson:responseString];
             if([resp.result isEqualToString:@"0"]){
                 completionBlock(resp.responseObj);
             
             }else{
//                 NSError* error=[NSError errorWithDomain:YKGDS_SERVER_ERROR_DOMAIN code:[resp.result intValue] userInfo:@{NSLocalizedFailureReasonErrorKey:YKGDSStringOrEmpty(resp.message)}];
             }
         }

         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}
@end



@implementation YKCamelBrandNetworkEngine


-(MKNetworkOperation*)completionHandler:(BrandResponseBlock) completionBlock
                           errorHandler:(MKNKErrorBlock) errorBlock {
    
    MKNetworkOperation *op = [self operationWithPath:@"brandList" params:nil httpMethod:@"GET"];
    
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
     {
         // the completionBlock will be called twice.
         // if you are interested only in new values, move that code within the else block
         
         if([completedOperation isCachedResponse]) {
             DLog(@"Data from cache");
         }
         else {
             DLog(@"Data from server");
         }
         
         NSString* responseString=[completedOperation responseString];
         if([responseString length]<1){
             DLog(@"[ERROR] 服务端返回数据为空 %s ",__FUNCTION__);
             //             NSError* error=[NSError errorWithDomain:@"SEVER_ERROR" code:YKGDS_ERROR_CODE_INVALID_RESPONSE_EXCEPTION userInfo:nil];
         }else{
             YKGDSBrandListJsonParser* parser=[[YKGDSBrandListJsonParser alloc] init];
             YKGDSResponse* resp=[parser parseFromJson:responseString];
             if([resp.result isEqualToString:@"0"]){
                 completionBlock(resp.responseObj);
                 
             }else{
                 //                 NSError* error=[NSError errorWithDomain:YKGDS_SERVER_ERROR_DOMAIN code:[resp.result intValue] userInfo:@{NSLocalizedFailureReasonErrorKey:YKGDSStringOrEmpty(resp.message)}];
             }
         }
         
         
     }errorHandler:^(MKNetworkOperation *errorOp, NSError* error) {
         
         errorBlock(error);
     }];
    
    [self enqueueOperation:op];
    
    return op;
}
@end
