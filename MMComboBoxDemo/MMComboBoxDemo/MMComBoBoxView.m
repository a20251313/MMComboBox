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

@end

@implementation MMComBoBoxView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lastTapIndex = -1;
        self.dropDownBoxArray = [NSMutableArray array];
        self.itemArray = [NSMutableArray array];
        self.symbolArray = [NSMutableArray arrayWithCapacity:1];
        self.backgroundColor = [UIColor colorWithRed:0xe6/255.0 green:0xe6/255.0 blue:0xe6/255.0 alpha:1];
        [self addSubview:self.topBgView];
        [self.topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.right.mas_offset(-15);
            make.top.bottom.mas_equalTo(0);
        }];
        
    }
    return self;
}


- (UIView*)topBgView
{
    if (_topBgView == nil) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.layer.masksToBounds = YES;
        bgView.layer.borderWidth = 1;
        bgView.layer.cornerRadius = 18;
        bgView.layer.borderColor = [UIColor clearColor].CGColor;
        bgView.backgroundColor = [UIColor whiteColor];
        _topBgView = bgView;
    }
    
    return _topBgView;
}

- (void)reload {
    NSUInteger count = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfColumnsIncomBoBoxView:)]) {
        count = [self.dataSource numberOfColumnsIncomBoBoxView:self];
    }
    
    CGFloat width = (self.ff_width-30)/count;
    if ([self.dataSource respondsToSelector:@selector(comBoBoxView:infomationForColumn:)]) {
        for (NSUInteger i = 0; i < count; i ++) {
            MMItem *item = [self.dataSource comBoBoxView:self infomationForColumn:i];
            [item findTheTypeOfPopUpView];
            MMDropDownBox *dropBox = [[MMDropDownBox alloc] initWithFrame:CGRectMake(i*width, 0, width, self.ff_height) titleName:item.title withIcon:item.iconType];
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
    [self _addLine];
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
    self.bottomLine.backgroundColor = [UIColor ff_colorWithHexString:@"e8e8e8"].CGColor;
    [self.layer addSublayer:self.bottomLine];
}


- (void)showNewPopupView:(NSUInteger)index
{
    self.isAnimation = YES;
    MMItem *item = self.itemArray[index];
    MMBasePopupView *popupView = [MMBasePopupView getSubPopupView:item];
    popupView.delegate = self;
    popupView.tag = index;
    self.popupView = popupView;
    [popupView popupViewFromSourceFrame:self.frame completion:^{
        self.isAnimation = NO;
    }];
    [self.symbolArray addObject:popupView];
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
    if (self.symbolArray.count) {
        //移除
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
    if (item.displayType == MMPopupViewDisplayTypeMultilayer || item.displayType == MMPopupViewDisplayTypeNormal) {
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
}

- (void)popupViewWillDismiss:(MMBasePopupView *)popupView {
    [self.symbolArray removeAllObjects];
    for (MMDropDownBox *currentBox in self.dropDownBoxArray) {
        [currentBox updateTitleState:NO];
    }
}
@end
