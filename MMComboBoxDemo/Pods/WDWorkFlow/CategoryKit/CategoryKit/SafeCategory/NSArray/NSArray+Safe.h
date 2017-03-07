//
//  NSArray+Safe.h
//  FeiFan
//
//  Created by 李魁峰 on 15/9/13.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Safe)


/**
 safe方法替换objectAtIndex 防止取值越界

 @param index 下标

 @return id
 */
- (id)safeObjectAtIndex:(NSUInteger)index;

/**
 根据判断转换obj为NSArray

 @param obj 入参对象

 @return NSArray
 */
+ (NSArray *)safeArrayFromObject:(id)obj;

@end
