//
//  FFUrlSchemeManager.h
//  FeiFan
//
//  Created by dash on 15/10/12.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FFSingleton.h"
#import "SDKNavigationController.h"
#import "FFDebugOptionManager.h"
#import "FFTestLogManager.h"

/*
 导航 Log
 */
#define SKIPLOG NSLog
//#define SKIPLOG(...) {\
//if ([[[FFDebugOptionManager sharedInstance] debugOptionValueForKey:@"导航逻辑"] boolValue])\
//{\
//DebugLog(__VA_ARGS__);\
//}\
//}
//#endif

#pragma mark - 页面跳转方式

@interface FFUrlSchemeManager : NSObject

FF_AS_SINGLETON(FFUrlSchemeManager)

- (SDKNavigationController *)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                   navigator:(SDKNavigationController *)navigator
                                      Params:(NSDictionary *)params;

- (SDKNavigationController *)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params completion:(void (^)(void))completion;

- (SDKNavigationController *)presentViewControllerWithControllerName:(NSString *)viewControllerName
                                      navigator:(SDKNavigationController *)navigator
                                         Params:(NSDictionary *)params;

- (SDKNavigationController *)openViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params
                                                       openMethod:(EViewControllerOpenMethod)openMethod
                                                          animate:(BOOL)animate;

- (SDKNavigationController *)openViewControllerWithURL:(NSString *)url
                                             navigator:(SDKNavigationController *)navigator
                                            openMethod:(EViewControllerOpenMethod)openMethod //这个参数暂时先不用处理
                                               animate:(BOOL)animate;

- (SDKViewController *)viewControllerWithViewControllerName:(NSString *)viewControllerName params:(NSDictionary *)params;

// 跳转到一个已经存在的VC，返回nil表示不存在
- (SDKViewController *)openExistViewControllerWithVCName:(NSString *)vcName
                                               navigator:(SDKNavigationController *)navigator
                                                 animate:(BOOL)animate;

- (void)registerUrlSchemePlistNames:(NSArray *)plistNames;

- (BOOL) isFeifanScheme:(NSString *) scheme;

@end
