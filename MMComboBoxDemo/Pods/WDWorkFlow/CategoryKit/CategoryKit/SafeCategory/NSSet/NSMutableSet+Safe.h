//
//  NSMutableSet+Safe.h
//  FeiFan
//
//  Created by AKsoftware on 15/9/14.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableSet (Safe)

/**
 对象非空是插入

 @param object 传入对象
 */
- (void)safeAddObject:(id)object;

@end
