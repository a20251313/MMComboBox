//
//  MMBaseItem.h
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import <Foundation/Foundation.h>
//这个字段我们暂时留着以后扩展，覆盖可能要有些选项不能选择，显示灰色的情况
typedef NS_ENUM(NSUInteger, MMPopupViewMarkType) {  //选中的状态
    MMPopupViewDisplayTypeSelected = 0,      //可以选中
    MMPopupViewDisplayTypeUnselected = 1,    //不可以选中
};

typedef NS_ENUM(NSUInteger, MMPopupViewSelectedType) {     //是否支持单选或者多选
    MMPopupViewSingleSelection,                            //单选
    MMPopupViewMultilSeMultiSelection,                    //多选
};

typedef NS_ENUM(NSUInteger, MMPopupViewDisplayType) {  //分辨弹出来的view类型
    MMPopupViewDisplayTypeNormal = 0,                //一层
    MMPopupViewDisplayTypeMultilayer = 1,            //两层
    MMPopupViewDisplayTypeFilters = 2,               //混合
    MMPopupViewDisplayTypeNormalCheck = 3,                //一层的check类型
};


typedef NS_ENUM(NSInteger, MMPopupViewIconType) {  //筛选层附加icon定义
    MMPopupViewNoneIcon = 0,                //没有图标
    MMPopupViewLocationIcon = 1,                //位置图标  //kLocationIcon
    MMPopupViewSortIcon = 2,            //排序图标  //kSortedIcon
    MMPopupViewTypeIcon = 3,               //类型图标 //kTypeIcon
    MMPopupViewFilterIcon = 4,               //筛选图标 //kFilterIcon
};

@interface MMBaseItem : NSObject

@property (nonatomic, assign) MMPopupViewMarkType markType;
@property (nonatomic, assign) MMPopupViewDisplayType displayType;
@property (nonatomic, assign) MMPopupViewSelectedType selectedType;
@property (nonatomic, assign) MMPopupViewIconType iconType;

@property (nonatomic, assign) BOOL hasAllFuntion; //是否有全部按钮  默认为YES
@property (nonatomic, assign) BOOL isOpen; //全部的item是否显示，只有hasAllFuntion为YES的时候才起作用，默认为NO

@end
