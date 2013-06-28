//
//  YKGDSFacade.m
//  YKGeneralDataSourceModule
//
//  Created by TFH on 13-3-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//

#import "YKGDSFacade.h"
#import "NSString+MKNetworkKitAdditions.h"
#import "JSONKit.h"

/*! 将string 转成 obj  */
//#define YKGDS_JSON_FROM_STRING(ret,str) {    NSError* error=nil;   \
//    ret=[NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];    \
//    if(error!=nil) {\
//        NSException* ex=[NSException exceptionWithName:YKGDS_EXCEPTION_PARSE_JSON reason:@"解析json出错" userInfo:nil];  \
//        @throw ex;\
//    }   \
//}


#define  YKGDS_JSON_FROM_STRING(ret,str){\
    ret=[str objectFromJSONString]; \
    if(ret==nil) {\
        NSException* ex=[NSException exceptionWithName:YKGDS_EXCEPTION_PARSE_JSON reason:@"解析json出现异常" userInfo:nil];  \
        NSLog(@"ex=%@",ex);\
        @throw ex;\
    }   \
}


//#define YKGDS_STR(target,dic,key) target=[[dic objectForKey:key] description]

/*! target=dic[key];  会对dic 进行类型检测  */
#define YKGDS_DIC_OBJ(target,dic,key) {\
    if([dic isKindOfClass:[NSDictionary class]]){\
        target=[dic objectForKey:key];\
    }else{\
        assert(NO);\
    }\
    if(target==nil){\
    }\
}

/*! target=dic[key];  会对dic 进行类型检测，会保证 target 是字符串类型  */
#define YKGDS_DIC_OBJ_STR(target,dic,key) {\
    id aaaobj=nil; \
    YKGDS_DIC_OBJ(aaaobj,dic,key); \
    if([aaaobj isKindOfClass:[NSString class]]){\
        target=aaaobj;  \
    }else{\
        target=[aaaobj description];\
    } \
}

/*!  */
#define YKGDS_ARRAY_ELE(target,array,i)



/**
 
 */
#define YKGDS_NEED_PARAM(dic,key) {\
if(![[dic allKeys] containsObject:key]){\
    NSException* ex=[NSException exceptionWithName:@"InvalidParam" reason:[NSString stringWithFormat: @"%s需要参数 %@ ",__FUNCTION__,key] userInfo:params];@throw ex; \
    } \
}


/*!
 解析 result message & responseObj
// ret:     YKGDSResponse* ret=[[YKGDSResponse alloc] init];
 */
#define YKGDS_PARSE2(ret,jsonString,responseObjKey,responseData){\
    assert(ret!=nil);\
    id json=nil;\
    YKGDS_JSON_FROM_STRING(json, jsonString);\
    YKGDS_DIC_OBJ_STR(ret.result, json, YKGDS_KEY_RESULT);\
    YKGDS_DIC_OBJ_STR(ret.message, json, YKGDS_KEY_MESSAGE);\
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result]){   \
        YKGDS_DIC_OBJ(responseData, json, YKGDS_KEY_RESONSE_DATA);\
        if( [responseData isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseData count]>0  && nil!=responseObjKey  ){\
            id respDataObjInfo=nil; YKGDS_DIC_OBJ(respDataObjInfo, responseData, responseObjKey);\
            if(respDataObjInfo==nil){\
                NSException* ex=[NSException exceptionWithName:YKGDS_EXCEPTION_PARSE_NO_ELEMENT reason:[NSString stringWithFormat:@"responseData 下没有找到%@元素",responseObjKey] userInfo:json];\
                @throw ex;\
            }else{\
                id obj=[self parseFromJsonObj:respDataObjInfo];\
                ret.responseObj=obj;\
            }\
        }\
    }\
}


#define YKGDS_PARSE(ret,jsonString,responseObjKey){\
    id responseData=nil;    \
    YKGDS_PARSE2(ret,jsonString,responseObjKey,responseData)    \
}






@implementation YKGDSResponse


@end



@implementation YKGDSBaseJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    assert([jsonString length]>0);
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id json=nil;
    YKGDS_JSON_FROM_STRING(json, jsonString);
    self.jsonObj=json;
    YKGDS_DIC_OBJ_STR(ret.result, json, YKGDS_KEY_RESULT);
    YKGDS_DIC_OBJ_STR(ret.message, json, YKGDS_KEY_MESSAGE);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result]){
        YKGDS_DIC_OBJ(self.responseDataJson, json, YKGDS_KEY_RESONSE_DATA);
        if(nil!=[self responseObjKey]){
            id respDataObjInfo=nil; YKGDS_DIC_OBJ(respDataObjInfo, self.responseDataJson, [self responseObjKey]);
            if(respDataObjInfo==nil){
                NSException* ex=[NSException exceptionWithName:YKGDS_EXCEPTION_PARSE_NO_ELEMENT reason:[NSString stringWithFormat:@"responseData 下没有找到%@元素",[self responseObjKey]] userInfo:json];
                @throw ex;
            }else{
                id obj=[self parseFromJsonObj:respDataObjInfo];
                ret.responseObj=obj;
            }
        }
    }
    return ret;
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(NO);
    [self doesNotRecognizeSelector:@selector(parseFromJsonObj:)];
}
-(NSString *)responseObjKey{
    [self doesNotRecognizeSelector:@selector(responseObjKey)];
    return nil;
}

@end


@implementation YKGDSResponseJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    id json=nil;
    YKGDS_JSON_FROM_STRING(json, jsonString);
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    YKGDS_DIC_OBJ_STR(ret.result, json, YKGDS_KEY_RESULT);
    YKGDS_DIC_OBJ_STR(ret.message, json, YKGDS_KEY_MESSAGE);
    return ret;
}

@end

@implementation YKGDSUserJsonParser
//-(YKGDSResponse *)parseFromJson_:(NSString *)jsonString{
//    id json=nil;
//    YKGDS_JSON_FROM_STRING(json, jsonString);
//    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
//    YKGDS_DIC_OBJ_STR(ret.result, json, YKGDS_KEY_RESULT);
//    YKGDS_DIC_OBJ_STR(ret.message, json, YKGDS_KEY_MESSAGE);
//    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result]){
//        id responseData=nil;
//        YKGDS_DIC_OBJ(responseData, json, YKGDS_KEY_RESONSE_DATA);
//        id userInfo=nil; YKGDS_DIC_OBJ(userInfo, responseData, @"userinfo");
//        if(userInfo==nil){
//            NSException* ex=[NSException exceptionWithName:YKGDS_EXCEPTION_PARSE_NO_ELEMENT reason:@"没有找到responseData元素" userInfo:json];
//            @throw ex;
//        }else{
//            YKUser* u=[self parseFromJsonObj:userInfo];
//            ret.responseObj=u;
//        }
//    }
//    return ret;
//}
//-(YKGDSResponse*) parseFromJson_:(NSString *)jsonString{
//    id data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    id json=nil;
//    YKGDS_JSON_FROM_STRING(json, jsonString);
//    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
//    ret.result=YK
//    YKUser* user=[self parseFromJsonObj:[[json objectForKey:@"responseData"]  objectForKey:@"userinfo"]];
//    return ret;
//}

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    YKGDS_PARSE(ret,jsonString,@"userinfo");
    return ret;
}

