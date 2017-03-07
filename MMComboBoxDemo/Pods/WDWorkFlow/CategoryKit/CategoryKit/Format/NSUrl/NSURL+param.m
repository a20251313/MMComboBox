//
//  NSURL+param.m
//  WDWorkFlow
//
//  Created by 李魁峰 on 16/8/10.
//  Copyright © 2016年 李魁峰. All rights reserved.
//

#import "NSURL+param.h"
#import "NSArray+Safe.h"
#import "NSString+Format.h"
#import "NSMutableDictionary+Safe.h"

@implementation NSURL (param)
/**
 获取URL协议
 
 @return NSString
 */
- (NSString *)protocol {
    if (NSNotFound != [self.absoluteString rangeOfString:@"://"].location) {
        return [self.absoluteString substringToIndex:([self.absoluteString rangeOfString:@"://"].location)];
    }
    return @"";
}

- (NSDictionary *)params {
    NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
    if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
        NSString *paramString = [self.absoluteString substringFromIndex:([self.absoluteString rangeOfString:@"?"].location + 1)];
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&"];
        NSScanner* scanner = [[NSScanner alloc] initWithString:paramString];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair safeObjectAtIndex:0] urldecode];
                NSString* value = [[kvPair safeObjectAtIndex:1] urldecode];
                [pairs safeSetObject:value forKey:key];
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:pairs];
}
/**
 拼接参数
 
 @param params 参数
 
 @return NSURL
 */
- (NSURL *)addParams:(NSDictionary *)params {
    NSMutableString *_add = nil;
    if (NSNotFound != [self.absoluteString rangeOfString:@"?"].location) {
        _add = [NSMutableString stringWithString:@"&"];
    }else {
        _add = [NSMutableString stringWithString:@"?"];
    }
    for (NSString* key in [params allKeys]) {
        if ([params objectForKey:key] && 0 < [[params objectForKey:key] length]) {
            [_add appendFormat:@"%@=%@&",key,[[params objectForKey:key] urlencode]];
        }
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.absoluteString,[_add substringToIndex:[_add length] - 1]]];
}
@end
