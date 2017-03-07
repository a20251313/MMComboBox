//
//  SDKViewController+SkipControl.m
//  FeiFan
//
//  Created by AKsoftware on 15/11/12.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "SDKViewController+SkipControl.h"
#import "UISkipControl.h"
#import "FFUrlSchemeManager.h"

@implementation SDKViewController (SkipControl)

//skipController

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.navigator) {
        [self.navigator presentViewController:viewControllerToPresent animated:flag completion:completion];
        return;
    }

    UIWindow *window = [UIWindow windowForViewController:self];
    if (!window.isAnimated) {
        window.isAnimated = YES;
        SKIPLOG(@"%@ PRESENT %@", self, viewControllerToPresent);
        void(^pCompletionBlock)() = ^(){
            window.isAnimated = NO;
            if (completion) {
                completion();
            }
            SKIPLOG(@"%@ PRESENT %@ Success", self, viewControllerToPresent);
        };
        [super presentViewController:viewControllerToPresent animated:flag completion:pCompletionBlock];
        return;
    }
    SKIPLOG(@"%@ PRESENT %@ Failed, Because self skip is Animated", self, viewControllerToPresent);
    
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (self.navigator) {
        [self.navigator dismissViewControllerAnimated:flag completion:completion];
        return;
    }
    
    if (!self.presentedViewController && !self.presentingViewController) {
        if (completion) {
            completion();
        }
        return;
    }
    UIWindow *window = [UIWindow windowForViewController:self];
    
    if (!window.isAnimated && window) {
        window.isAnimated = YES;
        void(^dismissCompletionBlock)() = ^(){
            window.isAnimated = NO;
            if (completion) {
                completion();
            }
            
            SKIPLOG(@"%@ DISMISS Success", self);
        };
        SKIPLOG(@"%@ DISMISS %@", self.presentedViewController ? self : self.presentingViewController, self.presentedViewController ? self.presentedViewController : self);
        [super dismissViewControllerAnimated:flag completion:dismissCompletionBlock];
        return;
    }
    SKIPLOG(@"%@ DISSMISS %@ Failed, Because self skip is Animated", self, self.presentingViewController);
}


- (NSString*) description
{
    return NSStringFromClass(self.class);
}

@end