-(YKUser*)parseFromJsonObj:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]]); //objtest assert( [obj count]>0);
    YKUser* ret=[[YKUser alloc] init];
    YKGDS_DIC_OBJ_STR(ret.userId, obj, @"userId");
    YKGDS_DIC_OBJ_STR(ret.level,obj,@"userLevel");
    YKGDS_DIC_OBJ_STR(ret.email,obj,@"email");
    YKGDS_DIC_OBJ_STR(ret.birthday,obj,@"birthday");
    YKGDS_DIC_OBJ_STR(ret.token,obj,@"usertoken");
    YKGDS_DIC_OBJ_STR(ret.nickName,obj,@"nickName");
    YKGDS_DIC_OBJ_STR(ret.telephone,obj,@"telephone");
    return ret;
}
@end

@implementation YKGDSLoginUserJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[super parseFromJson:jsonString];
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] ){
        assert(ret.responseObj!=nil);
        [[NSNotificationCenter defaultCenter] postNotificationName:YK_NOTIFICATION_LOGIN object:self userInfo:@{@"user":ret.responseObj}];
    }
    return ret;
}
@end


@implementation YKGDSProductJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    NSDictionary* responeDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,nil,responeDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responeDataJson isKindOfClass:[NSDictionary class]] && [responeDataJson count]>0 ){
        ret.responseObj=[self parseFromJsonObj:responeDataJson];
    }
    return ret;
}
-(YKProduct*)parseFromJsonObj:(NSDictionary*) obj{
    YKProduct* ret=[[YKProduct alloc] init];
    [self parseTarget:ret fromJsonObj:obj];
    return ret;
}
-(void)parseTarget:(YKProduct*) ret fromJsonObj:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    
    YKGDS_DIC_OBJ_STR(ret.productId, obj, @"productId");
    YKGDS_DIC_OBJ_STR(ret.categoryId, obj, @"categoryId");
    YKGDS_DIC_OBJ_STR(ret.pattern, obj, @"pattern");
    YKGDS_DIC_OBJ_STR(ret.type, obj, @"productType");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"productName");
    YKGDS_DIC_OBJ_STR(ret.desc, obj, @"productDesc");
    YKGDS_DIC_OBJ_STR(ret.imageUrl, obj, @"productImageUrl");
    YKGDS_DIC_OBJ_STR(ret.gridUrl, obj, @"productGridUrl");
    YKGDS_DIC_OBJ_STR(ret.marketPrice, obj, @"marketPrice");
    YKGDS_DIC_OBJ_STR(ret.salePrice, obj, @"salePrice");
    YKGDS_DIC_OBJ_STR(ret.totalPrice, obj, @"totalPrice");
    
    YKGDS_DIC_OBJ_STR(ret.count, obj, @"count");
    YKGDS_DIC_OBJ_STR(ret.productId, obj, @"productId");
    YKGDS_DIC_OBJ_STR(ret.sku, obj, @"productSku");
    YKGDS_DIC_OBJ_STR(ret.colorName, obj, @"colorName");
    YKGDS_DIC_OBJ_STR(ret.sizeName, obj, @"sizeName");
    
    YKGDS_DIC_OBJ_STR(ret.brandId, obj, @"brandId");
    
    YKGDS_DIC_OBJ_STR(ret.sizeTableUrl, obj, @"sizeUrl");
    id isGet=nil;
    YKGDS_DIC_OBJ(isGet, obj, @"isGet");
    ret.isGet=[isGet boolValue];
    
    //skulist
    NSArray* skuListJson=[obj objectForKey:@"skuList"];
    if(skuListJson!=nil && [skuListJson isKindOfClass:[NSArray class]] && [skuListJson count]){
        YKGDSProductColorJsonParser* colorParser=[[YKGDSProductColorJsonParser alloc] init];
        ret.colorList=[[YKProductColorList alloc] init];
        for(id skuJson in skuListJson){
            YKProductColor* pc=[colorParser parseFromJsonObj:skuJson];
            [ret.colorList addObject:pc];
        }
    }
}

@end

@implementation YKGDSCommentJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    YKComment* ret=[[YKComment alloc] init];
    YKGDS_DIC_OBJ_STR(ret.commentId, obj, @"id");
    YKGDS_DIC_OBJ_STR(ret.score, obj, @"score");
    YKGDS_DIC_OBJ_STR(ret.username, obj, @"username");
    YKGDS_DIC_OBJ_STR(ret.content, obj, @"content");
    YKGDS_DIC_OBJ_STR(ret.time, obj, @"time");
    return ret;
}

@end

@implementation YKGDSCommentListJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,@"commentList",responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKCommentList* list=ret.responseObj;
        assert(list!=nil);
        assert([list isMemberOfClass:[YKCommentList class]]);
        
        list.totalCount=[[responseDataJson objectForKey:@"totalCount"] intValue];
    }
    return ret;
}

-(id)parseFromJsonObj:(NSMutableArray *)obj{
    YKGDSCommentJsonParser* p=[[YKGDSCommentJsonParser alloc] init];
    YKCommentList* ret=[[YKCommentList alloc] init];
    for(id cjson in obj){
        [ret addObject:[p parseFromJsonObj:cjson]];
    }
    return ret;
}
@end


@implementation YKGDSProductSizeJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    assert(NO);
    return nil;
}
-(YKProductSize*)parseFromJsonObj:(NSDictionary *)obj{
    YKProductSize* ret=[[YKProductSize alloc] init];
    YKGDS_DIC_OBJ_STR(ret.sizeId, obj, @"sizeId");
    YKGDS_DIC_OBJ_STR(ret.sizeName, obj, @"sizeName");
    YKGDS_DIC_OBJ_STR(ret.sku, obj, @"sku");
    YKGDS_DIC_OBJ_STR(ret.stock, obj, @"stock");
    YKGDS_DIC_OBJ_STR(ret.marketPrice, obj, @"marketPrice");
    YKGDS_DIC_OBJ_STR(ret.salePrice, obj, @"salePrice");
    return ret;
}
@end

@implementation YKGDSProductColorJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    assert(NO);
    return nil;
}

-(YKProductColor*)parseFromJsonObj:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    YKProductColor* ret=[[YKProductColor alloc] init];
    YKGDS_DIC_OBJ_STR(ret.colorId, obj, @"colorId");
    YKGDS_DIC_OBJ_STR(ret.colorName, obj, @"colorName");
    YKGDS_DIC_OBJ_STR(ret.colorUrl, obj, @"colorUrl");
    YKGDS_DIC_OBJ_STR(ret.marketPrice, obj, @"marketPrice");
    YKGDS_DIC_OBJ_STR(ret.salePrice, obj, @"salePrice");
    //YKGDS_DIC_OBJ_STR(ret.imageList, obj, @"imageList");
    //YKGDS_DIC_OBJ_STR(ret.sizeList, obj, @"sizeList");
    
    {//imageList
        id imageListJson=[obj objectForKey:@"imageList"];
        if(imageListJson!=nil){
            ret.imageList=[[NSMutableArray alloc] init];
            for(id url in imageListJson){
                [ret.imageList addObject:[url description]];
            }
        }
    }
    
    {//imageList
        id imageListJson=[obj objectForKey:@"imageBigList"];
        if(imageListJson!=nil){
            ret.bigImageList=[[NSMutableArray alloc] init];
            for(id url in imageListJson){
                [ret.bigImageList addObject:[url description]];
            }
        }
    }
    
    {//sizeList
        NSArray* sizeListJson=[obj objectForKey:@"sizeList"];
        if(sizeListJson!=nil){
            ret.sizeList=[[YKProductSizeList alloc] init];
            YKGDSProductSizeJsonParser* sp=[[YKGDSProductSizeJsonParser alloc] init];
            for(id sizeJson in sizeListJson){
                YKProductSize* s=[sp parseFromJsonObj:sizeJson];
                [ret.sizeList addObject:s];
            }
        }
    }
    return ret;
}
@end

