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
//@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *dropDownBoxArray;
@property (nonatomic, strong) NSMutableArray *itemArray;
@property (nonatomic, strong) NSMutableArray *symbolArray;  //当成一个队列来标记那个弹出视图
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, strong) MMBasePopupView *popupView;
@property (nonatomic, assign) NSInteger lastTapIndex;       //默认 -1
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, strong) UIView    *topBgView;
@property (nonatomic, assign) CGFloat    spaceMargin;




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
    self.lastTapIndex = -1;
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


-(NSString*)getSelectTitle:(MMItem*)item boxArray:(NSArray <MMComBoxOldValue>*)boxValues
{
    NSString  *subTitle = nil;
    for (id<MMComBoxOldValue> box in boxValues) {
        if ([item.key isEqualToString:[box key]]) {
            NSArray *codeArray = [[box code] componentsSeparatedByString:@","];
            for (NSString *code in codeArray) {
                if ([code isEqualToString:item.code]) {
                    item.isSelected = YES;
                    if (!subTitle) {
                        subTitle = item.title;
                    }else{
                        subTitle = [NSString stringWithFormat:@"%@ %@",subTitle,item.title];
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
- (void)updateValueWithData:(NSArray <MMComBoxOldValue>*)boxValues
{
    [self resetAllChoiceToNone];
    for (int i = 0;i < self.itemArray.count; i++) {
        MMItem  *rootItem  =  [self.dataSource comBoBoxView:self infomationForColumn:i];
        NSString *rootTitle = nil;
        for (MMItem *subItem in rootItem.childrenNodes) {
            
            if (subItem.childrenNodes.count) {
                for (MMItem *subsubItem in subItem.childrenNodes) {
                    NSString  *subTitle = [self getSelectTitle:subsubItem boxArray:boxValues];
                    if (subTitle) {
                        if (rootTitle == nil) {
                            rootTitle = subTitle;
                        }else{
                            rootTitle = [NSString stringWithFormat:@"%@ %@",rootTitle,subTitle];
                        }
                        
                    }
                }
            }else{
                
                NSString  *subTitle = [self getSelectTitle:subItem boxArray:boxValues];
                if (subTitle) {
                    if (rootTitle == nil) {
                        rootTitle = subTitle;
                    }else{
                        rootTitle = [NSString stringWithFormat:@"%@ %@",rootTitle,subTitle];
                    }
                }
            }
            
            rootItem.title = (rootTitle != nil?rootTitle:rootItem.title);
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
                    }
                }else{
                    subItem.isSelected = NO;
                }
            }
            
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
    // [self _addLine];
}




- (void)dimissPopView {
    
    if (self.popupView.superview) {
        [self.popupView dismissWithOutAnimation];
    }
}

#pragma mark - Private Method
- (void)_addLine {
    self.topLine = [CALayer layer];
    self.topLine.frame = CGRectMake(0, 0 , self.ff_width, 1.0/scale);
    self.topLine.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.3].CGColor;
    [self.layer addSublayer:self.topLine];
    
    self.bottomLine = [CALayer layer];
    self.bottomLine.frame = CGRectMake(0, self.ff_height - 1.0/scale , self.ff_width, 1.0/scale);
    self.bottomLine.backgroundColor = [UIColor ff_colorWithHex:0xe8e8e8].CGColor;
    [self.layer addSublayer:self.bottomLine];
}


- (void)showNewPopupView:(NSUInteger)index
{
    self.isAnimation = YES;
    MMItem *item = self.itemArray[index];
    MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
    [popupView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(emptyAction:)]];
    popupView.delegate = self;
    popupView.tag = index;
    self.popupView = popupView;
    [self.symbolArray addObject:popupView];
    
    if ([self.delegate respondsToSelector:@selector(comBoBoxView:actionType:atIndex:)]) {
        [self.delegate comBoBoxView:self actionType:MMComBoBoxViewShowActionTypePop atIndex:index];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [popupView popupViewFromSourceFrame:self.frame completion:^ {
            self.isAnimation = NO;
        
        } fromView:self];
    });
    
    
}


- (void)emptyAction:(id)sender
{
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
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

        if (CGRectContainsPoint(self.popupView.frame, tp)) {
            return YES;
        }
        CGRect frame = [self convertRect:self.popupView.shadowView.frame toView:self];
        if (CGRectContainsPoint(frame, tp)) {
            return YES;
        }
    
    return [super pointInside:point withEvent:event];
}


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
    for (int i = 0; i <self.dropDownBoxArray.count; i++) {
        MMDropDownBox *currentBox  = self.dropDownBoxArray[i];
        [currentBox updateTitleState:(i == index)];
        [currentBox setLineHide:(i != index)];
    }
    //点击后先判断symbolArray有没有标示
    if (self.symbolArray.count > 0) {
        //移除
        if ([self.delegate respondsToSelector:@selector(comBoBoxView:actionType:atIndex:)]) {
            [self.delegate comBoBoxView:self actionType:MMComBoBoxViewShowActionTypePackUp atIndex:index];
        }
        MMBasePopupView * lastView = self.symbolArray[0];
        MMItem *rootItem = lastView.item;
        [lastView dismiss];
        [self.symbolArray removeAllObjects];
        //如果是点击当前的，那么就不需要再显示
        if ([rootItem isEqual:self.itemArray[index]]) {
            return;
        }
        
    }
    [self showNewPopupView:index];
}

#pragma mark - MMPopupViewDelegate
- (void)popupView:(MMBasePopupView *)popupView didSelectedItemsPackagingInArray:(NSArray *)array atIndex:(NSUInteger)index {
    MMItem *item = self.itemArray[index];
    if (1) {
        //拼接选择项
        NSMutableString *title = [NSMutableString string];
        for (int i = 0; i <array.count; i++) {
            MMSelectedPath *path = array[i];
            [title appendString:i?[NSString stringWithFormat:@";%@",[item findTitleBySelectedPath:path]]:[item findTitleBySelectedPath:path]];
        }
        MMDropDownBox *box = self.dropDownBoxArray[index];
        [box updateTitleContent:title];
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
}
@end
