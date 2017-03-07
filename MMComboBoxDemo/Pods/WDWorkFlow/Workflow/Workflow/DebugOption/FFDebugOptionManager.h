//
//  FFDebugOptionManager.h
//  FeiFan
//
//  Created by fy on 16/2/2.
//  Copyright © 2016年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDebugOptionViewController.h"
#import "FFSingleton.h"
#import "FFTestLogManager.h"

#define DebugLog NSLog
//#define DebugLog(...) { \
//    if ([[[FFDebugOptionManager sharedInstance] debugOptionValueForKey:@"ScreenLog" ] boolValue]) \
//    { \
//        [[FFTestLogManager sharedInstance] addLogString:[NSString stringWithFormat:__VA_ARGS__]];\
//    } \
//    else \
//    { \
//        NSLog(__VA_ARGS__);\
//    }\
//}

#define NKey_DebugOptionKeyValueChanged @"NKey_DebugOptionKeyValueChanged"


@interface FFDebugOptionManager : NSObject

FF_AS_SINGLETON(FFDebugOptionManager)

@property (nonatomic, strong) NSArray <FFdebugOptionSectionModel *> *modelSectionArr;

- (BOOL)isOnline;

- (BOOL)isRelease;

- (NSNumber *)debugOptionValueForKey:(NSString *)keyName;

- (void)setDebugOptionValue:(NSNumber *)value forKey:(NSString *)keyName;

@end