@implementation YKGDSProductListJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,@"productList",responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKProductList* list=ret.responseObj;
        assert(list!=nil);
        assert([list isMemberOfClass:[YKProductList class]]);
        
        list.totalCount=[[responseDataJson objectForKey:@"totalCount"] intValue];
        list.hasInfo=[[responseDataJson objectForKey:@"hasInfo"] boolValue];
        YKGDS_DIC_OBJ_STR(list.infoUrl, responseDataJson, @"infoUrl");
        YKGDS_DIC_OBJ_STR(list.title, responseDataJson, @"title");
        
        {//parse filter
            id filterListJson=[responseDataJson objectForKey:@"filter"];
            if([filterListJson isKindOfClass:[NSArray class]] && [(NSArray*)filterListJson count]>0){
                YKFilterList* filterList=[[YKFilterList alloc] init];
                list.filterList=filterList;
                for(id filterJson in filterListJson){
                    if(filterJson!=nil && [filterJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)filterJson count]>0){
                        YKFilter* f=[[YKFilter alloc] init];
                        [filterList addObject:f];
                        YKGDS_DIC_OBJ_STR(f.name, filterJson, @"name");
                        id optionListJson=nil; YKGDS_DIC_OBJ(optionListJson, filterJson, @"optionalList");
                        if(optionListJson!=nil && [optionListJson isKindOfClass:[NSArray class]] && [(NSArray*)optionListJson count]>0){
                            YKFilterOptionList* filterOptionList=[[YKFilterOptionList alloc] init];
                            f.optionList=filterOptionList;
                            for(id optionJson in optionListJson){
                                if(optionJson!=nil && [optionJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)optionJson count]>0){
                                    YKFilterOption* option=[[YKFilterOption alloc] init];
                                    [filterOptionList addObject:option];
                                    YKGDS_DIC_OBJ_STR(option.text, optionJson, @"text");
                                    YKGDS_DIC_OBJ_STR(option.value, optionJson, @"value");
                                }
                            }
                        }
                        
                    }
                }
            }
        }
//        
//        {//parse filter
//            id filterJson=[responseDataJson objectForKey:@"filter"];
//            if([filterJson isKindOfClass:[NSDictionary class]]){
//                list.filterCategoryList=[[YKCategoryList alloc] init];
//                id categoryListJson=[filterJson objectForKey:@"categoryList"];
//                for(id cjson in categoryListJson){
//                    YKCategory* category=[[YKCategory alloc] init];
//                    YKGDS_DIC_OBJ_STR(category.cid, cjson, @"catId");
//                    YKGDS_DIC_OBJ_STR(category.name, cjson, @"catName");
//                    [list.filterCategoryList addObject:category];
//                }
//                
//                list.filterColorList=[[YKProductColorList alloc] init];
//                id colorListJson=[filterJson objectForKey:@"colors"];
//                for( id cjson in colorListJson){
//                    YKProductColor* c=[[YKProductColor alloc] init];
//                    YKGDS_DIC_OBJ_STR(c.colorName, cjson, @"colorName");
//                    [list.filterColorList addObject:c];
//                }
//                
//                list.filterSizeList=[[YKProductSizeList alloc] init];
//                id sizeListJson=[filterJson objectForKey:@"sizes"];
//                for( id cjson in sizeListJson){
//                    YKProductSize* c=[[YKProductSize alloc] init];
//                    YKGDS_DIC_OBJ_STR(c.sizeName, cjson, @"sizeName");
//                    [list.filterSizeList addObject:c];
//                }
//                
//            }
//        }
    }
    return ret;
}


-(YKProductList*)parseFromJsonObj:(NSArray*) obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    YKProductList* ret=[[YKProductList alloc] init];
    //NSMutableArray* pl=[[NSMutableArray alloc] init];
    for(id pjson in obj){
        YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
        YKProduct* p=[pp parseFromJsonObj:pjson];
        [ret addObject:p];
    }
    //ret.productList=pl;
    return ret;
}
@end

@implementation YKGDSFavoriteListJsonParser
-(NSString *)responseObjKey{
    return @"collectList";
}
-(id)parseFromJsonObj:(NSArray *)obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    NSMutableArray* ret=[[NSMutableArray alloc] init];
    YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
    for(id p in obj){
        YKProduct* product=[pp parseFromJsonObj:p];
        [ret addObject:product];
    }
    return ret;
}
@end

@implementation YKGDSBrandCategoryJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataObj=nil;
    YKGDS_PARSE2(ret,jsonString,nil,responseDataObj);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataObj isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataObj count]>0 ){
        YKGDSBrandJsonParser* brandParser=[[YKGDSBrandJsonParser alloc] init];
        YKBrand* brand=[brandParser parseFromJsonObj:responseDataObj];
        YKGDSCategoryJsonParser* cateParser=[[YKGDSCategoryJsonParser alloc] init];
        NSArray* cateogryListObj=[responseDataObj objectForKey:@"category"];
        brand.categoryList=[cateParser parseFromJsonObj:cateogryListObj];
        ret.responseObj=brand;
    }
    return ret;
}

@end


@implementation YKGDSCategoryJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataObj=nil;
    YKGDS_PARSE2(ret,jsonString,nil,responseDataObj);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataObj isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataObj count]>0 ){
        NSArray* cateogryListObj=[responseDataObj objectForKey:@"category"];
        ret.responseObj=[self parseFromJsonObj:cateogryListObj];
    }
    return ret;
}

-(YKCategory*)parseCategory:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    YKCategory* ret=[[YKCategory alloc] init];
    YKGDS_DIC_OBJ_STR(ret.cid, obj, @"cid");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"name");
    YKGDS_DIC_OBJ_STR(ret.catIcon, obj, @"icon");
    if([[obj allKeys] containsObject:@"subCategory"]){
        ret.subCategory=[self parseFromJsonObj:[obj objectForKey:@"subCategory"]];
    }
    return ret;
}
-(YKCategoryList*)parseFromJsonObj:(NSArray*) obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    YKCategoryList* ret=[[YKCategoryList alloc] init];
    
    for(id ad in obj){
        YKCategory* address=[self parseCategory:ad];
        [ret addObject:address];
    }
    return ret;
}

@end


@implementation YKGDSKeywordJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    assert(NO);
    [self doesNotRecognizeSelector:_cmd];
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKKeyword* ret=nil;
    YKGDS_DIC_OBJ_STR(ret, obj, @"name");    
    return ret;
}
@end

