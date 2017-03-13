//
//  MMComBoBoxView.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMItem.h"


typedef NS_ENUM(NSUInteger, MMComBoBoxViewShowActionType) {  //分辨弹出框的动作
    MMComBoBoxViewShowActionTypePop = 0,                //弹出弹出框
    MMComBoBoxViewShowActionTypePackUp = 1,            //收起弹出框
};






@protocol MMComBoBoxViewDataSource;
@protocol MMComBoBoxViewDelegate;
@interface MMComBoBoxView : UIView
@property (nonatomic, weak) id<MMComBoBoxViewDataSource> dataSource;
@property (nonatomic, weak) id<MMComBoBoxViewDelegate> delegate;




/**
 根据boxValues 设置当前筛选项的title，以及当前选中的值
 
 @param boxValues MMComBoxOldValue
 */
- (void)updateValueWithData:(NSArray <MMComBoxOldValue>*)boxValues;

/**
 清除所有当前的选择
 */
- (void)cleanAllChoice;

/**
 重载数据
 */
- (void)reload;


/**
 收起下拉框
 */
- (void)dimissPopView;


/**
 初始化MMComBoBoxView

 @param frame frame
 @param spaceMargin 上下留白的距离`
 @return MMComBoBoxView
 */
- (id)initWithFrame:(CGRect)frame spaceToTop:(CGFloat)spaceMargin;

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



/**
  用户弹出下拉框或者收起下拉框的消息

 @param comBoBoxViewd MMComBoBoxView
 @param action 弹出框是弹出还是收起
 @param index MMDropDownBox的index（当前选择收起或者弹出的index）
 */
- (void)comBoBoxView:(MMComBoBoxView *)comBoBoxViewd actionType:(MMComBoBoxViewShowActionType)action atIndex:(NSUInteger)index;


@end
