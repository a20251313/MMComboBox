//
//  FFHttpClient.h
//  NSUrlSessionDemo
//
//  Created by 李魁峰 on 15/7/27.
//  Copyright (c) 2015年 李魁峰. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WDBaseApi.h"
#import "FFSingleton.h"


typedef void (^QuerySuccess)(id response,BOOL expired);
typedef void (^QueryFailure)(NSError *error);

@interface FFHttpClient : NSObject

FF_AS_SINGLETON(FFHttpClient)

- (void)execute:(WDBaseApi *)api
         method:(DPMethod)method
        success:(QuerySuccess)success
        failure:(QueryFailure)failure;

- (void)clearCacheForApi:(WDBaseApi *)api;

@end
