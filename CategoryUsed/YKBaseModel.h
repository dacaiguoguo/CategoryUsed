//
//  YKBaseModel.h
//  YKModule
//
//  Created by TFH on 13-4-1.
//  Copyright (c) 2013年 YEK. All rights reserved.
//



//Mark arc ??
#ifndef PX_STRONG

#if __has_feature(objc_arc)

#define PX_STRONG strong

#else

#define PX_STRONG retain

#endif

#endif

//Weak

#ifndef PX_WEAK

#if __has_feature(objc_arc_weak)

#define PX_WEAK weak

#elif __has_feature(objc_arc)

#define PX_WEAK unsafe_unretained

#else

#define PX_WEAK assign

#endif

#endif

//Release AutoRelease Retain
#if __has_feature(objc_arc)

#define PX_AUTORELEASE(expression) expression

#define PX_RELEASE(expression) expression

#define PX_RETAIN(expression) expression

#else

#define PX_AUTORELEASE(expression) [expression autorelease]

#define PX_RELEASE(expression) [expression release]

#define PX_RETAIN(expression) [expression retain]

#endif





#import <Foundation/Foundation.h>



@interface YKEntity : NSObject
-(void) setAttributeValue:(NSString*) v forKey:(NSString*) akey;
-(NSString*) attributeValueForKey:(NSString*) akey;

@end



/*!
 尺寸
 */
@interface YKProductSize : YKEntity
@property (strong) NSString* sizeId;
@property (strong) NSString* sizeName;
@property (strong) NSString* sku;

/*! 库存 */
@property (strong) NSString* stock;

/*!  */
@property (strong) NSString* marketPrice;
@property (strong) NSString* salePrice;
@end

typedef NSMutableArray YKProductSizeList;
typedef NSMutableArray YKImageList;

/*!
 花色
 */
@interface YKProductColor : YKEntity
@property (strong) NSString* colorId;
@property (strong) NSString* colorName;
@property (strong) NSString* colorUrl;
@property (strong) NSString* marketPrice;
@property (strong) NSString* salePrice;
@property (strong) YKImageList* imageList;
@property (strong) YKImageList* bigImageList;

/*! 商品该颜色下有哪些尺码 */
@property (strong) YKProductSizeList* sizeList;


@end

typedef NSMutableArray YKProductColorList;


@class YKProductAdd;
@protocol YKProductAddDelegate <NSObject>

- (void)computerFinished;

@end

/*!
 商品
 */
@interface YKProduct  : YKEntity

/*! 商品id */
@property (strong) NSString* productId;
@property (strong) NSString* type;

/*! 商品图片地址 */
@property (strong) NSString* imageUrl;
@property (strong) NSString* gridUrl; //??

/*! 市场价格 */
@property (strong) NSString* marketPrice;

/*! 价格 */
@property (strong) NSString* salePrice;

/*! 单价x数量 */
@property (strong) NSString* totalPrice;

/*! 商品所属分类id */
@property(strong) NSString* categoryId;

/*! 商品所属品牌d */
@property(strong) NSString* brandId;

/*! ?? */
@property(strong) NSString* pattern;

/*! 商品名称 */
@property(strong) NSString* name;

/*! 商品描述网址 */
@property(strong) NSString* desc;

/*! 商品尺码详情表描述 */
@property(strong) NSString* sizeTableUrl;



/*! 花色详情 */
@property(strong) YKProductColorList* colorList;



/*! 数量 */
@property(strong) NSString* count;
/*! sku */
@property(strong) NSString* sku;
/*! 尺码 */
@property(strong) NSString* sizeName;
/*! 花色 */
@property(strong) NSString* colorName;

/*! 此赠品是否已经领取 */
@property BOOL isGet;

//=================================================================================
//=================添加的方法，为了方便使用============================================
//=================================================================================

@property (nonatomic, assign) id<YKProductAddDelegate> delegate;

//@property (nonatomic, retain) YKProduct *refP;

//是否所有color 下的size 的stock都为0 那就都卖完了
@property BOOL isOffSale;

//第一个选择的颜色，即颜色下有尺码的库存不空的情况，就选中它
@property int firstSelectColor;

//第一个选择的尺码的数组，即NSNumber [firstSelectSizeArray objectAtIndex:N].intValue 为第N个Color下的第一个可以选择的颜色
@property  (nonatomic, strong) NSArray * firstSelectSizeArray;

//颜色标签的frame 数组 [rectArrayColor objectAtIndex:N].rectValue 为第N个颜色的Frame;
@property  (nonatomic, strong) NSArray *rectArrayColor;

