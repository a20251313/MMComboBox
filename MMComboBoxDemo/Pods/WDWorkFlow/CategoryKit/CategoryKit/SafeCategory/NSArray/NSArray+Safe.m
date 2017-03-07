//
//  NSArray+Safe.m
//  FeiFan
//
//  Created by 李魁峰 on 15/9/13.
//  Copyright (c) 2015年 Wanda Inc. All rights reserved.
//

#import "NSArray+Safe.h"

#import "NSString+Format.h"

@implementation NSArray (Safe)

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if (index < self.count) {
        return self[index];
    }
    return nil;
}

+ (NSArray *)safeArrayFromObject:(id)obj;
{
    if ([obj isKindOfClass:[NSArray class]]) {
        return obj;
    } else if ([obj respondsToSelector:@selector(jsonValueDecoded)]) {
        id ret = [obj jsonValueDecoded];
        if ([ret isKindOfClass:[NSArray class]]) {
            return ret;
        }
    }
    else if([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return nil;
}

@end