@implementation YKGDSKeywordListJsonParser

-(NSString *)responseObjKey{
    return @"keywordList";
}
-(id)parseFromJsonObj:(NSArray *)obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert( [obj count]>0);
    YKKeywordList* ret=[[YKKeywordList alloc] init];
    YKGDSKeywordJsonParser* p=[[YKGDSKeywordJsonParser alloc] init];
    for(id kjson in obj){
        YKKeyword* k=[p parseFromJsonObj:kjson];
        [ret addObject:k];
    }
    return ret;
}

@end

//@implementation YKGDSFilterJsonParser
//        
//@end
//        
//@implementation YKGDSFilterListJsonParser
//-(id)parseFromJsonObj:(NSDictionary *)obj{
//    YKFilter
//}
//@end

@implementation YKGDSAddressModifyResponseJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataJson=nil;
    YKGDS_PARSE2(ret, jsonString, nil, responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKGDS_DIC_OBJ_STR(ret.responseObj, responseDataJson, @"addressId");
    }
    return ret;
}

@end
@implementation YKGDSAddressJsonParser
-(NSString *)responseObjKey{
    return @"addressInfo";
}

-(YKAddress*)parseFromJsonObj:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]]); //objtest assert( [obj count]>0);
    YKAddress* ret=[[YKAddress alloc] init];
    YKGDS_DIC_OBJ_STR(ret.addressId, obj, @"addressId");
    YKGDS_DIC_OBJ_STR(ret.receiverName, obj, @"receiverName");
    YKGDS_DIC_OBJ_STR(ret.provinceId, obj, @"provinceId");
    YKGDS_DIC_OBJ_STR(ret.provinceName, obj, @"provinceName");
    YKGDS_DIC_OBJ_STR(ret.cityId, obj, @"cityId");
    YKGDS_DIC_OBJ_STR(ret.cityName, obj, @"cityName");
    YKGDS_DIC_OBJ_STR(ret.areaId, obj, @"areaId");
    YKGDS_DIC_OBJ_STR(ret.areaName, obj, @"areaName");
    YKGDS_DIC_OBJ_STR(ret.streetDetail, obj, @"address");
    YKGDS_DIC_OBJ_STR(ret.zipCode, obj, @"zipCode");
    YKGDS_DIC_OBJ_STR(ret.mobile, obj, @"mobile");
    YKGDS_DIC_OBJ_STR(ret.phone, obj, @"phone");
    YKGDS_DIC_OBJ_STR(ret.email, obj, @"email");
    YKGDS_DIC_OBJ_STR(ret.isDefault, obj, @"isDefault");

    return ret;
}

@end

@implementation YKGDSAddressListJsonParser
-(NSString *)responseObjKey{
    return @"addressList";
}

-(YKAddressList*)parseFromJsonObj:(NSArray*) obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert( [obj count]>0);
    YKAddressList* ret=[[YKAddressList alloc] init];    
    YKGDSAddressJsonParser* p=[[YKGDSAddressJsonParser alloc] init];
    for(id ad in obj){
        YKAddress* address=[p parseFromJsonObj:ad];
        [ret addObject:address];
    }
    return ret;
}

@end

@implementation YKGDSCheckoutJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    NSDictionary* responseDataJson=nil;
    YKGDS_PARSE2(ret, jsonString, nil, responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKCheckout* checkout=[[YKCheckout alloc] init];
        id userInfoJson=nil;
        YKGDS_DIC_OBJ(userInfoJson, responseDataJson, @"userInfo");
        
        {//解析地址
            id addressJson=nil;
            YKGDS_DIC_OBJ(addressJson, userInfoJson, @"addressInfo");
            if(addressJson!=nil && [addressJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)addressJson count]>0 ){
                YKGDSAddressJsonParser* p=[[YKGDSAddressJsonParser alloc] init];
                checkout.defaultAddress=[p parseFromJsonObj:addressJson];
            }
        }
        
        {//parse payway list
            id paywayJson=nil;
            YKGDS_DIC_OBJ(paywayJson, userInfoJson, @"payWay");
            if(paywayJson!=nil){
                YKGDSPayWayListJsonParser* p=[[YKGDSPayWayListJsonParser alloc] init];
                checkout.payWayList=[p parseFromJsonObj:paywayJson];
            }
        }
        
        {//parse 送货方式
            id deliverJson=nil;
            YKGDS_DIC_OBJ(deliverJson, userInfoJson, @"dlyInfo");
            if(deliverJson!=nil){
                YKGDSDeliverListJsonParser* p=[[YKGDSDeliverListJsonParser alloc] init];
                checkout.deliverList=[p parseFromJsonObj:deliverJson];
            }
        }

        {//发票
            id invoiceJson=nil;
            YKGDS_DIC_OBJ(invoiceJson, userInfoJson, @"invoiceInfo");
            if(invoiceJson!=nil){
                YKGDS_DIC_OBJ_STR(checkout.invoiceTitle, invoiceJson, @"invoiceTitle");
                
                {//发票类型
                    id invoiceTypeJson=nil; YKGDS_DIC_OBJ(invoiceTypeJson, invoiceJson, @"invoiceType");
                    if(invoiceTypeJson!=nil){
                        YKGDSInvoiceTypeListJsonParser* p=[[YKGDSInvoiceTypeListJsonParser  alloc] init];
                        checkout.invoiceTypeList=[p parseFromJsonObj:invoiceTypeJson];
                    }
                }

                {//发票客户类型
                    id customerTypeJson=nil; YKGDS_DIC_OBJ(customerTypeJson, invoiceJson, @"customerType");
                    if(customerTypeJson!=nil){
                        YKGDSCustomerTypeListJsonParser* p=[[YKGDSCustomerTypeListJsonParser  alloc] init];
                        checkout.customerTypeList=[p parseFromJsonObj:customerTypeJson];
                    }
                }
            }
        }
        
        {//parse sendtime list
            id sendtimeJson=nil;
            YKGDS_DIC_OBJ(sendtimeJson, userInfoJson, @"sendTime");
            if(sendtimeJson!=nil){
                YKGDSSendTimeListJsonParser* p=[[YKGDSSendTimeListJsonParser alloc] init];
                checkout.sendTimeList=[p parseFromJsonObj:sendtimeJson];
            }
        }
        
        
        
        {//parse product list
            id pljson=nil;
            YKGDS_DIC_OBJ(pljson, responseDataJson, @"productList");
            if(pljson!=nil){
                NSMutableArray* parray=[[NSMutableArray alloc] init];
                YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
                for(id p in pljson){
                    YKProduct* product=[pp parseFromJsonObj:p];
                    [parray addObject:product];
                }
                checkout.productList=parray;
            }
        }
        
        {//解析赠品
            id pljson=nil;
            YKGDS_DIC_OBJ(pljson, responseDataJson, @"giftList");
            if(pljson!=nil){
                NSMutableArray* parray=[[NSMutableArray alloc] init];
                YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
                for(id p in pljson){
                    YKProduct* product=[pp parseFromJsonObj:p];
                    [parray addObject:product];
                }
                checkout.presentList=parray;
            }
        }
        
        
        {//parse paycenterinfo
            id priceJson=nil;     YKGDS_DIC_OBJ(priceJson, responseDataJson, @"payCenterInfo");
            YKGDS_DIC_OBJ_STR(checkout.totalPrice, priceJson, @"totalPrice");
            YKGDS_DIC_OBJ_STR(checkout.dlyPrice, priceJson, @"dlyPrice");
            YKGDS_DIC_OBJ_STR(checkout.discountPrice, priceJson, @"couponPrice");
            YKGDS_DIC_OBJ_STR(checkout.totalPayablePrice, priceJson, @"totalPayablePrice");

            {//解析打折信息
                id discountJson=nil; YKGDS_DIC_OBJ(discountJson, priceJson, @"couponList");
                if(discountJson!=nil){
                    YKGDSDiscountListJsonParser* p=[[YKGDSDiscountListJsonParser alloc] init];
                    checkout.discountList=[p parseFromJsonObj:discountJson];
                }
            }
        
        }
        
        
        ret.responseObj=checkout;
    }
    return ret;
}