//color Name array
@property  (nonatomic, strong) NSArray *productColorNameArray;

//size Name array total
@property  (nonatomic, strong) NSArray *productSizeNameArrayTotal;

//所有颜色下的所有的尺码标签的 frame 数组
@property  (nonatomic, strong) NSArray *rectArraySizeTotal;


//取得 第 个color的 第 个size的 salePrice
- (NSString *)salePriceInColor:(int)colorIdx sizeIndex:(int)sizeIdx;

//取得 第 个color的 第 个size的 marketPrice
- (NSString *)marketPriceInColor:(int)colorIdx sizeIndex:(int)sizeIdx;

//取得第 个颜色下的图片数组
- (NSArray *)productImagesNameArrayAtIndex:(int)idx;

//取得第 个颜色下的大图图片数组
- (NSArray *)productBigImagesNameArrayAtIndex:(int)idx;

//对数据进行重新计算，完成后会调用delegate 的方法
- (void)computer;



@end


/*! 首页的专题 */
@interface YKTopic  : YKEntity
@property(strong) NSString* topicId;
@property(strong) NSString* imageUrl;
@property(strong) NSString* title;
@property(strong) NSString* actionUrl;
@end
typedef NSMutableArray YKTopicList;


/*!
 公告
 */
@interface YKNotice : YKEntity

/*! 公告id */
@property (strong) NSString* noticeId;

/*! 公告标题 */
@property (strong) NSString* title;

/*! 公告内容 */
@property (strong) NSString* content;

/*! 公告图片 */
@property (strong) NSString* imageUrl;

/*! 公告时间 */
@property (strong) NSString* time;

/*! 点击跳转到商品列表的链接*/
@property(strong) NSString* actionUrl;

@end
typedef NSMutableArray YKNoticeList;


/*!
 首页 TODO:EXT
 */
@interface YKHome  : YKEntity
@property(strong) YKNoticeList* noticeList;
@property(strong) YKTopicList* topicList;
@property(strong) NSString* htmlUrl;
@end

/*! 打折优惠信息 */
@interface YKDiscount : YKEntity
@property(strong) NSString* name;
@property(strong) NSString* price;
@end

typedef NSMutableArray YKDiscountList;

/*! 促销信息 */
typedef NSString YKPromotion;
typedef NSMutableArray YKPromotionList;

/*! 赠品 */
typedef YKProduct YKPresent;
typedef NSMutableArray YKPresentList;


/*! 商品评论 */
@interface YKComment : YKEntity
/*! 评论id */
@property(strong) NSString* commentId;

/*! 评分 */
@property(strong) NSString* score;

/*! 评论人 */
@property(strong) NSString* username;

/*! 评论内容 */
@property(strong) NSString* content;
/*! 发表评论时间 */
@property(strong) NSString* time;
@end
/*! 评论列表 */


@interface  YKCommentList :YKEntity
@property int totalCount;

-(NSUInteger) count;
-(YKComment*) objectAtIndex:(NSUInteger) aindex;
-(void)addObject:(YKComment*) comment;

@end


/*! 分类列表 */
typedef NSMutableArray YKCategoryList;

/*! 分类 */
@interface YKCategory  : YKEntity

/*! 分类id */
@property (strong) NSString* cid;

/*! 分类名称 */
@property (strong) NSString* name;

/*! 分类图片网址 */
@property (strong) NSString* catIcon;

/*! 子分类 YKCategory 数组 */
@property (strong) YKCategoryList* subCategory;
@end


/*! 筛选选项，如：红色、蓝色、裤子、衣服 */
@interface YKFilterOption : YKEntity
/*! 显示的文字 */
@property(strong) NSString* text;
/*! 回传给服务端的值 */
@property(strong) NSString* value;

@end
typedef NSMutableArray YKFilterOptionList;

/*!
 筛选条件，包含多个筛选选项
 */
@interface YKFilter : YKEntity
/*! 显示的文字，如：分类、花色、尺码、价格 */
@property(strong) NSString* name;
/*! 筛选选项，如：红色、蓝色、裤子、衣服   array of YKFilterOption */
@property(strong) YKFilterOptionList* optionList;
@end

typedef NSMutableArray YKFilterList;



/*! 商品列表 */
@interface YKProductList : YKEntity
/*! 服务端总共有多少条数据 */
@property (assign) int totalCount;

@property(strong) YKFilterList* filterList;

/*!  */
@property (assign) BOOL hasInfo;

/*! 说明信息? */
@property (strong) NSString* infoUrl;


/*! 目前在列表中已经有多少条数据 */
-(NSUInteger) count;

