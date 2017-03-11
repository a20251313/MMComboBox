//
//  MMCombinationFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombinationFitlerView.h"
#import "MMHeader.h"
#import "MMCombineCell.h"
#import "MMHeaderView.h"
#import "MMSelectedPath.h"
#import "MMAlternativeItem.h"
@interface MMCombinationFitlerView () <MMHeaderViewDelegate,MMCombineCellDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nullable, nonatomic, strong) UIView *bottomView;
@property (nullable ,nonatomic, strong) MMHeaderView *headView;
@property (nonatomic, assign) BOOL isSuccessfulToCallBack;

@end

@implementation MMCombinationFitlerView

- (nullable id)initWithItem:(nullable MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        //单选
        for (int i = 0; i < self.item.alternativeArray.count; i++) {
            MMAlternativeItem *alternativeItem = self.item.alternativeArray[i];
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:i isKindOfAlternative:YES isOn:alternativeItem.isSelected]];
        }
        //多层
        for (int i = 0; i < self.item.childrenNodes.count; i++) {
            MMItem *subItem = item.childrenNodes[i];
            for (int j = 0; j <subItem.childrenNodes.count; j++) {
                MMItem *secondItem = subItem.childrenNodes[j];
                if (secondItem.isSelected == YES){
                    [self.selectedArray addObject: [MMSelectedPath pathWithFirstPath:i secondPath:j]];
                    break;
                }
            }
        }
        self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES] ;
        
    }
    return self;
}

#pragma mark - Private Method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion  fromView:(nullable UIView*)superView{
    //UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    self.sourceFrame = frame;
    CGFloat top =  CGRectGetHeight(self.sourceFrame);
    CGFloat maxHeight = kMMScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight-DistanceBeteewnTopMargin;
    CGFloat resultHeight = MIN(maxHeight, self.item.layout.totalHeight);
    self.frame = CGRectMake(0, top, kMMScreenWidth, 0);
    [superView addSubview:self];
    
    //addTableView
    self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.tableHeaderView = [[UIView alloc] init];
    [self.mainTableView registerClass:[MMCombineCell class] forCellReuseIdentifier:MainCellID];
    [self.mainTableView setSeparatorColor:[UIColor clearColor]];
    [self addSubview:self.mainTableView];
    
    
    //add shadowView
    self.shadowView.frame = CGRectMake(0, top, kMMScreenWidth, kMMScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight);
        self.mainTableView.frame = self.bounds;
        self.shadowView.alpha = ShadowAlpha;
    } completion:^(BOOL finished) {
        completion();
        self.ff_height += PopupViewTabBarHeight;
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor ff_colorWithHex:0xffffff];
        self.bottomView.frame = CGRectMake(0, self.mainTableView.ff_bottom, self.ff_width, PopupViewTabBarHeight);
        [self addSubview:self.bottomView];
        
        
        UIImage *image =  [UIImage imageNamed:@"screen_line"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        UIImageView  *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, self.mainTableView.ff_width-30, 1)];
        lineView.image = image;
        [self.bottomView addSubview:lineView];
        
        NSArray *titleArray = @[@"重置",@"确定"];
        CGFloat  fbuttonWidth = (self.ff_width-ButtonHorizontalMargin*2-ButtonHorizontalMargin*3)/2;
        for (int i = 0; i < 2 ; i++) {
            CGFloat left = ((i == 0)?ButtonHorizontalMargin:self.ff_width - ButtonHorizontalMargin - fbuttonWidth);
            UIColor *titleColor = ((i == 0)?[UIColor ff_colorWithHex:0x2bbfff]:[UIColor ff_colorWithHex:0x2bbfff]);
            UIColor *bgColor = ((i == 0)?[UIColor ff_colorWithHex:0xffffff]:[UIColor ff_colorWithHex:0xffffff]);
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(left, 10, fbuttonWidth, PopupViewTabBarHeight-20);
            button.tag = i;
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.cornerRadius = 15;
            button.backgroundColor = bgColor;
            button.layer.borderColor = [UIColor ff_colorWithHex:0x2bbfff].CGColor;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
            [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:button];
        }
    }];

}

