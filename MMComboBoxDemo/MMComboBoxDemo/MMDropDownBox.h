//
//  MMDropDownBox.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMBaseItem.h"

@protocol MMDropDownBoxDelegate;

@interface MMDropDownBox : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelected;                 
@property (nonatomic, weak) id<MMDropDownBoxDelegate> delegate;
@property (nonatomic, assign) BOOL dotHide;
@property (nonatomic, assign) BOOL lineHide;
@property (nonatomic, strong) UIView *lineView;

- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title withIcon:(MMPopupViewIconType)iconType;
- (void)updateTitleState:(BOOL)isSelected;
- (void)updateTitleContent:(NSString *)title;

@end

@protocol MMDropDownBoxDelegate <NSObject>

- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index;

@end
