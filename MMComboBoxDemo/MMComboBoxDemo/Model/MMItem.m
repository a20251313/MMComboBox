//
//  MMItem.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMItem.h"
#import "MMLayout.h"
#import "MMSelectedPath.h"


static const void *kMMKeyKey = &kMMKeyKey;
static const void *kMMCodeKey = &kMMCodeKey;

@implementation MMItem
#pragma mark - init method


- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, kMMKeyKey, key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //[self setValue:key forKey:@"key"];
}

- (NSString*)key
{
    return objc_getAssociatedObject(self, kMMKeyKey);

}

- (void)setCode:(NSString *)code
{
     objc_setAssociatedObject(self, kMMCodeKey,code, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
 //   [self setValue:code forKey:@"code"];
}

- (NSString*)code
{
    return objc_getAssociatedObject(self, kMMCodeKey);
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.alternativeArray = [NSMutableArray array];
        self.childrenNodes = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title subTileName:(NSString *)subTile{
    MMItem *item = [MMItem itemWithItemType:type titleName:title];
    if (subTile != nil) {
        item.subTitle = subTile;
    }
    
    return item;
}

+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title {
    MMItem *item = [[[self class] alloc] init];
    item.markType = type;
    item.title = title;
    
    return item;
}


+ (instancetype)itemWithItemType:(MMPopupViewMarkType)type titleName:(NSString *)title iconType:(MMPopupViewIconType)iconType
{
    MMItem *item = [self itemWithItemType:type titleName:title];
    item.iconType = iconType;
    return item;
}

#pragma mark - public method
- (void)addNode:(MMItem *)node {
    NSParameterAssert(node);
    node.isSelected = (self.childrenNodes.count == 0) ? YES : NO;
    [self.childrenNodes addObject:node];
}

- (void)addNodeWithoutMark:(MMItem *)node {
    NSParameterAssert(node);
    node.isSelected = NO;
    [self.childrenNodes addObject:node];
}



- (void)findTheTypeOfPopUpView {
    if (self.alternativeArray.count || self.displayType == MMPopupViewDisplayTypeFilters) {
        self.displayType = MMPopupViewDisplayTypeFilters;
        self.layout = [MMLayout layoutWithItem:self];
        for (int i = 0; i < self.childrenNodes.count; i++) {
            MMItem *subItem = self.childrenNodes[i];
            subItem.layout = [[MMLayout alloc] init];
            [subItem.layout.cellLayoutTotalInfo addObjectsFromArray:self.layout.cellLayoutTotalInfo[i]];
        }
        return;
    }
    for (MMItem *item in self.childrenNodes) { //目前只支持两层 所以不需要去做递归
        if (item.childrenNodes.count != 0) {
            self.displayType = MMPopupViewDisplayTypeMultilayer;
            return;
        }
    }
}


- (NSString *)findTitleBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.secondPath != -1) {
        return [self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath] title];
    }
    return [self.childrenNodes[selectedPath.firstPath] title];
}



/**
 根据选择path返回当前选中item

 @param selectedPath MMSelectedPath
 @return MMItem
 */
- (MMItem *)findItemBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.secondPath != -1) {
        return self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath];
    }
    return self.childrenNodes[selectedPath.firstPath];
}




/**
 根据selectedPath获取code值，请确保code值唯一

 @param selectedPath  MMSelectedPath
 @return code值
 */
- (NSString *)findCodeBySelectedPath:(MMSelectedPath *)selectedPath {
    if (selectedPath.secondPath != -1) {
        return [self.childrenNodes[selectedPath.firstPath].childrenNodes[selectedPath.secondPath] code];
    }
    return [self.childrenNodes[selectedPath.firstPath] code];
}



/**
 根据code值设置某一选项为选中
 
 @param code code值
 */
- (void)setSubItemSelectAccordCode:(NSString*)code
{
    for (MMItem *item in self.childrenNodes) {
        if ([item.code isEqualToString:code]) {
            [item setIsSelected:YES];
        }
        for (MMItem *subitem in item.childrenNodes) {
            if ([subitem.code isEqualToString:code]) {
                [subitem setIsSelected:YES];
            }
        }
    }
    
}


/**
 设置所有子选项的选中状态

 @param selected 是否选中
 */
- (void)setAllSubItemSelected:(BOOL)selected
{
    for (MMItem *item in self.childrenNodes) {
        item.isSelected = selected;
        for (MMItem *subitem in subitem.childrenNodes) {
            subitem.isSelected = selected;
        }
    }
    
}

@end
