//
//  MMBasePopupView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MMItem;
@protocol MMPopupViewDelegate;
@interface MMBasePopupView : UIView 
@property (nullable, nonatomic, strong) MMItem *item;
@property (nonatomic, assign) CGRect sourceFrame;
@property (nullable, nonatomic, strong) UIView *shadowView;
@property (nullable, nonatomic, strong) UITableView *mainTableView;
@property (nullable, nonatomic, strong) UITableView *subTableView;
@property (nullable, nonatomic, strong) NSMutableArray *selectedArray;
@property (nullable, nonatomic, strong) NSArray *temporaryArray;


@property (nullable,nonatomic, weak) id<MMPopupViewDelegate> delegate;

+ (nullable MMBasePopupView *)getSubPopupView:(nullable MMItem *)item;
- (nullable id)initWithItem:(nullable MMItem *)item;
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion;
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion  fromView:(nullable UIView*)superView;
- (void)dismiss;
- (void)dismissWithOutAnimation;

@end

@protocol MMPopupViewDelegate <NSObject>

@optional

- (void)popupView:(nullable MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(nullable NSArray *)array atIndex:(NSUInteger)index;

@required

- (void)popupViewWillDismiss:(nullable MMBasePopupView *)popupView;

@end
