//
//  FFTestLogWindow.m
//  FeiFan
//
//  Created by fy on 15/12/16.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "FFTestLogWindow.h"

@implementation FFTestLogWindow

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    if (view == self || view == self.rootViewController.view) {
        return nil;
    }
    return view;
}
@end
