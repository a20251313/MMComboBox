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
@property (nullable, nonatomic, strong) UIControl *shadowView;
@property (nullable, nonatomic, strong) UITableView *mainTableView;
@property (nullable, nonatomic, strong) UITableView *subTableView;
@property (nullable, nonatomic, strong) NSMutableArray *selectedArray;
@property (nullable, nonatomic, strong) NSArray *temporaryArray;


@property (nullable,nonatomic, weak) id<MMPopupViewDelegate> delegate;

+ (nullable MMBasePopupView *)getSubPopupView:(nullable MMItem *)item;
- (nullable id)initWithItem:(nullable MMItem *)item;
- (void)popupViewFromView:(nullable UIView*)superView completion:(void (^ __nullable)(void))completion;

- (void)dismissWithCompletion:(void (^ __nullable)(void))completion;
- (void)dismissWithOutAnimation:(void (^ __nullable)(void))completion;
- (void)updateSelectPath;

@end

@protocol MMPopupViewDelegate <NSObject>

@optional

- (void)popupView:(nullable MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(nullable NSArray *)array atIndex:(NSUInteger)index;

@required

- (void)popupViewWillDismiss:(nullable MMBasePopupView *)popupView;
- (void)popupViewDidDismiss:(nullable MMBasePopupView *)popupView;

@end
