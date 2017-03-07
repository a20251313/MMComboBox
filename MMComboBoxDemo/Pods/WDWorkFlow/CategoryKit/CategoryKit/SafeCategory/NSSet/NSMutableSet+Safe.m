//
//  NSMutableSet+Safe.m
//  FeiFan
//
//  Created by AKsoftware on 15/9/14.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import "NSMutableSet+Safe.h"

@implementation NSMutableSet (Safe)

- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

@end
