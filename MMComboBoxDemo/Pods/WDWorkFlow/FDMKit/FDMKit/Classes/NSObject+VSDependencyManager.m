//
//  NSObject+deleteDependence.m
//  VSReplaceMethod
//
//  Created by YaoMing on 14-3-24.
//  Copyright (c) 2014年 YaoMing. All rights reserved.
//

#import "NSObject+VSDependencyManager.h"
#import "VSDependencyManager.h"
#import "VSDependencyObject.h"
@implementation NSObject (VSDependencyManager)

- (void)addDependencyObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    [self addDependencyObserver:observer forKeyPath:keyPath options:options context:context];

    if(![[VSDependencyManager shareInstance] isManagerObject:observer]){
        return;
    }
    
    if(![[VSDependencyManager shareInstance] observer:observer inkeySource:self keyPath:keyPath]){
        VSDependencyObject *obj = [[VSDependencyObject alloc] initWithResource:self key:keyPath];
        [[VSDependencyManager shareInstance] addObserver:observer keySource:obj];
#if __has_feature(objc_arc)
        // ARC is On
#else
        // ARC is Off
        [obj release];
#endif
    }
}

- (void)removeOCObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    [self removeOCObserver:observer forKeyPath:keyPath];

    if(![[VSDependencyManager shareInstance] isManagerObject:observer]){
        return;
    }
    [[VSDependencyManager shareInstance] observerremove:observer inkeySource:self keyPath:keyPath];

}


- (void)removeOCObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context{
    [self removeOCObserver:observer forKeyPath:keyPath context:context];

    if(![[VSDependencyManager shareInstance] isManagerObject:observer]){
        return;
    }
    [[VSDependencyManager shareInstance] observerremove:observer inkeySource:self keyPath:keyPath];
    
}

@end
