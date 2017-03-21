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
#import "NSMutableArray+Safe.h"


@interface MMMultiFitlerView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger minRowNumber;
@end


@implementation MMMultiFitlerView
- (id)initWithItem:(MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        [self updateSelectPath];
        self.minRowNumber = kMMMinShowRowNumer;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)updateSelectPath
{
    [self.selectedArray removeAllObjects];
    NSArray  *array = [self _findAllSelectItem];
    for (MMItem  *item in array) {
        NSUInteger index = [self.item.childrenNodes indexOfObject:item.parentItem];
        NSUInteger secondIndex = [item.parentItem.childrenNodes indexOfObject:item];
        MMSelectedPath *selectedPath = [MMSelectedPath pathWithFirstPath:index secondPath:secondIndex];
        if (index < self.item.childrenNodes.count && secondIndex < item.parentItem.childrenNodes.count) {
            if (self.selectedArray.count > 0) {
                MMItem  *subItem = [self.item findItemBySelectedPath:selectedPath];
                subItem.isSelected = NO;
                item.isSelected = NO;
            }else{
                
                MMItem  *subItem = [self.item findItemBySelectedPath:selectedPath];
                subItem.isSelected = YES;
                item.isSelected = YES;
                [self.selectedArray safeAddObject:selectedPath];
            }
            
        }
       
    }
 
    if (self.selectedArray.count < 1) {
        self.selectedIndex = 0;
        if (self.item.childrenNodes.count > 0) {
            
             MMSelectedPath *firstPath = [MMSelectedPath pathWithFirstPath:0];
             MMItem *firstItem = [self.item findItemBySelectedPath:firstPath];
            if (firstItem.childrenNodes.count > 0) {
                MMSelectedPath *selectedPath = [MMSelectedPath pathWithFirstPath:0 secondPath:0];
                self.selectedIndex = 0;
                MMItem *selectItem = [self.item findItemBySelectedPath:selectedPath];
                selectItem.isSelected = YES;
                firstItem.isSelected = YES;
                [self.selectedArray safeAddObject:selectedPath];
            }
        }
       
    }
    
    self.selectedIndex = [self _findLeftSelectedIndex];
    
//    [self.item setAllSubItemSelected:NO];
//    for (MMSelectedPath *path  in self.selectedArray) {
//        
//        MMItem *item = [self.item findItemBySelectedPath:path];
//        item.isSelected = YES;
//        item.parentItem.isSelected = YES;
//    }
    [self resetSelectIndex];
}


- (void)resetSelectIndex
{
    if (self.selectedArray.count > 0) {
        MMSelectedPath *path = [self.selectedArray safeObjectAtIndex:0];
        MMItem *tempItem = [self.item findItemBySelectedPath:path];
        tempItem.parentItem.isSelected = YES;
        tempItem.isSelected = YES;
        NSUInteger index = [self.item.childrenNodes indexOfObject:tempItem.parentItem];
        if (index < self.item.childrenNodes.count) {
            self.selectedIndex = index;
        }else{
            self.selectedIndex = 0;
        };
    }else{
        self.selectedIndex = 0;
    }
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
    self.mainTableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, kMMLeftCellWidth, 0) style:UITableViewStylePlain];
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
    
    self.subTableView = [[UITableView alloc] initWithFrame:CGRectMake(kMMLeftCellWidth+10, 0,  self.ff_width - kMMLeftCellWidth-20, 0) style:UITableViewStylePlain];
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
    [self.shadowView addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventAllEvents];
    [self.shadowView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(emptyAction:)]];
    
    

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

/**
 只是为了滑动事件不被父view接受
 
 @param sender sender
 */
-(void)emptyAction:(id)sender
{
      [self dismiss];
    
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

    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.mainTableView.ff_height = 0;
        self.subTableView.ff_height = 0;
        self.ff_height = 0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - private method

- (NSArray*)_findAllSelectItem {
    
    NSMutableArray  *items = [NSMutableArray array];
    for (MMItem *item in self.item.childrenNodes) {
        
        for (MMItem *subItem in item.childrenNodes) {
            if (subItem.isSelected)
            {
                [items safeAddObject:subItem];
            }
        }
       
    }
    return [NSArray arrayWithArray:items];
}
- (NSUInteger)_findLeftSelectedIndex {
    for (MMItem *item in self.item.childrenNodes) {
        if (item.isSelected) return [self.item.childrenNodes indexOfObject:item];
    }
    return NSUIntegerMax;
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
        if (selectdPath.firstPath == self.selectedIndex && selectdPath.secondPath == indexPath.row)
            return;
        
        if (selectdPath.firstPath == self.selectedIndex && selectdPath.secondPath == indexPath.row) return;
        if (selectdPath.secondPath != -1) {
            MMItem *lastItem = self.item.childrenNodes[selectdPath.firstPath].childrenNodes[selectdPath.secondPath];
            lastItem.isSelected = NO;
        }
        [self removeAndEmptySelected];
        [self.selectedArray removeAllObjects];
        MMItem *currentIndex = self.item.childrenNodes[self.selectedIndex].childrenNodes[indexPath.row];
        currentIndex.isSelected = YES;
        currentIndex.parentItem.isSelected = YES;
        [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:self.selectedIndex secondPath:indexPath.row]];
        [self.subTableView reloadData];
        [self.mainTableView reloadData];
        [self _callBackDelegate];

    }
    
}

#pragma mark

-(void)removeAndEmptySelected
{
    [self.item setAllSubItemSelected:NO];
}
@end
