//
//  NSURL+param.h
//  WDWorkFlow
//
//  Created by 李魁峰 on 16/8/10.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (param)

/**
 组织URL参数

 @return NSDictionary
 */
- (NSDictionary *)params;

/**
 获取URL协议

 @return NSString
 */
- (NSString *)protocol;

/**
 拼接参数

 @param params 参数

 @return NSURL
 */
- (NSURL *)addParams:(NSDictionary*)params;
@end