@end

@implementation YKGDSOrderResultJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    NSDictionary* responseData=nil;
    YKGDS_PARSE2(ret, jsonString, nil, responseData);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseData isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseData count]>0 ){
        assert(responseData!=nil);
        YKOrder* order=[[YKOrder alloc] init];
        ret.responseObj=order;
        YKGDS_DIC_OBJ_STR(order.orderId, responseData, @"orderId");
        YKGDS_DIC_OBJ_STR(order.orderPrice, responseData, @"orderPrice");
        order.payWay=[[YKPayWay alloc] init];
        YKGDS_DIC_OBJ_STR(order.payWay.name, responseData, @"payName");
        YKGDS_DIC_OBJ_STR(order.payMessage, responseData, @"payMsg");
        YKGDS_DIC_OBJ_STR(order.payUrl, responseData, @"payUrl");
        
    }
    return ret;
}

@end

@implementation YKGDSPayWayJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKPayWay* ret=[[YKPayWay alloc] init];
    YKGDS_DIC_OBJ_STR(ret.payId, obj, @"payId");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"payName");
    return ret;
}

@end


@implementation YKGDSSendTimeJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKSendTime* ret=[[YKSendTime alloc] init];
    YKGDS_DIC_OBJ_STR(ret.sendId, obj, @"sendId");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"sendName");
    return ret;
}

@end
@implementation YKGDSSendTimeListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKSendTimeList* ret=[[YKSendTimeList alloc] init];
    YKGDSSendTimeJsonParser* p=[[YKGDSSendTimeJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKSendTime* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end




@implementation YKGDSDiscountJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKDiscount* ret=[[YKDiscount alloc] init];
    YKGDS_DIC_OBJ_STR(ret.price, obj, @"price");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"name");
    return ret;
}

@end
@implementation YKGDSDiscountListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKDiscountList* ret=[[YKDiscountList alloc] init];
    YKGDSDiscountJsonParser* p=[[YKGDSDiscountJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKDiscount* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end

//{//解析打折信息
//    id discountJsonObj=nil;
//    YKGDS_DIC_OBJ(discountJsonObj, obj, @"couponList");
//    if(discountJsonObj!=nil && [discountJsonObj isKindOfClass:[NSArray class]]){
//        assert(discountJsonObj!=nil);
//        assert([discountJsonObj isKindOfClass:[NSArray class]]);
//        ret.discountList=[[YKDiscountList alloc] init];
//        for(id djson in discountJsonObj){
//            YKDiscount* d=[[YKDiscount alloc] init];
//            YKGDS_DIC_OBJ_STR(d.name, djson, @"name");
//            YKGDS_DIC_OBJ_STR(d.price, djson, @"price");
//            [ret.discountList addObject:d];
//        }
//    }
//}


@implementation YKGDSPayWayListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKPayWayList* ret=[[YKPayWayList alloc] init];
    YKGDSPayWayJsonParser* p=[[YKGDSPayWayJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKPayWay* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end



@implementation YKGDSDeliverJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKDeliver* ret=[[YKDeliver alloc] init];
    YKGDS_DIC_OBJ_STR(ret.deliverId, obj, @"dlyId");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"dlyName");
    return ret;
}

@end

@implementation YKGDSDeliverListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKDeliverList* ret=[[YKDeliverList alloc] init];
    YKGDSDeliverJsonParser* p=[[YKGDSDeliverJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKDeliver* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end




@implementation YKGDSInvoiceTypeJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKInvoiceType* ret=[[YKInvoiceType alloc] init];
    YKGDS_DIC_OBJ_STR(ret.invoiceId, obj, @"invoiceId");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"invoiceName");
    return ret;
}

@end

@implementation YKGDSInvoiceTypeListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKInvoiceTypeList* ret=[[YKInvoiceTypeList alloc] init];
    YKGDSInvoiceTypeJsonParser* p=[[YKGDSInvoiceTypeJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKInvoiceType* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end


@implementation YKGDSCustomerTypeJsonParser
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert(obj!=nil);
    YKCustomerType* ret=[[YKCustomerType alloc] init];
    YKGDS_DIC_OBJ_STR(ret.customerTypeId, obj, @"customerId");
    YKGDS_DIC_OBJ_STR(ret.name, obj, @"customerName");
    return ret;
}

@end

@implementation YKGDSCustomerTypeListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert(obj!=nil);
    YKCustomerTypeList* ret=[[YKCustomerTypeList alloc] init];
    YKGDSCustomerTypeJsonParser* p=[[YKGDSCustomerTypeJsonParser alloc] init];
    for(NSDictionary* sjson in obj){
        YKCustomerType* s=[p parseFromJsonObj:sjson];
        [ret addObject:s];
    }
    return ret;
}

@end




@implementation YKGDSOrderJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    NSDictionary* responseData=nil;
    YKGDS_PARSE2(ret, jsonString, nil, responseData);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseData isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseData count]>0 ){
        assert(responseData!=nil);
        YKOrder* order=[[YKOrder alloc] init];
        ret.responseObj=order;
        {
            id obj=[responseData objectForKey:@"orderInfo"];
            if(obj!=nil){
                YKGDS_DIC_OBJ_STR(order.orderId, obj, @"orderId");
                YKGDS_DIC_OBJ_STR(order.orderTime, obj, @"orderTime");
                //YKGDS_DIC_OBJ_STR(order.userId, obj, @"userId");
                YKGDS_DIC_OBJ_STR(order.orderPrice, obj, @"orderPrice");
                YKGDS_DIC_OBJ_STR(order.orderStatus, obj, @"orderStatus");
                YKGDS_DIC_OBJ_STR(order.canbeCancel, obj, @"canbeCancel");
                YKGDS_DIC_OBJ_STR(order.canbePay, obj, @"canbePay");
                YKGDS_DIC_OBJ_STR(order.payId, obj, @"payId");
                YKGDS_DIC_OBJ_STR(order.orderStatusCode, obj, @"orderStatusCode");
                YKGDS_DIC_OBJ_STR(order.isCancel, obj, @"isCancel");
                YKGDS_DIC_OBJ_STR(order.dlyStatus, obj, @"dlyStatus");
                YKGDS_DIC_OBJ_STR(order.payStatus, obj, @"payStatus");
                id isComment=nil;
                YKGDS_DIC_OBJ(isComment, obj, @"isComment");
                order.isComment=[isComment boolValue];
                
                {//payway
                    
                    order.payWay=[[YKPayWay alloc] init];
                    YKGDS_DIC_OBJ_STR(order.payWay.name, obj, @"payName");
                }
                {
                order.deliver=[[YKDeliver alloc] init];
                YKGDS_DIC_OBJ_STR(order.deliver.name, obj, @"dlyName");
                }
                
                id isAlipayObj=nil;
                YKGDS_DIC_OBJ(isAlipayObj, obj, @"isAlipay");
                order.isAlipay=[isAlipayObj boolValue];
                
                {//发票
                    id invoiceJson=[obj objectForKey:@"invoiceInfo"];
                    if(invoiceJson!=nil && [invoiceJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)invoiceJson count]>0){
                        YKGDS_DIC_OBJ_STR(order.invoiceTitle, invoiceJson, @"invoiceTitle");
                        YKGDS_DIC_OBJ_STR(order.customerName, invoiceJson, @"customerName");
                        YKGDS_DIC_OBJ_STR(order.invoiceTypeName, invoiceJson, @"invoiceName");
                    }
                }
            }
        }
        {
            id obj=[responseData objectForKey:@"summaryInfo"];
            if(obj!=nil){
                YKGDS_DIC_OBJ_STR(order.totalPrice, obj, @"totalPrice");
                //YKGDS_DIC_OBJ_STR(order.cartPrice, obj, @"cartPrice");
                YKGDS_DIC_OBJ_STR(order.orderPrice, obj, @"orderPrice");
                YKGDS_DIC_OBJ_STR(order.deliver.price, obj, @"dlyPrice");
            }
            
            {//解析打折信息
                YKGDS_DIC_OBJ_STR(order.discountPrice, obj, @"couponPrice");
                id couponListJson=[obj objectForKey:@"couponList"];
                YKGDSDiscountListJsonParser* p=[[YKGDSDiscountListJsonParser alloc] init];
                order.discountList=[p parseFromJsonObj:couponListJson];
            }
            
        }
        {//解析地址信息
            id addrJson=nil;
            YKGDS_DIC_OBJ(addrJson, responseData, @"addressInfo");
            if(addrJson!=nil){
                YKGDSAddressJsonParser* p=[[YKGDSAddressJsonParser alloc] init];
                order.address=[p parseFromJsonObj:addrJson];
            }
        }
        
        {//parse productList
            id obj=[responseData objectForKey:@"productList"];
            NSMutableArray* productArray=[[NSMutableArray alloc] init];
            order.productList=productArray;
            YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
            for(id pjson in obj){
                YKProduct* p=[pp parseFromJsonObj:pjson];
                [productArray addObject:p];
            }
            
        }
        
        order.payUrl=[responseData objectForKey:@"payUrl"];
    }
    return ret;
}

