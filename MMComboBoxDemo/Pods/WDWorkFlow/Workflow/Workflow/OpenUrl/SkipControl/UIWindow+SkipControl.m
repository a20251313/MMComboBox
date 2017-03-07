//
//  UIWindow+SkipControl.m
//  FeiFan
//
//  Created by AKsoftware on 15/12/21.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "UIWindow+SkipControl.h"
#import <Objc/runtime.h>

static NSString *isAnimatedKey = @"isAnimated";


@implementation UIWindow (SkipControl)

- (BOOL)isAnimated
{
    NSNumber *number = objc_getAssociatedObject(self, &isAnimatedKey);
    if (!number) {
        self.isAnimated = NO;
    }
    return number.boolValue;
}

- (void)setIsAnimated:(BOOL)isAnimated
{
    objc_setAssociatedObject(self, &isAnimatedKey, [NSNumber numberWithBool:isAnimated], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (UIWindow *)windowForViewController:(UIViewController *)viewController
{
    UIViewController *pViewController = viewController;
    while (pViewController && !pViewController.view.window) {
        pViewController = pViewController.presentedViewController;
    }
    return pViewController.view.window;
}

@end
