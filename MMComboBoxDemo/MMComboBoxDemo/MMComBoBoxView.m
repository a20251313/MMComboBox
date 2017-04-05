//
//  MMComBoBoxView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/7.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMComBoBoxView.h"
#import "MMDropDownBox.h"
#import "MMHeader.h"
#import "MMBasePopupView.h"
#import "MMSelectedPath.h"

@interface MMComBoBoxView () <MMDropDownBoxDelegate,MMPopupViewDelegate>

@property (nonatomic, strong) NSMutableArray *dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *symbolArray;  //当成一个队列来标记那个弹出视图
@property (nonatomic, strong) MMBasePopupView *popupView;
@property (nonatomic, strong) UIView          *topBgView;
@property (nonatomic, assign) CGFloat         spaceMargin;
@property (nonatomic, assign) BOOL            isAnimation;

@end

@implementation MMComBoBoxView

- (id)initWithFrame:(CGRect)frame spaceToTop:(CGFloat)spaceMargin{
    self = [super initWithFrame:frame];
    if (self) {
        self.spaceMargin = spaceMargin;
        [self initize];
    }
    return self;
}

- (void)initize
{
    self.dropDownBoxArray = [NSMutableArray array];
    self.itemArray = [NSMutableArray array];
    self.symbolArray = [NSMutableArray arrayWithCapacity:1];
    self.backgroundColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    [self addSubview:self.topBgView];
    self.topBgView.backgroundColor = [UIColor whiteColor];
    [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_offset(-10);
        make.top.mas_equalTo(self.spaceMargin);
        make.bottom.mas_offset(-self.spaceMargin);
    }];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initize];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.topBgView.layer.cornerRadius = self.topBgView.ff_height/2;
}

- (UIView*)topBgView
{
    if (_topBgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderWidth = 1;
        bgView.layer.cornerRadius = 25;
        bgView.layer.borderColor = [UIColor clearColor].CGColor;
        bgView.backgroundColor = [UIColor clearColor];
        _topBgView = bgView;
    }
    
    return _topBgView;
}

-(NSString*)getSelectTitle:(MMItem*)item boxArray:(NSArray *)boxValues
{
    NSString  *subTitle = nil;
    for (id<MMComBoxOldValue> box in boxValues) {
        if (([item.key isEqualToString:[box key]] && item.key2 == nil)
            || ([item.key2 isEqualToString:[box key2]] && [item.key isEqualToString:[box key]])) {
            NSArray *codeArray = [[box code] componentsSeparatedByString:@","];
            NSArray *code2Array = [[box code2] componentsSeparatedByString:@","];
            for (NSString *code in codeArray) {
                if ([code isEqualToString:item.code]) {
                    if (code2Array.count > 0) {
                        
                         for (NSString *code2 in code2Array)
                         {
                             if ([code2 isEqualToString:item.code2])
                             {
                                 item.isSelected = YES;
                                 item.parentItem.isSelected = YES;
                                 if (![box choiceDefault]) {
                                     if (!subTitle) {
                                         subTitle = item.title;
                                     }else{
                                         subTitle = [NSString stringWithFormat:@"%@ %@",subTitle,item.title];
                                     }
                                 }
                                 
                             }
                             
                         }
                    }else{
                        item.isSelected = YES;
                        item.parentItem.isSelected = YES;
                        if (![box choiceDefault]) {
                            if (!subTitle) {
                                subTitle = item.title;
                            }else{
                                subTitle = [NSString stringWithFormat:@"%@ %@",subTitle,item.title];
                            }
                        }
                    
                    }
                }
            }
        }
    }
    
    return subTitle;
    
}

/**
 根据boxValues 设置当前筛选项的title，以及当前选中的值
 
 @param boxValues MMComBoxOldValue
 */
- (void)updateValueWithData:(NSArray *)boxValues
{
    [self resetAllChoiceToNone];
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:boxValues];
    NSMutableDictionary *dicSort = [NSMutableDictionary dictionaryWithCapacity:2];
    for (int i = 0;i < mutArray.count;i++) {
        FFBaseKeyCodeModel  *model  = [mutArray safeObjectAtIndex:i];
        if ([model.key isEqualToString:kSortTypeKey] || [model.key isEqualToString:kSortKey]) {
            [dicSort safeSetObject:model.code forKey:model.key];
            [mutArray removeObject:model];
            i--;
        }
    }
    if (dicSort.count > 0) {
        FFBaseKeyCodeModel *model = [FFBaseKeyCodeModel modelWithKey:kSortKey code:dicSort[kSortKey]];
        model.key2 = kSortTypeKey;
        model.code2 = dicSort[kSortTypeKey];
        [mutArray safeAddObject:model];
    }


