/*!
//
//  YKGDSFacade.h
//  YKGeneralDataSourceModule
//
//  Created by TFH on 13-3-27.
//  Copyright (c) 2013年 YEK. All rights reserved.
//
 --------
 本模块用于
*/
#import <Foundation/Foundation.h>
#import "YKBaseModel.h"

#define YKGDSStringOrEmpty(str) (str==nil?@"":str)

#define YKGDS_ERROR_DOMAIN @"me.yek.generaldatasource"
/*! 网络出错 */
#define YKGDS_NETWORK_ERROR_DOMAIN @"me.yek.generaldatasource.network"

/*! 服务端错误 */
#define YKGDS_SERVER_ERROR_DOMAIN @"me.yek.generaldatasource.server"

/*! 解析json 出现异常 */
#define YKGDS_ERROR_CODE_PARSE_EXCEPTION 1000

/*! 服务端返回数据无效 */
#define YKGDS_ERROR_CODE_INVALID_RESPONSE_EXCEPTION 1001
#define YKGDS_EXCEPTION_PARSE_JSON @"YKGDS_EXCEPTION_PARSE_JSON"
#define YKGDS_EXCEPTION_PARSE_NO_ELEMENT @"YKGDS_EXCEPTION_PARSE_NO_ELEMENT"



#define YKGDS_KEY_RESULT @"result"
#define YKGDS_KEY_MESSAGE @"message"
#define YKGDS_KEY_RESONSE_DATA @"responseData"
#define YKGDS_VALUE_RESULT_OK @"0"

#define YKGDS_KEY_USERNAME @"username"
#define YKGDS_KEY_USERID @"userId"
#define YKGDS_KEY_PASSWORD @"password"

#define YKGDS_KEY_ADDRESS_ID @"addressId"


#pragma mark 通知
/*! 登陆／注册成功会发送此事件 notify.userinfo["user"] 是 YKUser */
#define YK_NOTIFICATION_LOGIN @"YK_NOTIFICATION_LOGIN"
#define YK_NOTIFICATION_LOGOUT @"YK_NOTIFICATION_LOGOUT"

/*!
 @author sihai fix by dacaiguoguo
 */



@interface YKGDSResponse : NSObject
@property (strong) NSString* result;
@property (strong) NSString* message;
@property (strong) id responseObj;
@end

@interface YKGDSError : NSObject
@end

@protocol YKGDSJsonParser <NSObject>
-(YKGDSResponse*) parseFromJson:(NSString*) jsonString;
@optional
-(id)parseFromJsonObj:(id) obj;
@end

/*!
 解析 result message 不解析 responseData
 */
@interface YKGDSBaseJsonParser : NSObject<YKGDSJsonParser>

@property(strong) id responseDataJson; /*!< 对应报文中的 response */
@property(strong) id jsonObj; /*!< 对应报文中的 response */

-(NSString*)responseObjKey;

@end


/*!
 解析 result message 不解析 responseData
 */
@interface YKGDSResponseJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end

@interface YKGDSUserJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end

@interface YKGDSLoginUserJsonParser : YKGDSUserJsonParser
@end
typedef YKGDSLoginUserJsonParser YKGDSRegisterUserJsonParser;

@interface YKGDSProductJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end
@interface YKGDSCommentJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end
@interface YKGDSCommentListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end

@interface YKGDSProductSizeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSProductColorJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSProductListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSFavoriteListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

/*! product array parse */
@interface YKGDSProductArrayJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end



@interface YKGDSCategoryJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSBrandCategoryJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSKeywordJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end
@interface YKGDSKeywordListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end


@interface YKGDSAddressModifyResponseJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSAddressJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSAddressListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSPayWayJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSSendTimeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSPayWayListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSSendTimeListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSDeliverJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSDeliverListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSInvoiceTypeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSInvoiceTypeListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSCustomerTypeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSCustomerTypeListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSDiscountJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSDiscountListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end


@interface YKGDSCheckoutJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end
/*! 下单结果 */
@interface YKGDSOrderResultJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end



@interface YKGDSOrderJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSOrderListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSHomeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end


@interface YKGDSCartJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
typedef YKGDSCartJsonParser YKGDSGiftAddJsonParser;

@interface YKGDSSecKillJsonParser : YKGDSProductJsonParser<YKGDSJsonParser>
@end

@interface YKGDSGroupJsonParser : YKGDSProductJsonParser<YKGDSJsonParser>
@end
@interface YKGDSLotteryJsonParser : YKGDSProductJsonParser<YKGDSJsonParser>
@end

@interface YKGDSLotteryResultJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>

@end

@interface YKGDSBrandJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSBrandListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSNoticeJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSNoticeListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSTopicJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end
@interface YKGDSTopicListJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSHelpJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end

@interface YKGDSUpdateJsonParser : YKGDSBaseJsonParser<YKGDSJsonParser>
@end








