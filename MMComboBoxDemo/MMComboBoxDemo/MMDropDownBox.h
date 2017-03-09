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


/**
 初始化本身，当前图标仅支持iconfont类型，默认支持四种

 @param frame frame
 @param title 默认标题
 @param iconType MMPopupViewIconType
 @return MMDropDownBox单例
 */
- (id)initWithFrame:(CGRect)frame titleName:(NSString *)title withIcon:(MMPopupViewIconType)iconType;


/**
 当前这个函数没有作用

 @param isSelected 根据选中状态更改title的颜色什么的，内部无实现（now）
 */
- (void)updateTitleState:(BOOL)isSelected;


/**
 更改当前title内容

 @param title title
 */
- (void)updateTitleContent:(NSString *)title;

@end

@protocol MMDropDownBoxDelegate <NSObject>

/**
 用户点击了某个dropDownBox

 @param dropDownBox MMDropDownBox
 @param index dropDownBox的index，从0开始
 */
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index;

@end