/*!  */
-(YKProduct*) objectAtIndex:(NSUInteger) aindex;
-(void) addObject:(YKProduct*) aobj;


@property(strong) NSString* title;

@end


/*!
 地址
 */
@interface YKAddress  : YKEntity

/*! 地址id */
@property (strong) NSString* addressId;

/*! 收货人姓名 */
@property (strong) NSString* receiverName;

/*! 省id */
@property (strong) NSString* provinceId;

/*! 省名称 */
@property (strong) NSString* provinceName;

/*! 市id */
@property (strong) NSString* cityId;

/*! 市名 */
@property (strong) NSString* cityName;

/*! 区/县id */
@property (strong) NSString* areaId;

/*! 区/县 名称 */
@property (strong) NSString* areaName;

/*! 详细街道地址 */
@property (strong) NSString* streetDetail; /*!< 街道地址 */

/*! 邮编 */
@property (strong) NSString* zipCode;

/*! 手机号 */
@property (strong) NSString* mobile;

/*! 固定电话 */
@property (strong) NSString* phone;

/*! email */
@property (strong) NSString* email;

/*! 是否为默认地址 */
@property (strong) NSString* isDefault;

@end

typedef NSMutableArray YKAddressList;


/*!
 支付方式
 */
@interface YKPayWay : YKEntity
@property(strong) NSString* payId;
@property(strong) NSString* name;

@end
typedef NSMutableArray YKPayWayList;


/*!
 送货时间
 */
@interface YKSendTime : YKEntity
@property(strong) NSString* sendId;
@property(strong) NSString* name;

@end
typedef NSMutableArray YKSendTimeList;

/*!
 送货方式
 */
@interface YKDeliver : YKEntity
@property(strong) NSString* deliverId; 
@property(strong) NSString* name;
@property(strong) NSString* price;
@property(strong) NSString* statu;

@end

typedef NSMutableArray YKDeliverList;

/*! 发票类型  */
@interface YKInvoiceType: YKEntity
@property(strong) NSString* invoiceId;
@property(strong) NSString* name;
@end

/*! 发票类型列表 */
typedef NSMutableArray YKInvoiceTypeList;



/*! 发票客户类型  */
@interface YKCustomerType: YKEntity
@property(strong) NSString* customerTypeId;
@property(strong) NSString* name;
@end

/*! 发票类型列表 */
typedef NSMutableArray YKCustomerTypeList;




/*! 结算中心 下单选项 */
@interface YKCheckout : YKEntity

/*! 打折优惠减免信息 */
@property(strong) YKDiscountList* discountList;

/*! 支付方式候选列表 */
@property(strong) YKPayWayList* payWayList;

/*! 送货时间候选列表 */
@property(strong) YKSendTimeList* sendTimeList;

/*! 送货方式候选列表 */
@property(strong) YKDeliverList* deliverList;

/*! 发票抬头 */
@property (strong) NSString* invoiceTitle;

/*! 发票类型方式候选列表 服装、办公用品…… */
@property(strong) YKInvoiceTypeList* invoiceTypeList;

/*! 发票客户类型候选列表 个人、公司…… */
@property(strong) YKCustomerTypeList* customerTypeList;


/*! 地址候选列表 */
@property(strong) YKAddress* defaultAddress;

/*! 商品列表列表 */
@property(strong) NSMutableArray* productList;

/*! 赠品列表 */
@property(strong) YKPresentList* presentList;

/*! 商品价格总计，未计算打折减免 */
@property (strong) NSString* totalPrice;

///*! 快递费用 */
@property (strong) NSString* dlyPrice;

/*! 优惠费用 */
@property (strong) NSString* discountPrice;

/*! 总共应支付金额？ */
@property (strong) NSString* totalPayablePrice;

@end


/*!
 订单
 
 orderInfo:订单信息
 orderId:订单号
 orderTime:下单时间
 userId:用户ID
 orderStatus:订单状态
 0:未确认，1:已确认，2:已完成，3:已取消
 canbeCancel:是否可取消订单
 0：不可，1：可以
 payId:支付方式
 0:货到付款，1:支付宝
 payStatus:支付状态
 0:未支付，1:已付款
 dlyId:物流ID
 dlyName:物流公司
 dlyStatus:物流状态
 0:未配送，1:配送中，2:已送达
 addressInfo:地址信息
 addressId:地址ID
 receiverName:收货人
 provinceId:省ID
 provinceName:省
 cityId:市ID
 cityName:市
 areaId:区ID
 areaName:区
 address:详细地址
 zipCode:邮政编码
 mobile:手机
 phone:固话
 
 productList:订单商品信息
 productSku:商品SKU
 productType:商品类型
 productName:商品名称
 marketPrice:市场价
 salePrice:骆驼价
 imageUrl:商品图片
 
 summaryInfo:订单结算信息
 cartPrice:购物车价格
 orderPrice:订单额
 dlyPrice:运费
 */
