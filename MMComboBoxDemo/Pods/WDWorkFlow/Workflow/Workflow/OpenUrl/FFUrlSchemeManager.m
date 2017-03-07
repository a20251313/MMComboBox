//
//  FFUrlSchemeManager.m
//  FeiFan
//
//  Created by dash on 15/10/12.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFUrlSchemeManager.h"
#import "FFUrlSchemeObject.h"
#import "UISkipControl.h"
#import "NSURL+param.h"
#import "SafeCategory.h"
#import "FFFormat.h"
#import "WDDecoupledProtocol.h"
#import "WDNSObjectEventSchedulerManager.h"
#import "NSObject+WDInvoke.h"

@interface FFUrlSchemeManager ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSMutableDictionary *currentVersions;
@property (nonatomic, strong) NSDictionary *urlSchemeObjectDicForTag;
@property (nonatomic, strong) NSDictionary *urlSchemeObjectDicForVCName;

@end

NSString* const kURLSchemeHttpJump = @"http";
NSString* const kURLSchemeHttpsJump = @"https";
NSString* const kURLSchemeReactNativeJump = @"reactNativePage";


@implementation FFUrlSchemeManager

FF_DEF_SINGLETON(FFUrlSchemeManager)

+ (void)load
{
    [FFUrlSchemeManager sharedInstance];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.currentVersions = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadTagObjectsFromPlistWithPlistFileNames:(NSArray *)fileNames
{
    if (!fileNames || [fileNames count] == 0 ) {
        SKIPLOG(@"未传入plist文件");
        return;
        
    }
    NSMutableDictionary *tmpDicForTag = [NSMutableDictionary dictionary];
    NSMutableDictionary *tmpDicForVCName = [NSMutableDictionary dictionary];
    
    
    for (NSString *fileName in fileNames)
    {
        SKIPLOG(@"UrlSchemeManager注册%@.plist",fileName);
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
        
        NSDictionary *tempDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        if (!tempDic) {
            SKIPLOG(@"加载%@.plist失败！",fileName);
            continue;
        }
        
        if (tempDic) {
            [self.currentVersions safeSetObject:tempDic[@"urlSchemeVersion"] forKey:fileName];
            NSArray *tagArray = [NSArray safeArrayFromObject:tempDic[@"urlSchemeTags"]];
            FFUrlSchemeObject *object = nil;
            
            for (int i = 0; i < tagArray.count; i++) {
                NSDictionary *tagDic = [NSDictionary safeDictionaryFromObject:[tagArray safeObjectAtIndex:i]];
                if (tagDic) {
                    
                    object = [[FFUrlSchemeObject alloc] initWithDictionary:tagDic];
                    if (object.tag) {
                        [tmpDicForTag safeSetObject:object forKey:object.tag];
                    }
                    
                    if (object.viewControllerName) {
                        [tmpDicForVCName safeSetObject:object forKey:object.viewControllerName];
                    }
                }
            }
        }
        
    }
    
    self.urlSchemeObjectDicForTag = [NSDictionary dictionaryWithDictionary:tmpDicForTag];
    self.urlSchemeObjectDicForVCName = [NSDictionary dictionaryWithDictionary:tmpDicForVCName];
    
}

- (BOOL)shouldOpenViewControllerWithURLString
{
    if (self.url.absoluteString.length <= 0) {
        SKIPLOG(@"url的长度必须大于0");
        return NO;
    }
    if([self isURLForOpeningWebViewController:self.url] || [self isFeifanScheme:self.url.scheme] || [self.url.scheme isEqualToString:kURLSchemeReactNativeJump]) {
        FFUrlSchemeObject *schemeObject = [self.urlSchemeObjectDicForTag objectForKey:self.url.path];
        for (NSString *parameter in schemeObject.requireParameters) {
            if (![self.url.params.allKeys containsObject:parameter]) {
                SKIPLOG(@"url Paramters不够");
                return NO;
            }
        }
        return YES;
    } else {
        SKIPLOG(@"url Scheme错误");
        return NO;
    }
}

- (BOOL)isURLForOpeningWebViewController:(NSURL *)url
{
    NSString *scheme = url.scheme;
    return [scheme isEqualToString:kURLSchemeHttpJump] || [scheme isEqualToString:kURLSchemeHttpsJump];
}

- (SDKViewController *)viewControllerForURL:(NSURL *)url
{
    
    if (!url) {
        return nil;
    }
    
    NSString *tag = url.host;
    FFUrlSchemeObject *schemeObject = [self.urlSchemeObjectDicForTag objectForKey:tag];
    Class vcClass = NSClassFromString(schemeObject.viewControllerName);
    SDKViewController *viewController = [(SDKViewController *)[vcClass alloc] initWithNibName:nil bundle:nil];
    
    if ([schemeObject.requireParameters count] > 0) {
        for (NSString *key in schemeObject.requireParameters) {
            NSString *value = [url.params objectForKey:key];
            
            BOOL success = [viewController safeSetParamsValue:value forKey:key];
            if (!success) {
                return nil;
            }
        }
    }
    
    if ([schemeObject.optionalParameters count] > 0) {
        for (NSString *key in schemeObject.optionalParameters) {
            NSString *value = [url.params objectForKey:key];
            
            if ([value isNotEmpty] && [viewController isPropertyExistForkey:key]){
                [viewController safeSetParamsValue:value forKey:key];
            }
        }
    }
    
    viewController.extParams = url.params;
    return viewController;
}

- (SDKViewController *)viewControllerForURL:(NSURL *)url withQuery:(NSDictionary *)query
{
    SDKViewController * viewController = nil;
    FFUrlSchemeObject *schemeObject = [self.urlSchemeObjectDicForTag objectForKey:self.url.path];
    Class class = NSClassFromString(schemeObject.viewControllerName);
    viewController = [(SDKViewController *)[class alloc] initWithNibName:nil bundle:nil];
    NSDictionary *params = url.params;
    for (NSString *key in params.allKeys) {
        NSString *value = [NSString safeStringFromObject:[params valueForKey:key]];
        if (key && value) {
            [viewController safeSetParamsValue:[params objectForKey:key] forKey:key];
        }
    }
    viewController.extParams = params;
    return viewController;
}

- (SDKViewController *)viewControllerWithViewControllerName:(NSString *)viewControllerName params:(NSDictionary *)params
{
    if (!viewControllerName) {
        NSLog(@"未传入VC名称");
        return nil;
    }
    
    FFUrlSchemeObject *object = [self.urlSchemeObjectDicForVCName objectForKey:viewControllerName];
    
    if (object) {
        
        Class class = NSClassFromString(viewControllerName);
        SDKViewController *viewController = nil;
        if (object.storyboardFileName && object.storyboardFileName.length > 0) {
            viewController = (SDKViewController *)[[UIStoryboard storyboardWithName:object.storyboardFileName bundle:nil] instantiateViewControllerWithIdentifier:viewControllerName];
        } else {
            viewController = [(SDKViewController *)[class alloc] initWithNibName:nil bundle:nil];
        }
        if ([object.requireParameters count] > 0) {
            for (NSString *requiredKey in object.requireParameters) {
                if (![params objectForKey:requiredKey]) {
                    NSLog(@"未传入必要参数%@字段，生成VC失败!",requiredKey);
                    return nil;
                }
                else
                {
                    [viewController safeSetParamsValue:[params objectForKey:requiredKey] forKey:requiredKey];
                }
            }
        }
        
        
        if ([object.optionalParameters count] > 0) {
            for (NSString *optionalKey in object.optionalParameters) {
                if ([params objectForKey:optionalKey]) {
                    [viewController safeSetParamsValue:[params objectForKey:optionalKey] forKey:optionalKey];
                }
            }
        }
        
        viewController.extParams = params;
        return viewController;
        
    }
    else
    {
        NSLog(@"未在plist中配置%@，无法生成VC",viewControllerName);
        
        Class class = NSClassFromString(viewControllerName);
        SDKViewController *viewController = [(SDKViewController *)[class alloc] initWithNibName:nil bundle:nil];
        if ([params.allKeys count] > 0) {
            for (NSString *key in params.allKeys) {
                id value = [params objectForKey:key];
                [viewController safeSetParamsValue:value forKey:key];
            }
        }
        
        viewController.extParams = params;
        return viewController;
    }
}

#pragma mark - public methods
- (SDKNavigationController *)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params
{
    return [self openViewControllerWithControllerName:viewControllerName
                                            navigator:navigator
                                               Params:params
                                           openMethod:EViewControllerOpenMethodPush
                                              animate:YES];
}

- (SDKNavigationController *)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params completion:(void (^)(void))completion
{
    return [self openViewControllerWithControllerName:viewControllerName
                                            navigator:navigator
                                               Params:params
                                           openMethod:EViewControllerOpenMethodPush
                                              animate:YES completion:completion];
}


- (SDKNavigationController *)presentViewControllerWithControllerName:(NSString *)viewControllerName
                                                           navigator:(SDKNavigationController *)navigator
                                                              Params:(NSDictionary *)params
{
    return [self openViewControllerWithControllerName:viewControllerName
                                            navigator:navigator
                                               Params:params
                                           openMethod:EViewControllerOpenMethodPresent
                                              animate:YES];
}

- (SDKNavigationController *)openViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params
                                                       openMethod:(EViewControllerOpenMethod)openMethod
                                                          animate:(BOOL)animate
{
//    NSDictionary *config;
//    if ([viewControllerName isEqualToString:@"FFShoppingMallViewController"]) {
//        config = @{@"type":@"rn",@"moduleName":@"plaza_list"};
//    }
    /*
    id helper = WDDecoupledObj(@"FFReactNativeInterfaceHelper");
    [[WDNSObjectEventSchedulerManager sharedInstance] setSchedulerDicWithWReceiver:helper];
    NSDictionary *config = [[WDNSObjectEventSchedulerManager sharedInstance] sendEventWithClassName:@"FFReactNativeInterfaceHelper" selName:@selector(getPageConfig:params:) params:@[WDSafeBox(viewControllerName),WDSafeBox(params)]];
     */
    
    id helper = [NSClassFromString(@"FFReactNativeInterfaceHelper") wd_invoke:@selector(sharedInstance)];
    NSDictionary *config = [helper wd_invoke:@selector(getPageConfig:params:)
                                   arguments:WDManiFold(viewControllerName,params)];
    
    if([config[@"type"] isEqualToString:@"rn"]){
        
        BOOL REACT_NATIVE_LOCAL_DEBUG = 0;
        NSString *isRNLocalDebug;
        NSString *jsCodeLocation;
        NSString *moduleName;
        NSDictionary *jsProperties;
        if (REACT_NATIVE_LOCAL_DEBUG) {
            isRNLocalDebug = @"1";
            jsCodeLocation = @"FFOAP/applications/applists.ios";
            moduleName = config[@"moduleName"];
            jsProperties = params;
        } else {
            isRNLocalDebug = nil;
            jsCodeLocation = nil;
            moduleName = config[@"moduleName"];
            jsProperties = params;
        }
        /*
        UIViewController *vc = [[WDNSObjectEventSchedulerManager sharedInstance] sendEventWithClassName:@"FFReactNativeInterfaceHelper" selName:@selector(reactNativeControllerWithIsRNLocalDebug:jsCodeLocation:moduleName:jsProperties:) params:@[WDSafeBox(isRNLocalDebug),WDSafeBox(jsCodeLocation),WDSafeBox(moduleName),WDSafeBox(jsProperties)]];
         */
        UIViewController *vc = [helper wd_invoke:@selector(reactNativeControllerWithIsRNLocalDebug:jsCodeLocation:moduleName:jsProperties:)
                                       arguments:WDManiFold(isRNLocalDebug,jsCodeLocation,moduleName,jsProperties)];

        if (!vc)
        {
            SKIPLOG(@"未能生成VC，无法跳转！");
            return navigator;
        }
        else
        {
            switch (openMethod) {
                case EViewControllerOpenMethodPush:
                {
                    [navigator pushViewController:vc animated:animate];
                }
                    break;
                case EViewControllerOpenMethodPresent:
                {
                    [navigator presentViewController:vc animated:NO completion:nil];
                }
                    break;
                default:
                    break;
            }
            return navigator;
        }
    }else if([config[@"type"] isEqualToString:@"hybrid"]){
        return [self openViewControllerWithURL:config[@"url"] navigator:navigator openMethod:openMethod animate:animate];
    }
    
    SDKViewController *viewController = [self viewControllerWithViewControllerName:viewControllerName params:params];
    viewController.openType = openMethod;
    if (!viewController)
    {
        SKIPLOG(@"未能生成VC，无法跳转！");
        return navigator;
    }
    else
    {
        
        return [navigator openViewController:viewController
                                  openMethod:openMethod
                                     animate:animate];
    }
    
}

- (SDKNavigationController *)openViewControllerWithControllerName:(NSString *)viewControllerName
                                                        navigator:(SDKNavigationController *)navigator
                                                           Params:(NSDictionary *)params
                                                       openMethod:(EViewControllerOpenMethod)openMethod
                                                          animate:(BOOL)animate completion:(void (^)(void))completion
{
    SDKViewController *viewController = [self viewControllerWithViewControllerName:viewControllerName params:params];
    viewController.openType = openMethod;
    if (!viewController)
    {
        SKIPLOG(@"未能生成VC，无法跳转！");
        return navigator;
    }
    else
    {
        
        return [navigator openViewController:viewController
                                  openMethod:openMethod
                                     animate:animate completion:completion];
    }
    
}

- (SDKNavigationController *)openViewControllerWithURL:(NSString *)urlString
                                             navigator:(SDKNavigationController *)navigator
                                            openMethod:(EViewControllerOpenMethod)openMethod
                                               animate:(BOOL)animate
{
    self.url = [NSURL URLWithString:urlString];
    
    if (![self shouldOpenViewControllerWithURLString]) {
        SKIPLOG(@"url错误,导致VC无法打开，请检查url:%@",self.url);
        return navigator;
    }
    
    if ([self isURLForOpeningWebViewController:self.url]) {
        
        Class class = NSClassFromString(@"FFWebBrowserViewController");
        //        FFWebBrowserViewController *webViewController = [[FFWebBrowserViewController alloc] init];
        
        SDKViewController *webVC = [(SDKViewController *)[class alloc] initWithNibName:nil bundle:nil];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic safeSetObject:urlString forKey:@"url"];
        [webVC safeSetParamsValue:self.url forKey:@"actualURL"];
        [webVC safeSetParamsValue:dic forKey:@"params"];
        //        webViewController.actualURL = self.url;
        if (self.url) {
            
            return [navigator openViewController:webVC
                                      openMethod:openMethod
                                         animate:animate];
        }
        
        return navigator;
    }
//    else if ([self isURLForReactViewController:self.url]) {
//        Class class = NSClassFromString(@"FFReactNativeController");
//        SDKViewController *webVC = [(SDKViewController *)[class alloc] initWithNibName:nil bundle:nil];
//        NSDictionary *params = [self.url params];
//        [webVC safeSetParamsValue:[params objectForKey:@"title"] forKey:@"title"];
//        [webVC safeSetParamsValue:[NSDictionary safeDictionaryFromObject:params[@"jsProperties"]]  forKey:@"jsProperties"];
//        [webVC safeSetParamsValue:self.url.host forKey:@"moduleName"];
//        return [navigator openViewController:webVC
//                                  openMethod:openMethod
//                                     animate:animate];
//    }
//    
    if ([self isFeifanScheme:self.url.scheme]) {
        SDKViewController *viewController = [self viewControllerForURL:self.url];
        if (viewController) {
            
            return [navigator openViewController:viewController
                                      openMethod:openMethod
                                         animate:animate];
        }
    }
    return navigator;
}


