//
//  NSError+FeiFan.h
//  FFOneCard
//
//  Created by huangyuling on 6/2/16.
//  Copyright © 2016 shaofeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (FeiFan)

/**
 获取error message信息

 @return NSString
 */
- (NSString *)errorMessage;
/**
 *  path 为路径，例如，取userInfo[@"response"][@"errMsg"], 则path为 @"response/errMsg"
 * 如果指定路径无法解析到错误信息，使用默认路径userInfo[@"response"][@"message"]
 */

/**
 获取对应path下的内容

 @param path 类似response/errMsg

 @return NSString
 */
- (NSString *)errorMessageWithPath:(NSString *)path;

/**
 获取未连接网络提示

 @return NSString
 */
+ (NSString *)errorMessageNotConnectedToInternet;

@end
