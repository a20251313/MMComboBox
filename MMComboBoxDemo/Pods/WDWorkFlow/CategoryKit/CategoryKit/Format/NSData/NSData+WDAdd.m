//
//  NSData+WDAdd.m
//  Pods
//
//  Created by fy on 16/2/23.
//
//

#import "NSData+WDAdd.h"

@implementation NSData (WDAdd)

- (id)jsonValueDecoded {
    NSError *error = nil;
    id value = [NSJSONSerialization JSONObjectWithData:self options:kNilOptions error:&error];
    if (error) {
        NSLog(@"jsonValueDecoded error:%@", error);
    }
    return value;
}

@end
