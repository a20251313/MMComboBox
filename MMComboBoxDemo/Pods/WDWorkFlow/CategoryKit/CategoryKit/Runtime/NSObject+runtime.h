//
//  NSObject+WDSafe.h
//  WDWorkFlow
//
//  Created by dash on 16/8/22.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(runtime)

+ (BOOL)swizzleOriginInstanceMethod:(SEL)originSelector
             swizzledInstanceMethod:(SEL)swizzledSelector
                              error:(NSError *)error;

@end
