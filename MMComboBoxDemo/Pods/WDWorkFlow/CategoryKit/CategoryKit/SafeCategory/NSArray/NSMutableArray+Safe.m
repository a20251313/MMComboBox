//
//  NSMutableArray+Safe.m
//  FeiFan
//
//  Created by 李魁峰 on 15/9/13.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import "NSMutableArray+Safe.h"

@implementation NSMutableArray (Safe)


- (void)safeAddObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
}

- (NSMutableArray *) reverse
{
    for (int i=0; i<(floor([self count]/2.0)); i++)
        [self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
    return self;
}

@end
