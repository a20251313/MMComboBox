//
//  NSArray+WDAdd.m
//  Pods
//
//  Created by fy on 16/2/23.
//
//

#import "NSArray+WDAdd.h"

@implementation NSArray (WDAdd)

- (NSString *)jsonStringEncoded {
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end
