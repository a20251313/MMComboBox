//
//  WDDownloadClient.h
//  FeiFan
//
//  Created by fy on 16/1/13.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "WDDownloadClient.h"
#import "WDDownloadApi.h"
#import "FFSingleton.h"


typedef void(^downloadSuccess)(NSURLResponse *response, NSURL *filePath);
typedef void (^downloadFailure)(NSError *error);

@interface WDDownloadClient : NSObject
FF_AS_SINGLETON(WDDownloadClient)

- (void)execute:(WDDownloadApi *)api
        success:(downloadSuccess)success
        failure:(downloadFailure)failure;

@end
