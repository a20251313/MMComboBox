//
//  NSMutableArray+Sort.h
//  Pods
//
//  Created by dash on 16/2/15.
//
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Sort)

/**
 交换NSMutableArray中两个元素的位置

 @param fromIndex 需要调换的第一个下标
 @param toIndex   需要调换的第二个下标
 */
- (void)moveObjectFromIndex:(NSInteger)fromIndex
                    toIndex:(NSInteger)toIndex;

@end
