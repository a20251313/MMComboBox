//
//  UIWebView+VSWebView.m
//  VDMTest
//
//  Created by YaoMing on 2016/11/4.
//  Copyright © 2016年 YaoMing. All rights reserved.
//

#import "UIWebView+VSWebView.h"
#import "VSDependencyManager.h"

@implementation UIWebView (VSWebView)
-(void)setWebViewDelegate:(id)delegate
{
    [self setWebViewDelegate:delegate];
    if([[VSDependencyManager shareInstance] isManagerObject:delegate]){
        [[VSDependencyManager shareInstance] addObserver:delegate source:self];
    }
}

@end
