//
//  NSObject+AutoParser.h
//  AutoParser
//
//  Created by LiXiangCheng on 16/9/16.
//  Copyright (c) 2016年 Wanda Inc All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
//以下引用：SafeCategories
#import "NSArray+Safe.h"
#import "NSArray+WDAdd.h"
#import "NSMutableArray+Safe.h"
#import "NSData+WDAdd.h"
#import "NSDictionary+Safe.h"
#import "NSMutableDictionary+Safe.h"
#import "NSDictionary+WDAdd.h"
#import "NSManagedObject+Safe.h"
#import "NSNumber+Safe.h"
#import "NSObject+Safe.h"
#import "NSMutableSet+Safe.h"
#import "NSString+Safe.h"
#import "NSUserDefaults+Safe.h"

#define JSONInterface(klass) protocol klass <NSObject> @end\
@interface klass

#define JSONImplementation(klass) implementation klass \
- (void)encodeWithCoder:(NSCoder *)aCoder{ \
NSDictionary *propertysDic = [[self class] propertiesOfObject:self]; \
[propertysDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { \
id value=[self valueForKeyPath:key]; \
if (value!=nil) { \
[aCoder encodeObject:value forKey:key]; \
} \
}]; \
} \
- (id)initWithCoder:(NSCoder *)aDecoder \
{ \
self = [self init]; \
NSDictionary *propertysDic = [[self class] propertiesOfObject:self]; \
[propertysDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { \
id value=[aDecoder decodeObjectForKey:key]; \
if (value!=nil) { \
[self setValue:value forKeyPath:key]; \
} \
}]; \
return self; \
} \
- (id)copyWithZone:(NSZone *)zone{ \
id copy=[[self class] new]; \
NSDictionary *propertysDic = [[self class] propertiesOfObject:copy]; \
[propertysDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { \
id value=[self valueForKeyPath:key]; \
if (value!=nil) { \
[copy setValue:[value copyWithZone:zone] forKeyPath:key]; \
} \
}]; \
return copy; \
}

#define JSONArray(type) NSArray<type>
#define JSONMutableArray(type) NSMutableArray<type>

#define JSONSet(type) NSSet<type>
#define JSONMutableSet(type) NSMutableSet<type>

#define JSONOrderedSet(type) NSOrderedSet<type>
#define JSONMutableOrderedSet(type) NSMutableOrderedSet<type>

@protocol NSNumber <NSObject> @end
@protocol NSString <NSObject> @end
@protocol NSMutableString <NSObject> @end
@protocol NSDictionary <NSObject> @end
@protocol NSMutableDictionary <NSObject> @end

///------------------------------
/// @LiXiangCheng 20161022
/// readme:http://adhoc.qiniudn.com/README.html
/// GitHub:https://github.com/LarryPage/AutoParser
/// 最大缓存500个Model定义,1个model按10个左右属性，大约0.1K，500个model点内存50K
/// 实现 dictionary<->model json<->model
/// 实现 模型序列化存储、读取、copy 【NSCoding NSCopying】
/// 使用 WDSafeCategories保证每条数据安全解析
///------------------------------

/**
 support :variable type

 double
 float
 int
 bool
 BOOL
 NSInteger
 NSUInteger
 NSNumber *
 NSString * NSMutableString *
 NSDictionary * NSMutableDictionary *
 NSArray * NSMutableArray *
 NSSet * NSMutableSet *
 NSOrderedSet * NSMutableOrderedSet *
 ...
 and 自定义model类
 */
@interface NSObject (KVC)

/*!
 *  @brief dic转model
 *  readme:http://adhoc.qiniudn.com/README.html
 *
 *  @param dic  字典
 *
 *  @return model对象
 *
 *  @since 1.0
 */
- (id)initWithDic:(NSDictionary *)dic;


/*!
 *  @brief model转dic
 *  readme:http://adhoc.qiniudn.com/README.html
 *
 *  @return 字典
 *
 *  @since 1.0
 */
- (NSDictionary *)dic;


/*!
 *  @brief json字符串转model
 *
 *  @param json  json字符串
 *
 *  @return model对象
 *
 *  @since 1.0
 */
- (id)initWithJson:(NSString *)json;


/*!
 *  @brief model转json字符串
 *
 *  @return json字符串
 *
 *  @since 1.0
 */
- (NSString *)json;


/*!
 *  @brief 在propertyName与josnKeyName不一致时，要设置此类函数
 *
 *  @return 字典映射replacedKeyMap：{propertyName:jsonKeyName}
 *
 *  @since 1.0
 */
+ (NSDictionary *)replacedKeyMap;


/*!
 *  @brief model对象转属性字典
 *
 *  @param object  model对象
 *
 *  @return model属性字典
 *
 *  @since 1.0
 */
+ (NSDictionary *) propertiesOfObject:(id)object;


/*!
 *  @brief model类转属性字典
 *
 *  @param klass  model类
 *
 *  @return model属性字典
 *
 *  @since 1.0
 */
+ (NSDictionary *) propertiesOfClass:(Class)klass;


/*!
 *  @brief model类的子类转属性字典，支持递归(recursive)
 *
 *  @param klass  model类
 *
 *  @return model的子类属性字典
 *
 *  @since 1.0
 */
+ (NSDictionary *) propertiesOfSubclass:(Class)klass;
@end
