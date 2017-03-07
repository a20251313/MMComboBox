//
//  UIWindow+SkipControl.h
//  FeiFan
//
//  Created by AKsoftware on 15/12/21.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (SkipControl)

@property (nonatomic, assign) BOOL isAnimated;

+ (UIWindow *)windowForViewController:(UIViewController *)viewController;

@end
