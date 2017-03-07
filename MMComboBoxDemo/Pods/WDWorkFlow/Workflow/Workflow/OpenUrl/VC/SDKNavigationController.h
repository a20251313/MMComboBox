//
//  SDKNavigationController.h
//  iplaza
//
//  Created by Rush.D.Xzj on 13-6-24.
//  Copyright (c) 2013年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDKViewController.h"

@interface SDKNavigationController : UINavigationController
- (SDKNavigationController *)presentString:(NSString *)str;
- (SDKNavigationController *)presentString:(NSString *)str withQuery:(NSDictionary *)query;
- (void)openString:(NSString *)str;
- (void)openString:(NSString *)str withQuery:(NSDictionary *)query;
- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate withFade:(BOOL)bFade;
- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate;
- (void)openString:(NSString *)str withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss;
- (void)fadeOpenString:(NSString *)str withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url;
- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate;
- (void)openURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss;
- (SDKNavigationController *)presentURL:(NSURL *)url;
- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query;
- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate;
- (SDKNavigationController *)presentURL:(NSURL *)url withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss;
// 跳转到某一个url viewController，如果界面栈里有的话。
// 导航栏中的VC从后往前最近的一个
- (BOOL)popToNearestViewControllerWithURL:(NSURL*)url;
- (BOOL)popToNearestViewControllerWithURL:(NSURL*)url animate:(BOOL)animate;
// 导航栏中的VC从后往前最远的一个
- (BOOL)popToFarestViewControllerWithURL:(NSURL*)url;
- (BOOL)popToFarestViewControllerWithURL:(NSURL*)url animate:(BOOL)animate;
- (SDKViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query;


- (id)initWithRootViewControllerURL:(NSURL *)url;
+ (void)setViewControllerName:(NSString *)className forURL:(NSString *)url;
+ (NSMutableDictionary *)config;
- (void)fadeBack;

- (SDKNavigationController *)openViewController:(SDKViewController *)viewcontroller
                                     openMethod:(EViewControllerOpenMethod)openMethod
                                        animate:(BOOL)animate;
- (SDKNavigationController *)openViewController:(SDKViewController *)viewcontroller
                                     openMethod:(EViewControllerOpenMethod)openMethod
                                        animate:(BOOL)animate completion:(void (^)(void))completion;

@property (strong, nonatomic) SDKViewController *rootViewController;
@property (weak, nonatomic) UIViewController *oldViewController;

@end

@interface SDKNavigationController (InternalUseOnly)

- (void)openURLForInternalUseOnly:(NSURL *)url viewController:(SDKViewController *)viewController withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss;

- (void)presentURLForInternalUseOnly:(NSURL *)url viewController:(SDKViewController *)viewController withQuery:(NSDictionary *)query animate:(BOOL)animate dismiss:(void (^)(void))dismiss;

@end
