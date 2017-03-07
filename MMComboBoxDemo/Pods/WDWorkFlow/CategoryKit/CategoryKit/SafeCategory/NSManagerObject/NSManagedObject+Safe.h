//
//  NSManagedObject+Safe.h
//  FeiFan
//
//  Created by 李魁峰 on 15/11/2.
//  Copyright © 2015年 Wanda Inc. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Safe)

/**
 coredata的safe方法

 @param anObject 传入对象
 @param aKey     key值
 */
- (void)safeSetObject:(id)anObject forKey:(NSString *)aKey;
@end