- (BOOL)isURLForReactViewController:(NSURL *)url
{
    NSString *scheme = url.scheme;
    return [scheme isEqualToString:kURLSchemeReactNativeJump];
}

- (SDKViewController *)openExistViewControllerWithVCName:(NSString *)vcName
                                               navigator:(SDKNavigationController *)navigator
                                                 animate:(BOOL)animate
                                           shouldDismiss:(BOOL)shouldDismiss
{
    BOOL find = NO;
    SDKViewController *lastVC = nil;
    
    NSMutableArray *vcs = [[NSMutableArray alloc]initWithArray:navigator.viewControllers];
    vcs = [vcs reverse];
    
    // 自上而下搜素
    for (id viewController in vcs) {
        if ([viewController isMemberOfClass:NSClassFromString(vcName)]) {
            find = YES;
            
            if (shouldDismiss) {
                [navigator dismissViewControllerAnimated:animate completion:^{
                    [navigator popToViewController:viewController animated:NO];
                }];
            }else{
                [navigator popToViewController:viewController animated:animate];
            }
            
            lastVC = viewController;
            return lastVC;
        }
    }
    // 当前栈找不到，查找上一个栈
    if (!find) {
        // 最后一个
        lastVC = vcs.lastObject;
        id presentVC = [lastVC presentingViewController];
        SDKNavigationController *preNav = nil;
        
        if ([presentVC isKindOfClass:[SDKNavigationController class]]) {
            preNav = presentVC;
        }else if([presentVC isKindOfClass:[SDKViewController class]]){
            preNav = ((SDKViewController *)presentVC).navigator;
        }else if([presentVC isKindOfClass:NSClassFromString(@"FFHomeTabbarViewController")]){
            preNav = [presentVC valueForKey:@"navigator"];
        }
        if (preNav) {
            SKIPLOG(@"preNav# %@",NSStringFromClass([preNav class]));
            
            return [self openExistViewControllerWithVCName:vcName
                                                 navigator:preNav
                                                   animate:animate
                                             shouldDismiss:YES ];
        }
    }
    
    return nil;
}