@end

@implementation YKGDSOrderListJsonParser

-(NSString *)responseObjKey{
    return @"orderList";
}
-(id)parseFromJsonObj:(NSArray *)obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert( [obj count]>0);
    YKOrderList* ret=[[YKOrderList alloc] init];
    //YKGDSOrderJsonParser* op=[[YKGDSOrderJsonParser alloc] init];
    for(id ojson in obj){
        YKOrder* o=[[YKOrder alloc] init];
        YKGDS_DIC_OBJ_STR(o.orderId, ojson, @"orderId");
        YKGDS_DIC_OBJ_STR(o.orderTime, ojson, @"orderTime");
        YKGDS_DIC_OBJ_STR(o.orderPrice, ojson, @"orderPrice");
        YKGDS_DIC_OBJ_STR(o.orderStatus, ojson, @"orderStatus");
        YKGDS_DIC_OBJ_STR(o.dlyStatus, ojson, @"dlyStatus");
        YKGDS_DIC_OBJ_STR(o.payStatus, ojson, @"payStatus");

        YKGDS_DIC_OBJ_STR(o.type, ojson, @"orderType");
        o.payWay=[[YKPayWay alloc] init];
        YKGDS_DIC_OBJ_STR(o.payWay.name, ojson, @"payName");
        YKGDS_DIC_OBJ_STR(o.orderStatusCode, ojson, @"orderStatusCode");
        YKGDS_DIC_OBJ_STR(o.canbePay, ojson, @"canbePay");
        YKGDS_DIC_OBJ_STR(o.canbeCancel, ojson, @"canbeCancel");
        YKGDS_DIC_OBJ_STR(o.isCancel, ojson, @"isCancel");
        
        
        [ret addObject:o];
    }
    return ret;
}

@end

@implementation YKGDSHomeJsonParser

-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,nil,responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKHome* home=[[YKHome alloc] init];
        ret.responseObj=home;
        assert(home!=nil);
        
        {//解析公告信息
            id pljson=[responseDataJson objectForKey:@"noticeList"];
            if(pljson!=nil){
                YKGDSNoticeListJsonParser* p=[[YKGDSNoticeListJsonParser alloc] init];
                home.noticeList=[p parseFromJsonObj:pljson];
            }
        }
        {//解析专题信息
            id pljson=[responseDataJson objectForKey:@"bannerList"];
            if(pljson!=nil){
                YKGDSTopicListJsonParser* p=[[YKGDSTopicListJsonParser alloc] init];
                home.topicList=[p parseFromJsonObj:pljson];
            }
        }
        
        {
            YKGDS_DIC_OBJ(home.htmlUrl, responseDataJson, @"homeUrl");
        }
        
    }
    return ret;
}

@end

@implementation YKGDSCartJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    id responseDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,@"cartInfo",responseDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responseDataJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)responseDataJson count]>0 ){
        YKCart* cart=ret.responseObj;
        assert(cart!=nil);
        assert([cart isMemberOfClass:[YKCart class]]);
        
        {//解析促销信息
            YKPromotionList* array=[[YKPromotionList alloc] init];
            cart.promotionList=array;
            id pljson=[responseDataJson objectForKey:@"couponInfo"];
            assert(pljson==nil || [pljson isKindOfClass:[NSArray class]]);
            for(id pjson in pljson){
                YKPromotion* p =[pjson description];
                //[pjson objectForKey:@"couponMsg"];
                [array addObject:p];
            }
        }
        
        {//parse prductList
            NSMutableArray* array=[[NSMutableArray alloc] init];
            cart.productList=array;
            YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
            id pljson=[responseDataJson objectForKey:@"productList"];
            for(id pjson in pljson){
                YKProduct* p=[pp parseFromJsonObj:pjson];
                [array addObject:p];
            }
        }
        
        {//解析赠品列表
            YKPresentList* array=[[YKPresentList alloc] init];
            cart.presentList=array;
            YKGDSProductJsonParser* pp=[[YKGDSProductJsonParser alloc] init];
            id pljson=[responseDataJson objectForKey:@"giftList"];
            for(id pjson in pljson){
                YKProduct* p=[pp parseFromJsonObj:pjson];
                [array addObject:p];
            }
        }
    }
    return ret;
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    YKCart* ret=[[YKCart alloc] init];
    YKGDS_DIC_OBJ_STR(ret.number, obj, @"number");
    YKGDS_DIC_OBJ_STR(ret.totalMarketPrice, obj, @"totalMarketPrice");
    YKGDS_DIC_OBJ_STR(ret.totalSalePrice, obj, @"totalSalePrice");
