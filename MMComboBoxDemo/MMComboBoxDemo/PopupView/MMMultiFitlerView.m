//
//  MMMultiFitlerView.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMMultiFitlerView.h"
#import "MMHeader.h"
#import "MMLeftCell.h"
#import "MMNormalCell.h"
#import "MMSelectedPath.h"

@interface MMMultiFitlerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger minRowNumber;
@property (nonatomic, strong) UIView  *bgView;
@end
@implementation MMMultiFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        MMSelectedPath *selectedPath = [MMSelectedPath pathWithFirstPath:[self _findLeftSelectedIndex]];
        self.selectedIndex = [self _findLeftSelectedIndex];
        if ([self _findRightSelectedIndex:self.selectedIndex] != -1) {
            selectedPath.secondPath = [self _findRightSelectedIndex:self.selectedIndex];
        }
        [self.selectedArray addObject:selectedPath];
        self.minRowNumber = 4;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



#pragma mark - public method
- (void)popupViewFromSourceFrame:(CGRect)frame completion:(void (^ __nullable)(void))completion fromView:(UIView *)superView {

    self.sourceFrame = frame;
    CGFloat top =  CGRectGetHeight(self.sourceFrame);
    CGFloat maxHeight = kMMScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight-DistanceBeteewnTopMargin;
    CGFloat resultHeight = MIN(maxHeight, MAX(self.item.childrenNodes.count, self.minRowNumber)  * [MMLeftCell leftCellHeight:nil]);
      self.frame = CGRectMake(0, top, kMMScreenWidth, 0);
    [superView addSubview:self];
    
  
    //add tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self.minRowNumber > self.item.childrenNodes.count) {
        self.mainTableView.rowHeight = [MMLeftCell leftCellHeight:nil]*self.minRowNumber/self.item.childrenNodes.count;
    }else{
        self.mainTableView.rowHeight =  [MMLeftCell leftCellHeight:nil];
    }
    
    self.mainTableView.tag = 0;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.showsVerticalScrollIndicator = YES;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.separatorColor = [UIColor clearColor];
    [self.mainTableView registerClass:[MMLeftCell class] forCellReuseIdentifier:MainCellID];
    [self addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor whiteColor];
    
    self.subTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.subTableView.rowHeight = [MMNormalCell normalCellHeight:nil];
    self.subTableView.tag = 1;
    self.subTableView.delegate = self;
    self.subTableView.dataSource = self;
    self.subTableView.backgroundColor = [UIColor whiteColor];
    self.subTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.subTableView registerClass:[MMNormalCell class] forCellReuseIdentifier:SubCellID];
    [self addSubview:self.subTableView];
    
    //add ShadowView
    self.shadowView.frame = CGRectMake(0, top, kMMScreenWidth, kMMScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    UITapGestureRecognizer  *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTapGestureRecognizer:)];
    tap.numberOfTouchesRequired = 1; //手指数
    tap.numberOfTapsRequired = 1; //tap次数
    [self.shadowView addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMMScreenWidth, resultHeight)];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self insertSubview:self.bgView atIndex:0];
    
    
//    [UIView animateWithDuration:0 animations:^{
//        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight);
//        self.mainTableView.frame = CGRectMake(0, 0, kMMLeftCellWidth, self.ff_height);
//        self.subTableView.frame = CGRectMake(kMMLeftCellWidth+10, 0,  self.ff_width - kMMLeftCellWidth-20, self.ff_height);
//        self.shadowView.alpha = ShadowAlpha;
//    } completion:^(BOOL finished) {
//        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight);
//        self.mainTableView.frame = CGRectMake(0, 0, kMMLeftCellWidth, self.ff_height);
//        self.subTableView.frame = CGRectMake(kMMLeftCellWidth+10, 0,  self.ff_width - kMMLeftCellWidth-20, self.ff_height);
//        self.shadowView.alpha = ShadowAlpha;
//         completion();
//    }];
    
    //出现的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        
        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight);
        self.mainTableView.frame = CGRectMake(0, 0, kMMLeftCellWidth, self.ff_height);
        self.subTableView.frame = CGRectMake(kMMLeftCellWidth+10, 0,  self.ff_width - kMMLeftCellWidth-20, self.ff_height);
        self.shadowView.alpha = ShadowAlpha;
       
    } completion:^(BOOL finished) {
        completion();
    }];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
}
- (void)dismiss{
    [super dismiss];
    //设置最后选中的赋给left cell
    MMSelectedPath *path = [self.selectedArray lastObject];
    if ([self _findLeftSelectedIndex] != path.firstPath) {
        self.item.childrenNodes[[self _findLeftSelectedIndex]].isSelected = NO;
        self.item.childrenNodes[path.firstPath].isSelected = YES;
    }
    
    if ([self.delegate respondsToSelector:@selector(popupViewWillDismiss:)]) {
        [self.delegate popupViewWillDismiss:self];
    }
    
    CGFloat top =  CGRectGetMaxY(self.sourceFrame);
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        //        self.imageView.hidden = YES;
        self.frame = CGRectMake(0, top, kMMScreenWidth, 0);
        self.mainTableView.ff_height = self.ff_height;
        self.subTableView.ff_height = self.ff_height;
        self.bgView.ff_height = self.ff_height;
        self.shadowView.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - private method
- (NSUInteger)_findLeftSelectedIndex {
    for (MMItem *item in self.item.childrenNodes) {
        if (item.isSelected) return [self.item.childrenNodes indexOfObject:item];
    }
    return MAXFLOAT;
}

- (NSInteger)_findRightSelectedIndex:(NSInteger)leftIndex {
    MMItem *item = self.item.childrenNodes[leftIndex];
    for (MMItem *subItem in item.childrenNodes) {
        if (subItem.isSelected) return [item.childrenNodes indexOfObject:subItem];
    }
    return -1;
}

- (void)_callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
    }
}

#pragma mark - Action
- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismiss];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) { //mainTableView
       return self.item.childrenNodes.count;
    }
    return self.item.childrenNodes[self.selectedIndex].childrenNodes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) { //mainTableView
        MMLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:MainCellID forIndexPath:indexPath];
        cell.item = self.item.childrenNodes[indexPath.row];
        return cell;
    }
    MMNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:SubCellID forIndexPath:indexPath];
    cell.item = self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row];
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        return [MMLeftCell leftCellHeight:self.item.childrenNodes[indexPath.row]];
    }
    return [MMNormalCell normalCellHeight:self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) { //mainTableView
        
        if (self.selectedIndex == indexPath.row) return;
        self.item.childrenNodes[indexPath.row].isSelected = YES;
        self.item.childrenNodes[self.selectedIndex].isSelected = NO;
        self.selectedIndex = indexPath.row;
        [self.mainTableView reloadData];
        [self.subTableView reloadData];
    }else{ //subTableView
        
        MMSelectedPath *selectdPath = [self.selectedArray lastObject];
        if (selectdPath.firstPath == self.selectedIndex && selectdPath.secondPath == indexPath.row) return;
        MMItem *lastItem = self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath];
        lastItem.isSelected = NO;
        [self.selectedArray removeAllObjects];
        MMItem *currentIndex =self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row];
        currentIndex.isSelected = YES;
        [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:self.selectedIndex secondPath:indexPath.row]];
        [self.subTableView reloadData];
        [self _callBackDelegate];

    }
    
}
@end