#if DEBUG
    //NSLog(@"updateValueWithData:%@",boxValues);
#endif
    for (int i = 0;i < self.itemArray.count; i++) {
        
        MMItem  *rootItem  =  [self.dataSource comBoBoxView:self infomationForColumn:i];
        NSString *rootTitle = nil;
        for (MMItem *subItem in rootItem.childrenNodes) {
            
            if (subItem.childrenNodes.count) {
                
                for (MMItem *subsubItem in subItem.childrenNodes) {
                    if (rootItem.selectedType == MMPopupViewSingleSelection && rootTitle.length > 0) {
                        break;
                    }
                    NSString  *subTitle = [self getSelectTitle:subsubItem boxArray:mutArray];
                    if (rootItem.displayType == MMPopupViewDisplayTypeFilters) {
                        continue;
                    }
                    if (subTitle) {
                        if (rootTitle == nil) {
                            rootTitle = subTitle;
                        }else{
                            rootTitle = [NSString stringWithFormat:@"%@;%@",rootTitle,subTitle];
                        }
                      
                    }
                   
                }
            }else{
                
                if (rootItem.selectedType == MMPopupViewSingleSelection && rootTitle.length > 0) {
                    break;
                }
                NSString  *subTitle = [self getSelectTitle:subItem boxArray:mutArray];
                if (subTitle) {
                    if (rootTitle == nil) {
                        rootTitle = subTitle;
                    }else{
                        rootTitle = [NSString stringWithFormat:@"%@;%@",rootTitle,subTitle];
                    }
                }
            }
            
            //如果title是全部，需要更改为默认的值
            if ([rootTitle isEqualToString:@"全部"]) {
                rootItem.title = rootItem.rootTitle;
            }else{
                rootItem.title = (rootTitle != nil?rootTitle:rootItem.title);
            }
     
        }
    }
    [self reload];
}


/**
 清除所有当前的选择
 */
- (void)cleanAllChoice
{
    [self resetAllChoiceToNone];
    [self.popupView updateSelectPath];
    [self reload];
}

- (void)resetAllChoiceToNone
{
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
        count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *rootItem = [self.dataSource comBoBoxView:self infomationForColumn:i];
            for (MMItem *subItem in rootItem.childrenNodes) {
                if (subItem.childrenNodes.count) {
                    for (MMItem *subsubItem in subItem.childrenNodes) {
                        subsubItem.isSelected = NO;
                        subItem.isSelected = NO;
                    }
                }else{
                    subItem.isSelected = NO;
                }
            }
            rootItem.title = rootItem.rootTitle;
        }
    }
}


- (void)reload {
    
    for (UIView  *subView in self.topBgView.subviews) {
        if (subView != self.topBgView) {
            [subView removeFromSuperview];
        }
    }
    [self.dropDownBoxArray removeAllObjects];
    [self.itemArray removeAllObjects];
    
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
        count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    CGFloat width = (self.ff_width-30)/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            [item findTheTypeOfPopUpView];
            MMDropDownBox *dropBox = [[MMDropDownBox alloc] initWithFrame:CGRectMake(i*width,0, width, self.ff_height-2*self.spaceMargin) titleName:item.title withIcon:item.iconType];
            dropBox.tag = i;
            dropBox.delegate = self;
            [dropBox setLineHide:YES];
            [self.topBgView addSubview:dropBox];
            [self.dropDownBoxArray addObject:dropBox];
            [self.itemArray addObject:item];
            if (i == count-1) {
                [dropBox setDotHide:YES];
            }
        }
    }
}

- (void)dimissPopView {
    
    for (MMDropDownBox *box in self.dropDownBoxArray) {
        [box setLineHide:YES];
    }
    
    if (self.popupView.superview) {
        
        [self.popupView dismissWithCompletion:nil];
    }
   
}

- (BOOL)isPopviewShow
{
    if (self.popupView.superview) {
        return YES;
    }
    return NO;
}
#pragma mark - Private Method
- (void)showNewPopupView:(NSUInteger)index
{
    self.isAnimation = YES;
    MMItem *item = [self.itemArray safeObjectAtIndex:index];
    MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
    [popupView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(emptyAction:)]];
    popupView.delegate = self;
    popupView.tag = index;
    self.popupView = popupView;
    [popupView updateSelectPath];
    [self.symbolArray addObject:popupView];
    
    for (int i = 0; i <self.dropDownBoxArray.count; i++) {
        MMDropDownBox *currentBox  = [self.dropDownBoxArray safeObjectAtIndex:i];
        [currentBox updateTitleState:(i == index)];
        [currentBox setLineHide:(i != index)];
    }

    if ([self.delegate respondsToSelector:@selector(comBoBoxView:actionType:atIndex:)]) {
        [self.delegate comBoBoxView:self actionType:MMComBoBoxViewShowActionTypePop atIndex:index];
    }
    
    [self.superview bringSubviewToFront:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        [popupView popupViewFromView:self completion:^ {
            self.isAnimation = NO;
            
            if ([self.delegate respondsToSelector:@selector(comBoBoxView:actionType:atIndex:)]) {
                [self.delegate comBoBoxView:self actionType:MMComBoBoxViewShowActionTypePop atIndex:index];
            }
        
        }];
    });
    
  
    
}
- (void)emptyAction:(id)sender
{

}

