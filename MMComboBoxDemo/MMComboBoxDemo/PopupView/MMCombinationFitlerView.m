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


#define kMMFileterEmptyHeight  301

@interface MMCombinationFitlerView () <MMHeaderViewDelegate,MMCombineCellDelegate,UITableViewDelegate, UITableViewDataSource>

@property (nullable, nonatomic, strong) UIView *bottomView;
@property (nullable, nonatomic, strong) MMHeaderView *headView;
@property (nullable, nonatomic, strong) UIView   *emptyView;
@property (nullable, nonatomic, strong) UIImageView   *lineView;

@property (nonatomic, assign) BOOL isSuccessfulToCallBack;

@end

@implementation MMCombinationFitlerView

- (nullable id)initWithItem:(nullable MMItem *)item{
    self = [super init];
    if (self) {
        self.item = item;
        self.selectedArray = [NSMutableArray array];
        [self updateSelectPath];
        
    }
    return self;
}


- (void)updateSelectPath
{
    [self.selectedArray removeAllObjects];
    //单选
    for (int i = 0; i < self.item.alternativeArray.count; i++) {
        MMAlternativeItem *alternativeItem = self.item.alternativeArray[i];
        [self.selectedArray addObject:[MMSelectedPath pathWithFirstPath:i isKindOfAlternative:YES isOn:alternativeItem.isSelected]];
    }
    //多层
    for (int i = 0; i < self.item.childrenNodes.count; i++) {
        MMItem *subItem = self.item.childrenNodes[i];
        for (int j = 0; j <subItem.childrenNodes.count; j++) {
            MMItem *secondItem = subItem.childrenNodes[j];
            if (secondItem.isSelected == YES){
                [self.selectedArray addObject: [MMSelectedPath pathWithFirstPath:i secondPath:j]];
            }
        }
    }
    
     self.temporaryArray= [[NSArray alloc] initWithArray:self.selectedArray copyItems:YES] ;
    
}
#pragma mark - Private Method

- (void)popupViewFromView:(nullable UIView*)superView completion:(void (^ __nullable)(void))completion{
    //UIView *rootView = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat top =  CGRectGetHeight(superView.frame);
    CGFloat maxHeight = kMMScreenHeigth - DistanceBeteewnPopupViewAndBottom - top - PopupViewTabBarHeight-DistanceBeteewnTopMargin-100;
    CGFloat resultHeight = MIN(maxHeight, self.item.layout.totalHeight);
    if (self.item.childrenNodes.count <= 0) {
        CGFloat  emptyViewHeight =  kMMFileterEmptyHeight;
        resultHeight = MAX(resultHeight, emptyViewHeight);
    }
       
    self.frame = CGRectMake(0, top, kMMScreenWidth, 0);
    [superView addSubview:self];
    
    
    //self.item.childrenNodes.count > 0
    if (self.item.childrenNodes.count == 0 && self.item.needEmptyView) {
        [self.mainTableView removeFromSuperview];
        [self creatEmptyView];
    }else{
        [_emptyView removeFromSuperview];
        _emptyView = nil;
        //addTableView
        self.mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.mainTableView.delegate = self;
        self.mainTableView.dataSource = self;
        self.mainTableView.tableHeaderView = [[UIView alloc] init];
        [self.mainTableView registerClass:[MMCombineCell class] forCellReuseIdentifier:MainCellID];
        [self.mainTableView setSeparatorColor:[UIColor clearColor]];
        [self addSubview:self.mainTableView];
    }

    //add shadowView
    self.shadowView.frame = CGRectMake(0, top, kMMScreenWidth, kMMScreenHeigth - top);
    self.shadowView.alpha = 0;
    self.shadowView.userInteractionEnabled = YES;
    [superView insertSubview:self.shadowView belowSubview:self];
    [self.shadowView addTarget:self action:@selector(emptyAction:) forControlEvents:UIControlEventAllEvents];
    [self.shadowView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(emptyAction:)]];
    self.bottomView.frame = CGRectMake(0, resultHeight, self.ff_width, 0);
  
    
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.frame = CGRectMake(0, top, kMMScreenWidth, resultHeight+PopupViewTabBarHeight);
        self.emptyView.frame = CGRectMake(0, 0, kMMScreenWidth, kMMFileterEmptyHeight);
        self.mainTableView.frame = CGRectMake(0, 0, kMMScreenWidth, resultHeight);
        self.shadowView.alpha = ShadowAlpha;
        self.bottomView.frame = CGRectMake(0, resultHeight, self.ff_width, PopupViewTabBarHeight);
        [self bringSubviewToFront:self.bottomView];
    } completion:^(BOOL finished) {
        completion();
        [self addSubview:self.bottomView];
    }];

}

-(UIView*)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor ff_colorWithHex:0xffffff];
        
        UIImage *image =  [UIImage imageNamed:@"screen_line"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        UIImageView  *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, self.mainTableView.ff_width-30, 1)];
        lineView.image = image;
        [_bottomView addSubview:lineView];
        self.lineView = lineView;
        
       
        
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
            [_bottomView addSubview:button];
        }
    }
    if (self.item.childrenNodes.count == 0) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
    }
    
    return _bottomView;
}


/**
 只是为了滑动事件不被父view接受

 @param sender sender
 */
-(void)emptyAction:(id)sender
{
    [self dismissWithCompletion:nil];
}


