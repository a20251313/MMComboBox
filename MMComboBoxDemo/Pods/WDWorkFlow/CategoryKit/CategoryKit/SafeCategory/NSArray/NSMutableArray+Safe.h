//
//  NSMutableArray+Safe.h
//  FeiFan
//
//  Created by 李魁峰 on 15/9/13.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safe)

/**
 safe替换addObject

 @param object 传入对象
 */
- (void)safeAddObject:(id)object;

/**
 翻转数组

 @return NSMutableArray
 */
- (NSMutableArray *) reverse;
@property (readonly, getter=reverse) NSMutableArray *reversed;

@end
