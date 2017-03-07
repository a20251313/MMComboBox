//
//  FFTestLogManager.h
//  FeiFan
//
//  Created by fy on 15/12/16.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFTestLogWindow.h"
#import "FFSingleton.h"

@interface FFTestLogManager : NSObject
FF_AS_SINGLETON(FFTestLogManager)
@property (nonatomic, strong , readonly)NSMutableArray *logArray;
- (void)load;
- (void)showLogOnScreen;
- (void)closeLogOnScreen;
- (void)addLogString:(NSString *)string;
- (void)clean;

@end