- (void)dismissWithCompletion:(void (^ __nullable)(void))completion{
    [super dismissWithCompletion:completion];
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
    //消失的动画
    [UIView animateWithDuration:AnimationDuration animations:^{
        self.ff_height = 0;
        _emptyView.ff_height = 0;
        self.mainTableView.ff_height = 0;
    } completion:^(BOOL finished) {
        if (self.superview) {
            [self removeFromSuperview];
        }
        [self.emptyView removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(popupViewDidDismiss:)]) {
            [self.delegate popupViewDidDismiss:self];
        }
    }];
}

#pragma mark - Private Method
- (MMSelectedPath*)_iscontainsSelectedPath:(nullable MMSelectedPath *)path sourceArray:(nullable NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.firstPath == path.firstPath && selectedpath.secondPath == path.secondPath) return selectedpath;
    }
    return nil;
}

- (nullable MMSelectedPath *)_removePath:(nullable MMSelectedPath *)path sourceArray:(nullable NSMutableArray *)array {
    for (MMSelectedPath *selectedpath in array) {
        if (selectedpath.secondPath != -1) {
            if (selectedpath.firstPath == path.firstPath &&
                selectedpath.isKindOfAlternative == NO &&
                selectedpath.secondPath == path.secondPath) {
                MMSelectedPath *returnPath = selectedpath;
                [array removeObject:selectedpath];
                return returnPath;
            }
        }else{
            if (selectedpath.firstPath == path.firstPath && selectedpath.isKindOfAlternative == NO) {
                MMSelectedPath *returnPath = selectedpath;
                [array removeObject:selectedpath];
                return returnPath;
            }
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
            [self.selectedArray removeObject:path];
            i--;
        }
    }
    self.item.title = self.item.rootTitle;
    [self.mainTableView reloadData];
}

- (void)callBackDelegate {
    if ([self.delegate respondsToSelector:@selector(popupView:didSelectedItemsPackagingInArray:atIndex:)]) {
        self.isSuccessfulToCallBack = YES;
        
        [self.delegate popupView:self didSelectedItemsPackagingInArray:self.selectedArray  atIndex:self.tag];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissWithCompletion:nil];
            self.isSuccessfulToCallBack = NO;
        });
    }
}
#pragma mark - Action
- (void)respondsToButtonAction:(UIButton *)sender {
    if (sender.tag == 0) {//重置
        [self resetValue];
        if (self.item.filterNeedCall) {
             [self callBackDelegate]; 
        }
      
    } else if (sender.tag == 1) {//确定
        [self callBackDelegate];
    }
}

- (void)respondsToTapGestureRecognizer:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self dismissWithCompletion:nil];
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
        [self _removePath:[MMSelectedPath pathWithFirstPath:indexPath.row secondPath:index] sourceArray:self.selectedArray];
        self.item.childrenNodes[indexPath.row].childrenNodes[index].isSelected = NO;
        [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        return;
    } else {
        MMItem *item  = [self.item findItemBySelectedPath:[MMSelectedPath pathWithFirstPath:indexPath.row]];
        if(item.selectedType != MMPopupViewMultilSeMultiSelection) {
            for (MMSelectedPath *selectPath in self.selectedArray) {
                if (selectPath.firstPath == indexPath.row) {
                    MMSelectedPath *removeIndexPath = [self _removePath:selectPath sourceArray:self.selectedArray];
                    self.item.childrenNodes[removeIndexPath.firstPath].childrenNodes[removeIndexPath.secondPath].isSelected = NO;
                    break;
                }
            }
        }
      
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

#pragma mark - empty
- (void)creatEmptyView
{
    [self addSubview:self.emptyView];
    self.lineView.hidden = YES;
    self.emptyView.frame = CGRectMake(0, 0, self.ff_width, 0);
    self.emptyView.clipsToBounds = YES;
}

- (UIView*)emptyView
{
    if (_emptyView == nil) {
        _emptyView = [[UIView alloc] initWithFrame:CGRectMake(0,0,CGRectGetWidth(self.frame), kMMFileterEmptyHeight)];
        _emptyView.backgroundColor = RGBCodeColor(0xF3F3F3);
        
        //111*165
        UIImageView *iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 39, 111, 165)];
        iconImage.image = [UIImage imageNamed:@"icon_notFound"];
        [_emptyView addSubview:iconImage];
        
        UILabel  *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iconImage.frame)+25, CGRectGetWidth(self.frame), 21)];
        [labelTitle setBackgroundColor:[UIColor clearColor]];
        [labelTitle setText:@"没有更多筛选项"];
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        [labelTitle setTextColor:RGBCodeColor(0x333333)];
        [labelTitle setFont:Pixel30];
        [_emptyView addSubview:labelTitle];
        
        
        UILabel  *labelSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(labelTitle.frame)+10, CGRectGetWidth(self.frame), 21)];
        [labelSubTitle setBackgroundColor:[UIColor clearColor]];
        [labelSubTitle setText:@"您可选择其他分类或者更换关键字试试"];
        [labelSubTitle setTextAlignment:NSTextAlignmentCenter];
        [labelSubTitle setTextColor:RGBCodeColor(0x999999)];
        [labelSubTitle setFont:Pixel24];
        [_emptyView addSubview:labelSubTitle];
        
        [iconImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(39);
            make.width.mas_equalTo(111);
            make.height.mas_equalTo(165);
            make.centerX.mas_equalTo(0);
        }];
        [labelTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(39+165+35);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        
        [labelSubTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(39+165+35+21+10);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo(21);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
        }];
        [_emptyView addSubview:labelSubTitle];
    }
    
    return _emptyView;
    
}

@end