- (void)dismiss{
    [super dismiss];
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    //根据isSuccessfulToCallBack字段判断是否要将数据回归到temporaryArray
    if (self.isSuccessfulToCallBack == NO) {
        [self.selectedArray enumerateObjectsUsingBlock:^(MMSelectedPath *path, NSUInteger idx, BOOL * _Nonnull stop) {
            if (path.isKindOfAlternative == YES) {
                MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
                item.isSelected = NO;
            }else {
                MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                lastItem.isSelected = NO;
            }
        }];
        [self.temporaryArray enumerateObjectsUsingBlock:^(MMSelectedPath *path, NSUInteger idx, BOOL * _Nonnull stop) {
            if (path.isKindOfAlternative == YES) {
                MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
                item.isSelected = path.isOn;
            }else {
                MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
                lastItem.isSelected = YES;
            }
        }];   
    }
   
    self.bottomView.hidden = YES;
    //CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.ff_height = 0;
        self.mainTableView.ff_height = 0;
       // self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Private Method
- (BOOL)_iscontainsSelectedPath:(nullable MMSelectedPath *)path sourceArray:(nullable NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.secondPath == path.secondPath) return YES;
    }
    return NO;
}

- (nullable MMSelectedPath *)_removePath:(nullable MMSelectedPath *)path sourceArray:(nullable NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.isKindOfAlternative == NO) {
            MMSelectedPath *returnPath = selectedpath;
            [array removeObject:selectedpath];
            return returnPath;
        }
    }
    return nil;
}

- (nullable MMSelectedPath *)_findAlternativeItemAtIndex:(NSInteger)index sourceArray:(nullable NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == index && selectedpath.isKindOfAlternative == YES) {
            return selectedpath;
        }
    }
    return nil;
}

- (void)resetValue {
    for (int i = 0; i < self.selectedArray.count; i++) {
        MMSelectedPath *path = self.selectedArray[i];
        if (path.isKindOfAlternative == YES) {
            MMAlternativeItem *item = self.item.alternativeArray[path.firstPath];
            item.isSelected = NO;
        }else {
            MMItem *lastItem = self.item.childrenNodes[path.firstPath].childrenNodes[path.secondPath];
            lastItem.isSelected = NO;
//            MMItem *currentItem = self.item.childrenNodes[path.firstPath].childrenNodes[0];
//            currentItem.isSelected = YES;
//            path.secondPath = 0;
        }
    }
    [self.mainTableView reloadData];
}

- (void)callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        self.isSuccessfulToCallBack = YES;
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
            self.isSuccessfulToCallBack = NO;
        });
    }
}
#pragma mark - Action
- (void)respondsToButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {//重置
        [self resetValue];
    } else if (sender.tag == 1) {//确定
        [self callBackDelegate];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMCombineCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    cell.item = self.item.childrenNodes[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.headView == nil) {
     self.headView = [[MMHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.ff_width,self.item.layout.headerViewHeight)];
     self.headView.delegate = self;
     self.headView.backgroundColor = [UIColor whiteColor];
    }
    self.headView.item = self.item;
    return self.headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    MMItem *subitem = self.item.childrenNodes[indexPath.row];
    if (subitem.isOpen) {
         return [self.item.layout.cellLayoutTotalHeight[indexPath.row] floatValue];
    }
    return [self.item.layout.cellCloseStateHeight[indexPath.row] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.item.layout.headerViewHeight;
}

#pragma mark - MMHeaderViewDelegate
- (void)headerView:(MMHeaderView *)headerView didSelectedAtIndex:(NSInteger)index currentState:(BOOL)isSelected {
   MMSelectedPath *selectedPath = [self _findAlternativeItemAtIndex:index sourceArray:self.selectedArray];
   selectedPath.isOn = isSelected;
   MMAlternativeItem *item = self.item.alternativeArray[index];
   item.isSelected = isSelected;
}

#pragma mark - MMCombineCellDelegate
- (void)combineCell:(MMCombineCell *)combineCell didSelectedAtIndex:(NSInteger)index{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:combineCell];
    if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:self.selectedArray]) {//包含
        return;
    } else {
      MMSelectedPath *removeIndexPath = [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray];
        self.item.childrenNodes[removeIndexPath.firstPath].childrenNodes[removeIndexPath.secondPath].isSelected = NO;
       [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index]];
        self.item.childrenNodes[indexPath.row].childrenNodes[index].isSelected = YES;
    }
    [self.mainTableView reloadData];
}

- (void)combineCellDidClickOpen:(MMCombineCell *)combineCell
{
    NSIndexPath *indexPath = [self.mainTableView indexPathForCell:combineCell];
    [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


@end
