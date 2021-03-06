//
//  NSObject+AutoParser.m
//  AutoParser
//
//  Created by LiXiangCheng on 16/9/16.
//  Copyright (c) 2016年 Wanda Inc All rights reserved.
//

#import "NSObject+AutoParser.h"

/**
 缓存要解析的类的属性{"ClassName":propertiesDic}=Table scheme
 countLimit=500
 最大缓存500个Model定义,1个model按10个左右属性，大约0.1K，500个model点内存50K
 */
static NSCache *gPropertiesOfClass = nil;
/**
 缓存要解析的类中不一致的propertyName与josnKeyName
 countLimit=500
 最大缓存500个Model定义（同上）
 */
static NSCache *gReplacedKeyMapsOfClass = nil;

@implementation NSObject (KVC)

- (id)initWithDic:(NSDictionary *)dic{
    self = [self init];
    if (self) {
        if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
            return nil;
        }
        
        [NSObject KeyValueDecoderForObject:self dic:dic];
    }
    return self;
}

- (NSDictionary *)dic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [NSObject KeyValueEncoderForObject:self dic:dic];
    
    return dic;
}

- (id)initWithJson:(NSString *)json{
    NSError *error;
    NSData *data= [json dataUsingEncoding:NSUTF8StringEncoding];
    id jsonData = [NSJSONSerialization
                   JSONObjectWithData:data
                   options:NSJSONReadingMutableContainers
                   error:&error];
    if (error) {
        return nil;
    }
    
    if (![jsonData isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *dic = (NSDictionary *)jsonData;
    return [self initWithDic:dic];
}

- (NSString *)json{
    NSDictionary *dic=[self dic];

    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

+ (NSDictionary *)replacedKeyMap{
    return nil;
}

+ (NSDictionary *)replacedKeyMapOfClass:(Class)klass{
    //memory缓存
    if (!gReplacedKeyMapsOfClass) {
        gReplacedKeyMapsOfClass = [[NSCache alloc] init];
        gReplacedKeyMapsOfClass.name=@"AutuParser.ReplacedKeyMapsOfClass";
        gReplacedKeyMapsOfClass.countLimit=500;
    }
    NSMutableDictionary * map=[gReplacedKeyMapsOfClass objectForKey:NSStringFromClass(klass)];
    if (map) {
    }
    else{
        map = [NSMutableDictionary dictionary];
        [self replacedKeyMapForHierarchyOfClass:klass onDictionary:map];
        //CLog(@"%@:%@",NSStringFromClass(klass),map);
        [gReplacedKeyMapsOfClass setObject:map forKey:NSStringFromClass(klass)];
    }
    return map;
    
//    NSMutableDictionary *map = [NSMutableDictionary dictionary];
//    [self replacedKeyMapForHierarchyOfClass:klass onDictionary:map];
//    return [NSDictionary dictionaryWithDictionary:map];
}

+ (void)replacedKeyMapForHierarchyOfClass:(Class)class onDictionary:(NSMutableDictionary *)map{
    if (class == NULL) {
        return;
    }
    
    if (class == [NSObject class]) {
    }
    
    [self replacedKeyMapForHierarchyOfClass:[class superclass] onDictionary:map];
    
    [[class replacedKeyMap] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [map safeSetObject:obj forKey:key];
    }];
}

+ (void)KeyValueDecoderForObject:(id)object dic:(NSDictionary *)dic{
    NSDictionary *propertysDic = [self propertiesOfObject:object];
    NSDictionary *map = [self replacedKeyMapOfClass:[object class]];
    [propertysDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *jsonKeyName=(map && [map valueForKey:key])?[map valueForKey:key]:key;
        
        if ([obj isEqualToString:NSStringFromClass([NSString class])]) {
            id value= [NSString safeStringFromObject:[dic valueForKey:jsonKeyName]];
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSMutableString class])]) {
            id value=[NSMutableString safeStringFromObject:[dic valueForKey:jsonKeyName]];
            //value=(NSMutableString *)[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSDictionary class])]) {
            id value=[NSDictionary safeDictionaryFromObject:[dic valueForKey:jsonKeyName]];
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
            id value=[NSMutableDictionary safeDictionaryFromObject:[dic valueForKey:jsonKeyName]];
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSNumber class])]) {
            id value=[NSNumber safeNumberFromObject:[dic valueForKey:jsonKeyName]];
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_LNG_LNG]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_INT]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_LNG]]) {//NSInteger
            NSInteger value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] integerValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_ULNG_LNG]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_UINT]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_ULNG]]) {//NSUInteger
            NSUInteger value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] integerValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_DBL]]) {//double
            double value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] doubleValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_FLT]]) {//float
            float value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] floatValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_INT]]) {//int
            int value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] intValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_BOOL]]) {//bool,BOOL
            bool value=[[NSString safeStringFromObject:[dic valueForKey:jsonKeyName]] boolValue];
            [object setValue:@(value) forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSArray class])] || [obj isEqualToString:NSStringFromClass([NSMutableArray class])]) {
            NSMutableArray *value=[[NSMutableArray alloc] init];
            
            NSArray *records = [NSArray safeArrayFromObject:[dic valueForKey:jsonKeyName]];
            for (NSObject *record in records) {
                [value safeAddObject:record];
            }
            
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSSet class])] || [obj isEqualToString:NSStringFromClass([NSMutableSet class])]) {
            NSMutableSet *value=[[NSMutableSet alloc] init];
            
            id ret = [dic valueForKey:jsonKeyName];
            if ([ret isKindOfClass:[NSSet class]]) {
                NSSet *records = (NSSet *)ret;
                for (NSObject *record in records) {
                    [value safeAddObject:record];
                }
            }
            
            [object setValue:value forKeyPath:key];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSOrderedSet class])] || [obj isEqualToString:NSStringFromClass([NSMutableOrderedSet class])]) {
            NSMutableOrderedSet *value=[[NSMutableOrderedSet alloc] init];
            
            id ret = [dic valueForKey:jsonKeyName];
            if ([ret isKindOfClass:[NSOrderedSet class]]) {
                NSOrderedSet *records = (NSOrderedSet *)ret;
                for (NSObject *record in records) {
                    if (record) {
                        [value addObject:record];
                    }
                }
            }
            
            [object setValue:value forKeyPath:key];
        }
        else{//自定义class
            NSRegularExpression *arrayRegExp=[[NSRegularExpression alloc] initWithPattern:@"(?<=\\<).*?(?=\\>)" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *results=[arrayRegExp matchesInString:obj options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [obj length])];
            if (results.count>0) {
                NSTextCheckingResult *result=[results safeObjectAtIndex:0];
                NSRange range = result.range;
                NSString *className = [[obj substringToIndex:range.location-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *recordClassName = [[obj substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                id recordClass = NSClassFromString(recordClassName);
                if ([className isEqualToString:NSStringFromClass([NSArray class])] || [className isEqualToString:NSStringFromClass([NSMutableArray class])]) {
                    NSMutableArray *value=[[NSMutableArray alloc] init];
                    
                    NSArray *records = [NSArray safeArrayFromObject:[dic valueForKey:jsonKeyName]];
                    for (NSObject *record in records) {
                        if (!record) {
                            continue;
                        }
                        if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                            [value safeAddObject:[NSNumber safeNumberFromObject:record]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                            [value safeAddObject:[NSString safeStringFromObject:record]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                            [value safeAddObject:[NSMutableString safeStringFromObject:record]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                            [value safeAddObject:[NSDictionary safeDictionaryFromObject:record]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                            [value safeAddObject:[NSMutableDictionary safeDictionaryFromObject:record]];
                        }
                        else{
                            if ([record isKindOfClass:[NSDictionary class]]) {
                                if([recordClass instancesRespondToSelector:@selector(initWithDic:)]){
                                    [value safeAddObject:[[recordClass alloc] initWithDic:(NSDictionary *)record]];
                                }
                            }
                        }
                    }
                    
                    [object setValue:value forKeyPath:key];
                    return;
                }
                else if ([className isEqualToString:NSStringFromClass([NSSet class])] || [className isEqualToString:NSStringFromClass([NSMutableSet class])]) {
                    NSMutableSet *value=[[NSMutableSet alloc] init];
                    
                    id ret = [dic valueForKey:jsonKeyName];
                    if ([ret isKindOfClass:[NSSet class]]) {
                        NSSet *records = (NSSet *)ret;
                        for (NSObject *record in records) {
                            if (!record) {
                                continue;
                            }
                            if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                                [value safeAddObject:[NSNumber safeNumberFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                                [value safeAddObject:[NSString safeStringFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                                [value safeAddObject:[NSMutableString safeStringFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                                [value safeAddObject:[NSDictionary safeDictionaryFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                                [value safeAddObject:[NSMutableDictionary safeDictionaryFromObject:record]];
                            }
                            else{
                                if ([record isKindOfClass:[NSDictionary class]]) {
                                    if([recordClass instancesRespondToSelector:@selector(initWithDic:)]){
                                        [value safeAddObject:[[recordClass alloc] initWithDic:(NSDictionary *)record]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [object setValue:value forKeyPath:key];
                    return;
                }
                else if ([className isEqualToString:NSStringFromClass([NSOrderedSet class])] || [className isEqualToString:NSStringFromClass([NSMutableOrderedSet class])]) {
                    NSMutableOrderedSet *value=[[NSMutableOrderedSet alloc] init];
                    
                    id ret = [dic valueForKey:jsonKeyName];
                    if ([ret isKindOfClass:[NSOrderedSet class]]) {
                        NSOrderedSet *records = (NSOrderedSet *)ret;
                        for (NSObject *record in records) {
                            if (!record) {
                                continue;
                            }
                            if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                                [value addObject:[NSNumber safeNumberFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                                [value addObject:[NSString safeStringFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                                [value addObject:[NSMutableString safeStringFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                                [value addObject:[NSDictionary safeDictionaryFromObject:record]];
                            }
                            else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                                [value addObject:[NSMutableDictionary safeDictionaryFromObject:record]];
                            }
                            else{
                                if ([record isKindOfClass:[NSDictionary class]]) {
                                    if([recordClass instancesRespondToSelector:@selector(initWithDic:)]){
                                        [value addObject:[[recordClass alloc] initWithDic:(NSDictionary *)record]];
                                    }
                                }
                            }
                        }
                    }
                    
                    [object setValue:value forKeyPath:key];
                    return;
                }
            }
            
            id aClass = NSClassFromString(obj);
            if([aClass instancesRespondToSelector:@selector(initWithDic:)]){
                id value=[[aClass alloc] initWithDic:[dic valueForKey:jsonKeyName]];
                if (value) {
                    [object setValue:value forKeyPath:key];
                }
            }
        }
    }];
}

+ (void)KeyValueEncoderForObject:(id)object dic:(NSDictionary *)dic{
    NSDictionary *propertysDic = [self propertiesOfObject:object];
    NSDictionary *map = [self replacedKeyMapOfClass:[object class]];
    [propertysDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *jsonKeyName=(map && [map valueForKey:key])?[map valueForKey:key]:key;
        
        if ([obj isEqualToString:NSStringFromClass([NSString class])] || [obj isEqualToString:NSStringFromClass([NSMutableString class])]) {
            id value=[object valueForKeyPath:key];
            [dic setValue:(value?value:@"") forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSDictionary class])] || [obj isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
            id value=[object valueForKeyPath:key];
            [dic setValue:(value?value:[NSMutableDictionary dictionary]) forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSNumber class])]) {
            id value=[object valueForKeyPath:key];
            [dic setValue:value forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_LNG_LNG]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_INT]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_LNG]]) {//NSInteger
            NSInteger value=[[object valueForKeyPath:key] integerValue];
            [dic setValue:@(value) forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_ULNG_LNG]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_UINT]]
                 || [obj isEqualToString:[NSString stringWithFormat:@"%c",_C_ULNG]]) {//NSUInteger
            NSUInteger value=[[object valueForKeyPath:key] integerValue];
            [dic setValue:@(value) forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_DBL]]) {//double
            double value=[[object valueForKeyPath:key] doubleValue];
            [dic setValue:[NSString stringWithFormat:@"%0.6f", value] forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_FLT]]) {//float
            float value=[[object valueForKeyPath:key] floatValue];
            [dic setValue:[NSString stringWithFormat:@"%0.6f", value] forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_INT]]) {//int
            int value=[[object valueForKeyPath:key] intValue];
            [dic setValue:@(value) forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:[NSString stringWithFormat:@"%c",_C_BOOL]]) {//bool,BOOL
            bool value=[[object valueForKeyPath:key] boolValue];
            [dic setValue:@(value) forKeyPath:jsonKeyName];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSArray class])] || [obj isEqualToString:NSStringFromClass([NSMutableArray class])]) {
            NSMutableArray *value=[NSMutableArray array];
            
            NSArray *records=[object valueForKeyPath:key];
            [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSObject *record = (NSObject *)obj;
                [value safeAddObject:record];
            }];
            [dic setValue:value forKey:jsonKeyName];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSSet class])] || [obj isEqualToString:NSStringFromClass([NSMutableSet class])]) {
            NSMutableSet *value=[NSMutableSet set];
            
            NSSet *records=[object valueForKeyPath:key];
            [records enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                NSObject *record = (NSObject *)obj;
                [value safeAddObject:record];
            }];
            [dic setValue:value forKey:jsonKeyName];
        }
        else if ([obj isEqualToString:NSStringFromClass([NSOrderedSet class])] || [obj isEqualToString:NSStringFromClass([NSMutableOrderedSet class])]) {
            NSMutableOrderedSet *value=[NSMutableOrderedSet orderedSet];
            
            NSOrderedSet *records=[object valueForKeyPath:key];
            [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSObject *record = (NSObject *)obj;
                if (record) {
                    [value addObject:record];
                }
            }];
            [dic setValue:value forKey:jsonKeyName];
        }
        else{//自定义class
            NSRegularExpression *arrayRegExp=[[NSRegularExpression alloc] initWithPattern:@"(?<=\\<).*?(?=\\>)" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *results=[arrayRegExp matchesInString:obj options:NSMatchingWithTransparentBounds range:NSMakeRange(0, [obj length])];
            if (results.count>0) {
                NSTextCheckingResult *result=[results safeObjectAtIndex:0];
                NSRange range = result.range;
                NSString *className = [[obj substringToIndex:range.location-1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                NSString *recordClassName = [[obj substringWithRange:range] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                id recordClass = NSClassFromString(recordClassName);
                if ([className isEqualToString:NSStringFromClass([NSArray class])] || [className isEqualToString:NSStringFromClass([NSMutableArray class])]) {
                    NSMutableArray *value=[NSMutableArray array];
                    
                    NSArray *records=[object valueForKeyPath:key];
                    [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                            [value safeAddObject:obj];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                            [value safeAddObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                            [value safeAddObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                            [value safeAddObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                            [value safeAddObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else{
                            if([recordClass instancesRespondToSelector:@selector(dic)]){
                                [value safeAddObject:[obj dic]];
                            }
                        }
                    }];
                    
                    [dic setValue:value forKey:jsonKeyName];
                    return;
                }
                else if ([className isEqualToString:NSStringFromClass([NSSet class])] || [className isEqualToString:NSStringFromClass([NSMutableSet class])]) {
                    NSMutableSet *value=[NSMutableSet set];
                    
                    NSSet *records=[object valueForKeyPath:key];
                    [records enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                        if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                            [value safeAddObject:obj];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                            [value safeAddObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                            [value safeAddObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                            [value safeAddObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                            [value safeAddObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else{
                            if([recordClass instancesRespondToSelector:@selector(dic)]){
                                [value safeAddObject:[obj dic]];
                            }
                        }
                    }];
                    
                    [dic setValue:value forKey:jsonKeyName];
                    return;
                }
                else if ([className isEqualToString:NSStringFromClass([NSOrderedSet class])] || [className isEqualToString:NSStringFromClass([NSMutableOrderedSet class])]) {
                    NSMutableOrderedSet *value=[NSMutableOrderedSet orderedSet];
                    
                    NSOrderedSet *records=[object valueForKeyPath:key];
                    [records enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        if ([recordClassName isEqualToString:NSStringFromClass([NSNumber class])]) {
                            [value addObject:obj];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSString class])]) {
                            [value addObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableString class])]) {
                            [value addObject:obj?obj:@""];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSDictionary class])]) {
                            [value addObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else if ([recordClassName isEqualToString:NSStringFromClass([NSMutableDictionary class])]) {
                            [value addObject:obj?obj:[NSMutableDictionary dictionary]];
                        }
                        else{
                            if([recordClass instancesRespondToSelector:@selector(dic)]){
                                [value addObject:[obj dic]];
                            }
                        }
                    }];
                    
                    [dic setValue:value forKey:jsonKeyName];
                    return;
                }
            }
            
            id aClass = NSClassFromString(obj);
            if([aClass instancesRespondToSelector:@selector(dic)]){
                NSDictionary *value=[[object valueForKeyPath:key] dic];
                [dic setValue:value?value:[NSDictionary dictionary] forKey:jsonKeyName];
            }
        }
    }];
}

//http://stackoverflow.com/questions/754824/get-an-object-properties-list-in-objective-c
static const char *getPropertyType(const char *attributes) {
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {//strsep:分解字符串为一组字符串
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            /*
             if you want a list of what will be returned for these primitives, search online for
             "objective-c" "Property Attribute Description Examples"
             apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
             */
            //return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            //return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}

//recursive
+ (NSDictionary *) propertiesOfObject:(id)object
{
    Class class = [object class];
    return [self propertiesOfClass:class];
}

+ (NSDictionary *) propertiesOfClass:(Class)klass
{
    //memory缓存
    if (!gPropertiesOfClass) {
        gPropertiesOfClass = [[NSCache alloc] init];
        gPropertiesOfClass.name=@"AutuParser.PropertiesOfClass";
        gPropertiesOfClass.countLimit=500;
    }
    NSMutableDictionary * properties=[gPropertiesOfClass objectForKey:NSStringFromClass(klass)];
    if (properties && properties.count>0) {
    }
    else{
        properties = [NSMutableDictionary dictionary];
        [self propertiesForHierarchyOfClass:klass onDictionary:properties];
        //CLog(@"%@:%@",NSStringFromClass(klass),properties);
        [gPropertiesOfClass setObject:properties forKey:NSStringFromClass(klass)];
    }
    return properties;
    
//    NSMutableDictionary * properties = [NSMutableDictionary dictionary];
//    [self propertiesForHierarchyOfClass:klass onDictionary:properties];
//    return [NSDictionary dictionaryWithDictionary:properties];
}

+ (NSDictionary *) propertiesOfSubclass:(Class)klass
{
    if (klass == NULL) {
        return nil;
    }
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    return [self propertiesForSubclass:klass onDictionary:properties];
}

+ (NSMutableDictionary *)propertiesForHierarchyOfClass:(Class)class onDictionary:(NSMutableDictionary *)properties
{
    if (class == NULL) {
        return nil;
    }
    
    if (class == [NSObject class]) {
        // On reaching the NSObject base class, return all properties collected.
        return properties;
    }
    
    // Collect properties from the current class.
    [self propertiesForSubclass:class onDictionary:properties];
    
    // Collect properties from the superclass.
    return [self propertiesForHierarchyOfClass:[class superclass] onDictionary:properties];
}

+ (NSMutableDictionary *) propertiesForSubclass:(Class)class onDictionary:(NSMutableDictionary *)properties
{
    unsigned int outCount, i;
    objc_property_t *objcProperties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = objcProperties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *attributes = property_getAttributes(property);
            //printf("attributes=%s\n", attributes);
            NSArray *attrs = [@(attributes) componentsSeparatedByString:@","];
            if (attrs.count>1) {
                NSString *propRight=attrs[1];//C:copy &:retain|readWrite R:readonly N:nonatomic
                if (![propRight isEqualToString:@"R"]) {
                    const char *propType = getPropertyType(attributes);
                    NSString *propertyName = [NSString stringWithUTF8String:propName];
                    NSString *propertyType = [NSString stringWithUTF8String:propType];
                    [properties setObject:propertyType forKey:propertyName];
                }
            }
            
        }
    }
    free(objcProperties);
    
    return properties;
}
@end