//    YKGDS_DIC_OBJ_STR(ret.totalPayablePrice, obj, @"totalPayablePrice");
    YKGDS_DIC_OBJ_STR(ret.totalDiscountPrice, obj, @"couponPrice");
    YKGDS_DIC_OBJ_STR(ret.checkoutPrice, obj, @"checkoutPrice");
    
    {//解析打折信息
        id discountJson=nil; YKGDS_DIC_OBJ(discountJson, obj, @"couponList");
        if(discountJson!=nil){
            YKGDSDiscountListJsonParser* p=[[YKGDSDiscountListJsonParser alloc] init];
            ret.discountList=[p parseFromJsonObj:discountJson];
        }
    }
//    
//    {//解析打折信息
//        id discountJsonObj=nil;
//        YKGDS_DIC_OBJ(discountJsonObj, obj, @"couponList");
//        if(discountJsonObj!=nil && [discountJsonObj isKindOfClass:[NSArray class]]){
//        assert(discountJsonObj!=nil);
//        assert([discountJsonObj isKindOfClass:[NSArray class]]);
//        ret.discountList=[[YKDiscountList alloc] init];
//        for(id djson in discountJsonObj){
//            YKDiscount* d=[[YKDiscount alloc] init];
//            YKGDS_DIC_OBJ_STR(d.name, djson, @"name");
//            YKGDS_DIC_OBJ_STR(d.price, djson, @"price");
//            [ret.discountList addObject:d];
//        }
//        }
//    }
    
    return ret;
}

@end
//

@implementation YKGDSSecKillJsonParser
-(YKProduct*)parseFromJsonObj:(NSDictionary*) obj{
    YKSecKill* ret=[[YKSecKill alloc] init];
    [self parseTarget:ret fromJsonObj:obj];
    YKGDS_DIC_OBJ_STR(ret.endTime, obj, @"endTime");
    YKGDS_DIC_OBJ_STR(ret.startTime, obj, @"startTime");
    return ret;
}
@end


//@implementation YKGDSSecKillListJsonParser
//-(NSString *)responseObjKey{
//    return @"skillList";
//}
//-(id)parseFromJsonObj:(NSArray *)obj{
//    YKSecKillList* list=[[YKSecKillList alloc] init];
//    YKGDSSecKillJsonParser* p=[[YKGDSSecKillJsonParser alloc] init];
//    for(id sjson in obj){
//        YKSecKill* k=[p parseFromJsonObj:sjson];
//        YKGDS_DIC_OBJ_STR(k.secKillId, sjson, @"id");
//        [list addObject:k];
//    }
//    return list;
//}
//@end
//

@implementation YKGDSGroupJsonParser
-(YKProduct*)parseFromJsonObj:(NSDictionary*) obj{
    YKGroup* ret=[[YKGroup alloc] init];
    [self parseTarget:ret fromJsonObj:obj];
    YKGDS_DIC_OBJ_STR(ret.endTime, obj, @"endTime");
    YKGDS_DIC_OBJ_STR(ret.startTime, obj, @"startTime");
    return ret;
}
@end

//
//@implementation YKGDSGroupJsonParser
//-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
//    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
//    id responseObjJson=nil;
//    YKGDS_PARSE2(ret, jsonString, nil, responseObjJson);
//    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result]){
//        YKGroup* g=[self parseFromJsonObj:responseObjJson];
//        ret.responseObj=g;
//    }
//    return ret;
//}
//-(id)parseFromJsonObj:(NSDictionary *)dic{
//    assert(dic!=nil);
//    assert([dic isKindOfClass:[NSDictionary class]] && [dic count]>0);
//    YKGroup* ret=[[YKGroup alloc] init];
//    YKGDS_DIC_OBJ_STR(ret.groupId, dic, @"groupId");
//    YKGDS_DIC_OBJ_STR(ret.type, dic, @"type");
//    YKGDS_DIC_OBJ_STR(ret.content, dic, @"content");
//    YKGDS_DIC_OBJ_STR(ret.imageUrl, dic, @"imageUrl");
//    YKGDS_DIC_OBJ_STR(ret.satisfyNumber, dic, @"satisfyNumber");
//    YKGDS_DIC_OBJ_STR(ret.startTime, dic, @"startTime");
//    YKGDS_DIC_OBJ_STR(ret.endTime, dic, @"endTime");
//    
//    YKGDS_DIC_OBJ_STR(ret.grouponTitle, dic, @"grouponTitle");
//    YKGDS_DIC_OBJ_STR(ret.needNumber, dic, @"needNumber");
//    YKGDS_DIC_OBJ_STR(ret.leftNumber, dic, @"leftNumber");
//    YKGDS_DIC_OBJ_STR(ret.productId, dic, @"productId");
//    YKGDS_DIC_OBJ_STR(ret.sku, dic, @"sku");
//    YKGDS_DIC_OBJ_STR(ret.categoryId, dic, @"categoryId");
//    YKGDS_DIC_OBJ_STR(ret.pattern, dic, @"pattern");
//    YKGDS_DIC_OBJ_STR(ret.colorName, dic, @"colorName");
//    YKGDS_DIC_OBJ_STR(ret.sizeId, dic, @"sizeId");
//    YKGDS_DIC_OBJ_STR(ret.sizeName, dic, @"sizeName");
//    YKGDS_DIC_OBJ_STR(ret.productType, dic, @"productType");
//    YKGDS_DIC_OBJ_STR(ret.productName, dic, @"productName");
//    YKGDS_DIC_OBJ_STR(ret.productDesc, dic, @"productDesc");
//    YKGDS_DIC_OBJ_STR(ret.colorUrl, dic, @"colorUrl");
//    YKGDS_DIC_OBJ_STR(ret.marketPrice, dic, @"marketPrice");
//    YKGDS_DIC_OBJ_STR(ret.salePrice, dic, @"salePrice");
//    YKGDS_DIC_OBJ_STR(ret.grouponPrice, dic, @"grouponPrice");
////    YKGDS_DIC_OBJ_STR(ret.imageList, dic, @"imageList");
//    {//parse image list
//        NSArray* imgListJson=nil;
//        YKGDS_DIC_OBJ(imgListJson, dic, @"imageList");
//        if(imgListJson!=nil){
//            ret.imageList=[[YKImageList alloc] init];
//            for(id img in imgListJson){
//                [ret.imageList addObject:[img description]];
//            }
//        }
//    }
//
//    
//    return ret;
//}
//@end
//
//@implementation YKGDSGroupListJsonParser
//-(NSString *)responseObjKey{
//    return @"grouponList";
//}
//-(id)parseFromJsonObj:(NSArray *)obj{
//    YKGroupList* list=[[YKGroupList alloc] init];
//    YKGDSGroupJsonParser* p=[[YKGDSGroupJsonParser alloc] init];
//    for(id sjson in obj){
//        YKGroup* k=[p parseFromJsonObj:sjson];
//        YKGDS_DIC_OBJ_STR(k.groupId, sjson, @"id");
//        [list addObject:k];
//    }
//    return list;
//}
//
//@end


