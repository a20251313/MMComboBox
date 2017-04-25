//
//  MMCombineCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/19.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMCombineCell.h"

@interface MMCombineCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) UILabel *openLabel;

@end

@implementation MMCombineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)setItem:(MMItem *)item {
    _item = item;
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    self.titleLabel.text = item.title;
    if (self.titleLabel.superview == nil) {
        [self addSubview:self.titleLabel];
    }
    
    for (int i = 0; i < item.childrenNodes.count; i ++) {
        if (i >= 4 && !item.isOpen) {
            break;
        }
        MMItem *subItem = item.childrenNodes[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat orginX = [item.layout.cellLayoutTotalInfo[i][0] floatValue];
        CGFloat orginy = [item.layout.cellLayoutTotalInfo[i][1] floatValue];
        button.frame = CGRectMake(orginX, orginy, [MMLayout layoutItemWidth], ItemHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
        if (item.showTail) {
            button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        }else{
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
        }
     
        button.layer.borderWidth = 1;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 15;
        button.tag = i;
        button.layer.borderColor = subItem.isSelected?[UIColor ff_colorWithHex:0x2bbfff].CGColor:[UIColor ff_colorWithHex:0x333333].CGColor;
        [button setTitle:subItem.title forState:UIControlStateNormal];
        [button setTitleColor:subItem.isSelected?[UIColor ff_colorWithHex:0xffffff]:[UIColor ff_colorWithHex:0x333333] forState:UIControlStateNormal];
        button.backgroundColor = subItem.isSelected?[UIColor ff_colorWithHex:0x2bbfff]:[UIColor whiteColor];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
        [button addTarget:self action:@selector(respondsToButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    //layout
    self.titleLabel.frame = CGRectMake(ItemHorizontalMargin, TitleVerticalMargin, self.ff_width - ItemHorizontalMargin-100, TitleHeight);
    
    self.openLabel.hidden = !self.item.hasAllFuntion;
    if (item.hasAllFuntion) {
        self.openLabel.text = [self textValue:item.isOpen];
        self.openLabel.textColor = item.isOpen ? [UIColor ff_colorWithHex:0x2bbfff]:[UIColor ff_colorWithHex:0x333333];
        [self addSubview:self.openLabel];
        self.openLabel.frame = CGRectMake(self.ff_width-70, 10, 60, 30);
        
    }
    //未超过一列，收起，全部按钮隐藏
    if (item.childrenNodes.count > 4) {
        self.openLabel.hidden = NO;
    }else{
        self.openLabel.hidden = YES;
    }
}
#pragma mark - action
- (void)respondsToButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(combineCell:didSelectedAtIndex:)]) {
        [self.delegate combineCell:self didSelectedAtIndex:sender.tag];
    }
}

- (void)clickOpen:(UITapGestureRecognizer*)sender
{
    self.item.isOpen = !self.item.isOpen;
    
    if ([self.delegate respondsToSelector:@selector(combineCellDidClickOpen:)]) {
        [self.delegate combineCellDidClickOpen:self];
    }
    
}
#pragma mark - get
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        self.titleLabel.textColor = [UIColor ff_colorWithHex:0x333333];
        _titleLabel.font = [UIFont systemFontOfSize:ButtonFontSize];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel*)openLabel
{
    if (_openLabel == nil) {
        _openLabel = [[UILabel alloc] init];
        _openLabel.backgroundColor = [UIColor clearColor];
        _openLabel.font = kICONFONT(ButtonFontSize);
        _openLabel.textColor = [UIColor ff_colorWithHex:0x333333];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOpen:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        _openLabel.userInteractionEnabled = YES;
        [_openLabel addGestureRecognizer:tap];
        [self addSubview:_openLabel];
    }
    return _openLabel;
}

- (NSString*)textValue:(BOOL)isOpen
{
    NSString  *strText = nil;
    if (isOpen) {//kUpArrowIcon
        strText = [NSString stringWithFormat:@"%@ %@",@"收起",kUpArrowIcon];
    }else{
        strText = [NSString stringWithFormat:@"%@ %@",@"全部",kDownArrowIcon];
    }
    return strText;
}


+ (CGFloat)combineCellHeight:(MMItem*)item
{
    return 44;
}
@end
