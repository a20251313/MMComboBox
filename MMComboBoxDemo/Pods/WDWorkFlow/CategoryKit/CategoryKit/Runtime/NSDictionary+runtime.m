//
//  NSDictionary+runtime.m
//  WDWorkFlow
//
//  Created by 陆锋平 on 2016/10/20.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "NSDictionary+runtime.h"
#import <objc/runtime.h>
#import "NSObject+runtime.h"

@interface NSDictionary (WDSafe)

@end

@interface NSMutableDictionary (WDSafe)

@end

@implementation NSDictionary (WDSafe)

-(instancetype)initWithObjects_safe:(id *)objects forKeys:(id<NSCopying> *)keys count:(NSUInteger)cnt {
    NSUInteger newCnt = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        if (!(keys[i] && objects[i])) {
            break;
        }
        newCnt++;
    }
    self = [self initWithObjects_safe:objects forKeys:keys count:newCnt];
    return self;
}

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [objc_getClass("__NSPlaceholderDictionary") swizzleOriginInstanceMethod:@selector(initWithObjects:forKeys:count:)
                                          swizzledInstanceMethod:@selector(initWithObjects_safe:forKeys:count:)
                                                           error:nil];
    });
}
@end


@implementation NSMutableDictionary (WDSafe)

- (void)safe_removeObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    [self safe_removeObjectForKey:aKey];
}

- (void)safe_setObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    [self safe_setObject:anObject forKey:aKey];
}

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSDictionaryM") swizzleOriginInstanceMethod:@selector(removeObjectForKey:)
                                                         swizzledInstanceMethod:@selector(safe_removeObjectForKey:)
                                                                          error:nil];
        [objc_getClass("__NSDictionaryM") swizzleOriginInstanceMethod:@selector(setObject:forKey:)
                                               swizzledInstanceMethod:@selector(safe_setObject:forKey:)
                                                                error:nil];
        
    });
}

@end
