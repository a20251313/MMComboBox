//
//  FFNetWorkReachable.m
//  test
//
//  Created by xinpenghui on 16/11/29.
//  Copyright © 2016年 xinpenghui. All rights reserved.
//

#import "FFNetWorkReachable.h"
#import "FF_AFNetworkReachabilityManager.h"

@implementation FFNetWorkReachable

+ (BOOL)isNetworkReachable
{
    return !([FF_AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable);
}

@end
