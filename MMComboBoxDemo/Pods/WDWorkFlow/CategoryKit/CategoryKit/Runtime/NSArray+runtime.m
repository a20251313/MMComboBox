//
//  NSArray+WDSafe.m
//  WDWorkFlow
//
//  Created by dash on 16/8/22.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "NSArray+runtime.h"
#import <objc/runtime.h>
#import "NSObject+runtime.h"

@interface NSArray(WDSafe)

- (id)swizzleObjectAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray(WDSafe)

- (void)swizzleAddObject:(id)obj;

@end

@implementation NSArray(WDSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            //objectAtIndex 包括objectAtIndex和字面量temp[i]方法替换
            [objc_getClass("__NSArrayI") swizzleOriginInstanceMethod:@selector(objectAtIndex:)
                                              swizzledInstanceMethod:@selector(swizzleObjectAtIndex:)
                                                               error:nil];
            //            [objc_getClass("__NSArrayM") swizzleOriginInstanceMethod:@selector(objectAtIndex:)
            //                                              swizzledInstanceMethod:@selector(swizzleObjectAtIndex:)
            //                                                       error:nil];
            //字面量初始化数组
            [objc_getClass("__NSPlaceholderArray") swizzleOriginInstanceMethod:@selector(initWithObjects:count:)
                                                        swizzledInstanceMethod:@selector(swizzleInitWithObjects:count:)
                                                                         error:nil];
        }
    });
}

- (id)swizzleObjectAtIndex:(NSUInteger)index
{
    if (index < self.count ) {
        return [self swizzleObjectAtIndex:index];
    }
    return nil;//越界返回为nil
}

- (id)swizzleInitWithObjects:(const id [])objects
                       count:(NSUInteger)count
{
    for (int i=0; i<count; i++)
    {
        if(objects[i] == nil) {
            return nil;
        }
    }
    return [self swizzleInitWithObjects:objects count:count];
}

@end

@implementation NSMutableArray(WDSafe)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            [objc_getClass("__NSArrayM") swizzleOriginInstanceMethod:@selector(addObject:)
                                              swizzledInstanceMethod:@selector(swizzleAddObject:)
                                                               error:nil];
        }
    });
}

- (void)swizzleAddObject:(id)obj
{
    if (!obj) {
        return;
    }
    [self swizzleAddObject:obj];
}

@end
