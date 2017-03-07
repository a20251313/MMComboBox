//
//  WDCache.m
//  FeiFan
//
//  Created by Gabriel Li on 7/21/15.
//  Copyright (c) 2015 Wanda. All rights reserved.
//

#import "WDCache.h"
#include <mach/mach_time.h>
#import "YYCache/YYCache.h"

typedef NS_ENUM(NSInteger, LLCacheStoreBackendType) {
    kLLCacheStoreBackendTypeYYCache = 0,
    kLLCacheStoreBackendTypeCoreData = 1,
};


@implementation FFCacheDataModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        _expiredTime =  [aDecoder decodeObjectForKey:@"_expiredTime"];
        _indexedKey = [aDecoder decodeObjectForKey:@"_indexedKey"];
        _userInfo = [aDecoder decodeObjectForKey:@"_userInfo"];
        
        if ([aDecoder containsValueForKey:@"_value"]) {
            NSUInteger length = 0;
            const uint8_t *bytes = [aDecoder decodeBytesForKey:@"_value" returnedLength:&length];
            _value = [NSData dataWithBytes:bytes length:length];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_expiredTime forKey:@"_expiredTime"];
    [aCoder encodeObject:_indexedKey forKey:@"_indexedKey"];
    [aCoder encodeBytes:_value.bytes length:_value.length forKey:@"_value"];
    [aCoder encodeObject:_userInfo forKey:@"_userInfo"];
}

@end


@interface WDCache ()
@property (nonatomic, strong) YYCache *yycache;
@property (nonatomic) LLCacheStoreBackendType backendType;
@end

@implementation WDCache

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backendType = kLLCacheStoreBackendTypeYYCache;
    }
    return self;
}

- (NSInteger)count
{
    NSInteger cnt = 0;
    
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        cnt = self.yycache.diskCache.totalCount;
    }
    return cnt;
}

- (void)setCachedObject:(FFCacheDataModel *)cachedObject forKey:(id)key
{
    if (!key || !cachedObject) {
        return;
    }
    
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        [self.yycache setObject:cachedObject forKey:key];
    }
}

- (FFCacheDataModel *)cachedObjectForKey:(id)key
{
    FFCacheDataModel *model = nil;
    
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        model = (FFCacheDataModel *)[self.yycache objectForKey:key];
    }
    return model;
}

#pragma mark - 删除

- (void)removeAllObjects
{
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        [self.yycache removeAllObjects];
    }
}

- (void)removeCachedObjectForKey:(id)key
{
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        [self.yycache removeObjectForKey:key];
    }
}

- (void)removeCachedObjectsForKeys:(NSArray *)keys
{
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        for (id key in keys) {
            [self.yycache removeObjectForKey:key];
        }
    }
}

- (void)removeCachedObjectsBeforeDate:(NSDate *)date
{
    if (self.backendType == kLLCacheStoreBackendTypeYYCache)
    {
        [self.yycache.diskCache trimToAge:[date timeIntervalSince1970]];
    }
}


- (void)removeCachedObjectsOlderThanDays:(NSInteger)days
{
    NSDate *expiredDate = [[NSDate date] dateByAddingTimeInterval:(-days*86400)];
    [self removeCachedObjectsBeforeDate:expiredDate];
}


#pragma mark - Property
- (YYCache *)yycache
{
    if (!_yycache)
    {
        _yycache = [[YYCache alloc] initWithName:@"LLCacheStore"];
        _yycache.memoryCache.ageLimit = 3600;
        _yycache.memoryCache.autoTrimInterval = 30;
        _yycache.diskCache.ageLimit = 86400 * 7;
        _yycache.diskCache.freeDiskSpaceLimit = 200 * 1024 * 1024;
    }
    return _yycache;
}
@end
