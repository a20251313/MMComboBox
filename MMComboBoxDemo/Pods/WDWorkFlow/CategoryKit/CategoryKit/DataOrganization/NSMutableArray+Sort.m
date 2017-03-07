//
//  NSMutableArray+Sort.m
//  Pods
//
//  Created by dash on 16/2/15.
//
//

#import "NSMutableArray+Sort.h"

@implementation NSMutableArray(Sort)

/**
 交换NSMutableArray中两个元素的位置
 
 @param fromIndex 需要调换的第一个下标
 @param toIndex   需要调换的第二个下标
 */
- (void)moveObjectFromIndex:(NSInteger)fromIndex
                    toIndex:(NSInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    if (fromIndex >= self.count
        || toIndex >= self.count) {
        return;
    }
    id obj = [self objectAtIndex:fromIndex];
    [self removeObjectAtIndex:fromIndex];
    if (toIndex >= self.count) {
        [self addObject:obj];
    } else {
        [self insertObject:obj atIndex:toIndex];
    }
}

@end
