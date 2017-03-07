//
//  FFApi.m
//  FeiFan
//
//  Created by 李魁峰 on 15/7/23.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import "WDBaseApi.h"
#import "FFHttpClient.h"
#import "SafeCategory.h"


#import "FFWeakObj.h"



@interface WDBaseApi ()
@property (nonatomic, assign) BOOL expired;
@property (nonatomic, copy) QuerySuccess success;
@property (nonatomic, copy) QueryFailure failure;

@property (nonatomic, strong) NSRecursiveLock* paramtersLock;
@property (nonatomic) DPMethod method;
@property (nonatomic) BOOL isQuerying;
@property (nonatomic, strong) NSDictionary *oldData;

/**
 *  API 参数
 */
@property (nonatomic, strong) NSMutableDictionary* param;

/**
 *  Cookie 参数
 */
@property (nonatomic, strong) NSMutableDictionary* cookieParam;

@end

static NSString *defaultUserAgent = nil;

@implementation WDBaseApi
@synthesize method = _method;

- (instancetype)init
{
    if (self = [super init])
    {
        self.paramtersLock = [[NSRecursiveLock alloc] init];
        self.param = [[NSMutableDictionary alloc] init];
        self.method = DP_None;
        self.isQuerying = NO;
        self.expired = NO;
        self.oldData = nil;
    }
    return self;
}

- (void)resetParamters:(NSDictionary*)dic
{
    if ([dic isEqualToDictionary:self.paramters]) {
        return;
    }
    
    if (dic && (dic.count > 0))
    {
        [self.paramtersLock lock];
        
        [self.param removeAllObjects];
        
        for (id key in dic.allKeys)
        {
            NSAssert([key isKindOfClass:[NSString class]], @"请以string为key");
            [self.param safeSetObject:[dic valueForKey:key] forKey:key];
        }
        
        [self.paramtersLock unlock];
    }
    self.oldData = nil;
}


- (NSDictionary *)paramters
{
    return [self.param mutableCopy];
}

- (NSString *)signatureString
{
    NSMutableString *sig = nil;
    sig = [NSMutableString stringWithString:self.baseUrl];
    [sig appendFormat:@"/%@",self.relativePath];
    
    BOOL shouldUseQuestionMark = [sig rangeOfString:@"?"].location == NSNotFound;
    NSDictionary *params = self.paramters;
//    NSArray *keys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
//    }];
//    
    for (NSString *key in params.allKeys)
    {
        if (shouldUseQuestionMark)
        {
            shouldUseQuestionMark = NO;
            [sig appendFormat:@"?%@=%@", key, params[key]];
        }
        else
        {
            [sig appendFormat:@"&%@=%@", key, params[key]];
        }
    }
    
//    shouldUseQuestionMark = [sig rangeOfString:@"?"].location == NSNotFound;
//    params = self.defaultParamters;
//    
//    if ( params )
//    {
//        NSArray *keys = [params.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
//        }];
//        
//        for (NSString *key in keys)
//        {
//            if (shouldUseQuestionMark)
//            {
//                shouldUseQuestionMark = NO;
//                [sig appendFormat:@"?%@=%@", key, params[key]];
//            }
//            else
//            {
//                [sig appendFormat:@"&%@=%@", key, params[key]];
//            }
//        }
//    }
    return sig;
}

- (NSString *)description
{
    return [self signatureString];
}

#pragma mark FFApiProtocol

- (NSString*) baseUrl
{
    return nil;
}

- (NSString*) relativePath
{
    return nil;
}

- (FFApiType) httpMethod
{
    return kFFApiTypeGet;
}

- (FFApiCookieType) cookieType
{
    return FFApiCookieRequired;
}

- (FFApiResponseType) responseType
{
    return FFApi_Json;
}

- (BOOL)isUseHTTPS
{
    //测试时改错了 恢复原状 xph 
    return YES;
}

- (NSString *)cerName
{
    return nil;
}

- (BOOL)isEncryption
{
    return NO;
}

- (NSString *)encryptAppKey
{
    return nil;
}

- (double) expiredTime
{
    return FFApiExpiredTime_ZeroSeconds;
}

- (NSTimeInterval) timeoutInterval
{
    return 30.0f;
}

- (FormData) formdata
{
    return nil;
}

- (NSMutableDictionary *)encryption:(NSMutableDictionary *)parameters
{
    return parameters;
}

#pragma mark FFDataProviderProtocol

- (void) loadLocal
{
    if (![self isQuerying])
    {
        self.isQuerying = YES;
        self.method = DP_LoadLocal;
        [[FFHttpClient sharedInstance] execute:self
                                        method:self.method
                                       success:self.success
                                       failure:self.failure];
    }

}

