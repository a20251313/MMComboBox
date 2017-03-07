//
//  NSObject+WDSafe.m
//  WDWorkFlow
//
//  Created by dash on 16/8/22.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "NSObject+runtime.h"

#import <objc/runtime.h>

@implementation NSObject(runtime)

+ (BOOL)swizzleOriginInstanceMethod:(SEL)originSelector
             swizzledInstanceMethod:(SEL)swizzledSelector
                              error:(NSError *)error
{
    Method originMethod = class_getInstanceMethod(self, originSelector);
    if (!originMethod) {
//        NSString *string = [NSString stringWithFormat:@" %@ 类没有找到 %@ 方法",NSStringFromClass([self class]),NSStringFromSelector(originSelector)];
//        error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    Method swizzledMethod = class_getInstanceMethod(self, swizzledSelector);
    if (!swizzledMethod) {
//        NSString *string = [NSString stringWithFormat:@" %@ 类没有找到 %@ 方法",NSStringFromClass([self class]),NSStringFromSelector(swizzledSelector)];
//        error = [NSError errorWithDomain:@"NSCocoaErrorDomain" code:-1 userInfo:[NSDictionary dictionaryWithObject:string forKey:NSLocalizedDescriptionKey]];
        return NO;
    }
    
    class_addMethod(self, originSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
    class_addMethod(self, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    method_exchangeImplementations(class_getInstanceMethod(self, originSelector), class_getInstanceMethod(self, swizzledSelector));
    return YES;
}

@end
