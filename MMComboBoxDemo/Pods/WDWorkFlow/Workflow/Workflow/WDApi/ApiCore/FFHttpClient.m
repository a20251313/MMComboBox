//
//  FFHttpClient.m
//  NSUrlSessionDemo
//
//  Created by 李魁峰 on 15/7/27.
//  Copyright (c) 2015年 李魁峰. All rights reserved.
//

#import "FFHttpClient.h"
#import "WDCache.h"
#import "FF_AFHTTPSessionManager.h"
#import "FF_AFSecurityPolicy.h"
#import "WDBaseApi.h"
#import <CommonCrypto/CommonDigest.h>
#import "FFWeakObj.h"
#import "SafeCategory.h"

@interface NSString (md5)
- (NSString *)md5;
@end

@implementation NSString (md5)
- (NSString *)md5 {
    const char* string = [self UTF8String];
    unsigned char result[16];

    CC_LONG lenth = (CC_LONG)strlen(string);
    CC_MD5(string, lenth, result);
    NSString * hash = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                       result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
                       result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];

    return [hash lowercaseString];
}
@end

@interface FFHttpClient ()
@property (nonatomic, strong) NSRecursiveLock* sessionManagerLock;

/**
 *  key:NSString:baseUrl
 *  Value:FFSessionManager
 */
@property (nonatomic, strong) NSMutableDictionary* sessionManagers;

@property (nonatomic, strong) WDCache* cache;

@end

@implementation FFHttpClient
@synthesize sessionManagerLock = _sessionManagerLock;
@synthesize sessionManagers = _sessionManagers;

FF_DEF_SINGLETON(FFHttpClient)

- (void)execute:(WDBaseApi *)api
         method:(DPMethod) method
        success:(QuerySuccess)success
        failure:(QueryFailure)failure
{
    if (method == DP_Query || method == DP_LoadLocal)
    {
        FFCacheDataModel* model = [self.cache cachedObjectForKey:[[api signatureString] md5]];

        BOOL expired = NO;
        if ( !model || ([[NSDate date] timeIntervalSince1970] > model.expiredTime.doubleValue) )
        {
            expired = YES;
        }

        id response = nil;
        if ( model )
        {
            @try {
                response = [NSKeyedUnarchiver unarchiveObjectWithData:model.value];
            } @catch (NSException *exception) {
                NSLog(@"<ERROR> %@", exception);
            }
        }

        success( response, expired );
        return;
    }

    FF_AFHTTPSessionManager* manager = [self sessionManagerWithAPI:api];

    NSMutableDictionary* paramters = [self urlParams:api];
    
    weakObj(self)
    switch (api.httpMethod)
    {
        case kFFApiTypeGet:
        {
            [manager GET:api.relativePath
              parameters:paramters
                 success:^void(NSURLSessionDataTask * task , id response)
             {
                 strongObj(self)
                 [self onSuccessApi:api method:method response:response success:success failure:failure];
             }
                 failure:^void(NSURLSessionDataTask * task, NSError * error)
             {
                 strongObj(self)
                 [self onFailureApi:api error:error success:success failure:failure];
             }];
        }
            break;

        case kFFApiTypePut:
        {
            [manager PUT:api.relativePath
              parameters:paramters
                 success:^(NSURLSessionDataTask *task, id response)
            {
                strongObj(self)
                [self onSuccessApi:api method:method response:response success:success failure:failure];
            }
                 failure:^(NSURLSessionDataTask *task, NSError *error)
             {
                 strongObj(self)
                 [self onFailureApi:api error:error success:success failure:failure];
            }];
        }
            break;
        case kFFApiTypeDelete:
        {
            [manager DELETE:api.relativePath
                 parameters:paramters
                    success:^(NSURLSessionDataTask *task, id response)
            {
                strongObj(self)
                [self onSuccessApi:api method:method response:response success:success failure:failure];

            }
                    failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                strongObj(self)
                 [self onFailureApi:api error:error success:success failure:failure];
            }];
        }
            break;

        case kFFApiTypePost:
        {

            if ( !api.formdata )
            {
                [manager POST:api.postRelativePath
                   parameters:paramters
                      success:^void(NSURLSessionDataTask * task, id response)
                 {
                     strongObj(self)
                    [self onSuccessApi:api method:method response:response success:success failure:failure];

                 }
                      failure:^ void(NSURLSessionDataTask * task, NSError * error)
                 {
                     strongObj(self)
                     [self onFailureApi:api error:error success:success failure:failure];
                 }];
            }
            else
            {
                [manager POST:api.postRelativePath
                   parameters:paramters
    constructingBodyWithBlock:api.formdata
                      success:^void(NSURLSessionDataTask * task, id response)
                 {
                     strongObj(self)
                     [self onSuccessApi:api method:method response:response success:success failure:failure];
                 }
                      failure:^ void(NSURLSessionDataTask * task, NSError * error)
                 {
                     strongObj(self)
                     [self onFailureApi:api error:error success:success failure:failure];
                 }];
            }
        }
            break;

        default:
            break;
    }
}

- (NSMutableDictionary *)urlParams:(WDBaseApi *)api
{
    NSMutableDictionary* paramters = [NSMutableDictionary dictionaryWithDictionary:[api defaultParamters]];
    
    for (id key in api.paramters.allKeys)
    {
        [paramters safeSetObject:[api.paramters objectForKey:key] forKey:key];
    }
    
    if ([api isEncryption]) {
        paramters = [api encryption:paramters];
    }
    
    return paramters;
}

