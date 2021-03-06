//
//  MMSingleFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMSingleFitlerView.h"
#import "MMHeader.h"
#import "MMNormalCell.h"
#import "MMSelectedPath.h"

@interface MMSingleFitlerView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isSuccessfulToCallBack;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MMSingleFitlerView

- (id)initWithItem:(MMItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
        self.isSuccessfulToCallBack = (self.item.selectedType == MMPopupViewSingleSelection)?YES:NO;
        self.selectedArray = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)updateSelectPath
{
    [self.selectedArray removeAllObjects];
    for (int i = 0; i < self.item.childrenNodes.count; i++) {
        MMItem *subItem = [self.item.childrenNodes safeObjectAtIndex:i];
        if (subItem.isSelected == YES){
            MMSelectedPath *path = [[MMSelectedPath alloc] init];
            path.firstPath = i;
            [self.selectedArray safeAddObject:path];
        }
    }
    self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES] ;
    [self.mainTableView reloadData];
}

#pragma mark - public method
- (void)popupViewFromView:(nullable UIView*)superView completion:(void (^ __nullable)(void))completion {
    
    CGFloat top =   CGRectGetHeight(superView.frame);
    CGFloat maxHeight = kMMScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight-DistanceBeteewnTopMargin;
    CGFloat resultHeight = MIN(maxHeight, self.item.childrenNodes.count * [MMNormalCell normalCellHeight:nil]);
    self.frame = CGRectMake(0, top, kMMScreenWidth, 0);
    [superView addSubview:self];
   
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, kMMScreenWidth-20, 0) style:UITableViewStylePlain];
    self.mainTableView.rowHeight = [MMNormalCell normalCellHeight:nil];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorColor = [UIColor clearColor];
    [self.mainTableView registerClass:[MMNormalCell class] forCellReuseIdentifier:MainCellID];
    [self addSubview:self.mainTableView];
    
    //add shadowView
    self.shadowView.frame = CGRectMake(0, top, kMMScreenWidth, kMMScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    [self.shadowView addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventAllEvents];
    [self.shadowView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(emptyAction:)]];
    
    //出现的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight);
        self.mainTableView.frame = CGRectMake(10, 0, kMMScreenWidth-20, resultHeight);
        self.shadowView.alpha = ShadowAlpha;
    } completion:^(BOOL finished) {
        completion();
        if (self.item.selectedType == MMPopupViewSingleSelection) return ;
        self.ff_height += PopupViewTabBarHeight;
        self.bottomView = [[UIView alloc] init];
        self.bottomView.backgroundColor = [UIColor ff_colorWithHex:0xFCFAFD];
        self.bottomView.frame = CGRectMake(0, self.mainTableView.ff_bottom, self.ff_width, PopupViewTabBarHeight);
        [self addSubview:self.bottomView];
        
        NSArray *titleArray = @[@"取消",@"确定"];
        for (int i = 0; i < 2 ; i++) {
            CGFloat left = ((i == 0)?ButtonHorizontalMargin:self.ff_width - ButtonHorizontalMargin - 100);
            UIColor *titleColor = ((i == 0)?[UIColor blackColor]:[UIColor ff_colorWithHexString:titleSelectedColor]);
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(left, 0, 100, PopupViewTabBarHeight);
            button.tag = i;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:titleColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
            [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:button];
        }
        
    }];
    
}

/**
 只是为了滑动事件不被父view接受
 
 @param sender sender
 */
-(void)emptyAction:(id)sender
{
      [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completion{
    [super dismissWithCompletion:completion];
    [self _resetValue];
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    if (self.item.selectedType == MMPopupViewMultilSeMultiSelection) {
        self.bottomView.hidden = YES;   
    }
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.ff_height = 0;
        self.mainTableView.ff_height = 0;
    } completion:^(BOOL finished) {
        if (self.superview) {
         [self removeFromSuperview];
        }
        if (completion) {
            completion();
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidDismiss:)]) {
            [self.delegate popupViewDidDismiss:self];
        }
    }];
}

#pragma mark - Private Method
- (void)_resetValue{
    //恢复成以前的值
    if (self.isSuccessfulToCallBack == NO) {
        for (MMItem *item in self.item.childrenNodes) {
            item.isSelected = NO;
        }
        for (MMSelectedPath *path in self.temporaryArray) {
            self.item.childrenNodes[path.firstPath].isSelected = YES;
        }
    }
}

- (BOOL)_iscontainsSelectedPath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array{
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) return YES;
    }
    return NO;
}

- (void)_removePath:(MMSelectedPath *)path sourceArray:(NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath ) {
            [array removeObject:selectedpath];
            return;
        }
    }
}

- (void)_callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        [self.mainTableView reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissWithCompletion:nil];
        });
    }
}
#pragma mark - Action
- (void)respondsToButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {//取消
      [self dismissWithCompletion:nil];
    } else if (sender.tag == 1) {//确定
    self.isSuccessfulToCallBack = YES;
    [self _callBackDelegate];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
  [self dismissWithCompletion:nil];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.item.childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
    MMItem *item = [self.item.childrenNodes safeObjectAtIndex:indexPath.row];
    cell.item = item;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMItem *item = self.item.childrenNodes[indexPath.row];
    return [MMNormalCell normalCellHeight:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.selectedType == MMPopupViewMultilSeMultiSelection) { //多选
        if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray]) {
            if (self.selectedArray.count == 1) return;
            [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray];
            self.item.childrenNodes[indexPath.row].isSelected = NO;
        }else {
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row]];
            self.item.childrenNodes[indexPath.row].isSelected = YES;
        }
      [self.mainTableView reloadData];
    }else if (self.item.selectedType == MMPopupViewSingleSelection) { //单选
        //如果点击的已经选中的直接返回
        if ([self _iscontainsSelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row] sourceArray:self.selectedArray])
        {
            [self _callBackDelegate];
            return;
        }
           //remove
            MMSelectedPath *lastSelectedPath = [self.selectedArray firstObject];
            if (lastSelectedPath) {
                self.item.childrenNodes[lastSelectedPath.firstPath].isSelected = NO;
                [self.selectedArray removeLastObject];
            }
           //add
            self.item.childrenNodes[indexPath.row].isSelected = YES;
            [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:indexPath.row]];
            [self _callBackDelegate];
    }
}
@end
