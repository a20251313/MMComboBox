//
//  SDKNavigationController+SkipControl.h
//  FeiFan
//
//  Created by AKsoftware on 15/11/11.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import "SDKNavigationController.h"

@interface SDKNavigationController (SkipControl) <UINavigationControllerDelegate>

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
