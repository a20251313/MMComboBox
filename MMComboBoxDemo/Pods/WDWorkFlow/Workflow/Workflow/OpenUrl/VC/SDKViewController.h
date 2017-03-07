//
//  SDKViewController.h
//  iplaza
//
//  Created by Rush.D.Xzj on 13-6-24.
//  Copyright (c) 2013年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EViewControllerOpenMethod){
    EViewControllerOpenMethodPush    = 0,
    
    EViewControllerOpenMethodPresent = 1,
    
    EViewControllerOpenMethodCustomType,
};
@class SDKNavigationController;


@interface SDKViewController : UIViewController

//SDK
@property (nonatomic, readonly, strong) NSURL *url; //initURL
@property (nonatomic, strong) NSDictionary *params; //params
@property (nonatomic, strong) NSDictionary *query;
@property (nonatomic, assign) BOOL bFade;
@property (nonatomic, assign) EViewControllerOpenMethod openType; //beFade 其实为自定义条抓
@property (nonatomic, assign) BOOL isJumpAnimate;

// jump support
@property (nonatomic, strong) NSDictionary *extParams;   // 额外参数

- (id)initWithURL:(NSURL *)url;
- (id)initWithURL:(NSURL *)url query:(NSDictionary *)query;

//scheme
@property (nonatomic, weak) SDKNavigationController *navigator;
@property (nonatomic, copy) void(^dismissCompletionBlock)(void);

- (BOOL)isSupportOpenWithURL:(NSURL *)url; //default is YES
- (void)openedFromViewControllerWithURL:(NSURL *)url;
- (void)willOpenViewController:(SDKViewController*)vc;
- (void)presentFromViewControllerWithURL:(NSURL *)url; // 在某个界面弹出的时候回调，同时也会回调openedFromViewController
- (void)pushFromViewControllerWithURL:(NSURL*)url;

- (void)backAction;
- (void)rightGestureBackAction;
- (BOOL)safeSetParamsValue:(id)value forKey:(NSString *)key;
- (BOOL)isPropertyExistForkey:(NSString *)key;

//for UrlSchemeManager & FFNavigationController

@end




