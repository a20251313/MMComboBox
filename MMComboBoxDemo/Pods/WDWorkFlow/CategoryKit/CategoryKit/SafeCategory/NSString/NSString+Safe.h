//
//  NSString+Safe.h
//  Pods
//
//  Created by fy on 16/1/28.
//
//

#import <Foundation/Foundation.h>

@interface NSString (Safe)


/**
 NSString的safe保护 如若为nil返回@“”

 @param obj 传入对象

 @return NSString
 */
+ (NSString *)safeStringFromObject:(id)obj;
/**
 *  @brief substringFromIndex的safe方法
 *
 *  @param from 截取的开始位置
 *
 *  @since 1.0
 */
- (NSString *)safeSubstringFromIndex:(NSUInteger)from;
/**
 *  @brief substringToIndex的safe方法
 *
 *  @param to 截取的终止位置
 *
 *  @since 1.0
 */
- (NSString *)safeSubstringToIndex:(NSUInteger)to;
@end
