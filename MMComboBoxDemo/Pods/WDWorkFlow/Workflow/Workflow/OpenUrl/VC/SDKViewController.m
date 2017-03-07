//
//  SDKViewController.m
//  iplaza
//
//  Created by Rush.D.Xzj on 13-6-24.
//  Copyright (c) 2013年 Wanda Inc. All rights reserved.
//

#import "SDKViewController.h"
#import "SDKNavigationController.h"
#import "SafeCategory.h"
#import "NSURL+param.h"
#import "FFUrlSchemeManager.h"

@interface SDKViewController ()

@property (nonatomic, strong) NSURL *url; //initURL

@end

@implementation SDKViewController

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        // Custom initialization
    }
    return self;
}

- (id)initWithURL:(NSURL *)url
{
    return [self initWithURL:url query:nil];
}

- (id)initWithURL:(NSURL *)url query:(NSDictionary *)aQuery {
    // 默认提供和viewcontroller名称一致的xib来进行初始化。
    // 如果想同时使用url映射和xib来生成界面，务必保证xib名称遵守规范。
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.url = url;
        self.params = [url params];
        self.query = aQuery;
    }
    return self;
}

- (void)backAction
{
        
    if (self.bFade) {
        [self.navigator fadeBack];
    }
    else
    {
        switch (self.openType) {
            case EViewControllerOpenMethodPush:
            {
                [self.navigator popViewControllerAnimated:self.isJumpAnimate];
            }
                break;
            case EViewControllerOpenMethodPresent:
            {
                [self.navigator dismissViewControllerAnimated:self.isJumpAnimate completion:self.dismissCompletionBlock];
            }
                break;
            default:
                break;
        }
    }
}

-(void)rightGestureBackAction
{

}

#pragma mark - before / after open

- (BOOL)isSupportOpenWithURL:(NSURL *)url
{
    return YES;
}

#pragma mark -

-(void)willOpenViewController:(SDKViewController*)vc
{
    
}

- (void)openedFromViewControllerWithURL:(NSURL *)url
{
    
}

- (void)presentFromViewControllerWithURL:(NSURL *)url
{
    
}

- (void)pushFromViewControllerWithURL:(NSURL*)url
{
    
}

#pragma mark - webViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] scheme] isEqualToString:@"wdpage"]) {
        // 如果是跳转URL，直接调用url vc mapping管理器。
        [self.navigator openURL:[request URL]];
        return NO;
    }
    return YES;
}

#pragma mark - methods for urlSchemeJump
- (BOOL)safeSetParamsValue:(nullable id)value forKey:(NSString *)key
{
    if (![self isPropertyExistForkey:key]) {
        NSLog(@"%@不存在%@属性",[self class],key);
        return NO;
    }
    
    if (!value) {
        
        NSLog(@"%@字段参数未配置或配置错误",key);
        return NO;
        
    }
    
    [self setValue:value forKey:key];
    
    return YES;
}

- (BOOL)isPropertyExistForkey:(NSString *)key
{
    return [self respondsToSelector:NSSelectorFromString(key)];
}


@end



