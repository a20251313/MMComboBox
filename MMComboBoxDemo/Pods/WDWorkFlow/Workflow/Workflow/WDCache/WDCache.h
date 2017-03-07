//
//  WDCache.h
//  FeiFan
//
//  Created by Gabriel Li on 7/21/15.
//  Copyright (c) 2015 Wanda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FFCacheDataModel : NSObject<NSCoding>

@property (nonatomic, strong) NSString *expiredTime;
@property (nonatomic, strong) NSString *indexedKey;
@property (nonatomic, strong) NSData *value;
@property (nonatomic, strong) NSDictionary *userInfo;

@end

@interface WDCache : NSObject

/** 当前缓存的数量
 **/
- (NSInteger)count;

/** 异步操作：添加key所指定的缓存，如果缓存已经存在，则更新内容
 **/
- (void)setCachedObject:(FFCacheDataModel *)cachedObject forKey:(id)key;

/** 同步操作：查找key所指定的缓存，如果不存在，返回nil
 **/
- (FFCacheDataModel *)cachedObjectForKey:(id)key;

/** 同步操作：删除key所指定的缓存œ
 **/
- (void)removeCachedObjectForKey:(id)key;

/** 同步操作：批量删除keys所指定的缓存
 **/
- (void)removeCachedObjectsForKeys:(NSArray *)keys;

/** 同步操作：删除指定日期以前的缓存
 **/
- (void)removeCachedObjectsBeforeDate:(NSDate *)date;

/** 同步操作：删除指定天数days以前的缓存
 **/
- (void)removeCachedObjectsOlderThanDays:(NSInteger)days;

/** 同步操作：清空缓存
 **/
- (void)removeAllObjects;

@end