#pragma mark
#pragma mark 截取事件的方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil && self.popupView.superview) {
        CGPoint tp = [self convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.popupView.frame, tp)) {
            view = self;
        }
        CGRect frame = [self convertRect:self.popupView.shadowView.frame toView:self];
        if (CGRectContainsPoint(frame, tp)) {
            return self;
        }
    }
    return view;
}
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGPoint tp = [self convertPoint:point fromView:self];

    if (self.popupView.superview) {
     
        if (CGRectContainsPoint(self.popupView.frame, tp)) {
            return YES;
        }
        CGRect frame = [self convertRect:self.popupView.shadowView.frame toView:self];
        if (CGRectContainsPoint(frame, tp)) {
            return YES;
        }
    }
    return [super pointInside:point withEvent:event];
}



/**
 根据选中的selectPaths 返回MMItem数组

 @param selectPaths 选中的selectPaths
 @param rootItem rootItem
 @return 返回的MMItem
 */
- (NSArray*)getModelsBySelectePath:(NSArray*)selectPaths rootItem:(MMItem*)rootItem
{
    NSMutableArray  *array = [NSMutableArray array];
    for (MMSelectedPath *path in selectPaths) {
        MMItem *subItem = [rootItem findItemBySelectedPath:path];
        [array safeAddObject:subItem];
    }
    return [NSArray arrayWithArray:array];
}

#pragma mark - MMDropDownBoxDelegate
- (void)didTapDropDownBox:(MMDropDownBox *)dropDownBox atIndex:(NSUInteger)index {
    
    if (self.isAnimation == YES) return;
    
    //点击后先判断symbolArray有没有标示
    if (self.symbolArray.count > 0) {
       
        MMBasePopupView * lastView = [self.symbolArray firstObject];
        MMItem *rootItem = lastView.item;
        [lastView dismissWithCompletion:nil];
        [self.symbolArray removeAllObjects];
        for (MMDropDownBox *box in self.dropDownBoxArray) {
            [box setLineHide:YES];
        }
      
        //如果是点击当前的，那么就不需要再显示
        if (rootItem == [self.itemArray safeObjectAtIndex:index]) {
            return;
        }
        
    }
    [self showNewPopupView:index];
}

#pragma mark - MMPopupViewDelegate
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *item = self.itemArray[index];
    if (item.displayType != MMPopupViewDisplayTypeFilters) {
        //拼接选择项
        NSMutableString *title = [NSMutableString string];
        for (int i = 0; i <array.count; i++) {
            if (title.length > 0) {
                break;
            }
            MMSelectedPath *path = array[i];
            [title appendString:i?[NSString stringWithFormat:@";%@",[item findTitleBySelectedPath:path]]:[item findTitleBySelectedPath:path]];
        }
        MMDropDownBox *box = [self.dropDownBoxArray safeObjectAtIndex:index];
        
        //如果title是全部，需要更改为默认的值
        if ([title isEqualToString:@"全部"]) {
                [box updateTitleContent:item.rootTitle];
        }else if (title.length > 0){
               [box updateTitleContent:title];
        }else{
               [box updateTitleContent:item.rootTitle];
        }
       
    }; //筛选不做UI赋值操作 直接将item的路径回调回去就好了
    
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate comBoBoxView:self didSelectedItemsPackagingInArray:array atIndex:index];
    }
    
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:didSelectedModelsInArray:atIndex:)]) {
        [self.delegate comBoBoxView:self didSelectedModelsInArray:[self getModelsBySelectePath:array rootItem:item] atIndex:index];
    }
}

- (void)popupViewWillDismiss:(MMBasePopupView *)popupView {
    
    [self.symbolArray removeAllObjects];
    for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
        [currentBox updateTitleState:NO];
    }
    for (MMDropDownBox *box in self.dropDownBoxArray) {
        [box setLineHide:YES];
    }
}

- (void)popupViewDidDismiss:(nullable MMBasePopupView *)popupView {
    
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:actionType:atIndex:)]) {
        [self.delegate comBoBoxView:self actionType:MMComBoBoxViewShowActionTypePackUp atIndex:0];
    }
}

@end
