//
//  MMLayout.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/15.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MMItem;
#import "MMHeader.h"

@interface MMLayout : NSObject
@property (nonatomic, assign) CGFloat headerViewHeight;
@property (nonatomic, assign) CGFloat alternativeTitleHeight;
@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGFloat totalHeight;

@property (nonatomic, assign) NSInteger rowNumber;
@property (nonatomic, strong) NSMutableArray *cellLayoutTotalHeight;
@property (nonatomic, strong) NSMutableArray *cellCloseStateHeight;
@property (nonatomic, strong) NSMutableArray *cellLayoutTotalInfo;

+ (instancetype)layoutWithItem:(MMItem *)item;

+ (CGFloat)layoutItemWidth;

@end
