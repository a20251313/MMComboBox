//
//  SDKNavigationController+SkipControl.m
//  FeiFan
//
//  Created by AKsoftware on 15/11/11.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "SDKNavigationController+SkipControl.h"
#import "UISkipControl.h"
#import "FFUrlSchemeManager.h"
#import <objc/runtime.h>

#import "SafeCategory.h"


static NSString *animationBlockKey = @"animationBlock";

@implementation SDKNavigationController (SkipControl)


- (void (^)(void))animationBlock
{
    return objc_getAssociatedObject(self, &animationBlockKey);
}

- (void)setAnimationBlock:(void (^)(void))completion
{
    objc_setAssociatedObject(self, &animationBlockKey, completion, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

//SDKNavigationController skip

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.delegate = self;
    //root ViewController
    
    if (animated || self.viewControllers.count)
    {
        UIWindow *window = [UIWindow windowForViewController:self];
        if(window.isAnimated)
        {
            return ;
        }
        if (window && !window.isAnimated) {
            window.isAnimated = YES;
        }
    }
    
    if ( [NSThread currentThread].isMainThread )
    {
        SKIPLOG(@"%@ PUSH %@", self, viewController);
        [super pushViewController:viewController animated:animated];
    }
    else
    {
        SKIPLOG(@"%@ PUSH %@", self, viewController);
        dispatch_async(dispatch_get_main_queue(), ^{
            [super pushViewController:viewController animated:animated];
        });
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    self.delegate = self;
    self.oldViewController = self.topViewController;
    UIWindow *window = [UIWindow windowForViewController:self];
    if (window && !window.isAnimated) {
        window.isAnimated = YES;

        SKIPLOG(@"%@ POP %@", self, self.topViewController);
        return [super popViewControllerAnimated:animated];
    }
    SKIPLOG(@"%@ POP %@ Failed, Because self skip is Animated", self.topViewController, self.topViewController);

    return nil;
}


- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    UIWindow *window = [UIWindow windowForViewController:self];
    if (window && !window.isAnimated) {
        window.isAnimated = YES;
        SKIPLOG(@"%@ PRESENT %@", self, viewControllerToPresent);
        __weak __typeof(window)weakWindow = window;
        [super presentViewController:viewControllerToPresent animated:flag completion:^(){
            __strong __typeof(window)strongWindow = weakWindow;
            if ( strongWindow )
            {
                strongWindow.isAnimated = NO;
            }
            
            if (completion) {
                completion();
            }
            SKIPLOG(@"%@ PRESENT %@ Success", self, viewControllerToPresent);
        }];
        return;
    }
    SKIPLOG(@"%@ PRESENT %@ Failed, Because self skip is Animated", self, viewControllerToPresent);

}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (!self.presentedViewController && !self.presentingViewController) {
        if (completion) {
            completion();
        }
        return;
    }

    UIWindow *window = [UIWindow windowForViewController:self];

    if (window && !window.isAnimated) {
        window.isAnimated = YES;
        
        SKIPLOG(@"%@ DISMISS %@", self.presentedViewController ? self : self.presentingViewController, self.presentedViewController ? self.presentedViewController : self);

        __weak __typeof(window)weakWindow = window;
        [super dismissViewControllerAnimated:flag completion:^(){
            __strong __typeof(window)strongWindow = weakWindow;
            if ( strongWindow )
            {
                strongWindow.isAnimated = NO;
            }
            
            if (completion) {
                completion();
            }
            
            SKIPLOG(@"%@ DISMISS Success", self);
        }];
        return;
    }
    SKIPLOG(@"%@ DISSMISS %@ Failed, Because self skip is Animated", self, self.presentingViewController);
}

#pragma makr - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIWindow *window = [UIWindow windowForViewController:self];
    window.isAnimated = NO;

    if ([self animationBlock]) {
        [self animationBlock]();
        [self setAnimationBlock:nil];
    }
    SKIPLOG(@"%@ DID PUSH OR POP %@", navigationController, viewController);
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    id<UIViewControllerTransitionCoordinator> tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        //右滑手势抬起时
        SKIPLOG(@"右滑手势isCancelled:%i", [context isCancelled]);

        if ([context isCancelled]) {
            //右滑手势取消
            UIWindow *window = [UIWindow windowForViewController:self];
            window.isAnimated = NO;
        } else {
            //右滑手势确认返回上层页面
            if ([self.oldViewController isKindOfClass:SDKViewController.class]) {
                SDKViewController *viewController = (SDKViewController *) self.oldViewController;
                [viewController rightGestureBackAction];
            }
        }
    }];

    SKIPLOG(@"%@ WILL PUSH OR POP %@", navigationController, viewController);
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIWindow *window = [UIWindow windowForViewController:self];
    if (window && !window.isAnimated) {
        [self setAnimationBlock:completion];
        [self pushViewController:viewController animated:animated];
    }
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion
{
    UIWindow *window = [UIWindow windowForViewController:self];
    if (window && !window.isAnimated) {
        [self setAnimationBlock:completion];
        return [self popViewControllerAnimated:animated];
    }
    return nil;
}

- (NSString*) description
{
    UIViewController* vc = [self.viewControllers safeObjectAtIndex:0];
    if ( vc )
    {
       return NSStringFromClass(vc.class);
    }
    else
    {
        return NSStringFromClass(self.class);
    }
}

@end
