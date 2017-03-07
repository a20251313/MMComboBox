//
//  FFZombieObject.m
//  WildPointerCheckerDemo
//
//  Created by XXXXXX on 16/8/26.
//  Copyright © 2016年 hdurtt. All rights reserved.
//

#import "FFZombieObject.h"
#import <objc/runtime.h>
#import "CrashReporter.h"
#import "FFMonitorManager.h"

@implementation FFZombieObject

//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    NSLog(@"发生野指针的Class:%@,Selector:%@", NSStringFromClass(self.origClass), NSStringFromSelector(aSelector));
////    abort();
//}
//
- (void)dealloc
{
    NSLog(@"发生野指针的Class:%@,Selector:%@", NSStringFromClass(self.origClass), @"dealloc");
//    abort();
}

void targetForwardMethod(id self,SEL sel)
{
    [self outputCrashReportWithSelector:sel];
}

- (void)outputCrashReportWithSelector:(SEL)sel
{
    NSLog(@"++++++++++++++++++++++请关注++++++++++++++++++\n\n\n");
    NSLog(@"特么你有野指针了，发生野指针的Class:%@,Selector:%@\n\n\n,别BB了，赶紧查一下", NSStringFromClass(self.origClass), NSStringFromSelector(sel));
    NSLog(@"++++++++++++++++++++++请关注++++++++++++++++++\n\n\n");
//    [FFMonitorManager outputCurrentStackInfo];
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel) {
        class_addMethod(self, sel, (IMP)targetForwardMethod, "v@:");
        return YES;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    if (sel) {
        class_addMethod(self, sel, (IMP)targetForwardMethod, "v@:");
        return YES;
    } else {
        return [super resolveClassMethod:sel];
    }
}

@end
