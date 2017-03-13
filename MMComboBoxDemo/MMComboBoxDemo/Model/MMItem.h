//
//  MMItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMBaseItem.h"
@class MMSelectedPath;
@class MMLayout;
#import "MMLayout.h"

@protocol MMComBoxOldValue <NSObject>

@property(nonatomic,copy)NSString   *key;
@property(nonatomic,copy)NSString   *code;//如果有多个，默认以逗号分隔

@end

@interface MMItem : MMBaseItem<MMComBoxOldValue>
@property (nonatomic, copy) NSString *code;      //支持有的需要上传code而不是title,飞凡项目中定义为选中时需要上传的参数值
@property (nonatomic, copy) NSString *key;       //定义一个单独的同一属性的唯一标识，飞凡项目中定义为参数名
@property (nonatomic, copy) NSString *title;      //定义一个title 用于显示
@property (nonatomic, strong) NSMutableArray <MMItem *> *childrenNodes;     
@property (nonatomic, strong) NSMutableArray *alternativeArray;         //当有这种的类型则一定为MMPopupViewDisplayTypeFilters类型
@property (nonatomic, assign) BOOL isSelected;                          //默认0
@property (nonatomic, strong) NSString *subTitle;                       //第一层默认没有
@property (nonatomic, strong) MMLayout *layout;



/**
添加子item，如果之前没有子item，子item设置为选中状态
 @param node 子item
 */
- (void)addNode:(MMItem *)node;

/**

 添加子item，子item设置为非选中状态（isSelected == NO）
 @param node node
 */
- (void)addNodeWithoutMark:(MMItem *)node;


/**
 重新定义各个PopUpView的展现方式
 */
- (void)findTheTypeOfPopUpView;


/**
 根据MMSelectedPath获取title

 @param selectedPath  selectedPath
 @return title值
 */
- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath;



/**
 根据selectedPath获取code值，请确保code值唯一
 
 @param selectedPath  MMSelectedPath
 @return code值
 */
- (NSString *)findCodeBySelectedPath:(MMSelectedPath *)selectedPath;

/**
 根据选择path返回当前选中item
 
 @param selectedPath MMSelectedPath
 @return MMItem
 */
- (MMItem *)findItemBySelectedPath:(MMSelectedPath *)selectedPath;

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title;
+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title iconType:(MMPopupViewIconType)iconType;
+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title subTileName:(NSString *)subTile;



/**
 根据code值设置某一选项为选中,请保证所有itemcode选项唯一性，否则所有code相同选项都要被选中
 
 @param code code值
 */
- (void)setSubItemSelectAccordCode:(NSString*)code;

/**
 设置所有子选项的选中状态
 
 @param selected 是否选中
 */
- (void)setAllSubItemSelected:(BOOL)selected;
@end
