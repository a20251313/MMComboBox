//
//  WDApiProtocol.h
//  FeiFan
//
//  Created by fy on 16/1/28.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDBaseApi.h"

typedef enum FFApiType {
    kFFApiTypeGet,                      // Get方式
    kFFApiTypePost,                     // Post方式
    kFFApiTypeDelete,                   // Delete方式
    kFFApiTypePut,                      // Put方式
}FFApiType;


#define FFApiExpiredTime_OneHour       (1 * 60 * 60)      // 一小时
// 活动列表,优惠券列表,餐饮列表,各种详情,广告轮播
#define FFApiExpiredTime_ThreeMinute   (3 * 60)           // 三分钟
#define FFApiExpiredTime_OneMinute     (60)               // 一分钟
// 用户相关内容
#define FFApiExpiredTime_ZeroSeconds   (0)                // 立即过期
#define FFApiExpiredTime_Never         (MAXFLOAT)         // 永不过期

typedef NS_ENUM (NSInteger, FFApiCookieType) {
    FFApiCookieNone = 0,                       // 没有Cookie
    FFApiCookieRequired,                   // 必须有Cookie
};

typedef enum : NSUInteger {
    FFApi_Json,
    FFApi_Xml
}FFApiResponseType;

typedef void (^FormData)(id <AFMultipartFormData> formData);


/**
 *  需要子类派生的Api属性
 */

@protocol WDApiProtocol <NSObject>

@required
- (NSString*)baseUrl;
- (NSString*)relativePath;

/**
 *  请求类型
 *
 *  @return kFFApiTypeGet | kFFApiTypePost
 *  @默认值为：kFFApiTypeGet
 */
- (FFApiType)httpMethod;

/**
 *  请求时，是否携带cookie
 *
 *  @return FFApiCookieNone | FFApiCookieRequired
 *  @默认值为：FFApiCookieRequired
 */
- (FFApiCookieType)cookieType;

/**
 *  返回值的类型
 *
 *  @return FFApi_Json | FFApi_Xml
 *  @默认值为：FFApi_Json
 */
- (FFApiResponseType)responseType;

/**
 *  此api是否支持https
 *
 *  @默认值为：YES
 */
- (BOOL)isUseHTTPS;

/**
 *  过期时间
 *
 *  @return FFApiExpiredTime_ZeroSeconds ...
 *  @默认值为4小时：FFApiExpiredTime_OneHour * 4
 */
- (double) expiredTime;

/**
 *  超时时间
 *  @默认值：建议为10秒
 */
- (NSTimeInterval) timeoutInterval;

/**
 *  对API返回的结果进行解析
 *
 *  @param response 根据responseType所指定的类型返回的结果, 默认为NSDictionary
 *  注意：
 1. BaseApi提供了默认处理，请调用super
 2. response 可能为nil (如没有缓存但执行了query方法)
 */
- (void)parseResponse:(id)response;

/**
 *  对API返回的“错误”进行解析
 *
 *  @param error 当前错误
 *
 *  @return 尚未被处理的错误
 *
 *  注意：
 1. BaseApi提供了默认处理，派生类需要调用super
 2. error 可能为nil (已经全部被父类处理完)
 */
- (NSError *)parseError:(NSError *)error;

- (NSError *)preprocessError:(NSError *)error;

- (NSString *)author;

- (NSString *)clientAuthor;

- (BOOL)isEncryption;

- (NSString *)encryptAppKey;


/**
 *  追加在Url relative path 后面的默认参数
 */
- (NSDictionary *)defaultParamters;

@optional

/*
 * 各类请求的默认参数
 */
- (NSMutableDictionary *)defaultGetParamters;
- (NSMutableDictionary *)defaultPostParamters;
- (NSMutableDictionary *)defaultPutParamters;
- (NSMutableDictionary *)defaultDeleteParamters;

/**
 *  Post请求文件对象
 */
- (FormData) formdata;

/**
 *  需导入证书的名称
 */
- (NSString *)cerName;

- (void)queryExpiredWithResponse:(id)response;

- (void)requestSuccessWithResponse:(id)response;

- (void)requestFailedWithError:(NSError *)error;

@end