@interface YKOrder  : YKEntity

/*! 订单号  */
@property (strong) NSString* orderId;

/*! 下单时间  */
@property (strong) NSString* orderTime;

/*! 
 订单类型
 0：普通订单
 1：秒杀订单
 2：团购订单
 3：抽奖订单  
 */
@property (strong) NSString* type;



/*! 用户id  */
@property (strong) NSString* userId;

/*! 订单状态   */
@property (strong) NSString* orderStatus;
/*! 订单状态编码   */
@property (strong) NSString* orderStatusCode;

/*! dlyStatus 发货状态   */
@property (strong) NSString* dlyStatus;

/*! 是否可以取消  */
@property (strong) NSString* canbeCancel;
/*! 是否可以取消  */
@property (strong) NSString* canbePay;
/*!   */
@property (strong) NSString* isCancel;


/*! 支付id? 在线支付？  */
@property (strong) NSString* payId;

/*! 支付状态  */
@property (strong) NSString* payStatus;


/*! 支付网址  */
@property (strong) NSString* payUrl;

@property BOOL isAlipay;

///*! 送货方式id */
//@property (strong) NSString* dlyId;

/*! 送货信息  */
@property (strong) YKDeliver* deliver;

/*! 总价？  */
@property (strong) NSString* totalPrice;

/*! 支付方式   */
@property (strong) YKPayWay* payWay;

/*! 送货时间  */
@property (strong) YKSendTime* sendTime;

/*! 收货地址  */
@property (strong) YKAddress* address;

/*!  发票抬头 */
@property (strong) NSString* invoiceTitle;

/*! 发票类型  */
@property (strong) NSString* invoiceTypeName;

/*! 客户类型  */
@property (strong) NSString* customerName;

/*! 打折信息 */
@property(strong) YKDiscountList* discountList;

/*! 商品列表  */
@property (strong) NSMutableArray* productList;

/*! 打折价格  */
@property (strong) NSString* discountPrice;



///*! 购物车价格  */
//@property (strong) NSString* cartPrice;

/*! 订单价格  */
@property (strong) NSString* orderPrice;

/*! 下单成功提示  */
@property (strong) NSString* payMessage;


@property BOOL isComment;

@end

typedef NSMutableArray  YKOrderList;
/*!
 购物车
 */
@interface YKCart  : YKEntity

/*! 总共多少件商品 */
@property (strong) NSString* number;

/*! 市场价总共多少 */
@property (strong) NSString* totalMarketPrice;

/*! 本店价总共多少 */
@property (strong) NSString* totalSalePrice;

//@property (strong) NSString* totalPayablePrice;

/*! 购买所有这些商品扣减折扣外用户需要支付金额 */
@property (strong) NSString* checkoutPrice;

/*! 打折多少钱，总共享受优惠多少钱 */
@property (strong) NSString* totalDiscountPrice;

/*! 打折信息，已享受优惠列表 全场满300减50 */
@property(strong) YKDiscountList* discountList;

/*! 购物车中的商品列表，YKProduct数组 */
@property(strong) NSMutableArray* productList;

/*! 促销信息， NSString 数组  再消费15元即可减60  */
@property(strong) YKPromotionList* promotionList;

/*! 赠品  YKProduct 数组 */
@property(strong) YKPresentList* presentList;

/*! 失效商品  YKProduct 数组 */
@property(strong) NSMutableArray* invalidProductList;



@end

typedef NSString YKKeyword;
typedef NSMutableArray YKKeywordList;

/*!
 秒杀
 */
//@interface YKSecKill  : YKEntity
//
//@property (strong) NSString* secKillId;
//@property (strong) NSString* type;
//@property (strong) NSString* content;
//@property (strong) NSString* imageUrl;
//@property (strong) NSString* startTime;
//@property (strong) NSString* endTime;
//@property (strong) NSString* skillTitle;
//@property (strong) NSString* productId;
//@property (strong) NSString* sku;
//@property (strong) NSString* categoryId;
//@property (strong) NSString* pattern;
//@property (strong) NSString* colorName;
//@property (strong) NSString* sizeId;
//@property (strong) NSString* sizeName;
//@property (strong) NSString* productType;
//@property (strong) NSString* productName;
//@property (strong) NSString* productDesc;
//@property (strong) NSString* colorUrl;
//@property (strong) NSString* marketPrice;
//@property (strong) NSString* salePrice;
//@property (strong) NSString* skillPrice;
//@property (strong) YKImageList* imageList;
//@end

