//
//  NSUserDefaults+Safe.h
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Safe)

/**
 NSUserDefaults的保护设置

 @param anObject 传入对象
 @param aKey     key值
 */
- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey;

@end
