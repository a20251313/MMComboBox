//
//  NSString+runtime.m
//  Pods
//
//  Created by 陆锋平 on 2017/1/25.
//
//

#import "NSString+runtime.h"
#import <objc/runtime.h>
#import "NSObject+runtime.h"

@interface NSString (runtime)

@end

@implementation NSString (runtime)

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [objc_getClass("__NSCFString") swizzleOriginInstanceMethod:@selector(stringByAppendingString:)
                                               swizzledInstanceMethod:@selector(safe_stringByAppendingString:)
                                                                error:nil];
    });
}

-(NSString *) safe_stringByAppendingString:(NSString *)aString
{
    NSAssert(aString, @"stringByAppendingString 参数不能为nil");
    if(aString == nil)
    {
        return self;
    }
    
    return [self safe_stringByAppendingString:aString];
}

@end
