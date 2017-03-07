//
//  NSError+FeiFan.m
//  FFOneCard
//
//  Created by huangyuling on 6/2/16.
//  Copyright © 2016 shaofeng. All rights reserved.
//

#import "NSError+FeiFan.h"
#import "NSDictionary+Safe.h"
#import "NSString+Safe.h"

//无网络
#define KFeifanNetworkNotConnectedErrMsg ( @"网络无法连接" )

//超时 或者 弱网
#define KFeifanHttpTimeoutErrMsg ( @"网络不给力，请稍后重试" )

@implementation NSError (FeiFan)

/**
 获取error message信息
 
 @return NSString
 */
- (NSString *)errorMessage
{
    return [self errorMessageWithPath:nil];
}
/**
 *  path 为路径，例如，取userInfo[@"response"][@"errMsg"], 则path为 @"response/errMsg"
 * 如果指定路径无法解析到错误信息，使用默认路径userInfo[@"response"][@"message"]
 */

/**
 获取对应path下的内容
 
 @param path 类似response/errMsg
 
 @return NSString
 */
-(NSString*)ffNetworkErrorMsg
{
    switch (self.code) {
        case NSURLErrorTimedOut://超时
            return KFeifanHttpTimeoutErrMsg;
            break;
        case NSURLErrorNetworkConnectionLost://无网
        case NSURLErrorNotConnectedToInternet:
            return KFeifanNetworkNotConnectedErrMsg;
            break;
        default:
            return self.localizedDescription;
            break;
    }
}
/**
 获取未连接网络提示
 
 @return NSString
 */
- (NSString *)errorMessageWithPath:(NSString *)path
{
    NSDictionary *userInfo = [NSDictionary safeDictionaryFromObject:self.userInfo];
    __block NSString *message = nil;
    
    // specified error message path
    if (path && [path isKindOfClass:[NSString class]] && path.length > 0) {
        NSArray *errorPaths = [path componentsSeparatedByString:@"/"];
        __block NSDictionary *pathDic = userInfo;
        [errorPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![obj isEqualToString:@""]) {
                if (idx == errorPaths.count - 1) {
                    message = [NSString safeStringFromObject:[pathDic objectForKey:obj]];
                } else {
                    pathDic = [NSDictionary safeDictionaryFromObject:[pathDic objectForKey:obj]];
                    if (![pathDic isKindOfClass:[NSDictionary class]]) {
                        *stop = YES;
                    }
                }
            }
        }];
    }

    // default error message path
    if (message.length == 0) {
        NSDictionary *responseDic = [NSDictionary safeDictionaryFromObject:userInfo[@"response"]];
        message = [NSString safeStringFromObject:responseDic[@"message"]];
    }
    
    // if error message componented by a number of error message。then split it
    if (message.length > 0) {
        if ([message containsString:@"|"]) {
            NSArray *array = [message componentsSeparatedByString:@"|"];
            message = [array componentsJoinedByString:@"\n"];
        }
    } else {
        message = [self ffNetworkErrorMsg];
        if (message.length == 0) {
            message = @"未知错误";
        }
    }
    return message;
}

+ (NSString *)errorMessageNotConnectedToInternet
{
    return KFeifanNetworkNotConnectedErrMsg;//无网
}
@end
