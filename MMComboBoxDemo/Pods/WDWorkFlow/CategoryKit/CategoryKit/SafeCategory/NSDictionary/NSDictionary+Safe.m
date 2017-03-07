//
//  NSDictionary+Safe.m
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSString+Format.h"

@implementation NSDictionary (Safe)

- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey
{
    if (anObject == nil || aKey == nil)
    {
        return;
    } 

    [self setValue:anObject forKey:aKey];
}

+ (NSDictionary *)safeDictionaryFromObject:(id)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return obj;
    } else if ([obj respondsToSelector:@selector(jsonValueDecoded)]) {
        id ret = [obj jsonValueDecoded];
        if ([ret isKindOfClass:[NSDictionary class]]) {
            return ret;
        }
    }
    else if([obj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return nil;
}
@end
