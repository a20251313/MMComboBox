//
//  MMLayout.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/15.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMLayout.h"
#import "MMItem.h"


@interface MMLayout ()

@property(nonatomic,assign)CGFloat  layItemWidth;

@end

@implementation MMLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        self.cellLayoutTotalHeight = [NSMutableArray array];
        self.cellLayoutTotalInfo = [NSMutableArray array];
        
        self.layItemWidth = (kScreenWidth-4*ItemHorizontalMargin)/4;
        self.rowNumber = 4;//(kScreenWidth - 2*ItemHorizontalMargin)/(ItemWidth + ItemHorizontalDistance);
        
        [self _initUI];
    }
    return self;
}

- (void)_initUI {
    
}

+ (instancetype)layoutWithItem:(MMItem *)item {
    MMLayout *layout = [[MMLayout alloc] init];
    layout.headerViewHeight = item.alternativeArray.count * (2*AlternativeTitleVerticalMargin + AlternativeTitleHeight);
    layout.totalHeight += layout.headerViewHeight;
    for (int i = 0; i < item.childrenNodes.count; i++) {
        MMItem *subItem = item.childrenNodes[i];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:subItem.childrenNodes.count];
        CGFloat totalCellHeight = 2*TitleVerticalMargin + ItemHeight;
        NSInteger columnNumber = MAX(1,subItem.childrenNodes.count /layout.rowNumber + ((subItem.childrenNodes.count %layout.rowNumber)?1:0));
        totalCellHeight += columnNumber*(ItemHeight + TitleVerticalMargin);
        [layout.cellLayoutTotalHeight addObject:@(totalCellHeight)];
        layout.totalHeight += totalCellHeight;
        //布局
        for (int j = 0; j < columnNumber; j ++){
            if ( j ==  columnNumber -1) {
                for (int k = 0; k < (subItem.childrenNodes.count %layout.rowNumber?subItem.childrenNodes.count%layout.rowNumber:layout.rowNumber) ; k++) {
                    [array addObject:@[@(k*(layout.layItemWidth + ItemHorizontalDistance) + ItemHorizontalMargin),@((2*TitleVerticalMargin + ItemHeight) + j*(ItemHeight + TitleVerticalMargin))]];
                }
            }else {
                for (int m = 0; m < layout.rowNumber; m++) {
                    [array addObject:@[@(m*(layout.layItemWidth + ItemHorizontalDistance) + ItemHorizontalMargin),@((2*TitleVerticalMargin + ItemHeight) + j*(ItemHeight + TitleVerticalMargin))]];
                }
            }
        }
        [layout.cellLayoutTotalInfo addObject:array];
    }
    return  layout;
}

@end
