//
//  FFApi.h
//  FeiFan
//
//  Created by 李魁峰 on 15/7/23.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FF_AFURLRequestSerialization.h"
#import "FFDataProviderProtocol.h"
#import "WDApiProtocol.h"

@interface WDBaseApi : NSObject<WDApiProtocol,FFDataProviderProtocol>

@property (nonatomic,weak) id<FFDataProviderDelegate> delegate;
@property (nonatomic, assign) BOOL repeated;


/**
 *  重置Api参数
 *
 *  @param dic dic必须 (不为空) && (count > 0) && (key:NSString*)
 */
- (void) resetParamters:(NSDictionary*) dic;

/**
 *  返回当前paramters的"临时对象"
 *  注: 以 count >0 作为判空标准
 */
- (NSDictionary *)paramters;

/**
 *  API的特征字符串，将所有参数(包括Body内的参数)拼接成Restful格式
 *  供 Client 使用
 */
- (NSString *)signatureString;

/**
 *  返回post请求的临时路径
 */
- (NSString *) postRelativePath;


/**
 *  参数加密，默认为不加密
 */
- (NSMutableDictionary *)encryption:(NSMutableDictionary *)parameters;

- (NSString *) infoLog;

- (NSString *) methodLog;

@end
