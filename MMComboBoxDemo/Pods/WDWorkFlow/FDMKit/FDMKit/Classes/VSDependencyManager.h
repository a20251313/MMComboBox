//
//  VSDependencyManage.h
//  VSReplaceMethod
//
//  Created by YaoMing on 14-3-24.
//  Copyright (c) 2014年 YaoMing. All rights reserved.
//

#import <Foundation/Foundation.h>
@class VSDependencyObject;
@interface VSDependencyManager : NSObject
+ (VSDependencyManager *)shareInstance;
- (void)addObserver:(id)observer source:(id)source;
- (void)addObserver:(id)observer keySource:(VSDependencyObject *)keySource;
- (void)removeObserver:(id)observer;
- (void)removeObserverAll:(id)observer;
- (void)start;
- (BOOL)observer:(id)observer inkeySource:(id)keySource keyPath:(NSString*)path;
- (BOOL)observerremove:(id)observer inkeySource:(id)keySource keyPath:(NSString*)path;


/*
 *  目前只处理UIView或其子类,UIViewController或其子类
 */
- (BOOL)isManagerObject:(id)object;
@end