/**
 *  成功的统一处理
 *  1. 验证格式
 *  2. 调用API请求成功回调
 *  3. 如果是refresh,则存储数据库
 */
- (void) onSuccessApi:(WDBaseApi *)api
               method:(DPMethod) method
             response:(id) response
              success:(QuerySuccess)success
              failure:(QueryFailure)failure
{
    NSError* error = [self checkServerResponse:response api:api];

    if (!error)
    {
        success(response,NO);

        if ( method == DP_Refresh)//) && (api.expiredTime > FFApiExpiredTime_ZeroSeconds) )
        {
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:response];

            if ( data )
            {
                FFCacheDataModel* model = [[FFCacheDataModel alloc] init];

                NSString* key = [[api signatureString] md5];

                NSTimeInterval expiredTime = [[NSDate date] timeIntervalSince1970] + api.expiredTime;

                model.expiredTime = [NSString stringWithFormat:@"%.0f", expiredTime];
                model.indexedKey = key;
                model.value = data;

                [self.cache setCachedObject:model forKey:key];
            }
        }
    }
    else
    {
        failure(error);
    }
}

/**
 *  错误的统一处理
 *  1. 暂无
 */
- (void) onFailureApi:(WDBaseApi *)api
             error:(NSError *) error
              success:(QuerySuccess)success
              failure:(QueryFailure)failure
{
    failure(error);
}

- (NSError *)checkServerResponse:(id)response api:(WDBaseApi*) api
{
    NSDictionary* responseDic = [NSDictionary safeDictionaryFromObject:response];
    if ( responseDic )
    {
        id idStatus = [responseDic objectForKey:@"status"];
        NSInteger status;
        if (idStatus == nil || idStatus == [NSNull null])
        {
            id idMessage = [responseDic objectForKey:@"message"];
            // 没有message字段表示是成功的
            if (idMessage == nil || idMessage == [NSNull null])
            {
                status = 0;
            }
            else
            {
                status = 400;
            }
        } else
        {
            status = [idStatus intValue];
        }

        if ( (status != 0) && (status != 200) )
        {
            return [[NSError alloc] initWithDomain:api.description code:status userInfo:@{@"response":response}];
        }
    }

    return nil;
}

#pragma mark -

- (void)clearCacheForApi:(WDBaseApi *)api
{
    if (!api) {
        return;
    }

    [self.cache removeCachedObjectForKey:[[api signatureString] md5]];
}

#pragma mark - Get Paramters

- (FF_AFHTTPSessionManager *) sessionManagerWithAPI:(WDBaseApi *)api
{
    FF_AFHTTPSessionManager* manager;

    @synchronized (self) {

        NSString *sessionKey = [NSString stringWithFormat:@"%@%d%zd%lu%f",
                                api.baseUrl,
                                [api isUseHTTPS],
                                api.cookieType,
                                (unsigned long)api.responseType,
                                api.timeoutInterval];

        manager = [self.sessionManagers objectForKey:sessionKey];

        if ( !manager )
        {
            manager = [[FF_AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:api.baseUrl]];
            //设置https证书
            if (api.isUseHTTPS) {
                //使用默认模式，客户端不自带证书
                [manager setSecurityPolicy:[self defaultSecurityPolicy]];

            }

            // 设置cookie
            if (api.cookieType != FFApiCookieRequired)
            {
                [manager.requestSerializer setHTTPShouldHandleCookies:NO];
            }
            else
            {
                [manager.requestSerializer setHTTPShouldHandleCookies:YES];
            }

            //构造response
            switch (api.responseType)
            {
                case FFApi_Json:
                {
                    manager.responseSerializer = [FF_AFJSONResponseSerializer serializer];
                }
                    break;
                case FFApi_Xml:
                {
                    manager.responseSerializer = [FF_AFXMLParserResponseSerializer serializer];
                }
                    break;
                default:
                    break;
            }
            
            //设置超时
            if (api.timeoutInterval > 0)
            {
                manager.requestSerializer.timeoutInterval = api.timeoutInterval;
            }
            [self.sessionManagers safeSetObject:manager forKey:sessionKey];
        }
    }

    return manager;
}

- (NSRecursiveLock *) sessionManagerLock
{
    if ( !_sessionManagerLock )
    {
        _sessionManagerLock = [[NSRecursiveLock alloc] init];
    }
    return _sessionManagerLock;
}

- (NSMutableDictionary *) sessionManagers
{
    if ( !_sessionManagers )
    {
        _sessionManagers = [[NSMutableDictionary alloc] init];
    }
    return _sessionManagers;
}


- (WDCache* ) cache
{
    if ( !_cache )
    {
        _cache = [[WDCache alloc] init];
    }
    return _cache;
}

//HTTPS
- (FF_AFSecurityPolicy*)customSecurityPolicyWithCerName:(NSString *)cerName
{
    // /先导入证书
    FF_AFSecurityPolicy *securityPolicy;

    securityPolicy = [FF_AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:cerName ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    securityPolicy.pinnedCertificates = @[certData];

    securityPolicy.allowInvalidCertificates = NO;
    //万达还是有钱的
    securityPolicy.validatesDomainName = YES;//如果为NO，有可能引发中间人攻击
    securityPolicy.validatesCertificateChain = NO;

    return securityPolicy;
}

- (FF_AFSecurityPolicy*)defaultSecurityPolicy
{
    // /先导入证书
    FF_AFSecurityPolicy *securityPolicy;

    securityPolicy = [FF_AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = NO;
    securityPolicy.validatesDomainName = YES;
    securityPolicy.validatesCertificateChain = YES;

    return securityPolicy;
}



@end
