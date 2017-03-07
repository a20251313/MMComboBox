//
//  NSUserDefaults+safe.m
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "NSUserDefaults+Safe.h"

@implementation NSUserDefaults (Safe)

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey
{
    if ( aKey == nil)
    {
        return;
    }
    else if (anObject == nil )
    {
        [self removeObjectForKey:aKey];
    }
    else
    {
        [self setObject:anObject forKey:aKey];
    }
}

@end
