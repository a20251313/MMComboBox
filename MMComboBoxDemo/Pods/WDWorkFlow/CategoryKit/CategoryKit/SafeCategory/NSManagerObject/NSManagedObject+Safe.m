//
//  NSManagedObject+Safe.m
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "NSManagedObject+Safe.h"

@implementation NSManagedObject (Safe)

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil)
    {
        return;
    }
    
    [self setValue:anObject forKey:aKey];
}
@end
