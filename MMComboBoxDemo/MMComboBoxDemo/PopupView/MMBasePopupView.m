//
//  MMBasePopupView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMBasePopupView.h"
#import "MMSingleFitlerView.h"
#import "MMMultiFitlerView.h"
#import "MMCombinationFitlerView.h"
#import "MMHeader.h"
#import "MMItem.h"
@interface MMBasePopupView ()

@end
@implementation MMBasePopupView
- (nullable id)initWithItem:(nullable MMItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
        
    }
    return self;
}

- (void)updateSelectPath
{
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.shadowView = [[UIControl alloc] init];
        self.shadowView.backgroundColor = [UIColor ff_colorWithHex:0x484848];
        self.selectedArray = [NSMutableArray array];
        self.temporaryArray = [NSMutableArray array];
    }
    return self;
}

+ (nullable MMBasePopupView *)getSubPopupView:(nullable MMItem *)item {
    MMBasePopupView *view;
    switch (item.displayType) {
        case MMPopupViewDisplayTypeNormal:
        case MMPopupViewDisplayTypeNormalCheck:
            view =  [[MMSingleFitlerView alloc] initWithItem:item];
            break;
        case MMPopupViewDisplayTypeMultilayer:
             view =  [[MMMultiFitlerView alloc] initWithItem:item];
            break;
        case MMPopupViewDisplayTypeFilters:
            view =  [[MMCombinationFitlerView alloc] initWithItem:item];
            break;
        default:
            break;
    }
    return view;
}

- (void)dismiss {

    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
}

- (void)dismissWithOutAnimation {
    
    
    [self.shadowView removeFromSuperview];
    self.shadowView = nil;
    if (self.superview) {
        [self removeFromSuperview];
    }
}

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion {
  //写这些方法是为了消除警告；
}

- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion  fromView:(nullable UIView*)superView
{
}


@end
