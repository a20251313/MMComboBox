//
//  MMNormalCell.m
//  MMComboBoxDemo
//
//  Created by wyy on 2016/12/8.
//  Copyright © 2016年 wyy. All rights reserved.
//

#import "MMNormalCell.h"
#import "MMHeader.h"
#import "UIImage+CommonImage.h"

static const CGFloat horizontalMargin = 10.0f;

@interface MMNormalCell ()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *subTitle;
@property (nonatomic, strong) UIImageView *selectedImageview;
@property (nonatomic, strong) CALayer *bottomLine;
@end

@implementation MMNormalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.selectedImageview.frame = CGRectMake(self.width-horizontalMargin-16, (self.height -16)/2, 16, 16);
    self.title.frame = CGRectMake(20, 0, 120, self.height);
    if (_item.subTitle != nil) {
        self.subTitle.frame = CGRectMake(self.width - horizontalMargin - 80 , 0, 80, self.height);
    }
    self.bottomLine.frame = CGRectMake(20, self.height - 1.0 , self.width-20, 1.0);
}

- (void)setItem:(MMItem *)item{
    _item = item;
    self.title.text = item.title;
    
    if (self.item.displayType == MMPopupViewDisplayTypeNormalCheck) {
        self.title.textColor = item.isSelected?[UIColor colorWithHexString:@"2bbfff"]:[UIColor colorWithHexString:@"333333"];
        self.backgroundColor = item.isSelected?[UIColor colorWithHexString:@"ffffff"]:[UIColor whiteColor];
        self.bottomLine.backgroundColor = item.isSelected?[UIColor colorWithHexString:@"2bbfff"].CGColor:[UIColor colorWithHexString:@"333333"].CGColor;
        self.selectedImageview.hidden = !item.isSelected;
    }else if (self.item.displayType == MMPopupViewDisplayTypeNormal)
    {
        self.title.textColor = item.isSelected?[UIColor whiteColor]:[UIColor colorWithHexString:@"333333"];
        self.backgroundColor = item.isSelected?[UIColor colorWithHexString:@"2bbfff"]:[UIColor whiteColor];
        self.selectedImageview.hidden = YES;
    }
 
    if (item.subTitle != nil) {
    self.subTitle.text  = item.subTitle;
    }
  
}
#pragma mark - get
- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor blackColor];
        _title.font = [UIFont systemFontOfSize:MainTitleFontSize];
        [self addSubview:_title];
    }
    return _title;
}

- (UILabel *)subTitle {
    if (!_subTitle) {
        _subTitle = [[UILabel alloc] init];
        _subTitle.textColor = [UIColor blackColor];
        _subTitle.textAlignment = NSTextAlignmentRight;
        _subTitle.font = [UIFont systemFontOfSize:SubTitleFontSize];
        [self addSubview:_subTitle];
    }
    return _subTitle;
}

- (UIImageView *)selectedImageview {
    
    if (!_selectedImageview) {
        _selectedImageview = [[UIImageView alloc] initWithImage:[UIImage rightImageWithColor:[UIColor colorWithHexString:@"#2bbfff"] size:16]];
        [self addSubview:_selectedImageview];
    }
    return _selectedImageview;
}

- (CALayer *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"333333"].CGColor;
        [self.layer addSublayer:_bottomLine];
    }
    return _bottomLine;
}
@end
