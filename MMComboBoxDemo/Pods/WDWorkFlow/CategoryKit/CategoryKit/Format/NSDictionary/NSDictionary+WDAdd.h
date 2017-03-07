//
//  NSDictionary+WDAdd.h
//  Pods
//
//  Created by fy on 16/2/23.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WDAdd)

/**
 NSDictionary转换为JSON

 @return NSString
 */
- (NSString *)jsonStringEncoded;


/**
 格式化输出

 @return NSString
 */
- (NSString *)prettyPrintedStr;

@end
