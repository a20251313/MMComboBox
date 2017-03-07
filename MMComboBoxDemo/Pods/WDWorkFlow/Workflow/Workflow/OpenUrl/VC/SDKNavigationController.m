//
//  SDKNavigationController.m
//  iplaza
//
//  Created by Rush.D.Xzj on 13-6-24.
//  Copyright (c) 2013年 Wanda Inc. All rights reserved.
//

#import "SDKNavigationController.h"
#import<QuartzCore/QuartzCore.h>
#import "SDKViewController.h"
#import "SDKNavigationController+SkipControl.h"
#import "SafeCategory.h"

@interface SDKNavigationController () <UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>

@end

@implementation SDKNavigationController

#pragma mark - init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = self;
        self.transitioningDelegate = self;
        // Custom initialization
    }
    return self;
}
- (id)initWithRootViewControllerURL:(NSURL *)url
{
    self = [self init];
    if (self) {
        SDKViewController *rootVC = [self viewControllerForURL:url withQuery:nil];
        self = [self initWithRootViewController:rootVC];
        return self;
    }
    return nil;
}

- (id)initWithRootViewController:(SDKViewController *)aRootViewController
{
    self = [super initWithRootViewController:aRootViewController];
    if (self && [aRootViewController isKindOfClass:[SDKViewController class]]) {
        self.delegate = self;
        aRootViewController.navigator = self;
        self.rootViewController = aRootViewController;
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        self.delegate = self;
    }
    return self;
}

#pragma mark - actions
- (SDKViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    SDKViewController * viewController = nil;
    if ([self URLAvailable:url]) {
        Class class = NSClassFromString([[SDKNavigationController config] objectForKey:urlString]);
        if (nil == query) {
            viewController = (SDKViewController *)[[class alloc] initWithURL:url];
        }
        else {
            viewController = (SDKViewController *)[[class alloc] initWithURL:url query:query];
        }
        viewController.navigator = self;
    } else if ([self webURLAvailable:url]) {
        Class class = NSClassFromString([[SDKNavigationController config] objectForKey:url.scheme]);
        viewController = [[class alloc] initWithURL:url query:query];
        viewController.navigator = self;
        
        
    }
    
    return viewController;
}


- (BOOL)webURLAvailable:(NSURL *)url
{
    NSString *scheme = url.scheme;
    return [scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"];
}
- (BOOL)URLAvailable:(NSURL *)url
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    return [[[SDKNavigationController config] allKeys] containsObject:urlString];
}

- (void)openURL:(NSURL *)url
{
    [self openURL:url withQuery:nil];
    [self setNavigationBarHidden:NO animated:YES];
}

- (void)openString:(NSString *)str
{
    [self openString:str withQuery:nil animate:YES];
}

- (void)openString:(NSString *)str withQuery:(NSDictionary *)query
{
    [self openString:str withQuery:query animate:YES];
}

- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate withFade:(BOOL)bFade
{
    if (bFade) {
        [self fadeOpenString:str withQuery:query];
    }else
    {
        [self openString:str withQuery:query animate:animate];
    }
}

- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate
{
    [self openString:str withQuery:query animate:animate dismiss:nil];
}

- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss
{
    NSURL *url = [NSURL URLWithString:str];
    if (url == nil) {
        url = [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    [self openURL:url withQuery:query animate:animate dismiss:dismiss];
}

- (void)fadeOpenString:(NSString *)str withQuery:(NSDictionary *)query
{
    NSURL *url = [NSURL URLWithString:str];
    if (url == nil) {
        url = [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    SDKViewController *viewController = [self viewControllerForURL:url withQuery:query];
    viewController.bFade = YES;
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.layer addAnimation:transition forKey:nil];
    [self pushViewController:viewController animated:NO];
}

- (SDKNavigationController *)presentURL:(NSURL *)url
{
    return [self presentURL:url withQuery:nil animate:YES];
}

- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    return [self presentURL:url withQuery:query animate:YES];
}

- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate
{
    return [self presentURL:url withQuery:query animate:animate dismiss:nil];
}

- (SDKNavigationController *)presentString:(NSString *)str withQuery:(NSDictionary *)query
{
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return [self presentURL:url withQuery:query];
}

- (SDKNavigationController *)presentString:(NSString *)str
{
    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    return [self presentURL:url];
}

- (void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (void)fadeBack
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.layer addAnimation:transition forKey:nil];
    [self popViewControllerAnimated:NO];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    [self openURL:url withQuery:query animate:YES];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate
{
    [self openURL:url withQuery:query animate:animate dismiss:nil];
}

- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss
{
    SDKViewController *viewController = [self viewControllerForURL:url withQuery:query];
    [self openURLForInternalUseOnly:url
                     viewController:viewController
                          withQuery:query
                            animate:animate
                            dismiss:dismiss];
}

- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss
{
    SDKViewController *viewController = [self viewControllerForURL:url withQuery:query];
    SDKNavigationController *presentNavi = [[[self class] alloc] initWithRootViewController:viewController];
    
    [self presentURLForInternalUseOnly:url
                        viewController:viewController
                             withQuery:query
                               animate:animate
                               dismiss:dismiss];
    return presentNavi;
}

// 跳转到某一个url viewController，如果界面栈里有的话。
- (BOOL)popToNearestViewControllerWithURL:(NSURL*)url
{
    return [self popToNearestViewControllerWithURL:url animate:YES];
}

- (BOOL)popToNearestViewControllerWithURL:(NSURL*)url animate:(BOOL)animate
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    SDKViewController * viewController = nil;
    if ([self URLAvailable:url]) {
        Class class = NSClassFromString([[SDKNavigationController config] objectForKey:urlString]);
        NSUInteger count = self.viewControllers.count;
        for (NSInteger i = count - 1 ; i >= 0; i--) {
            SDKViewController *vc = [self.viewControllers safeObjectAtIndex:i];
            if([vc isKindOfClass:class]) {
                viewController = vc;
                break;
            }
        }
    }
    if (viewController) {
        [self popToViewController:viewController animated:animate];
        return YES;
    }
    return NO;
}
- (BOOL)popToFarestViewControllerWithURL:(NSURL*)url
{
    return [self popToFarestViewControllerWithURL:url animate:YES];
}
- (BOOL)popToFarestViewControllerWithURL:(NSURL*)url animate:(BOOL)animate
{
    NSString *urlString = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
    SDKViewController * viewController = nil;
    if ([self URLAvailable:url]) {
        Class class = NSClassFromString([[SDKNavigationController config] objectForKey:urlString]);
        for (SDKViewController* vc in self.viewControllers) {
            if([vc isKindOfClass:class]) {
                viewController = vc;
                break;
            }
        }
    }
    if (viewController) {
        [self popToViewController:viewController animated:animate];
        return YES;
    }
    return NO;
}
#pragma mark - config

+ (void)setViewControllerName:(NSString *)className forURL:(NSString *)url
{
    [[SDKNavigationController config] safeSetObject:className forKey:url];
}

+ (NSMutableDictionary *)config
{
    static NSMutableDictionary *config;
    if (nil == config) {
        config = [[NSMutableDictionary alloc] init];
    }
    return config;
}


- (SDKNavigationController *)openViewController:(SDKViewController *)viewcontroller
                                     openMethod:(EViewControllerOpenMethod)openMethod
                                        animate:(BOOL)animate
{
    Class navClass = [self class];
    
    viewcontroller.openType = openMethod;
    viewcontroller.isJumpAnimate = animate;
    viewcontroller.navigator = self;
    
    switch (openMethod) {
        case EViewControllerOpenMethodPush:
        {
            [self pushViewController:viewcontroller animated:animate];
            return self;
        }
            break;
        case EViewControllerOpenMethodPresent:
        {
            SDKNavigationController *presentNav = [(SDKNavigationController *)[navClass alloc] initWithRootViewController:viewcontroller];
            [self.topViewController presentViewController:presentNav animated:animate completion:nil];
            return presentNav;
        }
            break;
        default:
            break;
    }
    return self;
}

- (SDKNavigationController *)openViewController:(SDKViewController *)viewcontroller
                                     openMethod:(EViewControllerOpenMethod)openMethod
                                        animate:(BOOL)animate completion:(void (^)(void))completion
{
    Class navClass = [self class];
    
    viewcontroller.openType = openMethod;
    viewcontroller.isJumpAnimate = animate;
    viewcontroller.navigator = self;
    
    
    switch (openMethod) {
        case EViewControllerOpenMethodPush:
        {
            [self pushViewController:viewcontroller animated:animate completion:completion];
            return self;
        }
            break;
        case EViewControllerOpenMethodPresent:
        {
            SDKNavigationController *presentNav = [(SDKNavigationController *)[navClass alloc] initWithRootViewController:viewcontroller];
            [self.topViewController presentViewController:presentNav animated:animate completion:completion];
            return presentNav;
        }
            break;
        default:
            break;
    }
    
    return self;
}



@end

@implementation SDKNavigationController (InternalUseOnly)

- (void)openURLForInternalUseOnly:(NSURL *)url viewController:(SDKViewController *)viewController withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss
{
    SDKViewController *lastViewController = (SDKViewController *)[self.viewControllers lastObject];
    if (viewController == nil) {
        // 不是内部导航，也不是http的页面，则打开app
        [[UIApplication sharedApplication] openURL:url];
        return;
    }
    if ([lastViewController isSupportOpenWithURL:url] && viewController)
    {
        viewController.openType = EViewControllerOpenMethodPush;
        viewController.isJumpAnimate = animate;
        viewController.dismissCompletionBlock = dismiss;
        [lastViewController willOpenViewController:viewController];
        [self pushViewController:viewController animated:animate];
        [viewController pushFromViewControllerWithURL:lastViewController.url];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

- (void)presentURLForInternalUseOnly:(NSURL *)url viewController:(SDKViewController *)viewController withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss
{
    SDKViewController *lastViewController = (SDKViewController *)[self.viewControllers lastObject];
    if ([lastViewController isSupportOpenWithURL:url] && viewController)
    {
        viewController.openType = EViewControllerOpenMethodPresent;
        viewController.isJumpAnimate = animate;
        viewController.dismissCompletionBlock = dismiss;
        [lastViewController willOpenViewController:viewController];
        [self presentViewController:viewController.navigator animated:animate completion:nil];
        [viewController presentFromViewControllerWithURL:lastViewController.url];
        [viewController openedFromViewControllerWithURL:lastViewController.url];
    }
}

@end
