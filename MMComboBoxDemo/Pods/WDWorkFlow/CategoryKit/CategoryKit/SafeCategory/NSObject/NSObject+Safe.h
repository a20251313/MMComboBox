//
//  NSObject+Safe.h
//  Pods
//
//  Created by fy on 16/1/28.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Safe)

/**
 主要作用是去除NSNull:当obj为NSNull的时候，返回nil

 @param obj 传入对象

 @return id
 */
+ (id)safeObjectFromObject:(id)obj;

@end