- (void) query
{
    if (![self isQuerying])
    {
        self.isQuerying = YES;
        self.method = DP_Query;
        [[FFHttpClient sharedInstance] execute:self
                                     method:self.method
                                    success:self.success
                                    failure:self.failure];
    }
}

- (void) refresh
{
    if (![self isQuerying])
    {
        self.isQuerying = YES;
        self.method = DP_Refresh;
        [[FFHttpClient sharedInstance] execute:self
                                     method:self.method
                                    success:self.success
                                    failure:self.failure];
    }
}

- (void) loadMore
{
    if (![self isQuerying])
    {
        self.isQuerying = YES;
        self.method = DP_LoadMore;
        [[FFHttpClient sharedInstance] execute:self
                                     method:_method
                                    success:self.success
                                    failure:self.failure];
    }
}

#pragma mark -

- (void)clearCache
{
    [[FFHttpClient sharedInstance] clearCacheForApi:self];
}

#pragma mark Private
- (QuerySuccess) success
{
    if (!_success)
    {
        weakObj(self)
        _success = ^void(id response,BOOL expired)
        {
            strongObj(self)
            NSDictionary *newData = [NSDictionary safeDictionaryFromObject:response];
            self.expired = expired;
            self.isQuerying = NO;
            
            self.repeated = NO;
            if ( self.oldData && newData && [self.oldData isEqualToDictionary:newData])
            {
                self.repeated = YES;
            }
            
            if ( self.method == DP_Query && self.expired )
            {

                [self queryExpiredWithResponse:response];
                [self refresh];
            }
            else
            {
                [self requestSuccessWithResponse:response];
                
                if ( newData )
                {
                    self.oldData = newData;
                    [self parseResponse:newData];
                }
                
                if ([self.delegate respondsToSelector:@selector(requestSuccessed:)]) {
                    [self.delegate requestSuccessed:self];
                }
            }
        };
    }
    return _success;
}

- (void)queryExpiredWithResponse:(id)response
{
    
}

- (void)requestSuccessWithResponse:(id)response
{
    
}

- (void)requestFailedWithError:(NSError *)error
{
    
}


- (QueryFailure)failure
{
    if (!_failure)
    {
        weakObj(self)
        _failure = ^void(NSError *error)
        {
            strongObj(self)
            
            [self requestFailedWithError:error];
            
            error = [self preprocessError:error];
            
            NSError *_error = [self parseError:error];
            
            self.isQuerying = NO;
            if ([self.delegate respondsToSelector:@selector(requestFailured:error:)]) {
                [self.delegate requestFailured:self error:_error];
            }
        };
    }
    return _failure;
}

- (void)parseResponse:(id)response
{
    // do nothing
}

- (NSError * )preprocessError:(NSError *)error
{
    return error;
}

- (NSError *)parseError:(NSError *)error
{
    return error;
}

- (NSString *) author
{
    return nil;
}

- (NSString *) clientAuthor
{
    return nil;
}

- (NSString *) infoLog
{
    return [NSString stringWithFormat:@"Author: %@, client Author: %@, expiredTime: %0.1f sec, %@",
            self.author,
            self.clientAuthor,
            self.expiredTime,
            (self.isUseHTTPS ? @"Https" : @"http")];
}

- (NSString *) methodLog
{
    NSString *method = @"Query";
    switch (self.method) {
        case DP_Query:
            method = @"Query";
            break;
            
        case DP_LoadLocal:
            method = @"LoadLocal";
            break;
            
        case DP_Refresh:
            method = @"Refresh";
            break;
            
        case DP_LoadMore:
            method = @"LoadMore";
            break;
        default:
            break;
    }
    
    return method;
}

//
- (NSDictionary *)defaultParamters
{
    NSMutableDictionary *paramters = [NSMutableDictionary dictionary];
    switch (self.httpMethod) {
        case kFFApiTypeGet:
            if ( [self respondsToSelector:@selector(defaultGetParamters)] )
            {
                paramters = [self defaultGetParamters] ?: paramters ;
            }
            
            break;
        case kFFApiTypePost:
            if ( [self respondsToSelector:@selector(defaultPostParamters)] )
            {
                paramters = [self defaultPostParamters] ?: paramters ;
            }
            break;
            
        case kFFApiTypePut:
            if ( [self respondsToSelector:@selector(defaultPutParamters)] )
            {
                paramters = [self defaultPutParamters] ?: paramters ;
            }
            break;
            
        case kFFApiTypeDelete:
            if ( [self respondsToSelector:@selector(defaultDeleteParamters)] )
            {
                paramters = [self defaultDeleteParamters] ?: paramters ;
            }
            break;
            
        default:
            break;
    }
    return paramters;
}

- (NSString *) postRelativePath
{
    return self.relativePath;
}

@end
