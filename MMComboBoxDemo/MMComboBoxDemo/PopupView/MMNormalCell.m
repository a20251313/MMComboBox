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
@property (nonatomic, strong) UIImageView  *screenLineView;

@end

@implementation MMNormalCell



- (UIImageView*)screenLineView
{
    if (_screenLineView == nil) {
        _screenLineView = [[UIImageView alloc] initWithFrame:CGRectZero];
        UIImage *image =  [UIImage imageNamed:@"screen_line"];
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeTile];
        self.screenLineView.image = image;
        [self addSubview:_screenLineView];
    }
    
    return _screenLineView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    
    self.selectedImageview.frame = CGRectMake(self.ff_width-horizontalMargin-16, (self.ff_height -16)/2, 16, 16);
    self.title.frame = CGRectMake(10, 0, 140, self.ff_height);
    if (_item.subTitle != nil) {
        self.subTitle.frame = CGRectMake(self.ff_width - horizontalMargin - 80 , 0, 80, self.ff_height);
    }
    self.screenLineView.frame = CGRectMake(10, self.ff_height-2, self.ff_width, 1);
    
   
    
}

- (void)setItem:(MMItem *)item{
    _item = item;
    self.title.text = item.title;
    
    if (self.item.displayType == MMPopupViewDisplayTypeNormalCheck) {
        self.title.textColor = item.isSelected?[UIColor ff_colorWithHexString:@"2bbfff"]:[UIColor ff_colorWithHexString:@"333333"];
        self.backgroundColor = item.isSelected?[UIColor ff_colorWithHexString:@"ffffff"]:[UIColor whiteColor];
//        self.screenLineView.lineColor = item.isSelected?[UIColor ff_colorWithHexString:@"2bbfff"]:[UIColor ff_colorWithHexString:@"333333"];
        self.selectedImageview.hidden = !item.isSelected;
    }else if (self.item.displayType == MMPopupViewDisplayTypeNormal)
    {
        self.title.textColor = item.isSelected?[UIColor whiteColor]:[UIColor ff_colorWithHexString:@"333333"];
        self.backgroundColor = item.isSelected?[UIColor ff_colorWithHexString:@"2bbfff"]:[UIColor whiteColor];
        self.selectedImageview.hidden = YES;
//        self.waveLineView.lineColor = item.isSelected?[UIColor ff_colorWithHexString:@"2bbfff"]:[UIColor ff_colorWithHexString:@"333333"];
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
        _selectedImageview = [[UIImageView alloc] initWithImage:[UIImage rightImageWithColor:[UIColor ff_colorWithHexString:@"#2bbfff"] size:16]];
        [self addSubview:_selectedImageview];
    }
    return _selectedImageview;
}



+ (CGFloat)normalCellHeight:(MMItem*)item
{
    return 45;
}
@end