@interface YKSecKill : YKProduct
@property (strong) NSString* startTime;
@property (strong) NSString* endTime;
@end

//typedef YKProduct YKSecKill;
typedef NSMutableArray YKSecKillList;

//@interface YKGroup  : YKEntity
//
//@property (strong) NSString* groupId;
//@property (strong) NSString* type;
//@property (strong) NSString* content;
//@property (strong) NSString* imageUrl;
//@property (strong) NSString* satisfyNumber;
//@property (strong) NSString* startTime;
//@property (strong) NSString* endTime;
//
//@property (strong) NSString* grouponTitle;
//@property (strong) NSString* needNumber;
//@property (strong) NSString* leftNumber;
//@property (strong) NSString* productId;
//@property (strong) NSString* sku;
//@property (strong) NSString* categoryId;
//@property (strong) NSString* pattern;
//@property (strong) NSString* colorName;
//@property (strong) NSString* sizeId;
//@property (strong) NSString* sizeName;
//@property (strong) NSString* productType;
//@property (strong) NSString* productName;
//@property (strong) NSString* productDesc;
//@property (strong) NSString* colorUrl;
//@property (strong) NSString* marketPrice;
//@property (strong) NSString* salePrice;
//@property (strong) NSString* grouponPrice;
//@property (strong) YKImageList* imageList;
//
//@end

//typedef YKProduct YKGroup;
@interface YKGroup : YKProduct
@property (strong) NSString* endTime;
@property (strong) NSString* startTime;
@end
typedef NSMutableArray YKGroupList;


/**
 抽奖详情
 */
@interface YKLottery : YKProduct
@property (strong) NSString* endTime;
@property (strong) NSString* startTime;
@property (strong) YKAddress* address;
@property (strong) NSString* title;
@property (strong) NSString* hasInfo;
@property (strong) NSString* infoUrl;

@end


/**
 抽奖结果
 */
@interface YKLotteryResult : YKEntity
@property(strong) NSString* orderId;

/**
 lotteryResult:
 0：未抽中
 1：抽中
 2：等待结果
 */
@property(strong) NSString* result;
@property(strong) NSString* payMsg;

@end


/*!
 用户信息
 */
@interface YKUser  : YKEntity
/*! 用户名称 */
@property (strong) NSString* name;

/*! 用户标示  */
@property (strong) NSString* userId;

/*! 用户级别  */
@property (strong) NSString* level;

/*! 邮件  */
@property (strong) NSString* email;

/*! 生日 */
@property (strong) NSString* birthday;

/*! 令牌，登陆后服务端返回  */
@property (strong) NSString* token;

/*! 昵称  */
@property (strong) NSString* nickName;

/*! 电话号码  */
@property (strong) NSString* telephone;

@end


/*!
 品牌
 */
@interface YKBrand  : YKEntity

@property (strong) NSString* brandId;
@property (strong) NSString* title;
@property (strong) NSString* content;
@property (strong) NSString* imageUrl;

@property BOOL hasInfo;
@property (strong) NSString* infoUrl;

@property(strong) YKCategoryList* categoryList;

@end

typedef NSMutableArray YKBrandList;


///*!
// 活动，满增，满减
// */
//@interface YKActivity : YKEntity
//
//@property (strong) NSString* title;
//@property (strong) NSString* activityId;
//@property (strong) NSString* type;
//@property (strong) NSString* content;
//@property (strong) NSString* imageUrl;
//@property (strong) NSString* startTime;
//@property (strong) NSString* endTime;
//
//@end
//
//typedef NSMutableArray YKActivityList;



/*!
 帮助信息
 */
@interface YKHelp : YKEntity
@property (strong) NSString* title;
@property (strong) NSString* content;
@property (strong) NSString* imageUrl;
@end

typedef NSMutableArray YKHelpList;


/*!
 版本检测
 */
@interface YKUpdate : YKEntity

@property (strong) NSString* currentVersion;
@property (strong) NSString* newestVersion;

/*! 是否需要更新 1:需要升级 */
@property (strong) NSString* isNeedUpdate;

/*! 更新类型, 1：强制升级，0:可选升级  */
@property (strong) NSString* updateType;

/*! 更新网址  */
@property (strong) NSString* updateUrl;

/*! 更新消息 */
@property (strong) NSString* updateMessage;

@end