@implementation YKGDSLotteryJsonParser
-(YKLottery*)parseFromJsonObj:(NSDictionary*) obj{
    YKLottery* ret=[[YKLottery alloc] init];
    [self parseTarget:ret fromJsonObj:obj];
    YKGDS_DIC_OBJ_STR(ret.endTime, obj, @"endTime");
    YKGDS_DIC_OBJ_STR(ret.startTime, obj, @"startTime");
    YKGDS_DIC_OBJ_STR(ret.title, obj, @"title");
    YKGDS_DIC_OBJ_STR(ret.infoUrl, obj, @"infoUrl");
    YKGDS_DIC_OBJ_STR(ret.hasInfo, obj, @"hasInfo");
    
    id addressJson=nil;
    YKGDS_DIC_OBJ(addressJson, obj, @"addressInfo");
    if(addressJson!=nil && [addressJson isKindOfClass:[NSDictionary class]] && [(NSDictionary*)addressJson count]>0){
        YKGDSAddressJsonParser* p=[[YKGDSAddressJsonParser alloc] init];
        ret.address= [p parseFromJsonObj:addressJson];
    }
    return ret;
}
@end


@implementation YKGDSLotteryResultJsonParser
-(YKGDSResponse *)parseFromJson:(NSString *)jsonString{
    YKGDSResponse* ret=[[YKGDSResponse alloc] init];
    NSDictionary* responeDataJson=nil;
    YKGDS_PARSE2(ret,jsonString,nil,responeDataJson);
    if([YKGDS_VALUE_RESULT_OK isEqualToString:ret.result] && [responeDataJson isKindOfClass:[NSDictionary class]] && [responeDataJson count]>0 ){
        YKLotteryResult* result=[[YKLotteryResult alloc] init];
        YKGDS_DIC_OBJ_STR(result.orderId, responeDataJson, @"orderId");
        YKGDS_DIC_OBJ_STR(result.payMsg, responeDataJson, @"payMsg");
        YKGDS_DIC_OBJ_STR(result.result, responeDataJson, @"lotteryResult");
        ret.responseObj=result;
    }
    return ret;
}
@end



@implementation YKGDSBrandJsonParser
-(NSString *)responseObjKey{
    return @"brandInfo";
}
-(YKBrand*)parseFromJsonObj:(NSDictionary*) obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    YKBrand* ret=[[YKBrand alloc] init];
    YKGDS_DIC_OBJ_STR(ret.brandId, obj, @"brandId");
    YKGDS_DIC_OBJ_STR(ret.title, obj, @"title");
    YKGDS_DIC_OBJ_STR(ret.content, obj, @"content");
    YKGDS_DIC_OBJ_STR(ret.imageUrl, obj, @"imageUrl");
    id hasInfo=nil;
    YKGDS_DIC_OBJ(hasInfo, obj, @"hasInfo");
    if(hasInfo!=nil){
        ret.hasInfo=[hasInfo boolValue];
    }
    YKGDS_DIC_OBJ_STR(ret.infoUrl, obj, @"infoUrl");
    return ret;
}

@end
@implementation YKGDSBrandListJsonParser
-(NSString *)responseObjKey{
    return @"brandInfo";
}
-(YKBrandList*)parseFromJsonObj:(NSArray*) obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    YKBrandList* ret=[[YKBrandList alloc] init];
    YKGDSBrandJsonParser* p=[[YKGDSBrandJsonParser alloc] init];
    for(id ad in obj){
        YKBrand* address=[p parseFromJsonObj:ad];
        [ret addObject:address];
    }
    return ret;
}
@end

//@implementation YKGDSActivityJsonParser
//@end



@implementation YKGDSNoticeJsonParser
-(NSString *)responseObjKey{
    return @"noticeInfo";
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    YKNotice* ret=[[YKNotice alloc] init];
    YKGDS_DIC_OBJ_STR(ret.noticeId, obj, @"id");
    YKGDS_DIC_OBJ_STR(ret.title, obj, @"title");
    YKGDS_DIC_OBJ_STR(ret.content, obj, @"content");
    YKGDS_DIC_OBJ_STR(ret.imageUrl, obj, @"imageUrl");
    YKGDS_DIC_OBJ_STR(ret.time, obj, @"time");
    YKGDS_DIC_OBJ_STR(ret.actionUrl, obj, @"href");

    return ret;
}
@end

@implementation YKGDSNoticeListJsonParser
-(NSString *)responseObjKey{
    return @"noticeList";
}
-(id)parseFromJsonObj:(NSArray *)obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    YKNoticeList* ret=[[YKNoticeList alloc] init];
    YKGDSNoticeJsonParser* p=[[YKGDSNoticeJsonParser alloc] init];
    for(id njson in obj){
        YKNotice* n=[p parseFromJsonObj:njson];
        [ret addObject:n];
    }
    return ret;
}
@end



@implementation YKGDSTopicJsonParser
-(NSString *)responseObjKey{
    assert(NO);
    return nil;
}
-(id)parseFromJsonObj:(NSDictionary *)obj{
    assert([obj isKindOfClass:[NSDictionary class]] ); //objtest assert([obj count]>0);
    YKTopic* ret=[[YKTopic alloc] init];
    YKGDS_DIC_OBJ_STR(ret.topicId, obj, @"id");
    YKGDS_DIC_OBJ_STR(ret.imageUrl, obj, @"imageUrl");
    YKGDS_DIC_OBJ_STR(ret.actionUrl, obj, @"href");
    YKGDS_DIC_OBJ_STR(ret.title, obj, @"title");
    return ret;
}
@end

@implementation YKGDSTopicListJsonParser
-(id)parseFromJsonObj:(NSArray *)obj{
    assert([obj isKindOfClass:[NSArray class]] ); //objtest assert([obj count]>0);
    YKTopicList* ret=[[YKTopicList alloc] init];
    YKGDSTopicJsonParser* p=[[YKGDSTopicJsonParser alloc] init];
    for(id njson in obj){
        YKTopic* n=[p parseFromJsonObj:njson];
        [ret addObject:n];
    }
    return ret;
}
@end


@implementation YKGDSHelpJsonParser
@end

@implementation YKGDSUpdateJsonParser
-(NSString *)responseObjKey{
    return @"versionInfo";
}
-(id)parseFromJsonObj:(id)obj{
    assert([obj isKindOfClass:[NSDictionary class]]); assert([(NSDictionary*)obj count]>0);
    YKUpdate* ret=[[YKUpdate alloc] init];
    YKGDS_DIC_OBJ_STR(ret.currentVersion, obj, @"currentVersion");
    YKGDS_DIC_OBJ_STR(ret.newestVersion, obj, @"newestVersion");
    YKGDS_DIC_OBJ_STR(ret.isNeedUpdate, obj, @"isNeedUpdate");
    YKGDS_DIC_OBJ_STR(ret.updateType, obj, @"updateType");
    YKGDS_DIC_OBJ_STR(ret.updateUrl, obj, @"updateURL");
    YKGDS_DIC_OBJ_STR(ret.updateMessage, obj, @"updateMessage");
    return ret;
    
}

@end











