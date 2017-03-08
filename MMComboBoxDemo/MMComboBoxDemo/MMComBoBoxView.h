//
//  MMComBoBoxView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"

@protocol MMComBoBoxViewDataSource;
@protocol MMComBoBoxViewDelegate;
@interface MMComBoBoxView : UIView
@property (nonatomic, weak) id<MMComBoBoxViewDataSource> dataSource;
@property (nonatomic, weak) id<MMComBoBoxViewDelegate> delegate;

- (void)reload;
- (void)dimissPopView;

@end

@protocol MMComBoBoxViewDataSource <NSObject>

@required;

/**
 有几列数据

 @param comBoBoxView MMComBoBoxView
 @return 列数
 */
- (NSUInteger)numberOfColumnsIncomBoBoxView :(MMComBoBoxView *)comBoBoxView;


/**
 每一列的第一行rootItem

 @param comBoBoxView MMComBoBoxView
 @param column 列
 @return rootItem（MMItem）
 */
- (MMItem *)comBoBoxView:(MMComBoBoxView *)comBoBoxView infomationForColumn:(NSUInteger)column;
@end

@protocol MMComBoBoxViewDelegate <NSObject>

@optional


/**
 用户选择或者确定了某一数据

 @param comBoBoxViewd MMComBoBoxView
 @param array 保存选中的MMItem选项
 @param index MMDropDownBox的index（当前选择的index）
 */
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index;
@end