- (SDKViewController *)openExistViewControllerWithVCName:(NSString *)vcName
                                               navigator:(SDKNavigationController *)navigator
                                                 animate:(BOOL)animate;
{
    return [self openExistViewControllerWithVCName:vcName
                                         navigator:navigator
                                           animate:animate
                                     shouldDismiss:NO ];  // 默认shouldDismiss是NO
}

- (void)registerUrlSchemePlistNames:(NSArray *)plistNames
{
    if (!plistNames || plistNames.count == 0)
    {
        SKIPLOG(@"未传入plist文件");
        return;
    }
    
    [self loadTagObjectsFromPlistWithPlistFileNames:plistNames];
    
    if ([[self.urlSchemeObjectDicForTag allKeys] count] > 0) {
        SKIPLOG(@"已注册页面:");
        for (FFUrlSchemeObject *object in [self.urlSchemeObjectDicForTag allValues]) {
            SKIPLOG(@"%@\n", object);
        }
    }
}

- (BOOL) isFeifanScheme:(NSString *) scheme
{
    if ([scheme isEqualToString:@"wandafeifanapp"] || [scheme isEqualToString:@"wandaappfeifan"] || [scheme isEqualToString:@"wandafeifanpay"])
    {
        return YES;
    }
    return NO;
}

@end
